Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932989Ab0KQAtL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 19:49:11 -0500
Received: from smtp-out.google.com ([216.239.44.51]:60460 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755931Ab0KQAtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 19:49:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-operating-system
         :user-agent;
        b=pBDo0Hwlbtdv79dJcuJmfn/FqZ1aE9aX7II28hJZO9OzgiSZfopAOQ3HNYSGJnXBsM
         FrYz1KveAH5DTcO0vplQ==
Date: Tue, 16 Nov 2010 16:48:54 -0800
From: Mandeep Singh Baines <msb@chromium.org>
To: Bodo Eggert <7eggert@gmx.de>
Cc: David Rientjes <rientjes@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ying Han <yinghan@google.com>, Bodo Eggert <7eggert@web.de>,
        "Figo.zhang" <figo1802@gmail.com>
Subject: Re: [PATCH] Revert oom rewrite series
Message-ID: <20101117004854.GA7153@google.com>
References: <20101114133543.E00A.A69D9226@jp.fujitsu.com>
 <alpine.DEB.2.00.1011141345100.22262@chino.kir.corp.google.com>
 <alpine.LNX.2.00.1011152255580.17235@be10.lrz>
 <alpine.DEB.2.00.1011151537580.29081@chino.kir.corp.google.com>
 <alpine.LSU.0.999.1011170035050.5484@be1.lrz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.0.999.1011170035050.5484@be1.lrz>
X-Operating-System: Linux/2.6.32-gg252-generic (x86_64)
User-Agent: Mutt/1.5.20 (2009-06-14)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bodo Eggert (7eggert@gmx.de) wrote:
> On Mon, 15 Nov 2010, David Rientjes wrote:
> > On Tue, 16 Nov 2010, Bodo Eggert wrote:
> 
> > > > CAP_SYS_RESOURCE threads have full control over their oom killing priority
> > > > by /proc/pid/oom_score_adj
> > > 
> > > , but unless they are written in the last months and designed for linux
> > > and if the author took some time to research each external process invocation,
> > > they can not be aware of this possibility.
> > > 
> > 
> > You're clearly wrong, CAP_SYS_RESOURCE has been required to modify oom_adj 
> > for over five years (as long as the git history).  8fb4fc68, merged into 
> > 2.6.20, allowed tasks to raise their own oom_adj but not decrease it.  
> > That is unchanged by the rewrite.
> 
> You are misunderstanding me. It was allowed to do this, but it did not need 
> to do it yet. It was enough to be a well-written POSIX application without 
> linux-specific OOM hacks for some specific kernel versions.
> 
> > > Besides that, if each process is supposed to change the default, the default
> > > is wrong.
> > 
> > That doesn't make any sense, if want to protect a thread from the oom 
> > killer you're going to need to modify oom_score_adj, the kernel can't know 
> > what you perceive as being vital.  Having CAP_SYS_RESOURCE alone does not 
> > imply that, it only allows unbounded access to resources.  That's 
> > completely orthogonal to the goal of the oom killer heuristic, which is to 
> > find the most memory-hogging task to kill.
> 
> The old oom killer's task was to guess the best victim to kill. For me, it 
> did a good job (but the system kept thrashing for too long until it kicked

Here's a patch I've been working on to control thrashing.

http://lkml.org/lkml/2010/10/28/289

It works well for our app: web browser. We'd rather OOM quickly and kill
a browser tab than thrash for a few minutes and then OOM. It works well for
us but I'm working on a more generally useful solution.

> the offender). Looking at CAP_SYS_RESOURCE was one way to recognize 
> important processes.
> 
> > > 1) The exponential scale did have a low resolution.
> > > 
> > > 2) The heuristics were developed using much brain power and much
> > >    trial-and-error. You are going back to basics, and some people
> > >    are not convinced that this is better. I googled and I did not
> > >    find a discussion about how and why the new score was designed
> > >    this way.
> > >    looking at the output of:
> > >    cd /proc; for a in [0-9]*; do
> > >      echo `cat $a/oom_score` $a `perl -pes/'\0.*$'// < $a/cmdline`;
> > >    done|grep -v ^0|sort -n |less
> > >    , I 'm not convinced, too.
> > > 
> > 
> > The old heuristics were a mixture of arbitrary values that didn't adjust 
> > scores based on a unit and would often cause the incorrect task to be 
> > targeted because there was no clear goal being achieved.  The new 
> > heuristic has a solid goal: to identify and kill the most memory-hogging 
> > task that is eligible given the context in which the oom occurs.  If you 
> > disagree with that goal and want any of the old heursitics reintroduced, 
> > please show that it makes sense in the oom killer.
> 
> The first old OOM killer did the same as you promise the current one does,
> except for your bugfixes. That's why it killed the wrong applications and
> all the heuristics were added until the complaints stopped.
> 
> Off cause I did not yet test your OOM killer, maybe it really is better.
> Heuristics tend to rot and you did much work to make it right.
> 
> I don't want the old OOM killer back, but I don't want you to fall
> into the same pits as the pre-old OOM killer used to do.
> 
> > > PS) Mapping an exponential value to a linear score is bad. E.g. A
> > >     oom_adj of 8 should make an 1-MB-process as likely to kill as
> > >     a 256-MB-process with oom_adj=0.
> > > 
> > 
> > To show that, you would have to show that an application that exists today 
> > uses an oom_adj for something other than polarization and is based on a 
> > calculation of allowable memory usage.  It simply doesn't exist.
> 
> No such application should exist because the OOM killer should DTRT.
> oom_adj was supposed to let the sysadmin lower his mission-critical
> DB's score to be just lower than the less-important tasks, or to
> point the kernel to his ever-faulty and easily-restarted browser.
> 
> > > PS2) Because I saw this in your presentation PDF: (@udev-people)
> > >     The -17 score of udevd is wrong, since it will even prevent
> > >     the OOM killer from working correctly if it grows to 100 MB:
> > > 
> > 
> > Threads with CAP_SYS_RESOURCE are free to lower the oom_score_adj of any 
> > thread they deem fit and that includes applications that lower its own 
> > oom_score_adj.  The kernel isn't going to prohibit users from setting 
> > their own oom_score_adj.
> 
> My point is: The udev people should not prevent the OOM killer 
> unconditionally, it has an important task in case something goes wrong.
> I just didn't want to start a new thread at that time of day.
> -- 
> How do I set my laser printer on stun?
