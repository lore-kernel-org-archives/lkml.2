Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752906Ab2EJQXB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 12:23:01 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:42935 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751261Ab2EJQW7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 12:22:59 -0400
MIME-Version: 1.0
In-Reply-To: <1336645785.25483.3.camel@marge.simpson.net>
References: <CABS55+A_ZbJT4Tz-XfacbURpgfx2WuXqvPnn1_XkAfhxJMP6eA@mail.gmail.com>
 <1336645785.25483.3.camel@marge.simpson.net>
From: Jason Garrett-Glaser <jason@x264.com>
Date: Thu, 10 May 2012 09:22:17 -0700
X-Google-Sender-Auth: EMIHFrmoqNNUj8ZDkWt-6kFls3U
Message-ID: <CABS55+DrvJ3QByW6i9gnYCq+ayD3r7oVkRVW73Hj4-zGBKFoKw@mail.gmail.com>
Subject: Re: Scheduler still seems awful with x264, worse with patches
To: Mike Galbraith <efault@gmx.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2012 at 3:29 AM, Mike Galbraith <efault@gmx.de> wrote:
> On Wed, 2012-05-09 at 09:00 -0700, Jason Garrett-Glaser wrote:
>> Many months ago, the topic of CFS's inefficiencies with x264 came up
>> and some improvements were made, but BFS and Windows still stayed a
>> little bit in the lead.  This seemed to be because of a mix of two
>> issues.  Firstly, a combination of relatively short-lived jobs (x264
>> uses a thread pool, so the actual threads are long-lived).  Secondly,
>> in frame threads, heavy dependencies between threads, benefiting
>> greatly from a dumb scheduler.  Thirdly, in sliced threads -- the
>> focus of this post -- the best scheduling approach is to simply spread
>> them throughout the cores and do nothing, so again, a dumb scheduler
>> will do the right thing.
>>
>> Recently I tried multithreading x264's lookahead for a customer.  The
>> lookahead previously wasn't threaded, causing bottlenecks with many
>> cores and threads.  I do my development mainly on Windows, and the
>> patch looked to be quite a success, with nice performance boosts for
>> many target use-cases.
>>
>> And then I ran it on Linux and it choked horribly.
>>
>> The patch is here:
>> https://github.com/DarkShikari/x264-devel/commit/99e830f1581eac3cf30f07b1d6c6c32bae1725c8
>> .  To replicate the test, simply test that version against the
>> previous version.  My guess is the reason it chokes is that it
>> involves spawning even *shorter*-lived jobs than x264 typically does,
>> something that CFS seems to simply collapse on.
>>
>> Here's some stats from a recent kernel:
>>
>> SD encoding (before -> after patch):
>> CFS: 325.49 +/- 1.22 fps -> 251.68 +/- 2.32 fps
>> BFS: 334.94 +/- 0.59 fps -> 344.47 +/- 0.68 fps
>>
>> HD encoding (before -> after patch):
>> CFS: 39.05 +/- 0.22 fps -> 40.56 +/- 0.23 fps
>> BFS: 40.15 +/- 0.05 fps -> 44.89 +/- 0.05 fps
>>
>> As can be seen, the longer the threads live (the lower the fps), the
>> less horrific the penalty is.  Furthermore, though I don't have
>> numbers, using schedtool -R -p 1 does basically as well as BFS in
>> eliminating the problem.  Naturally, this is not really a solution as
>> it requires root.
>>
>> To replicate this test, a commandline like this should work on any
>> cached raw input file (a collection of free raw videos can be found
>> here if you don't like making your own:
>> http://media.xiph.org/video/derf/ ):
>>
>> ./x264 --preset superfast --tune zerolatency --threads X input -o /dev/null
>
> On my Q6600 box, neither scheduler (identical configs) seems to like
> --tune zerolatency much.

Sliced-threads (zero latency mode) should probably never be run with
more threads than cores -- virtual cores, at the very least.  8
threads on a quad-core is definitely not the best idea.

Your tests are very very short so I suspect the standard deviation of
those tests is so high as to obscure any actual results; please always
remember to post error bars.  A test that only lasts for 2 seconds can
easily have +/- 50fps of error.

Jason
