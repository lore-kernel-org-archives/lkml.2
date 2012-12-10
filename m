Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751834Ab2LJSGM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 13:06:12 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:44392 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751093Ab2LJSGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 13:06:11 -0500
MIME-Version: 1.0
In-Reply-To: <20121210145950.GC8137@sergelap>
References: <CALCETrW05JtRZSSJ0v=jz8B7_av1QS+D5qux5=q8aO3iWZHB1A@mail.gmail.com>
 <20121205210528.GA9047@sergelap> <CALCETrVsrJSt8oYnh+y32Lrxw6Yk=Cp_e07Qf=fLbVfORvzUNg@mail.gmail.com>
 <20121205222040.GB14884@sergelap> <50C13F0E.5010401@schaufler-ca.com>
 <20121207144233.GA6681@mail.hallyn.com> <CALQRfL6c2nOSOR00YsBhgC=KWSWB-xOsDTJiLzbtmj6Zv1Mr2Q@mail.gmail.com>
 <CALCETrUwVO6YjO-VzwBO59z4L2zB+-Zd_V-ontciMEFzRHzDFQ@mail.gmail.com>
 <CALQRfL4iaHQgQ_PY44xYsyZc3fn4J+9Aw3bMfpPMSbE=4AymSA@mail.gmail.com>
 <CALCETrXrX7V0uW1XQgUAoror1D1ymZL8_0PxjQRWEoSaXT+phg@mail.gmail.com> <20121210145950.GC8137@sergelap>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 10 Dec 2012 10:05:49 -0800
Message-ID: <CALCETrWSE+smyTOwvx5wnWudcpZBTqGu2FV+svhAHR4GwAHHKw@mail.gmail.com>
Subject: Re: [RFC] Capabilities still can't be inherited by normal programs
To: Serge Hallyn <serge.hallyn@canonical.com>
Cc: "Andrew G. Morgan" <morgan@kernel.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Casey Schaufler <casey@schaufler-ca.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        Kees Cook <keescook@chromium.org>,
        James Morris <james.l.morris@oracle.com>,
        Eric Paris <eparis@redhat.com>,
        "Serge E. Hallyn" <serge@canonical.com>,
        Markku Savela <msa@moth.iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 10, 2012 at 6:59 AM, Serge Hallyn
<serge.hallyn@canonical.com> wrote:
> Quoting Andy Lutomirski (luto@amacapital.net):
>> It's especially bad because granting CAP_DAC_READ_SEARCH to user "foo"
>> doesn't mean anything.  Is he authorized to back things up to
>> encrypted storage?
>
> We're talking about privileges at the kernel level here, and there is
> no way this could be expressed at that level.
>
> Higher level tools could/should certainly be exposing things at this
> level.

Agreed, although selinux tries to allow this kind of detail in the
kernel.  I don't think capabilities should move in that direction.

>
> BUT
>
> You *are* doing a good job of making me feel that we should have
> per-user fI xattrs or acls.  Sudo is popular because people like to say
> "user joe can run foo with privilege".  Most people will never want to
> be bothered to say "user joe can run foo with CAP_XYZ" (versus "as
> root"), but I do think we could get programs/packages to do that.

Hmm.  I wish I was doing as good a job convincing myself that I know a
good solution.

I don't actually consider the fact that pI has insufficient
granularity to be a problem in need of fixing.  I think userspace can
take care of detailed authorization questions on its own.  I think the
problem is that pI is failing to allow users who aren't root (or at
least aren't uid=0) to have elevated, but not completely elevated,
privilege.  (If you don't like "users" in that sentence, feel free to
replace it with "trusted programs that use execve as part of their
operation".)

Part of my struggle in proposing a solution is that there are two
things I'd rather not add:

1. More modes.  securebits, etc are hard to understand and can break
assumptions that are currently true.

2. execve granting new privilege, even in the pI -> pP sense.  There
have been countless bugs relating to this in the past.  This is why I
proposed no_new_privs.

A new mode that is only allowed when no_new_privs is set is
considerably less dangerous, but still not wonderful.


I could write a patch to add a new securebit SECURE_CAP_INHERITANCE
that changes execve to act as though fI always contained all bits and
to change capset to prevent pI from ever exceeding pP & pB.  To make
it usable without CAP_SETPCAP, maybe setting it to true should be
legal without privilege if no_new_privs.

(Actually, maybe all of the securebits should be freely tweakable if
no_new_privs.)


Some use cases:

1. Write a pam module that sets SECURE_CAP_INHERITANCE and assigns
inheritable caps.  Obviously it would grant users full use of those
caps.  The question is: what else would break?  I.e. could users abuse
it to exploit other setuid or fP!=0 binaries?

2. Write little fP != 0 helpers that check authorization, set
no_new_privs and SECURE_CAP_INHERITANCE, and invoke something else.

3. (Pipe dream?)  Eventually convince everyone to run in
SECURE_CAP_INHERITANCE mode.


I'll admit I'm not really thrilled by this suggestion.

I'd like to do a survey and find out if anyone uses fI.  If the answer
is "no", fI support could be dropped in some kind of controlled
manner, perhaps using the vfs cap version number.  The setcap tool IMO
wants some reworking anyway.

--Andy
