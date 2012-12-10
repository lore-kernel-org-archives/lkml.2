Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754118Ab2LJQ1a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 11:27:30 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:55087 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752174Ab2LJQ11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 11:27:27 -0500
Date: Mon, 10 Dec 2012 10:27:15 -0600
From: Serge Hallyn <serge.hallyn@canonical.com>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: Andy Lutomirski <luto@amacapital.net>,
        "Andrew G. Morgan" <morgan@kernel.org>,
        "Serge E. Hallyn" <serge@hallyn.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        Kees Cook <keescook@chromium.org>,
        James Morris <james.l.morris@oracle.com>,
        Eric Paris <eparis@redhat.com>,
        "Serge E. Hallyn" <serge@canonical.com>,
        Markku Savela <msa@moth.iki.fi>
Subject: Re: [RFC] Capabilities still can't be inherited by normal programs
Message-ID: <20121210162715.GA16520@sergelap>
References: <CALCETrVsrJSt8oYnh+y32Lrxw6Yk=Cp_e07Qf=fLbVfORvzUNg@mail.gmail.com>
 <20121205222040.GB14884@sergelap>
 <50C13F0E.5010401@schaufler-ca.com>
 <20121207144233.GA6681@mail.hallyn.com>
 <CALQRfL6c2nOSOR00YsBhgC=KWSWB-xOsDTJiLzbtmj6Zv1Mr2Q@mail.gmail.com>
 <CALCETrUwVO6YjO-VzwBO59z4L2zB+-Zd_V-ontciMEFzRHzDFQ@mail.gmail.com>
 <CALQRfL4iaHQgQ_PY44xYsyZc3fn4J+9Aw3bMfpPMSbE=4AymSA@mail.gmail.com>
 <CALCETrXrX7V0uW1XQgUAoror1D1ymZL8_0PxjQRWEoSaXT+phg@mail.gmail.com>
 <20121210145950.GC8137@sergelap>
 <50C603F8.6070401@schaufler-ca.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50C603F8.6070401@schaufler-ca.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Casey Schaufler (casey@schaufler-ca.com):
> On 12/10/2012 6:59 AM, Serge Hallyn wrote:
> > Quoting Andy Lutomirski (luto@amacapital.net):
> >> It's especially bad because granting CAP_DAC_READ_SEARCH to user "foo"
> >> doesn't mean anything.  Is he authorized to back things up to
> >> encrypted storage?
> > We're talking about privileges at the kernel level here, and there is
> > no way this could be expressed at that level.
> >
> > Higher level tools could/should certainly be exposing things at this
> > level.
> >
> > BUT
> >
> > You *are* doing a good job of making me feel that we should have
> > per-user fI xattrs or acls.  Sudo is popular because people like to say
> > "user joe can run foo with privilege".  Most people will never want to
> > be bothered to say "user joe can run foo with CAP_XYZ" (versus "as
> > root"), but I do think we could get programs/packages to do that.
> 
> Put an ACL on the program file.
> If you want different users to run with different privilege
> make two copies of the program and give them different
> ACLs and cap sets.

Yes, but that is a bit kludgy.

My own objection to doing per-user fI acls/xattrs is that it
combines in the kernel what so far has only been mixed in
userspace (uids and capabilities, mixed at pam_cap.so).

I guess we could facilitate what you and amorgan suggest by having:

	1. a database listing what privileges a particular tool needs
	   for full functionality
	2. a nice sudo-adm-like program which you can tell "let joe
	   use X with full functionality.
	3. the utility then keeps a hierarchy under /var/lib/privs/$user
	   with binaries $user is allowed to use, properly set up with
	   pI.  No acl needed since /var/lib/privs/$user can just be perms
	   500.

> If your program is so big that making a copy is a disk space issue
> it is too big to have privilege.
> If you can't deal with having the have different paths for different
> users write a shell script that redirects to the correct version
> based on user id.
> 
> This is not rocket science. The kernel shouldn't be crammed
> with mechanism and complexity just because disto/"OS"/site
> developers can't be bothered with learning how the existing
> facilities work.
> 
> I frequently get requests to make changes to the way Smack
> controls access that can easily be achieved using users and
> groups. It's amazing how often people seem to forget that
> Linux has security mechanisms other than the one that they
> think is the cat's pajamas.
> 
> >
> > Note that another difficulty here likes in the age-old, as yet
> > unanswered imo, question of "how do I easily figure out what caps I need
> > to run my program."  A few years ago I pointed to this (perhaps in
> > mostly private emails, don't recall) as something to be solved, but
> > the solution escapes me.
> 
> The audit trail is your friend. If it doesn't tell you what
> capabilities are required that you don't have, it should.

I'm not asking how I personally could do it.  I've written up the hard
way to do it in papers before.  I'm asking how a developer who just
wants to let package installs of his program easily be privileged by
certain users could make that happen.  Asking him to go to the audit
trail is (experience show) akin to telling him to use sudo or setuid-root.

It's possible that good documentation is the (best, or only)
answer.  Or, I do think a cool program could be written which runs
the target program in a container (with userns, so soon could be
done unprivileged) sandbox, looks at audit and strace output with
toggle-able capabilities.  Taken to the extreme a debugger
over a kernel in a vm could in fact be the magic want you say
can't exist :)

> Unfortunately, the Linux (formerly Unix) security policy into
> which the capabilities mechanism was retrofit is implementation
> derived. Without understanding how the Linux security system,
> with users and groups and LSMs and all works it's impossible
> to just guess and even if you do understand all that there is
> going to be lots of environmental context to deal with.
> Sorry, there's no magic wand.
> 
> If I had it to do over there would be many fewer capabilities.
> Please reread that. I said fewer. You need something that would make
> SELinux policy look small to break out a consistent fine granularity,
> so I say go consistently coarse. 

As I've said before, I think the way CAP_SYSLOG was introduced,
although it was intended to be temporary,  is the right way to
add finer-grained capabilities: keep coarser capabilities which
imply all the newer finer-grained capabilities which were derived.

Similarly if we could come up with a nice hierarchy we could also
come up with new, courser capabilities to combine similar
existing ones (i.e.
CAP_DAC_READ_SEARCH+CAP_DAC_OVERRIDE_CAP_FOWNER+CAPFSETID and
CAP_SETUID+CAP_SETGID+CAP_SYS_NICE?)

-serge
