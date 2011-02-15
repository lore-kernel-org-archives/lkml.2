Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755465Ab1BOSgi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 13:36:38 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36003 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994Ab1BOSge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 13:36:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=kVZXKCG2J6983V57qXOdyJwbO6NkYIQGCq5UGCXEMUi9b4VKMBrXhqFZpEgMJmr75o
         lkMCda+xueQEXHRnwLJ6im6Im5u4o++hbkRQoNEcbtNUjcAcLaXykXq3qthFC5XXtwsW
         5cR7Pp0dDweyIy3U+STPCbcXx5qb0cpc/hBTc=
Message-ID: <4D5AC7AC.2020702@gmail.com>
Date: Tue, 15 Feb 2011 19:36:28 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.13) Gecko/20101206 SUSE/3.1.7 Thunderbird/3.1.7
MIME-Version: 1.0
To: Amit Shah <amitshah@gmx.net>
CC: Sergei Shtylyov <sshtylyov@mvista.com>, Jiri Slaby <jslaby@suse.cz>,
        gregkh@suse.de, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] USB: serial/usb_wwan, fix tty NULL dereference
References: <1297781707-3985-1-git-send-email-jslaby@suse.cz> <4D5AB48A.2040504@ru.mvista.com> <20110215181045.GA12700@amit-x200.redhat.com>
In-Reply-To: <20110215181045.GA12700@amit-x200.redhat.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/15/2011 07:10 PM, Amit Shah wrote:
> On (Tue) 15 Feb 2011 [20:14:50], Sergei Shtylyov wrote:
>> Hello.
>>
>> Jiri Slaby wrote:
>>
>>> tty_port_tty_get may return without any problems NULL. Handle this
>>> case and do not oops in usb_wwan_indat_callback by dereferencing it.
> 
> Thanks for looking at this!
> 
>>> The oops:
>>> Unable to handle kernel paging request for data at address 0x000000d8
>>> Faulting instruction address: 0xc0175b3c
>>> Oops: Kernel access of bad area, sig: 11 [#1]
>>> PowerPC 40x Platform
>>> last sysfs file:
>>> /sys/devices/pci0000:00/0000:00:00.0/0000:01:00.0/0000:02:09.2/usb1/idVendor
>>> Modules linked in:
>>> NIP: c0175b3c LR: c0175e7c CTR: c0215c90
>>> REGS: c77f7d50 TRAP: 0300   Not tainted  (2.6.37-rc5)
>>> MSR: 00021030 <ME,CE,IR,DR>  CR: 88482028  XER: 2000005f
>>> DEAR: 000000d8, ESR: 00000000
>>> TASK = c7141b90[1149] 'wvdial' THREAD: c2750000
>>> GPR00: 00021030 c77f7e00 c7141b90 00000000 0000000e 00000000 0000000e c0410680
>>> GPR08: c683db00 00000000 00000001 c03c81f8 88482028 10073ef4 ffffffb9 ffffff94
>>> GPR16: 00000000 fde036c0 00200200 00100100 00000001 ffffff8d c34fabcc 00000000
>>> GPR24: c71120d4 00000000 00000000 0000000e 00021030 00000000 00000000 0000000e
>>> NIP [c0175b3c] tty_buffer_request_room+0x2c/0x194
>>> LR [c0175e7c] tty_insert_flip_string_fixed_flag+0x3c/0xb0
>>> Call Trace:
>>> [c77f7e00] [00000003] 0x3 (unreliable)
>>> [c77f7e30] [c0175e7c] tty_insert_flip_string_fixed_flag+0x3c/0xb0
>>> [c77f7e60] [c0215df4] usb_wwan_indat_callback+0x164/0x170
>>> ...
>>
>>> References: https://bugzilla.kernel.org/show_bug.cgi?id=24582
>>> Cc: Amit Shah <amitshah@gmx.net>
>>> Cc: baoyb <baoyb@avit.org.cn>
>>> Cc: Greg Kroah-Hartman <gregkh@suse.de>
>>> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
>>> ---
>>> drivers/usb/serial/usb_wwan.c |   15 +++++++++------
>>> 1 files changed, 9 insertions(+), 6 deletions(-)
>>
>>> diff --git a/drivers/usb/serial/usb_wwan.c b/drivers/usb/serial/usb_wwan.c
>>> index b004b2a..9c014e2 100644
>>> --- a/drivers/usb/serial/usb_wwan.c
>>> +++ b/drivers/usb/serial/usb_wwan.c
>>> @@ -295,12 +295,15 @@ static void usb_wwan_indat_callback(struct urb *urb)
>>> 		    __func__, status, endpoint);
>>> 	} else {
>>> 		tty = tty_port_tty_get(&port->port);
>>> -		if (urb->actual_length) {
>>> -			tty_insert_flip_string(tty, data, urb->actual_length);
>>> -			tty_flip_buffer_push(tty);
>>> -		} else
>>> -			dbg("%s: empty read urb received", __func__);
>>> -		tty_kref_put(tty);
>>> +		if (tty) {
>>> +			if (urb->actual_length) {
>>> +				tty_insert_flip_string(tty, data,
>>> +						urb->actual_length);
>>> +				tty_flip_buffer_push(tty);
>>> +			} else
>>> +				dbg("%s: empty read urb received", __func__);
>>
>>    Should be {} on the *else* branch too, according to Documentation/CodingStyle...
> 
> If you're fixing that, might as well return in the 'if' above

No, the urb has to be resubmitted.

regards,
-- 
js
