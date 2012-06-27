Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932090Ab2F0MkF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 08:40:05 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:50628 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755803Ab2F0MkD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 08:40:03 -0400
MIME-Version: 1.0
In-Reply-To: <4FE9F63B.1000908@canonical.com>
References: <1340364965.18025.71.camel@twins>
	<4FE48A09.7050305@canonical.com>
	<1340718515.21991.83.camel@twins>
	<4FE9F63B.1000908@canonical.com>
Date: Wed, 27 Jun 2012 20:40:02 +0800
Message-ID: <CAJd=RBBWGVkTeZEz9K70AP2-DDTm0p5VEwHgM1tvcnwU3Y=brQ@mail.gmail.com>
Subject: Re: [RFC][PATCH] sched: Fix race in task_group()
From: Hillf Danton <dhillf@gmail.com>
To: Stefan Bader <stefan.bader@canonical.com>
Cc: Peter Zijlstra <peterz@infradead.org>, mingo@kernel.org,
        Oleg Nesterov <oleg@redhat.com>, Paul Turner <pjt@google.com>,
        Mike Galbraith <efault@gmx.de>, Andrew Vagin <avagin@openvz.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch went three versions, the first,

On Fri, Jun 22, 2012 at 7:36 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> Reported-by: Stefan Bader <stefan.bader@canonical.com>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 32157b9..77437d4 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1246,6 +1246,9 @@ struct task_struct {
>	const struct sched_class *sched_class;
>	struct sched_entity se;
>	struct sched_rt_entity rt;
> +#ifdef CONFIG_CGROUP_SCHED
> +	struct task_struct *sched_task_group;
> +#endif
>

The second,

>> On 26.06.2012 15:48, Peter Zijlstra wrote:
>> Here's one that's actually compile tested (with the right CONFIG_foo
>> enabled) and I fixed the autogroup lockdep splat.
>>
>> ---
>> Subject: sched: Fix race in task_group()
>> From: Peter Zijlstra <peterz@infradead.org>
>> Date: Fri, 22 Jun 2012 13:36:05 +0200
>>
>> Reported-by: Stefan Bader <stefan.bader@canonical.com>
>> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
>> ---
>> --- a/include/linux/sched.h
>> +++ b/include/linux/sched.h
>> @@ -1246,6 +1246,9 @@ struct task_struct {
>>       const struct sched_class *sched_class;
>>       struct sched_entity se;
>>       struct sched_rt_entity rt;
>> +#ifdef CONFIG_CGROUP_SCHED
>> +     struct task_group *sched_task_group;
>> +#endif
>>

And the third,  https://lkml.org/lkml/2012/6/26/331

>From d751ab1f1e532f32412d99b71a1bfea3e5282d07 Mon Sep 17 00:00:00 2001
From: Peter Zijlstra <peterz@infradead.org>
Date: Fri, 22 Jun 2012 13:36:00 +0200
Subject: [PATCH] sched: Fix race in task_group()

Stefan reported a crash on a kernel before a3e5d1091c1 ("sched: Don't
call task_group() too many times in set_task_rq()"), he found the reason
to be that the multiple task_group() invocations in set_task_rq()
returned different values.

Looking at all that I found a lack of serialization and plain wrong
comments.

The below tries to fix it using an extra pointer which is updated under
the appropriate scheduler locks. Its not pretty, but I can't really see
another way given how all the cgroup stuff works.

Reported-and-tested-by: Stefan Bader <stefan.bader@canonical.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
[backported to apply to 3.0 and 3.2]
Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
---
 include/linux/init_task.h |   12 +++++++++++-
 include/linux/sched.h     |    5 ++++-
 kernel/sched.c            |   32 ++++++++++++++++++--------------
 3 files changed, 33 insertions(+), 16 deletions(-)
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 56de5c1..1fd9884 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1242,6 +1242,9 @@ struct task_struct {
 	const struct sched_class *sched_class;
 	struct sched_entity se;
 	struct sched_rt_entity rt;
+#ifdef CONFIG_CGROUP_SCHED
+	struct task_struct *sched_task_group;
+#endif

where sched_task_group was defined to be task_struct twice(in the first
and the third versions) and to be task_group once.

Before backport, feel free to respin with the final define determined.
