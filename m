Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753181Ab2DSG2V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 02:28:21 -0400
Received: from mga02.intel.com ([134.134.136.20]:6499 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751918Ab2DSG2U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 02:28:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="134238986"
Message-ID: <1334816911.14538.39.camel@ymzhang.sh.intel.com>
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
Date: Thu, 19 Apr 2012 14:28:31 +0800
In-Reply-To: <4F8FACFF.9070107@gmail.com>
References: <EE928378561BF1449699C96571234A740FCED62F@SHSMSX101.ccr.corp.intel.com>
	 <4F8F8B9E.3040107@gmail.com>
	 <1334812653.14538.29.camel@ymzhang.sh.intel.com>
	 <4F8FACFF.9070107@gmail.com>
Organization: MCG
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-04-19 at 14:13 +0800, Cong Wang wrote:
> On 04/19/2012 01:17 PM, Yanmin Zhang wrote:
> > On Thu, 2012-04-19 at 11:50 +0800, Cong Wang wrote:
> >> On 04/17/2012 10:37 PM, Tu, Xiaobing wrote:
> >>> Resend the patch because of the log is too long on a single line.
> >>>
> >>> From: xiaobing tu<xiaobing.tu@intel.com>
> >>>
> >>> Here is the kernel patch for this tool, The idea is to output user space stack call-chain from
> >>> /proc/xxx/stack, currently, /proc/xxx/stack only output kernel stack call chain. We extend
> >>> it to output user space call chain in hex format
> >>>
> >>
> >> Can you teach me why we still need this as we have pstack?
> > Cong,
> >
> > Sorry for replying so late. Xiaobing told me you sent him email and I
> > didn't receive the 1st one you sent out.
> 
> 
> Based on the length of your reply and the description of the patch, you 
> hide lots of information in your patch description.
Indeed, we need add more info there.

> 
> >
> > I tried pstack and it does work. It means developers in the world wanted
> > the tool long long ago.
> >
> > Although not checking the source codes of pstack (sorry, I'm busy in debugging
> > many critical issues), I think pstack is based on ptrace interface, which means:
> > 1) It need traps into system for many times to collect call frames of one
> > task.
> > 2) It need send signal to the ptraced process to stop it. Such behavior
> > might have some impact if the ptraced process also processes many signals.
> > 3) The data parsing to get symbols might not be split from data collection.
> > I mean, it collects call frames of one process, then parses it; then collects the 2nd
> > task's. If there are many processes, it couldn't collect the data just at the monitor
> > time point.
> 
> 
> Yet another one who wants to "fix" ptrace. ;-)
Agree. But usually, it's hard to fix very old codes. Ptrace is used by gdb
and people don't touch the kernel part.

> 
> >
> > Why do we work out the tools? The original requirement is from real work.
> > We are enabling Android on Medfield. One typical error of Android is ANR.
> > When a process couldn't respond in 5 seconds, Android reports an ANR error,
> > and dumps JAVA call stack. However, it couldn't dump userspace lib (such like
> > bionic, written by C or C++). In addition, Android just dumps the stack of
> > the non-responding process. It doesn't dump stack of others. As binder is basic
> > framework in Android, processes communicate by binder in the model of client/server.
> > When one process is not responding quickly, maybe another process blocks it. We
> > need dump that process status.
> >
> > Many teams complained it's hard to debug such ANR issues, especially the ones which
> > are triggered at MTBF testing. Sometimes, an ANR happens after MTBF testing runs
> > for one week. Developers ask us to implement such tool over and over again.
> >
> > Besides ANR, sometimes, system might not respond to any user operation. Usually,
> > kernel or firmware would reset system. At that time, we also need get the call
> > chains of all the user space processes before system is reset.
> 
> 
> I am not familiar with Andriod at all, so a quick question is if this is 
> only for Andriod, why you introduce this for all? IOW, why not provide a 
> Kconfig?
Although working on Android, we think it might be useful to use the tool to resolve similar
issue. For example, I worked on performance tuning years ago and got headache why
there was performance drop on a large-scale server. From kernel part, I couldn't
find enough info to debug it. Eventually, I root caused some issues by gdb attach,
then manually checking the user space call chain. It's painful.

In addition, the new tool consists of kernel patch and user space parse tool.
The kernel patch is quite simple and shouldn't hurt system. It reuses
existing CONFIG_USER_STACKTRACE_SUPPORT.

> 
> BTW, I am sure you need to put the above paragraphs into your patch 
> description, to make it clear why the patch is needed.
It's a good idea definitely.

> 
> >
> > With our tool,
> > 1) We could collect the HEX-format call chain data and /proc/XXX/maps
> > of all the processes quickly, then parse them either after rebooting, or
> > after the issue is reported. It could catch the scene just at the time point
> > when the error happens. Our experiments shows the tool could collect the data
> > of all processes within 200ms.
> > 2) The new tool won't stop the processes and have less impact on them.
> > Considering a scenario of performance bottleneck investigation, statistics collection
> > shouldn't have big impact on running processes.
> > 3) It could support both i386 and x86-64. I tried pstack and it doesn't work
> > with x86-64.
> > 4) It follows /proc/XXX/stack interface and it's easy to use it.
> >
> > Besides this tool, we are considering to extend it to collect user space
> > call chain of current process from kernel when kernel detects some other
> > abnormal behavior.
> >
> 
> In my previous reply, I ran 'pstrack' on my x86-64 machine, don't 
> understand why you said it doesn't work with x86-64? I guess pstack 
> supports more than just x86, as ptrace is available in other arch's too.
Ok. I use the latest ubuntu on my workstation and apt-get to install
pstack without recompiling it. The default pstack executable reported
failure on 64bit os. I was wrong and might check pstack again.

Thanks for the information.

Yanmin




