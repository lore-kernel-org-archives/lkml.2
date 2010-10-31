Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756776Ab0JaVvn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Oct 2010 17:51:43 -0400
Received: from slowhand.arndnet.de ([88.198.19.76]:59162 "EHLO mail.unitix.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752823Ab0JaVvl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Oct 2010 17:51:41 -0400
Message-ID: <4CCDE4EB.7060001@arndnet.de>
Date: Sun, 31 Oct 2010 22:51:39 +0100
From: Arnd Hannemann <arnd@arndnet.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.15) Gecko/20101027 Lightning/1.0b1 Thunderbird/3.0.10
MIME-Version: 1.0
To: Ohad Ben-Cohen <ohad@wizery.com>
CC: "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: regression: b43-sdio: probe of mmc0:0001:1 failed with error
 -16
References: <4CCDA454.708@arndnet.de> <AANLkTin80pwnb1DX8OdZK3Wgsq0nj==G9VM3pahsmo0U@mail.gmail.com>
In-Reply-To: <AANLkTin80pwnb1DX8OdZK3Wgsq0nj==G9VM3pahsmo0U@mail.gmail.com>
X-Enigmail-Version: 1.0.1
Content-Type: multipart/mixed;
 boundary="------------090604000406090506030406"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090604000406090506030406
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi Ohad,

Am 31.10.2010 20:14, schrieb Ohad Ben-Cohen:

> On Sun, Oct 31, 2010 at 7:16 PM, Arnd Hannemann <arnd@arndnet.de> wrote:
>> b43-sdio: probe of mmc0:0001:1 failed with error -16
> 
> It's exactly what Daniel is experiencing with the XO-1.5.
> 
> In Daniel's scenario, mmc_sdio_init_card() fails because
> mmc_send_relative_addr() returns -110.
> 
> Can you please check out if that's the same thing you have too ?

No, it seems to be the pm_runtime_get_sync in sdio_bus.c::sdio_bus_probe().

If I test with CONFIG_PM_RUNTIME=y and the attached modifications,
then I get this as output:

root@ap4evb:~# modprobe b43
[   29.859375] cfg80211: Calling CRDA to update world regulatory domain
[   30.226562] pm_runtime_get_sync: -16
[   30.234375] b43-sdio: probe of mmc0:0001:1 failed with error -16
[   30.242187] Broadcom 43xx driver loaded [ Features: LS, Firmware-ID: FW13 ]

If CONFIG_PM_RUNTIME is not set in .config, the problem goes away.

Regards,
Arnd


--------------090604000406090506030406
Content-Type: text/plain;
 name="diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="diff"

diff --git a/drivers/mmc/core/sd_ops.c b/drivers/mmc/core/sd_ops.c
index 797cdb5..57b6dd4 100644
--- a/drivers/mmc/core/sd_ops.c
+++ b/drivers/mmc/core/sd_ops.c
@@ -237,8 +237,10 @@ int mmc_send_relative_addr(struct mmc_host *host, unsigned int *rca)
 	cmd.flags = MMC_RSP_R6 | MMC_CMD_BCR;
 
 	err = mmc_wait_for_cmd(host, &cmd, MMC_CMD_RETRIES);
-	if (err)
+	if (err) {
+		printk(KERN_INFO "%s(): %d\n", __func__, err);
 		return err;
+	}
 
 	*rca = cmd.resp[0] >> 16;
 
diff --git a/drivers/mmc/core/sdio_bus.c b/drivers/mmc/core/sdio_bus.c
index 2716c7a..102c163 100644
--- a/drivers/mmc/core/sdio_bus.c
+++ b/drivers/mmc/core/sdio_bus.c
@@ -133,8 +133,10 @@ static int sdio_bus_probe(struct device *dev)
 	 * pm_runtime_get_noresume() in its remove routine.
 	 */
 	ret = pm_runtime_get_sync(dev);
-	if (ret < 0)
+	if (ret < 0) {
+		printk(KERN_INFO "pm_runtime_get_sync: %d\n", ret);
 		goto out;
+	}
 
 	/* Set the default block size so the driver is sure it's something
 	 * sensible. */

--------------090604000406090506030406--
