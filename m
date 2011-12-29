Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753644Ab1L2Dzg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Dec 2011 22:55:36 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47494 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752334Ab1L2Dze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Dec 2011 22:55:34 -0500
Message-ID: <4EFBE4B2.5000801@lwfinger.net>
Date: Wed, 28 Dec 2011 21:55:30 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111220 Thunderbird/9.0
MIME-Version: 1.0
To: Andiry Xu <andiry.xu@amd.com>
CC: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        USB list <linux-usb@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, v4mp <gaigo88@hotmail.it>
Subject: Re: Question about error from xhci-hcd
References: <4EAC3C5C.5000209@lwfinger.net> <20111030050443.GC4535@xanatos> <4EB01904.10605@lwfinger.net> <4EC0DCD5.2010509@amd.com> <4EFB4429.4090002@lwfinger.net> <4EFBDF35.8000501@amd.com>
In-Reply-To: <4EFBDF35.8000501@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/28/2011 09:32 PM, Andiry Xu wrote:
>
> Thanks for your test. However, I did not find anything abnormal
> information in the dmesg, except for the dump, but it seems unrelated
> with "no room on ring" error.
>
> The patch is supposed to print the ep ring when it encounters a "no room
> on ring" error, but it's not triggered. I see you added some control
> transfer prints in the dmesg, but it seems quite normal: note the
> "Toggle cycle state for ring" info, it means the ring is looped
> normally, and driver does not report any no room on ring error. Can it
> be reproduced frequently or hard to trigger?
>
> The short transfer message is normal for control transfer too. Sarah has
> posted some patches to remove the corresponding printk and downgrade the
> debug warn level so people will not be scared.

The patch I added was as follows:

Index: compat-wireless-2011-10-28/drivers/usb/host/xhci-ring.c
===================================================================
--- compat-wireless-2011-10-28.orig/drivers/usb/host/xhci-ring.c
+++ compat-wireless-2011-10-28/drivers/usb/host/xhci-ring.c
@@ -2462,9 +2462,15 @@ static int prepare_ring(struct xhci_hcd
         }
         if (!room_on_ring(xhci, ep_ring, num_trbs)) {
                 /* FIXME allocate more room */
-               xhci_err(xhci, "ERROR no room on ep ring\n");
+               if (count++ < 25) {
+                       xhci_err(xhci, "ERROR no room on ep ring\n");
+                       xhci_err(xhci, "Event ring:\n");
+                       xhci_debug_ring(xhci, xhci->event_ring);
+                       xhci_err(xhci, "Endpoint ring:\n");
+                       xhci_debug_ring(xhci, ep_ring);
+                       if (count < 2)
+                               dump_stack();
+               }
                 return -ENOMEM;
         }

Count is a static int to limit the amount of output to help prevent wrapping of 
the dmesg buffer.

With the rtl8192cu driver, the "no room" message occurs repeatedly. A piece of 
the unrestrained log is as follows:

[  269.214841] xhci_hcd 0000:05:00.0: ERROR no room on ep ring
[  269.214847] xhci_hcd 0000:05:00.0: ERROR no room on ep ring
[  269.214853] xhci_hcd 0000:05:00.0: ERROR no room on ep ring
[  269.214859] xhci_hcd 0000:05:00.0: ERROR no room on ep ring
[  269.214865] xhci_hcd 0000:05:00.0: ERROR no room on ep ring
[  269.214916] xhci_hcd 0000:05:00.0: ERROR no room on ep ring
[  269.214926] xhci_hcd 0000:05:00.0: ERROR no room on ep ring
[  269.214936] xhci_hcd 0000:05:00.0: ERROR no room on ep ring
[  269.214945] xhci_hcd 0000:05:00.0: ERROR no room on ep ring
[  269.214954] xhci_hcd 0000:05:00.0: ERROR no room on ep ring
[  269.214964] xhci_hcd 0000:05:00.0: ERROR no room on ep ring
[  269.214973] xhci_hcd 0000:05:00.0: ERROR no room on ep ring
[  269.214981] xhci_hcd 0000:05:00.0: ERROR no room on ep ring
[  269.214990] xhci_hcd 0000:05:00.0: ERROR no room on ep ring
[  269.215000] xhci_hcd 0000:05:00.0: ERROR no room on ep ring
[  269.215009] xhci_hcd 0000:05:00.0: ERROR no room on ep ring
[  269.215018] xhci_hcd 0000:05:00.0: ERROR no room on ep ring
[  269.215027] xhci_hcd 0000:05:00.0: ERROR no room on ep ring

If the ring appears to be normal, any idea why the error is being triggered?

Whatever the cause, the device fails, but works fine on a USB 2.0 port. If you 
have any other tests we could run, please let me know.

Larry
