Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754805Ab0GMTiR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 15:38:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753350Ab0GMTiQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 15:38:16 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Corrado Zoccolo <czoccolo@gmail.com>, axboe@kernel.dk
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>,
        Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 0/2] cfq-iosched: fixing RQ_NOIDLE handling.
References: <AANLkTim1wmWOJTbzrQgqQnB_VHJF8gWfr41DbjP9r8AJ@mail.gmail.com>
	<x49eiffusvn.fsf@segfault.boston.devel.redhat.com>
	<AANLkTikulpqCK169_bIiXrHQtZIhsQpp_siBIvnahCVn@mail.gmail.com>
	<x49vd8rt5ub.fsf@segfault.boston.devel.redhat.com>
	<AANLkTilgHqtb1FbgK-d1vW6MyIyOT6MtpCcMmQcGlc7t@mail.gmail.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 13 Jul 2010 15:38:11 -0400
In-Reply-To: <AANLkTilgHqtb1FbgK-d1vW6MyIyOT6MtpCcMmQcGlc7t@mail.gmail.com>
	(Corrado Zoccolo's message of "Fri, 9 Jul 2010 12:33:36 +0200")
Message-ID: <x49eif7p3z0.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Corrado Zoccolo <czoccolo@gmail.com> writes:

> Can you test the attached patch, where I also added your changes to
> make jbd(2) to perform sync writes?

I got new storage, so I have new numbers.  I only re-ran deadline and
vanilla cfq for the fs_mark only test.  The average of 10 runs comes out
like so:

deadline:    571.98
vanilla cfq: 107.42
patched cfq: 460.9

Mixed workload results with your suggested patch:

fs_mark: 15.65 files/sec
fio: 132.5 MB/s

So, again, not looking great for the mixed workload, but the patch
does improve the fs_mark only case.  Looking at the blktrace data shows
that the jbd2 thread preempts the fs_mark thread at all the right
times.  The only thing holding throughput back is the whole notion that
we need to only dispatch from one queue (even though the storage is
capable of serving both the reads and writes simultaneously).

I added in the patch that allows the simultaneous dispatch of both reads
and writes, and here are the results from that run:

fs_mark: 15.975 files/sec
fio: 132.4 MB/s

So, it looks like that didn't help.  The reason this patch doesn't come
close to the yield patch in the mixed workload is because the yield
patch set allows the fs_mark process to continue to issue I/O.  With
your patch, the fs_mark process does 64KB of I/O, the jbd2 thread does
the journal commit, and then the fio process runs again.  Given that the
fs_mark process typically only uses a small fraction of its time slice,
you end up with an unfair balance.

Now, we still have to decide whether that's a problem that needs
solving.  I tried to gather data from the field, but I've been unable to
conclusively say whether an application issues this sort of dependent
I/O.

As such, I am happy with this patch.  If we see that we need something
like the blk_yield approach, then I'm happy to resurrect that work.

Jens, do you find that an agreeable solution?  If so, you can add my
signed-off-by and tested-by to the patch that Corrado posted.

Cheers,
Jeff
