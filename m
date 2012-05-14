Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932202Ab2ENTS7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 15:18:59 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47449 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755118Ab2ENTS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 15:18:58 -0400
Date: Mon, 14 May 2012 12:18:53 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Tejun Heo <tj@kernel.org>, "Eric W. Biederman" <ebiederm@xmission.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sysfs: get rid of some lockdep false positives
Message-ID: <20120514191853.GA4344@kroah.com>
References: <Pine.LNX.4.44L0.1205141324200.1699-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1205141324200.1699-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 14, 2012 at 01:30:03PM -0400, Alan Stern wrote:
> This patch (as1554) fixes a lockdep false-positive report.  The
> problem arises because lockdep is unable to deal with the
> tree-structured locks created by the device core and sysfs.
> 
> This particular problem involves a sysfs attribute method that
> unregisters itself, not from the device it was called for, but from a
> descendant device.  Lockdep doesn't understand the distinction and
> reports a possible deadlock, even though the operation is safe.
> 
> This is the sort of thing that would normally be handled by using a
> nested lock annotation; unfortunately it's not feasible to do that
> here.  There's no sensible way to tell sysfs when attribute removal
> occurs in the context of a parent attribute method.
> 
> As a workaround, the patch adds a new flag to struct attribute
> telling sysfs not to inform lockdep when it acquires a readlock on a
> sysfs_dirent instance for the attribute.  The readlock is still
> acquired, but lockdep doesn't know about it and hence does not
> complain about impossible deadlock scenarios.
> 
> Also added are macros for static initialization of attribute
> structures with the ignore_lockdep flag set.  The three offending
> attributes in the USB subsystem are converted to use the new macros.
> 
> Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
> Acked-by: Tejun Heo <tj@kernel.org>
> CC: Eric W. Biederman <ebiederm@xmission.com>
> CC: Peter Zijlstra <peterz@infradead.org>
> 
> ---
> 
>  drivers/usb/core/sysfs.c |    6 +++---
>  fs/sysfs/dir.c           |   31 ++++++++++++++++++++++++++-----
>  include/linux/device.h   |    3 +++
>  include/linux/sysfs.h    |   12 ++++++++++++
>  4 files changed, 44 insertions(+), 8 deletions(-)
> 
> Index: usb-3.4/include/linux/sysfs.h
> ===================================================================
> --- usb-3.4.orig/include/linux/sysfs.h
> +++ usb-3.4/include/linux/sysfs.h

Just a note about this patch, from a meta-point of view (I have no
objection to the patch at all, I'll go apply it in a bit.)

You do use git to generate these patches, right?  Or are you using
something else?  The "Index:" lines seem odd, like cvs things.

Also, I just learned about the '--3way' option to 'git am', which, when
I have merge problems with a patch (like, for example this one, which
had rejects in the device.h portion), should be able to help me out, if
you used git to generate the patch.

But, if you don't use git, no problems, I was just curious as to what
was creating the "Index:" lines.

thanks,

greg k-h
