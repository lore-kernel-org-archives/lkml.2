Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754315Ab2ALRLB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 12:11:01 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:35804 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752525Ab2ALRK5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 12:10:57 -0500
MIME-Version: 1.0
In-Reply-To: <20120112162231.GA23960@redhat.com>
References: <1326302710-9427-1-git-send-email-wad@chromium.org>
	<1326302710-9427-2-git-send-email-wad@chromium.org>
	<20120112162231.GA23960@redhat.com>
Date: Thu, 12 Jan 2012 11:10:55 -0600
Message-ID: <CABqD9hbjGYA-jAOe-3CZEUV3MG2Qgs6SJ2irN7N+JMB2wj-mzA@mail.gmail.com>
Subject: Re: [RFC,PATCH 1/2] seccomp_filters: system call filtering using BPF
From: Will Drewry <wad@chromium.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, keescook@chromium.org,
        john.johansen@canonical.com, serge.hallyn@canonical.com,
        coreyb@linux.vnet.ibm.com, pmoore@redhat.com, eparis@redhat.com,
        djm@mindrot.org, torvalds@linux-foundation.org, segoon@openwall.com,
        rostedt@goodmis.org, jmorris@namei.org, scarybeasts@gmail.com,
        avi@redhat.com, penberg@cs.helsinki.fi, viro@zeniv.linux.org.uk,
        luto@mit.edu, mingo@elte.hu, akpm@linux-foundation.org, khilman@ti.com,
        borislav.petkov@amd.com, amwang@redhat.com, ak@linux.intel.com,
        eric.dumazet@gmail.com, gregkh@suse.de, dhowells@redhat.com,
        daniel.lezcano@free.fr, linux-fsdevel@vger.kernel.org,
        linux-security-module@vger.kernel.org, olofj@chromium.org,
        mhalcrow@google.com, dlaor@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 12, 2012 at 10:22 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> On 01/11, Will Drewry wrote:
>>
>> +__weak u8 *seccomp_get_regs(u8 *scratch, size_t *available)
>> +{
>> +     /* regset is usually returned based on task personality, not current
>> +      * system call convention.  This behavior makes it unsafe to execute
>> +      * BPF programs over regviews if is_compat_task or the personality
>> +      * have changed since the program was installed.
>> +      */
>> +     const struct user_regset_view *view = task_user_regset_view(current);
>> +     const struct user_regset *regset = &view->regsets[0];
>> +     size_t scratch_size = *available;
>> +     if (regset->core_note_type != NT_PRSTATUS) {
>> +             /* The architecture should override this method for speed. */
>> +             regset = find_prstatus(view);
>> +             if (!regset)
>> +                     return NULL;
>> +     }
>> +     *available = regset->n * regset->size;
>> +     /* Make sure the scratch space isn't exceeded. */
>> +     if (*available > scratch_size)
>> +             *available = scratch_size;
>> +     if (regset->get(current, regset, 0, *available, scratch, NULL))
>> +             return NULL;
>> +     return scratch;
>> +}
>> +
>> +/**
>> + * seccomp_test_filters - tests 'current' against the given syscall
>> + * @syscall: number of the system call to test
>> + *
>> + * Returns 0 on ok and non-zero on error/failure.
>> + */
>> +int seccomp_test_filters(int syscall)
>> +{
>> +     struct seccomp_filter *filter;
>> +     u8 regs_tmp[sizeof(struct user_regs_struct)], *regs;
>> +     size_t regs_size = sizeof(struct user_regs_struct);
>> +     int ret = -EACCES;
>> +
>> +     filter = current->seccomp.filter; /* uses task ref */
>> +     if (!filter)
>> +             goto out;
>> +
>> +     /* All filters in the list are required to share the same system call
>> +      * convention so only the first filter is ever checked.
>> +      */
>> +     if (seccomp_check_personality(filter))
>> +             goto out;
>> +
>> +     /* Grab the user_regs_struct.  Normally, regs == &regs_tmp, but
>> +      * that is not mandatory.  E.g., it may return a point to
>> +      * task_pt_regs(current).  NULL checking is mandatory.
>> +      */
>> +     regs = seccomp_get_regs(regs_tmp, &regs_size);
>
> Stupid question. I am sure you know what are you doing ;) and I know
> nothing about !x86 arches.
>
> But could you explain why it is designed to use user_regs_struct ?
> Why we can't simply use task_pt_regs() and avoid the (costly) regsets?

So on x86 32, it would work since user_regs_struct == task_pt_regs
(iirc), but on x86-64
and others, that's not true.  I don't think it's kosher to expose
pt_regs to the userspace, but if, let's say, x86-32 overrides the weak
linkage, then it could just return task_pt_regs and be the fastest
path.

If it would be appropriate to expose pt_regs to userspace, then I'd
happily do so :)
