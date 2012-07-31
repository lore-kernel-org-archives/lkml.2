Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756543Ab2GaXvr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 19:51:47 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:13385 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756524Ab2GaXvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 19:51:42 -0400
X-Authority-Analysis: v=2.0 cv=IOWA+3TG c=1 sm=0 a=s5Htg7xnQOKvHEu9STBOug==:17 a=OpT9cpI26MMA:10 a=3Odpp9koIGIA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=FoRfYKP0UL6t3QyspkoA:9 a=PUjeQqilurYA:10 a=E6k37eg1NvgA:10 a=s5Htg7xnQOKvHEu9STBOug==:117
X-Cloudmark-Score: 0
X-Originating-IP: 72.230.195.127
Message-ID: <1343778699.27983.70.camel@gandalf.stny.rr.com>
Subject: Re: Testing tracer wakeup_rt: .. no entries found ..FAILED!
From: Steven Rostedt <rostedt@goodmis.org>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Avi Kivity <avi@redhat.com>, Steven Rostedt <srostedt@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Date: Tue, 31 Jul 2012 19:51:39 -0400
In-Reply-To: <20120731234336.GA5526@localhost>
References: <20120724090330.GA9830@localhost>
	 <20120724090720.GA10434@localhost> <1343663105.3847.7.camel@fedora>
	 <20120731121759.GA17822@localhost> <5017D19B.5080806@redhat.com>
	 <1343738627.27983.30.camel@gandalf.stny.rr.com>
	 <5017D4AB.3090107@redhat.com>
	 <1343740419.27983.33.camel@gandalf.stny.rr.com>
	 <20120731234336.GA5526@localhost>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-08-01 at 07:43 +0800, Fengguang Wu wrote:
> On Tue, Jul 31, 2012 at 09:13:39AM -0400, Steven Rostedt wrote:
> > On Tue, 2012-07-31 at 15:50 +0300, Avi Kivity wrote:
> > > On 07/31/2012 03:43 PM, Steven Rostedt wrote:
> > 
> > > That would be better.  A hypervisor might be real-time capable (with
> > > some effort kvm can do this), so we don't want to turn off real time
> > > features just based on that.
> > 
> > It would only turn off if you enable selftests and the timing falied. If
> > the kvm had real time features, this most likely would fail anyway. But
> > that said, here's a patch that should solve this:
> 
> No luck.. it still fails:

I bet you it didn't ;-)

> 
> [    2.360068] Testing tracer irqsoff: [    2.854529] 
> [    2.854828] ===============================
> [    2.855560] [ INFO: suspicious RCU usage. ]
> [    2.856266] 3.5.0-00024-g01ff5db-dirty #3 Not tainted
> [    2.857182] -------------------------------
> [    2.857933] /c/wfg/linux/include/linux/rcupdate.h:730 rcu_read_lock() used illegally while idle!
> [    2.859450] 
> [    2.859450] other info that might help us debug this:
> [    2.859450] 
> [    2.860874] 
> [    2.860874] RCU used illegally from idle CPU!
> [    2.860874] rcu_scheduler_active = 1, debug_locks = 0
> [    2.862754] RCU used illegally from extended quiescent state!
> [    2.863741] 2 locks held by swapper/0/0:
> 
> [    2.864377]  #0: [    2.864423]  (max_trace_lock){......}, at: [<814f6bfe>] check_critical_timing+0xd7/0x286
> [    2.864423]  #1:  (rcu_read_lock){.+.+..}, at: [<8116f930>] __update_max_tr+0x0/0x430
> 
> [    2.864423] stack backtrace:
> [    2.864423] Pid: 0, comm: swapper/0 Not tainted 3.5.0-00024-g01ff5db-dirty #3
> [    2.864423] Call Trace:
> [    2.864423]  [<81103a06>] lockdep_rcu_suspicious+0x1c6/0x210
> [    2.864423]  [<8116fc9a>] __update_max_tr+0x36a/0x430
> [    2.864423]  [<8116f930>] ? tracing_record_cmdline+0x200/0x200
> [    2.864423]  [<8117186e>] update_max_tr_single+0x14e/0x2c0
> [    2.864423]  [<81170baa>] ? __trace_stack+0x2a/0x40
> [    2.864423]  [<814f6d22>] check_critical_timing+0x1fb/0x286
> [    2.864423]  [<81013313>] ? default_idle+0x593/0xc30
> [    2.864423]  [<81013313>] ? default_idle+0x593/0xc30
> [    2.864423]  [<8110a0e7>] ? trace_hardirqs_on+0x27/0x40
> [    2.864423]  [<8117ea5e>] time_hardirqs_on+0x1de/0x220
> [    2.864423]  [<81013313>] ? default_idle+0x593/0xc30
> [    2.864423]  [<81109d6d>] trace_hardirqs_on_caller+0x2d/0x380
> [    2.864423]  [<8110a0e7>] trace_hardirqs_on+0x27/0x40
> [    2.864423]  [<81013313>] default_idle+0x593/0xc30
> [    2.864423]  [<8101692d>] cpu_idle+0x2dd/0x390
> [    2.864423]  [<814eb841>] rest_init+0x2f5/0x314
> [    2.864423]  [<814eb54c>] ? __read_lock_failed+0x14/0x14
> [    2.864423]  [<817a43b4>] start_kernel+0x866/0x87a

What was the next lines? I bet you it was "PASSED". Which means it did
not fail. This is the second bug you found that has to do with RCU being
called in 'idle'. The one that Paul posted a patch for.

-- Steve


