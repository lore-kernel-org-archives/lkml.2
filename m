Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752760Ab1GWNY3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jul 2011 09:24:29 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:40075
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752535Ab1GWNYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jul 2011 09:24:24 -0400
Date: Sat, 23 Jul 2011 09:24:11 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Christoph Hellwig <hch@infradead.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Andi Kleen <andi@firstfloor.org>, Matthew Wilcox <matthew@wil.cx>,
        Anton Blanchard <anton@samba.org>, npiggin@kernel.dk,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [Patch] VFS : mount lock scalability for files systems without
 mount point   (WAS vfsmount lock issues on very large ppc64 box)
Message-ID: <20110723132411.GA22183@infradead.org>
References: <20110717105027.53cc3ca4@kryten>
 <20110717010427.GC5359@parisc-linux.org>
 <20110717084630.GC8006@one.firstfloor.org>
 <1310977028.5756.1.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
 <20110718154008.GA29593@infradead.org>
 <20110718155141.GA11013@ZenIV.linux.org.uk>
 <1311093158.2707.75.camel@schen9-DESK>
 <20110721204042.GB31405@ZenIV.linux.org.uk>
 <1311294452.2576.18.camel@schen9-DESK>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311294452.2576.18.camel@schen9-DESK>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think you actually want this done in kern_mount_data, as both
ipc and proc want long-term references as well.  I also suspect with
additional creep of container awareness more internal mounts will switch
to kern_mount_data.  Al, what do you think about simply passing the
private data argument to kern_mount and kill kern_mount_data?  It's not
like the additional argument is going to cause us any pain.


> +struct vfsmount *kern_mount(struct file_system_type *type)
> +{
> +	struct vfsmount *mnt;
> +
> +	mnt = kern_mount_data(type, NULL);
> +	if (!IS_ERR(mnt)) {
> +		/* it is a longterm mount, don't release mnt until */
> +		/* we unmount before file sys is unregistered */

Please use normal kernel comment style, e.g.

	/*
	 * This is a longterm mount, don't release mnt until we umount
	 * it just before unregister_filesystem().
	 */
	
Adding proper kerneldoc comments for the kern_mount/umount function that
explain things in more detail would also be nice.

