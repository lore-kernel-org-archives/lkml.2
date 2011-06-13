Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755028Ab1FMItJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 04:49:09 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:47221 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754992Ab1FMItI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 04:49:08 -0400
Date: Mon, 13 Jun 2011 14:11:33 +0530
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
Message-ID: <20110613084133.GA27130@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20110607125804.28590.92092.sendpatchset@localhost6.localdomain6>
 <20110607130216.28590.5724.sendpatchset@localhost6.localdomain6>
 <4DF20511.8000206@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <4DF20511.8000206@hitachi.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Masami,
[ I have restricted the number of people in CC to those people who are
closely following perf. Please feel free to add people].

Thanks for the review.

> > Enhances perf probe to user space executables and libraries.
> > Provides very basic support for uprobes.
> > 
> > [ Probing a function in the executable using function name  ]
> > -------------------------------------------------------------
> > [root@localhost ~]# perf probe -u zfree@/bin/zsh
> 
> Hmm, here, I have concern about the interface inconsistency
> of the probe point syntax.
> 
> Since perf probe already supports debuginfo analysis,
> it accepts following syntax;
> 
> [EVENT=]FUNC[@SRC][:RLN|+OFFS|%return|;PTN] [ARG ...]
> 
> Thus, The "@" should take a source file path, not binary path.
> 

All the discussions in this forum happened with respect to
<function>@<executable> form (esp since we started with the inode based
uprobes approach). Thats why I chose the
perf probe -u func@execfile. This also gave us a flexibility to define 
two probes in two different executables in the same session/command.
Something like 
perf probe -u func1@exec1 func2@exec2.

However I am okay to change to your suggested syntax which is 
"perf probe -u /bin/zsh -a zfree"

> I think -u option should have a path of the target binary, as below
> 
> # perf probe -u /bin/zsh -a zfree

Will --uprobe work as the long name option for -u or do you suggest
something else?

> 
> This will allow perf-probe to support user-space debuginfo
> analysis. With it, we can do as below;
> 

While we discuss this I would also like to get your thoughts on couple
of issues.

1. Its okay to use a switch like "-u" that restricts the probe
definition session to just the user space tracing. i.e We wont be able
to define a probe in user space executable and also a kernel probe in
one single session.

2. Its okay to have just "target" and a flag to identify if the session
is a userspace probing session, instead of having separate fields for
userspace executable path and the module name.
	i.e you are okay with patch "perf: rename target_module to target"

3. Currently perf_probe_point has one field "file" that was only used to
refer to source file. Uprobes overrides it to use it for executable file
too. One approach would be to add another field something like
"execfile" that we use to refer to executable files and use the current
field "file" for source files. 
	Also do you suggest that we rename the current
file field to "srcfile?

Based on the outcomes of this discussion, I will modify the code and
Documentation.

-- 
Thanks and Regards
Srikar
