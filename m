Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755460Ab1FOOdF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 10:33:05 -0400
Received: from mail03-md.ns.itscom.net ([175.177.155.113]:43037 "EHLO
	mail03-md.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754790Ab1FOOdC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 10:33:02 -0400
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: Re: [PATCH 0/7] overlay filesystem: request for inclusion
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Valerie Aurora <val@vaaconsulting.com>,
        Andrew Morton <akpm@linux-foundation.org>, NeilBrown <neilb@suse.de>,
        viro@ZenIV.linux.org.uk, torvalds@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        apw@canonical.com, nbd@openwrt.org, hramrach@centrum.cz,
        jordipujolp@gmail.com, ezk@fsl.cs.sunysb.edu
In-Reply-To: <8739jbjqa7.fsf@tucsk.pomaz.szeredi.hu>
References: <20110609125114.8dff08da.akpm@linux-foundation.org> <BANLkTi=uWDSw96v0Y4W94NZvgD=j=3r3zg@mail.gmail.com> <20110610100143.28037551@lxorguk.ukuu.org.uk> <8739jbjqa7.fsf@tucsk.pomaz.szeredi.hu>
Date: Wed, 15 Jun 2011 23:32:56 +0900
Message-ID: <11186.1308148376@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Miklos Szeredi:
> For example "rmdir /ovl/a/b" will do the following:
>
>   1. find the underlying dentry for "a" -> upper-a
>   2. lock upper-a
>   3. find the underlying dentry for "b" -> upper-b
>   4. verify that upper-b is a child of upper-a
>   5. remove upper-b

It is good to verify in step 4.
Essentially (or ideally) this verification should be equivalent to all
of what VFS does before vfs_rmdir(). I know overlayfs makes the upper
mnt_want_write()-ed in early stage and keeps it. So it might be better
to lookup again (as step 3 and 4) instead of comparing d_parent
simply. If you think it is unnecessary to lookup here, then I'd suggest
you to make it option (choosable by user).

I see ovl_rmdir() does,
- lookup and unlink all whiteouts
- rmdir the target dir
- create a whiteout for the target
Right?
But I am afraid that any error can happen in every step on the upper
dir. And if it happens, then ovl_rmdir() returns the error but the dir
left in incomplete status. It may be one of these.
- some whiteouts are unlinked but others are left
- all whiteouts are gone but the target dir remains
- the target dir is removed but the whiteout is not created
Of course, it is bad and makes users really confused, since it will show
users things which should not be. At the same time, I don't know how
possible it can happen.

Anyway if you have read aufs, then you would know how aufs solves these
problems. I don't think the approaches in aufs is best or one and
only. I just could not get another good idea.


J. R. Okajima
