Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754307Ab0DUMee (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 08:34:34 -0400
Received: from reserved-DSUX-GH1-UEA02 ([63.239.65.40]:51581 "EHLO
	msux-gh1-uea02.nsa.gov" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753623Ab0DUMeb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 08:34:31 -0400
Subject: Re: [PATCH 0/3] Taming execve, setuid, and LSMs
From: Stephen Smalley <sds@tycho.nsa.gov>
To: Andrew Lutomirski <luto@mit.edu>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, "Serge E. Hallyn" <serue@us.ibm.com>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Eric Biederman <ebiederm@xmission.com>,
       "Andrew G. Morgan" <morgan@kernel.org>
In-Reply-To: <s2pcb0375e11004200853m62ee45b5lf447da1e1a55ffc5@mail.gmail.com>
References: <cover.1269610458.git.luto@mit.edu>
	 <20100419172639.GA15800@us.ibm.com>
	 <n2ycb0375e11004191432g855540c0jab7989d75b32200d@mail.gmail.com>
	 <20100419213952.GA28494@hallyn.com>
	 <1271767039.30027.50.camel@moss-pluto.epoch.ncsc.mil>
	 <v2qcb0375e11004200723w776f806elb1be2c3aa30f1671@mail.gmail.com>
	 <1271777652.30027.131.camel@moss-pluto.epoch.ncsc.mil>
	 <s2pcb0375e11004200853m62ee45b5lf447da1e1a55ffc5@mail.gmail.com>
Content-Type: text/plain
Organization: National Security Agency
Date: Wed, 21 Apr 2010 08:34:26 -0400
Message-Id: <1271853266.7088.40.camel@moss-pluto.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-04-20 at 11:53 -0400, Andrew Lutomirski wrote:
> On Tue, Apr 20, 2010 at 11:34 AM, Stephen Smalley <sds@tycho.nsa.gov> wrote:
> >>
> >> True,  but I think it's still asking for trouble -- other LSMs could
> >> (and almost certainly will, especially the out-of-tree ones) do
> >> something, and I think that any action at all that an LSM takes in the
> >> bprm_set_creds hook for a nosuid (or whatever it's called) process is
> >> wrong or at best misguided.
> >>
> >> Can you think of anything that an LSM should do (or even should be
> >> able to do) when a nosuid process calls exec, other than denying the
> >> request outright?  With my patch, LSMs can still reject the open_exec
> >> call.
> >
> > In the case where the context transition would shed permissions rather
> > than gain permissions, it has been suggested that we shouldn't disable
> > the transition even in the presence of nosuid.  But automatically
> > computing that for a domain transition is non-trivial, so we have the
> > present behavior for SELinux.
> >
> > There also can be state updates even in the non-suid exec case, e.g.
> > saved uids, clearing capabilities, etc.
> 
> Ah, right.
> 
> In my patch, execve_nosecurity is (or will be, anyway) documented to
> skip all of this, and it's a new syscall, so nothing should need to be
> done.  It doesn't allow anything that a userland ELF loader couldn't
> already do.  (I'm not thrilled with changing the behavior of the
> original execve syscall, but one way or another, any nosuid mechanism
> will probably allow programs to exec other things without losing
> permissions that the admin might have expected.  I don't see this is a
> real problem, though.)

The further you deviate from existing execve semantics, the less likely
your solution will work cleanly as a transparent replacement for execve
for userland running in this nosuid state, and the less compelling the
case for implementing execve_nosecurity in the kernel vs. just userspace
emulation of it.

> Is it even possible to purely drop permissions in SELinux?  If your
> original type was orig_t and your new type is new_t, and if the rights
> granted to orig_t and new_t overlap nontrivially, then what are you
> supposed to do?  Check both types for each hook?  (Some annoying admin
> could even *change* the rights for orig_t or new_t after execve
> finishes.)

It has always been possible to configure policy such that one type is
less privileged than its caller, and the typebounds construct introduced
in more recent SELinux provides a kernel-enforced mechanism for ensuring
that one type is strictly bounded by the permissions of another type.

-- 
Stephen Smalley
National Security Agency

