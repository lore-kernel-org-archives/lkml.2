Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751644Ab0GCVUW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jul 2010 17:20:22 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:64530 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941Ab0GCVUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jul 2010 17:20:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=AGW0d2FBSXtTyehJgkjUGybIAwa3U3XVS1C79kaLzRRhpnoHqKZRUr7VXa4iabw5nk
         7+3hRqSEaVV+4I+6ZnC21CDX1lJvhSEbQJw1nOxKAIbOWmdLuzSvUYrz6mm8AJz6xZ1F
         SzUM2mRj5a3E/xj+hYZETqVe3XeinnVDCy7H4=
Date: Sat, 3 Jul 2010 14:20:15 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jerome Lacoste <jerome.lacoste@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: i8042 no mouse on resume. (i8042: failed to resume active
 multiplexor, mouse won't work.)
Message-ID: <20100703212015.GA32052@core.coreip.homeip.net>
References: <AANLkTilvxV18Qc2-34GtNmfAIvNL2dtEAPC3iPFNU2Pv@mail.gmail.com>
 <20100701162454.GD4152@core.coreip.homeip.net>
 <AANLkTikx8AxRdPoSbsym9rUiA11BbufqImcD2sg4f8Ds@mail.gmail.com>
 <AANLkTikmcaQSNNy6ZHMvEwBJVkWdyQ5KALR6832hUkjz@mail.gmail.com>
 <20100701224235.GA29504@core.coreip.homeip.net>
 <AANLkTilPJ6Vod4zU4gfOC3id-Cxy_Ho4I5lxMh5fLaCV@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTilPJ6Vod4zU4gfOC3id-Cxy_Ho4I5lxMh5fLaCV@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 03, 2010 at 10:26:13AM +0200, Jerome Lacoste wrote:
> On Fri, Jul 2, 2010 at 12:42 AM, Dmitry Torokhov
> <dmitry.torokhov@gmail.com> wrote:
> > On Fri, Jul 02, 2010 at 12:28:17AM +0200, Jerome Lacoste wrote:
> >> On Thu, Jul 1, 2010 at 11:19 PM, Jerome Lacoste
> >> <jerome.lacoste@gmail.com> wrote:
> >> > On Thu, Jul 1, 2010 at 6:24 PM, Dmitry Torokhov
> >> > <dmitry.torokhov@gmail.com> wrote:
> >> >> Hi Jerome,
> >> >>
> >> > [...]
> >> >>> * the hardware is a Lenovo 3000 N100
> >> >>
> >> >> We already trying to disable MUX mode on Lenovo 3000 N100, see
> >> >> drivers/input/serio/i8042-x86ia64io.h:
> >> >>
> [...]
> >> > System Information
> >> >        Manufacturer: LENOVO
> >> >        Product Name: 0768BKG
> >> >        Version: 3000 N100
> >> >
> >> > according to dmidecode
> >>
> >> Note: I will try the i8042.nomux option, but can't reboot until tomorrow.
> >
> > Could you please also try i8042.reset instead of i8042.nomux?
> 
> the i8042.reset works so far after 5 resumes.
> 
> Tested with: Linux expresso2 2.6.32-23-generic #37-Ubuntu SMP Fri Jun
> 11 07:54:58 UTC 2010 i686 GNU/Linux
> 
> Should I test something else ?
> 

Coudl you please try the patch below?

Thanks.

-- 
Dmitry


Input: i8042 - reset keyboard controller wehen resuming from S2R

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

Some laptops, such as Lenovo 3000 N100, require keyboard controller reset
in order to have touchpad operable after suspend to RAM. Even if box does
not need the reset it should be safe to do so, so instead of chasing
after misbehaving boxes and grow DMI tables. let's reset the controller
unconditionally.

Reported-by: Jerome Lacoste <jerome.lacoste@gmail.com>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/input/serio/i8042.c |   65 +++++++++++++++++++++++++++----------------
 1 files changed, 41 insertions(+), 24 deletions(-)


diff --git a/drivers/input/serio/i8042.c b/drivers/input/serio/i8042.c
index 6440a8f..258b98b 100644
--- a/drivers/input/serio/i8042.c
+++ b/drivers/input/serio/i8042.c
@@ -861,9 +861,6 @@ static int i8042_controller_selftest(void)
 	unsigned char param;
 	int i = 0;
 
-	if (!i8042_reset)
-		return 0;
-
 	/*
 	 * We try this 5 times; on some really fragile systems this does not
 	 * take the first time...
@@ -1020,7 +1017,8 @@ static void i8042_controller_reset(void)
  * Reset the controller if requested.
  */
 
-	i8042_controller_selftest();
+	if (i8042_reset)
+		i8042_controller_selftest();
 
 /*
  * Restore the original control register setting.
@@ -1094,23 +1092,11 @@ static void i8042_dritek_enable(void)
 #ifdef CONFIG_PM
 
 /*
- * Here we try to restore the original BIOS settings to avoid
- * upsetting it.
- */
-
-static int i8042_pm_reset(struct device *dev)
-{
-	i8042_controller_reset();
-
-	return 0;
-}
-
-/*
  * Here we try to reset everything back to a state we had
  * before suspending.
  */
 
-static int i8042_pm_restore(struct device *dev)
+static int i8042_controller_resume(bool force_reset)
 {
 	int error;
 
@@ -1118,9 +1104,11 @@ static int i8042_pm_restore(struct device *dev)
 	if (error)
 		return error;
 
-	error = i8042_controller_selftest();
-	if (error)
-		return error;
+	if (i8042_reset || force_reset) {
+		error = i8042_controller_selftest();
+		if (error)
+			return error;
+	}
 
 /*
  * Restore original CTR value and disable all ports
@@ -1162,6 +1150,28 @@ static int i8042_pm_restore(struct device *dev)
 	return 0;
 }
 
+/*
+ * Here we try to restore the original BIOS settings to avoid
+ * upsetting it.
+ */
+
+static int i8042_pm_reset(struct device *dev)
+{
+	i8042_controller_reset();
+
+	return 0;
+}
+
+static int i8042_pm_resume(struct device *dev)
+{
+	/*
+	 * On resume from S2R we always try to reset the controller
+	 * to bring it in a sane state. (In case of S2D we expect
+	 * BIOS to reset the controller for us.)
+	 */
+	return i8042_controller_resume(true);
+}
+
 static int i8042_pm_thaw(struct device *dev)
 {
 	i8042_interrupt(0, NULL);
@@ -1169,9 +1179,14 @@ static int i8042_pm_thaw(struct device *dev)
 	return 0;
 }
 
+static int i8042_pm_restore(struct device *dev)
+{
+	return i8042_controller_resume(false);
+}
+
 static const struct dev_pm_ops i8042_pm_ops = {
 	.suspend	= i8042_pm_reset,
-	.resume		= i8042_pm_restore,
+	.resume		= i8042_pm_resume,
 	.thaw		= i8042_pm_thaw,
 	.poweroff	= i8042_pm_reset,
 	.restore	= i8042_pm_restore,
@@ -1389,9 +1404,11 @@ static int __init i8042_probe(struct platform_device *dev)
 
 	i8042_platform_device = dev;
 
-	error = i8042_controller_selftest();
-	if (error)
-		return error;
+	if (i8042_reset) {
+		error = i8042_controller_selftest();
+		if (error)
+			return error;
+	}
 
 	error = i8042_controller_init();
 	if (error)
