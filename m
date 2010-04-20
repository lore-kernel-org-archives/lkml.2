Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752276Ab0DTPev (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 11:34:51 -0400
Received: from reserved-DSUX-GH1-UEA02 ([63.239.65.40]:45890 "EHLO
	msux-gh1-uea02.nsa.gov" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1750957Ab0DTPet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 11:34:49 -0400
Subject: Re: [PATCH 0/3] Taming execve, setuid, and LSMs
From: Stephen Smalley <sds@tycho.nsa.gov>
To: Andrew Lutomirski <luto@mit.edu>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, "Serge E. Hallyn" <serue@us.ibm.com>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Eric Biederman <ebiederm@xmission.com>,
       "Andrew G. Morgan" <morgan@kernel.org>
In-Reply-To: <v2qcb0375e11004200723w776f806elb1be2c3aa30f1671@mail.gmail.com>
References: <cover.1269610458.git.luto@mit.edu>
	 <20100419172639.GA15800@us.ibm.com>
	 <n2ycb0375e11004191432g855540c0jab7989d75b32200d@mail.gmail.com>
	 <20100419213952.GA28494@hallyn.com>
	 <1271767039.30027.50.camel@moss-pluto.epoch.ncsc.mil>
	 <v2qcb0375e11004200723w776f806elb1be2c3aa30f1671@mail.gmail.com>
Content-Type: text/plain
Organization: National Security Agency
Date: Tue, 20 Apr 2010 11:34:12 -0400
Message-Id: <1271777652.30027.131.camel@moss-pluto.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-04-20 at 10:23 -0400, Andrew Lutomirski wrote:
> On Tue, Apr 20, 2010 at 8:37 AM, Stephen Smalley <sds@tycho.nsa.gov> wrote:
> > On Mon, 2010-04-19 at 16:39 -0500, Serge E. Hallyn wrote:
> >> Quoting Andrew Lutomirski (luto@mit.edu):
> 
> >> > and LSM  transitions.  I
> >> > think this is a terrible idea for two reasons:
> >> >   1. LSM transitions already scare me enough, and if anyone relies on
> >> > them working in concert with setuid, then the mere act of separating
> >> > them might break things, even if the "privileged" (by LSM) app in
> >> > question is well-written.
> >>
> >> hmm...
> >>
> >> A good point.
> >
> > At least in the case of SELinux, context transitions upon execve are
> > already disabled in the nosuid case, and Eric's patch updated the
> > SELinux test accordingly.
> >
> 
> True,  but I think it's still asking for trouble -- other LSMs could
> (and almost certainly will, especially the out-of-tree ones) do
> something, and I think that any action at all that an LSM takes in the
> bprm_set_creds hook for a nosuid (or whatever it's called) process is
> wrong or at best misguided.
> 
> Can you think of anything that an LSM should do (or even should be
> able to do) when a nosuid process calls exec, other than denying the
> request outright?  With my patch, LSMs can still reject the open_exec
> call.

In the case where the context transition would shed permissions rather
than gain permissions, it has been suggested that we shouldn't disable
the transition even in the presence of nosuid.  But automatically
computing that for a domain transition is non-trivial, so we have the
present behavior for SELinux.

There also can be state updates even in the non-suid exec case, e.g.
saved uids, clearing capabilities, etc.

But as far as the access control goes, it should suffice to check read
and execute access to the file, just as with the userland ELF loader
scenario (which gets handled by the mmap hook).

-- 
Stephen Smalley
National Security Agency

