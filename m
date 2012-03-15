Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755543Ab2COGWD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 02:22:03 -0400
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:19582
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752840Ab2COGV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 02:21:58 -0400
X-SpamScore: -9
X-BigFish: VPS-9(zz9371I542M1432N4015Izz1202hzz8275bh8275dha509lz2dh668h839h93fhd25h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M0WXOI-01-23U-02
X-M-MSG: 
From: "Xu, Andiry" <Andiry.Xu@amd.com>
To: Alex Shi <alex.shi@intel.com>,
        "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>,
        gregkh <gregkh@linuxfoundation.org>
CC: "sarah.a.sharp@linux.intel.com" <sarah.a.sharp@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-usb <linux-usb@vger.kernel.org>
Subject: RE: [PATCH] usb/core: skip unnecessary line IRQ request for USB3
Thread-Topic: [PATCH] usb/core: skip unnecessary line IRQ request for USB3
Thread-Index: AQHNAmb/35FJtE2gW0mkSAvd2PFwkZZq4clw
Date: Thu, 15 Mar 2012 06:21:34 +0000
Message-ID: <2A76B9D36150BE4293842BC2FE8FF16503320F@SCYBEXDAG04.amd.com>
References: <1331786904.2979.64.camel@debian>
In-Reply-To: <1331786904.2979.64.camel@debian>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.237.72.81]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q2F6M74H001112

> -----Original Message-----
> From: linux-usb-owner@vger.kernel.org [mailto:linux-usb-
> owner@vger.kernel.org] On Behalf Of Alex Shi
> Sent: Thursday, March 15, 2012 12:48 PM
> To: stern@rowland.harvard.edu; gregkh
> Cc: sarah.a.sharp@linux.intel.com; linux-kernel@vger.kernel.org; linux-usb
> Subject: [PATCH] usb/core: skip unnecessary line IRQ request for USB3
> 
> 
> USB3 requests line IRQ here but will disable it
> in later driver->start function and try MSI first.
> 

You may also remove the unregister the legacy interrupt part in
xhci_try_enable_msi().

In fact, I think all the MSI related codes should be moved to xhci-pci.c,
Since MSI is PCI-only.

Thanks,
Andiry

> xhci_hcd 0000:02:00.0: irq 18, io mem 0xfe500000
> xhci_hcd 0000:02:00.0: irq 45 for MSI/MSI-X
> xhci_hcd 0000:02:00.0: irq 46 for MSI/MSI-X
> 
> So it is better to remove the redundant request here. And
> save a little time in booting.
> 
> Signed-off-by: Alex Shi <alex.shi@intel.com>
> ---
>  drivers/usb/core/hcd.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
> index e128232..5b09825 100644
> --- a/drivers/usb/core/hcd.c
> +++ b/drivers/usb/core/hcd.c
> @@ -2450,7 +2450,8 @@ int usb_add_hcd(struct usb_hcd *hcd,
>  	/* enable irqs just before we start the controller,
>  	 * if the BIOS provides legacy PCI irqs.
>  	 */
> -	if (usb_hcd_is_primary_hcd(hcd) && irqnum) {
> +	if (usb_hcd_is_primary_hcd(hcd) && irqnum
> +		&& (hcd->driver->flags & HCD_MASK) != HCD_USB3) {
>  		retval = usb_hcd_request_irqs(hcd, irqnum, irqflags);
>  		if (retval)
>  			goto err_request_irq;
> --
> 1.7.5.1
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
