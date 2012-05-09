Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760191Ab2EIQYg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 12:24:36 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:53407 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755790Ab2EIQYe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 12:24:34 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+s9N0lanqsFAiVZYpYQBj23xkWv8xKOQqhF+JHdp
	LJto105Apg3JZa
Message-ID: <1336580669.16079.68.camel@marge.simpson.net>
Subject: Re: Scheduler still seems awful with x264, worse with patches
From: Mike Galbraith <efault@gmx.de>
To: Jason Garrett-Glaser <jason@x264.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Wed, 09 May 2012 18:24:29 +0200
In-Reply-To: <CABS55+A_ZbJT4Tz-XfacbURpgfx2WuXqvPnn1_XkAfhxJMP6eA@mail.gmail.com>
References: <CABS55+A_ZbJT4Tz-XfacbURpgfx2WuXqvPnn1_XkAfhxJMP6eA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-09 at 09:00 -0700, Jason Garrett-Glaser wrote: 
> Many months ago, the topic of CFS's inefficiencies with x264 came up
> and some improvements were made, but BFS and Windows still stayed a
> little bit in the lead.  This seemed to be because of a mix of two
> issues.  Firstly, a combination of relatively short-lived jobs (x264
> uses a thread pool, so the actual threads are long-lived).  Secondly,
> in frame threads, heavy dependencies between threads, benefiting
> greatly from a dumb scheduler.  Thirdly, in sliced threads -- the
> focus of this post -- the best scheduling approach is to simply spread
> them throughout the cores and do nothing, so again, a dumb scheduler
> will do the right thing.

I took x264 for a quick test drive a short while ago, and it looks like
we slipped a bit.  I didn't have time to futz with it much, but did find
that SCHED_IDLE kicked SCHED_OTHER's butt.  x264 really really wants RR.

> Recently I tried multithreading x264's lookahead for a customer.  The
> lookahead previously wasn't threaded, causing bottlenecks with many
> cores and threads.  I do my development mainly on Windows, and the
> patch looked to be quite a success, with nice performance boosts for
> many target use-cases.
> 
> And then I ran it on Linux and it choked horribly.
> 
> The patch is here:
> https://github.com/DarkShikari/x264-devel/commit/99e830f1581eac3cf30f07b1d6c6c32bae1725c8
> .  To replicate the test, simply test that version against the
> previous version.  My guess is the reason it chokes is that it
> involves spawning even *shorter*-lived jobs than x264 typically does,
> something that CFS seems to simply collapse on.
> 
> Here's some stats from a recent kernel:
> 
> SD encoding (before -> after patch):
> CFS: 325.49 +/- 1.22 fps -> 251.68 +/- 2.32 fps
> BFS: 334.94 +/- 0.59 fps -> 344.47 +/- 0.68 fps
> 
> HD encoding (before -> after patch):
> CFS: 39.05 +/- 0.22 fps -> 40.56 +/- 0.23 fps
> BFS: 40.15 +/- 0.05 fps -> 44.89 +/- 0.05 fps
> 
> As can be seen, the longer the threads live (the lower the fps), the
> less horrific the penalty is.  Furthermore, though I don't have
> numbers, using schedtool -R -p 1 does basically as well as BFS in
> eliminating the problem.  Naturally, this is not really a solution as
> it requires root.
> 
> To replicate this test, a commandline like this should work on any
> cached raw input file (a collection of free raw videos can be found
> here if you don't like making your own:
> http://media.xiph.org/video/derf/ ):
> 
> ./x264 --preset superfast --tune zerolatency --threads X input -o /dev/null
> 
> Most of my testing was done with X = 4 or 8 on quad-core or
> quad-core-with-HT machines.  Though I don't have numbers, I should
> note that the absolute worst results are on a Core i7 machine where I
> set taskset 0xf and used threads 4; the patch literally cut the
> framerate in half, despite giving a performance boost when SCHED_RR
> was used.
> 
> Jason
> 
> P.S.  Here is the structure of low-latency sliced threading with the
> patch, for anyone curious.
> 
> To encode a frame with X threads:
> 1.  The previous frame's X threads are still going -- they're
> finishing up hpel and deblock calculation, which can be done after the
> encoder returns, but before the next frame is encoded.
> 2.  Serially, copy in the input frame and preprocess it, running
> various not-yet-parallelized tasks while those threads finish up.
> 3.  In parallel, do lookahead analysis of the input frame -- split it
> into X slices and analyze them simultaneously.  Then wait on the jobs
> and merge the results.
> 4.  If any of the previous frame's threads are still going, wait on them now.
> 5.  Split the main encode into X slices and do them simultaneously.
> Once they've all finished encoding -- after they've signaled the main
> thread with a condition variable -- serially finish up a few minor
> tasks and return to the caller.  These threads will continue until
> step 4) of the next frame.
> 
> When encoding at ~300fps, the encode jobs will typically run for about
> ~3ms each, and the lookahead threads likely for around 0.5ms, very
> roughly.  For a low-latency encoder, there is no way to make these
> threads last longer while still getting parallelism, and it must be
> doable because Windows handles it just fine.
> 
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


