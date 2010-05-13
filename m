Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753112Ab0EMGKO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 02:10:14 -0400
Received: from bld-mail18.adl2.internode.on.net ([150.101.137.103]:53725 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752308Ab0EMGKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 02:10:12 -0400
Date: Thu, 13 May 2010 16:09:55 +1000
From: Dave Chinner <david@fromorbit.com>
To: Neil Brown <neilb@suse.de>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>, hch@infradead.org,
       viro@zeniv.linux.org.uk, adilger@sun.com, corbet@lwn.net,
       serue@us.ibm.com, linux-fsdevel@vger.kernel.org, sfrench@us.ibm.com,
       philippe.deniel@CEA.FR, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -V7 4/9] vfs: Add open by file handle support
Message-ID: <20100513060955.GG13617@dastard>
References: <1273679444-14903-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1273679444-14903-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <20100513094422.0f7991a0@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100513094422.0f7991a0@notabene.brown>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 13, 2010 at 09:44:22AM +1000, Neil Brown wrote:
> On Wed, 12 May 2010 21:20:39 +0530
> "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com> wrote:
> 
> > +		filp->f_flags |= O_NOATIME;
> > +		filp->f_mode |= FMODE_NOCMTIME;
> > +	}
> 
> I think you need a comment here explaining the rational for these setting.

If you've never seen how applications use the XFS handle interface
in conjunction with other XFS functionality, then I guess if would
seem like bad voodoo.

> Why is O_NOATIME important IFREG but not for IFDIR?

No application has ever required directory access or modification
via the handle interface to be invisible to the rest of the system.

> Why is it not sufficient to honour O_NOATIME that is passed in.

Because the XFS handle library is cross platform and predates
O_NOATIME on linux. Hence the library it has never set that flag and
always relied on the kernel implementation of the API to ensure
atime was never updated on fds derived from handles..

> How can you ever justify setting FMODE_NOCMTIME ?

Quite easily. ;)

The XFS handle interface was designed specifically to allow
applications to execute silent/invisible movement of data in, out
and around the filesystem without leaving user visible traces in
file metadata. This enables backup or filesysetm utilities that
operate on active filesystems need to be able to access or modify
inodes and data without affecting running applications.  It's a
feature of the handle interface, and used by xfs_dump, xfs_fsr,
SGI's HSM, etc to do stuff that isn't otherwise possible.

FWIW, if you are curious, here's the initial commit of the XFS
handle code into Irix tree from 3 Sep 1994, showing that the initial
XFS open_by_handle() implementation sets the FINVIS flag to trigger
invisible IO semantics:

http://oss.sgi.com/cgi-bin/gitweb.cgi?p=archive/xfs-import.git;a=commitdiff;h=575b66fae833429a51fcadb204d45521c2dfc26f

> I guess you are just copying from xfs code, but it still needs justification.

	"They are intended for use by a limited set of system
	utilities such as backup programs."

		- open_by_handle(3) man page

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
