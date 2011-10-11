Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755613Ab1JKRHe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 13:07:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33723 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755591Ab1JKRHa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 13:07:30 -0400
X-Mailbox-Line: From gregkh@pistachio.kroah.org Tue Oct 11 10:57:10 2011
Message-Id: <20111011165710.136001599@pistachio.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 11 Oct 2011 10:55:22 -0600
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Takashi Iwai <tiwai@suse.de>, Eric Piel <eric.piel@tremplin-utc.net>,
        Samu Onkalo <samu.p.onkalo@nokia.com>, Andrew Morton <akpm@google.com>
Subject: [12/38] lis3: fix regression of HP DriveGuard with 8bit chip
In-Reply-To: <20111011165903.GA30976@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 05faadcf59507e8eea57ffbeea9cbb14c9a2ab3d upstream.

Commit 2a7fade7e03 ("hwmon: lis3: Power on corrections") caused a
regression on HP laptops with 8bit chip.  Writing CTRL2_BOOT_8B bit seems
clearing the BIOS setup, and no proper interrupt for DriveGuard will be
triggered any more.

Since the init code there is basically only for embedded devices, put a
pdata check so that the problematic initialization will be skipped for
hp_accel stuff.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Cc: Eric Piel <eric.piel@tremplin-utc.net>
Cc: Samu Onkalo <samu.p.onkalo@nokia.com>
Signed-off-by: Andrew Morton <akpm@google.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/misc/lis3lv02d/lis3lv02d.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/drivers/misc/lis3lv02d/lis3lv02d.c
+++ b/drivers/misc/lis3lv02d/lis3lv02d.c
@@ -375,12 +375,14 @@ void lis3lv02d_poweron(struct lis3lv02d
 	 *      both have been read. So the value read will always be correct.
 	 * Set BOOT bit to refresh factory tuning values.
 	 */
-	lis3->read(lis3, CTRL_REG2, &reg);
-	if (lis3->whoami ==  WAI_12B)
-		reg |= CTRL2_BDU | CTRL2_BOOT;
-	else
-		reg |= CTRL2_BOOT_8B;
-	lis3->write(lis3, CTRL_REG2, reg);
+	if (lis3->pdata) {
+		lis3->read(lis3, CTRL_REG2, &reg);
+		if (lis3->whoami ==  WAI_12B)
+			reg |= CTRL2_BDU | CTRL2_BOOT;
+		else
+			reg |= CTRL2_BOOT_8B;
+		lis3->write(lis3, CTRL_REG2, reg);
+	}
 
 	/* LIS3 power on delay is quite long */
 	msleep(lis3->pwron_delay / lis3lv02d_get_odr());


