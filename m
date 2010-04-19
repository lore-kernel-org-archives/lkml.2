Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754787Ab0DSR0o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 13:26:44 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:48673 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754331Ab0DSR0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 13:26:43 -0400
Date: Mon, 19 Apr 2010 12:26:39 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Andy Lutomirski <luto@MIT.EDU>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Eric Biederman <ebiederm@xmission.com>,
       "Andrew G. Morgan" <morgan@kernel.org>
Subject: Re: [PATCH 0/3] Taming execve, setuid, and LSMs
Message-ID: <20100419172639.GA15800@us.ibm.com>
References: <cover.1269610458.git.luto@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1269610458.git.luto@mit.edu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Andy Lutomirski (luto@MIT.EDU):
> Every now and then, someone wants to let unprivileged programs change
> something about their execution environment (think unsharing namespaces,
> changing capabilities, disabling networking, chrooting, mounting and
> unmounting filesystems).  Whether or not any of these abilities are good
> ideas, there's a recurring problem that gets most of these patches shot
> down: setuid executables.
> 
> The obvious solution is to allow a process to opt out of setuid
> semantics and require processes to do this before using these shiny new
> features. [1] [2]
> 
> But there's a problem with this, too: with LSMs running, execve can do
> pretty much anything, and even unprivileged users running unprivileged
> programs can have crazy security implications.  (Take a look at a
> default install of Fedora.  If you can understand the security
> implications of disabling setuid, you get a cookie.  If you can figure
> out which programs will result in a change of security label when
> exec'd, you get another cookie.)
> 
> So here's another solution, based on the idea that in a sane world,
> execve should be a lot less magical than it is.  Any unprivileged
> program can open an executable, parse its headers, map it, and run it,
> although getting all the details right is tedious at best (and there's
> no good way to get all of the threading semantics right from userspace).
> 
> Patch 1 adds a new syscall execve_nosecurity.  It does an exec, but
> without changing any security properties.  This means no setuid, no
> setgid, no LSM credential hooks (e.g. no SELinux type transitions), and
> no ptrace restrictions.  (You have to have read access to the program,
> because disabling security stuff could allow someone to ptrace a program
> that they couldn't otherwise ptrace.)  This shouldn't be particularly
> scary -- any process could do much the same thing with open and mmap.
> (You can easily shoot yourself in the foot with this syscall -- think
> LD_PRELOAD or running some program with insufficient error checking that
> can get subverted when run in the wrong security context.  So don't do
> that.)
> 
> Patch 2 adds a prctl that irrevocably disables execve.  Making execve do
> something different that could confuse LSMs is dangerous.  Turning the
> whole thing off shouldn't be.  (Of course, with execve disabled, you can
> still use execve_nosecurity.  But any program that does that should take
> precautions not to shoot itself in the foot.)  (In a future revision,
> this should probably be a new syscall.)
> 
> Sadly, programs that have opted out of execve might want to use
> subprocesses that in turn run execve.  This will fail.  So patch 3
> (which is ugly, but I don't see anything fundamentally wrong with it)
> allows processes to set a flag that turns execve into execve_nosecurity.
> This flag survives exec.  Of course, this could be used to subvert
> setuid programs, so you can't set this flag unless you disable ordinary
> exec first.
> 
> [1] Unprivileged: http://lkml.org/lkml/2009/12/30/265
> [2] securebit approach: http://lwn.net/Articles/368600/

No responses for a month after this was sent.  Really, thanks, I do
appreciate the work at another approach.

I'll be honest, I prefer option [1].  Though I think it's reasonable
to require privilege for prctl(PR_SET_NOSUID).  Make it a separate
capability, and on most systems it should be safe to have a file
sitting in /bin with cap_set_nosuid+pe.  If OTOH you know you have
legacy or poorly coded privileged programs which would not be safe
bc they don't verify that they have the needed privs, you just don't
provide the program to do prctl(PR_SET_NOSUID) for unprivileged users.

( I did like using new securebits as in [2], but I prefer the
automatic not-raising-privs of [1] to simply -EPERM on uid/gid
change and lack kof checking for privs raising of [2]. )

Really the trick will be finding a balance to satisfy those wanting
this as a separate LSM, without traipsing into LSM stacking territory.

I myself think this feature fits very nicely with established semantics,
but not everyone agrees, so chances are my view is a bit tainted, and
we should defer to those wanting this to be an LSM.

Of course, another alternative is to skip this feature altogether and
push toward targeted capabilties.  The problem is that path amounts
to playing whack-a-mole to catch all the places where privilege might
leak to a parent namespace, whereas [1] simply, cleanly cuts them all
off at the source.

thanks,
-serge
