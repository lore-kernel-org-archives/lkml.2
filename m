Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755485Ab0DUVPp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 17:15:45 -0400
Received: from mail-pz0-f176.google.com ([209.85.222.176]:56883 "EHLO
	mail-pz0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754210Ab0DUVPn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 17:15:43 -0400
X-Greylist: delayed 108208 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 Apr 2010 17:15:43 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=t+ZCFLXYBGYfI81PzaM7s/k/Pvfeo8fdkemWQ1RrwjpFh4CYPLQfWYVgyQKQUphGZ0
         Y6JULeg7Fe4VxhXdBnl1feQ5INhSCINE09vFgVH/1HHx3nK9TEiH6m6OCWzP48W4wpe5
         GxDBbQGvv4hX7FG3MRCdCSUv/O5XfnWRs3Rfc=
MIME-Version: 1.0
In-Reply-To: <20100420143545.GA19513@us.ibm.com>
References: <cover.1269610458.git.luto@mit.edu> <20100419172639.GA15800@us.ibm.com> 
	<n2ycb0375e11004191432g855540c0jab7989d75b32200d@mail.gmail.com> 
	<20100419213952.GA28494@hallyn.com> <1271767039.30027.50.camel@moss-pluto.epoch.ncsc.mil> 
	<v2qcb0375e11004200723w776f806elb1be2c3aa30f1671@mail.gmail.com> 
	<20100420143545.GA19513@us.ibm.com>
From: Andrew Lutomirski <luto@mit.edu>
Date: Wed, 21 Apr 2010 17:15:22 -0400
X-Google-Sender-Auth: 06f3e73d89a06f38
Message-ID: <q2pcb0375e11004211415ge9371513n6fad211823aba2b3@mail.gmail.com>
Subject: Re: [PATCH 0/3] Taming execve, setuid, and LSMs
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Stephen Smalley <sds@tycho.nsa.gov>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       Eric Biederman <ebiederm@xmission.com>,
       "Andrew G. Morgan" <morgan@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 20, 2010 at 10:35 AM, Serge E. Hallyn <serue@us.ibm.com> wrote:
> Quoting Andrew Lutomirski (luto@mit.edu):
>> On Tue, Apr 20, 2010 at 8:37 AM, Stephen Smalley <sds@tycho.nsa.gov> wrote:
>> > On Mon, 2010-04-19 at 16:39 -0500, Serge E. Hallyn wrote:
>> >> Quoting Andrew Lutomirski (luto@mit.edu):
>>
>> >> > and LSM  transitions.  I
>> >> > think this is a terrible idea for two reasons:
>> >> >   1. LSM transitions already scare me enough, and if anyone relies on
>> >> > them working in concert with setuid, then the mere act of separating
>> >> > them might break things, even if the "privileged" (by LSM) app in
>> >> > question is well-written.
>> >>
>> >> hmm...
>> >>
>> >> A good point.
>> >
>> > At least in the case of SELinux, context transitions upon execve are
>> > already disabled in the nosuid case, and Eric's patch updated the
>> > SELinux test accordingly.
>> >
>>
>> True,  but I think it's still asking for trouble -- other LSMs could
>> (and almost certainly will, especially the out-of-tree ones) do
>> something, and I think that any action at all that an LSM takes in the
>> bprm_set_creds hook for a nosuid (or whatever it's called) process is
>> wrong or at best misguided.
>
> I could be wrong, but I think the point is that your reasoning is
> correct, and that the same reasoning must apply if we're just
> executing a file out of an fs which has been mounted with '-o nosuid'.

I think Stephen has just convinced me that MNT_NOSUID will never make
sense -- there's odd legacy behavior in there and we'll probably never
get anyone to change it.

So if we give up on changing nosuid, there are a couple of things we
might want to do:

1. A mode where execve acts like all filesystems are MNT_NOSUID.  This
sounds like a bad idea (if nothing else, it will cause apps that use
selinux's exec_sid mechanism (runcon?) to silently malfunction).

2. A mode where execve (or a new syscall?) has no effect on
credentials at all.  This is conceptually simple and it would be great
for new userspace code, especially code that wants to do something
sandbox-like.  For simplicity, even things like the effective and
inherited capability sets should probably remain unchanged.  In this
mode, we'll have to disallow execing unreadable files.  securebits are
(almost) irrelevant.  This is what my patch does.  Dealing with
AT_SECURE will be awkward at best, so programs that enter this mode
should sanitize their own environments and should be very careful if
they were setuid.  (But they should do that anyway.)

There are a couple of annoyances to deal with.  First, there are LSM
API issues, like this code in SELinux:

	new_tsec->osid = old_tsec->sid;

	/* Reset fs, key, and sock SIDs on execve. */
	new_tsec->create_sid = 0;
	new_tsec->keycreate_sid = 0;
	new_tsec->sockcreate_sid = 0;

and this code in commoncap:

	new->suid = new->fsuid = new->euid;
	new->sgid = new->fsgid = new->egid;

I have no problem keeping these.

The other annoyance is cap_effective.  We could clear it on every exec
(what commoncap does for non-legacy executables, I think), but that
would completely break any legacy code running as root.  We could set
it to cap_permitted on every exec, which sounds like bad engineering
even though I don't see any specific problem with it.  We could also
just leave it alone across exec, which might have odd side effects for
programs which change their effective set and then call exec without
thinking.  (We could also emulate current behavior: in SECURE_NOROOT
mode, clear effective, and otherwise set it depending on euid.  This
may be the best idea, since securebits already affects setuid().  This
emulation should *not* extend to cap_permitted or cap_inheritable.)

Empirically, my Fedora system is almost completely usable in this mode
(with cap_effective just passing through unchanged).

3. Some intermediate mode meant for userspace code that wants to
create containers or otherwise manipulate dangerous things but that
still want to execute legacy code.  Breaking out of containers on exec
sounds like a really bad idea.  Off the top of my head, I can think of
a couple of possibilities:

3a. Treat all executables like they have some standard (safe) label.
This could be: fP = 0, fI = everything, no setuid/setgid, and whatever
LSM label makes sense (file_t or something new for selinux, perhaps).
LSMs might want to add weird rules for what can exec what, but they
*must not* ever increase permission.  Decreasing permission (with
selinux typebounds?) could be done, but I'm happy to leave that for
new features that the LSM people could add if they want.

3b. Whatever the final version of Eric's patch was.


Any thoughts on what we want to do?  (2) seems most likely to survive
bashing on LKML.


--Andy

P.S. Rather than targeted capabilities, why not have namespaces come
with file descriptors that let you control them?  sethostname and
setdomainname could be ioctls on the UTS namespace fd, and a network
namespace could come with two fds: one would be (or function as) a
netlink socket and the other would either let you bind low-numbered
ports just by possessing it or would have ioctls or something that
replace bind.  FS namespaces still seem scary.
