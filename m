Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933002Ab1EaX5G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 19:57:06 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:65133 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932946Ab1EaX5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 19:57:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=ZimazJpvHMQWwF9BXPADiW90wZvmfVBVg4lbsOhfxtdAetcmiQ3M1/ipceDEaUmfpi
         cE4/fBFFH1SLsZ3EZJKeIOQEbu60CL7NyBtXAYBm58PTahBWwMB9fSBFZDLY2/PhnNDg
         mbsIZApaF5c2rMC5xZks5vz0C56QisahuAtlU=
Message-ID: <4DE5804C.2050609@gmail.com>
Date: Wed, 01 Jun 2011 01:57:00 +0200
From: Maarten Lankhorst <m.b.lankhorst@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110419 Thunderbird/3.1.9
MIME-Version: 1.0
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
CC: "Xu, Andiry" <Andiry.Xu@amd.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RFC] usb: Do not attempt to reset the device while it
 is disabled
References: <1306749406-21124-1-git-send-email-m.b.lankhorst@gmail.com> <2DEEA3AB13739D45A22ADDB5086AEA0B016C1261@sshaexmb1.amd.com> <4DE4F166.8020207@gmail.com> <20110531171446.GB6776@xanatos> <4DE5283A.9070202@gmail.com> <20110531181848.GA6911@xanatos> <4DE53C74.2080700@gmail.com> <20110531223502.GA8550@xanatos>
In-Reply-To: <20110531223502.GA8550@xanatos>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 01-06-11 00:35, Sarah Sharp schreef:
> On Tue, May 31, 2011 at 09:07:32PM +0200, Maarten Lankhorst wrote:
>> Op 31-05-11 20:18, Sarah Sharp schreef:
>>> On Tue, May 31, 2011 at 07:41:14PM +0200, Maarten Lankhorst wrote:
>> My xhci controller is this one:
>> 04:00.0 USB Controller: Device 1b6f:7023 (rev 01) (prog-if 30 [XHCI])
>> Subsystem: ASRock Incorporation Device 7023
> Ok, the PCI SIGG says that vendor ID is assigned to Etron.  Congrats,
> that's the first xHCI host controller I've seen from that company. :)
Hooray.
> Ok, so the xHCI driver does successfully get a slot from the host
> controller.
>
>> [  545.664041] xhci_hcd 0000:04:00.0: Allocating ring at ffff8801c7d7ccc0
>> [  545.664044] xhci_hcd 0000:04:00.0: Allocating priv segment structure at ffff8801e2e26c40
>> [  545.664047] xhci_hcd 0000:04:00.0: // Allocating segment at ffff8800bac3f800 (virtual) 0xbac3f800 (DMA)
>> [  545.664053] xhci_hcd 0000:04:00.0: Linking segment 0xbac3f800 to segment 0xbac3f800 (DMA)
>> [  545.664056] xhci_hcd 0000:04:00.0: Wrote link toggle flag to segment ffff8801e2e26c40 (virtual), 0xbac3f800 (DMA)
>> [  545.664059] xhci_hcd 0000:04:00.0: Set slot id 1 dcbaa entry ffff8800bac3e008 to 0xbac21000
>> [  545.664070] xhci_hcd 0000:04:00.0: `MEM_WRITE_DWORD(3'b000, 32'hffffc90001ce0420, 32'h2f1, 4'hf);
> But I don't see an Address Device command complete here.  The command
> submission probably caused that memory write, but there really should be
> more debugging here.  I'll have to look through the hub initialization
> and see if there is any error path that would make it skip setting the
> device address.
>
> Have you tried on Linux 3.0-rc1?
Same problem with 3.0rc1 it seems. Just look at hub_port_init, that appears to be where it's going wrong:

First it calls:
        retval = hub_port_reset(hub, port1, udev, delay);

Which does the device reset..

Then lower in that function:
                if (udev->wusb == 0) {
                        for (j = 0; j < SET_ADDRESS_TRIES; ++j) {
                                retval = hub_set_address(udev, devnum);
                                if (retval >= 0)
                                        break;
                                msleep(200);
                        }

It seems to me that is why I get the reset call failing BEFORE the address is set. However I'm unsure what
would be a proper fix for it would be.

~Maarten
