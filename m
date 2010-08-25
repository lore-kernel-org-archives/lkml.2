Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752855Ab0HYJKI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 05:10:08 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:44476 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751838Ab0HYJKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 05:10:05 -0400
Subject: Re: [PATCH] workqueue: fix cwq->nr_active underflow
From: Johannes Berg <johannes@sipsolutions.net>
To: Tejun Heo <tj@kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <4C74D9E4.5070403@kernel.org>
References: <4C74D9E4.5070403@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 25 Aug 2010 11:11:41 +0200
Message-ID: <1282727501.3685.7.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-08-25 at 10:52 +0200, Tejun Heo wrote:
> cwq->nr_active is used to keep track of how many work items are active
> for the cpu workqueue, where 'active' is defined as either pending on
> global worklist or executing.  This is used to implement the
> max_active limit and workqueue freezing.  If a work item is queued
> after nr_active has already reached max_active, the work item doesn't
> increment nr_active and is put on the delayed queue and gets activated
> later as previous active work items retire.
> 
> try_to_grab_pending() which is used in the cancellation path
> unconditionally decremented nr_active whether the work item being
> cancelled is currently active or delayed, so cancelling a delayed work
> item makes nr_active underflow.  This breaks max_active enforcement
> and triggers BUG_ON() in destroy_workqueue() later on.
> 
> This patch fixes this bug by adding a flag WORK_STRUCT_DELAYED, which
> is set while a work item in on the delayed list and making
> try_to_grab_pending() decrement nr_active iff the work item is
> currently active.
> 
> The addition of the flag enlarges cwq alignment to 256 bytes which is
> getting a bit too large.  It's scheduled to be reduced back to 128
> bytes by merging WORK_STRUCT_PENDING and WORK_STRUCT_CWQ in the next
> devel cycle.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Reported-by: Johannes Berg <johannes@sipsolutions.net>
> ---
> Johannes, although I don't have your confirmation yet, my simple test
> case confirms the bug and fix, so I'm pushing it out.  Please let me
> know if you can confirm the fix.

Thanks Tejun. Come to think of it, since it's an underflow it should be
easier for me to change the BUG_ON into a printk + BUG_ON() to print out
the current value, and then reproduce -- that way I'll know when I hit
the situation, which isn't trivial, and also whether I hit the
underflow. Does that sound like a good thing to try to you?

johannes

