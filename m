Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752299Ab0KWUWu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 15:22:50 -0500
Received: from smtp-out.google.com ([74.125.121.35]:16944 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301Ab0KWUWt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 15:22:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=k7m77oKi4fBe6Gshi3jh5anMNEw3UtUXKRhql27wgYdUel+iJj0p9L1ytHkM2v5vnv
         /qWeMIAQhIHYT722hqtA==
MIME-Version: 1.0
In-Reply-To: <AANLkTimjpW6NZ6fEiVi0VzjkpQGVob4=VHsohXUiDQkJ@mail.gmail.com>
References: <AANLkTikx6d0_VFtZ4zWQucRCf=vFt7N2M6=0jpnKasEE@mail.gmail.com>
	<1290398767-15230-1-git-send-email-ccross@android.com>
	<4CEB77E0.10202@cn.fujitsu.com>
	<AANLkTimjpW6NZ6fEiVi0VzjkpQGVob4=VHsohXUiDQkJ@mail.gmail.com>
Date: Tue, 23 Nov 2010 12:22:45 -0800
X-Google-Sender-Auth: V_ShRiagkCisWqkAxKscnNd3F-U
Message-ID: <AANLkTimJ4QeNRBg4U2V-H8WdxnG-h_8XyZHiC4G6kur_@mail.gmail.com>
Subject: Re: [PATCH] cgroup: Convert synchronize_rcu to call_rcu in cgroup_attach_task
From: Colin Cross <ccross@android.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Paul Menage <menage@google.com>,
        containers@lists.linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 23, 2010 at 12:58 AM, Colin Cross <ccross@android.com> wrote:
> On Tue, Nov 23, 2010 at 12:14 AM, Li Zefan <lizf@cn.fujitsu.com> wrote:
>> 12:06, Colin Cross wrote:
>>> The synchronize_rcu call in cgroup_attach_task can be very
>>> expensive.  All fastpath accesses to task->cgroups that expect
>>> task->cgroups not to change already use task_lock() or
>>> cgroup_lock() to protect against updates, and, in cgroup.c,
>>> only the CGROUP_DEBUG files have RCU read-side critical
>>> sections.
>>>
>>> sched.c uses RCU read-side-critical sections on task->cgroups,
>>> but only to ensure that a dereference of task->cgroups does
>>> not become invalid, not that it doesn't change.
>>>
>>
>> Other cgroup subsystems also use rcu_read_lock to access task->cgroups,
>> for example net_cls cgroup and device cgroup.
> I believe the same comment applies as sched.c, I'll update the commit message.
>
>> I don't think the performance of task attaching is so critically
>> important that we have to use call_rcu() instead of synchronize_rcu()?
> On my desktop, moving a task between cgroups averages 100 ms, and on
> an Tegra2 SMP ARM platform it takes 20 ms.  Moving a task with many
> threads can take hundreds of milliseconds or more.  With this patch it
> takes 50 microseconds to move one task, a 400x improvement.
>
>>> This patch adds a function put_css_set_rcu, which delays the
>>> put until after a grace period has elapsed.  This ensures that
>>> any RCU read-side critical sections that dereferenced
>>> task->cgroups in sched.c have completed before the css_set is
>>> deleted.  The synchronize_rcu()/put_css_set() combo in
>>> cgroup_attach_task() can then be replaced with
>>> put_css_set_rcu().
>>>
>>
>>> Also converts the CGROUP_DEBUG files that access
>>> current->cgroups to use task_lock(current) instead of
>>> rcu_read_lock().
>>>
>>
>> What for? What do we gain from doing this for those debug
>> interfaces?
> Left over from the previous patch that incorrectly dropped RCU
> completely.  I'll put the rcu_read_locks back.
>
>>> Signed-off-by: Colin Cross <ccross@android.com>
>>>
>>> ---
>>>
>>> This version fixes the problems with the previous patch by
>>> keeping the use of RCU in cgroup_attach_task, but allowing
>>> cgroup_attach_task to return immediately by deferring the
>>> final put_css_reg to an rcu callback.
>>>
>>>  include/linux/cgroup.h |    4 +++
>>>  kernel/cgroup.c        |   58 ++++++++++++++++++++++++++++++++++++++----------
>>>  2 files changed, 50 insertions(+), 12 deletions(-)
>>
>

This patch has another problem - calling put_css_set_rcu twice before
an rcu grace period has elapsed would not guarantee the appropriate
rcu grace period for the second call.  I'll try a new approach, moving
the parts of put_css_set that need to be protected by rcu into
free_css_set_rcu.
