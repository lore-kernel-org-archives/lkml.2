Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753198Ab2HOINq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 04:13:46 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:51510 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065Ab2HOINk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 04:13:40 -0400
Date: Wed, 15 Aug 2012 01:13:32 -0700
From: Joel Becker <jlbec@evilplan.org>
To: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'Felipe Balbi'" <balbi@ti.com>,
        "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>,
        "'Sebastian Andrzej Siewior'" <bigeasy@linutronix.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        "'Alan Stern'" <stern@rowland.harvard.edu>
Subject: Re: [RFC 0/2] USB gadget - configfs
Message-ID: <20120815081331.GL31083@dhcp-172-17-9-228.mtv.corp.google.com>
Mail-Followup-To: Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
	linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
	'Kyungmin Park' <kyungmin.park@samsung.com>,
	'Felipe Balbi' <balbi@ti.com>,
	'Greg Kroah-Hartman' <gregkh@linuxfoundation.org>,
	'Sebastian Andrzej Siewior' <bigeasy@linutronix.de>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	'Alan Stern' <stern@rowland.harvard.edu>
References: <1340276129-20023-1-git-send-email-andrzej.p@samsung.com>
 <20120702090907.GC13247@dhcp-172-17-9-228.mtv.corp.google.com>
 <000501cd5e79$a770be50$f6523af0$%p@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000501cd5e79$a770be50$f6523af0$%p@samsung.com>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
 come to perfection.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 10, 2012 at 10:54:44AM +0200, Andrzej Pietrasiewicz wrote:
> Dear Joel,
> 
> Thank you for your review.
> 
> @Sebastian, Alan, Felipe: Thank you, too.
> 
> On Monday, July 02, 2012 11:09 AM Joel Becker wrote:
> 
> <snip>
> 
> > 
> > > As a prerequisite it adds an operation to configfs. The operation allows
> > > checking if it is ok to remove a pseudo directory corresponding to a
> > > configfs item/group.
> > 
> > 	I NAK'd that patch because you should be using
> > configfs_depend_item().  If you have trouble with that, let's talk.
> > 
> 
> Now I see the configfs_depend_item() is the way to go. I am in doubt,
> though, so could you please throw some light on it? Here is why:
> As an example I did a quick-and-dirty port of f_mass_storage to the new,
> configfs-based approach. The business logic of this function is that
> once a lun is opened, it must not be changed (deleted, in particular)
> until it is closed. The moment the lun is opened is defined by a write
> to a configfs "file" attribute of a lun config item:
> 
>                +-/lunX
>                |  |
>                |  +-file
>                |  |
>                |  +-nofua
>                |  |
>                |  +-removable
>                |  |
>                |  +-ro
> 
> So, the config item corresponding to the lun becomes depended on during
> the write file operation, the same with undepend. Can this be expressed
> with configfs_depend/undepend_item()? Your code in fs/configfs/dir.c
> contains a warning not to call the configfs_depend_item()
> from a configfs callback.
> In this case, is store_attribute a configfs callback?

Hey Andrzej,
	I'm sorry it took me so long to write back.  I wanted a chance
to read and understand your code, so I could make some intelligent
comments.
	But first, a small aside.  Rather than filp_open() a filename
within the kernel, with all of its attendant state problems, you should
just take a file descriptor.  You can then let userspace permissions and
other things Just Work.  See
fs/ocfs2/heartbeat.c:o2hb_region_dev_write() for an example of o2hb
doing exactly this.  It takes a file descriptor and fgets() the filp.
The process writing the fd can actually close the file right after;
the heartbeat code has its reference.
	Let's continue with that example.  Just like your code, when
o2hb is given its fd, it starts up the heartbeat infrastructure.  So not
only does it hold a reference on the filp, it is starting threads and
such.  However, it also does not block deletion of the object.  If you
rmdir() the config_item, it will shut down the threads and drop the
filp.  This is analogous to your problem.  What happens if you remove a
heartbeat device underneath a running ocfs2 filesystem?  Why, it must
crash!  We don't want that, so when the ocfs2 filesystem is mounted, it
uses configfs_depend_item() to pin that heartbeat device.  This is what
I mean by pinning outside the configfs callback.
	Yes, attribute store is a callback.  So what should you do?
This is where my understanding of your setup logic fails me.  At first I
thought fsg_bind_function() was the right place, because it is where you
expect the LUNs to already be configured.  But it is, in turn, called
underneath another configfs callback (ufg_gadget_grp_store_connect()).
	Can you help me understand the userspace steps that are used to
set up a gadget?  The way I read the code, there is some software in the
gadget that sets up the LUN mappings; that is, the host has no idea
"lun01" is backed by a file named "foo".  So, if you had a gadget that
just exposed a single LUN, it would have some userspace software at
startup that sets fua=1, removable=0, ro=0, file="foo".  At some future
point, the host connects to the gadget.  At this point, lun01 is
connected to the host, and it had better not disappear.  What part of
the code reacts to the host connect?  This is the "open" of the LUN
where I think you should be locking out.

Joel


-- 

"Only a life lived for others is a life worth while."
							-Albert Einstein  

			http://www.jlbec.org/
			jlbec@evilplan.org
