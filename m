Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751222Ab0HSBfu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 21:35:50 -0400
Received: from mtoichi13.ns.itscom.net ([219.110.2.183]:58034 "EHLO
	mtoichi13.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973Ab0HSBfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 21:35:48 -0400
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: Re: [PATCH 14/39] union-mount: Union mounts documentation
To: Valerie Aurora <vaurora@redhat.com>
Cc: Neil Brown <neilb@suse.de>, Alexander Viro <viro@zeniv.linux.org.uk>,
        Miklos Szeredi <miklos@szeredi.hu>, Jan Blunck <jblunck@suse.de>,
        Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
In-Reply-To: <20100818185542.GA10850@shell>
References: <1281282776-5447-1-git-send-email-vaurora@redhat.com> <1281282776-5447-15-git-send-email-vaurora@redhat.com> <20100810085641.2b9a714c@notabene> <20100817204430.GE5556@shell> <6820.1282094632@jrobl> <20100818185542.GA10850@shell>
Date: Thu, 19 Aug 2010 10:34:59 +0900
Message-ID: <16318.1282181699@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Valerie Aurora:
> According Al Viro, unionfs has some fundamental architectural problems
> that prevents it from being correct and leads to crashes:
>
> http://lkml.indiana.edu/hypermail/linux/kernel/0802.0/0839.html
>
> The main question for me is whether aufs has fixed these problems.  If
> it hasn't, then it can't be bug-free.

Although I don't understand fully your question, aufs actually verifies
the parent-child relationship after lock_rename() on the writable layer.
Such verification is done in other operations too.
And aufs provides three options to specify the level of
verification. When the highest (most strict) level is given, aufs_rename
lookup again after lock_rename() and compares the got parent and the
given (cached) parent.
Does this answer your question correctly?


> Think about the case of two different RPM package database files.  One
> contains the info from newly installed packages on the top layer file
> system.  The lower layer contains info from packages newly installed
> on the lower file system.  You don't want either file; you want the
> merged packaged database showing the info for all packages installed
> on both layers.  Any practical file system based system is only going
> to be able to pick one file or the other, and it's going to be wrong
> in some cases.

Let me make sure.
Do you mean something like this?
- a user makes a union
- fileA exists on the lower layer but upper
- modify fileA in the union
  --> the file is copied-up and updated on the upper layer.
- modify fileA on the lower layer directly (by-passing union)
  --> the file on the lower is updated.
- and the user will not see the uptodate fileA in the union, lack of the
  modification made on the lower directly.

Then I'd say it is an expected behaviour. Simply the upper file hides
the lower.

While UnionMount takes a block device as a parameter of making a union
operaion, aufs takes a directory.
# mount /dev/sda /u
# mount -o union /dev/sdb /u

# mount /dev/sda /ro
# mount /dev/sdb /rw
# mount -t aufs -o br:/rw:/ro none /u

It means sda is hidden in UnionMount (generally) and users cannot access
it directly. But in aufs, it is possible via /ro. For those who wants to
hide /ro and stop accessing it directly, aufs document suggests mounting
another thing onto /ro. It can be an empty directly if you use "mount -o
bind".


J. R. Okajima
