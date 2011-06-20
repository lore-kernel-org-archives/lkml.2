Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755019Ab1FTOeQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 10:34:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10205 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754378Ab1FTOeP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 10:34:15 -0400
Date: Mon, 20 Jun 2011 10:34:11 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
Cc: Tao Ma <tm@tao.ma>
Subject: Re: [PATCH] cfq: Fix starvation of async writes in presence of heavy
 sync workload
Message-ID: <20110620143411.GB4749@redhat.com>
References: <20110620141631.GA4749@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110620141631.GA4749@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 20, 2011 at 10:16:31AM -0400, Vivek Goyal wrote:
> In presence of heavy sync workload CFQ can starve asnc writes.
> If one launches multiple readers (say 16), then one can notice
> that CFQ can withhold dispatch of WRITEs for a very long time say
> 200 or 300 seconds.
> 
> Basically CFQ schedules an async queue but does not dispatch any
> writes because it is waiting for exisintng sync requests in queue to
> finish. While it is waiting, one or other reader gets queued up and
> preempts the async queue. So we did schedule the async queue but never
> dispatched anything from it. This can repeat for long time hence
> practically starving Writers.
> 
> This patch allows async queue to dispatch atleast 1 requeust once
> it gets scheduled and denies preemption if async queue has been
> waiting for sync requests to drain and has not been able to dispatch
> a request yet.
> 
> One concern with this fix is that how does it impact readers
> in presence of heavy writting going on.
> 
> I did a test where I launch firefox, load a website and close
> firefox and measure the time. I ran the test 3 times and took
> average.
> 
> - Vanilla kernel time ~= 1 minute 40 seconds
> - Patched kenrel time ~= 1 minute 35 seconds
> 

Forgot to mention that this was in the presence of a dd doing
writes.

dd if=/dev/zero of=zerofile bs=4K count=1M

Launching firefox takes around 25 seconds or so. Loading first
website takes a long time. I had a quick look at blktrace
and it I see for long time no reads are queued at all. Looks
like firefox has some dependency on some write to finish
before next read can be issued.

Thanks
Vivek
