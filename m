Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756488Ab1CCIzJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 03:55:09 -0500
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:42935 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133Ab1CCIzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 03:55:06 -0500
From: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
To: Jonathan Nieder <jrnieder@gmail.com>, Sage Weil <sage@newdream.net>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, linux-api@vger.kernel.org
Subject: Re: [RFC] introduce sys_syncat to sync a single file system
In-Reply-To: <20110303072223.GA28133@elie>
References: <Pine.LNX.4.64.1102171035220.13904@cobra.newdream.net> <20110303072223.GA28133@elie>
User-Agent: Notmuch/0.5-66-g70c5e2c (http://notmuchmail.org) Emacs/23.1.1 (i686-pc-linux-gnu)
Date: Thu, 03 Mar 2011 14:24:56 +0530
Message-ID: <87bp1sziqn.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Mar 2011 01:22:24 -0600, Jonathan Nieder <jrnieder@gmail.com> wrote:
> Hi,
> 
> Sage Weil wrote:
> 
> >  - On machines with many of mounts, it is not at all uncommon for some of
> >    them to hang (e.g. unresponsive NFS server).  sync(2) will get stuck on
> >    those and may never get to the one you do care about (e.g., /).
> 
> Fun to see this again.
> 
> >  - Some applications (Ceph, dpkg) write lots of data to the file system and
> >    then want to make sure it is flushed to disk.  Calling fsync(2) on each
> >    file introduces unnecessary ordering constraints that result in a large
> >    amount of sub-optimal writeback/flush/commit behavior by the file
> >    system.

This would be useful for 9p server in qemu

http://article.gmane.org/gmane.comp.emulators.qemu/95497

> 
> FWIW dpkg uses sync_file_range(2) and only syncs the files it needs to
> nowadays.  Other apps in the same position should probably do the
> same.[1][2]
> 
> > This patch introduces a new system call syncat(2) that mimics the existing 
> > *at() interfaces by taking an fd and/or path.  The fd can be either an 
> > open file descriptor or AT_FDCWD, and the pathname can be either a path or 
> > (unlike the usual *at() style interface) NULL.  Only the file system for 
> > the referenced file is synced.
> 
> Sounds like overengineering.  The openat(2) family of calls are meant
> to add flexibility to familiar calls that perform an operation with a
> path relative to the cwd.  To maintain familiarity, they include some
> complication (AT_FDCWD, taking a relative path, and so on).


With some of the proposed changes for VFS [1] some of the *at calls also allows to
specify "" names. So i guess having syncat is useful because now we can
call sync with either an fd or with a name. 

ie 

syncat(fd, "");
or
syncat(AT_FDCWD, "a");

[1] http://article.gmane.org/gmane.linux.file-systems/50773

> 
> Since sync_one_filesystem(2) is new, why not just take a file or
> directory fd (and perhaps flags for future expansion)?  I can use
> open(".", O_NONBLOCK) to get a file descriptor for the cwd.
> 
> > Is this a reasonable approach?  (Patch below is compile tested only.  :)
> 
> Sounds reasonably sane.
> 
> As for the patch: without the pathname arg it becomes much simpler.
> To my inexpert eyes, aside from that it looks good.
> 

-aneesh
