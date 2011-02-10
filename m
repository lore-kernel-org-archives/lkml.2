Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754323Ab1BJSbI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 13:31:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62469 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751102Ab1BJSbH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 13:31:07 -0500
Date: Thu, 10 Feb 2011 13:30:53 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: Jens Axboe <axboe@kernel.dk>, Shaohua Li <shaohua.li@intel.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Chad Talbott <ctalbott@google.com>, Divyesh Shah <dpshah@google.com>
Subject: Re: [PATCH 0/6 v4] cfq-iosched: Introduce CFQ group hierarchical
 scheduling and "use_hierarchy" interface
Message-ID: <20110210183053.GD2524@redhat.com>
References: <4D5397A9.6040404@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D5397A9.6040404@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 10, 2011 at 03:45:45PM +0800, Gui Jianfeng wrote:
> Hi
> 
> Previously, I posted a patchset to add support of CFQ group hierarchical scheduling
> in the way that it puts all CFQ queues in a hidden group and schedules with other 
> CFQ group under their parent. The patchset is available here,
> http://lkml.org/lkml/2010/8/30/30
> 
> Vivek think this approach isn't so instinct that we should treat CFQ queues
> and groups at the same level. Here is the new approach for hierarchical 
> scheduling based on Vivek's suggestion. The most big change of CFQ is that
> it gets rid of cfq_slice_offset logic, and makes use of vdisktime for CFQ
> queue scheduling just like CFQ group does. But I still give cfqq some jump 
> in vdisktime based on ioprio, thanks for Vivek to point out this. Now CFQ 
> queue and CFQ group use the same scheduling algorithm. 
> 
> "use_hierarchy" interface is now added to switch between hierarchical mode
> and flat mode. It works as memcg.
> 
> --
> V3 -> V4 Changes:
> - Take io class into account when calculating the boost value.
> - Refine the vtime boosting logic as Vivek's Suggestion.

Hi Gui,

What testing did you do to make sure that this vtime boosting logic is working
and is good replacement for slice_offset() logic for cfqq?

Secondly, did you get a chance to look at chad's patch of keeping track
of previous assigned vdisktime and keeping track of genrations. I think
his patch is going to coflict with yours, so one of you will have to
make adjustments. I think both the boost logic and keeping track of generation
logic can be combined.

	if (entity->gneration_number > cfqd->active_generation)
		Use_boost_logic;
	else
		Use_previously_assigned_vdisktime;


That way if we generation has changed then we really don't have a valid
vdisktime and we can use boost logic to come up with differential
vdisktime and if generation has not changed then we can continue to make
use of previous vdisktime.

Thanks
Vivek
