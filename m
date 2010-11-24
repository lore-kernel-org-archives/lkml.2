Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755735Ab0KXCE5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 21:04:57 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:55532 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752136Ab0KXCE4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 21:04:56 -0500
Message-ID: <4CEC7329.7070909@cn.fujitsu.com>
Date: Wed, 24 Nov 2010 10:06:33 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: Colin Cross <ccross@android.com>, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org
Subject: Re: [PATCH] cgroup: Convert synchronize_rcu to call_rcu in cgroup_attach_task
References: <AANLkTikx6d0_VFtZ4zWQucRCf=vFt7N2M6=0jpnKasEE@mail.gmail.com> <1290398767-15230-1-git-send-email-ccross@android.com> <AANLkTi=4-OgPUugnUBaqSU3oC=3wxTjAsOB_Ais3Or+i@mail.gmail.com>
In-Reply-To: <AANLkTi=4-OgPUugnUBaqSU3oC=3wxTjAsOB_Ais3Or+i@mail.gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-24 10:05:11,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-24 10:05:12,
	Serialize complete at 2010-11-24 10:05:12
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> On Sun, Nov 21, 2010 at 8:06 PM, Colin Cross <ccross@android.com> wrote:
>> The synchronize_rcu call in cgroup_attach_task can be very
>> expensive.  All fastpath accesses to task->cgroups that expect
>> task->cgroups not to change already use task_lock() or
>> cgroup_lock() to protect against updates, and, in cgroup.c,
>> only the CGROUP_DEBUG files have RCU read-side critical
>> sections.
> 
> I definitely agree with the goal of using lighter-weight
> synchronization than the current synchronize_rcu() call. However,
> there are definitely some subtleties to worry about in this code.
> 
> One of the reasons originally for the current synchronization was to
> avoid the case of calling subsystem destroy() callbacks while there
> could still be threads with RCU references to the subsystem state. The
> fact that synchronize_rcu() was called within a cgroup_mutex critical
> section meant that an rmdir (or any other significant cgrooup
> management action) couldn't possibly start until any RCU read sections
> were done.
> 
> I suspect that when we moved a lot of the cgroup teardown code from
> cgroup_rmdir() to cgroup_diput() (which also has a synchronize_rcu()
> call in it) this restriction could have been eased, but I think I left
> it as it was mostly out of paranoia that I was missing/forgetting some
> crucial reason for keeping it in place.
> 
> I'd suggest trying the following approach, which I suspect is similar
> to what you were suggesting in your last email
> 
> 1) make find_existing_css_set ignore css_set objects with a zero refcount
> 2) change __put_css_set to be simply
> 
> if (atomic_dec_and_test(&cg->refcount)) {
>   call_rcu(&cg->rcu_head, free_css_set_rcu);
> }

If we do this, it's not anymore safe to use get_css_set(), which just
increments the refcount without checking if it's zero.

> 
> 3) move the rest of __put_css_set into a delayed work struct that's
> scheduled by free_css_set_rcu
> 
> 4) Get rid of the taskexit parameter - I think we can do that via a
> simple flag that indicates whether any task has ever been moved into
> the cgroup.
> 
> 5) Put extra checks in cgroup_rmdir() such that if it tries to remove
> a cgroup that has a non-zero refcount, it scans the cgroup's css_sets
> list - if it finds only zero-refcount entries, then wait (via
> synchronize_rcu() or some other appropriate means, maybe reusing the
> CGRP_WAIT_ON_RMDIR mechanism?) until the css_set objects have been
> fully cleaned up and the cgroup's refcounts have been released.
> Otherwise the operation of moving the last thread out of a cgroup and
> immediately deleting the cgroup would very likely fail with an EBUSY
> 
