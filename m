Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760241Ab2EIQaT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 12:30:19 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:35704 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755761Ab2EIQaR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 12:30:17 -0400
MIME-Version: 1.0
In-Reply-To: <1336580669.16079.68.camel@marge.simpson.net>
References: <CABS55+A_ZbJT4Tz-XfacbURpgfx2WuXqvPnn1_XkAfhxJMP6eA@mail.gmail.com>
 <1336580669.16079.68.camel@marge.simpson.net>
From: Jason Garrett-Glaser <jason@x264.com>
Date: Wed, 9 May 2012 09:29:35 -0700
X-Google-Sender-Auth: JBQ3ANYsNfLEmqmNhgPZE3uCxoQ
Message-ID: <CABS55+Ayu9nM2QEnb1154f115Q4GmrKzaY=VKBoVwEA17=A8Jg@mail.gmail.com>
Subject: Re: Scheduler still seems awful with x264, worse with patches
To: Mike Galbraith <efault@gmx.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 9, 2012 at 9:24 AM, Mike Galbraith <efault@gmx.de> wrote:
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
>
> I took x264 for a quick test drive a short while ago, and it looks like
> we slipped a bit.  I didn't have time to futz with it much, but did find
> that SCHED_IDLE kicked SCHED_OTHER's butt.  x264 really really wants RR.

Do remember to separate frame and slice threading in tests; they work
totally differently and, while you might be able to kill two birds
with one stone sometimes, some particular tuning might not affect both
in the same way.

Slice-threading is probably harder in general because the threads last
far less time, and that seems to be the thing that angers CFS.

Note also that my patch slice-threads the lookahead, even if the main
encode is frame-threaded.  This is because for various reasons
frame-threading the lookahead may be harder and more difficult, so I
decided to do it this way (and it worked on Windows, so...).  Note
also that when using automatic lookahead threads (default in that
patch), x264 currently does:

number of lookahead threads = MIN( sliced threads ? threads : threads / 6, 16 );

Jason
