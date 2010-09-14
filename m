Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755446Ab0INUkT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 16:40:19 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:53349 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753458Ab0INUkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 16:40:18 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] Remove BKL from fs/locks.c
Date: Tue, 14 Sep 2010 22:39:02 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc3+; KDE/4.5.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Matthew Wilcox <willy@linux.intel.com>, Christoph Hellwig <hch@lst.de>,
        Trond Myklebust <trond.myklebust@fys.uio.no>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Miklos Szeredi <mszeredi@suse.cz>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, John Kacur <jkacur@redhat.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
References: <201009142206.54130.arnd@arndb.de> <AANLkTimzFDdWbr2gtfmJmfGJVnyURcpvwnGf334ZHVYc@mail.gmail.com>
In-Reply-To: <AANLkTimzFDdWbr2gtfmJmfGJVnyURcpvwnGf334ZHVYc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009142239.02904.arnd@arndb.de>
X-Provags-ID: V02:K0:5wrrFacVI+npgStnLANVT+YF8xqZKTg3MHeTmFdyp2o
 1+cuD7u90p29wIi//JSZYQxWmBJxHRC60wvtM2zcVcZnafvhUG
 8mr+mDZvrS0QykUqthukYvsZ8E0eFN8hk7yC1Ug5yVXSCiLiTx
 ck46j6vHWT5pG5FSFzf0xNqz2ebWoYEEPC+T9pz74qWOQaymt4
 rdPOwFTVjOP5WhnXZmkFQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 14 September 2010 22:20:22 Linus Torvalds wrote:
> End result: anybody who uses the old exports will just not link at
> all, and all in-kernel users (ie lockd etc) will now very explicitly
> have that xyz_bkl() use.
> 
> After that one release, we can re-introduce the old names without the
> bkl, and let filesystems and other subsystems just decide that they
> don't want the bkl version one by one. So that first phase would be
> basically a no-op with an interface rename just so that the rest could
> then be done piece-meal.

Hmm, maybe I'm misunderstanding part of that plan, but I think it
won't work because the BKL in there seems to protect all struct file_lock
instances and they are passed around to other code, most importantly
lockd. The file_locks themselves can be accessed both using sys_flock()
etc locally and using afs/nfs/coda/... exported file systems from other
systems.

AFAICT we could end up with lockd changing data under BKL while a sys_flock()
accesses the same data under file_lock_lock, with no mutual exclusion
between the two.

	Arnd
