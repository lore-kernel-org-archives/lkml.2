Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752640Ab1DUGnY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 02:43:24 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:51256 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704Ab1DUGnX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 02:43:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=NaLYoaA2SROUtqD7VoFM0wOrO8dMw6dpwO96sSXc1pj8341GgnAPGWJR6mQQE8zwS1
         Py2P4w3he8sCMPqBlueZN9gJ/vhVTOW8PSSgf/rUUXsC6ay9ai0tQhs1gZK4DOraSaJ8
         /yaTKZIXBLSmXdm9V3eg+SnA2iIdsbkhoEnR8=
MIME-Version: 1.0
In-Reply-To: <20110421014259.132728798@goodmis.org>
References: <20110421014153.126662477@goodmis.org>
	<20110421014259.132728798@goodmis.org>
Date: Thu, 21 Apr 2011 14:43:22 +0800
Message-ID: <BANLkTimdMP52JCWCJp9Qfz=kWDMYWdQqgg@mail.gmail.com>
Subject: Re: [PATCH 1/7] lockdep: Print a nice description of an irq locking issue
From: Yong Zhang <yong.zhang0@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 21, 2011 at 9:41 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
>  ---
>
> The above is the case when the unsafe lock is taken while holding
> a lock taken in irq context. But when a lock is taken that also
> grabs a unsafe lock, the call chain is shown:
>
>  ---
> other info that might help us debug this:
>
> Chain exists of:
>  &rq->lock --> lockA --> lockC
>
>  Possible interrupt unsafe locking scenario:
>
>       CPU0                    CPU1
>       ----                    ----
>  lock(lockC);
>                               local_irq_disable();
>                               lock(&rq->lock);
>                               lock(lockA);
>  <Interrupt>
>    lock(&rq->lock);
>
>  *** DEADLOCK ***

But this is not a real deadlock, right? Or maybe you can teach me :)

I just assume your scenario should show a more real one, But for
a possible irq-dependence deadlock, it seems not easy to find out.

Thanks,
Yong

>
> Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  kernel/lockdep.c |   70 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 70 insertions(+), 0 deletions(-)
>
> diff --git a/kernel/lockdep.c b/kernel/lockdep.c
> index 0d2058d..bb77c030 100644
> --- a/kernel/lockdep.c
> +++ b/kernel/lockdep.c
> @@ -490,6 +490,18 @@ void get_usage_chars(struct lock_class *class, char usage[LOCK_USAGE_CHARS])
>        usage[i] = '\0';
>  }
>
> +static int __print_lock_name(struct lock_class *class)
> +{
> +       char str[KSYM_NAME_LEN];
> +       const char *name;
> +
> +       name = class->name;
> +       if (!name)
> +               name = __get_key_name(class->key, str);
> +
> +       return printk("%s", name);
> +}
> +
>  static void print_lock_name(struct lock_class *class)
>  {
>        char str[KSYM_NAME_LEN], usage[LOCK_USAGE_CHARS];
> @@ -1325,6 +1337,62 @@ print_shortest_lock_dependencies(struct lock_list *leaf,
>        return;
>  }
>
> +static void
> +print_irq_lock_scenario(struct lock_list *safe_entry,
> +                       struct lock_list *unsafe_entry,
> +                       struct held_lock *prev,
> +                       struct held_lock *next)
> +{
> +       struct lock_class *safe_class = safe_entry->class;
> +       struct lock_class *unsafe_class = unsafe_entry->class;
> +       struct lock_class *middle_class = hlock_class(prev);
> +
> +       if (middle_class == safe_class)
> +               middle_class = hlock_class(next);
> +
> +       /*
> +        * A direct locking problem where unsafe_class lock is taken
> +        * directly by safe_class lock, then all we need to show
> +        * is the deadlock scenario, as it is obvious that the
> +        * unsafe lock is taken under the safe lock.
> +        *
> +        * But if there is a chain instead, where the safe lock takes
> +        * an intermediate lock (middle_class) where this lock is
> +        * not the same as the safe lock, then the lock chain is
> +        * used to describe the problem. Otherwise we would need
> +        * to show a different CPU case for each link in the chain
> +        * from the safe_class lock to the unsafe_class lock.
> +        */
> +       if (middle_class != unsafe_class) {
> +               printk("Chain exists of:\n  ");
> +               __print_lock_name(safe_class);
> +               printk(" --> ");
> +               __print_lock_name(middle_class);
> +               printk(" --> ");
> +               __print_lock_name(unsafe_class);
> +               printk("\n\n");
> +       }
> +
> +       printk(" Possible interrupt unsafe locking scenario:\n\n");
> +       printk("       CPU0                    CPU1\n");
> +       printk("       ----                    ----\n");
> +       printk("  lock(");
> +       __print_lock_name(unsafe_class);
> +       printk(");\n");
> +       printk("                               local_irq_disable();\n");
> +       printk("                               lock(");
> +       __print_lock_name(safe_class);
> +       printk(");\n");
> +       printk("                               lock(");
> +       __print_lock_name(middle_class);
> +       printk(");\n");
> +       printk("  <Interrupt>\n");
> +       printk("    lock(");
> +       __print_lock_name(safe_class);
> +       printk(");\n");
> +       printk("\n *** DEADLOCK ***\n\n");
> +}
> +
>  static int
>  print_bad_irq_dependency(struct task_struct *curr,
>                         struct lock_list *prev_root,
> @@ -1376,6 +1444,8 @@ print_bad_irq_dependency(struct task_struct *curr,
>        print_stack_trace(forwards_entry->class->usage_traces + bit2, 1);
>
>        printk("\nother info that might help us debug this:\n\n");
> +       print_irq_lock_scenario(backwards_entry, forwards_entry, prev, next);
> +
>        lockdep_print_held_locks(curr);
>
>        printk("\nthe dependencies between %s-irq-safe lock", irqclass);
> --
> 1.7.2.3
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
Only stand for myself
