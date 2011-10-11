Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751221Ab1JKGm2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 02:42:28 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:48392 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1749667Ab1JKGmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 02:42:24 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Ted Ts'o" <tytso@mit.edu>
Cc: Matt Helsley <matthltc@us.ibm.com>,
        Lennart Poettering <mzxreary@0pointer.de>,
        Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org,
        harald@redhat.com, david@fubar.dk, greg@kroah.com,
        Linux Containers <containers@lists.osdl.org>,
        Linux Containers <lxc-devel@lists.sourceforge.net>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Daniel Lezcano <daniel.lezcano@free.fr>,
        Paul Menage <paul@paulmenage.org>
References: <1317943022.1095.25.camel@mop>
	<20111007074904.GC16723@count0.beaverton.ibm.com>
	<20111007160113.GB14201@tango.0pointer.de>
	<m17h4g2jqy.fsf@fess.ebiederm.org>
	<20111010163140.GA22191@tango.0pointer.de>
	<m1mxd8lg0x.fsf_-_@fess.ebiederm.org>
	<20111011013201.GA7948@thunk.org>
	<20111011020530.GG16723@count0.beaverton.ibm.com>
	<20111011032523.GB7948@thunk.org>
Date: Mon, 10 Oct 2011 23:42:36 -0700
In-Reply-To: <20111011032523.GB7948@thunk.org> (Ted Ts'o's message of "Mon, 10
	Oct 2011 23:25:23 -0400")
Message-ID: <m1ty7ghvvn.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/D+2jvD44zkRn6U6GRTHvRqb9+PnB/Vmc=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.8 RDNS_NONE Delivered to internal network by a host with no rDNS
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Ted Ts'o <tytso@mit.edu>
X-Spam-Relay-Country: **
Subject: Re: Detecting if you are running in a container
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ted Ts'o <tytso@mit.edu> writes:

> On Mon, Oct 10, 2011 at 07:05:30PM -0700, Matt Helsley wrote:
>> Yes, it does detract from the unique advantages of using a container.
>> However, I think the value here is not the effeciency of the initial
>> system configuration but the fact that it gives users a better place to
>> start.
>> 
>> Right now we're effectively asking users to start with non-working
>> and/or unfamiliar systems and repair them until they work.
>
> If things are not working with containers, I would submit to you that
> we're doing something wrong(tm). 

That is what this discussion is about.  What we are doing wrong(tm).
Mostly it is about the bits that have not yet been namespacified but
need to be.

I am totally in favor of not starting the entire world.  But just
like I find it convienient to loopback mount an iso image to see
what is on a disk image.  It would be handy to be able to just
download a distro image and play with it, without doing anything
special.

We can pair things down farther for the people who are running 1000
copies of apache but not requiring detailed distro surgery before
starting up the binaries on a livecd sounds handy.

> Things should just work, except that
> processes in one container can't use more than their fair share (as
> dictated by policy) of memory, CPU, networking, and I/O bandwidth.

You have to be careful with the limiters.  The fundamental reason
why containers are more efficient than hardware virtualization is
that with containers we can do over commit of resources, especially
memory.  I keep seeing implementations of resource limiters that want
to do things in a heavy handed way that break resource over commit.

> Something which is baked in my world view of containers (which I
> suspect is not shared by other people who are interested in using
> containers) is that given that kernel is shared, trying to use
> containers to provide better security isolation between mutually
> suspicious users is hopeless.  That is, it's pretty much impossible to
> prevent a user from finding one or more zero day local privilege
> escalation bugs that will allow a user to break root.  And at that
> point, they will be able to penetrate the kernel, and from there,
> break security of other processes.

You don't even have to get to security problems to have that concern.
There are enough crazy timing and side channel attacks.

I don't know what concern you have security wise, but the problem that
wants to be solved with user namespaces is something you hit much
earlier than when you worry about sharing a kernel between mutually
distrusting users.  Right now root inside a container is root rout
outside of a container just like in a chroot jail.  Where this becomes a
problem is that people change things like like
/proc/sys/kernel/print-fatal-signals expecting it to be a setting local
to their sand box when in fact the global setting and things start
behaving weirdly for other users.  Running sysctl -a during bootup 
has that problem in spades.

With user namespaces what we get is that the global root user is not the
container root user and we have been working our way through the
permission checks in the kernel to ensure we get them right in the
context of the user namespace.  This trivially means that the things
that we allow the global root user to do in /proc/ and /sysfs and
the like simply won't be allowed as a container root user.  Which
makes doing something stupid and affecting other people much more
difficult.

What the user namespace also allows is an escape hatch from the
bonds of suid.  Right now anything that could confuse an existing
app with that is suid root we have to only allow to root, or risk
adding a security hole.  With the user namespaces we can relax
that check and allow it also for container root users as well
as global root users.  When we are brave enough and certain
enough of our code we can allow non-root users to create their
own user namespaces.

There is the third use for containers where for some reason
we have uid assignment overlap.  Perhaps one distroy assigns
uid 22 to sshd and another to the nobody user.  Or perhaps there
are two departments who have that have done the silly thing
of assigning overlapping uids to their users and we want to
accesses filesystems created by both departments at the same
time without a chance of confusion and conflict.

With my sysadmin hat on I would not want to touch two untrusting groups
of users on the same machine.  Because of the probability there is at
least one security hole that can be found and exploited to allow
privilege escalation.

With my kernel developer hat on I can't just say surrender to the
idea that there will in fact be a privilege escalation bug that
is easy to exploit.  The code has to be built and designed so that
privilege escalation is difficult.  Otherwise we might as well
assume if you visit a website an stealthy worm has taken over your
computer.

It is my hope at the end of the day that the user namespaces will be one
more line of defense in messing up and slowing down the evil omnicient
worms that seem to uneering go for every privilege exploit there is.

Eric

