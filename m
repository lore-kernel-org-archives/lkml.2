Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751534Ab2ABHtR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 02:49:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40621 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751089Ab2ABHtO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 02:49:14 -0500
Message-ID: <4F01615E.1000301@redhat.com>
Date: Mon, 02 Jan 2012 09:48:46 +0200
From: Dor Laor <dlaor@redhat.com>
Reply-To: dlaor@redhat.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Stefan Hajnoczi <stefanha@gmail.com>
CC: Minchan Kim <minchan@kernel.org>, Rusty Russell <rusty@rustcorp.com.au>,
        Chris Wright <chrisw@sous-sol.org>, Jens Axboe <axboe@kernel.dk>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 0/6][RFC] virtio-blk: Change I/O path from request to
 BIO
References: <1324429254-28383-1-git-send-email-minchan@kernel.org> <CAJSP0QW5wPYcHr02oNm8Y8=hsChEb5tJuO0ntPy9MO8EPuH=Qg@mail.gmail.com> <20111222234135.GB7056@barrios-laptop.redhat.com> <CAJSP0QWpzOGtQEULu7yz1vDEExSatGpdEPSvvDx=oNYkBveyrQ@mail.gmail.com>
In-Reply-To: <CAJSP0QWpzOGtQEULu7yz1vDEExSatGpdEPSvvDx=oNYkBveyrQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/01/2012 06:45 PM, Stefan Hajnoczi wrote:
> On Thu, Dec 22, 2011 at 11:41 PM, Minchan Kim<minchan@kernel.org>  wrote:
>> On Thu, Dec 22, 2011 at 12:57:40PM +0000, Stefan Hajnoczi wrote:
>>> On Wed, Dec 21, 2011 at 1:00 AM, Minchan Kim<minchan@kernel.org>  wrote:
>>> If you're stumped by the performance perhaps compare blktraces of the
>>> request approach vs the bio approach.  We're probably performing I/O
>>> more CPU-efficiently but the I/O pattern itself is worse.
>>
>> You mean I/O scheduler have many techniques to do well in I/O pattern?
>> That's what I want to discuss in this RFC.
>>
>> I guess request layer have many techniques proved during long time
>> to do well I/O but BIO-based drvier ignores them for just reducing locking
>> overhead. Of course, we can add such techniques to BIO-batch driver like
>> custom-batch in this series. But it needs lots of work, is really duplication,
>> and will have a problem on maintenance.
>>
>> I would like to listen opinions whether this direction is good or bad.
>
> This series is a good platform for performance analysis but not
> something that should be merged IMO.  As you said it duplicates work
> that I/O schedulers and the request-based block layer do.  If other
> drivers start taking this approach too then the duplication will be
> proliferated.
>
> The value of this series is that you have a prototype to benchmark and
> understand the bottlenecks in virtio-blk and the block layer better.
> The results do not should that bypassing the I/O scheduler is always a
> win.  The fact that you added batching suggests there is some benefit
> to what the request-based code path does.  So find out what's good
> about the request-based code path and how to get the best of both
> worlds.
>
> By the way, drivers for solid-state devices can set QUEUE_FLAG_NONROT
> to hint that seek time optimizations may be sub-optimal.  NBD and
> other virtual/pseudo device drivers set this flag.  Should virtio-blk
> set it and how does it affect performance?

Seems logical to me. If the underlying backing storage of the host is 
SSD or some remote fast SAN server we need such a flag. Even in the case 
of standard local storage, the host will still do the seek time 
optimization so no need to do them twice.

>
> Stefan
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

