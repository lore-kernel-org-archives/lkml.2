Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933497Ab1IJPgm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Sep 2011 11:36:42 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:51959 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753220Ab1IJPgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Sep 2011 11:36:41 -0400
From: Pedro Alves <pedro@codesourcery.com>
Organization: CodeSourcery
To: Denys Vlasenko <vda.linux@googlemail.com>
Subject: Re: [PATCH v3] Make PTRACE_SEIZE set ptrace options specified in 'data'
Date: Sat, 10 Sep 2011 16:36:36 +0100
User-Agent: KMail/1.13.6 (Linux/2.6.38-11-generic; KDE/4.7.0; x86_64; ; )
Cc: Denys Vlasenko <dvlasenk@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
References: <1315506333.18043.49.camel@dhcp-25-63.brq.redhat.com> <201109101340.16506.vda.linux@googlemail.com> <201109101312.39256.pedro@codesourcery.com>
In-Reply-To: <201109101312.39256.pedro@codesourcery.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201109101636.37007.pedro@codesourcery.com>
X-OriginalArrivalTime: 10 Sep 2011 15:36:39.0274 (UTC) FILETIME=[6EAE6CA0:01CC6FCF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 10 September 2011 13:12:38, Pedro Alves wrote:

> (just-options-on-SEIZE scares me in terms of future expansion,
> as it assumes only bitflags will ever be necessary.)

The more I think of this, the more I think we could do this
some other way --- why don't we allow setting the default
options _on the ptracer_, and then tracee's inherit those
options from the ptracer-set-of-default-options if their
parent is not currently ptraced by own tracer?  That is, you'd make
the ptracer set options on itself:

options = PTRACE_O_TRACESYSGOOD | PTRACE_O_TRACECLONE|FORK|VFORK|EXEC ...;
ptrace(PTRACE_SETOPTIONS, gettid(), 0, options);

And then, in all of

 ptrace(PTRACE_ATTACH, foo_pid, 0, 0);
 ptrace(PTRACE_TRACEME, 0, 0, 0);
 ptrace(PTRACE_SEIZE, foo_pid, 0, 0);

you'd end up with the tracee already with your chosen options set.

Clones, vforks and forks that are auto-attached would still inherit their
options from their parent, just like today.

Some pro points:

- works for PTRACE_ATTACH AND PTRACE_TRACEME too.

- most ptracers on earth will only need to set options once.

- backwards compatible.  The "default ptrace options" default
to 0, so old tracers on new kernels will still behave the same.

- future proof.  If some other PTRACE_SET_NEAT_OPTION ptrace
command appears in the future, we can make it work the same
way, instead of getting stuck with PTRACE_SEIZE's `data'
already being taken...

- if ptrace(PTRACE_SETOPTIONS, gettid(), 0, 0) works, then
we can stop gdb (and probably other tracers) from forking a new
child just to check if PTRACE_O_TRACEFOO works before actually
attaching/spawning the process of interest.
(see code around linux_supports_tracefork_flag at
<http://sourceware.org/cgi-bin/cvsweb.cgi/src/gdb/linux-nat.c?rev=1.215&content-type=text/x-cvsweb-markup&cvsroot=src>)

Cons:

- is there any real con?

Note the default ptrace options would _not_ conflict with
the ptracer's own ptrace options in case the ptracer itself
is being ptraced.

WDYT?

-- 
Pedro Alves
