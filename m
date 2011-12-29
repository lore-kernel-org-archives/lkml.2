Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751992Ab1L2Ead (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Dec 2011 23:30:33 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:39475 "EHLO
	TX2EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785Ab1L2Eab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Dec 2011 23:30:31 -0500
X-SpamScore: -18
X-BigFish: VPS-18(zzbb2dI9371I146fK1432N98dK4015Lzz1202hzzz2dh668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LWY76P-01-3QI-02
X-M-MSG: 
Message-ID: <4EFBECE1.2060001@amd.com>
Date: Thu, 29 Dec 2011 12:30:25 +0800
From: Andiry Xu <andiry.xu@amd.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.21) Gecko/20110831 Thunderbird/3.1.13
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        USB list <linux-usb@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, v4mp <gaigo88@hotmail.it>
Subject: Re: Question about error from xhci-hcd
References: <4EAC3C5C.5000209@lwfinger.net> <20111030050443.GC4535@xanatos> <4EB01904.10605@lwfinger.net> <4EC0DCD5.2010509@amd.com> <4EFB4429.4090002@lwfinger.net> <4EFBDF35.8000501@amd.com> <4EFBE4B2.5000801@lwfinger.net>
In-Reply-To: <4EFBE4B2.5000801@lwfinger.net>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 Dec 2011 04:30:24.0857 (UTC) FILETIME=[9582F490:01CCC5E2]
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/29/2011 11:55 AM, Larry Finger wrote:
> On 12/28/2011 09:32 PM, Andiry Xu wrote:
>>
>> Thanks for your test. However, I did not find anything abnormal
>> information in the dmesg, except for the dump, but it seems unrelated
>> with "no room on ring" error.
>>
>> The patch is supposed to print the ep ring when it encounters a "no room
>> on ring" error, but it's not triggered. I see you added some control
>> transfer prints in the dmesg, but it seems quite normal: note the
>> "Toggle cycle state for ring" info, it means the ring is looped
>> normally, and driver does not report any no room on ring error. Can it
>> be reproduced frequently or hard to trigger?
>>
>> The short transfer message is normal for control transfer too. Sarah has
>> posted some patches to remove the corresponding printk and downgrade the
>> debug warn level so people will not be scared.
> 
> The patch I added was as follows:
> 
> Index: compat-wireless-2011-10-28/drivers/usb/host/xhci-ring.c
> ===================================================================
> --- compat-wireless-2011-10-28.orig/drivers/usb/host/xhci-ring.c
> +++ compat-wireless-2011-10-28/drivers/usb/host/xhci-ring.c
> @@ -2462,9 +2462,15 @@ static int prepare_ring(struct xhci_hcd
>         }
>         if (!room_on_ring(xhci, ep_ring, num_trbs)) {
>                 /* FIXME allocate more room */
> -               xhci_err(xhci, "ERROR no room on ep ring\n");
> +               if (count++ < 25) {
> +                       xhci_err(xhci, "ERROR no room on ep ring\n");
> +                       xhci_err(xhci, "Event ring:\n");
> +                       xhci_debug_ring(xhci, xhci->event_ring);
> +                       xhci_err(xhci, "Endpoint ring:\n");
> +                       xhci_debug_ring(xhci, ep_ring);
> +                       if (count < 2)
> +                               dump_stack();
> +               }
>                 return -ENOMEM;
>         }
> 
> Count is a static int to limit the amount of output to help prevent
> wrapping of the dmesg buffer.
> 
> With the rtl8192cu driver, the "no room" message occurs repeatedly. A
> piece of the unrestrained log is as follows:
> 
> [  269.214841] xhci_hcd 0000:05:00.0: ERROR no room on ep ring
> [  269.214847] xhci_hcd 0000:05:00.0: ERROR no room on ep ring
> [  269.214853] xhci_hcd 0000:05:00.0: ERROR no room on ep ring
> [  269.214859] xhci_hcd 0000:05:00.0: ERROR no room on ep ring
> [  269.214865] xhci_hcd 0000:05:00.0: ERROR no room on ep ring
> [  269.214916] xhci_hcd 0000:05:00.0: ERROR no room on ep ring
> [  269.214926] xhci_hcd 0000:05:00.0: ERROR no room on ep ring
> [  269.214936] xhci_hcd 0000:05:00.0: ERROR no room on ep ring
> [  269.214945] xhci_hcd 0000:05:00.0: ERROR no room on ep ring
> [  269.214954] xhci_hcd 0000:05:00.0: ERROR no room on ep ring
> [  269.214964] xhci_hcd 0000:05:00.0: ERROR no room on ep ring
> [  269.214973] xhci_hcd 0000:05:00.0: ERROR no room on ep ring
> [  269.214981] xhci_hcd 0000:05:00.0: ERROR no room on ep ring
> [  269.214990] xhci_hcd 0000:05:00.0: ERROR no room on ep ring
> [  269.215000] xhci_hcd 0000:05:00.0: ERROR no room on ep ring
> [  269.215009] xhci_hcd 0000:05:00.0: ERROR no room on ep ring
> [  269.215018] xhci_hcd 0000:05:00.0: ERROR no room on ep ring
> [  269.215027] xhci_hcd 0000:05:00.0: ERROR no room on ep ring
> 
> If the ring appears to be normal, any idea why the error is being
> triggered?
> 
> Whatever the cause, the device fails, but works fine on a USB 2.0 port.
> If you have any other tests we could run, please let me know.
> 

That's the error I want to see, but I didn't find it in the dmesg you
posted. is it wrapped?

Anyway, please post the full dmesg with no room on ring error and the
dump of the ep ring and event ring (so the xhci_debug_ring() is
triggered in the patch), so we can see if the ring is mangled or there
is just too many transfers.

Another thing you can try is the andiry-ring-expansion branch on Sarah's
xhci git tree, check if there is still no room on ring error.

Thanks,
Andiry

