Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754671Ab1HCKyy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 06:54:54 -0400
Received: from merlin.infradead.org ([205.233.59.134]:42478 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753639Ab1HCKys convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 06:54:48 -0400
Subject: Re: perf complains losting events
From: Peter Zijlstra <peterz@infradead.org>
To: Han Pingtian <phan@redhat.com>
Cc: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>, jolsa@redhat.com
In-Reply-To: <20110803102858.GB2790@hpt.nay.redhat.com>
References: <20110803102858.GB2790@hpt.nay.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 03 Aug 2011 12:54:11 +0200
Message-ID: <1312368852.1147.290.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-08-03 at 18:28 +0800, Han Pingtian wrote:
> Hi,
> 
> I find there is a comment about losting events:
> 
> /*
>  * The kernel collects the number of events it couldn't send in a stretch and
>  * when possible sends this number in a PERF_RECORD_LOST event. The number of
>  * such "chunks" of lost events is stored in .nr_events[PERF_EVENT_LOST] while
>  * total_lost tells exactly how many events the kernel in fact lost, i.e. it is
>  * the sum of all struct lost_event.lost fields reported.
>  *
>  * The total_period is needed because by default auto-freq is used, so
>  * multipling nr_events[PERF_EVENT_SAMPLE] by a frequency isn't possible to get
>  * the total number of low level events, it is necessary to to sum all struct
>  * sample_event.period and stash the result in total_period.
>  */
> 
> So my question is, whether the losting of events is a problem? 
> I have saw it many times:
> 
> [root@hp-dl580g7-01 perf]# ./perf kmem record sleep 1
> [ perf record: Woken up 0 times to write data ]
> [ perf record: Captured and wrote 21.789 MB perf.data (~951977 samples)
> ]
> Processed 0 events and LOST 76148!
> 
> Check IO/CPU overload!
> 
> [root@hp-dl580g7-01 perf]# ./perf kmem stat
> Processed 0 events and LOST 76148!
> 
> Check IO/CPU overload!
> 
> 
> SUMMARY
> =======
> Total bytes requested: 5725028
> Total bytes allocated: 6291512
> Total bytes wasted on internal fragmentation: 566484
> Internal fragmentation: 9.003941%
> Cross CPU allocations: 28/84295

Just means there's too many event to process, if you run record as a
realtime task its less:

$ perf record -a -r 1 -R -f -c 1 -e kmem:kmalloc -e kmem:kmalloc_node -e
kmem:kfree -e kmem:kmem_cache_alloc -e kmem:kmem_cache_alloc_node -e
kmem:kmem_cache_free -- sleep 2
[ perf record: Woken up 2 times to write data ]
[ perf record: Captured and wrote 3.642 MB perf.data (~159113 samples) ]
Processed 0 events and LOST 7213!

On the question on if its a problem, that very much depends on what you
want to do and what kind of precision you need from you data..

I suspect that once we start writing one file per cpu this again will
improve somewhat. Acme was going to work on that.. dunno what his plans
are.
