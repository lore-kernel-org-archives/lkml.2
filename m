Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932811Ab2GBJJR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 05:09:17 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:41891 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932716Ab2GBJJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 05:09:14 -0400
Date: Mon, 2 Jul 2012 02:09:08 -0700
From: Joel Becker <jlbec@evilplan.org>
To: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [RFC 0/2] USB gadget - configfs
Message-ID: <20120702090907.GC13247@dhcp-172-17-9-228.mtv.corp.google.com>
Mail-Followup-To: Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
	linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Felipe Balbi <balbi@ti.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Marek Szyprowski <m.szyprowski@samsung.com>
References: <1340276129-20023-1-git-send-email-andrzej.p@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340276129-20023-1-git-send-email-andrzej.p@samsung.com>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
 come to perfection.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 21, 2012 at 12:55:27PM +0200, Andrzej Pietrasiewicz wrote:
> Dear All,
> 
> This patch series is a follow-up to this thread:
> 
> http://marc.info/?l=linux-usb&m=132430533824884&w=2

Dear Andrzej,
	I read this thread just now, and I wanted to comment.  I think
configfs fits your needs nicely here.  I'd like to affirm your
supposition that hiding the details in a library is the right way to go.
 configfs aims to provide nice, predictable, transparent user<->kernel
API for creating and configuring objects, but it doesn't have to be what
the end user or administrator sees in everyday use.  Most of the other
configfs clients (ocfs2, dlm, target) wrap configfs usage in their
tools.

> As a prerequisite it adds an operation to configfs. The operation allows
> checking if it is ok to remove a pseudo directory corresponding to a
> configfs item/group.

	I NAK'd that patch because you should be using
configfs_depend_item().  If you have trouble with that, let's talk.

<snip>
 
> I would like to ask some questions. All answers in general, and answers
> from linux-usb and Felipe and Greg KH in particular, are welcome.
> 
> 1. Generally, is this the right way to go?

LGTM.

> 2. Using configfs like this calls for an interface between the generic
>    configfs-related code and function-specific code. I suggested the
>    struct ufg_fn. What do you think?
> 3. Should some parameters still be available through sysfs?

	If they fit, yes.  As a rule of thumb, if userspace directed the
object creation, it should be in configfs.  But if kernelspace created
the object, sysfs is the better location.  There is wiggle room here.
Do not be afraid to use both.  configfs was created because sysfs didn't
fit userspace-directed creation.  configfs is not intended to replace
all of the things sysfs does better.

> 4. Do we need module parameters for USB descriptors like iManufacturer
>    and similar?
> 5. I assumed that the configfs entities are contained in the structures
>    used for configuring the USB functions, e.g. a struct config_group in
>    struct fsg_common, or a struct config_item in a struct fsg_lun. This
>    has implications that the lifetime of the structures is controlled by
>    userspace through configfs, which, in turn, has influence on how
>    the USB functions are implemented. Even though it seems natural,
>    there are some issues. For example an extension to configfs was required
>    in order to disable deleting the luns while the gadget is connected.
>    Is this the right approach? If not, then are there any alternatives?

	Yes, embedding in the structures is correct.  These are
userspace-created objects, and thus userspace has control over their
lifetimes.  That's intentional.  See above about configfs_depend_item()
for blocking unsafe removal.

Joel

-- 

"Hey mister if you're gonna walk on water,
 Could you drop a line my way?"

			http://www.jlbec.org/
			jlbec@evilplan.org
