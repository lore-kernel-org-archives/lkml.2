Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751181Ab2IWET0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2012 00:19:26 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:36445 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878Ab2IWETZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2012 00:19:25 -0400
Date: Sun, 23 Sep 2012 05:19:06 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        containers@lists.linux-foundation.org,
        Dave Hansen <haveblue@us.ibm.com>, linux-kernel@vger.kernel.org,
        Andy Whitcroft <apw@canonical.com>, sukadev@linux.vnet.ibm.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Serge Hallyn <serge.hallyn@canonical.com>
Subject: Re: [PATCH 3/4] devpts: Make the newinstance option historical
Message-ID: <20120923041906.GM13973@ZenIV.linux.org.uk>
References: <CA+55aFzwOU137V6wtyBjessx05NJo2G4KV0rvTKWvC79A+o9iQ@mail.gmail.com>
 <20120124010758.GJ23916@ZenIV.linux.org.uk>
 <m1k44gj1cu.fsf@fess.ebiederm.org>
 <20120124220247.GA26353@hallyn.com>
 <CAPXgP13_gczQmG_USAp0p2AuTfxkzAvzHvjbZY_rbbLH-4rDyg@mail.gmail.com>
 <20120124231601.GA4470@sergelap>
 <CAPXgP12REAwmDORzdGJhsxZKU8nhiauCxoVdKa8Eifw4MWWtgA@mail.gmail.com>
 <20120128195103.GA11299@sergelap>
 <87txup763i.fsf_-_@xmission.com>
 <87d31d75yj.fsf_-_@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87d31d75yj.fsf_-_@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 22, 2012 at 08:50:44PM -0700, Eric W. Biederman wrote:

> +struct inode *devpts_redirect(struct file *filp)
> +{
> +	struct inode *inode;
> +	struct file *filp2;
> +
> +	/* Is the inode already a devpts inode? */
> +	inode = filp->f_dentry->d_inode;
> +	if (filp->f_dentry->d_sb->s_magic == DEVPTS_SUPER_MAGIC)
> +		goto out;
> +
> +	/* Is f_dentry->d_parent usable? */
> +	inode = ERR_PTR(-ENODEV);
> +	if (filp->f_vfsmnt->mnt_root == filp->f_dentry)
> +		goto out;
> +
> +	/* Is there a devpts inode we can use instead? */
> +	
> +	filp2 = file_open_root(filp->f_dentry->d_parent, filp->f_vfsmnt,
> +			       "pts/ptmx", O_PATH);
> +	if (!IS_ERR(filp2)) {
> +		if (filp2->f_dentry->d_sb->s_magic == DEVPTS_SUPER_MAGIC) {
> +			struct path old;
> +			old = filp->f_path;
> +			filp->f_path = filp2->f_path;
> +			inode = filp->f_dentry->d_inode;
> +			path_get(&filp->f_path);
> +			path_put(&old);

You are welcome to supply an analysis of the reasons why ->open() pulling
such tricks will not break all kinds of code in VFS.
> +		}
> +		fput(filp2);

... starting with "what happens when some joker binds /dev/ptmx on
/dev/pts/ptmx"

NAK.  This violates asserts made by VFS (namely, that ->f_path is not
changed since dentry_open() has set it and until __fput() rips the thing
out) *and* by your own code (attack mentioned above, just from looking
at it for a minute).  Far too brittle...
