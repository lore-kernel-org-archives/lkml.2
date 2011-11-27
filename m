Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755192Ab1K0TaJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 14:30:09 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:62599 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754804Ab1K0TaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 14:30:08 -0500
Date: Sun, 27 Nov 2011 11:30:01 -0800
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
Message-ID: <20111127193001.GC4266@google.com>
References: <1320191193-8110-1-git-send-email-tj@kernel.org>
 <1320191193-8110-4-git-send-email-tj@kernel.org>
 <20111124225054.GA14828@google.com>
 <20111125140136.GC23307@somewhere.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111125140136.GC23307@somewhere.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Frederic.

On Fri, Nov 25, 2011 at 03:01:39PM +0100, Frederic Weisbecker wrote:
> > +	/*
> > +	 * @tsk's threadgroup is going through changes - lock out users
> > +	 * which expect stable threadgroup.  Do this before actually
> > +	 * starting tearing down @tsk so that locked threadgroup has either
> > +	 * alive or dead tasks, not something inbetween.
> > +	 */
> > +	threadgroup_change_begin(tsk);
> > +
> 
> I still wonder why there is a so big coverage of this lock. I mean
> why is it called right before exit_irq_thread() and released so late.
> All we want is to lock cgroup_exit() I think, after which tasks can't be
> migrated.

That way, cgroup plugins never see tasks in the process of
deconstruction.  Its ->mm, ->sighand, ->signal and so on either don't
exist or continue to exist across all cgroup callbacks.  It's simpler
and safer (especially as bugs in this area would only be visible when
migration and exit race), and if we're gonna synchronize exit path at
all, there isn't anything to lose by excluding the whole thing.

Thanks.

-- 
tejun
