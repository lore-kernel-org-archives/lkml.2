Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755526Ab2BLQpp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Feb 2012 11:45:45 -0500
Received: from 50.23.254.54-static.reverse.softlayer.com ([50.23.254.54]:35163
	"EHLO softlayer.compulab.co.il" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754471Ab2BLQpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Feb 2012 11:45:43 -0500
Message-ID: <4F37ECC6.5060303@compulab.co.il>
Date: Sun, 12 Feb 2012 18:45:58 +0200
From: Denis Turischev <denis@compulab.co.il>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] gpio: optimise gpio functionality in gpio-sch.c
References: <4F37EBEC.8060209@compulab.co.il>
In-Reply-To: <4F37EBEC.8060209@compulab.co.il>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - softlayer.compulab.co.il
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

GPIO logic of core powered and resume powered gpios on Intel SCH/Tunnel Creek
is the same, make wrappers for them with appropriate base registers.

Signed-off-by: Denis Turischev <denis@compulab.co.il>
---
 drivers/gpio/gpio-sch.c |   84 +++++++++++++++++++++-------------------------
 1 files changed, 38 insertions(+), 46 deletions(-)

diff --git a/drivers/gpio/gpio-sch.c b/drivers/gpio/gpio-sch.c
index f287016..8377d28 100644
--- a/drivers/gpio/gpio-sch.c
+++ b/drivers/gpio/gpio-sch.c
@@ -41,14 +41,14 @@ static DEFINE_SPINLOCK(gpio_lock);
 
 static unsigned short gpio_ba;
 
-static int sch_gpio_core_direction_in(struct gpio_chip *gc, unsigned  gpio_num)
+static void sch_gpio_direction_in(unsigned ioreg, unsigned  gpio_num)
 {
 	u8 curr_dirs;
 	unsigned short offset, bit;
 
 	spin_lock(&gpio_lock);
 
-	offset = CGIO + gpio_num / 8;
+	offset = ioreg + gpio_num / 8;
 	bit = gpio_num % 8;
 
 	curr_dirs = inb(gpio_ba + offset);
@@ -57,29 +57,28 @@ static int sch_gpio_core_direction_in(struct gpio_chip *gc, unsigned  gpio_num)
 		outb(curr_dirs | (1 << bit), gpio_ba + offset);
 
 	spin_unlock(&gpio_lock);
-	return 0;
 }
 
-static int sch_gpio_core_get(struct gpio_chip *gc, unsigned gpio_num)
+static int sch_gpio_get(unsigned lvreg, unsigned gpio_num)
 {
 	int res;
 	unsigned short offset, bit;
 
-	offset = CGLV + gpio_num / 8;
+	offset = lvreg + gpio_num / 8;
 	bit = gpio_num % 8;
 
 	res = !!(inb(gpio_ba + offset) & (1 << bit));
 	return res;
 }
 
-static void sch_gpio_core_set(struct gpio_chip *gc, unsigned gpio_num, int val)
+static void sch_gpio_set(unsigned lvreg, unsigned gpio_num, int val)
 {
 	u8 curr_vals;
 	unsigned short offset, bit;
 
 	spin_lock(&gpio_lock);
 
-	offset = CGLV + gpio_num / 8;
+	offset = lvreg + gpio_num / 8;
 	bit = gpio_num % 8;
 
 	curr_vals = inb(gpio_ba + offset);
@@ -91,17 +90,14 @@ static void sch_gpio_core_set(struct gpio_chip *gc, unsigned gpio_num, int val)
 	spin_unlock(&gpio_lock);
 }
 
-static int sch_gpio_core_direction_out(struct gpio_chip *gc,
-					unsigned gpio_num, int val)
+static void sch_gpio_direction_out(unsigned ioreg, unsigned gpio_num)
 {
 	u8 curr_dirs;
 	unsigned short offset, bit;
 
-	sch_gpio_core_set(gc, gpio_num, val);
-
 	spin_lock(&gpio_lock);
 
-	offset = CGIO + gpio_num / 8;
+	offset = ioreg + gpio_num / 8;
 	bit = gpio_num % 8;
 
 	curr_dirs = inb(gpio_ba + offset);
@@ -109,6 +105,30 @@ static int sch_gpio_core_direction_out(struct gpio_chip *gc,
 		outb(curr_dirs & ~(1 << bit), gpio_ba + offset);
 
 	spin_unlock(&gpio_lock);
+}
+
+static int sch_gpio_core_direction_in(struct gpio_chip *gc, unsigned  gpio_num)
+{
+	sch_gpio_direction_in(CGIO, gpio_num);
+	return 0;
+}
+
+static int sch_gpio_core_get(struct gpio_chip *gc, unsigned gpio_num)
+{
+	return sch_gpio_get(CGLV, gpio_num);
+}
+
+static void sch_gpio_core_set(struct gpio_chip *gc, unsigned gpio_num, int val)
+{
+	sch_gpio_set(CGLV, gpio_num, val);
+}
+
+static int sch_gpio_core_direction_out(struct gpio_chip *gc,
+					unsigned gpio_num, int val)
+{
+	sch_gpio_direction_out(CGIO, gpio_num);
+	sch_gpio_set(CGLV, gpio_num, val);
+
 	return 0;
 }
 
@@ -122,57 +142,29 @@ static struct gpio_chip sch_gpio_core = {
 };
 
 static int sch_gpio_resume_direction_in(struct gpio_chip *gc,
-					unsigned gpio_num)
+					unsigned  gpio_num)
 {
-	u8 curr_dirs;
-
-	spin_lock(&gpio_lock);
-
-	curr_dirs = inb(gpio_ba + RGIO);
-
-	if (!(curr_dirs & (1 << gpio_num)))
-		outb(curr_dirs | (1 << gpio_num) , gpio_ba + RGIO);
-
-	spin_unlock(&gpio_lock);
+	sch_gpio_direction_in(RGIO, gpio_num);
 	return 0;
 }
 
 static int sch_gpio_resume_get(struct gpio_chip *gc, unsigned gpio_num)
 {
-	return !!(inb(gpio_ba + RGLV) & (1 << gpio_num));
+	return sch_gpio_get(RGLV, gpio_num);
 }
 
 static void sch_gpio_resume_set(struct gpio_chip *gc,
 				unsigned gpio_num, int val)
 {
-	u8 curr_vals;
-
-	spin_lock(&gpio_lock);
-
-	curr_vals = inb(gpio_ba + RGLV);
-
-	if (val)
-		outb(curr_vals | (1 << gpio_num), gpio_ba + RGLV);
-	else
-		outb((curr_vals & ~(1 << gpio_num)), gpio_ba + RGLV);
-
-	spin_unlock(&gpio_lock);
+	sch_gpio_set(RGLV, gpio_num, val);
 }
 
 static int sch_gpio_resume_direction_out(struct gpio_chip *gc,
 					unsigned gpio_num, int val)
 {
-	u8 curr_dirs;
-
-	sch_gpio_resume_set(gc, gpio_num, val);
-
-	spin_lock(&gpio_lock);
-
-	curr_dirs = inb(gpio_ba + RGIO);
-	if (curr_dirs & (1 << gpio_num))
-		outb(curr_dirs & ~(1 << gpio_num), gpio_ba + RGIO);
+	sch_gpio_direction_out(RGIO, gpio_num);
+	sch_gpio_set(RGLV, gpio_num, val);
 
-	spin_unlock(&gpio_lock);
 	return 0;
 }
 
-- 
1.7.5.4

