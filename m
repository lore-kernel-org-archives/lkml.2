Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758780Ab2HQSVI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 14:21:08 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:53323 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758728Ab2HQSVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 14:21:04 -0400
Date: Fri, 17 Aug 2012 19:20:51 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, hch@infradead.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        apw@canonical.com, nbd@openwrt.org, neilb@suse.de, hramrach@centrum.cz,
        jordipujolp@gmail.com, ezk@fsl.cs.sunysb.edu, ricwheeler@gmail.com,
        dhowells@redhat.com, hpj@urpla.net, sedat.dilek@googlemail.com,
        penberg@kernel.org, goran.cetusic@gmail.com, romain@orebokech.com,
        mszeredi@suse.cz
Message-ID: <20120817182051.GC29217@decadent.org.uk>
References: <1345045700-9062-1-git-send-email-miklos@szeredi.hu>
 <1345045700-9062-6-git-send-email-miklos@szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345045700-9062-6-git-send-email-miklos@szeredi.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: Re: [PATCH 05/13] overlayfs: add statfs support
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 15, 2012 at 05:48:12PM +0200, Miklos Szeredi wrote:
> From: Andy Whitcroft <apw@canonical.com>
> 
> Add support for statfs to the overlayfs filesystem.  As the upper layer
> is the target of all write operations assume that the space in that
> filesystem is the space in the overlayfs.  There will be some inaccuracy as
> overwriting a file will copy it up and consume space we were not expecting,
> but it is better than nothing.
> 
> Use the upper layer dentry and mount from the overlayfs root inode,
> passing the statfs call to that filesystem.
[...] 
> +/**
> + * ovl_statfs
> + * @sb: The overlayfs super block
> + * @buf: The struct kstatfs to fill in with stats
> + *
> + * Get the filesystem statistics.  As writes always target the upper layer
> + * filesystem pass the statfs to the same filesystem.
> + */
> +static int ovl_statfs(struct dentry *dentry, struct kstatfs *buf)
> +{
> +	struct dentry *root_dentry = dentry->d_sb->s_root;
> +	struct path path;
> +	ovl_path_upper(root_dentry, &path);
> +
> +	if (!path.dentry->d_sb->s_op->statfs)
> +		return -ENOSYS;
> +	return path.dentry->d_sb->s_op->statfs(path.dentry, buf);
> +}
[...]

In case f_namelen differs between the upper and lower filesystems, you
need to return the greater of the two.

Should f_type be overridden to indicate overlayfs?  I'm not sure what
userland is likely to do with f_type.  (For presentation to the user,
it should get the mount type name with getmntent() or libmount.  And
that will just work.)

Ben.

-- 
Ben Hutchings
We get into the habit of living before acquiring the habit of thinking.
                                                              - Albert Camus
