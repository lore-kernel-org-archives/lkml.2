Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754984Ab2EJK3u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 06:29:50 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:32954 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750848Ab2EJK3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 06:29:49 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+a+rFawSSagvfJolhBZR4H8ysRdo9zwqefUfhAER
	kCe5ApPfHKSINp
Message-ID: <1336645785.25483.3.camel@marge.simpson.net>
Subject: Re: Scheduler still seems awful with x264, worse with patches
From: Mike Galbraith <efault@gmx.de>
To: Jason Garrett-Glaser <jason@x264.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Thu, 10 May 2012 12:29:45 +0200
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
> 
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

On my Q6600 box, neither scheduler (identical configs) seems to like
--tune zerolatency much.

# ultrafast
x264 --quiet --no-progress --preset ultrafast --no-scenecut --sync-lookahead 0 --qp 20 -o /dev/null --threads $1 ./soccer_4cif.y4m
x264 --quiet --no-progress --preset ultrafast --tune zerolatency --no-scenecut --sync-lookahead 0 --qp 20 -o /dev/null --threads $1 ./soccer_4cif.y4m
x264 --quiet --no-progress --preset ultrafast --tune zerolatency -o /dev/null --threads $1 ./soccer_4cif.y4m

                    3.3.0-bfs          3.3.0-cfs
marge:~/tmp # ./x264.sh 8

encoded 600 frames, 449.63 fps         400.20 fps
encoded 600 frames, 355.00 fps         304.12 fps
encoded 600 frames, 305.65 fps         267.25 fps

marge:~/tmp # schedctl -I ./x264.sh 8

encoded 600 frames, 475.00 fps         483.19 fps
encoded 600 frames, 364.72 fps         278.37 fps
encoded 600 frames, 311.69 fps         256.25 fps

marge:~/tmp # schedctl -R ./x264.sh 8

encoded 600 frames, 454.70 fps         489.00 fps
encoded 600 frames, 358.83 fps         365.61 fps
encoded 600 frames, 308.81 fps         310.46 fps


