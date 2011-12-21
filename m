Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753901Ab1LUUSF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 15:18:05 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:35569 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752361Ab1LUUSD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 15:18:03 -0500
MIME-Version: 1.0
In-Reply-To: <4EF16DE1.8010909@canonical.com>
References: <1324333066-12452-1-git-send-email-keescook@chromium.org>
	<1324333066-12452-3-git-send-email-keescook@chromium.org>
	<4EF16DE1.8010909@canonical.com>
Date: Wed, 21 Dec 2011 12:18:02 -0800
X-Google-Sender-Auth: SulZm9USRPDDksJmwE0Vwu1K0DM
Message-ID: <CAGXu5jKDnwTnFb4ziAhPeJ_7qaqfpBEtupSaq0i3jThP9Lhc9A@mail.gmail.com>
Subject: Re: [kernel-hardening] [PATCH 2/2] security: Yama LSM
From: Kees Cook <keescook@chromium.org>
To: John Johansen <john.johansen@canonical.com>
Cc: kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        Roland McGrath <roland@hack.frob.com>,
        James Morris <jmorris@namei.org>
X-System-Of-Record: true
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 20, 2011 at 9:25 PM, John Johansen
<john.johansen@canonical.com> wrote:
> On 12/19/2011 02:17 PM, Kees Cook wrote:
>> This adds the Yama Linux Security Module to collect DAC security
>> improvements (specifically just ptrace restrictions for now) that have
>> existed in various forms over the years and have been carried outside the
>> mainline kernel by other Linux distributions like Openwall and grsecurity.
>>
>> Signed-off-by: Kees Cook <keescook@chromium.org>
>
> This is looking really good.  I have a few notes inlined below but I didn't
> find any problems.
>
> I am happy giving it an
> Acked-by: John Johansen <john.johansen@canonical.com>

Thanks for the review!

>> +/**
>> + * yama_ptracer_add - add/replace an exception for this tracer/tracee pair
>> + * @tracer: the task_struct of the process doing the ptrace
>> + * @tracee: the task_struct of the process to be ptraced
>> + *
>> + * Returns 0 if relationship was added, -ve on error.
>> + */
> It might be good to add a note here, or a more explicit note in the Yama
> Documentation that a tracee can only have a single tracer (+ its descendants).

Good idea; I've added a note in both places now.

>> +static int yama_ptracer_add(struct task_struct *tracer,
>> +                         struct task_struct *tracee)
>> +{
>> +     int rc = 0;
>> +     struct ptrace_relation *added;
>> +     struct ptrace_relation *entry, *relation = NULL;
>> +
>> +     added = kmalloc(sizeof(*added), GFP_KERNEL);
>> +     spin_lock_bh(&ptracer_relations_lock);
>> +     list_for_each_entry(entry, &ptracer_relations, node)
>> +             if (entry->tracee == tracee) {
>> +                     relation = entry;
>> +                     break;
>> +             }
>> +     if (!relation) {
>> +             relation = added;
>> +             if (!relation) {
>> +                     rc = -ENOMEM;
>> +                     goto unlock_out;
>> +             }
>> +             relation->tracee = tracee;
>> +             list_add(&relation->node, &ptracer_relations);
>> +     }
>> +     relation->tracer = tracer;
>> +
>> +unlock_out:
>> +     spin_unlock_bh(&ptracer_relations_lock);
>> +     if (added && added != relation)
>> +             kfree(added);
>> +
>> +     return rc;
>> +}
>> +
> I think pulling the out of the locking makes the fn a little easier to
> read.

Agreed, I've done this now. I think my original thought was "why check
'added' unless we actually need it?" But it just makes the whole thing
harder to read.

>> +     spin_lock_bh(&ptracer_relations_lock);
>> +     list_for_each_safe(list, safe, &ptracer_relations) {
>> +             relation = list_entry(list, struct ptrace_relation, node);
> You could use list_for_each_entry_safe here
>        list_for_each_entry_safe(relation, safe, &ptracer_relations, node)

Ah! Yes, thanks for catching this.

>> + * yama_task_prctl - check for Yama-specific prctl operations
>> + * @option: operation
>> + * @arg2: argument
>> + * @arg3: argument
>> + * @arg4: argument
>> + * @arg5: argument
>> + *
>> + * Return 0 on success, -ve on error.  -ENOSYS is returned when Yama
>> + * does not handle the given option.
>> + */
> So maybe add a note here about why the tracee is being stored via the
> group_leader, but that the tracer isn't.  Its not really a problem but I
> tripped over this at first as I was going through the code.

Yeah, dealing with when a thread might be calling these things lead to
some confusion. In the end, I have to check group_leader in a few
places, and this was a seemingly good place too. I might rework this a
bit, but in the meantime, I've added a comment explaining my
reasoning.

Thanks!

-Kees

-- 
Kees Cook
ChromeOS Security
