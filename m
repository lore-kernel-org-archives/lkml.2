Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753114Ab1GLKzM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 06:55:12 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:60542 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752959Ab1GLKzJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 06:55:09 -0400
Date: Tue, 12 Jul 2011 03:55:06 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: xen-devel@lists.xensource.com, julie Sullivan <kernelmail.jms@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: 3.0-rc kernels unbootable since -rc3
Message-ID: <20110712105506.GB2253@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110710173530.GA16954@linux.vnet.ibm.com>
 <CAAVPGOPAx-oLZct9u2Kq3uQ4W2GwJFYUGgw3h=M_Y4_wv7b51w@mail.gmail.com>
 <20110710214639.GP6014@linux.vnet.ibm.com>
 <CAAVPGOMafp_+45X=7asHe=MqaHY8CiJYsf2GZ3qOPrWpjctHVQ@mail.gmail.com>
 <20110710231449.GQ6014@linux.vnet.ibm.com>
 <20110711162450.GA22913@dumpdata.com>
 <20110711171337.GK2245@linux.vnet.ibm.com>
 <20110711193021.GA2996@dumpdata.com>
 <20110711201508.GN2245@linux.vnet.ibm.com>
 <20110711210954.GA15745@dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110711210954.GA15745@dumpdata.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 11, 2011 at 05:09:54PM -0400, Konrad Rzeszutek Wilk wrote:
> On Mon, Jul 11, 2011 at 01:15:08PM -0700, Paul E. McKenney wrote:
> > On Mon, Jul 11, 2011 at 03:30:22PM -0400, Konrad Rzeszutek Wilk wrote:
> > > > 
> > > > Hmmm...  Does the stall repeat about every 3.5 minutes after the first stall?
> > > 
> > > Starting Configure read-only root support...
> > > [   81.335070] INFO: rcu_sched_state detected stalls on CPUs/tasks: { 0} (detected by 3, t=60002 jiffies)
> > > [   81.335091] sending NMI to all CPUs:
> > > [  261.367071] INFO: rcu_sched_state detected stalls on CPUs/tasks: { 0} (detected by 3, t=240034 jiffies)
> > > [  261.367092] sending NMI to all CPUs:
> > > [  441.399066] INFO: rcu_sched_state detected stalls on CPUs/tasks: { 0} (detected by 3, t=420066 jiffies)
> > > [  441.399089] sending NMI to all CPUs:
> > 
> > OK, then the likely cause is something hanging onto the CPU.  Do the later
> > stalls also show stack traces?  If so, what shows up?
> 
> I don't really get any stack traces from the guest. Not sure why it does
> not print them out (probably b/c the NMI functionality is not accessible
> somehow?). I get the stack traces using a 'xenctx' tool and this is what
> I get from the guest before the stall, and after the stall:
> 
> 20:45:56 # 12 :/mnt/tmp/FC15-32/ 
> /usr/lib64/xen/bin/xenctx 29 -s System.map-3.0.0-rc6-disabled-options+ -a 2
> cs:eip: 0061:c042d0f5 task_waking_fair+0x14 
> flags: 00001286 i s nz p
> ss:esp: 0069:e94cff0c
> eax: c18dbed0   ebx: ffffffff   ecx: fff00000   edx: c14a10c0
> esi: 00000000   edi: 00000000   ebp: e94cff18
>  ds:     007b    es:     007b    fs:     00d8    gs:     00e0
> 
> cr0: 8005003b
> cr2: b7743000
> cr3: 97348001
> cr4: 00000660
> 
> dr0: 00000000
> dr1: 00000000
> dr2: 00000000
> dr3: 00000000
> dr6: ffff0ff0
> dr7: 00000400
> Code (instr addr c042d0f5)
> c3 55 89 e5 57 56 53 3e 8d 74 26 00 8b 90 58 01 00 00 8b 7a 1c <8b> 72 20 8b 5a 18 8b 4a 14 39 f3 
> 
> 
> Stack:
>  c18dbed0 00000003 00000002 e94cff38 c0439a45 c18d00c0 c18dc2c0 00000000
>  e8bd1ec4 e8bd1ef8 00000003 e94cff40 c0439b0c e94cff64 c042d4db 00000000
>  e8bd1f04 00000001 00000001 e8bd1f00 e8bd0200 e8bd1efc e94cff80 c042ea69
>  00000000 00000000 e8bd1ef4 ea9c4918 c0a43a80 e94cff88 c0455e14 e94cffb4
> 
> Call Trace:
>   [<c042d0f5>] task_waking_fair+0x14  <--

Hmmm...  This is a 32-bit system, isn't it?

Could you please add a check to the loop in task_waking_fair() and
do a printk() if the loop does (say) more than 1000 passes without
exiting?

							Thanx, Paul

>   [<c0439a45>] try_to_wake_up+0xb2 
>   [<c0439b0c>] default_wake_function+0x10 
>   [<c042d4db>] __wake_up_common+0x3b 
>   [<c042ea69>] complete+0x3e 
>   [<c0455e14>] wakeme_after_rcu+0x10 
>   [<c048fd26>] __rcu_process_callbacks+0x172 
>   [<c048fe14>] rcu_process_callbacks+0x1e 
>   [<c044567d>] __do_softirq+0xa2 
