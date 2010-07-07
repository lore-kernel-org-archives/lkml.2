Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757533Ab0GGRDS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 13:03:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3773 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757503Ab0GGRDO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 13:03:14 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, Linux-Kernel <linux-kernel@vger.kernel.org>,
       Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 0/2] cfq-iosched: fixing RQ_NOIDLE handling.
References: <AANLkTim1wmWOJTbzrQgqQnB_VHJF8gWfr41DbjP9r8AJ@mail.gmail.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Wed, 07 Jul 2010 13:03:08 -0400
In-Reply-To: <AANLkTim1wmWOJTbzrQgqQnB_VHJF8gWfr41DbjP9r8AJ@mail.gmail.com>
	(Corrado Zoccolo's message of "Wed, 7 Jul 2010 17:22:54 +0200")
Message-ID: <x49eiffusvn.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Corrado Zoccolo <czoccolo@gmail.com> writes:

> Hi Jens,
> patch 8e55063 "cfq-iosched: fix corner cases in idling logic", is
> suspected for some regressions on high end hardware.
> The two patches from this series:
> - [PATCH 1/2] cfq-iosched: fix tree-wide handling of rq_noidle
> - [PATCH 2/2] cfq-iosched: RQ_NOIDLE enabled for SYNC_WORKLOAD
> fix two issues that I have identified, related to how RQ_NOIDLE is
> used by the upper layers.
> First patch makes sure that a RQ_NOIDLE coming after a sequence of
> possibly idling requests from the same queue on the no-idle tree will
> clear the noidle_tree_requires_idle flag.
> Second patch enables RQ_NOIDLE for queues in the idling tree,
> restoring the behaviour pre-8e55063 patch.

Hi, Corrado,

I ran your kernel through my tests.  Here are the results, up against
vanilla, deadline, and the blk_yield patch set:

                 just    just
                fs_mark  fio        mixed	
-------------------------------+--------------
deadline        529.44   151.4 | 450.0    78.2
vanilla cfq     107.88   164.4 |   6.6   137.2
blk_yield cfq   530.82   158.7 | 113.2    78.6
corrado cfq      80.82   138.1 |   4.5   130.7

fs_mark results are in files/second, fio results are in MB/s.  All
results are the average of 5 runs.  In order to get results for the
mixed workload for both vanilla and Corrado's kernels, I had to extend
the runtime from 30s to 300s.

So, the changes proposed in this thread actually make performance worse
across the board.

I re-ran my tests against a RHEL 5 kernel (which is based on 2.6.18),
and it shows that fs_mark performance is much better than stock CFQ in
2.6.35-rc3, and the mixed workload results are much the same as they are
now (which is to say, the fs_mark process is completely starved by the
sequential reader).  So, that problem has existed for a long time.

I'm still in the process of collecting data from production servers and
will report back with my findings there.

Cheers,
Jeff
