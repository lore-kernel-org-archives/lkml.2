Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755670Ab1CCHWe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 02:22:34 -0500
Received: from mail-gw0-f51.google.com ([74.125.83.51]:56320 "EHLO
	mail-gw0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404Ab1CCHWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 02:22:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=LnyHovK5wZ3nHQyEDPwiD3H89fRh3j7XLqFTRNyDj1CKQiQY3FT0LaMvsle/taEIxp
         2gXB93Gkm6aIimh8gkyff1LeU9ZDvxRvN6fzEv8dEHOe6INOv3W/gsfdHRr4Qg1O7ihw
         MSJVFYICRLI0clOxSqa2blM3mbC/KsThJdNwA=
Date: Thu, 3 Mar 2011 01:22:24 -0600
From: Jonathan Nieder <jrnieder@gmail.com>
To: Sage Weil <sage@newdream.net>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, linux-api@vger.kernel.org
Subject: Re: [RFC] introduce sys_syncat to sync a single file system
Message-ID: <20110303072223.GA28133@elie>
References: <Pine.LNX.4.64.1102171035220.13904@cobra.newdream.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1102171035220.13904@cobra.newdream.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Sage Weil wrote:

>  - On machines with many of mounts, it is not at all uncommon for some of
>    them to hang (e.g. unresponsive NFS server).  sync(2) will get stuck on
>    those and may never get to the one you do care about (e.g., /).

Fun to see this again.

>  - Some applications (Ceph, dpkg) write lots of data to the file system and
>    then want to make sure it is flushed to disk.  Calling fsync(2) on each
>    file introduces unnecessary ordering constraints that result in a large
>    amount of sub-optimal writeback/flush/commit behavior by the file
>    system.

FWIW dpkg uses sync_file_range(2) and only syncs the files it needs to
nowadays.  Other apps in the same position should probably do the
same.[1][2]

> This patch introduces a new system call syncat(2) that mimics the existing 
> *at() interfaces by taking an fd and/or path.  The fd can be either an 
> open file descriptor or AT_FDCWD, and the pathname can be either a path or 
> (unlike the usual *at() style interface) NULL.  Only the file system for 
> the referenced file is synced.

Sounds like overengineering.  The openat(2) family of calls are meant
to add flexibility to familiar calls that perform an operation with a
path relative to the cwd.  To maintain familiarity, they include some
complication (AT_FDCWD, taking a relative path, and so on).

Since sync_one_filesystem(2) is new, why not just take a file or
directory fd (and perhaps flags for future expansion)?  I can use
open(".", O_NONBLOCK) to get a file descriptor for the cwd.

> Is this a reasonable approach?  (Patch below is compile tested only.  :)

Sounds reasonably sane.

As for the patch: without the pathname arg it becomes much simpler.
To my inexpert eyes, aside from that it looks good.

Thanks,
Jonathan

[1] http://thread.gmane.org/gmane.comp.file-systems.ext4/22190
[2] http://lists.debian.org/debian-dpkg/2010/11/threads.html#00075
