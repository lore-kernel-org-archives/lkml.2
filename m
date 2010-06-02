Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933069Ab0FBTxi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 15:53:38 -0400
Received: from smtp-out.google.com ([74.125.121.35]:17818 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933056Ab0FBTxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 15:53:37 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:x-system-of-record;
	b=B3Cat/ddeQevVeoiKmDGDJVm/6FPWAntrw+MNhxyYgnxBuv5eFu+beZoz0vrJXRoY
	ticUlzR4W2+IwTfTYihmA==
MIME-Version: 1.0
In-Reply-To: <20100602140659.GA5324@redhat.com>
References: <20100530013002.GA762@ghc01.ghc.andrew.cmu.edu>
	<20100530013303.GC762@ghc01.ghc.andrew.cmu.edu>
	<20100531175242.GA14691@redhat.com>
	<20100531180446.GA16249@redhat.com>
	<AANLkTimcrX0TjzDMNJdubR92pAO4IPATbVpyvvVt0qIV@mail.gmail.com>
	<20100602140659.GA5324@redhat.com>
Date: Wed, 2 Jun 2010 12:53:33 -0700
Message-ID: <AANLkTin-T6ij3xf0ceGoCamwcoayxyf0GdAKY6yXDMVl@mail.gmail.com>
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

On Wed, Jun 2, 2010 at 7:06 AM, Oleg Nesterov <oleg@redhat.com> wrote:
>
> Yes sure, I understand this part. cgroup_attach_task() correctly checks
> PF_EXITING under task_lock(), this protects from the case when this
> task has already passed cgroup_exit() which takes this lock too.

Right.

>
> But. This exactly means that the PF_EXITING check in attach_task_by_pid()
> is not necessary from the correctness pov (while probably can be considered
> as optimization), right?

For the value of correctness that was relevant when writing that code
originally, I think it's fine. But ...

> I am not sure. It doesn't hurt when we try to move a thread. But if
> we want to move the whole thread group, we should proceed even if the
> group leader has already exited and thus has PF_EXITING bit set.

Hmm, maybe. I could see this being argued both ways. Can the process
hang around indefinitely with the leader as a zombie and the other
threads still running?

It wouldn't be that hard to make it possible to avoid relying on
PF_EXITING as the check - instead we'd have an exiting_css_set object
that have the same pointer set as init_css_set, but would be
distinguishable from it as a task->cgroups pointer by virtue of being
a different object. Then cgroup_exit() can reassign tasks to point to
exiting_css_set rather than init_css_set, and the various checks that
are currently made for (task->flags & PF_EXITING) could check for
(task->cgroups == exiting_css_set) instead. This would allow task
movement further into the exit process.

Paul
