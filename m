Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753190Ab2LBOP6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2012 09:15:58 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34040 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579Ab2LBOP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2012 09:15:57 -0500
Date: Sun, 2 Dec 2012 06:15:50 -0800
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: peterz@infradead.org, linux-kernel@vger.kernel.org,
        Paul Menage <paul@paulmenage.org>,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org
Subject: Re: Why is cpuset_cpus_allowed_fallback() necessary?
Message-ID: <20121202141550.GQ15930@mtj.dyndns.org>
References: <20121126223249.GB15930@mtj.dyndns.org>
 <20121127184117.GA8937@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121127184117.GA8937@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Oleg.

On Tue, Nov 27, 2012 at 07:41:17PM +0100, Oleg Nesterov wrote:
> > Oleg, do you remember?  Why do we need
> > this?
> 
> No, I forgot. And this code was changed after that, the fat comment in
> cpuset_cpus_allowed_fallback() tried to explain the code below which
> was removed.
> 
> I am starting to recall what this patch tried to do after I looked into
> git history. This patch was the last (probably) change in series.
> 
> Please look at
> 	897f0b3c3ff40b443c84e271bef19bd6ae885195
> 	sched: Kill the broken and deadlockable cpuset_lock/cpuset_cpus_allowed_locked code
> 
> In particular it removes cpuset_cpus_allowed_locked() from
> select_fallback_rq() because this was very wrong. IOW, this patch
> simply removes the code which didn't really work
> 
> And after some other changes, this comment tried to add the supposed
> behaviour back: we shouldn't simply use cpu_possible_mask, we should
> consult cpuset.

Ah, okay.  If the task's affinity, which is subset of cpuset's, become
empty while the cpuset's doesn't, we still better confine the task to
the cpuset.  The code seems broken tho - it looks at CPUs which are on
the same node first before consulting cpuset, which may lead to the
task escaping cpuset.  Prolly the function need to be restructured
that it first runs as if cpuset->cpus_allowed is cpu_possible_mask and
then if that fails with the actual cpu_possible_mask.

Thanks!

-- 
tejun
