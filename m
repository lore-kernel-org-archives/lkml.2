Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753692Ab2LYIfJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2012 03:35:09 -0500
Received: from mail-vc0-f181.google.com ([209.85.220.181]:53381 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753623Ab2LYIfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2012 03:35:07 -0500
MIME-Version: 1.0
In-Reply-To: <20121224165306.GA9553@redhat.com>
References: <1356336807-5517-1-git-send-email-avagin@openvz.org>
	<1356336807-5517-2-git-send-email-avagin@openvz.org>
	<20121224165306.GA9553@redhat.com>
Date: Tue, 25 Dec 2012 12:29:25 +0400
Message-ID: <CANaxB-x=fQROdwD1OyU8=Ai9tXWm9QTSsGgfKvPbjn57ER6aZg@mail.gmail.com>
Subject: Re: [PATCH 1/4] signalfd: add ability to return siginfo in a raw format
From: Andrey Wagin <avagin@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, criu@openvz.org,
        linux-fsdevel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/12/24 Oleg Nesterov <oleg@redhat.com>:
> On 12/24, Andrey Vagin wrote:
>>
>> signalfd should be called with the flag SFD_RAW for that.
>>
>> signalfd_siginfo is not full for siginfo with a negative si_code.
>> copy_siginfo_to_user() is copied a full siginfo to user-space, if
>> si_code is negative.  signalfd_copyinfo() doesn't do that and can't be
>> expanded, because it has not compatiable format with siginfo_t.
>
> Yes, but otoh perhaps we should change (fix) signalfd_siginfo/copyinfo,
> its "default" case makes no sense if si_code < 0.

Its "default" case makes sense if a signal is sent by sigqueue(pid,sig,ptr).

I'm afraid, we can change (fix) signalfd_copyinfo, because for
negative si_code a whole siginfo should be copied to userspace.
Currently if si_code is unknown, signalfd_copyinfo sets only ssi_ptr
and that can't be changed due to backward compatibility. ssi_ptr is in
the midle of signalfd_siginfo and a sizeof(signalfd_siginfo) is equal
to sizeof(siginfo_t). We don't have space to copied siginfo into
signalfd_siginfo.

If we want to have another format with SFD_RAW, I prefer to have
siginfo_t instead of signalfd_siginfo. Because if si_code is negative,
it should be siginfo_t in any case. A minor thing is that it can be
sent back without modifications.

Oleg, thank you for the comments.

>
>> Another problem is that a constant __SI_* is removed from si_code.
>
> OK, so you add the additional put_user(kinfo->si_code). Again, in
> this case we can extend signalfd_siginfo perhaps...
>
> Anyway, the patch doesn't look right.
>
>> +static int signalfd_copy_raw_info(struct signalfd_siginfo __user *siginfo,
>> +                                     siginfo_t *kinfo)
>> +{
>> +     siginfo_t *uinfo = (siginfo_t *) siginfo;
>> +     int err;
>> +
>> +     BUILD_BUG_ON(sizeof(siginfo_t) != sizeof(struct signalfd_siginfo));
>> +
>> +     err = __clear_user(uinfo, sizeof(*uinfo));
>> +     err |= copy_siginfo_to_user(uinfo, kinfo);
>
> This probably needs copy_siginfo_to_user32() if is_compat_task...
>
>> +     err |= __put_user(kinfo->si_code, &uinfo->si_code);
>
> __put_user() is not safe? This allows to write to the kernel memory.
>
>> @@ -286,6 +308,11 @@ SYSCALL_DEFINE4(signalfd4, int, ufd, sigset_t __user *, user_mask,
>>                                      O_RDWR | (flags & (O_CLOEXEC | O_NONBLOCK)));
>>               if (ufd < 0)
>>                       kfree(ctx);
>> +             else if (flags & SFD_RAW) {
>> +                     struct fd f = fdget(ufd);
>> +                     f.file->f_flags |= flags & SFD_RAW;
>
> Well, but this is racy. How we can know that fdget(ufd) still
> points to the same file created by anon_inode_getfd? Not to
> mention f.file can be NULL.
>
> Another CLONE_FILES thread can do close() right after fd_install().
> And it can also do dup3().
>
> Oleg.
>
