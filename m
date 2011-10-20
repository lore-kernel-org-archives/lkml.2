Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753486Ab1JTVUZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 17:20:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64047 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751958Ab1JTVUX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 17:20:23 -0400
Date: Thu, 20 Oct 2011 17:20:21 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, jaxboe@fusionio.com
Subject: Re: [PATCH 2/2] blk-throttle: Take blkcg->lock while traversing
 blkcg->policy_list
Message-ID: <20111020212021.GA2841@redhat.com>
References: <1319144906-5066-1-git-send-email-vgoyal@redhat.com>
 <1319144906-5066-2-git-send-email-vgoyal@redhat.com>
 <20111020211140.GY25124@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111020211140.GY25124@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 20, 2011 at 02:11:40PM -0700, Tejun Heo wrote:
> Hello,
> 
> On Thu, Oct 20, 2011 at 05:08:26PM -0400, Vivek Goyal wrote:
> > blkcg->policy_list is protected by blkcg->lock. Its not rcu protected
> > list. So even for readers, they need to take blkcg->lock. There are
> > few functions which were reading the list without taking lock. Fix it.
> > 
> > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> 
>  Acked-by: Tejun Heo <tj@kernel.org>
> 
> And yeap, some of rcu usages in cfq/iocg seem either incorrect or
> unnecessary.  Trying to clean up that now too.

Cool. I am waiting for the patches as I am curious to know what's incorrect
or unnecessary.

I noticed above two problems while trying to figure out how can we cleanup
the device rules when devices goes away. One place could be.

blk_throtl_exit() {
	blkiocg_del_blkio_group() {
		delete_any_policy_nodes_associated_with_this device;
	}
}

The only problem with this approach is that it will cleanup per device
weight rules also at elevator_exit() time which is not same as device
removal and one might device to bring CFQ back on device and we will
need the rules again.

cfq_exit_queue()
  cfq_release_cfq_groups
    cfq_blkiocg_del_blkio_group()
      blkiocg_del_blkio_group()

Thanks
Vivek
