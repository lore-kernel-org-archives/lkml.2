Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757959Ab0HKCDG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 22:03:06 -0400
Received: from mfbichi12.ns.itscom.net ([219.110.2.190]:41702 "EHLO
	mfbichi12.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754203Ab0HKCDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 22:03:04 -0400
X-Greylist: delayed 621 seconds by postgrey-1.27 at vger.kernel.org; Tue, 10 Aug 2010 22:03:04 EDT
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: Re: [PATCH 14/39] union-mount: Union mounts documentation
To: Neil Brown <neilb@suse.de>
Cc: Valerie Aurora <vaurora@redhat.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Miklos Szeredi <miklos@szeredi.hu>, Jan Blunck <jblunck@suse.de>,
        Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
In-Reply-To: <20100810085641.2b9a714c@notabene>
References: <1281282776-5447-1-git-send-email-vaurora@redhat.com> <1281282776-5447-15-git-send-email-vaurora@redhat.com> <20100810085641.2b9a714c@notabene>
Date: Wed, 11 Aug 2010 10:51:52 +0900
Message-ID: <13447.1281491512@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Neil Brown:
> I wonder if the restriction is not more serious than this.
> Given the prevalence of "copy-up", particularly of directories, I would think
> that even off-line upgrade would not be supported.
> If the upgrade adds a file in a directory that has already been read (and
> hence copied-up), or changes a file that has been chmodded, then the upgrade
> will not be completely visible, which sounds dangerous.
	:::
> I see two block-layer solutions.  The obvious is a COW block device as you
> have mentioned.  I am not convinced that it is as bad as you think.
	:::

DM snapshot provides the COW block feature and it will match your idea
since the size of COW device is much smaller genearally. But it doesn't
support off-line upgrade either. If you do, it is equivalent to corrupt
filesystem for DM snapshot device.

Here is pros/cons of DM snapshot comparing a union.
- the number of bytes to be copied between devices is much smaller.

- the type of filesystem must be one and only.
- the fs must be writable, no readonly fs, even for the lower original
  device. so the compression fs will not be usable. but if we use
  loopback mount, we may address this issue.
  for instance,
	mount /cdrom/squashfs.img /sq
	losetup /sq/ext2.img
	losetup /somewhere/cow
	dmsetup "snapshot /dev/loop0 /dev/loop1 ..."

- it will be difficult (or needs more operations) to extract the
  difference between the original device and COW.

- DM snapshot-merge may help a lot when users try merging. in the
  fs-layer union, users will use rsync(1).

- in fs-based union, users can add/remove members(layer) dynamicall
  without unmounting. of course, all files on the removing layer should
  not be busy.


Also here is my concern about UnionMount. All these issues have been
reported before.
- for users, the inode number may change silently. eg. copy-up.
- link(2) may break by copy-up.
- read(2) may get an obsoleted filedata (fstat(2) too).
- fcntl(F_SETLK) may be broken by copy-up.
- unnecessary copy-up may happen, for example mmap(MAP_PRIVATE) after
  open(O_RDWR).


J. R. Okajima
