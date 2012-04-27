Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756235Ab2D0TrF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 15:47:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22972 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751729Ab2D0TrD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 15:47:03 -0400
Date: Fri, 27 Apr 2012 15:46:54 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        containers@lists.linux-foundation.org, fengguang.wu@intel.com,
        hughd@google.com, akpm@linux-foundation.org
Subject: Re: [PATCH 11/11] blkcg: implement per-blkg request allocation
Message-ID: <20120427194654.GN10579@redhat.com>
References: <1335477561-11131-1-git-send-email-tj@kernel.org>
 <1335477561-11131-12-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1335477561-11131-12-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26, 2012 at 02:59:21PM -0700, Tejun Heo wrote:

[..]
> @@ -926,6 +936,7 @@ static struct request *__get_request(struct request_list *rl, int rw_flags,
>  		goto fail_alloc;
>  
>  	blk_rq_init(q, rq);
> +	blk_rq_set_rl(rq, rl);

Given the fact that we have established the rq and blkg releation at
the time of allocation, should we modify CFQ to just use that relation
instread of trying to lookup group again based on bio.

We avoid one lookup also we avoid duplicate creation of blkg in following
corner case of bio==NULL

	- blkg_get_rl()
	- request allocation fails. sleep, drop queue lock
	- process is moved to a different cgroup. origincal cgroup is
	  deleted. pre_destroy will cleanup all blkg on blkcg.
	- process wakes up, request allocated, set_request sets up new blkg
 	  based on new cgroup. Now a request is queued in one blkg/cgroup and
 	  it has come out of the quota of other blkg/cgroup.

Well, I have a question. Ideally nobody should be linking any more blkg
to a blkcg once blkg_pre_destroy() has been called? But can it happen
that bio_associate_current() takes are reference to blkcg and bio is
throttled. cgroup associated with bio is deleted resulting in
pre_destroy(). Now bio is submitted to CFQ and it will try to create
a new blkg for blkcg-queue pair and once IO is complete, bio will drop
blkcg reference, which in turn will free up blkcg and associated blkg
is still around and will not be cleaned up.

IOW, looks like we need a mechanism to mark a blkcg dead (set in
pre_destroy() call) and any submissions to blkcg after that should result
in bio being divered to root group?

If we reuse the rl->blkg during CFQ submission, we will avoid that problem
as blkg IO is being submitted has already been disconnected from blkcg
list and hopefully that's not a problem and IO can still be submitted
in this blkg.

Thanks
Vivek
