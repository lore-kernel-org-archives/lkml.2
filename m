Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753931Ab1CJTjk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 14:39:40 -0500
Received: from mx2.netapp.com ([216.240.18.37]:62561 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751125Ab1CJTjj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 14:39:39 -0500
X-IronPort-AV: E=Sophos;i="4.62,297,1297065600"; 
   d="scan'208";a="528767803"
Subject: Re: NFS regression in 2.6.37.1 (current stable)
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Dr Andrew John Hughes <ahughes@redhat.com>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, mkl@pengutronix.de
In-Reply-To: <20110310185321.GA22030@rivendell.middle-earth.co.uk>
References: <20110310185321.GA22030@rivendell.middle-earth.co.uk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Organization: NetApp Inc
Date: Thu, 10 Mar 2011 14:39:25 -0500
Message-ID: <1299785965.3075.30.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
X-OriginalArrivalTime: 10 Mar 2011 19:39:27.0747 (UTC) FILETIME=[DE28FD30:01CBDF5A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-03-10 at 18:53 +0000, Dr Andrew John Hughes wrote: 
> [Please CC me on responses as I'm not subscribed]
> 
> Hi,
> 
> I seem to have uncovered a regression in the NFS code between 2.6.37 and 2.6.37.1
> caused by this changeset:
> 
> commit 55ea499d60aefa3d03a77fc8590c26b5881faa92
> Author: Trond Myklebust <Trond.Myklebust@netapp.com>
> Date:   Sat Jan 8 17:45:38 2011 -0500
> NFS: Don't use vm_map_ram() in readdir
> http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.37.y.git;a=commit;h=6650239a4b01077e80d5a4468562756d77afaa59
> 
> With this change applied, copying of files between NFS and non-NFS
> mounts seems to be broken.  The easiest way I've found to replicate
> this myself is to use a VCS to do a clone of a tree on a NFS mount to
> a directory on a non-NFS mount.  I used Mercurial, as I had Mercurial
> trees to hand from work on IcedTea, but I assume doing it with a git
> tree such as the linux tree would also work.  The idea is to do
> something which involves copying over a bunch of directories and
> checking the result is readable.
> 
> $ hg clone $HOME/projects/openjdk/icedtea6-hg
> destination directory: icedtea6-hg
> updating to branch default
> abort:
> data/contrib/templater/hotspot/src/cpu/CPU/vm/bytecodeInterpreter_CPU.inline.hpp.i@16d04ce16287:
> no match found!
> 
> In the above, $HOME is an NFS mount and $PWD is a local reiserfs
> partition.  I initially hit failures doing builds with source on $HOME
> and the build directory on a local reiserfs partition.  In that
> scenario, it would fail as not being able to find files that should
> have been copied over.
> 
> Reverting the changeset fixes the issue.  2.6.37.2 still has the bug.
> I haven't checked 2.6.37.3 yet but I didn't see any NFS changes in there.
> --
> Andrew :)
> 
> Free Java Software Engineer
> Red Hat, Inc. (http://www.redhat.com)

It looks to me as if you are hitting the issue that was fixed in
mainline by commit d1205f87bbb8040c1408bbd9e0a720310b2b0b9b (NFS: NFSv4
readdir loses entries). That commit was labelled as "Cc:
stable@kernel.org" but has still not made it into the 2.6.37 stable
series.

I've attached it below...

Cheers
  Trond

8<-------------------------------------------------------------------
>From d1205f87bbb8040c1408bbd9e0a720310b2b0b9b Mon Sep 17 00:00:00 2001
From: Chuck Lever <chuck.lever@oracle.com>
Date: Fri, 28 Jan 2011 12:41:05 -0500
Subject: [PATCH] NFS: NFSv4 readdir loses entries

On recent 2.6.38-rc kernels, connectathon basic test 6 fails on
NFSv4 mounts of OpenSolaris with something like:

> ./test6: readdir
> ./test6: (/mnt/klimt/matisse.test) didn't read expected 'file.12' dir
entry, pass 0
> ./test6: (/mnt/klimt/matisse.test) didn't read expected 'file.82' dir
entry, pass 0
> ./test6: (/mnt/klimt/matisse.test) didn't read expected 'file.164' dir
entry, pass 0
> ./test6: (/mnt/klimt/matisse.test) Test failed with 3 errors
> basic tests failed
> Tests failed, leaving /mnt/klimt mounted
> [cel@matisse cthon04]$

I narrowed the problem down to nfs4_decode_dirent() reporting that the
decode buffer had overflowed while decoding the entries for those
missing files.

verify_attr_len() assumes both it's pointer arguments reside on the
same page.  When these arguments point to locations on two different
pages, verify_attr_len() can report false errors.  This can happen now
that a large NFSv4 readdir result can span pages.

We have reasonably good checking in nfs4_decode_dirent() anyway, so
it should be safe to simply remove the extra checking.

At a guess, this was introduced by commit 6650239a, "NFS: Don't use
vm_map_ram() in readdir".

Cc: stable@kernel.org [2.6.37]
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
---
fs/nfs/nfs4xdr.c |    3 ---
1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/fs/nfs/nfs4xdr.c b/fs/nfs/nfs4xdr.c
index 009aef9..4e2c168 100644
--- a/fs/nfs/nfs4xdr.c
+++ b/fs/nfs/nfs4xdr.c
@@ -6132,9 +6132,6 @@ int nfs4_decode_dirent(struct xdr_stream *xdr,
struct nfs_entry *entry,
if (entry->fattr->valid & NFS_ATTR_FATTR_TYPE)
entry->d_type = nfs_umode_to_dtype(entry->fattr->mode);

- if (verify_attr_len(xdr, p, len) < 0)
- goto out_overflow;
-
return 0;

out_overflow:
-- 
1.7.4



-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com

