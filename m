Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754826Ab1ERHSt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 03:18:49 -0400
Received: from smtp-out.google.com ([74.125.121.67]:39690 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754599Ab1ERHSr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 03:18:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=MzdV/IfSSJwBSODwLA1FXqql1a+luMsQLnJDQTOR2My4gjB7yCEeCaTgKtvZsfNO3z
         P5Np8Ac+kg7/jqkLBzRw==
MIME-Version: 1.0
In-Reply-To: <1305639062.2466.5749.camel@twins>
References: <20110503092846.022272244@google.com> <20110503092905.340562757@google.com>
 <1305639062.2466.5749.camel@twins>
From: Paul Turner <pjt@google.com>
Date: Wed, 18 May 2011 00:18:14 -0700
Message-ID: <BANLkTimSv0wuNY71ZkmK1vAAa41=tK0V=w@mail.gmail.com>
Subject: Re: [patch 10/15] sched: allow for positional tg_tree walks
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 17, 2011 at 6:31 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Tue, 2011-05-03 at 02:28 -0700, Paul Turner wrote:
>> plain text document attachment (sched-bwc-refactor-walk_tg_tree.patch)
>> Extend walk_tg_tree to accept a positional argument
>>
>> static int walk_tg_tree_from(struct task_group *from,
>>                            tg_visitor down, tg_visitor up, void *data)
>>
>> Existing semantics are preserved, caller must hold rcu_lock() or sufficient
>> analogue.
>>
>> Signed-off-by: Paul Turner <pjt@google.com>
>> ---
>>  kernel/sched.c |   34 +++++++++++++++++++++++-----------
>>  1 file changed, 23 insertions(+), 11 deletions(-)
>>
>> Index: tip/kernel/sched.c
>> ===================================================================
>> --- tip.orig/kernel/sched.c
>> +++ tip/kernel/sched.c
>> @@ -1430,21 +1430,19 @@ static inline void dec_cpu_load(struct r
>>  #if (defined(CONFIG_SMP) && defined(CONFIG_FAIR_GROUP_SCHED)) || defined(CONFIG_RT_GROUP_SCHED)
>>  typedef int (*tg_visitor)(struct task_group *, void *);
>>
>> -/*
>> - * Iterate the full tree, calling @down when first entering a node and @up when
>> - * leaving it for the final time.
>> - */
>> -static int walk_tg_tree(tg_visitor down, tg_visitor up, void *data)
>> +/* Iterate task_group tree rooted at *from */
>> +static int walk_tg_tree_from(struct task_group *from,
>> +                          tg_visitor down, tg_visitor up, void *data)
>>  {
>>       struct task_group *parent, *child;
>>       int ret;
>>
>> -     rcu_read_lock();
>> -     parent = &root_task_group;
>> +     parent = from;
>> +
>>  down:
>>       ret = (*down)(parent, data);
>>       if (ret)
>> -             goto out_unlock;
>> +             goto out;
>>       list_for_each_entry_rcu(child, &parent->children, siblings) {
>>               parent = child;
>>               goto down;
>> @@ -1453,14 +1451,28 @@ up:
>>               continue;
>>       }
>>       ret = (*up)(parent, data);
>> -     if (ret)
>> -             goto out_unlock;
>> +     if (ret || parent == from)
>> +             goto out;
>>
>>       child = parent;
>>       parent = parent->parent;
>>       if (parent)
>>               goto up;
>> -out_unlock:
>> +out:
>> +     return ret;
>> +}
>> +
>> +/*
>> + * Iterate the full tree, calling @down when first entering a node and @up when
>> + * leaving it for the final time.
>> + */
>> +
>> +static inline int walk_tg_tree(tg_visitor down, tg_visitor up, void *data)
>> +{
>> +     int ret;
>> +
>> +     rcu_read_lock();
>> +     ret = walk_tg_tree_from(&root_task_group, down, up, data);
>>       rcu_read_unlock();
>>
>>       return ret;
>
> I don't much like the different locking rules for these two functions. I
> don't much care which you pick, but please make them consistent.
>

Reasonable, given the call sites it would seem to make more sense to
make things consistent in the direction of depending on having the
caller do the locking.  Will update.

>
