Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753147Ab2APCES (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jan 2012 21:04:18 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:40247 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752387Ab2APCEQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jan 2012 21:04:16 -0500
MIME-Version: 1.0
In-Reply-To: <CAObL_7F4hEvdyJLNhodOOETTv-Dur8gEadLkzESQWFC2C57t7w@mail.gmail.com>
References: <1326411506-16894-1-git-send-email-wad@chromium.org>
	<CA+55aFz4mJU2E2BPzZyVQ52V_ytg_8fyAH+BV_uYHVXBM2wqDw@mail.gmail.com>
	<CAObL_7FErN5CHmfSehJYcM0_Lz-WTywG7cHe2jZyQbf-GkOQjg@mail.gmail.com>
	<CA+55aFzzRNHfSo-1DyzsAwYvj1Da-vyhMQP-OdrA-rWywsebcg@mail.gmail.com>
	<CAObL_7F8aYPDQ1xTFjOxWgoZfrtGNFVgMe2Ld61_=D+YY427qA@mail.gmail.com>
	<CA+55aFxSgYFp1psum3amgqqsT-rrvGd1T8BXJSA-mgd1EdHrwg@mail.gmail.com>
	<20120114133053.GY7180@jl-vm1.vm.bytemark.co.uk>
	<CA+55aFwZ-=s3S9wmRSfW8-tbcJct+GWedQi8Dc8RW75NaqB10A@mail.gmail.com>
	<4F133423.5070007@schaufler-ca.com>
	<CAObL_7FE1NGJLNu-xUkyzCfZ7OSHO16p-4Lk2h5emkE7CGxC_Q@mail.gmail.com>
	<4F1345DB.8040303@schaufler-ca.com>
	<CAObL_7F4hEvdyJLNhodOOETTv-Dur8gEadLkzESQWFC2C57t7w@mail.gmail.com>
Date: Sun, 15 Jan 2012 20:04:13 -0600
Message-ID: <CABqD9haumYV6SizAXeR9Os69QgYEkW6fBC27dAYhOr-8U=p6_A@mail.gmail.com>
Subject: Re: [PATCH PLACEHOLDER 1/3] fs/exec: "always_unprivileged" patch
From: Will Drewry <wad@chromium.org>
To: Andrew Lutomirski <luto@mit.edu>
Cc: Casey Schaufler <casey@schaufler-ca.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jamie Lokier <jamie@shareable.org>, linux-kernel@vger.kernel.org,
        keescook@chromium.org, john.johansen@canonical.com,
        serge.hallyn@canonical.com, coreyb@linux.vnet.ibm.com,
        pmoore@redhat.com, eparis@redhat.com, djm@mindrot.org,
        segoon@openwall.com, rostedt@goodmis.org, jmorris@namei.org,
        scarybeasts@gmail.com, avi@redhat.com, penberg@cs.helsinki.fi,
        viro@zeniv.linux.org.uk, mingo@elte.hu, akpm@linux-foundation.org,
        khilman@ti.com, borislav.petkov@amd.com, amwang@redhat.com,
        oleg@redhat.com, ak@linux.intel.com, eric.dumazet@gmail.com,
        gregkh@suse.de, dhowells@redhat.com, daniel.lezcano@free.fr,
        linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
        olofj@chromium.org, mhalcrow@google.com, dlaor@redhat.com,
        corbet@lwn.net, alan@lxorguk.ukuu.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 15, 2012 at 4:07 PM, Andrew Lutomirski <luto@mit.edu> wrote:
> On Sun, Jan 15, 2012 at 1:32 PM, Casey Schaufler <casey@schaufler-ca.com> wrote:
>> On 1/15/2012 12:59 PM, Andrew Lutomirski wrote:
>>>
>>> On Sun, Jan 15, 2012 at 12:16 PM, Casey Schaufler
>>> <casey@schaufler-ca.com>  wrote:
>>>>
>>>> On 1/14/2012 12:22 PM, Linus Torvalds wrote:
>>>>>
>>>>> And yes, I really seriously do believe that is both safer and simpler
>>>>> than some model that says "you can drop stuff", and then you have to
>>>>> start making up rules for what "dropping" means.
>>>>>
>>>>> Does "dropping" mean allowing setuid(geteuid()) for example? That *is*
>>>>> dropping the uid in a _POSIX_SAVED_IDS environment. And I'm saying
>>>>> that no, we should not even allow that. It's simply all too "subtle".
>>>>
>>>>
>>>> I am casting my two cents worth behind Linus. Dropping
>>>> privilege can be every bit as dangerous as granting privilege
>>>> in the real world of atrocious user land code. Especially in
>>>> the case of security policy enforcing user land code.
>>>
>>> Can you think of *any* plausible attack that is possible with my patch
>>> (i.e. no_new_privs allows setuid, setresuid, and capset) that would be
>>> prevented or even mitigated if I blocked those syscalls?  I can't.
>>> (The sendmail-style attack is impossible with no_new_privs.)
>>
>>
>> I am notoriously bad at coming up with this sort of example.
>> I will try, I may not hit the mark, but it should be close.
>>
>> The application is running with saved uid != euid when
>> no-new-privs is set. It execs a new binary, which keeps
>> the saved and effective uids. The program calls setreuid,
>> which succeeds. It opens the saved userid's files.
>
> If you don't trust that binary, then why are you execing it with saved
> uid != euid in the first place?  If you are setting no_new_privs, then
> you are new code and should have at least some basic awareness of the
> semantics.  The exact same "exploit" is possible if you have
> CAP_DAC_OVERRIDE with either no_new_privs semantics -- if you have a
> privilege and you run untrusted code, then you had better remove that
> privilege somehow for the untrusted code.
>
> IOW, *drop privileges if you are a sandbox*.  Otherwise you're screwed
> with or without no_new_privs.

One consideration could be to add do_exit()s at known DAC transitions
(set*id, fcaps). I don't know if that'd be wise, but it would remove
some described ambiguity.  The same could be done with exec when the
(e)uid/gid/fcaps change.  However, none of that helps with the opaque
LSM data, so that'd have to be left up to the LSMs and the LSM_* flag
you've added.

This does seem subject to bitrot though, and your current approach
certainly suits the needs of the general
don't-do-something-stupid-on-exec that seccomp filter, unprivileged
chroot, unshare, etc all need (which is really nice).

> Another way of saying this is: no_new_privs is not a sandbox.  It's
> just a way to make it safe for sandboxes and other such weird things
> processes can do to themselves safe across execve.  If you want a
> sandbox, use seccomp mode 2, which will require you to set
> no_new_privs.

And even with system call filtering, you'll need to have appropriately
set up accessible files, file descriptors, memory maps, etc if you
want a proper sandbox.  There's no single sandbox-equivalent kernel
feature.  no_new_privs would be an excellent addition to the sandbox
toolkit. (I've tried to synthesize it in userspace with an empty
capability bounding set, SECURE_NOROOT, and MNT_NOSUID.  Having this
in a future-proof task_struct bit form would be amazing.)

cheers!
will
