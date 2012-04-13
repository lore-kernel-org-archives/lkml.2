Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756805Ab2DMUiL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 16:38:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1986 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756779Ab2DMUiD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 16:38:03 -0400
Date: Fri, 13 Apr 2012 16:37:58 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        containers@lists.linux-foundation.org
Subject: Re: [PATCH 07/11] blkcg: make request_queue bypassing on allocation
Message-ID: <20120413203758.GJ26383@redhat.com>
References: <1334347895-6268-1-git-send-email-tj@kernel.org>
 <1334347895-6268-8-git-send-email-tj@kernel.org>
 <20120413203205.GI26383@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120413203205.GI26383@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 13, 2012 at 04:32:05PM -0400, Vivek Goyal wrote:
> On Fri, Apr 13, 2012 at 01:11:31PM -0700, Tejun Heo wrote:
> > With the previous change to guarantee bypass visiblity for RCU read
> > lock regions, entering bypass mode involves non-trivial overhead and
> > future changes are scheduled to make use of bypass mode during init
> > path.  Combined it may end up adding noticeable delay during boot.
> > 
> > This patch makes request_queue start its life in bypass mode, which is
> > ended on queue init completion at the end of
> > blk_init_allocated_queue(), and updates blk_queue_bypass_start() such
> > that draining and RCU synchronization are performed only when the
> > queue actually enters bypass mode.
> > 
> > This avoids unnecessarily switching in and out of bypass mode during
> > init avoiding the overhead and any nasty surprises which may step from
> > leaving bypass mode on half-initialized queues.
> 
> Tejun, I am not sure that this will fix the problem completely. I think
> we will still face the overhead of synchronize_rcu() in
> blkcg_deactivate_policy() as it will be called from cfq_exit_queue() for
> initialized queues.
> 
> In the past I had I had used synchronize_rcu() in cfq_exit_queue() and
> noticed the overhead. Looks like driver was creating fully initialized
> queues and tearing these apart soon.

Here is the old commit. Driver in question was megaraid.

commit bb729bc98c0f3e6a898d8730df3e2830bf68751a
Author: Jens Axboe <jens.axboe@oracle.com>
Date:   Sun Dec 6 09:54:19 2009 +0100

    cfq-iosched: use call_rcu() instead of doing grace period stall on queue exit

    After the merge of the IO controller patches, booting on my megaraid box
    ran much slower. Vivek Goyal traced it down to megaraid discovery creating
    tons of devices, each suffering a grace period when they later kill that
    queue (if no device is found).
    
    So lets use call_rcu() to batch these deferred frees, instead of taking
    the grace period hit for each one.

Thanks
Vivek
