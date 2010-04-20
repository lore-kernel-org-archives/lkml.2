Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754597Ab0DTMsP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 08:48:15 -0400
Received: from msux-gh1-uea01.nsa.gov ([63.239.65.39]:41141 "EHLO
	msux-gh1-uea01.nsa.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753995Ab0DTMsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 08:48:09 -0400
X-Greylist: delayed 611 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 Apr 2010 08:48:09 EDT
Subject: Re: [PATCH 0/3] Taming execve, setuid, and LSMs
From: Stephen Smalley <sds@tycho.nsa.gov>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Andrew Lutomirski <luto@mit.edu>, "Serge E. Hallyn" <serue@us.ibm.com>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Eric Biederman <ebiederm@xmission.com>,
       "Andrew G. Morgan" <morgan@kernel.org>
In-Reply-To: <20100419213952.GA28494@hallyn.com>
References: <cover.1269610458.git.luto@mit.edu>
	 <20100419172639.GA15800@us.ibm.com>
	 <n2ycb0375e11004191432g855540c0jab7989d75b32200d@mail.gmail.com>
	 <20100419213952.GA28494@hallyn.com>
Content-Type: text/plain
Organization: National Security Agency
Date: Tue, 20 Apr 2010 08:37:19 -0400
Message-Id: <1271767039.30027.50.camel@moss-pluto.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-04-19 at 16:39 -0500, Serge E. Hallyn wrote:
> Quoting Andrew Lutomirski (luto@mit.edu):
> > On Mon, Apr 19, 2010 at 1:26 PM, Serge E. Hallyn <serue@us.ibm.com> wrote:
> > > Quoting Andy Lutomirski (luto@MIT.EDU):
> > >> Every now and then, someone wants to let unprivileged programs change
> > >> something about their execution environment (think unsharing namespaces,
> > >> changing capabilities, disabling networking, chrooting, mounting and
> > >> unmounting filesystems). ?Whether or not any of these abilities are good
> > >> ideas, there's a recurring problem that gets most of these patches shot
> > >> down: setuid executables.
> > >>
> > >> The obvious solution is to allow a process to opt out of setuid
> > >> semantics and require processes to do this before using these shiny new
> > >> features. [1] [2]
> > >>
> > >> But there's a problem with this, too: with LSMs running, execve can do
> > >> pretty much anything, and even unprivileged users running unprivileged
> > >> programs can have crazy security implications. ?(Take a look at a
> > >> default install of Fedora. ?If you can understand the security
> > >> implications of disabling setuid, you get a cookie. ?If you can figure
> > >> out which programs will result in a change of security label when
> > >> exec'd, you get another cookie.)
> > >>
> > >> So here's another solution, based on the idea that in a sane world,
> > >> execve should be a lot less magical than it is. ?Any unprivileged
> > >> program can open an executable, parse its headers, map it, and run it,
> > >> although getting all the details right is tedious at best (and there's
> > >> no good way to get all of the threading semantics right from userspace).
> > >>
> > >> Patch 1 adds a new syscall execve_nosecurity. ?It does an exec, but
> > >> without changing any security properties. ?This means no setuid, no
> > >> setgid, no LSM credential hooks (e.g. no SELinux type transitions), and
> > >> no ptrace restrictions. ?(You have to have read access to the program,
> > >> because disabling security stuff could allow someone to ptrace a program
> > >> that they couldn't otherwise ptrace.) ?This shouldn't be particularly
> > >> scary -- any process could do much the same thing with open and mmap.
> > >> (You can easily shoot yourself in the foot with this syscall -- think
> > >> LD_PRELOAD or running some program with insufficient error checking that
> > >> can get subverted when run in the wrong security context. ?So don't do
> > >> that.)
> > >>
> > >> Patch 2 adds a prctl that irrevocably disables execve. ?Making execve do
> > >> something different that could confuse LSMs is dangerous. ?Turning the
> > >> whole thing off shouldn't be. ?(Of course, with execve disabled, you can
> > >> still use execve_nosecurity. ?But any program that does that should take
> > >> precautions not to shoot itself in the foot.) ?(In a future revision,
> > >> this should probably be a new syscall.)
> > >>
> > >> Sadly, programs that have opted out of execve might want to use
> > >> subprocesses that in turn run execve. ?This will fail. ?So patch 3
> > >> (which is ugly, but I don't see anything fundamentally wrong with it)
> > >> allows processes to set a flag that turns execve into execve_nosecurity.
> > >> This flag survives exec. ?Of course, this could be used to subvert
> > >> setuid programs, so you can't set this flag unless you disable ordinary
> > >> exec first.
> > >>
> > >> [1] Unprivileged: http://lkml.org/lkml/2009/12/30/265
> > >> [2] securebit approach: http://lwn.net/Articles/368600/
> > >
> > > No responses for a month after this was sent. ?Really, thanks, I do
> > > appreciate the work at another approach.
> > >
> > > I'll be honest, I prefer option [1]. ?Though I think it's reasonable
> > > to require privilege for prctl(PR_SET_NOSUID). ?Make it a separate
> > > capability, and on most systems it should be safe to have a file
> > > sitting in /bin with cap_set_nosuid+pe. ?If OTOH you know you have
> > > legacy or poorly coded privileged programs which would not be safe
> > > bc they don't verify that they have the needed privs, you just don't
> > > provide the program to do prctl(PR_SET_NOSUID) for unprivileged users.
> > 
> > Both approaches result in two kinds of exec: the normal kind that
> > respects setuid, file capabilities, and LSMs, and the restricted kind
> > that is supposed to be safe when programs have unshared namespaces and
> > other crazy things.
> > 
> > Eric's approach [1] adds a restricted kind of exec that ignores setuid
> > but still (AFAICT) respects file capabilities 
> 
> No, please see the rest of that thread - that was an oversight.
> 
> > and LSM  transitions.  I
> > think this is a terrible idea for two reasons:
> >   1. LSM transitions already scare me enough, and if anyone relies on
> > them working in concert with setuid, then the mere act of separating
> > them might break things, even if the "privileged" (by LSM) app in
> > question is well-written.
> 
> hmm...
> 
> A good point.

At least in the case of SELinux, context transitions upon execve are
already disabled in the nosuid case, and Eric's patch updated the
SELinux test accordingly.

-- 
Stephen Smalley
National Security Agency

