Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932079Ab2DMICi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 04:02:38 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:34343 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754643Ab2DMICb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 04:02:31 -0400
Message-ID: <4F87DD92.4090601@suse.cz>
Date: Fri, 13 Apr 2012 10:02:26 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120404 Thunderbird/13.0a2
MIME-Version: 1.0
To: Michael Neuling <mikey@neuling.org>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>, linux-next@vger.kernel.org,
        Jiri Slaby <jirislaby@gmail.com>
Subject: Re: linux-next: boot failures with next-20120411
References: <20120411165835.415e546374a54ea94669b0c6@canb.auug.org.au> <16710.1334284211@neuling.org>
In-Reply-To: <16710.1334284211@neuling.org>
X-Enigmail-Version: 1.4
Content-Type: multipart/mixed;
 boundary="------------050407080301050201040708"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050407080301050201040708
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit

On 04/13/2012 04:30 AM, Michael Neuling wrote:
> Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> 
>> Hi all,
>>
>> Some (not all) of my PowerPC boot tests have failed like this after
>> getting into user mode (this one was just after udev started, but others
>> are after other processes getting going):
>>
>> Unable to handle kernel paging request for data at address 0xc0000003f9d550
>> Faulting instruction address: 0xc0000000001b7f40
>> Oops: Kernel access of bad area, sig: 11 [#1]
>> SMP NR_CPUS=32 NUMA pSeries
>> Modules linked in: ehea
>> NIP: c0000000001b7f40 LR: c0000000001b7f14 CTR: c0000000000e04f0
>> REGS: c0000003f68bf6b0 TRAP: 0300   Not tainted  (3.4.0-rc2-autokern1)
>> MSR: 800000000280b032 <SF,VEC,VSX,EE,FP,ME,IR,DR,RI>  CR: 24422424  XER: 20000001
>> SOFTE: 1
>> CFAR: 000000000000562c
>> DAR: 00c0000003f9d550, DSISR: 40000000
>> TASK = c0000003f8818000[3192] 'kdump' THREAD: c0000003f68bc000 CPU: 5
>> GPR00: 0000000000000000 c0000003f68bf930 c000000000ce1d40 c0000003fe00ec00 
>> GPR04: 00000000000002d0 0000000000000038 c0000003f8f935e8 c000000000e55280 
>> GPR08: 0000000000000011 c000000000bcb280 c000000000bcb1e8 000000000028a000 
>> GPR12: 0000000024422424 c00000000f33bc80 00000fffdd90a770 0000000000081000 
>> GPR16: c0000003f846c000 000000000de4f7a0 f00000000de4f7a0 0000000000000000 
>> GPR20: c0000003f8365408 c0000003f8365480 c0000003f8e5d110 0000000000000000 
>> GPR24: 0000000000000100 c0000003f8365400 c0000000001e5424 00000000000002d0 
>> GPR28: 0000000000000800 00c0000003f9d550 c000000000c5b718 c0000003fe00ec00 
>> NIP [c0000000001b7f40] .__kmalloc+0x70/0x230
>> LR [c0000000001b7f14] .__kmalloc+0x44/0x230
>> Call Trace:
>> [c0000003f68bf930] [c0000003f68bf9b0] 0xc0000003f68bf9b0 (unreliable)
>> [c0000003f68bf9e0] [c0000000001e5424] .alloc_fdmem+0x24/0x70
>> [c0000003f68bfa60] [c0000000001e54f8] .alloc_fdtable+0x88/0x130
>> [c0000003f68bfaf0] [c0000000001e5924] .dup_fd+0x384/0x450
>> [c0000003f68bfbd0] [c00000000009a310] .copy_process+0x880/0x11d0
>> [c0000003f68bfcd0] [c00000000009aee0] .do_fork+0x70/0x400
>> [c0000003f68bfdc0] [c0000000000141c4] .sys_clone+0x54/0x70
>> [c0000003f68bfe30] [c000000000009aa0] .ppc_clone+0x8/0xc
>> Instruction dump:
>> 4bff9281 2ba30010 7c7f1b78 40dd00f4 e96d0040 e93f0000 7ce95a14 e9070008 
>> 7fa9582a 2fbd0000 41de0054 e81f0022 <7f3d002a> 38000000 886d01f2 980d01f2 
>> ---[ end trace 366fe6c7ced3bfb0 ]---
>>
>> This did not happen yesterday.  Just wondering if anyone can think of
>> anything obvious.  Full console log at
>> http://ozlabs.org/~sfr/next-20120411.log.bz2
> 
> I managed to bisect this down using pseries_defconfig with next-20120412
> to this patch:
> 
>   commit 85bbc003b24335e253a392f6a9874103b77abb36
>   Author: Jiri Slaby <jslaby@suse.cz>
>   Date:   Mon Apr 2 13:54:22 2012 +0200
> 
>       TTY: HVC, use tty from tty_port
> 
>       The driver already used refcounting. So we just switch it to tty_port
>       helpers. And switch to tty_port->lock for tty.
> 
>       Signed-off-by: Jiri Slaby <jslaby@suse.cz>
>       Cc: linuxppc-dev@lists.ozlabs.org
>       Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> Reverting this commit (and 0146b6939074ebe14ece3604fd00e7be128a3812
> otherwise git barfs) fixes the problem on next-20120412.  
> 
> I'm assuming we got the ref count changes wrong somewhere in the patch
> but the tty code is beyond me.  Jiri, can you take a look?

Yeah, I see. I forgot to remove a couple of tty reference drops. The
reference is dropped by tty_port_tty_set in open/close/hangup now. Does
the attached patch help?

thanks,
-- 
js
suse labs



--------------050407080301050201040708
Content-Type: text/x-patch;
 name="0001-HVC-fix-refcounting.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0001-HVC-fix-refcounting.patch"

>From cc51efe721f5aa184e119c52c661a1faf865e492 Mon Sep 17 00:00:00 2001
From: Jiri Slaby <jslaby@suse.cz>
Date: Fri, 13 Apr 2012 10:00:28 +0200
Subject: [PATCH 1/1] HVC: fix refcounting

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/tty/hvc/hvc_console.c |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/tty/hvc/hvc_console.c b/drivers/tty/hvc/hvc_console.c
index 6c45cbf..260d4f2 100644
--- a/drivers/tty/hvc/hvc_console.c
+++ b/drivers/tty/hvc/hvc_console.c
@@ -338,7 +338,6 @@ static int hvc_open(struct tty_struct *tty, struct file * filp)
 	 */
 	if (rc) {
 		tty_port_tty_set(&hp->port, NULL);
-		tty_kref_put(tty);
 		tty->driver_data = NULL;
 		tty_port_put(&hp->port);
 		printk(KERN_ERR "hvc_open: request_irq failed with rc %d.\n", rc);
@@ -393,7 +392,6 @@ static void hvc_close(struct tty_struct *tty, struct file * filp)
 		spin_unlock_irqrestore(&hp->port.lock, flags);
 	}
 
-	tty_kref_put(tty);
 	tty_port_put(&hp->port);
 }
 
@@ -433,7 +431,6 @@ static void hvc_hangup(struct tty_struct *tty)
 
 	while(temp_open_count) {
 		--temp_open_count;
-		tty_kref_put(tty);
 		tty_port_put(&hp->port);
 	}
 }
-- 
1.7.9.2


--------------050407080301050201040708--
