Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758671Ab2EBD5t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 23:57:49 -0400
Received: from mx2.netapp.com ([216.240.18.37]:38654 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755679Ab2EBD5r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 23:57:47 -0400
X-IronPort-AV: E=Sophos;i="4.75,514,1330934400"; 
   d="scan'208";a="644659968"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux NFS mailing list <linux-nfs@vger.kernel.org>,
        "Linux Kernel mailing list" <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Please pull NFS client bugfixes
Thread-Topic: [GIT PULL] Please pull NFS client bugfixes
Thread-Index: AQHNKBexPsmxPhS6uUCVKnX7EVV/Mw==
Date: Wed, 2 May 2012 03:57:27 +0000
Message-ID: <1335931053.4390.2.camel@lade.trondhjem.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.104.60.116]
Content-Type: text/plain; charset="utf-8"
Content-ID: <6E0D7464304CA04B9A109DB909EF413E@tahoe.netapp.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q423vwS4018026

Hi Linus,

Please pull from the signed tag "nfs-for-3.4-4" in the repository at

   git pull git://git.linux-nfs.org/projects/trondmy/linux-nfs.git tags/nfs-for-3.4-4

This will update the following files through the appended changesets.

  Cheers,
    Trond

----
 fs/nfs/blocklayout/blocklayout.c |    4 +-
 fs/nfs/client.c                  |    5 +-
 fs/nfs/idmap.c                   |    4 +
 fs/nfs/internal.h                |    8 +-
 fs/nfs/namespace.c               |   93 +++++++------------------
 fs/nfs/nfs4_fs.h                 |   10 ++-
 fs/nfs/nfs4filelayoutdev.c       |    2 +-
 fs/nfs/nfs4namespace.c           |   86 +++++++++++++++++++++--
 fs/nfs/nfs4proc.c                |  142 +++++++++++++++++++++++++++----------
 fs/nfs/nfs4xdr.c                 |   44 ++++++++----
 fs/nfs/objlayout/objlayout.c     |    2 -
 fs/nfs/pnfs.c                    |    2 +-
 fs/nfs/super.c                   |    4 +-
 net/sunrpc/clnt.c                |   50 ++++++++++---
 net/sunrpc/rpc_pipe.c            |    3 +-
 15 files changed, 308 insertions(+), 151 deletions(-)

commit 3617e5031b3acec04efaa36566a8111ac8f07325
Author: Trond Myklebust <Trond.Myklebust@netapp.com>
Date:   Mon Apr 30 12:04:58 2012 -0400

    NFSv4.1: Use the correct hostname in the client identifier string
    
    We need to use the hostname of the process that created the nfs_client.
    That hostname is now stored in the rpc_client->cl_nodename.
    
    Also remove the utsname()->domainname component. There is no reason
    to include the NIS/YP domainname in a client identifier string.
    
    Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>

commit cbbb34498f8b2b26cbdc79532c8a2ee5cd1e756a
Author: Trond Myklebust <Trond.Myklebust@netapp.com>
Date:   Mon Apr 30 11:52:40 2012 -0400

    SUNRPC: RPC client must use the current utsname hostname string
    
    Now that the rpc client is namespace aware, it needs to use the
    utsname of the process that created it instead of using the
    init_utsname. Both rpc_new_client and rpc_clone_client need to
    be fixed.
    
    Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
    Cc: Stanislav Kinsbursky <skinsbursky@parallels.com>

commit 71dfc5fa5160bb73752f0731539404569a77faca
Author: Stanislav Kinsbursky <skinsbursky@parallels.com>
Date:   Sat Apr 28 19:32:21 2012 +0400

    NFS: get module in idmap PipeFS notifier callback
    
    This is bug fix.
    Notifier callback is called from SUNRPC module. So before dereferencing NFS
    module we have to make sure, that it's alive.
    
    Signed-off-by: Stanislav Kinsbursky <skinsbursky@parallels.com>
    Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>

commit e245d4250d0326cfcf7c816a2081b6ab2ea810be
Author: Bryan Schumaker <bjschuma@netapp.com>
Date:   Fri Apr 27 13:27:43 2012 -0400

    NFS: Remove unused function nfs_lookup_with_sec()
    
    This fixes a compiler warning.
    
    Signed-off-by: Bryan Schumaker <bjschuma@netapp.com>
    Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>

commit 7e6eb683d260d9325f0d1bd911518d5ed3cb4f0c
Author: Bryan Schumaker <bjschuma@netapp.com>
Date:   Fri Apr 27 13:27:42 2012 -0400

    NFS: Honor the authflavor set in the clone mount data
    
    The authflavor is set in an nfs_clone_mount structure and passed to the
    xdev_mount() functions where it was promptly ignored.  Instead, use it
    to initialize an rpc_clnt for the cloned server.
    
    Signed-off-by: Bryan Schumaker <bjschuma@netapp.com>
    Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>

commit f05d147f7e3cf0d86b3a4bd5603029a7cb109633
Author: Bryan Schumaker <bjschuma@netapp.com>
Date:   Fri Apr 27 13:27:41 2012 -0400

    NFS: Fix following referral mount points with different security
    
    I create a new proc_lookup_mountpoint() to use when submounting an NFS
    v4 share.  This function returns an rpc_clnt to use for performing an
    fs_locations() call on a referral's mountpoint.
    
    Signed-off-by: Bryan Schumaker <bjschuma@netapp.com>
    Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>

commit 72de53ec4bca39c26709122a8f78bfefe7b6bca4
Author: Bryan Schumaker <bjschuma@netapp.com>
Date:   Fri Apr 27 13:27:40 2012 -0400

    NFS: Do secinfo as part of lookup
    
    Whenever lookup sees wrongsec do a secinfo and retry the lookup to find
    attributes of the file or directory, such as "is this a referral
    mountpoint?".  This also allows me to remove handling -NFS4ERR_WRONSEC
    as part of getattr xdr decoding.
    
    Signed-off-by: Bryan Schumaker <bjschuma@netapp.com>
    Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>

commit db0a9593d52f935c80085d8993bdcead1ad30b0c
Author: Bryan Schumaker <bjschuma@netapp.com>
Date:   Fri Apr 27 13:27:39 2012 -0400

    NFS: Handle exceptions coming out of nfs4_proc_fs_locations()
    
    We don't want to return -NFS4ERR_WRONGSEC to the VFS because it could
    cause the kernel to oops.
    
    Signed-off-by: Bryan Schumaker <bjschuma@netapp.com>
    Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>

commit 31e4dda4747713de13889f7c79c7aec341fea61b
Author: Bryan Schumaker <bjschuma@netapp.com>
Date:   Fri Apr 27 13:27:38 2012 -0400

    NFS: Fix SECINFO_NO_NAME
    
    I was using the same decoder function for SECINFO and SECINFO_NO_NAME,
    so it was returning an error when it tried to decode an OP_SECINFO_NO_NAME
    header as OP_SECINFO.
    
    Signed-off-by: Bryan Schumaker <bjschuma@netapp.com>
    Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>

commit ea8cfa06795bb30d2ea61f503ef129284492c06a
Author: Stanislav Kinsbursky <skinsbursky@parallels.com>
Date:   Fri Apr 27 13:00:17 2012 +0400

    SUNRPC: traverse clients tree on PipeFS event
    
    v2: recursion was replaced by loop
    
    If client is a clone, then it's parent can not be in the list.
    But parent's Pipefs dentries have to be created and destroyed.
    
    Note: event skip helper for clients introduced
    
    Signed-off-by: Stanislav Kinsbursky <skinsbursky@parallels.com>
    Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>

commit 37629b572cc4e80fc24b4139a24df1a89415d534
Author: Stanislav Kinsbursky <skinsbursky@parallels.com>
Date:   Fri Apr 20 18:19:56 2012 +0400

    SUNRPC: set per-net PipeFS superblock before notification
    
    There can be a case, when on MOUNT event RPC client (after it's dentries were
    created) is not longer hold by anyone except notification callback.
    I.e. on release this client will be destoroyed. And it's dentries have to be
    destroyed as well. Which in turn requires per-net PipeFS superblock to be set.
    
    Signed-off-by: Stanislav Kinsbursky <skinsbursky@parallels.com>
    Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>

commit 7aab449e5a2ebfa9c5116e87e16536bc4195e4de
Author: Stanislav Kinsbursky <skinsbursky@parallels.com>
Date:   Fri Apr 20 18:19:18 2012 +0400

    SUNRPC: skip clients with program without PipeFS entries
    
    1) This is sane.
    2) Otherwise there will be soft lockup:
    
    do {
    	rpc_get_client_for_event (clnt->cl_dentry == NULL ==> choose)
    	__rpc_pipefs_event (clnt->cl_program->pipe_dir_name == NULL ==> return)
    } while (1)
    
    Signed-off-by: Stanislav Kinsbursky <skinsbursky@parallels.com>
    Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>

commit a4dff1bc492ee4a2184d384ae8b5bcab5859e150
Author: Stanislav Kinsbursky <skinsbursky@parallels.com>
Date:   Fri Apr 20 18:11:02 2012 +0400

    SUNRPC: skip dead but not buried clients on PipeFS events
    
    These clients can't be safely dereferenced if their counter in 0.
    
    Signed-off-by: Stanislav Kinsbursky <skinsbursky@parallels.com>
    Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>

commit 5794d21ef4639f0e33440927bb903f9598c21e92
Author: Sachin Prabhu <sprabhu@redhat.com>
Date:   Tue Apr 17 14:36:40 2012 +0100

    Avoid beyond bounds copy while caching ACL
    
    When attempting to cache ACLs returned from the server, if the bitmap
    size + the ACL size is greater than a PAGE_SIZE but the ACL size itself
    is smaller than a PAGE_SIZE, we can read past the buffer page boundary.
    
    Signed-off-by: Sachin Prabhu <sprabhu@redhat.com>
    Reported-by: Jian Li <jiali@redhat.com>
    Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>

commit 5a00689930ab975fdd1b37b034475017e460cf2a
Author: Sachin Prabhu <sprabhu@redhat.com>
Date:   Tue Apr 17 14:35:39 2012 +0100

    Avoid reading past buffer when calling GETACL
    
    Bug noticed in commit
    bf118a342f10dafe44b14451a1392c3254629a1f
    
    When calling GETACL, if the size of the bitmap array, the length
    attribute and the acl returned by the server is greater than the
    allocated buffer(args.acl_len), we can Oops with a General Protection
    fault at _copy_from_pages() when we attempt to read past the pages
    allocated.
    
    This patch allocates an extra PAGE for the bitmap and checks to see that
    the bitmap + attribute_length + ACLs don't exceed the buffer space
    allocated to it.
    
    Signed-off-by: Sachin Prabhu <sprabhu@redhat.com>
    Reported-by: Jian Li <jiali@redhat.com>
    [Trond: Fixed a size_t vs unsigned int printk() warning]
    Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>

commit 10bd295a0b6488ebe634b72a11d8986bd3af3819
Author: Jim Rees <rees@umich.edu>
Date:   Mon Apr 9 22:33:39 2012 -0400

    fix page number calculation bug for block layout decode buffer
    
    Signed-off-by: Jim Rees <rees@umich.edu>
    Suggested-by: Andy Adamson <andros@netapp.com>
    Suggested-by: Fred Isaman <iisaman@netapp.com>
    Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>

commit e5265a0c587423bbd21a6b39a572cecff16b9346
Author: Andy Adamson <andros@netapp.com>
Date:   Sat Apr 14 03:56:35 2012 -0400

    NFSv4.1 fix page number calculation bug for filelayout decode buffers
    
    Signed-off-by: Andy Adamson <andros@netapp.com>
    Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>

commit 9526b2b6d6b9f183b66cf21c4afa6e79d5a14f44
Author: Sachin Bhamare <sbhamare@panasas.com>
Date:   Fri Mar 30 14:29:59 2012 -0700

    pnfs-obj: Remove unused variable from objlayout_get_deviceinfo()
    
    Local variable 'sb' was not being used in objlayout_get_deviceinfo().
    
    Signed-off-by: Sachin Bhamare <sbhamare@panasas.com>
    Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
    Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>

commit 1aba1567637b93eee32253b42deaaad381c3175b
Author: Weston Andros Adamson <dros@netapp.com>
Date:   Tue Apr 24 16:50:37 2012 -0400

    nfs4: fix referrals on mounts that use IPv6 addrs
    
    All referrals (IPv4 addr, IPv6 addr, and DNS) are broken on mounts of
    IPv6 addresses, because validation code uses a path that is parsed
    from the dev_name ("<server>:<path>") by splitting on the first colon and
    colons are used in IPv6 addrs.
    This patch ignores colons within IPv6 addresses that are escaped by '[' and ']'.
    
    Signed-off-by: Weston Andros Adamson <dros@netapp.com>
    Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>


-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com

ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
