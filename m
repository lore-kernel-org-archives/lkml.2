Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756047Ab0JVM0U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 08:26:20 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:39523 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754838Ab0JVM0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 08:26:19 -0400
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: miklos@szeredi.hu, dave@linux.vnet.ibm.com, akpm@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-reply-to: <20101022064627.GA21607@ZenIV.linux.org.uk> (message from Al Viro
	on Fri, 22 Oct 2010 07:46:27 +0100)
Subject: Re: [PATCH 7/9] vfs: protect remounting superblock read-only
References: <20101005103108.288743609@szeredi.hu>
 <20101005103144.051231469@szeredi.hu> <20101022064627.GA21607@ZenIV.linux.org.uk>
Message-Id: <E1P9Gh4-00054y-EA@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 22 Oct 2010 14:25:58 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Oct 2010, Al Viro wrote:
> On Tue, Oct 05, 2010 at 12:31:15PM +0200, Miklos Szeredi wrote:
> > From: Miklos Szeredi <mszeredi@suse.cz>
> > 
> > Currently remouting superblock read-only is racy in a major way.
> > 
> > With the per mount read-only infrastructure it is now possible to
> > prevent most races, which this patch attempts.
> > 
> > Before starting the remount read-only, set MNT_WRITE_HOLD on all
> > mounts so that writes are held off until the remount either succeeds
> > or fails.
> 
> Umm...  What'll happen if your remount will say mnt_want_write() on
> e.g. internal vfsmount over that sb?

Quickly looking through filesystems I didn't find this sort of usage.

>   Or, more subtle, tries to
> update atime on some opened struct file on that sb.

Hmm, load_nls() will apparently do that.  Drat.

Plan B: remount all vfsmounts read-only before ->remount_fs() but
remember which ones were read-write and restore on failure.  Will
result in ugly transient write failures if remount_fs() fails, but I
don't think anybody would care in practice.

Thanks,
Miklos
