Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759847Ab0FJWZn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 18:25:43 -0400
Received: from sprinkles.athenacr.com ([64.95.46.210]:9439 "EHLO
	sprinkles.inp.in.athenacr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759709Ab0FJWZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 18:25:42 -0400
Message-ID: <4C116652.8010408@athenacr.com>
Date: Thu, 10 Jun 2010 18:25:22 -0400
From: Brian Bloniarz <bmb@athenacr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: Chris Wedgwood <cw@f00f.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>, Greg KH <gregkh@suse.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Jef Driesen <jefdriesen@telenet.be>, linux-kernel@vger.kernel.org
Subject: Re: Slow pty's (was Re: libdivecomputer interfaces?)
References: <AANLkTinLth4iKXAwszEEsPm_9ZDlj8HtqsiG5cdFE1cZ@mail.gmail.com> <20100610181042.GA19210@puku.stupidest.org>
In-Reply-To: <20100610181042.GA19210@puku.stupidest.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10/2010 02:10 PM, Chris Wedgwood wrote:
> (sorry if this reponse isn't on target, i was just pointed to this
> thread a few minutes ago)
> 
> 
> On Thu, Jun 10, 2010 at 10:25:36AM -0700, Linus Torvalds wrote:
> 
>>  I thought we long since (ie back last fall) fixed the latency
>> problems with pty's, but there does seem to be something very fishy
>> going on there still.
> 
> this might not be related, but i have slow serial ports with NOHZ that
> goes away when i revert 39c0cbe2150cbd848a25ba6cdb271d1ad46818ad.

Unrelated or not, I think Chris is right about this. Somewhere before
-rc1, the emulated serial console on my KVM instance became slow
to echo input. I just tested with the commit reverted and it's
back to normal.

> commit 39c0cbe2150cbd848a25ba6cdb271d1ad46818ad
> Author: Mike Galbraith <efault@gmx.de>
> Date:   Thu Mar 11 17:17:13 2010 +0100
> 
>     sched: Rate-limit nohz
> 
>     Entering nohz code on every micro-idle is costing ~10% throughput for netperf
>     TCP_RR when scheduling cross-cpu.  Rate limiting entry fixes this, but raises
>     ticks a bit.  On my Q6600, an idle box goes from ~85 interrupts/sec to 128.
> 
>     The higher the context switch rate, the more nohz entry costs.  With this patch
>     and some cycle recovery patches in my tree, max cross cpu context switch rate is
>     improved by ~16%, a large portion of which of which is this ratelimiting.
> 
> and looking at the only two interesting hunks it's not clear why:
> 
> +int nohz_ratelimit(int cpu)
> +{
> +       struct rq *rq = cpu_rq(cpu);
> +       u64 diff = rq->clock - rq->nohz_stamp;
> +
> +       rq->nohz_stamp = rq->clock;
> +
> +       return diff < (NSEC_PER_SEC / HZ) >> 1;
> +}
> 
> +       if (nohz_ratelimit(cpu))
> +               goto end;
> +
> 
> network latnecy is fine, and if i create lots of wakeups (network IO
> is fine) then the serial port latency is noticable
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

