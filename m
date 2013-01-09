Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933209Ab3AIVpq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 16:45:46 -0500
Received: from mail.kernel.org ([198.145.19.201]:41734 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933106Ab3AIUhq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 15:37:46 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Takashi Iwai <tiwai@suse.de>
Subject: [ 020/123] ALSA: hda - Move runtime PM check to runtime_idle callback
Date: Wed,  9 Jan 2013 12:34:19 -0800
Message-Id: <20130109201501.095006832@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130109201458.392601412@linuxfoundation.org>
References: <20130109201458.392601412@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 6eb827d23577a4efec2b10a9c4cc9ded268a1d1c upstream.

The runtime_idle callback is the right place to check the suspend
capability, but currently we do it wrongly in the runtime_suspend
callback.  This leads to a kernel error message like:
   pci_pm_runtime_suspend(): azx_runtime_suspend+0x0/0x50 [snd_hda_intel] returns -11
and the runtime PM core would even repeat the attempts.

Reported-and-tested-by: Borislav Petkov <bp@alien8.de>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/hda_intel.c |   19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -2557,10 +2557,6 @@ static int azx_runtime_suspend(struct de
 	struct snd_card *card = dev_get_drvdata(dev);
 	struct azx *chip = card->private_data;
 
-	if (!power_save_controller ||
-	    !(chip->driver_caps & AZX_DCAPS_PM_RUNTIME))
-		return -EAGAIN;
-
 	azx_stop_chip(chip);
 	azx_clear_irq_pending(chip);
 	return 0;
@@ -2575,12 +2571,25 @@ static int azx_runtime_resume(struct dev
 	azx_init_chip(chip, 1);
 	return 0;
 }
+
+static int azx_runtime_idle(struct device *dev)
+{
+	struct snd_card *card = dev_get_drvdata(dev);
+	struct azx *chip = card->private_data;
+
+	if (!power_save_controller ||
+	    !(chip->driver_caps & AZX_DCAPS_PM_RUNTIME))
+		return -EBUSY;
+
+	return 0;
+}
+
 #endif /* CONFIG_PM_RUNTIME */
 
 #ifdef CONFIG_PM
 static const struct dev_pm_ops azx_pm = {
 	SET_SYSTEM_SLEEP_PM_OPS(azx_suspend, azx_resume)
-	SET_RUNTIME_PM_OPS(azx_runtime_suspend, azx_runtime_resume, NULL)
+	SET_RUNTIME_PM_OPS(azx_runtime_suspend, azx_runtime_resume, azx_runtime_idle)
 };
 
 #define AZX_PM_OPS	&azx_pm


