Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752268Ab1HKRI5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 13:08:57 -0400
Received: from gateway.hbm.com ([213.157.30.2]:12702 "EHLO hbmntx5.hbm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750933Ab1HKRIw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 13:08:52 -0400
Thread-Index: AcxYSVWvr7OaZLwZQYeLcTUv5I9ENA==
Thread-Topic: [ANNOUNCE] 3.0.1-rt8 - Regression to 3.0-rt7
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.3790.4862
Content-class: urn:content-classes:message
Importance: normal
From: "Tim Sander" <tim.sander@hbm.com>
Organization: Hottinger Baldwin Messtechnik
To: "Peter Zijlstra" <peterz@infradead.org>
Subject: Re: [ANNOUNCE] 3.0.1-rt8 - Regression to 3.0-rt7
Date: Thu, 11 Aug 2011 19:08:32 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.39; KDE/4.4.5; x86_64; ; )
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@us.ibm.com>,
        "linux-rt-users" <linux-rt-users@vger.kernel.org>
References: <1312580681.28695.44.camel@twins> <201108111804.11136.tim.sander@hbm.com> <1313080781.8491.6.camel@twins>
In-Reply-To: <1313080781.8491.6.camel@twins>
MIME-Version: 1.0
Content-Type: text/Plain;
	charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Message-ID: <201108111908.32729.tim.sander@hbm.com>
X-OriginalArrivalTime: 11 Aug 2011 17:08:47.0860 (UTC) FILETIME=[55953340:01CC5849]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter
> > Yes it works for CONFIG_PREEMPT_RTB=y and as you say not for
> > CONFIG_PREEMPT_LL=y.
> > 
> > +++ b/mm/filemap.c
> > @@ -2040,7 +2040,7 @@ size_t iov_iter_copy_from_user_atomic(struct page
> > *page,
> > 
> >         char *kaddr;
> >         size_t copied;
> > 
> > -       BUG_ON(!current->pagefault_disabled);
> > +       BUG_ON(!(in_atomic() || current->pagefault_disabled));
> 
> Ah, I had hoped that bit would have cured the PREEMPT_LL=y config.
As stated in the other mail, it was really PREEMPT_LL=y. I hope my error 
didn't cause you any extra work.

> But let me untangle that posix_cpu_timer stuff first, maybe that's in
> the way.
Which *is* visible by CONFIG_PREEMPT_LL.

I just tested 3.0.1 with rt8 patch + the ones i mailed in this thread
in both configurations. I can confirm that CONFIG_PREEMPT_RTB=y
doesn't show any bugs and CONFIG_PREEMPT_LL shows the following bug:

kernel BUG at kernel/posix-cpu-timers.c:1315!                                                                                                   
Unable to handle kernel NULL pointer dereference at virtual address 00000000                                                                                
pgd = c0004000                                                                                                                                              
[00000000] *pgd=00000000                                                                                                                                    
Internal error: Oops: 817 [#1] PREEMPT                                                                                                                      
Modules linked in: af_packet i2c_imx(+) netx netx_reset dspload fpgaload 
mxc_nand(+) nand nand_ids nand_ecc                                                 
CPU: 0    Not tainted  (3.0.1-pmx-rt8 #2)                                                                                                                   
PC is at __bug+0x24/0x30                                                                                                                                    
LR is at walk_stackframe+0x24/0x40                                                                                                                          
pc : [<c002cbf0>]    lr : [<c002cbb0>]    psr: 60000113                                                                                                     
sp : c782ff40  ip : c782fe28  fp : c782ff4c                                                                                                                 
r10: 00000001  r9 : 00000000  r8 : c78b2180                                                                                                                 
r7 : c030463c  r6 : c782e000  r5 : 00000000  r4 : c78b2180                                                                                                  
r3 : 00000000  r2 : 00000001  r1 : c782fe58  r0 : 00000034                                                                                                  
Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment kernel                                                                                         
Control: 00c5387d  Table: 87b84008  DAC: 00000017
Process posixcputmr/0 (pid: 6, stack limit = 0xc782e268)
Stack: (0xc782ff40 to 0xc7830000)
ff40: c782ff8c c782ff50 c005a5c0 c002cbd8 00000000 c782ff54 c782ff54 00000000
ff60: 00000000 c78b2180 00000000 c782e000 c030463c c78b2180 00000000 00000001
ff80: c782ffbc c782ff90 c005a88c c005a594 00000000 c7817f28 00000000 c782ffcc
ffa0: c005a800 00000000 00000000 00000000 c782fff4 c782ffc0 c00570f0 c005a80c
ffc0: c7817f28 00000000 00000000 00000000 c782ffd0 c782ffd0 c7817f28 c0057064
ffe0: c0040868 00000013 00000000 c782fff8 c0040868 c0057070 cccdcd6c ffdec890
Backtrace: 
[<c002cbcc>] (__bug+0x0/0x30) from [<c005a5c0>] 
(__run_posix_cpu_timers+0x38/0x278)
[<c005a588>] (__run_posix_cpu_timers+0x0/0x278) from [<c005a88c>] 
(posix_cpu_timers_thread+0x8c/0x124)
[<c005a800>] (posix_cpu_timers_thread+0x0/0x124) from [<c00570f0>] 
(kthread+0x8c/0x94)
[<c0057064>] (kthread+0x0/0x94) from [<c0040868>] (do_exit+0x0/0x2d8)
 r7:00000013 r6:c0040868 r5:c0057064 r4:c7817f28
Code: e59f0010 e1a01003 eb086b03 e3a03000 (e5833000) 
---[ end trace 09b9f42079c77f6a ]---

Thats enough for me today.

Best regards
Tim

Hottinger Baldwin Messtechnik GmbH, Im Tiefen See 45, 64293 Darmstadt, Germany | www.hbm.com 

Registered as GmbH (German limited liability corporation) in the commercial register at the local court of Darmstadt, HRB 1147  
Company domiciled in Darmstadt | CEO: Andreas Huellhorst | Chairman of the board: James Charles Webster

Als Gesellschaft mit beschraenkter Haftung eingetragen im Handelsregister des Amtsgerichts Darmstadt unter HRB 1147 
Sitz der Gesellschaft: Darmstadt | Geschaeftsfuehrung: Andreas Huellhorst | Aufsichtsratsvorsitzender: James Charles Webster

The information in this email is confidential. It is intended solely for the addressee. If you are not the intended recipient, please let me know and delete this email.

Die in dieser E-Mail enthaltene Information ist vertraulich und lediglich für den Empfaenger bestimmt. Sollten Sie nicht der eigentliche Empfaenger sein, informieren Sie mich bitte kurz und loeschen diese E-Mail.

