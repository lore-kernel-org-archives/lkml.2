Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753477Ab2APHqT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 02:46:19 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:60453 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750858Ab2APHqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 02:46:16 -0500
MIME-Version: 1.0
In-Reply-To: <4F138E57.6030007@schaufler-ca.com>
References: <1326411506-16894-1-git-send-email-wad@chromium.org>
 <CA+55aFz4mJU2E2BPzZyVQ52V_ytg_8fyAH+BV_uYHVXBM2wqDw@mail.gmail.com>
 <CAObL_7FErN5CHmfSehJYcM0_Lz-WTywG7cHe2jZyQbf-GkOQjg@mail.gmail.com>
 <CA+55aFzzRNHfSo-1DyzsAwYvj1Da-vyhMQP-OdrA-rWywsebcg@mail.gmail.com>
 <CAObL_7F8aYPDQ1xTFjOxWgoZfrtGNFVgMe2Ld61_=D+YY427qA@mail.gmail.com>
 <CA+55aFxSgYFp1psum3amgqqsT-rrvGd1T8BXJSA-mgd1EdHrwg@mail.gmail.com>
 <20120114133053.GY7180@jl-vm1.vm.bytemark.co.uk> <CA+55aFwZ-=s3S9wmRSfW8-tbcJct+GWedQi8Dc8RW75NaqB10A@mail.gmail.com>
 <4F133423.5070007@schaufler-ca.com> <CAObL_7FE1NGJLNu-xUkyzCfZ7OSHO16p-4Lk2h5emkE7CGxC_Q@mail.gmail.com>
 <4F1345DB.8040303@schaufler-ca.com> <CAObL_7F4hEvdyJLNhodOOETTv-Dur8gEadLkzESQWFC2C57t7w@mail.gmail.com>
 <4F138E57.6030007@schaufler-ca.com>
From: Andrew Lutomirski <luto@mit.edu>
Date: Sun, 15 Jan 2012 23:45:54 -0800
X-Google-Sender-Auth: O_yNKM1e5CSpSst-im2Mx9ldWiE
Message-ID: <CAObL_7HaeRBpjLzp=B8z5n8KQPTPVmYTvbOw+w3eQbjWL-3E=w@mail.gmail.com>
Subject: Re: [PATCH PLACEHOLDER 1/3] fs/exec: "always_unprivileged" patch
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Jamie Lokier <jamie@shareable.org>, Will Drewry <wad@chromium.org>,
        linux-kernel@vger.kernel.org, keescook@chromium.org,
        john.johansen@canonical.com, serge.hallyn@canonical.com,
        coreyb@linux.vnet.ibm.com, pmoore@redhat.com, eparis@redhat.com,
        djm@mindrot.org, segoon@openwall.com, rostedt@goodmis.org,
        jmorris@namei.org, scarybeasts@gmail.com, avi@redhat.com,
        penberg@cs.helsinki.fi, viro@zeniv.linux.org.uk, mingo@elte.hu,
        akpm@linux-foundation.org, khilman@ti.com, borislav.petkov@amd.com,
        amwang@redhat.com, oleg@redhat.com, ak@linux.intel.com,
        eric.dumazet@gmail.com, gregkh@suse.de, dhowells@redhat.com,
        daniel.lezcano@free.fr, linux-fsdevel@vger.kernel.org,
        linux-security-module@vger.kernel.org, olofj@chromium.org,
        mhalcrow@google.com, dlaor@redhat.com, corbet@lwn.net,
        alan@lxorguk.ukuu.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 15, 2012 at 6:41 PM, Casey Schaufler <casey@schaufler-ca.com> wrote:
> On 1/15/2012 2:07 PM, Andrew Lutomirski wrote:
>>
>> On Sun, Jan 15, 2012 at 1:32 PM, Casey Schaufler<casey@schaufler-ca.com>
>>
>> If you don't trust that binary, then why are you execing it with saved
>> uid != euid in the first place?
>
>
> If I could trust the binary I wouldn't need your no_new_privs
> semantics in the first place. Do you have any idea how big the
> chrome browser binary is? You can't link it on a 32bit machine
> it uses so much address space. On top of that, most modern
> applications are compositions of scripts and interpreters built
> on top of multiple layers of middleware. Of course I don't trust
> the binary!
>

I'm not sure we're really talking about the same thing here.  I agree
that, if you are trying to sandbox untrusted code, then you probably
don't want that code messing with setuid, capset, or any other
privilege-changing operation.

no_new_privs is not intended to be that sandbox.  It is, by itself, at
best a small reduction in attack surface.

The attack surface accessible to a program (e.g. chrome) that you run
normally is huge.  There is filesystem access, ptrace, unix sockets,
any available privileges, setuid programs, /proc, etc.  LSMs try to
characterize and control that whole attack surface.  seccomp mode 2
allows a whitelisting approach in which everything is denied except
that which is explicitly allowed (and I think that's a much better
approach to sandboxing things).  The problem is that seccomp mode 2,
as well as anything else that changes the behavior of syscalls in a
nonstandard way (chroot, unshare, etc), can cause existing code to
malfunction.  That's how the sendmail bug came to be -- dropping a
privilege made sendmail do the wrong thing.  This type of attack works
by changing something that persists across a *gain* of privilege and
then attacking the code that gains that privilege.  If new things like
seccomp mode 2 require no_new_privs, then that entire class of attacks
is prevented.

In answer to your specific example, if you are trying to sandbox
chrome or anything else and you forget to drop your privileged saved
uid, I really don't think it's no_new_privs's job to rescue you.

--Andy
