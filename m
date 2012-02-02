Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933625Ab2BBUDZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 15:03:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8850 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754059Ab2BBUDX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 15:03:23 -0500
Date: Thu, 2 Feb 2012 15:03:18 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/11] blkcg: let blkio_group point to blkio_cgroup
 directly
Message-ID: <20120202200318.GB1723@redhat.com>
References: <1328131156-13290-1-git-send-email-tj@kernel.org>
 <1328131156-13290-2-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328131156-13290-2-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 01, 2012 at 01:19:06PM -0800, Tejun Heo wrote:
> Currently, blkg points to the associated blkcg via its css_id.  This
> unnecessarily complicates dereferencing blkcg.  Let blkg hold a
> reference to the associated blkcg and point directly to it and disable
> css_id on blkio_subsys.
> 
> This change requires splitting blkiocg_destroy() into
> blkiocg_pre_destroy() and blkiocg_destroy() so that all blkg's can be
> destroyed and all the blkcg references held by them dropped during
> cgroup removal.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Vivek Goyal <vgoyal@redhat.com>

[..]
> +static void blkiocg_destroy(struct cgroup_subsys *subsys, struct cgroup *cgroup)
> +{
> +	struct blkio_cgroup *blkcg = cgroup_to_blkio_cgroup(cgroup);
> +
>  	if (blkcg != &blkio_root_cgroup)
>  		kfree(blkcg);

Hi Tejun,

What makes sure that all the blkg are gone and they have dropped their
reference to blkcg? IIUC, pre-destroy will just make sure to decouple
blkg from request queue as well as blkcg list and also drop joint cgroup
and request queue reference.

But there could well be some IO queued in the group which might have
its own reference and will be dropped later when IO completes. So at
the time of blkiocg_destroy() it is not guranteed that there are
no reference holders to blkcg?

Thanks
Vivek
