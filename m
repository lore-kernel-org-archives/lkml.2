Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751820Ab2DSFRb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 01:17:31 -0400
Received: from mga02.intel.com ([134.134.136.20]:44280 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751281Ab2DSFR3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 01:17:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="131527462"
Message-ID: <1334812653.14538.29.camel@ymzhang.sh.intel.com>
Subject: Re: [RFC 1/2] kernel patch for dump user space stack tool
From: Yanmin Zhang <yanmin_zhang@linux.intel.com>
To: Cong Wang <xiyou.wangcong@gmail.com>
Cc: "Tu, Xiaobing" <xiaobing.tu@intel.com>, Lin Ming <mlin@ss.pku.edu.cn>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "Zuo, Jiao" <jiao.zuo@intel.com>
Date: Thu, 19 Apr 2012 13:17:33 +0800
In-Reply-To: <4F8F8B9E.3040107@gmail.com>
References: <EE928378561BF1449699C96571234A740FCED62F@SHSMSX101.ccr.corp.intel.com>
	 <4F8F8B9E.3040107@gmail.com>
Organization: MCG
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-04-19 at 11:50 +0800, Cong Wang wrote:
> On 04/17/2012 10:37 PM, Tu, Xiaobing wrote:
> > Resend the patch because of the log is too long on a single line.
> >
> > From: xiaobing tu<xiaobing.tu@intel.com>
> >
> > Here is the kernel patch for this tool, The idea is to output user space stack call-chain from
> > /proc/xxx/stack, currently, /proc/xxx/stack only output kernel stack call chain. We extend
> > it to output user space call chain in hex format
> >
> 
> Can you teach me why we still need this as we have pstack?
Cong,

Sorry for replying so late. Xiaobing told me you sent him email and I
didn't receive the 1st one you sent out.

I tried pstack and it does work. It means developers in the world wanted
the tool long long ago.

Although not checking the source codes of pstack (sorry, I'm busy in debugging
many critical issues), I think pstack is based on ptrace interface, which means:
1) It need traps into system for many times to collect call frames of one
task.
2) It need send signal to the ptraced process to stop it. Such behavior
might have some impact if the ptraced process also processes many signals.
3) The data parsing to get symbols might not be split from data collection.
I mean, it collects call frames of one process, then parses it; then collects the 2nd
task's. If there are many processes, it couldn't collect the data just at the monitor
time point.

Why do we work out the tools? The original requirement is from real work.
We are enabling Android on Medfield. One typical error of Android is ANR.
When a process couldn't respond in 5 seconds, Android reports an ANR error,
and dumps JAVA call stack. However, it couldn't dump userspace lib (such like
bionic, written by C or C++). In addition, Android just dumps the stack of
the non-responding process. It doesn't dump stack of others. As binder is basic
framework in Android, processes communicate by binder in the model of client/server.
When one process is not responding quickly, maybe another process blocks it. We
need dump that process status.

Many teams complained it's hard to debug such ANR issues, especially the ones which
are triggered at MTBF testing. Sometimes, an ANR happens after MTBF testing runs
for one week. Developers ask us to implement such tool over and over again.

Besides ANR, sometimes, system might not respond to any user operation. Usually,
kernel or firmware would reset system. At that time, we also need get the call
chains of all the user space processes before system is reset.

With our tool,
1) We could collect the HEX-format call chain data and /proc/XXX/maps
of all the processes quickly, then parse them either after rebooting, or
after the issue is reported. It could catch the scene just at the time point
when the error happens. Our experiments shows the tool could collect the data
of all processes within 200ms.
2) The new tool won't stop the processes and have less impact on them.
Considering a scenario of performance bottleneck investigation, statistics collection
shouldn't have big impact on running processes. 
3) It could support both i386 and x86-64. I tried pstack and it doesn't work
with x86-64.
4) It follows /proc/XXX/stack interface and it's easy to use it.

Besides this tool, we are considering to extend it to collect user space
call chain of current process from kernel when kernel detects some other
abnormal behavior.

Thanks for your kind comments and welcome to try it.

Yanmin

> 
> ~% pstack $$
> #0  0x00000036ae2365da in sigsuspend () from /lib64/libc.so.6
> #1  0x0000000000472c25 in signal_suspend ()
> #2  0x0000000000443323 in ?? ()
> #3  0x0000000000443be6 in waitjobs ()
> #4  0x000000000042b6d3 in ?? ()
> #5  0x000000000042c0bd in execlist ()
> #6  0x000000000042c64f in execode ()
> #7  0x000000000043cd32 in loop ()
> #8  0x000000000043fb36 in zsh_main ()
> #9  0x00000036ae22169d in __libc_start_main () from /lib64/libc.so.6
> #10 0x000000000040e571 in _start ()
> 
> Thanks!


