Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759178Ab0FJSUc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 14:20:32 -0400
Received: from parsec.stupidest.org ([71.6.196.126]:45690 "EHLO
	parsec.stupidest.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751963Ab0FJSUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 14:20:31 -0400
X-Greylist: delayed 588 seconds by postgrey-1.27 at vger.kernel.org; Thu, 10 Jun 2010 14:20:31 EDT
Date: Thu, 10 Jun 2010 11:10:42 -0700
From: Chris Wedgwood <cw@f00f.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg KH <gregkh@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Jef Driesen <jefdriesen@telenet.be>, linux-kernel@vger.kernel.org
Subject: Re: Slow pty's (was Re: libdivecomputer interfaces?)
Message-ID: <20100610181042.GA19210@puku.stupidest.org>
References: <AANLkTinLth4iKXAwszEEsPm_9ZDlj8HtqsiG5cdFE1cZ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinLth4iKXAwszEEsPm_9ZDlj8HtqsiG5cdFE1cZ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(sorry if this reponse isn't on target, i was just pointed to this
thread a few minutes ago)


On Thu, Jun 10, 2010 at 10:25:36AM -0700, Linus Torvalds wrote:

>  I thought we long since (ie back last fall) fixed the latency
> problems with pty's, but there does seem to be something very fishy
> going on there still.

this might not be related, but i have slow serial ports with NOHZ that
goes away when i revert 39c0cbe2150cbd848a25ba6cdb271d1ad46818ad.


commit 39c0cbe2150cbd848a25ba6cdb271d1ad46818ad
Author: Mike Galbraith <efault@gmx.de>
Date:   Thu Mar 11 17:17:13 2010 +0100

    sched: Rate-limit nohz

    Entering nohz code on every micro-idle is costing ~10% throughput for netperf
    TCP_RR when scheduling cross-cpu.  Rate limiting entry fixes this, but raises
    ticks a bit.  On my Q6600, an idle box goes from ~85 interrupts/sec to 128.

    The higher the context switch rate, the more nohz entry costs.  With this patch
    and some cycle recovery patches in my tree, max cross cpu context switch rate is
    improved by ~16%, a large portion of which of which is this ratelimiting.

and looking at the only two interesting hunks it's not clear why:

+int nohz_ratelimit(int cpu)
+{
+       struct rq *rq = cpu_rq(cpu);
+       u64 diff = rq->clock - rq->nohz_stamp;
+
+       rq->nohz_stamp = rq->clock;
+
+       return diff < (NSEC_PER_SEC / HZ) >> 1;
+}

+       if (nohz_ratelimit(cpu))
+               goto end;
+

network latnecy is fine, and if i create lots of wakeups (network IO
is fine) then the serial port latency is noticable
