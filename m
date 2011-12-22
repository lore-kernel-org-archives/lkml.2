Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756091Ab1LVX05 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 18:26:57 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:36210 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751334Ab1LVX0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 18:26:55 -0500
Date: Fri, 23 Dec 2011 08:26:42 +0900
From: Minchan Kim <minchan@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Chris Wright <chrisw@sous-sol.org>,
        Jens Axboe <axboe@kernel.dk>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/6][RFC] virtio-blk: Change I/O path from request to BIO
Message-ID: <20111222232642.GA7056@barrios-laptop.redhat.com>
References: <1324429254-28383-1-git-send-email-minchan@kernel.org>
 <20111221191117.GA27789@redhat.com>
 <20111222010538.GA9879@barrios-laptop.redhat.com>
 <20111222154506.GC1388@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111222154506.GC1388@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 22, 2011 at 10:45:06AM -0500, Vivek Goyal wrote:
> On Thu, Dec 22, 2011 at 10:05:38AM +0900, Minchan Kim wrote:
> 
> [..]
> > > May be using deadline or noop in guest is better to benchmark against
> > > PCI-E based flash.
> > 
> > Good suggestion.
> > I tested it by deadline on guest side.
> > 
> > The result is not good.
> > Although gap is within noise, Batch BIO's random performance is regressed
> > compared to CFQ. 
> > 
> >             Request                Batch BIO
> > 
> >          (MB/s)  stddev          (MB/s)  stddev
> > w        787.030 31.494 w        748.714 68.490
> > rw       216.044 29.734 rw       216.977 40.635
> > r        771.765 3.327  r        771.107 4.299
> > rr       280.096 25.135 rr       258.067 43.916
> > 
> > I did some small test for only Batch BIO with deadline and cfq.
> > to see I/O scheduler's effect.
> > I think result is very strange, deadline :149MB, CFQ : 87M
> > Because Batio BIO patch uses make_request_fn instead of request_rfn.
> > So I think we should not affect by I/O scheduler.(I mean we issue I/O 
> > before I/O scheduler handles it)
> > 
> > What do you think about it?
> > Do I miss something?
> 
> This indeed is very strange. In case of bio based drivers, changing IO
> scheduler on the queue should not change anything.
> 
> Trying running blktrace on the vda devie and see if you notice something
> odd.
> 
> Also you seem to be reporting contracdicting results for batch bio.
> 
> Initially you mention that random IO is regressing with deadline as
> comapred to CFQ. (It dropped from 325.976 MB/s to 258.067 MB/s).
> 
> In this second test you are reporting that CFQ performs badly as
> compared to deadline. (149MB/s vs 87MB/s).

First test is with 64 thread with 512M and second test is only 1 thread with 128M
for finishing quick.
I think so result is very stange.

This is data on test of deadline.
In summary, data is very fluctuated.

Sometime it's very stable but sometime data is very fluctuated like this.
I don't know it's aio-stress problem or fusion I/O stuff problem

1)
[root@RHEL-6 ~]# ./aio-stress -c 1 -t 1 -s 128 -r 8 -O -o 3 -d 512 /dev/vda
num_thread 1
adding stage random read
starting with random read
file size 128MB, record size 8KB, depth 512, ios per iteration 8
max io_submit 8, buffer alignment set to 4KB
threads 1 files 1 contexts 1 context offset 2MB verification off
Running single thread version 
random read on /dev/vda (151.71 MB/s) 128.00 MB in 0.84s
thread 0 random read totals (151.55 MB/s) 128.00 MB in 0.84s

2)
[root@RHEL-6 ~]# ./aio-stress -c 1 -t 1 -s 128 -r 8 -O -o 3 -d 512 /dev/vda
num_thread 1
adding stage random read
starting with random read
file size 128MB, record size 8KB, depth 512, ios per iteration 8
max io_submit 8, buffer alignment set to 4KB
threads 1 files 1 contexts 1 context offset 2MB verification off
Running single thread version 
random read on /dev/vda (201.04 MB/s) 128.00 MB in 0.64s
thread 0 random read totals (200.76 MB/s) 128.00 MB in 0.64s

3)
[root@RHEL-6 ~]# ./aio-stress -c 1 -t 1 -s 128 -r 8 -O -o 3 -d 512 /dev/vda
num_thread 1
adding stage random read
starting with random read
file size 128MB, record size 8KB, depth 512, ios per iteration 8
max io_submit 8, buffer alignment set to 4KB
threads 1 files 1 contexts 1 context offset 2MB verification off
Running single thread version 
random read on /dev/vda (135.31 MB/s) 128.00 MB in 0.95s
thread 0 random read totals (135.19 MB/s) 128.00 MB in 0.95s

4)
[root@RHEL-6 ~]# ./aio-stress -c 1 -t 1 -s 128 -r 8 -O -o 3 -d 512 /dev/vda
num_thread 1
adding stage random read
starting with random read
file size 128MB, record size 8KB, depth 512, ios per iteration 8
max io_submit 8, buffer alignment set to 4KB
threads 1 files 1 contexts 1 context offset 2MB verification off
Running single thread version 
random read on /dev/vda (116.93 MB/s) 128.00 MB in 1.09s
thread 0 random read totals (116.82 MB/s) 128.00 MB in 1.10s

5)
[root@RHEL-6 ~]# ./aio-stress -c 1 -t 1 -s 128 -r 8 -O -o 3 -d 512 /dev/vda
num_thread 1
adding stage random read
starting with random read
file size 128MB, record size 8KB, depth 512, ios per iteration 8
max io_submit 8, buffer alignment set to 4KB
threads 1 files 1 contexts 1 context offset 2MB verification off
Running single thread version 
random read on /dev/vda (130.79 MB/s) 128.00 MB in 0.98s
thread 0 random read totals (130.65 MB/s) 128.00 MB in 0.98s

> 
> Two contradicting results?

Hmm, I need test in /tmp/ to prevent it.

> 
> Thanks
> Vivek

-- 
Kind regards,
Minchan Kim
