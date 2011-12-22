Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754527Ab1LVBFz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 20:05:55 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:34865 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663Ab1LVBFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 20:05:50 -0500
Date: Thu, 22 Dec 2011 10:05:38 +0900
From: Minchan Kim <minchan@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Chris Wright <chrisw@sous-sol.org>,
        Jens Axboe <axboe@kernel.dk>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/6][RFC] virtio-blk: Change I/O path from request to BIO
Message-ID: <20111222010538.GA9879@barrios-laptop.redhat.com>
References: <1324429254-28383-1-git-send-email-minchan@kernel.org>
 <20111221191117.GA27789@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111221191117.GA27789@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vivek,

On Wed, Dec 21, 2011 at 02:11:17PM -0500, Vivek Goyal wrote:
> On Wed, Dec 21, 2011 at 10:00:48AM +0900, Minchan Kim wrote:
> > This patch is follow-up of Christohp Hellwig's work
> > [RFC: ->make_request support for virtio-blk].
> > http://thread.gmane.org/gmane.linux.kernel/1199763
> > 
> > Quote from hch
> > "This patchset allows the virtio-blk driver to support much higher IOP
> > rates which can be driven out of modern PCI-e flash devices.  At this
> > point it really is just a RFC due to various issues."
> > 
> > I fixed race bug and add batch I/O for enhancing sequential I/O,
> > FLUSH/FUA emulation.
> > 
> > I tested this patch on fusion I/O device by aio-stress.
> > Result is following as.
> > 
> > Benchmark : aio-stress (64 thread, test file size 512M, 8K io per IO, O_DIRECT write)
> > Environment: 8 socket - 8 core, 2533.372Hz, Fusion IO 320G storage
> > Test repeated by 20 times
> > Guest I/O scheduler : CFQ
> > Host I/O scheduler : NOOP
> 
> May be using deadline or noop in guest is better to benchmark against
> PCI-E based flash.

Good suggestion.
I tested it by deadline on guest side.

The result is not good.
Although gap is within noise, Batch BIO's random performance is regressed
compared to CFQ. 

            Request                Batch BIO

         (MB/s)  stddev          (MB/s)  stddev
w        787.030 31.494 w        748.714 68.490
rw       216.044 29.734 rw       216.977 40.635
r        771.765 3.327  r        771.107 4.299
rr       280.096 25.135 rr       258.067 43.916

I did some small test for only Batch BIO with deadline and cfq.
to see I/O scheduler's effect.
I think result is very strange, deadline :149MB, CFQ : 87M
Because Batio BIO patch uses make_request_fn instead of request_rfn.
So I think we should not affect by I/O scheduler.(I mean we issue I/O 
before I/O scheduler handles it)

What do you think about it?
Do I miss something?


1) deadline
[root@RHEL-6 ~]# ./aio-stress -c 1 -t 1 -s 128 -r 8 -O -o 3 -d 512 /dev/vda
num_thread 1
adding stage random read
starting with random read
file size 128MB, record size 8KB, depth 512, ios per iteration 8
max io_submit 8, buffer alignment set to 4KB
threads 1 files 1 contexts 1 context offset 2MB verification off
Running single thread version 
random read on /dev/vda (149.40 MB/s) 128.00 MB in 0.86s
thread 0 random read totals (149.22 MB/s) 128.00 MB in 0.86s


2) cfq
[root@RHEL-6 ~]# ./aio-stress -c 1 -t 1 -s 128 -r 8 -O -o 3 -d 512 /dev/vda
num_thread 1
adding stage random read
starting with random read
file size 128MB, record size 8KB, depth 512, ios per iteration 8
max io_submit 8, buffer alignment set to 4KB
threads 1 files 1 contexts 1 context offset 2MB verification off
Running single thread version 
random read on /dev/vda (87.21 MB/s) 128.00 MB in 1.47s
thread 0 random read totals (87.15 MB/s) 128.00 MB in 1.47s


> 
> Thanks
> Vivek

-- 
Kind regards,
Minchan Kim
