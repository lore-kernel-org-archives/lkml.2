Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753511Ab1FUCPV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 22:15:21 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:61512 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752296Ab1FUCPQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 22:15:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=QzYHTSBgSrmPujll6Zae0aoGM47XQUOEMDrfhysEYSNYmSuyyTCRsJHDymLi+kRQR3
         q9V9XrOl0nGq7ETEEyg0wvSS/0hi5U2Ev5PbygpAOe7z+XHFUEvZuxtAVD1Wzg9Q0O+B
         hdEfJnyJmwWWdUD23CWR+2lHph6x6JJaN1OXI=
MIME-Version: 1.0
In-Reply-To: <20110620141631.GA4749@redhat.com>
References: <20110620141631.GA4749@redhat.com>
Date: Tue, 21 Jun 2011 10:15:15 +0800
X-Google-Sender-Auth: cqrWJZZd3IQeUWu6p-lUb5DM3cE
Message-ID: <BANLkTike3ZhFR9HioPcQWzwXYhszo0-SkA@mail.gmail.com>
Subject: Re: [PATCH] cfq: Fix starvation of async writes in presence of heavy
 sync workload
From: Shaohua Li <shaohua.li@intel.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Tao Ma <tm@tao.ma>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/6/20 Vivek Goyal <vgoyal@redhat.com>:
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
> Basically it looks like that for this test times have not
> changed much for this test. But I would not claim that it does
> not impact reader's latencies at all. It might show up in
> other workloads.
>
> I think we anyway need to fix writer starvation. If this patch
> causes issues, then we need to look at reducing writer's
> queue depth further to improve latencies for readers.
I'm afraid this can causes read latency because cfq_dispatch_requests
doesn't check preempt. we will dispatch 4 requests at least instead of
just one. can we add a logic to force it just dispatches one request?

Thanks,
Shaohua
