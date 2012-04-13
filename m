Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756952Ab2DMVdw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 17:33:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57129 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752403Ab2DMVdv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 17:33:51 -0400
Date: Fri, 13 Apr 2012 17:33:44 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        containers@lists.linux-foundation.org
Subject: Re: [PATCH 07/11] blkcg: make request_queue bypassing on allocation
Message-ID: <20120413213344.GA1825@redhat.com>
References: <1334347895-6268-1-git-send-email-tj@kernel.org>
 <1334347895-6268-8-git-send-email-tj@kernel.org>
 <20120413203205.GI26383@redhat.com>
 <20120413203726.GE12233@google.com>
 <20120413204446.GK26383@redhat.com>
 <20120413204710.GF12233@google.com>
 <20120413205501.GL26383@redhat.com>
 <20120413210548.GG12233@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120413210548.GG12233@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 13, 2012 at 02:05:48PM -0700, Tejun Heo wrote:
> On Fri, Apr 13, 2012 at 04:55:01PM -0400, Vivek Goyal wrote:
> > But neither seems to be the case here. So to make sure that blkg_lookup()
> > under rcu will see the updated value of queue flag (bypass), are we
> > relying on the fact that caller should see the DEAD flag and not go
> > ahead with blkg_lookup()?  If yes, atleast it is not obivious.
> 
> We're relying on the fact that it doesn't matter anymore because all
> blkgs will be shoot down in queue cleanup path which goes through rcu
> free, which is different from deactivating individual policies.  It
> indeed is subtle.  Umm... this is starting to get ridiculous.  Why the
> hell was megaraid messing with so many queues anyways?

Well, blkcg_deactivate_policy() frees the policy data in a non-rcu
manner. So group is around but policy data is gone. So technically if some
IO submitter does not see the queue bypass flag, he might still try to
access blkg->pd[pol->plid] after being freed.

Having said that, in this case we are probably fine as blk_release_queue()
is executed after last reference to queue is dropped and no more IO can
come. May be a 2 line comment will help.

elevator_switch() path of deactivation policy is anyway fine as it will
call synchronize_rcu().

BTW, looks like blkio_exit_group_fn() probably is not a good name anymore
as it is not even called when policy is being deactivated. It should
probably be now .blkio_exit_policy_data_fn() or something like that.

Thanks
Vivek
