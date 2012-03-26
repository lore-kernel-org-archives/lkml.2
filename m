Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933181Ab2CZRpN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 13:45:13 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:33399 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932774Ab2CZRpL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 13:45:11 -0400
MIME-Version: 1.0
In-Reply-To: <m1ty1esa52.fsf@fess.ebiederm.org>
References: <20120313005855.GA24639@redhat.com> <CA+55aFwb2WRRamWPVY-ETDG_LO0QR9C8epk8tSAJVZhPFSNzhA@mail.gmail.com>
 <20120318192755.GB6589@ZenIV.linux.org.uk> <CAMOw1v4qa_AxJgc+qAsY6M=K--2JDvO-+CNj8OwKuE7piRViGw@mail.gmail.com>
 <m1vclw1fx8.fsf@fess.ebiederm.org> <CAMOw1v4gszzV7F3z1m+RWEe9UDgR2Jrp9wX_w9z_1UkXT=FL5Q@mail.gmail.com>
 <m1iphuu9pd.fsf_-_@fess.ebiederm.org> <CAMOw1v65TePmMOxzGsnW4xv1ge1RDD=Stxgo9-eqtyi8hdjZOQ@mail.gmail.com>
 <m1ty1esa52.fsf@fess.ebiederm.org>
From: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Date: Mon, 26 Mar 2012 14:44:50 -0300
Message-ID: <CAMOw1v4hZFk20QzvwWUL73Nax2m77HOkfp0KkuOPFjCgYprZgw@mail.gmail.com>
Subject: Re: [REVIEW][PATCH] Making poll generally useful for sysctls
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric,

On Sat, Mar 24, 2012 at 4:58 AM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
> Lucas De Marchi <lucas.demarchi@profusion.mobi> writes:
>
>>>  /* A sysctl table is an array of struct ctl_table: */
>>>  struct ctl_table
>>>  {
>>>        const char *procname;           /* Text ID for /proc/sys, or zero */
>>>        void *data;
>>> +       atomic_t event;
>>>        int maxlen;
>>>        umode_t mode;
>>>        struct ctl_table *child;        /* Deprecated */
>>>        proc_handler *proc_handler;     /* Callback for text formatting */
>>> -       struct ctl_table_poll *poll;
>>>        void *extra1;
>>>        void *extra2;
>>>  };
>>> @@ -1042,6 +1025,7 @@ struct ctl_table_header
>>>                };
>>>                struct rcu_head rcu;
>>>        };
>>> +       wait_queue_head_t wait;
>>
>> If you have a waitqueue per table instead of per entry you will get
>> spurious notifications when other entries change. The easiest way to
>> test this is to poll /proc/sys/kernel/hostname and change your
>> domainname.
>
> You will get spurious wakeups but not spurious notifications to
> userspace since event is still per entry.

Yeah, indeed.

> For my money that seemed a nice compromise of code simplicity, and
> generality.  We could of course do something much closer to what
> sysfs does and allocate and refcount something similar to your
> ctl_table_poll when we have a ctl_table opened.  But that just looked
> like a pain.

I don't think we want spurious wakeups in favor of a slightly simpler code.


>
> Of course we already have spurious notifications for hostname and
> domainname when multiple uts namespaces are involved, but that
> is a different problem.
>
>> I couldn't apply this patch to any tree (linus/master + my previous
>> patch, your master, 3.3 + my previous patch), so I couldn't test. On
>> top of your tree:
>
> How odd.  It should have applied cleanly to my tree and it applies
> with just a two line offset top of Linus's latest with my tree merged
> in.  Those two lines of offset coming from the two extra includes
> that came in through the merge.
>
> patch -p1 --dry-run <  ~/tmp/sysctl-poll-test.patch
> patching file fs/proc/proc_sysctl.c
> Hunk #1 succeeded at 18 (offset 2 lines).
> Hunk #2 succeeded at 173 (offset 2 lines).
> Hunk #3 succeeded at 245 (offset 2 lines).
> Hunk #4 succeeded at 512 (offset 2 lines).
> Hunk #5 succeeded at 542 (offset 2 lines).
> Hunk #6 succeeded at 561 (offset 2 lines).
> patching file include/linux/sysctl.h
> patching file kernel/utsname_sysctl.c
>
>> [lucas@vader kernel]$ git am /tmp/a.patch
>> Applying: Making poll generally useful for sysctls
>> error: patch failed: fs/proc/proc_sysctl.c:16
>> error: fs/proc/proc_sysctl.c: patch does not apply
>> error: patch failed: include/linux/sysctl.h:992
>> error: include/linux/sysctl.h: patch does not apply
>> Patch failed at 0001 Making poll generally useful for sysctls
>
> Here is rebased version of the patch just in case that helps.

Now I can apply, but I can't boot: we hit a NULL dereference in
__wake_up_common(), called by proc_sys_poll_notify(). It seems that
you forgot to initialize the waitqueue with
__WAIT_QUEUE_HEAD_INITIALIZER().


Lucas De Marchi
