Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755812Ab2ARAXI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 19:23:08 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:62116 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754919Ab2ARAXG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 19:23:06 -0500
MIME-Version: 1.0
In-Reply-To: <m1pqeh9927.fsf@fess.ebiederm.org>
References: <e2f7f5ab9f24294a6b4ef8b6a7eaa760e414d777.1326420331.git.luto@amacapital.net>
 <m1pqeh9927.fsf@fess.ebiederm.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 17 Jan 2012 16:22:42 -0800
Message-ID: <CALCETrUPSABn8P-0TSzXaSP=dCs+Cwnpit-XHNYvXr+6FQ7dCw@mail.gmail.com>
Subject: Re: [PATCH] Add PR_{GET,SET}_NO_NEW_PRIVS to prevent execve from
 granting privs
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Will Drewry <wad@chromium.org>, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, keescook@chromium.org,
        john.johansen@canonical.com, serge.hallyn@canonical.com,
        coreyb@linux.vnet.ibm.com, pmoore@redhat.com, eparis@redhat.com,
        djm@mindrot.org, segoon@openwall.com, rostedt@goodmis.org,
        jmorris@namei.org, scarybeasts@gmail.com, avi@redhat.com,
        penberg@cs.helsinki.fi, viro@zeniv.linux.org.uk, luto@mit.edu,
        mingo@elte.hu, akpm@linux-foundation.org, khilman@ti.com,
        borislav.petkov@amd.com, amwang@redhat.com, oleg@redhat.com,
        ak@linux.intel.com, eric.dumazet@gmail.com, gregkh@suse.de,
        dhowells@redhat.com, daniel.lezcano@free.fr,
        linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
        olofj@chromium.org, mhalcrow@google.com, dlaor@redhat.com,
        corbet@lwn.net, alan@lxorguk.ukuu.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 17, 2012 at 3:57 PM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
> Andy Lutomirski <luto@amacapital.net> writes:
>
>> With this set, a lot of dangerous operations (chroot, unshare, etc)
>> become a lot less dangerous because there is no possibility of
>> subverting privileged binaries.
>>
>> This patch completely breaks apparmor.  Someone who understands (and
>> uses) apparmor should fix it or at least give me a hint.
>
> Foolish implementation question.
>
> Is there a reason why we are putting this in a new field in the task
> struct instead of adding a new flag in securebits in struct cred?

Linus said:

I think it almost has to be task state, since we very much want to
make sure it's trivial to see that nothing ever clears that bit, and
that it always gets copied right over a fork/exec/whatever.

Putting it in some cred or capability bit or somethin would make that
kind of transparency pretty much totally impossible.


I personally don't care that much.

>
> It seems to me like putting this information on the task_struct instead
> of struct cred will tend to make this frozen state transition less
> discoverable for future developers.
>
> Also I would expect if you were applying this policy that you would
> to ensure that task->read_cred == task->cred.

What sets cred to something other than real_cred.

>
> Do we want to disable setuid() and it's friends as well?  Certainly
> freezing everything at exec is good I'm just wondering if handling
> the handful of other cases where we explicitly change the permissions
> on a process might be interesting.

I still think we shouldn't.  If you want to disable setuid, just turn
off CAP_SETUID.  The ability to setuid (the syscall, not the mode bit)
doesn't make things like seccomp and chroot more dangerous.  And I
need setuid if I want to implement my hypothetical pam_no_new_privs.

--Andy
