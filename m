Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755609Ab2JPWyP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 18:54:15 -0400
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:32001 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754728Ab2JPWyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 18:54:14 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjceANfkfVB5LJyt/2dsb2JhbABFhSi1CIRkAn+BCYIgAQEEATocIwULCAMYLhQlAyETh34FuysUizuBfoNiYAOVapAzgwE
Date: Wed, 17 Oct 2012 09:54:10 +1100
From: Dave Chinner <david@fromorbit.com>
To: Jaegeuk Kim <jaegeuk.kim@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Jaegeuk Kim <jaegeuk.kim@samsung.com>,
        "'Vyacheslav Dubeyko'" <slava@dubeyko.com>, viro@zeniv.linux.org.uk,
        "'Theodore Ts'o'" <tytso@mit.edu>, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, chur.lee@samsung.com,
        cm224.lee@samsung.com, jooyoung.hwang@samsung.com
Subject: Re: [PATCH 11/16] f2fs: add inode operations for special inodes
Message-ID: <20121016225410.GA26797@dastard>
References: <001201cda2f1$633db960$29b92c20$%kim@samsung.com>
 <20121015223409.GE2739@dastard>
 <015901cdab42$06deac20$149c0460$%kim@samsung.com>
 <201210161138.35388.arnd@arndb.de>
 <20121016204412.GF2864@dastard>
 <1350426621.1958.119.camel@kjgkr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350426621.1958.119.camel@kjgkr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 17, 2012 at 07:30:21AM +0900, Jaegeuk Kim wrote:
> > > > OTOH, I think xattr itself is for users, not for communicating
> > > > between file system and users.
> > > 
> > > No, you are mistaken in that point, as Dave explained.
> > 
> > e.g. selinux, IMA, ACLs, capabilities, etc all communicate
> > information that the kernel uses for access control. That's why
> > xattrs have different namespaces like "system", "security" and
> > "user". Only user attributes are truly for user data
> > - the rest are for communicating information to the kernel....
> > 
> 
> I agree that "system" is used by kernel.
> How about the file system view?

Not sure what you mean - the filesystem woul dsimply read the xattrs
in the system namespace as it needs, just like the other subsystems
like selinux or IMA do.

> Would you explain what file systems retrieve xattrs and use
> them with their own purpose?

I think cachefs users a "CacheFiles.cache" namespace for storing
information it needs in xattrs. ecryptfs stores crypto metadata in
xattrs in the lower filesytem. NFSv4 servers store junction mount
information in xattrs.

So there are examples where filesystems use xattrs for special
information. However, in most cases filesystems don't need xattrs
for their own metadata primarily because that gets added to their
own on-disk formats. IThe above are all "overlay" style filesystems
that don't have their own on-disk formats, so need to use xattrs to
store their per-inode metadata.

The case of access hints and allocation policies are not somethign
that are native to any filesystem on-disk format. They are abstract
concepts that really only the software generating/using that
information knows about. Given we want the software that uses this
information to be in VFS, it is separate from every filesystem and
this is exactly the use case that system xattrs were intended for.
:)

> Sorry, I'm not familiar with xattrs in depth.
> 
> Unfortunately, "system" is not implemented in f2fs yet. :(

If you've already implemented the user.* namespace, then it's
trivial to support the other namespaces - it's just prefixing the
xattrs with the appropriate string instead of "user"....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
