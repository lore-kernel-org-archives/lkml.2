Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933068Ab0FBVM3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 17:12:29 -0400
Received: from smtp-out.google.com ([74.125.121.35]:47204 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932805Ab0FBVMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 17:12:24 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:x-system-of-record;
	b=ISt0+YU27s3smAJrGQNjfwHeZrWTKC0CfHbfZYmNIDn//2JHWoGuWGOoGkOJzS7Dn
	xrqNm+mGZK38DWd8AMrTA==
MIME-Version: 1.0
In-Reply-To: <20100602205855.GA30039@redhat.com>
References: <20100530013002.GA762@ghc01.ghc.andrew.cmu.edu>
	<20100530013303.GC762@ghc01.ghc.andrew.cmu.edu>
	<20100531175242.GA14691@redhat.com>
	<20100531180446.GA16249@redhat.com>
	<AANLkTimcrX0TjzDMNJdubR92pAO4IPATbVpyvvVt0qIV@mail.gmail.com>
	<20100602140659.GA5324@redhat.com>
	<AANLkTin-T6ij3xf0ceGoCamwcoayxyf0GdAKY6yXDMVl@mail.gmail.com>
	<20100602202048.GB28663@redhat.com>
	<AANLkTimrJFiidM8BlUNvmzfapUAv8369R9PYnTscasEf@mail.gmail.com>
	<20100602205855.GA30039@redhat.com>
Date: Wed, 2 Jun 2010 14:12:20 -0700
Message-ID: <AANLkTimfHlapl7mbRyAazWW5q5Wzs23n6i9wIhVtSv6r@mail.gmail.com>
Subject: Re: [RFC] [PATCH 2/2] cgroups: make procs file writable
From: Paul Menage <menage@google.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ben Blum <bblum@andrew.cmu.edu>, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org, akpm@linux-foundation.org,
       ebiederm@xmission.com, lizf@cn.fujitsu.com, matthltc@us.ibm.com
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 2, 2010 at 1:58 PM, Oleg Nesterov <oleg@redhat.com> wrote:
>> The "it" that you're proposing to remove is in fact the code that
>> handles those races.
>
> In that case I confused, and I thought we already agreed that
> the PF_EXITING check in attach_task_by_pid() is not strictly needed
> for correctness.

Not quite - something is required for correctness, and the PF_EXITING
check provides that correctness, with a very small window (between
setting PF_EXITING and calling cgroup_exit) where we might arguably
have been able to move the thread but decline to do so because it's
simpler not to do so and no-one cares. That's the optimization that I
meant - the data structures are slightly simpler since there's no way
to tell when a task has passed cgroup_exit(), and instead we just see
if they've passed PF_EXITING.

>
> Once again, the task can call do_exit() and set PF_EXITING right
> after the check.

Yes, the important part is that they haven't set it *before* the check
in attach_task_by_pid(). If they have set it before that, then they
could be anywhere in the exit path after PF_EXITING, and we decline to
move them since it's possible that they've already passed
cgroup_exit(). If the exiting task has not yet set PF_EXITING, then it
can't possibly get into the critical section in cgroup_exit() since
attach_task_by_pid() holds task->alloc_lock.

Paul
