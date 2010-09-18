Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754829Ab0IRCeW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 22:34:22 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:38320 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754669Ab0IRCeR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 22:34:17 -0400
MIME-Version: 1.0
In-Reply-To: <20100918012939.GA25046@redhat.com>
References: <20100917152639.0e88341a@basil.nowhere.org>
	<1284736618-27153-2-git-send-email-wad@chromium.org>
	<20100918012939.GA25046@redhat.com>
Date: Fri, 17 Sep 2010 21:34:16 -0500
Message-ID: <AANLkTimsNtoT2GGCv1Zk2cGCsZ17zsOqV1DiF7D5tV=L@mail.gmail.com>
Subject: Re: [PATCH 2/2] exec: move core_pattern pipe helper into the crashing namespace
From: Will Drewry <wad@chromium.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Roland McGrath <roland@redhat.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        containers@lists.linux-foundation.org, Eugene Teo <eteo@redhat.com>,
        Tejun Heo <tj@kernel.org>, Serge Hallyn <serue@us.ibm.com>,
        Alexey Dobriyan <adobriyan@gmail.com>, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 17, 2010 at 8:29 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> On 09/17, Will Drewry wrote:
>>
>> Instead, this change implements the more complex option two.  It
>> migrates the ____call_usermodehelper() thread into the same namespaces
>> as the dumping process.  It does not assign a pid in that namespace so
>> the collector will appear to be pid 0.
>
> Hmm... You mean, it won't visible in that namespace? Afacis, it should
> have the correct pid in the init ns, no?

Exactly - it will be unmapped in its new pid namespace, returning 0
only in that case, as you point out below!

>
> I am a bit worried task_active_pid_ns() != nsproxy->pid_ns, but perhaps
> this is OK... Say, sys_getpid() returns 0, strange.
>
>> +             /* Run the core_collector in the crashing namespaces */
>> +             if (copy_namespaces_unattached(0, current,
>> +                     &pipe_params.nsproxy, &pipe_params.fs)) {
>> +                     printk(KERN_WARNING "%s failed to copy namespaces\n",
>> +                            __func__);
>> +                     argv_free(helper_argv);
>> +                     goto fail_dropcount;
>> +             }
>
> This looks overcomplicated to me, or I missed something.
>
> I do not understand why should we do this beforehand, and why we need
> copy_namespaces_unattached().
>
> Can't you just pass current to umh_pipe_setup() (or another helper) as
> the argument? Then this helper can copy ->fs and ->nsproxy itself.

I wasn't sure if it was reasonable to pass the current task_struct
over, but I certainly can.

> In fact, I do not understand why create_new_namespaces() is used. It
> is called with flags == 0 anyway, can't we just do
>
>        ns = coredumping_task->nsproxy;
>        get_nsproxy(ns);
>        switch_task_namespaces(current, ns);
>
> ?

So that was my first thought (which I tried).  I did exactly what you
suggested to the khelper thread, and the lack of the fs struct bit me.
 Since the older patch from Eric Biederman (setns()) had taken the
route of deflecting the work through create_new_namespaces(), I did
too.  I figured it would ensure that any namespacing behavior that
needed to be done would be done.

In practice, this seems to amount to just adding a refcount to all the
namespaces and creating a new nsproxy which isn't really needed.  Most
likely, doing what you've suggested above plus the copy_fs_struct and
the swap out will do the trick.  I'll try it out and see.  That's make
it much clearer I think.

thanks!
will
