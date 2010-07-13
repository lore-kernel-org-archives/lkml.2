Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757052Ab0GMT46 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 15:56:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61782 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752906Ab0GMT45 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 15:56:57 -0400
Date: Tue, 13 Jul 2010 15:56:50 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Corrado Zoccolo <czoccolo@gmail.com>, axboe@kernel.dk,
        Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] cfq-iosched: fixing RQ_NOIDLE handling.
Message-ID: <20100713195650.GA21044@redhat.com>
References: <AANLkTim1wmWOJTbzrQgqQnB_VHJF8gWfr41DbjP9r8AJ@mail.gmail.com>
 <x49eiffusvn.fsf@segfault.boston.devel.redhat.com>
 <AANLkTikulpqCK169_bIiXrHQtZIhsQpp_siBIvnahCVn@mail.gmail.com>
 <x49vd8rt5ub.fsf@segfault.boston.devel.redhat.com>
 <AANLkTilgHqtb1FbgK-d1vW6MyIyOT6MtpCcMmQcGlc7t@mail.gmail.com>
 <x49eif7p3z0.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x49eif7p3z0.fsf@segfault.boston.devel.redhat.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 13, 2010 at 03:38:11PM -0400, Jeff Moyer wrote:
> Corrado Zoccolo <czoccolo@gmail.com> writes:
> 
> > Can you test the attached patch, where I also added your changes to
> > make jbd(2) to perform sync writes?
> 
> I got new storage, so I have new numbers.  I only re-ran deadline and
> vanilla cfq for the fs_mark only test.  The average of 10 runs comes out
> like so:
> 
> deadline:    571.98
> vanilla cfq: 107.42
> patched cfq: 460.9
> 
> Mixed workload results with your suggested patch:
> 
> fs_mark: 15.65 files/sec
> fio: 132.5 MB/s
> 
> So, again, not looking great for the mixed workload, but the patch
> does improve the fs_mark only case.  Looking at the blktrace data shows
> that the jbd2 thread preempts the fs_mark thread at all the right
> times.  The only thing holding throughput back is the whole notion that
> we need to only dispatch from one queue (even though the storage is
> capable of serving both the reads and writes simultaneously).
> 
> I added in the patch that allows the simultaneous dispatch of both reads
> and writes, and here are the results from that run:
> 
> fs_mark: 15.975 files/sec
> fio: 132.4 MB/s
> 
> So, it looks like that didn't help.  The reason this patch doesn't come
> close to the yield patch in the mixed workload is because the yield
> patch set allows the fs_mark process to continue to issue I/O.  With
> your patch, the fs_mark process does 64KB of I/O, the jbd2 thread does
> the journal commit, and then the fio process runs again.  Given that the
> fs_mark process typically only uses a small fraction of its time slice,
> you end up with an unfair balance.

Hi Jeff,

This is little strange. Given the fact that now both fs_mark and jbd
threads are on sync-noidle tree, we should have idled on sync-noidle
tree to provide fairness and that should have made sure that fs_mark/jbd
do more IO and slice is not lost to fio thread.

Not sure what is happening though in practice. Only you can look at
traces more closely and see if timer is being armed or not. 

Thanks
Vivek
