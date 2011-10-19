Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932352Ab1JSXD5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 19:03:57 -0400
Received: from tango.0pointer.de ([85.214.72.216]:52276 "EHLO
	tango.0pointer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932319Ab1JSXDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 19:03:52 -0400
Date: Thu, 20 Oct 2011 01:03:47 +0200
From: Lennart Poettering <mzxreary@0pointer.de>
To: Paul Menage <paul@paulmenage.org>
Cc: Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org,
        harald@redhat.com, david@fubar.dk, greg@kroah.com
Subject: Re: A =?utf-8?Q?Plumber=E2=80=99?=
	=?utf-8?Q?s?= Wish List for Linux
Message-ID: <20111019230347.GA32295@tango.0pointer.de>
References: <1317943022.1095.25.camel@mop>
 <CALdu-PBLCNXTaZuODyzw_g_FQNyLqK_FsdObC=HjtEp75vkdFQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALdu-PBLCNXTaZuODyzw_g_FQNyLqK_FsdObC=HjtEp75vkdFQ@mail.gmail.com>
Organization: Red Hat, Inc.
X-Campaign-1: ()  ASCII Ribbon Campaign
X-Campaign-2: /  Against HTML Email & vCards - Against Microsoft Attachments
User-Agent: Leviathan/19.8.0 [zh] (Cray 3; I; Solaris 4.711; Console)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19.10.11 14:12, Paul Menage (paul@paulmenage.org) wrote:

> On Thu, Oct 6, 2011 at 4:17 PM, Kay Sievers <kay.sievers@vrfy.org> wrote:
> >
> > * fork throttling mechanism as basic cgroup functionality that is
> > available in all hierarchies independent of the controllers used:
> > This is important to implement race-free killing of all members of a
> > cgroup, so that cgroup member processes cannot fork faster then a cgroup
> > supervisor process could kill them. This needs to be recursive, so that
> > not only a cgroup but all its subgroups are covered as well.
> 
> If that's your end goal, then an alternative to the freezer support
> that others have mentioned would be a 'cgroup.signal' file which, when
> written to, would send that signal to all members of the cgroup at
> once. Perhaps simpler than having to get in the way of the fork path
> more and manage a rate-limit.

For our systemd usecase a cgroup.signal file would not be useful. This
is because we actually kill all members of the service's cgroup plus the
main process of the service, which is usually also in the service's
cgroup but sometimes isn't (for example: when the user logs in, the
whole /sbin/login process ends up in the user's session cgroup, and is
removed from the original service cgroup). Since we want to avoid
killing the main service process twice in the case where it isn't in the
servce cgroup we'd hence prefer to have some fork throttling logic in
place, so that we can kill members flexibly in accordance with these
rules.

> > * allow user xattrs to be set on files in the cgroupfs (and maybe
> > procfs?)
> 
> What would the use case be for this?

Attaching meta information to services, in an easily discoverable
way. For example, in systemd we create one cgroup for each service, and
could then store data like the main pid of the specific service as an
xattr on the cgroup itself. That way we'd have almost all service state
in the cgroupfs, which would make it possible to terminate systemd and
later restart it without losing any state information. But there's more:
for example, some very peculiar services cannot be terminated on
shutdown (i.e. fakeraid DM stuff) and it would be really nice if the
services in question could just mark that on their cgroup, by setting an
xattr. On the more desktopy side of things there are other
possibilities: for example there are plans defining what an application
is along the lines of a cgroup (i.e. an app being a collection of
processes). With xattrs one could then attach an icon or human readable
program name on the cgroup.

The key idea is that this would allow attaching runtime meta information
to cgroups and everything they model (services, apps, vms), that doesn't
need any complex userspace infrastructure, has good access control
(i.e. because the file system enforces that anyway, and there's the
"trusted." xattr namespace), notifications (inotify), and can easily be
shared among applications. 

Lennart

-- 
Lennart Poettering - Red Hat, Inc.
