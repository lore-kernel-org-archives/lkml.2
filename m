Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755887Ab1LESnY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 13:43:24 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63676 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755772Ab1LESnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 13:43:23 -0500
Date: Mon, 5 Dec 2011 10:43:15 -0800
From: Tejun Heo <tj@kernel.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: paul@paulmenage.org, rjw@sisk.pl, lizf@cn.fujitsu.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, matthltc@us.ibm.com,
        akpm@linux-foundation.org, oleg@redhat.com,
        kamezawa.hiroyu@Jp.fujitsu.com
Subject: Re: [PATCH UPDATED 03/10] threadgroup: extend threadgroup_lock()
 to cover exit and exec
Message-ID: <20111205184315.GJ627@google.com>
References: <1320191193-8110-1-git-send-email-tj@kernel.org>
 <1320191193-8110-4-git-send-email-tj@kernel.org>
 <20111124225054.GA14828@google.com>
 <20111125140136.GC23307@somewhere.redhat.com>
 <20111127193001.GC4266@google.com>
 <20111202162753.GA19752@somewhere.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111202162753.GA19752@somewhere.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Frederic.

On Fri, Dec 02, 2011 at 05:28:03PM +0100, Frederic Weisbecker wrote:
> But I don't think it's very useful to protect against irq_exit_thread(),
> what happens there is purely of internal irq interest.
> 
> Then right after, PF_EXITING is set before any interesting change.
> Isn't it possible to simply lock this flag setting? IIRC, as soon
> as the PF_EXITING flag is set, you ignore the task for attachment.

I think that's technically possible but it does introduce another
class of tasks - the dying ones.  e.g. If a task has PF_EXITING set
and the containing process is migrating, we'll have to migrate all
tasks but the dying one and cgroup ->exit callbacks can be called on
the lonely task after the migration is complete.  It's kinda messy and
if someone makes a wrong assumption there, the bug is gonna be even
more difficult to reproduce / track down than now.  Yes, smaller scope
locking is nicer but I would like to avoid api weirdities like that.

Thanks.

-- 
tejun
