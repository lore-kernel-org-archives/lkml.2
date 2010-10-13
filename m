Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010Ab0JMMKt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 08:10:49 -0400
Received: from mail.perches.com ([173.55.12.10]:2842 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753808Ab0JMMKr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 08:10:47 -0400
Subject: [PATCH] sound/soc: rename vol to volatile_register as appropriate
From: Joe Perches <joe@perches.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Peter Hsiang <Peter.Hsiang@maxim-ic.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Liam Girdwood <lrg@slimlogic.co.uk>,
        Peter Ujfalusi <peter.ujfalusi@nokia.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jesse Marroquin <Jesse.Marroquin@maxim-ic.com>
In-Reply-To: <20101013082414.GD6424@rakim.wolfsonmicro.main>
References: <B2150E1E4418E1438554A300EA5040E40D469C124D@ITSVLEX06.it.maxim-ic.internal>
	 <B2150E1E4418E1438554A300EA5040E40D469C124F@ITSVLEX06.it.maxim-ic.internal>
	 <1286934472.1117.129.camel@Joe-Laptop>
	 <20101013082414.GD6424@rakim.wolfsonmicro.main>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 13 Oct 2010 05:10:45 -0700
Message-ID: <1286971846.1117.191.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename the declaration and uses of variables
named vol to volatile_register to avoid name
clash with the much more common use of vol
for volume.

Signed-off-by: Joe Perches <joe@perches.com>
---
On Wed, 2010-10-13 at 09:24 +0100, Mark Brown wrote:
> On Tue, Oct 12, 2010 at 06:47:52PM -0700, Joe Perches wrote:
> > On Tue, 2010-10-12 at 18:20 -0700, Peter Hsiang wrote:
> 
> > > +static struct {
> > > +       int readable;
> > > +       int writable;
> > > +       int vol;
> > > +} max98088_access[M98088_REG_CNT] = {
> 
> > bool instead?
> 
> > static struct {
> > 	bool readable;
> > 	bool writable,
> > 	bool vol;
> > } etc...
> 
> The readable and writable fields are being used as bitmasks:

No, they are being declared as bitmasks.
writable is used once as bool, readable isn't used at all.

> | +       { 0x1F, 0x1F, 1 }, /* 03 battery voltage */
> so this discards data which we may wish to use in future.

It's not used as bitmask now, what use would there
be in the future for it as a bitmask?

> > readable isn't used anywhere, writeable is used as bool
> > vol isn't a good name as it's easy to confuse with
> > volume.  Maybe volatile_register?
> 
> vol is traditionally used for this throughout the subsystem.  It's
> unfortuante that volatile is a keyword.

As far as I see, your description of vol being
used throughout the subsystem is not true.

vol is defined 3 times in sound/soc/codecs for
volatility, used twice, and there are about 500
uses in sound for vol as volume.

Here's a patch for the current defines and uses.

 sound/soc/codecs/wm8904.c |    4 ++--
 sound/soc/codecs/wm8962.c |    2 +-
 sound/soc/codecs/wm8962.h |    2 +-
 sound/soc/codecs/wm8994.c |    2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/sound/soc/codecs/wm8904.c b/sound/soc/codecs/wm8904.c
index 33be84e..18a6f5c 100644
--- a/sound/soc/codecs/wm8904.c
+++ b/sound/soc/codecs/wm8904.c
@@ -346,7 +346,7 @@ static const u16 wm8904_reg[WM8904_MAX_REGISTER + 1] = {
 static struct {
 	int readable;
 	int writable;
-	int vol;
+	bool volatile_register;
 } wm8904_access[] = {
 	{ 0xFFFF, 0xFFFF, 1 }, /* R0   - SW Reset and ID */
 	{ 0x0000, 0x0000, 0 }, /* R1   - Revision */
@@ -601,7 +601,7 @@ static struct {
 
 static int wm8904_volatile_register(unsigned int reg)
 {
-	return wm8904_access[reg].vol;
+	return wm8904_access[reg].volatile_register;
 }
 
 static int wm8904_reset(struct snd_soc_codec *codec)
diff --git a/sound/soc/codecs/wm8962.c b/sound/soc/codecs/wm8962.c
index 6d30f34..98ed910 100644
--- a/sound/soc/codecs/wm8962.c
+++ b/sound/soc/codecs/wm8962.c
@@ -108,7 +108,7 @@ WM8962_REGULATOR_EVENT(7)
 
 static int wm8962_volatile_register(unsigned int reg)
 {
-	if (wm8962_reg_access[reg].vol)
+	if (wm8962_reg_access[reg].volatile_register)
 		return 1;
 	else
 		return 0;
diff --git a/sound/soc/codecs/wm8962.h b/sound/soc/codecs/wm8962.h
index 2af6c93..070a4c9 100644
--- a/sound/soc/codecs/wm8962.h
+++ b/sound/soc/codecs/wm8962.h
@@ -3780,7 +3780,7 @@ extern const u16 wm8962_reg[WM8962_MAX_REGISTER + 1];
 struct wm8962_reg_access {
 	u16 read;
 	u16 write;
-	u16 vol;
+	bool volatile_register;
 };
 
 extern
diff --git a/sound/soc/codecs/wm8994.c b/sound/soc/codecs/wm8994.c
index 218bcd2..d46f661 100644
--- a/sound/soc/codecs/wm8994.c
+++ b/sound/soc/codecs/wm8994.c
@@ -101,7 +101,7 @@ struct wm8994_priv {
 static struct {
 	unsigned short  readable;   /* Mask of readable bits */
 	unsigned short  writable;   /* Mask of writable bits */
-	unsigned short  vol;        /* Mask of volatile bits */
+	unsigned short  volatile_register;    /* Mask of volatile bits */
 } access_masks[] = {
 	{ 0xFFFF, 0xFFFF, 0x0000 }, /* R0     - Software Reset */
 	{ 0x3B37, 0x3B37, 0x0000 }, /* R1     - Power Management (1) */


