Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753148Ab0JTMqe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 08:46:34 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:35897 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179Ab0JTMqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 08:46:32 -0400
Date: Wed, 20 Oct 2010 13:46:31 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: npiggin@kernel.dk
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [patch 19/35] fs: icache remove redundant i_sb_list umount
 locking
Message-ID: <20101020124631.GA24394@ZenIV.linux.org.uk>
References: <20101019034216.319085068@kernel.dk>
 <20101019034657.476923711@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101019034657.476923711@kernel.dk>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 19, 2010 at 02:42:35PM +1100, npiggin@kernel.dk wrote:
> +	/*
> +	 * We can walk the per-sb list of inodes here without worrying about
> +	 * its consistency, because the list must not change during umount
> +	 * anymore, and because iprune_sem keeps shrink_icache_memory() away.
> +	 */
>  	fsnotify_unmount_inodes(&sb->s_inodes);

OK, explain to me why is that safe.  Note that fsnotify_destroy_mark()
_can_ race with umount, dropping the last reference to inode before
fsnotify_unmount_inodes() would get to it and kill it (along with the mark).
With the current code it's just fine - we walk the list under lock and
iput() won't mess with that list until it acquires the damn lock.  And
no matter who gets there first, the mark will be destroyed and reference
to inode will be dropped.

With your change, AFAICS, removal from the list can happen while we walk
it.  With obvious results.
