Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752676Ab1JJQbp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 12:31:45 -0400
Received: from tango.0pointer.de ([85.214.72.216]:41648 "EHLO
	tango.0pointer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786Ab1JJQbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 12:31:44 -0400
Date: Mon, 10 Oct 2011 18:31:41 +0200
From: Lennart Poettering <mzxreary@0pointer.de>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Matt Helsley <matthltc@us.ibm.com>, Kay Sievers <kay.sievers@vrfy.org>,
        linux-kernel@vger.kernel.org, harald@redhat.com, david@fubar.dk,
        greg@kroah.com
Subject: Re: A =?utf-8?Q?Plumber=E2=80=99?=
	=?utf-8?Q?s?= Wish List for Linux
Message-ID: <20111010163140.GA22191@tango.0pointer.de>
References: <1317943022.1095.25.camel@mop>
 <20111007074904.GC16723@count0.beaverton.ibm.com>
 <20111007160113.GB14201@tango.0pointer.de>
 <m17h4g2jqy.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m17h4g2jqy.fsf@fess.ebiederm.org>
Organization: Red Hat, Inc.
X-Campaign-1: ()  ASCII Ribbon Campaign
X-Campaign-2: /  Against HTML Email & vCards - Against Microsoft Attachments
User-Agent: Leviathan/19.8.0 [zh] (Cray 3; I; Solaris 4.711; Console)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 07.10.11 21:24, Eric W. Biederman (ebiederm@xmission.com) wrote:

> 
> Lennart Poettering <mzxreary@0pointer.de> writes:
> 
> > On Fri, 07.10.11 00:49, Matt Helsley (matthltc@us.ibm.com) wrote:
> >
> >> 
> >> On Fri, Oct 07, 2011 at 01:17:02AM +0200, Kay Sievers wrote:
> >> 
> >> <snip>
> >> 
> >> > * simple, reliable and future-proof way to detect whether a specific pid
> >> > is running in a CLONE_NEWPID container, i.e. not in the root PID
> >> > namespace. Currently, there are available a few ugly hacks to detect
> >> 
> >> Is that precisely what's needed or would it be sufficient to know
> >> that the pid is running in a child pid namespace of the current pid
> >> namespace? If so, I think this could eventually be done by comparing
> >> the inode numbers assigned to /proc/<pid>/ns/pid to those of
> >> /proc/1/ns/pid.
> >
> > I think the most interesting test would be to figure out for a process
> > if itself is running in a PID namespace. And for that comparing inodes
> > wouldn't work since the namespace process would never get access to the
> > inode of the outside init.
> 
> Strictly correct answer.  All processes are running in a pid namespace.
> I think we can implement that in a libc header.
> 
> static inline bool in_pid_namespace(void)
> {
>         return true;
> }
> 
> Why does it matter if you are running in something other than the
> initial pid namespace?  I expect what you are really after is something
> else entirely, and you are asking the wrong question.

Well, all other virtualization solutions are easily detectable via CPUID
leaf 0x1, bit 31, and via DMI and some other ways. However, for Linux
containers there is no nice way to detect them.

VMs are pretty good at providing a comprehensive emulation of real
machines, and distributions running in them usually do not need
information whether they are running in a VM or not. This is very
different though for containers: Quite a few kernel subsystems are
currently not virtualized, for example SELinux, VTs, most of sysfs, most
of /proc/sys, audit, udev or file systems (by which I mean that for a
container you probably don't want to fsck the root fs, and so on), and
containers tend to be much more lightweight than real systems.

To make a standard distribution run nicely in a Linux container you
usually have to make quite a number of modifications to it and disable
certain things from the boot process. Ideally however, one could simply
boot the same image on a real machine and in a container and would just
do the right thing, fully stateless. And for that you need to be able to
detect containers, and currently you can't.

Of course, in 10 years or so containers might be much more complete then
they are right now, and virtualize all subsystems I listed above and
maybe a ton more, but that's 10y for now, and for now to make things
work as cleanly as possible it would be immensly helpful if containers
could be detectable in a nice way.

Of course, in many case there are nicer ways to shortcut the init jobs
on a container. For example, instead of bypassing root fsck in a
container it makes a lot more sense to simply say: bypass root fsck if
the root fs is already writable. And there's more like that. But at the
end of the day you always want to be able to bind certain things to the
fact that you are running in a container, if you want things to "just
work". And I believe that must be the goal. 

I am pretty sure that having a way to detect execution in a container is
a minimum requirement to get general purpose distribution makers to
officially support and care for execution in container environments. As
you are a container guy I am sure that would be very much in your
interest.

And note that I am only interested in detecting CLONE_NEWPID, not the
other namespaces. CLONE_NEWPID is the core namespace technology that
turns a container into a container, so that's all that's needed.

And yes, CLONE_NEWPID can be useful for other purposes then just
containers as well. However, that doesn't really matter for my usecase
as mentioned above: becuase if you run an init system in CLONE_NEWPID
namespace, then that's what I call a container, and the init system
should have all rights to detect that.

The root PID namespace is different from all other namespaces btw,
already in the fact that the the kernel threads are part of it, but not
the other namespaces.

Finally, note that it prevously has been very easy to detect execution
in a container, simple by checking the "ns" cgroup hierarchy. (i.e. look
whether the path in /proc/self/cgroup for "ns" wasn't "/" and you knew
you were in a container). systemd made use of that and since very early
on we supported container boots. The removal of "ns" broke systemd in
that regard. Now, I don't want "ns" back, and I am not going to make the
big hubbub out of the fact that you guys broke userspace that way. But
what I do like to see made available again is a sane way to detect
execution in a container environment, i.e. a way for a process to detect
whether it is running in the root CLONE_NEWPID namespace.

Thanks,

Lennart

-- 
Lennart Poettering - Red Hat, Inc.
