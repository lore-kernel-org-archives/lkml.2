Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752281Ab1KYECl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 23:02:41 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:57912 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177Ab1KYECk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 23:02:40 -0500
MIME-Version: 1.0
In-Reply-To: <20111124225054.GA14828@google.com>
References: <1320191193-8110-1-git-send-email-tj@kernel.org>
 <1320191193-8110-4-git-send-email-tj@kernel.org> <20111124225054.GA14828@google.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 24 Nov 2011 20:02:18 -0800
X-Google-Sender-Auth: u6c47zwVxN_YOxcQzmDiku9qtg0
Message-ID: <CA+55aFxq1wztMzYhKaY5RHazLBDz4pSXUgiGzTj2wA6EJcDbAw@mail.gmail.com>
Subject: Re: [PATCH UPDATED 03/10] threadgroup: extend threadgroup_lock() to
 cover exit and exec
To: Tejun Heo <tj@kernel.org>
Cc: paul@paulmenage.org, rjw@sisk.pl, lizf@cn.fujitsu.com,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, fweisbec@gmail.com,
        matthltc@us.ibm.com, akpm@linux-foundation.org, oleg@redhat.com,
        kamezawa.hiroyu@jp.fujitsu.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 24, 2011 at 2:50 PM, Tejun Heo <tj@kernel.org> wrote:
>
> Linus, this is something being scheduled for the next merge window.
> It extends threadgroup locking which cgroup used to do to exclude only
> fork path so that it includes exit and exec paths.  threadgroup
> locking is used by cgroup to implement process-scope cgroup migration.
>
> Migration happens in multiple steps, at each of which the matching
> method of each cgroup plugin is called.  When a whole process is being
> migrated, methods being called at those different steps expect to see
> consistent image of the thread group.

Ugh.

I see why you want to do this, but I really don't much like some of it.

I've got a few questions:

 - do you even *need* two separate locks at all? If you extend the
threadgroup_fork_lock to cover exec/exit too (and rename it), then why
does that separate cred_guard_mutex make sense at all?

  Taking two locks for the common exit case seems disgusting. What do
the separate locks buy us?

 - could we possible avoid the lock(s) entirely for the
single-threaded case? The fact that ptrace wants to serialize makes me
say "maybe we can't avoid it", but I thought I'd ask. Even if we do
need/want two separate locks, do we really want to take them both for
the case that shouldn't really need even a single one?

Hmm? Simplifying the locking rules is always a good idea, and I think
this seems to make some of it more straightforward, but at the same
time I shudder when I look at some of the patches in the series that
nest locking three locks deep. Ugh.

                 Linus
