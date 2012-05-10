Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761171Ab2EJSZM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 14:25:12 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:33729 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1760086Ab2EJSZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 14:25:10 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX198F4Ncs8J8O3TuE/HUDhElQn+We+TA2y4lGcMBXs
	Jyw5o2yeQjt6hq
Message-ID: <1336674306.7334.18.camel@marge.simpson.net>
Subject: Re: Scheduler still seems awful with x264, worse with patches
From: Mike Galbraith <efault@gmx.de>
To: Jason Garrett-Glaser <jason@x264.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Thu, 10 May 2012 20:25:06 +0200
In-Reply-To: <CABS55+DrvJ3QByW6i9gnYCq+ayD3r7oVkRVW73Hj4-zGBKFoKw@mail.gmail.com>
References: <CABS55+A_ZbJT4Tz-XfacbURpgfx2WuXqvPnn1_XkAfhxJMP6eA@mail.gmail.com>
	 <1336645785.25483.3.camel@marge.simpson.net>
	 <CABS55+DrvJ3QByW6i9gnYCq+ayD3r7oVkRVW73Hj4-zGBKFoKw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-10 at 09:22 -0700, Jason Garrett-Glaser wrote: 
> On Thu, May 10, 2012 at 3:29 AM, Mike Galbraith <efault@gmx.de> wrote:
> > On Wed, 2012-05-09 at 09:00 -0700, Jason Garrett-Glaser wrote:
> >> Many months ago, the topic of CFS's inefficiencies with x264 came up
> >> and some improvements were made, but BFS and Windows still stayed a
> >> little bit in the lead.  This seemed to be because of a mix of two
> >> issues.  Firstly, a combination of relatively short-lived jobs (x264
> >> uses a thread pool, so the actual threads are long-lived).  Secondly,
> >> in frame threads, heavy dependencies between threads, benefiting
> >> greatly from a dumb scheduler.  Thirdly, in sliced threads -- the
> >> focus of this post -- the best scheduling approach is to simply spread
> >> them throughout the cores and do nothing, so again, a dumb scheduler
> >> will do the right thing.
> >>
> >> Recently I tried multithreading x264's lookahead for a customer.  The
> >> lookahead previously wasn't threaded, causing bottlenecks with many
> >> cores and threads.  I do my development mainly on Windows, and the
> >> patch looked to be quite a success, with nice performance boosts for
> >> many target use-cases.
> >>
> >> And then I ran it on Linux and it choked horribly.
> >>
> >> The patch is here:
> >> https://github.com/DarkShikari/x264-devel/commit/99e830f1581eac3cf30f07b1d6c6c32bae1725c8
> >> .  To replicate the test, simply test that version against the
> >> previous version.  My guess is the reason it chokes is that it
> >> involves spawning even *shorter*-lived jobs than x264 typically does,
> >> something that CFS seems to simply collapse on.
> >>
> >> Here's some stats from a recent kernel:
> >>
> >> SD encoding (before -> after patch):
> >> CFS: 325.49 +/- 1.22 fps -> 251.68 +/- 2.32 fps
> >> BFS: 334.94 +/- 0.59 fps -> 344.47 +/- 0.68 fps
> >>
> >> HD encoding (before -> after patch):
> >> CFS: 39.05 +/- 0.22 fps -> 40.56 +/- 0.23 fps
> >> BFS: 40.15 +/- 0.05 fps -> 44.89 +/- 0.05 fps
> >>
> >> As can be seen, the longer the threads live (the lower the fps), the
> >> less horrific the penalty is.  Furthermore, though I don't have
> >> numbers, using schedtool -R -p 1 does basically as well as BFS in
> >> eliminating the problem.  Naturally, this is not really a solution as
> >> it requires root.
> >>
> >> To replicate this test, a commandline like this should work on any
> >> cached raw input file (a collection of free raw videos can be found
> >> here if you don't like making your own:
> >> http://media.xiph.org/video/derf/ ):
> >>
> >> ./x264 --preset superfast --tune zerolatency --threads X input -o /dev/null
> >
> > On my Q6600 box, neither scheduler (identical configs) seems to like
> > --tune zerolatency much.
> 
> Sliced-threads (zero latency mode) should probably never be run with
> more threads than cores -- virtual cores, at the very least.  8
> threads on a quad-core is definitely not the best idea.

Ok.

> Your tests are very very short so I suspect the standard deviation of
> those tests is so high as to obscure any actual results; please always
> remember to post error bars.  A test that only lasts for 2 seconds can
> easily have +/- 50fps of error.

No.  Results are plenty repeatable enough that 'problem' sticks out far
above s/n.  No idea what to do with this, but 'tree' seems significant.

-Mike


-Mike

