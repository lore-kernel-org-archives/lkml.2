Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751501Ab1GOMc4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 08:32:56 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:61123 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810Ab1GOMcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 08:32:55 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Cc: Andrew Morton <akpm@linux-foundation.org>, NeilBrown <neilb@suse.de>,
        viro@ZenIV.linux.org.uk, torvalds@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        apw@canonical.com, nbd@openwrt.org, hramrach@centrum.cz,
        jordipujolp@gmail.com, ezk@fsl.cs.sunysb.edu
Subject: Re: [PATCH 0/7] overlay filesystem: request for inclusion
References: <1306932380-10280-1-git-send-email-miklos@szeredi.hu>
	<20110608153208.dc705cda.akpm@linux-foundation.org>
	<20110609115934.3c53f78f@notabene.brown>
	<20110608205233.ebfedc4d.akpm@linux-foundation.org>
	<87wrgvb28a.fsf@tucsk.pomaz.szeredi.hu>
	<20110609123843.77153b27.akpm@linux-foundation.org>
	<877h8uzmsi.fsf@tucsk.pomaz.szeredi.hu> <21324.1307677721@jrobl>
	<871uyxa7ol.fsf@tucsk.pomaz.szeredi.hu>
	<8739ig3k93.fsf@tucsk.pomaz.szeredi.hu> <8536.1310214135@jrobl>
Date: Fri, 15 Jul 2011 14:33:51 +0200
In-Reply-To: <8536.1310214135@jrobl> (J. R. Okajima's message of "Sat, 09 Jul
	2011 21:22:15 +0900")
Message-ID: <87k4bjd8pc.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"J. R. Okajima" <hooanon05@yahoo.co.jp> writes:

> Miklos Szeredi:
>> Here's a patch to document these limitations.
>
> If you want covering limitations as possible, I'd suggest you to add
> these.
> - Some versions of GNU find(1) may produce a warning about the link
>   count of a directory. When a sub dir exists, find(1) expects it
>   increments the link count of the parent dir.

st_nlink==1 for directories is widely accepted way of saying that the
number of subdirectories is unknown.  Various filesystems already do
this, and versions of GNU utils that I have come across accept it.

> - If I remember correctly, Valerie Aurora has pointed out that
>   open(O_RDONLY) + fchmod() will work correctly in UnionMount.
>   It is true in overlayfs too?

Neither union-mounts nor overlayfs can handle this case.

I hadn't thought about this case, so overlayfs would modify the lower
filesystem in that case, which is a no-no.

Following patch fixes this and return -EROFS for the above case.  I also
updated the non-standard section in the docs.

Thanks,
Miklos
----

Subject: ovl: make lower mount read-only

From: Miklos Szeredi <mszeredi@suse.cz>

If a file only existing on the lower fs is operned for O_RDONLY and
fchmod/fchown/etc is performed on the open file then this will modify
the lower fs, which is not what we want.

Copying up at this point is not possible.  The best solution is to
return an error for this corner case and hope applications are not
relying on it.

Reported-by: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/overlayfs/super.c |    6 ++++++
 1 file changed, 6 insertions(+)

Index: linux-2.6/fs/overlayfs/super.c
===================================================================
--- linux-2.6.orig/fs/overlayfs/super.c	2011-07-15 12:48:03.000000000 +0200
+++ linux-2.6/fs/overlayfs/super.c	2011-07-15 13:47:35.000000000 +0200
@@ -569,6 +569,12 @@ static int ovl_fill_super(struct super_b
 		goto out_put_upper_mnt;
 	}
 
+	/*
+	 * Make lower_mnt R/O.  That way fchmod/fchown on lower file
+	 * will fail instead of modifying lower fs.
+	 */
+	ufs->lower_mnt->mnt_flags |= MNT_READONLY;
+
 	/* If the upper fs is r/o, we mark overlayfs r/o too */
 	if (ufs->upper_mnt->mnt_sb->s_flags & MS_RDONLY)
 		sb->s_flags |= MS_RDONLY;
