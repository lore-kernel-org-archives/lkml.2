Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753178Ab2AXXQc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 18:16:32 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46718 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752706Ab2AXXQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 18:16:31 -0500
Date: Tue, 24 Jan 2012 17:16:01 -0600
From: Serge Hallyn <serge.hallyn@canonical.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: "Serge E. Hallyn" <serge@hallyn.com>,
        containers@lists.linux-foundation.org,
        Dave Hansen <haveblue@us.ibm.com>, linux-kernel@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andy Whitcroft <apw@canonical.com>, sukadev@linux.vnet.ibm.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [RFC] fix devpts mount behavior
Message-ID: <20120124231601.GA4470@sergelap>
References: <20120124000517.GA28878@sergelap>
 <CA+55aFz9ofF+Ey8VCDS8UEf2XSw36kj2RhkHfFScuzLXMeNrkA@mail.gmail.com>
 <20120124002555.GA29534@sergelap>
 <CA+55aFzwOU137V6wtyBjessx05NJo2G4KV0rvTKWvC79A+o9iQ@mail.gmail.com>
 <20120124010758.GJ23916@ZenIV.linux.org.uk>
 <m1k44gj1cu.fsf@fess.ebiederm.org>
 <20120124220247.GA26353@hallyn.com>
 <CAPXgP13_gczQmG_USAp0p2AuTfxkzAvzHvjbZY_rbbLH-4rDyg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPXgP13_gczQmG_USAp0p2AuTfxkzAvzHvjbZY_rbbLH-4rDyg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Kay Sievers (kay.sievers@vrfy.org):
> On Tue, Jan 24, 2012 at 23:02, Serge E. Hallyn <serge@hallyn.com> wrote:
> > Quoting Eric W. Biederman (ebiederm@xmission.com):
> 
> >> It looks like relatively recent udev still creates /dev/ptmx and does
> >
> > Boy, it does, and it's stubborn about it.  Removing the /lib/udev/rules.d
> > entry doesn't stop it.  (this is after I've had an init job replace the
> > devtmpfs-created ptmx entry with a symlink)
> 
> Udev has nothing to do with that. The kernel creates that device node.
> Udev does not carry any rules you could remove, to name device nodes,
> it only set permissions and creates symlinks to device nodes.

That's odd, because I was sure I deleted the node after the kernel created
it.

But it sounds like I must have done it wrong.

> It will never replace a kernel-created device node with a symlink,
> there is no way to express that. If you don't want a device node
> there, you need to change the kernel, to not export
> /sys/class/tty/ptmx/ the way it is today.
> 
> > So current distros (well, Ubuntu and Fedora at least) would need to at least
> > (a) fix udev,
> 
> To do what?

Nothing, as I'm sure you're right above  :)

> > (b) change the default devpts mount (done from initramfs) to
> > add ptmxmode=666,
> 
> > (c) (if not done in udev) create the /dev/ptmx symlink.
> 
> Udev can only create symlinks to devices the driver-core creates, not
> to devices inside a custom filesystem.

I see.

> > For safety I'd recommend creating /dev/pts/ptmx with
> > DEVPTS_MULTIPLE_INSTANCES=n (or dropping that support), and by default
> > setting ptmxmode to 666 as that's what udev does.
> 
> The mode for ptmx is set by the kernel itself, and does not even need
> udev to do that:
>   $ cat /sys/class/tty/ptmx/uevent
>   MAJOR=5
>   MINOR=2
>   DEVNAME=ptmx
>   DEVMODE=0666

That has nothing to do with /dev/pts/ptmx, whose perms are set based on
the '-o ptmxmode=" argument, and default to 000 if not specified.  If
/dev/ptmx is going to be a symlink to /dev/pts/ptmx, then we have to set
the /dev/pts/ptmx perms to not be 000, or users won't be able to create
ptys.

-serge
