Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756837Ab2K0SlO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 13:41:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42884 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751622Ab2K0SlN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 13:41:13 -0500
Date: Tue, 27 Nov 2012 19:41:17 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: peterz@infradead.org, linux-kernel@vger.kernel.org,
        Paul Menage <paul@paulmenage.org>,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org
Subject: Re: Why is cpuset_cpus_allowed_fallback() necessary?
Message-ID: <20121127184117.GA8937@redhat.com>
References: <20121126223249.GB15930@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121126223249.GB15930@mtj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

On 11/26, Tejun Heo wrote:
>
> I'm wondering why cpuset_cpus_allowed_fallback() is necessary.  This
> is called from, e.g., try_to_wake_up()->select_task_rq() when none of
> the cpus in ->cpus_allowed is useable.  The cpuset callback invokes
> do_set_cpus_allowed() w/ the cpuset's cpus_allowed.  This was added by
> the following commit,
>
>   commit 9084bb8246ea935b98320554229e2f371f7f52fa
>   Author: Oleg Nesterov <oleg@redhat.com>
>   Date:   Mon Mar 15 10:10:27 2010 +0100
>
>
>   sched: Make select_fallback_rq() cpuset friendly
>
>   Introduce cpuset_cpus_allowed_fallback() helper to fix the cpuset problems
>   with select_fallback_rq(). It can be called from any context and can't use
>   any cpuset locks including task_lock(). It is called when the task doesn't
>   have online cpus in ->cpus_allowed but ttwu/etc must be able to find a
>   suitable cpu.
>   ....
>
> The problem is, nothing's explaining what "the cpuset problems with
> select_fallback_rq()" are.

Cough. You are right, the changelog is confusing and I no can not
understand it too.

> Oleg, do you remember?  Why do we need
> this?

No, I forgot. And this code was changed after that, the fat comment in
cpuset_cpus_allowed_fallback() tried to explain the code below which
was removed.



I am starting to recall what this patch tried to do after I looked into
git history. This patch was the last (probably) change in series.

Please look at
	897f0b3c3ff40b443c84e271bef19bd6ae885195
	sched: Kill the broken and deadlockable cpuset_lock/cpuset_cpus_allowed_locked code

In particular it removes cpuset_cpus_allowed_locked() from
select_fallback_rq() because this was very wrong. IOW, this patch
simply removes the code which didn't really work

And after some other changes, this comment tried to add the supposed
behaviour back: we shouldn't simply use cpu_possible_mask, we should
consult cpuset.

Oleg.

