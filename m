Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754832Ab1FPCoA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 22:44:00 -0400
Received: from mail08-md.ns.itscom.net ([175.177.155.118]:48842 "EHLO
	mail08-md.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753399Ab1FPCn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 22:43:57 -0400
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: Re: [PATCH 0/7] overlay filesystem: request for inclusion
To: Michal Suchanek <hramrach@centrum.cz>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Valerie Aurora <val@vaaconsulting.com>,
        Andrew Morton <akpm@linux-foundation.org>, NeilBrown <neilb@suse.de>,
        viro@zeniv.linux.org.uk, torvalds@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        apw@canonical.com, nbd@openwrt.org, jordipujolp@gmail.com,
        ezk@fsl.cs.sunysb.edu
In-Reply-To: <BANLkTi=hvBBbZPBj5niUV9StSRRjmLtK8w@mail.gmail.com>
References: <20110609125114.8dff08da.akpm@linux-foundation.org> <BANLkTi=uWDSw96v0Y4W94NZvgD=j=3r3zg@mail.gmail.com> <20110610100143.28037551@lxorguk.ukuu.org.uk> <8739jbjqa7.fsf@tucsk.pomaz.szeredi.hu> <11186.1308148376@jrobl> <87vcw7hz7y.fsf@tucsk.pomaz.szeredi.hu> <15402.1308154495@jrobl> <BANLkTi=hvBBbZPBj5niUV9StSRRjmLtK8w@mail.gmail.com>
Date: Thu, 16 Jun 2011 11:43:46 +0900
Message-ID: <18273.1308192226@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Michal Suchanek:
> This is generally not possible in solutions that don't reserve any filename=
> s.
>
> However, it should be possible to create whiteout of a non-existent
> entry in a directory while it is locked without affecting userspace.

Actually aufs generates a doubly whiteouted unique name dynamically for
the target dir. For instance, when rmdir("dirA") aufs does,
- lock i_mutex of the parent dir of dirA on the real fs
- some verifycations for the parent-child relationship
- some tests whether we can do rmdir
- create whiteout for dirA
- rename dirA to .wh..wh.XXXXXXXX (random value in hex), after making
  sure the name doesn't exist
- unlock the parent dir
- return to VFS
And then the async workqueue removes the .wh..wh.XXXXXXXX dir with some
whiteouts under it.

It means the temporary whiteout name is,
- always unique
- always hidden (from users), even if it remains accidentally
So even if an error happens in the async work, it doesn't matter.

Additionally there is a userspace script called "auchk" which is like
fsck for real fs. auchk script checks the logical consistency on the
(writable) real fs, and removes the illegal whiteouts, remained
pseudo-links, and remained temp files.


> As an alternative way to perform atomic renames I would suggest
> "fallthrough symlinks". If you want to rename an entry which is

Symlink?
Is it a different thing from DCACHE_FALLTHRU in UnionMount?
I am afraid a special symlink is fragile or dangerous.
Its special meaning is valid in inner union world only, is it? If
something in outer world gets changed, we may not follow the symlink
anymore or follow something different unexpectedly. Is it acceptable?


J. R. Okajima
