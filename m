Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755035Ab1HCRvQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 13:51:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33533 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754448Ab1HCRvH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 13:51:07 -0400
Date: Wed, 3 Aug 2011 13:51:01 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: Shaohua Li <shli@kernel.org>, Jens Axboe <jaxboe@fusionio.com>,
        linux-kernel@vger.kernel.org
Subject: Re: fio posixaio performance problem
Message-ID: <20110803175101.GC32385@redhat.com>
References: <4E38C314.8070305@cn.fujitsu.com>
 <CANejiEViuKky1A7Xh0MQKBVNMj_fgzwayWyON7hFGfP3wa62SQ@mail.gmail.com>
 <4E3902C7.9050907@cn.fujitsu.com>
 <CANejiEVqFt4j1-qTVnxEAe75z0y010s=ST2XtCDDTqDEQT=EcQ@mail.gmail.com>
 <4E391986.90108@cn.fujitsu.com>
 <20110803154533.GB32385@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110803154533.GB32385@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 03, 2011 at 11:45:33AM -0400, Vivek Goyal wrote:
> On Wed, Aug 03, 2011 at 05:48:54PM +0800, Gui Jianfeng wrote:
> > On 2011-8-3 16:22, Shaohua Li wrote:
> > > 2011/8/3 Gui Jianfeng <guijianfeng@cn.fujitsu.com>:
> > >> On 2011-8-3 15:38, Shaohua Li wrote:
> > >>> 2011/8/3 Gui Jianfeng <guijianfeng@cn.fujitsu.com>:
> > >>>> Hi,
> > >>>>
> > >>>> I ran a fio test to simulate qemu-kvm io behaviour.
> > >>>> When job number is greater than 2, IO performance is
> > >>>> really bad.
> > >>>>
> > >>>> 1 thread: aggrb=15,129KB/s
> > >>>> 4 thread: aggrb=1,049KB/s
> > >>>>
> > >>>> Kernel: lastest upstream
> > >>>>
> > >>>> Any idea?
> > >>>>
> > >>>> ---
> > >>>> [global]
> > >>>> runtime=30
> > >>>> time_based=1
> > >>>> size=1G
> > >>>> group_reporting=1
> > >>>> ioengine=posixaio
> > >>>> exec_prerun='echo 3 > /proc/sys/vm/drop_caches'
> > >>>> thread=1
> > >>>>
> > >>>> [kvmio-1]
> > >>>> description=kvmio-1
> > >>>> numjobs=4
> > >>>> rw=write
> > >>>> bs=4k
> > >>>> direct=1
> > >>>> filename=/mnt/sda4/1G.img
> > >>> Hmm, the test runs always about 15M/s at my side regardless how many threads.
> > >>
> > >> CFQ？
> > > yes.
> > > 
> > >> what's the slice_idle value?
> > > default value. I didn't change it.
> > 
> > Hmm, I use a sata disk, and can reproduce this bug every time...
> 
> Do you have blktrace of run with 4 jobs?

I can't reproduce it too. On my sata disk single thread is getting around
23-24MB/s and 4 threads get around 19-20MB/sec. Some of the throughput
is gone into seeking so that is expected.

I think what you are trying to point out is idling issue. In your workload
every thread is doing sync-idle IO. So idling is enabled on each thread.
On my system I see that next thread preempts the current idle thread 
because they all are doing IO in nearby area of file and rq_close() is
true hence preemption is allowed.

On your system, I think somehow rq_close() is not true hence preemption
does not take place and we continue to idle on that thread. That also
is not necessarily too bad but it might be happening that we are waiting
for completion of IO from some other thread before this thread (we are
idling on) can do more writes due to some filesystem rescrition and
that can lead to sudden throughput drop. blktrace will give some idea.

Thanks
Vivek
