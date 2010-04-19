Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752473Ab0DSVdV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 17:33:21 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:63267 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129Ab0DSVdQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 17:33:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=QVqliOYboRarNxfM2kg4MQPtbj/ttuEAcN7NqOaEht0Zr8jtp0KRNXhcp4A78cFjCv
         CPcj6jk7TaSWBTlYz0y92KZHe8G4LJRWK4ZsXnPrZivA26B6GXcDaMr4/psN06ofA2TS
         OiwZfhss+NwkErin1INya2lHio0GWEQUtFKFM=
MIME-Version: 1.0
In-Reply-To: <20100419172639.GA15800@us.ibm.com>
References: <cover.1269610458.git.luto@mit.edu> <20100419172639.GA15800@us.ibm.com>
From: Andrew Lutomirski <luto@mit.edu>
Date: Mon, 19 Apr 2010 17:32:56 -0400
X-Google-Sender-Auth: 3cb2d94b69265ec3
Message-ID: <n2ycb0375e11004191432g855540c0jab7989d75b32200d@mail.gmail.com>
Subject: Re: [PATCH 0/3] Taming execve, setuid, and LSMs
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Eric Biederman <ebiederm@xmission.com>,
       "Andrew G. Morgan" <morgan@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 19, 2010 at 1:26 PM, Serge E. Hallyn <serue@us.ibm.com> wrote:
> Quoting Andy Lutomirski (luto@MIT.EDU):
>> Every now and then, someone wants to let unprivileged programs change
>> something about their execution environment (think unsharing namespaces,
>> changing capabilities, disabling networking, chrooting, mounting and
>> unmounting filesystems).  Whether or not any of these abilities are good
>> ideas, there's a recurring problem that gets most of these patches shot
>> down: setuid executables.
>>
>> The obvious solution is to allow a process to opt out of setuid
>> semantics and require processes to do this before using these shiny new
>> features. [1] [2]
>>
>> But there's a problem with this, too: with LSMs running, execve can do
>> pretty much anything, and even unprivileged users running unprivileged
>> programs can have crazy security implications.  (Take a look at a
>> default install of Fedora.  If you can understand the security
>> implications of disabling setuid, you get a cookie.  If you can figure
>> out which programs will result in a change of security label when
>> exec'd, you get another cookie.)
>>
>> So here's another solution, based on the idea that in a sane world,
>> execve should be a lot less magical than it is.  Any unprivileged
>> program can open an executable, parse its headers, map it, and run it,
>> although getting all the details right is tedious at best (and there's
>> no good way to get all of the threading semantics right from userspace).
>>
>> Patch 1 adds a new syscall execve_nosecurity.  It does an exec, but
>> without changing any security properties.  This means no setuid, no
>> setgid, no LSM credential hooks (e.g. no SELinux type transitions), and
>> no ptrace restrictions.  (You have to have read access to the program,
>> because disabling security stuff could allow someone to ptrace a program
>> that they couldn't otherwise ptrace.)  This shouldn't be particularly
>> scary -- any process could do much the same thing with open and mmap.
>> (You can easily shoot yourself in the foot with this syscall -- think
>> LD_PRELOAD or running some program with insufficient error checking that
>> can get subverted when run in the wrong security context.  So don't do
>> that.)
>>
>> Patch 2 adds a prctl that irrevocably disables execve.  Making execve do
>> something different that could confuse LSMs is dangerous.  Turning the
>> whole thing off shouldn't be.  (Of course, with execve disabled, you can
>> still use execve_nosecurity.  But any program that does that should take
>> precautions not to shoot itself in the foot.)  (In a future revision,
>> this should probably be a new syscall.)
>>
>> Sadly, programs that have opted out of execve might want to use
>> subprocesses that in turn run execve.  This will fail.  So patch 3
>> (which is ugly, but I don't see anything fundamentally wrong with it)
>> allows processes to set a flag that turns execve into execve_nosecurity.
>> This flag survives exec.  Of course, this could be used to subvert
>> setuid programs, so you can't set this flag unless you disable ordinary
>> exec first.
>>
>> [1] Unprivileged: http://lkml.org/lkml/2009/12/30/265
>> [2] securebit approach: http://lwn.net/Articles/368600/
>
> No responses for a month after this was sent.  Really, thanks, I do
> appreciate the work at another approach.
>
> I'll be honest, I prefer option [1].  Though I think it's reasonable
> to require privilege for prctl(PR_SET_NOSUID).  Make it a separate
> capability, and on most systems it should be safe to have a file
> sitting in /bin with cap_set_nosuid+pe.  If OTOH you know you have
> legacy or poorly coded privileged programs which would not be safe
> bc they don't verify that they have the needed privs, you just don't
> provide the program to do prctl(PR_SET_NOSUID) for unprivileged users.

Both approaches result in two kinds of exec: the normal kind that
respects setuid, file capabilities, and LSMs, and the restricted kind
that is supposed to be safe when programs have unshared namespaces and
other crazy things.

Eric's approach [1] adds a restricted kind of exec that ignores setuid
but still (AFAICT) respects file capabilities and LSM  transitions.  I
think this is a terrible idea for two reasons:

  1. LSM transitions already scare me enough, and if anyone relies on
them working in concert with setuid, then the mere act of separating
them might break things, even if the "privileged" (by LSM) app in
question is well-written.
  2. File capabilities are just as dangerous as setuid, and I wouldn't
even know how to write a program that's safe when it has extra
capabilities granted by fE (or fP or whatever it is) and the caller
has, say, an unshared fs namespace and the ability to rearrange the
namespace arbitrarily.

In short, I think that this nosuid exec is both dangerous in and of
itself *and* doesn't actually solve the problem it was supposed to
solve.

I also don't like relying on the admin to decide that it's safe to
allow PR_SET_NOSUID (or whatever you call it) and having to install a
special privileged program to enable it.  If sandbox-like features
require explicit action by root, then they won't be as widely used as
they should be.  And how many admins will have any clue whether
enabling this feature is safe?

My approach introduces what I think is a much more obviously safe
restricted exec, and I think it's so safe that no privilege or special
configuration should be required to use it.

As for what to call it (execve_nosecurity or PR_SET_NOSUID) or whether
to have a special syscall so that programs that aren't restricted can
use the restricted exec, I don't care all that much.  I just think
that the separate syscall might be useful in its own right and
required almost no additional code, so I added it.


>
> ( I did like using new securebits as in [2], but I prefer the
> automatic not-raising-privs of [1] to simply -EPERM on uid/gid
> change and lack kof checking for privs raising of [2]. )
>
> Really the trick will be finding a balance to satisfy those wanting
> this as a separate LSM, without traipsing into LSM stacking territory.

I think that making this an LSM is absurd.  Containers (and anything
else people want to do with namespaces or with other new features that
interact badly with setuid) are features that people should be able to
use easily, and system's choice of LSM shouldn't have anything to do
with them.  Not to mention that we're trying to *add* rights (e.g.
unprivileged unshare), and LSM is about *removing* rights.

>
> I myself think this feature fits very nicely with established semantics,
> but not everyone agrees, so chances are my view is a bit tainted, and
> we should defer to those wanting this to be an LSM.
>
> Of course, another alternative is to skip this feature altogether and
> push toward targeted capabilties.  The problem is that path amounts
> to playing whack-a-mole to catch all the places where privilege might
> leak to a parent namespace, whereas [1] simply, cleanly cuts them all
> off at the source.

Agreed, that sounds painful.  My secret goal is real
userspace-controlled (by unprivileged users, no less) sandboxes, in
which case in-kernel target capabilities are probably impossible.

--Andy
