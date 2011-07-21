Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752455Ab1GUUk5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 16:40:57 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:57826 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769Ab1GUUky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 16:40:54 -0400
Date: Thu, 21 Jul 2011 21:40:42 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Christoph Hellwig <hch@infradead.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Andi Kleen <andi@firstfloor.org>, Matthew Wilcox <matthew@wil.cx>,
        Anton Blanchard <anton@samba.org>, npiggin@kernel.dk,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [Patch] VFS : mount lock scalability for files systems without
 mount point   (WAS vfsmount lock issues on very large ppc64 box)
Message-ID: <20110721204042.GB31405@ZenIV.linux.org.uk>
References: <20110717105027.53cc3ca4@kryten>
 <20110717010427.GC5359@parisc-linux.org>
 <20110717084630.GC8006@one.firstfloor.org>
 <1310977028.5756.1.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
 <20110718154008.GA29593@infradead.org>
 <20110718155141.GA11013@ZenIV.linux.org.uk>
 <1311093158.2707.75.camel@schen9-DESK>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311093158.2707.75.camel@schen9-DESK>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 19, 2011 at 09:32:38AM -0700, Tim Chen wrote:
> @@ -1193,6 +1193,7 @@ static void __exit cleanup_mtdchar(void)
>  {
>  	unregister_mtd_user(&mtdchar_notifier);
>  	mntput(mtd_inode_mnt);
> +	kern_unmount(mtd_inode_mnt);

Surely you want to merge that mntput() in there...

> +void kern_unmount(struct vfsmount *mnt)
> +{
> +	/* release long term mount so mount point can be released */
> +	if (!IS_ERR_OR_NULL(mnt)) {
> +		mnt_make_shortterm(mnt);
> +		mntput();
> +	}
> +}

... and if you pass it the argument, it'll be much happier.
