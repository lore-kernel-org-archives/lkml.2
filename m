Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757818Ab1K3Lzb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 06:55:31 -0500
Received: from merlin.infradead.org ([205.233.59.134]:56871 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757798Ab1K3Lz1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 06:55:27 -0500
Message-ID: <1322654092.2921.256.camel@twins>
Subject: Re: perf_event self-monitoring overhead regression
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Vince Weaver <vweaver1@eecs.utk.edu>
Cc: Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Stephane Eranian <eranian@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 30 Nov 2011 12:54:52 +0100
In-Reply-To: <alpine.DEB.2.00.1111300011260.7107@cl320.eecs.utk.edu>
References: <alpine.DEB.2.00.1111300011260.7107@cl320.eecs.utk.edu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-11-30 at 00:20 -0500, Vince Weaver wrote:
> Hello
> 
> I've been tracking a performance regression with self-monitoring and 
> perf_event.
> 
> For a simple start/stop/read test, the overhead has increased about 10%
> from the 2.6.32 kernel to 3.1.  (this has been measured on a variety
> of x86_64 machines).
> 
> This is as measured with the POSIX clock_gettime(CLOCK_REALTIME,&time)
> calls.  Potentially the issue is with this and not with perf_events.
> As you can imagine it is hard to measure the performance of the perf_event
> interface since you can't invoke perf_event on it.

If you've got a stable TSC on your machine you can of course revert to
userspace TSC reads and eliminate clock_gettime() from the picture.

> In any case, I was trying to bisect some of these performance issues.  
> There was another jump in overhead between 3.0 and 3.1, so I tried there.
> I had a bisectable test case, but after a tedious day-long bisect run the 
> problem bisected down to
> 
>    commit 2d86a3f04e345b03d5e429bfe14985ce26bff4dc
>    Merge: 3960ef3 5ddac6b
>    Author: Linus Torvalds <torvalds@linux-foundation.org>
>    Date:   Tue Jul 26 17:13:04 2011 -0700
> 
>     Merge branch 'next/board' of git://git.kernel.org/pub/scm/linux/kernel/git/arm/l
>     
> Which seems unlikely.  My git skills really aren't enough to try to figure
> out why an ARM board merge would affect the overhead of the perf_event
> syscalls on x86_64.
> 
> Is there a better way for trying to track down performance regressions 
> like this?

I CC'ed Linus since he's way too skilled at this git thing and always
has good advice. There might be very good bisect advice in the lkml
archives but I'm not sure there's anything like a HOWTO/FAQ on the
subject other than the git-bisect manpage (ought there be one?).

One thing that was suggested at the last KS is a git bisect mode that
jumps on merge commits instead of random points in the history. And only
once its isolated a particular merge will it bisect that one merge on
commit level.

Something like that might help by reducing noise, or it might not.
Bisect is often (as you well know by now) a lot harder in practice than
it sounds in theory :/
