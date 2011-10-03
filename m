Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755697Ab1JCNgB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 09:36:01 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:44940 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520Ab1JCNfx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 09:35:53 -0400
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <m18vp88cx6.fsf@fess.ebiederm.org>
References: <CAKgNAkhX-SnESaVoux2zUtTEVSY5umw=gPqCtfDEOO+xigtTdg@mail.gmail.com>
 <m18vp88cx6.fsf@fess.ebiederm.org>
From: Michael Kerrisk <mtk.manpages@gmail.com>
Date: Mon, 3 Oct 2011 15:35:33 +0200
Message-ID: <CAKgNAkh3HQAgNkYg=o6rpsm5n8wGpTNPLgq82OkKzVV8gux5YA@mail.gmail.com>
Subject: Re: [PATCH 1/2] setns.2: Initial man page [RESEND]
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-man@vger.kernel.org, "Serge E. Hallyn" <serge.hallyn@canonical.com>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric,

On Thu, Sep 29, 2011 at 1:28 AM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
> Michael Kerrisk <mtk.manpages@gmail.com> writes:
>
>> Hi Eric,
>>
>> I'm still wanting your input on the edited setns.2 draft below. Please
>> don't make me chase you round Prague ;-).
>
> That could be interesting...  As I don't have plans to head out that way
> this year.  I got side tracked with some unexpected computer troubles
> that showed up right after I got home.

Ahh -- that's a shame not to see you there!

> So overall it looks good.  I found two nits to pick (see below).
>
> The significant nit is how do we say unshare and setns refer
> to just a linux task and not the entire process.
>
> When you are writing multi-threaded apps it actually matters.
>
> In particular I keep expecting someone will need a call like:
>
> int socketat(int namespace, int domain, int type, int protocol)
> {
>        int netns, ret, fd;
>        netns = open("/proc/self/ns/net", O_RDONLY);
>        if (netns < 0)
>                return -1;
>        ret = setns( namespace, CLONE_NETNS);
>        if (ret < 0)
>                return -1;
>        fd = socket( domain, type, protocol);
>        setns(netns, CLONE_NETNS);
>        return fd;
> }
>
> Which with a little bit care adding blocking of signals etc
> that call can actually be made thread safe.
>
> However if setns affected all threads of a multi-threaded process
> socketat would require a system call to be written to do the
> same job.

Okay. But please, when you add it, don't call it "socketat()". That
name makes it look as though it is similar to "openat()" and all of
the other "*at" calls, when really it is not. Perhaps "socketns()"?

> Multi-threaded processes that simultaneously deal with multiple
> namespaces are likely to be rare but I expect there to be a few
> that actually care.
>
> Eric
>
>
>> Cheers,
>>
>> Michael
>>
>> From: Michael Kerrisk <mtk.manpages@gmail.com>
>> Date: Thu, Sep 15, 2011 at 6:13 AM
>> Subject: Re: [PATCH 1/2] setns.2: Initial man page
>> To: "Eric W. Biederman" <ebiederm@xmission.com>
>> Cc: linux-man@vger.kernel.org, "Serge E. Hallyn" <serge.hallyn@canonical.com>
>>
>>
>> Hello Eric,
>>
>> See below.
>>
>> On Mon, May 30, 2011 at 5:16 AM, Eric W. Biederman
>> <ebiederm@xmission.com> wrote:
>>>
>>> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
>>> ---
>>>  man2/setns.2 |   88 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>>>  1 files changed, 88 insertions(+), 0 deletions(-)
>>>  create mode 100644 man2/setns.2
>>>
>>> diff --git a/man2/setns.2 b/man2/setns.2
>>> new file mode 100644
>>> index 0000000..8b48e14
>>> --- /dev/null
>>> +++ b/man2/setns.2
>>> @@ -0,0 +1,88 @@
>>> +.\" Copyright (C) 2011, Eric Biederman <ebiederm@xmission.com>
>>> +.\" Licensed under the GPLv2
>>> +.\"

[...]

>> As I understand it, this refers to interactions between the mount
>> namespace and file system namespace. However, as noted in the man
>> page, setns() does not support CLONE_NEWNS. Furthermore, I can see no
>> path in the setns() that generates EINVAL and  involves CLONE_NEWNS.
>> So,I removed that text. Please let me know if that's wrong.
>
> Removing that text is fine for now.  I expect I will have to readd it
> after I get my next round of patches in but no need to Document what
> does not yet exist in mainline.

Okay.

> Reading the
>
>> .\" Copyright (C) 2011, Eric Biederman <ebiederm@xmission.com>
>> .\" Licensed under the GPLv2
>> .\"
>> .TH SETNS 2 2011-09-15 "Linux" "Linux Programmer's Manual"
>> .SH NAME
>> setns \- reassociate process with a namespace
>> .SH SYNOPSIS
>> .nf
>> .BR "#define _GNU_SOURCE" "             /* See feature_test_macros(7) */"
>> .B #include <sched.h>
>> .sp
>> .BI "int setns(int " fd ", int " nstype );
>> .fi
>> .SH DESCRIPTION
>> Given a file descriptor referring to a namespace,
>> reassociate the calling process with that namespace.
>>
>> The
>> .I fd
>> argument is a file descriptor referring to one of the namespace entries in a
>> .I /proc/[pid]/ns/
>> directory; see
>> .BR proc (5)
>> for further information on
>> .IR /proc/[pid]/ns/ .
>> The calling process will be reassociated with the corresponding namespace,
>> subject to any constraints imposed by the
>> .I nstype
>> argument.
>>
>
> There is an weird twist I think it makes sense to document.  The unit of
> reassociation is a linux task.  What is normally seen as a thread.
>
> Which is important to consider if you happen to be using this in a
> multi-threaded program.  But I'm not certain how best to say that.
>
> Perhaps:  perhaps just say linux task instead of process?

I'll write "thread", which is the usual terminology in this context
(Section 2). I've made that change at multiple places in the page (see
below).

[...]

>> .SH ERRORS
>> .TP
>> .B EBADF
>> .I fd
>> is not a valid file descriptor.
>> .TP
>> .B EINVAL
>> .I fd
>> refers to a namespace whose type does not match that specified in
>> .IR nstype .
>
> Just because we have been going back on forth on this bit I am inclined
> to say:
>
> EINVAL fd refers to a namespace whose type does not match that
> specified in nstype, or there is problem with reassociating the
> the thread with the specified namespace.

Changed.

[...]

Revised page below, which you can make a final check on, if you like.
The page will go out with the next man-pages release (3.35).

Cheers,

Michael


.\" Copyright (C) 2011, Eric Biederman <ebiederm@xmission.com>
.\" Licensed under the GPLv2
.\"
.TH SETNS 2 2011-09-15 "Linux" "Linux Programmer's Manual"
.SH NAME
setns \- reassociate thread with a namespace
.SH SYNOPSIS
.nf
.BR "#define _GNU_SOURCE" "             /* See feature_test_macros(7) */"
.B #include <sched.h>
.sp
.BI "int setns(int " fd ", int " nstype );
.fi
.SH DESCRIPTION
Given a file descriptor referring to a namespace,
reassociate the calling thread with that namespace.

The
.I fd
argument is a file descriptor referring to one of the namespace entries in a
.I /proc/[pid]/ns/
directory; see
.BR proc (5)
for further information on
.IR /proc/[pid]/ns/ .
The calling thread will be reassociated with the corresponding namespace,
subject to any constraints imposed by the
.I nstype
argument.

The
.I nstype
argument specifies which type of namespace
the calling thread may be reassociated with.
This argument can have one of the following values:
.TP
.BR 0
Allow any type of namespace to be joined.
.TP
.BR CLONE_NEWIPC
.I fd
must refer to an IPC namespace.
.TP
.BR CLONE_NEWNET
.I fd
must refer to a network namespace.
.TP
.BR CLONE_NEWUTS
.I fd
must refer to a UTS namespace.
.PP
Specifying
.I nstype
as 0 suffices if the caller knows (or does not care)
what type of namespace is referred to by
.IR fd .
Specifying a nonzero value for
.I nstype
is useful if the caller does not know what type of namespace is referred to by
.IR fd
and wants to ensure that the namespace is of a particular type.
(The caller might not know the type of the namespace referred to by
.IR fd
if the file descriptor was opened by another process and, for example,
passed to the caller via a UNIX domain socket.)
.SH RETURN VALUE
On success,
.IR setns ()
returns 0.
On failure, \-1 is returned and
.I errno
is set to indicate the error.
.SH ERRORS
.TP
.B EBADF
.I fd
is not a valid file descriptor.
.TP
.B EINVAL
.I fd
refers to a namespace whose type does not match that specified in
.IR nstype ,
or there is problem with reassociating the
the thread with the specified namespace.
.TP
.B ENOMEM
Cannot allocate sufficient memory to change the specified namespace.
.TP
.B EPERM
The calling thread did not have the required privilege
.RB ( CAP_SYS_ADMIN )
for this operation.
.SH VERSIONS
The
.BR setns ()
system call first appeared in Linux in kernel 3.0
.SH CONFORMING TO
The
.BR setns ()
system call is Linux-specific.
.SH NOTES
Not all of the attributes that can be shared when
a new thread is created using
.BR clone (2)
can be changed using
.BR setns ().
.SH BUGS
The PID namespace and the mount namespace are not currently supported.
(See the descriptions of
.BR CLONE_NEWPID
and
.BR CLONE_NEWNS
in
.BR clone (2).)
.SH SEE ALSO
.BR clone (2),
.BR fork (2),
.BR vfork (2),
.BR proc (5),
.BR unix (7)



-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface"; http://man7.org/tlpi/
