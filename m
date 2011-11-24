Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754462Ab1KXVOI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 16:14:08 -0500
Received: from cantor2.suse.de ([195.135.220.15]:32814 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754118Ab1KXVOF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 16:14:05 -0500
Date: Thu, 24 Nov 2011 22:14:03 +0100
From: Jan Kara <jack@suse.cz>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: George Spelvin <linux@horizon.com>, jack@suse.cz,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: 3.1-rc10 oops in nameidata_to_filp
Message-ID: <20111124211403.GE29519@quack.suse.cz>
References: <20111124145141.GB22640@quack.suse.cz>
 <20111124164406.22919.qmail@science.horizon.com>
 <20111124173829.GL2203@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111124173829.GL2203@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 24-11-11 17:38:29, Al Viro wrote:
> On Thu, Nov 24, 2011 at 11:44:06AM -0500, George Spelvin wrote:
> 
> > It turned out the machine was quite recoverable and I've been running it without rebooting since then.
> > This includes several suspends to RAM and one to disk.
> > 
> > So far, it seems pretty reproducible, but I suppose it could be a kernel bit flip.
> > (F***ing Intel not even *allowing* ECC in "consumer" chipsets...)
> > 
> > I should probably add a debugging patch and reboot.  Is there a debugging helper
> > for printing a dentry and vfsmount?
> 
> d_path(); takes struct path *, pointer to buffer and buffer length, puts
> the pathname into the end of buffer and returns a pointer to the beginning
> of resulting string.
> 
> I'd add (hell, maybe start with) printing this:
> 	file->f_path.dentry->d_inode
> 	inode
> 	file->f_mapping
> 	inode->i_mapping
> 	inode->i_mapping->host
> just to see whether it's open() callback resetting ->f_mapping to NULL or
> weird inode->i_mapping->host.  All in case file->f_mapping->host == NULL
> just before the spot where it oopses.
> 
> Getting pathname would be something like
> 	static char name[4096];
> 	struct path path = {.mnt = mnt, .dentry = dentry};
> 	char *p = d_path(&path, name, 4096);
> 	if (IS_ERR(p))
> 		printk("[%d]", PTR_ERR(p));
> 	else
> 		printk("'%s'", p);
> conditional on the same test.  
> 
> Said that, I'm not buying the theory of open assigning to ->f_mapping and
> screwing it up; all such assignments end up with ->i_mapping of *some*
> inode, as far as I can see from cursory grep over the tree.
  Yeah, after some thought and grepping, setting ->f_mapping to something
bogus does not seem likely. More likely is that i_mapping got somehow
corrupted (use after free?) or something like that.

> Just in case: do you have CONFIG_FS_POSIX_ACL set?

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
