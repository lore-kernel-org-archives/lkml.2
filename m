Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752728Ab2AAQps (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jan 2012 11:45:48 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:40823 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925Ab2AAQpo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jan 2012 11:45:44 -0500
MIME-Version: 1.0
In-Reply-To: <20111222234135.GB7056@barrios-laptop.redhat.com>
References: <1324429254-28383-1-git-send-email-minchan@kernel.org>
	<CAJSP0QW5wPYcHr02oNm8Y8=hsChEb5tJuO0ntPy9MO8EPuH=Qg@mail.gmail.com>
	<20111222234135.GB7056@barrios-laptop.redhat.com>
Date: Sun, 1 Jan 2012 16:45:42 +0000
Message-ID: <CAJSP0QWpzOGtQEULu7yz1vDEExSatGpdEPSvvDx=oNYkBveyrQ@mail.gmail.com>
Subject: Re: [PATCH 0/6][RFC] virtio-blk: Change I/O path from request to BIO
From: Stefan Hajnoczi <stefanha@gmail.com>
To: Minchan Kim <minchan@kernel.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Chris Wright <chrisw@sous-sol.org>,
        Jens Axboe <axboe@kernel.dk>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Vivek Goyal <vgoyal@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 22, 2011 at 11:41 PM, Minchan Kim <minchan@kernel.org> wrote:
> On Thu, Dec 22, 2011 at 12:57:40PM +0000, Stefan Hajnoczi wrote:
>> On Wed, Dec 21, 2011 at 1:00 AM, Minchan Kim <minchan@kernel.org> wrote:
>> If you're stumped by the performance perhaps compare blktraces of the
>> request approach vs the bio approach.  We're probably performing I/O
>> more CPU-efficiently but the I/O pattern itself is worse.
>
> You mean I/O scheduler have many techniques to do well in I/O pattern?
> That's what I want to discuss in this RFC.
>
> I guess request layer have many techniques proved during long time
> to do well I/O but BIO-based drvier ignores them for just reducing locking
> overhead. Of course, we can add such techniques to BIO-batch driver like
> custom-batch in this series. But it needs lots of work, is really duplication,
> and will have a problem on maintenance.
>
> I would like to listen opinions whether this direction is good or bad.

This series is a good platform for performance analysis but not
something that should be merged IMO.  As you said it duplicates work
that I/O schedulers and the request-based block layer do.  If other
drivers start taking this approach too then the duplication will be
proliferated.

The value of this series is that you have a prototype to benchmark and
understand the bottlenecks in virtio-blk and the block layer better.
The results do not should that bypassing the I/O scheduler is always a
win.  The fact that you added batching suggests there is some benefit
to what the request-based code path does.  So find out what's good
about the request-based code path and how to get the best of both
worlds.

By the way, drivers for solid-state devices can set QUEUE_FLAG_NONROT
to hint that seek time optimizations may be sub-optimal.  NBD and
other virtual/pseudo device drivers set this flag.  Should virtio-blk
set it and how does it affect performance?

Stefan
