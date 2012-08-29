Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754624Ab2H2WrE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 18:47:04 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:38745 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753350Ab2H2WrC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 18:47:02 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, hch@infradead.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        apw@canonical.com, nbd@openwrt.org, neilb@suse.de, hramrach@centrum.cz,
        jordipujolp@gmail.com, ezk@fsl.cs.sunysb.edu, ricwheeler@gmail.com,
        dhowells@redhat.com, hpj@urpla.net, sedat.dilek@googlemail.com,
        penberg@kernel.org, goran.cetusic@gmail.com, romain@orebokech.com
Subject: Re: [PATCH 05/13] overlayfs: add statfs support
References: <1345045700-9062-1-git-send-email-miklos@szeredi.hu>
	<1345045700-9062-6-git-send-email-miklos@szeredi.hu>
	<20120817182051.GC29217@decadent.org.uk>
Date: Thu, 30 Aug 2012 00:48:28 +0200
In-Reply-To: <20120817182051.GC29217@decadent.org.uk> (Ben Hutchings's message
	of "Fri, 17 Aug 2012 19:20:51 +0100")
Message-ID: <87d32971s3.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben Hutchings <ben@decadent.org.uk> writes:

> On Wed, Aug 15, 2012 at 05:48:12PM +0200, Miklos Szeredi wrote:
>> From: Andy Whitcroft <apw@canonical.com>
>> 
>> Add support for statfs to the overlayfs filesystem.  As the upper layer
>> is the target of all write operations assume that the space in that
>> filesystem is the space in the overlayfs.  There will be some inaccuracy as
>> overwriting a file will copy it up and consume space we were not expecting,
>> but it is better than nothing.
>> 
>> Use the upper layer dentry and mount from the overlayfs root inode,
>> passing the statfs call to that filesystem.
> [...] 
>> +/**
>> + * ovl_statfs
>> + * @sb: The overlayfs super block
>> + * @buf: The struct kstatfs to fill in with stats
>> + *
>> + * Get the filesystem statistics.  As writes always target the upper layer
>> + * filesystem pass the statfs to the same filesystem.
>> + */
>> +static int ovl_statfs(struct dentry *dentry, struct kstatfs *buf)
>> +{
>> +	struct dentry *root_dentry = dentry->d_sb->s_root;
>> +	struct path path;
>> +	ovl_path_upper(root_dentry, &path);
>> +
>> +	if (!path.dentry->d_sb->s_op->statfs)
>> +		return -ENOSYS;
>> +	return path.dentry->d_sb->s_op->statfs(path.dentry, buf);
>> +}
> [...]
>
> In case f_namelen differs between the upper and lower filesystems, you
> need to return the greater of the two.

Maybe.  I've never seen any app use f_namelen for anything useful.

>
> Should f_type be overridden to indicate overlayfs?  I'm not sure what
> userland is likely to do with f_type.  (For presentation to the user,
> it should get the mount type name with getmntent() or libmount.  And
> that will just work.)

Yeah we could do that.

Thanks,
Miklos
