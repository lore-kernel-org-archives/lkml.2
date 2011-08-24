Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755486Ab1HXHuI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 03:50:08 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60047 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354Ab1HXHuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 03:50:04 -0400
Date: Wed, 24 Aug 2011 09:49:59 +0200
From: Tejun Heo <tj@kernel.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: rjw@sisk.pl, paul@paulmenage.org, lizf@cn.fujitsu.com,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org
Subject: Re: [PATCHSET] cgroup: introduce cgroup_taskset and consolidate
 subsys methods
Message-ID: <20110824074959.GA14170@htj.dyndns.org>
References: <1314138000-2049-1-git-send-email-tj@kernel.org>
 <20110824011428.GC23979@somewhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110824011428.GC23979@somewhere>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Frederic.

On Wed, Aug 24, 2011 at 03:14:30AM +0200, Frederic Weisbecker wrote:
> >  0001-cgroup-subsys-attach_task-should-be-called-after-mig.patch
> >  0002-cgroup-improve-old-cgroup-handling-in-cgroup_attach_.patch
> >  0003-cgroup-introduce-cgroup_taskset-and-use-it-in-subsys.patch
> >  0004-cgroup-don-t-use-subsys-can_attach_task-or-attach_ta.patch
> >  0005-cgroup-cpuset-don-t-use-ss-pre_attach.patch
> >  0006-cgroup-kill-subsys-can_attach_task-pre_attach-and-at.patch
> 
> I don't understand the point on patches 3,4,5,6
> 
> Why pushing the task iterations down to the subsystems?

I'll try again.

It seems like methods were added to serve the immediate need of the
particular user at the time and that in turn led to addition of
callbacks which were both superflous and incomplete (the bullet points
in the original message list them).  This seems to have happened
because extra interface was added without trying to make the existing
interface complete.

The interface is complicated and cumbersome to use - are
[can_]attach() called first or [can_]attach_task()?  What about
cancelation?  What if a subsys wants to perform operations across
multiple tasks atomically?

In general, iteration-by-callback is painful to use.  Establishing
common context (be it synchronization domain or shared variables)
becomes very cumbersome and implementation becomes fragmented and
difficult to follow.  For example, imagine how it would be like to use
list if we had call_for_each_list_entry(func, list_head) instead of
the control-loop style iterators we have know.

So, using iterators enables making all relevant information to each
stage of attach so that only one callback is required for each step -
the way it should be.  In addition, it makes it far easier for
subsystems to implement more involved logic in their methods.

I tried to make cgroup_freezer behave better which requires better
synchronization against the freezer and, with the current interface,
it's extremely ugly and painful.  The new interface is complete, easy
to understand and use with far less subtleties.

Thanks.

-- 
tejun
