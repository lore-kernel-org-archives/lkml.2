Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935739Ab1ETTTP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 15:19:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37279 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935701Ab1ETTTN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 15:19:13 -0400
Date: Fri, 20 May 2011 15:19:07 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Namhyung Kim <namhyung@gmail.com>, Shaohua Li <shaohua.li@intel.com>,
        linux-kernel@vger.kernel.org, Divyesh Shah <dpshah@google.com>
Subject: Re: [PATCH] block: call elv_bio_merged() when merged
Message-ID: <20110520191907.GA6379@redhat.com>
References: <1305869337-4375-1-git-send-email-namhyung@gmail.com>
 <BANLkTik5Od9tLg1F6mDFkzpViXR2ZcRmgA@mail.gmail.com>
 <1305885108.1633.11.camel@leonhard>
 <4DD6B807.6040309@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4DD6B807.6040309@kernel.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 20, 2011 at 08:50:47PM +0200, Jens Axboe wrote:
> On 2011-05-20 11:51, Namhyung Kim wrote:
> > Hello,
> > 
> > 2011-05-20 (금), 16:31 +0800, Shaohua Li:
> >> 2011/5/20 Namhyung Kim <namhyung@gmail.com>:
> >>> Commit 73c101011926 ("block: initial patch for on-stack per-task plugging")
> >>> removed calls to elv_bio_merged() when @bio merged with @req. Re-add them.
> >>>
> >>> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> >>> Cc: Divyesh Shah <dpshah@google.com>
> >>> ---
> >>>  block/blk-core.c |    2 ++
> >>>  1 files changed, 2 insertions(+), 0 deletions(-)
> >>>
> >>> diff --git a/block/blk-core.c b/block/blk-core.c
> >>> index 3fe00a14822a..4dc02ef5fc82 100644
> >>> --- a/block/blk-core.c
> >>> +++ b/block/blk-core.c
> >>> @@ -1132,6 +1132,7 @@ static bool bio_attempt_back_merge(struct request_queue *q, struct request *req,
> >>>        req->ioprio = ioprio_best(req->ioprio, bio_prio(bio));
> >>>
> >>>        drive_stat_acct(req, 0);
> >>> +       elv_bio_merged(q, req, bio);
> >>>        return true;
> >>>  }
> >>>
> >>> @@ -1173,6 +1174,7 @@ static bool bio_attempt_front_merge(struct request_queue *q,
> >>>        req->ioprio = ioprio_best(req->ioprio, bio_prio(bio));
> >>>
> >>>        drive_stat_acct(req, 0);
> >>> +       elv_bio_merged(q, req, bio);
> >>>        return true;
> >>>  }
> >> Looks you should do this in __make_request. when the routine is called
> >> in attempt_plug_merge, the request isn't added to elevator yet.
> >>
> > 
> > Hmm.. anyway it is merged. Is there any reason why we shouldn't collect
> > the stat - or invoke the callback routine - if the @req is not in the
> > elevator? Or we need to add a separate stat item for this case?
> 
> Your patch should be safe, it's essentially only for the cgroup stuff
> that does its own accounting and has appropriate protection for it. We'd
> want to do this for both the plug and not-plugged merge case.
> 
> It's a bit of a shame to add this though, since now we are hitting the
> cgroup lock for each merge.

I think wer can make MERGED per cpu as I have done in my other patch
series for following dispatch stats.

BLKIO_STAT_CPU_SECTORS,
/* Total bytes transferred */
BLKIO_STAT_CPU_SERVICE_BYTES,
/* Total IOs serviced, post merge */
BLKIO_STAT_CPU_SERVICED,

Jens are you planning to merge lockless throttling series? Once that gets
merged, we can convert this MERGED stat also per cpu and get rid of need of
taking blkg->stats_lock.

Thanks
Vivek
