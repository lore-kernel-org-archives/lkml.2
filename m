Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753394Ab2A0WtJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 17:49:09 -0500
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:51099 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752378Ab2A0WtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 17:49:07 -0500
Message-ID: <4F233777.5040708@xenotime.net>
Date: Fri, 27 Jan 2012 15:47:03 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        linux-usb <linux-usb@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -next] uwb & wusb & usb wireless controllers: fix kconfig
 error & build errors
References: <20120125141938.c1a9460d56948e1c7b26d3f8@canb.auug.org.au> <4F20798C.4040205@xenotime.net>
In-Reply-To: <4F20798C.4040205@xenotime.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/25/2012 01:52 PM, Randy Dunlap wrote:
> From: Randy Dunlap <rdunlap@xenotime.net>
> 
> Fix UWB/WUSB kconfig error by changing 'select' to 'depends on'.
> 
> drivers/usb/wusbcore/Kconfig:4:error: recursive dependency detected!
> drivers/usb/wusbcore/Kconfig:4:	symbol USB_WUSB is selected by USB_HWA_HCD
> drivers/usb/host/Kconfig:559:	symbol USB_HWA_HCD depends on UWB
> drivers/uwb/Kconfig:5:	symbol UWB is selected by USB_WUSB
> 
> Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
> ---
>  drivers/usb/wusbcore/Kconfig |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- linux-next-20120125.orig/drivers/usb/wusbcore/Kconfig
> +++ linux-next-20120125/drivers/usb/wusbcore/Kconfig
> @@ -6,7 +6,7 @@ config USB_WUSB
>  	depends on EXPERIMENTAL
>  	depends on USB
>  	depends on PCI
> -        select UWB
> +	depends on UWB
>          select CRYPTO
>          select CRYPTO_BLKCIPHER
>          select CRYPTO_CBC
> 


Ugh, I should have seen this earlier.

Greg, the patch above is not sufficient -- it causes build errors in linux-next.

Please apply the patch below also.
---

From: Randy Dunlap <rdunlap@xenotime.net>

Fix kconfig warnings and build errors in UWB/WUSB/USB_HWA etc.
by making all of these related symbols depend on UWB.

warning: (USB_WHCI_HCD && USB_HWA_HCD) selects USB_WUSB which has unmet direct dependencies (USB_SUPPORT && EXPERIMENTAL && USB && PCI && UWB)
warning: (USB_HWA_HCD) selects UWB_HWA which has unmet direct dependencies (UWB && USB)

which lead to:

ERROR: "uwb_rsv_establish" [drivers/usb/wusbcore/wusbcore.ko] undefined!
ERROR: "uwb_pal_register" [drivers/usb/wusbcore/wusbcore.ko] undefined!
ERROR: "uwb_rsv_get_usable_mas" [drivers/usb/wusbcore/wusbcore.ko] undefined!
ERROR: "uwb_rsv_destroy" [drivers/usb/wusbcore/wusbcore.ko] undefined!
ERROR: "uwb_radio_stop" [drivers/usb/wusbcore/wusbcore.ko] undefined!
ERROR: "uwb_rsv_terminate" [drivers/usb/wusbcore/wusbcore.ko] undefined!
ERROR: "uwb_pal_unregister" [drivers/usb/wusbcore/wusbcore.ko] undefined!
ERROR: "uwb_pal_init" [drivers/usb/wusbcore/wusbcore.ko] undefined!
ERROR: "uwb_rc_reset_all" [drivers/usb/wusbcore/wusbcore.ko] undefined!
ERROR: "uwb_radio_start" [drivers/usb/wusbcore/wusbcore.ko] undefined!
ERROR: "uwb_rsv_create" [drivers/usb/wusbcore/wusbcore.ko] undefined!
ERROR: "uwb_rc_put" [drivers/usb/host/whci/whci-hcd.ko] undefined!
ERROR: "uwb_rc_get_by_grandpa" [drivers/usb/host/whci/whci-hcd.ko] undefined!
ERROR: "__umc_driver_register" [drivers/usb/host/whci/whci-hcd.ko] undefined!
ERROR: "umc_driver_unregister" [drivers/usb/host/whci/whci-hcd.ko] undefined!
ERROR: "whci_wait_for" [drivers/usb/host/whci/whci-hcd.ko] undefined!
ERROR: "uwb_rc_get_by_grandpa" [drivers/usb/host/hwa-hc.ko] undefined!
ERROR: "uwb_rc_put" [drivers/usb/host/hwa-hc.ko] undefined!

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
---
 drivers/usb/host/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-next-20120127.orig/drivers/usb/host/Kconfig
+++ linux-next-20120127/drivers/usb/host/Kconfig
@@ -546,7 +546,7 @@ config USB_RENESAS_USBHS_HCD
 config USB_WHCI_HCD
 	tristate "Wireless USB Host Controller Interface (WHCI) driver (EXPERIMENTAL)"
 	depends on EXPERIMENTAL
-	depends on PCI && USB
+	depends on PCI && USB && UWB
 	select USB_WUSB
 	select UWB_WHCI
 	help
@@ -559,7 +559,7 @@ config USB_WHCI_HCD
 config USB_HWA_HCD
 	tristate "Host Wire Adapter (HWA) driver (EXPERIMENTAL)"
 	depends on EXPERIMENTAL
-	depends on USB
+	depends on USB && UWB
 	select USB_WUSB
 	select UWB_HWA
 	help
