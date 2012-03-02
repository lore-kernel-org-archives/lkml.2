Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932317Ab2CBBEo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 20:04:44 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:50719 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756923Ab2CBBEm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 20:04:42 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of yhlu.kernel@gmail.com designates 10.52.33.169 as permitted sender) smtp.mail=yhlu.kernel@gmail.com; dkim=pass header.i=yhlu.kernel@gmail.com
MIME-Version: 1.0
In-Reply-To: <20120301201050.GC5155@xanatos>
References: <1330629843-6027-1-git-send-email-yinghai@kernel.org>
	<1330629843-6027-2-git-send-email-yinghai@kernel.org>
	<20120301201050.GC5155@xanatos>
Date: Thu, 1 Mar 2012 17:04:41 -0800
X-Google-Sender-Auth: Y5TStNm54BFIM4-ovQmfp9BVaps
Message-ID: <CAE9FiQWDwraftUnr8ryStOWX5XxXK6sBPS7fbbqD8bWWF_ASfg@mail.gmail.com>
Subject: Re: [RFC PATCH 2/3] usb, PCI: remove disable/enable device with
 non-xhci quirk
From: Yinghai Lu <yinghai@kernel.org>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, linux-usb@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 1, 2012 at 12:10 PM, Sarah Sharp
<sarah.a.sharp@linux.intel.com> wrote:
> On Thu, Mar 01, 2012 at 11:24:02AM -0800, Yinghai Lu wrote:
>> | commit cab928ee1f221c9cc48d6615070fefe2e444384a
>> |    USB: Fix handoff when BIOS disables host PCI device.
>>
>> mention only need to do disable/enable for xhci controller.
>>
>> So just remove that for non-xhci controller and restore old behavior for them.
>
> As I said, we do need to do the enable/disable for all USB hosts.  Jesse
> Barnes confirms that the PCI core doesn't do that for us, so we can't
> rely on the BIOS always enabling the PCI device.  I don't think we need
> this patch, because we should always be doing the enable/disable for all
> USB hosts.  We just never had a BIOS that caused this bug to be
> discovered until the xHCI BIOS for the Intel system in question.

ok

after
-DECLARE_PCI_FIXUP_FINAL(PCI_ANY_ID, PCI_ANY_ID,
                                                quirk_usb_early_handoff);
+DECLARE_PCI_FIXUP_CLASS_FINAL(PCI_ANY_ID, PCI_ANY_ID,
                        PCI_CLASS_SERIAL_USB, 8, quirk_usb_early_handoff);
in pci-next get merged,

how about following change ?

Index: linux-2.6/drivers/usb/host/pci-quirks.c
===================================================================
--- linux-2.6.orig/drivers/usb/host/pci-quirks.c
+++ linux-2.6/drivers/usb/host/pci-quirks.c
@@ -891,11 +891,6 @@ static void __devinit quirk_usb_early_ha
 	 */
 	if (pdev->vendor == 0x184e)	/* vendor Netlogic */
 		return;
-	if (pdev->class != PCI_CLASS_SERIAL_USB_UHCI &&
-			pdev->class != PCI_CLASS_SERIAL_USB_OHCI &&
-			pdev->class != PCI_CLASS_SERIAL_USB_EHCI &&
-			pdev->class != PCI_CLASS_SERIAL_USB_XHCI)
-		return;

 	if (pci_enable_device(pdev) < 0) {
 		dev_warn(&pdev->dev, "Can't enable PCI device, "
