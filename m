Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755900Ab0KXBYz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 20:24:55 -0500
Received: from smtp-out.google.com ([74.125.121.35]:8829 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754185Ab0KXBYy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 20:24:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=X7C3s2dXsMg2QxXBBQnb7Xm8Xn3cLxDKIvjcBdDayc59bLwDvvwJHahS0QGpRcRPsg
         mAayS0OGlTvQ8eHj9+rw==
MIME-Version: 1.0
In-Reply-To: <1290398767-15230-1-git-send-email-ccross@android.com>
References: <AANLkTikx6d0_VFtZ4zWQucRCf=vFt7N2M6=0jpnKasEE@mail.gmail.com> <1290398767-15230-1-git-send-email-ccross@android.com>
From: Paul Menage <menage@google.com>
Date: Tue, 23 Nov 2010 17:24:30 -0800
Message-ID: <AANLkTi=4-OgPUugnUBaqSU3oC=3wxTjAsOB_Ais3Or+i@mail.gmail.com>
Subject: Re: [PATCH] cgroup: Convert synchronize_rcu to call_rcu in cgroup_attach_task
To: Colin Cross <ccross@android.com>
Cc: linux-kernel@vger.kernel.org, Li Zefan <lizf@cn.fujitsu.com>,
        containers@lists.linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 21, 2010 at 8:06 PM, Colin Cross <ccross@android.com> wrote:
> The synchronize_rcu call in cgroup_attach_task can be very
> expensive.  All fastpath accesses to task->cgroups that expect
> task->cgroups not to change already use task_lock() or
> cgroup_lock() to protect against updates, and, in cgroup.c,
> only the CGROUP_DEBUG files have RCU read-side critical
> sections.

I definitely agree with the goal of using lighter-weight
synchronization than the current synchronize_rcu() call. However,
there are definitely some subtleties to worry about in this code.

One of the reasons originally for the current synchronization was to
avoid the case of calling subsystem destroy() callbacks while there
could still be threads with RCU references to the subsystem state. The
fact that synchronize_rcu() was called within a cgroup_mutex critical
section meant that an rmdir (or any other significant cgrooup
management action) couldn't possibly start until any RCU read sections
were done.

I suspect that when we moved a lot of the cgroup teardown code from
cgroup_rmdir() to cgroup_diput() (which also has a synchronize_rcu()
call in it) this restriction could have been eased, but I think I left
it as it was mostly out of paranoia that I was missing/forgetting some
crucial reason for keeping it in place.

I'd suggest trying the following approach, which I suspect is similar
to what you were suggesting in your last email

1) make find_existing_css_set ignore css_set objects with a zero refcount
2) change __put_css_set to be simply

if (atomic_dec_and_test(&cg->refcount)) {
  call_rcu(&cg->rcu_head, free_css_set_rcu);
}

3) move the rest of __put_css_set into a delayed work struct that's
scheduled by free_css_set_rcu

4) Get rid of the taskexit parameter - I think we can do that via a
simple flag that indicates whether any task has ever been moved into
the cgroup.

5) Put extra checks in cgroup_rmdir() such that if it tries to remove
a cgroup that has a non-zero refcount, it scans the cgroup's css_sets
list - if it finds only zero-refcount entries, then wait (via
synchronize_rcu() or some other appropriate means, maybe reusing the
CGRP_WAIT_ON_RMDIR mechanism?) until the css_set objects have been
fully cleaned up and the cgroup's refcounts have been released.
Otherwise the operation of moving the last thread out of a cgroup and
immediately deleting the cgroup would very likely fail with an EBUSY

Paul
