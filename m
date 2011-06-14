Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756392Ab1FNMEh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 08:04:37 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:42869 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756189Ab1FNMEf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 08:04:35 -0400
Date: Tue, 14 Jun 2011 17:26:52 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 3.0-rc2-tip 20/22] 20: perf: perf interface for
 uprobes
Message-ID: <20110614115652.GA4952@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20110607125804.28590.92092.sendpatchset@localhost6.localdomain6>
 <20110607130216.28590.5724.sendpatchset@localhost6.localdomain6>
 <4DF20511.8000206@hitachi.com>
 <20110613084133.GA27130@linux.vnet.ibm.com>
 <4DF6FFD1.1080203@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <4DF6FFD1.1080203@hitachi.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > 
> > All the discussions in this forum happened with respect to
> > <function>@<executable> form (esp since we started with the inode based
> > uprobes approach). Thats why I chose the
> > perf probe -u func@execfile. This also gave us a flexibility to define 
> > two probes in two different executables in the same session/command.
> > Something like 
> > perf probe -u func1@exec1 func2@exec2.
> 
> I see, and sorry for changing my mind, but I think '-u execname symbol'
> style finally be good also for uprobe users when perf probe -u supports
> debuginfo, since they don't need to learn a different syntax.
> 
> > 
> >> I think -u option should have a path of the target binary, as below
> >>
> >> # perf probe -u /bin/zsh -a zfree
> > 
> > Will --uprobe work as the long name option for -u or do you suggest
> > something else?
> 
> Hmm, good question. Maybe we can use -x|--exec to define a uprobe event,
> because there is no need to give an executable file for kprobes events.
> # so that -x implies user space event on given execfile
> 

Okay, then lets stick with perf probe -x executable <function-name>
then.

> > 
> > 1. Its okay to use a switch like "-u" that restricts the probe
> > definition session to just the user space tracing. i.e We wont be able
> > to define a probe in user space executable and also a kernel probe in
> > one single session.
> 
> I'm OK for that. The usage of perf probe is different from systemtap;
> perf probe do one thing at a time, systemtap do everything at a time.
> 
> If someone want to define various probes in the kernel, they may have
> to call perf probe several times. And I'm OK for that, because all probe
> definition should be done before recording.

Right.

> 
> So with perf probe, tracing is done following below 3 steps.
> 1. Definition
> 2. Recording
> 3. Analysis
> 
> And each phase is done separately.
> 
> > 2. Its okay to have just "target" and a flag to identify if the session
> > is a userspace probing session, instead of having separate fields for
> > userspace executable path and the module name.
> > 	i.e you are okay with patch "perf: rename target_module to target"
> 
> Ah, that's good to me. Actually, I'm now trying to expand "target_module"
> to receive a path of offline module. It'll be better for that too.:-)

Okay, works.

> 
> > 3. Currently perf_probe_point has one field "file" that was only used to
> > refer to source file. Uprobes overrides it to use it for executable file
> > too. One approach would be to add another field something like
> > "execfile" that we use to refer to executable files and use the current
> > field "file" for source files. 
> > 	Also do you suggest that we rename the current
> > file field to "srcfile?
> 
> Ah, I see. From the viewpoint of implementation, we just introduce
> a bool flag, which indicates user-probe, and a union, which has
> a "char *module" and "char *exec". :)

Okay, 

> 
> However, Maybe we'd better look this more carefully. Here, we have
> a problem with listing userspace probes (I mean how perf probe can
> list up the probes which is on a user app)
> 
> Currently, it just ignores module name if a probe on a module.
>   probe:fuse_do_open   (on fuse_do_open@ksrc/linux-2.6/fs/fuse/file.c with isdir)
> 
> One possible solution is to show the module name right before the
> symbol as same as the kernel does.
> 
>   probe:fuse_do_open   (on fuse:fuse_do_open@ksrc/linux-2.6/fs/fuse/file.c with
> isdir)

This looks better to me.

> 
> It seems that current your proposal doing same thing
> 
>   probe_zsh:zfree      (on /bin/zsh:0x45400)
> 
> Another way is to show it more verbosely, like below.
> 
>   probe:fuse_do_open   (at fuse_do_open@ksrc/linux-2.6/fs/fuse/file.c with isdir
> on fuse)
>   probe_zsh:zfree      (at 0x45400 on /bin/zsh)
> 

But I am okay with changing to this format too.

-- 
Thanks and Regards
Srikar
