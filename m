Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755378Ab0DVOgQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 10:36:16 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:57657 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755288Ab0DVOgO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 10:36:14 -0400
Date: Thu, 22 Apr 2010 09:36:09 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Kyle Moffett <kyle@moffetthome.net>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       lkml <linux-kernel@vger.kernel.org>,
       David Howells <dhowells@redhat.com>,
       Ashwin Ganti <ashwin.ganti@gmail.com>, Greg KH <greg@kroah.com>,
       rsc@swtch.com, ericvh@gmail.com, linux-security-module@vger.kernel.org,
       Ron Minnich <rminnich@gmail.com>, jt.beard@gmail.com,
       Andrew Morton <akpm@linux-foundation.org>,
       Andrew Morgan <morgan@kernel.org>, oleg@us.ibm.com,
       Eric Paris <eparis@redhat.com>, linux-api@vger.kernel.org,
       Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH 3/3] p9auth: add p9auth driver
Message-ID: <20100422143609.GA3269@us.ibm.com>
References: <20100421012749.GA21338@us.ibm.com>
 <20100421012908.GB24251@us.ibm.com>
 <20100421102739.6ad932fb@lxorguk.ukuu.org.uk>
 <20100421133917.GB16326@us.ibm.com>
 <20100421151917.5ae20265@lxorguk.ukuu.org.uk>
 <20100421150900.GB31880@us.ibm.com>
 <m11ve81usw.fsf@fess.ebiederm.org>
 <w2wf73f7ab81004212157o371c5738o10c8b6ff807ba36a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <w2wf73f7ab81004212157o371c5738o10c8b6ff807ba36a@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Kyle Moffett (kyle@moffetthome.net):
> On Wed, Apr 21, 2010 at 15:15, Eric W. Biederman <ebiederm@xmission.com> wrote:
> > "Serge E. Hallyn" <serue@us.ibm.com> writes:
> >
> >> Ignoring namespaces for a moment, I guess we could do something like
> >>
> >> struct credentials_pass {
> >>       pid_t global_pid;
> >>       unsigned long unique_id;
> >>       uid_t new_uid;
> >>       gid_t new_gid;
> >>       int num_aux_gids;
> >>       gid_t aux_gids[];
> >> }
> >
> > This looks surprising like what I am doing in passing uids and pids
> > through unix domain sockets.
> >
> > So if this looks like a direction we want to go it shouldn't be too
> > difficult.
> 
> Hmm... for an alternative idea:
> 
> We have this nice "kernel keyring" infrastructure that lets us stuff
> arbitrary things into "keys" and grant/revoke them between processes.
> What if we created a relatively generic way for processes to package
> up privileges (of whatever form) into a "key" that could be granted to
> another process (via UNIX-domain socket)?  Then the other process
> would use a setuid()-ish syscall which would instead apply a specific
> key as your credentials, possibly including the audit context and/or
> namespaces it came from.
> 
> By using the keyring system, such tokens could be kept around across
> multiple processes easily (as opposed to FDs), in the same style as a
> "sudo" ticket file, for example (even with an expiration time).
> 
> Types of credentials you could pass around:
>   * Capabilities
>   * Filesystem UID/GID in a particular UID namespace (for FS operations)
>   * Process UID/GID in a particular UID namespace (for kill(), etc)
>   * Audit contexts
>   * SELinux/etc security labels
> 
> All of the above could be optionally limited to effectively require a
> bprm-secure-style exec() with specific args.  So for example, instead
> of making "/usr/sbin/passwd" a setuid program, you could make it be an
> unprivileged helper.  It would connect to a privileged daemon and ask
> for a password-change cookie for that particular user.  The daemon
> would create what is essentially a "delayed exec" key which grants a
> specific UID and capabilities when that process performs an execkey().

Hi Kyle,

it's a neat idea in terms of flexibility - but in this case the
flexibility really scares me :)

In particular I don't like the ability to keep these tokens around
for later use, and your example of passing around capabilities is
something we've specifically rejected in the past.

That doesn't mean that it wouldn't be a good idea to take your
general approach, use it very inflexibly, and then slowly, as we
gain experience, add flexibility.

I think we are best off starting with two options:

	1. pass audit credentials only
	2. pass full credentials

credentials meaning uid/gid, though - and let capabilities be
sorted out by the setuid rules.

> So as an example, you could rewrite "sudo" as a partially-privileged
> daemon and an unprivileged helper.  The unpriv helper would send
> across a request (optionally including the command and environment)
> which would be checked by the daemon.  It would then issue a key to
> allow the unpriv helper to perform a limited exec.
> 
> Another option would be to rewrite network login programs (eg OpenSSH)
> to use this for privilege separation.  The listening process would get
> a non-expiring key to allow it to exec a partially-privileged
> password-checking program.  If the password-checking program likes the
> password it generates a single-use key to pass back to the forked
> network process that allows it to exec a program as that user.

Note that the last two examples are possible with with the simple
p9auth driver, and are really their motivation.  In fact, we only
need a single privileged back-end (factotum) server to server a bunch
of unprivileged front-end servers.

So over the next few days I will incorporate a bunch of the feedback
on the p9auth driver itself, turn it into a filesystem, and resend
it.  That's not to say that I don't like the other suggestions - I
want to pursue those as well and we can see where we end up and which
approach we prefer.  For a first step I look forward to Eric pushing
the patches to do uid and pid translation for unix sock credentials.

thanks,
-serge
