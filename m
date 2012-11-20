Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752023Ab2KTGx5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 01:53:57 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:54542 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751389Ab2KTGxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 01:53:55 -0500
MIME-Version: 1.0
In-Reply-To: <CAGXu5j+B=kx6847EUn6tppNwNk=YHbBwekqr6V22+gh2Lfea0g@mail.gmail.com>
References: <20121119233459.GA9524@www.outflux.net>
	<20121120034515.GA5212@sergelap>
	<CAGXu5j+B=kx6847EUn6tppNwNk=YHbBwekqr6V22+gh2Lfea0g@mail.gmail.com>
Date: Mon, 19 Nov 2012 22:53:54 -0800
X-Google-Sender-Auth: mmdMhetd0HlYpCbpEim2s52OXPk
Message-ID: <CAGXu5jLUZTfEfK7t8P68WiZ4pzHN=C8L=Gd6bWBe3p7tKhzFEA@mail.gmail.com>
Subject: Re: [PATCH] Yama: remove locking from delete path
From: Kees Cook <keescook@chromium.org>
To: Serge Hallyn <serge.hallyn@canonical.com>
Cc: linux-kernel@vger.kernel.org, James Morris <james.l.morris@oracle.com>,
        John Johansen <john.johansen@canonical.com>,
        "Serge E. Hallyn" <serge.hallyn@ubuntu.com>,
        Eric Paris <eparis@redhat.com>, linux-security-module@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 19, 2012 at 10:14 PM, Kees Cook <keescook@chromium.org> wrote:
> On Mon, Nov 19, 2012 at 7:45 PM, Serge Hallyn
> <serge.hallyn@canonical.com> wrote:
>> Quoting Kees Cook (keescook@chromium.org):
>>> Instead of locking the list during a delete, mark entries as invalid
>>> and trigger a workqueue to clean them up. This lets us easily handle
>>> task_free from interrupt context.
>>>
>>> Cc: Sasha Levin <sasha.levin@oracle.com>
>>> Signed-off-by: Kees Cook <keescook@chromium.org>
>>> ---
>>>  security/yama/yama_lsm.c |   43 ++++++++++++++++++++++++++++++++++++-------
>>>  1 file changed, 36 insertions(+), 7 deletions(-)
>>>
>>> diff --git a/security/yama/yama_lsm.c b/security/yama/yama_lsm.c
>>> index 17da6ca..1cba901 100644
>>> --- a/security/yama/yama_lsm.c
>>> +++ b/security/yama/yama_lsm.c
>>> @@ -17,6 +17,7 @@
>>>  #include <linux/ptrace.h>
>>>  #include <linux/prctl.h>
>>>  #include <linux/ratelimit.h>
>>> +#include <linux/workqueue.h>
>>>
>>>  #define YAMA_SCOPE_DISABLED  0
>>>  #define YAMA_SCOPE_RELATIONAL        1
>>> @@ -29,6 +30,7 @@ static int ptrace_scope = YAMA_SCOPE_RELATIONAL;
>>>  struct ptrace_relation {
>>>       struct task_struct *tracer;
>>>       struct task_struct *tracee;
>>> +     bool invalid;
>>>       struct list_head node;
>>>       struct rcu_head rcu;
>>>  };
>>> @@ -36,6 +38,27 @@ struct ptrace_relation {
>>>  static LIST_HEAD(ptracer_relations);
>>>  static DEFINE_SPINLOCK(ptracer_relations_lock);
>>>
>>> +static void yama_relation_cleanup(struct work_struct *work);
>>> +static DECLARE_WORK(yama_relation_work, yama_relation_cleanup);
>>> +
>>> +/**
>>> + * yama_relation_cleanup - remove invalid entries from the relation list
>>> + *
>>> + */
>>> +static void yama_relation_cleanup(struct work_struct *work)
>>> +{
>>> +     struct ptrace_relation *relation;
>>> +
>>> +     spin_lock(&ptracer_relations_lock);
>>> +     list_for_each_entry_rcu(relation, &ptracer_relations, node) {
>>> +             if (relation->invalid) {
>>> +                     list_del_rcu(&relation->node);
>>> +                     kfree_rcu(relation, rcu);
>>> +             }
>>> +     }
>>> +     spin_unlock(&ptracer_relations_lock);
>>> +}
>>> +
>>>  /**
>>>   * yama_ptracer_add - add/replace an exception for this tracer/tracee pair
>>>   * @tracer: the task_struct of the process doing the ptrace
>>> @@ -57,9 +80,12 @@ static int yama_ptracer_add(struct task_struct *tracer,
>>>
>>>       added->tracee = tracee;
>>>       added->tracer = tracer;
>>> +     added->invalid = false;
>>>
>>> -     spin_lock_bh(&ptracer_relations_lock);
>>> +     spin_lock(&ptracer_relations_lock);
>>>       list_for_each_entry_rcu(relation, &ptracer_relations, node) {
>>> +             if (relation->invalid)
>>> +                     continue;
>>>               if (relation->tracee == tracee) {
>>>                       list_replace_rcu(&relation->node, &added->node);
>>>                       kfree_rcu(relation, rcu);
>>> @@ -70,7 +96,7 @@ static int yama_ptracer_add(struct task_struct *tracer,
>>>       list_add_rcu(&added->node, &ptracer_relations);
>>>
>>>  out:
>>> -     spin_unlock_bh(&ptracer_relations_lock);
>>> +     spin_unlock(&ptracer_relations_lock);
>>>       return 0;
>>>  }
>>>
>>> @@ -84,15 +110,15 @@ static void yama_ptracer_del(struct task_struct *tracer,
>>>  {
>>>       struct ptrace_relation *relation;
>>>
>>> -     spin_lock_bh(&ptracer_relations_lock);
>>
>> I don't understand - is there a patch I don't have sitting around
>> which puts the calls to yama_ptracer_del() under rcu_read_lock()?
>> If not, I don't see how it's safe to walk the list here and risk
>> racing against another yama_relation_cleanup() run.
>>
>> I'm probably missing something really cool about the locking,
>> but it doesn't look right to me.  I would think you'd want to
>> do the loop under rcu_read_lock(), set a boolean if one is
>> changed, and call schedule_work() once at the end if the boolean
>> is set.
>
> Unless I'm mistaken and my lockdep tests are wrong,
> list_for_each_entry_rcu runs under rcu_read_lock().

Ew, yeah, no, the examples I was looking at are missing
rcu_read_lock(). That's sad. Anyway, I'll fix this up here and in the
other patch.

> I could optimize it to only run schedule_work() once all the marking
> is done at the end of the loop.

And I'll do this.

-Kees

>
> -Kees
>
>>
>>>       list_for_each_entry_rcu(relation, &ptracer_relations, node) {
>>> +             if (relation->invalid)
>>> +                     continue;
>>>               if (relation->tracee == tracee ||
>>>                   (tracer && relation->tracer == tracer)) {
>>> -                     list_del_rcu(&relation->node);
>>> -                     kfree_rcu(relation, rcu);
>>> +                     relation->invalid = true;
>>> +                     schedule_work(&yama_relation_work);
>>>               }
>>>       }
>>> -     spin_unlock_bh(&ptracer_relations_lock);
>>>  }
>>>
>>>  /**
>>> @@ -219,12 +245,15 @@ static int ptracer_exception_found(struct task_struct *tracer,
>>>       rcu_read_lock();
>>>       if (!thread_group_leader(tracee))
>>>               tracee = rcu_dereference(tracee->group_leader);
>>> -     list_for_each_entry_rcu(relation, &ptracer_relations, node)
>>> +     list_for_each_entry_rcu(relation, &ptracer_relations, node) {
>>> +             if (relation->invalid)
>>> +                     continue;
>>>               if (relation->tracee == tracee) {
>>>                       parent = relation->tracer;
>>>                       found = true;
>>>                       break;
>>>               }
>>> +     }
>>>
>>>       if (found && (parent == NULL || task_is_descendant(parent, tracer)))
>>>               rc = 1;
>>> --
>>> 1.7.9.5
>>>
>>>
>>> --
>>> Kees Cook
>>> Chrome OS Security
>
> --
> Kees Cook
> Chrome OS Security



-- 
Kees Cook
Chrome OS Security
