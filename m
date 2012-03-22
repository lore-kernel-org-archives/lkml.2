Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932354Ab2CVO7q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 10:59:46 -0400
Received: from mx2.netapp.com ([216.240.18.37]:12296 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753334Ab2CVO7m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 10:59:42 -0400
X-IronPort-AV: E=Sophos;i="4.73,630,1325491200"; 
   d="scan'208";a="635479973"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux NFS mailing list <linux-nfs@vger.kernel.org>,
        "Linux Kernel mailing list" <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Please pull NFS client updates
Thread-Topic: [GIT PULL] Please pull NFS client updates
Thread-Index: AQHNCDxdo9K1NbtCu0qQcXnIk8PwsA==
Date: Thu, 22 Mar 2012 14:59:22 +0000
Message-ID: <1332428364.2985.25.camel@lade.trondhjem.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.104.60.116]
Content-Type: text/plain; charset="utf-8"
Content-ID: <43E7A0A0551AD444A2C70072174FD3E8@tahoe.netapp.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q2MExvff021906

Hi Linus,

Please pull from the signed tag "nfs-for-3.4-1" in the repository at

   git pull git://git.linux-nfs.org/projects/trondmy/linux-nfs.git tag nfs-for-3.4-1

This will update the following files through the appended changesets.

Please note the presence of one (minimal) back-merge that was needed in
order to resolve a conflict with the upstream kernel.

New features include:
- Add NFS client support for containers.
  This should enable most of the necessary functionality, including
  lockd support, and support for rpc.statd, NFSv4 idmapper and
  RPCSEC_GSS upcalls into the correct network namespace from
  which the mount system call was issued.
- NFSv4 idmapper scalability improvements
  Base the idmapper cache on the keyring interface to allow concurrent
  access to idmapper entries. Start the process of migrating users from
  the single-threaded daemon-based approach to the multi-threaded
  request-key based approach.
- NFSv4.1 implementation id.
  Allows the NFSv4.1 client and server to mutually identify each other
  for logging and debugging purposes.
- Support the 'vers=4.1' mount option for mounting NFSv4.1 instead of
  having to use the more counterintuitive 'vers=4,minorversion=1'.
- SUNRPC tracepoints.
  Start the process of adding tracepoints in order to improve debugging
  of the RPC layer.
- pNFS object layout support for autologin.

Important bugfixes include:
- Fix a bug in rpc_wake_up/rpc_wake_up_status that caused them to fail
  to wake up all tasks when applied to priority waitqueues.
- Ensure that we handle read delegations correctly, when we try to
  truncate a file.
- A number of fixes for NFSv4 state manager loops (mostly to do with
  delegation recovery).


  Cheers,
    Trond

----
 Documentation/filesystems/nfs/idmapper.txt |   20 +-
 Documentation/filesystems/nfs/pnfs.txt     |   54 ++
 Documentation/kernel-parameters.txt        |   23 +
 fs/lockd/clnt4xdr.c                        |    2 +-
 fs/lockd/clntlock.c                        |    3 +-
 fs/lockd/clntxdr.c                         |    8 +-
 fs/lockd/host.c                            |   42 ++-
 fs/lockd/mon.c                             |   21 +-
 fs/lockd/netns.h                           |   12 +
 fs/lockd/svc.c                             |  117 ++++-
 fs/lockd/svclock.c                         |   59 ++--
 fs/nfs/Kconfig                             |   29 +-
 fs/nfs/blocklayout/blocklayout.c           |  161 +++++--
 fs/nfs/blocklayout/blocklayout.h           |   11 +-
 fs/nfs/blocklayout/blocklayoutdev.c        |   46 +-
 fs/nfs/blocklayout/blocklayoutdm.c         |   33 +-
 fs/nfs/blocklayout/extents.c               |    2 +-
 fs/nfs/cache_lib.c                         |   61 ++-
 fs/nfs/cache_lib.h                         |   10 +-
 fs/nfs/callback.c                          |   19 +-
 fs/nfs/callback.h                          |    3 +-
 fs/nfs/callback_proc.c                     |   99 ++--
 fs/nfs/callback_xdr.c                      |   21 +-
 fs/nfs/client.c                            |  246 ++++++----
 fs/nfs/delegation.c                        |   68 ++--
 fs/nfs/delegation.h                        |    4 +-
 fs/nfs/dir.c                               |   27 +-
 fs/nfs/direct.c                            |    6 -
 fs/nfs/dns_resolve.c                       |  130 ++++-
 fs/nfs/dns_resolve.h                       |   14 +-
 fs/nfs/file.c                              |    2 +
 fs/nfs/fscache.c                           |    2 +-
 fs/nfs/idmap.c                             |  733 +++++++++++++---------------
 fs/nfs/inode.c                             |  119 ++++-
 fs/nfs/internal.h                          |   15 +-
 fs/nfs/mount_clnt.c                        |   16 +-
 fs/nfs/namespace.c                         |    5 +-
 fs/nfs/netns.h                             |   27 +
 fs/nfs/nfs2xdr.c                           |    2 +-
 fs/nfs/nfs3acl.c                           |    2 +-
 fs/nfs/nfs3proc.c                          |   24 +
 fs/nfs/nfs3xdr.c                           |    4 +-
 fs/nfs/nfs4_fs.h                           |   58 ++-
 fs/nfs/nfs4filelayout.c                    |  272 ++++++++---
 fs/nfs/nfs4filelayout.h                    |    7 +-
 fs/nfs/nfs4filelayoutdev.c                 |   90 ++---
 fs/nfs/nfs4namespace.c                     |   10 +-
 fs/nfs/nfs4proc.c                          |  559 +++++++++++++++-------
 fs/nfs/nfs4state.c                         |  355 ++++++++------
 fs/nfs/nfs4xdr.c                           |  697 +++++++++++++--------------
 fs/nfs/nfsroot.c                           |    2 +-
 fs/nfs/objlayout/objio_osd.c               |   54 ++-
 fs/nfs/objlayout/objlayout.c               |  142 ++++++-
 fs/nfs/objlayout/objlayout.h               |    2 +
 fs/nfs/pagelist.c                          |   92 +----
 fs/nfs/pnfs.c                              |   46 +-
 fs/nfs/pnfs.h                              |   98 ++--
 fs/nfs/pnfs_dev.c                          |    4 +-
 fs/nfs/proc.c                              |   24 +
 fs/nfs/read.c                              |   14 +-
 fs/nfs/super.c                             |  167 +++++--
 fs/nfs/sysctl.c                            |    2 -
 fs/nfs/unlink.c                            |   45 +--
 fs/nfs/write.c                             |  213 +++++----
 fs/nfsd/nfs4callback.c                     |    8 +-
 fs/nfsd/nfs4state.c                        |    2 +-
 fs/nfsd/nfsctl.c                           |    6 +-
 fs/nfsd/nfssvc.c                           |    4 +-
 fs/nfsd/stats.c                            |    5 +-
 include/linux/key.h                        |    2 +
 include/linux/lockd/bind.h                 |    1 +
 include/linux/lockd/lockd.h                |    7 +-
 include/linux/lockd/xdr4.h                 |    2 +-
 include/linux/nfs.h                        |    2 +-
 include/linux/nfs4.h                       |    7 +-
 include/linux/nfs_fs.h                     |   46 ++-
 include/linux/nfs_fs_i.h                   |    4 -
 include/linux/nfs_fs_sb.h                  |   23 +-
 include/linux/nfs_idmap.h                  |   22 +-
 include/linux/nfs_iostat.h                 |    2 +-
 include/linux/nfs_page.h                   |   27 +-
 include/linux/nfs_xdr.h                    |   65 ++-
 include/linux/sunrpc/auth.h                |    2 +
 include/linux/sunrpc/bc_xprt.h             |    2 +-
 include/linux/sunrpc/cache.h               |    8 +-
 include/linux/sunrpc/clnt.h                |   40 +-
 include/linux/sunrpc/debug.h               |   26 +-
 include/linux/sunrpc/metrics.h             |    6 +-
 include/linux/sunrpc/rpc_pipe_fs.h         |   46 ++-
 include/linux/sunrpc/sched.h               |   24 +-
 include/linux/sunrpc/stats.h               |   22 +-
 include/linux/sunrpc/svc.h                 |   13 +-
 include/linux/sunrpc/svc_xprt.h            |    3 +-
 include/linux/sunrpc/svcauth.h             |    3 +
 include/linux/sunrpc/svcauth_gss.h         |    2 +
 include/linux/sunrpc/svcsock.h             |    2 +-
 include/linux/sunrpc/xprt.h                |   11 +-
 include/linux/sunrpc/xprtsock.h            |   12 -
 include/trace/events/sunrpc.h              |  177 +++++++
 net/sunrpc/Kconfig                         |   13 +
 net/sunrpc/addr.c                          |   26 +-
 net/sunrpc/auth_gss/auth_gss.c             |  216 ++++++---
 net/sunrpc/auth_gss/gss_krb5_crypto.c      |    7 +-
 net/sunrpc/auth_gss/gss_krb5_mech.c        |    2 +-
 net/sunrpc/auth_gss/gss_krb5_seal.c        |    2 +-
 net/sunrpc/auth_gss/svcauth_gss.c          |  165 +++++--
 net/sunrpc/backchannel_rqst.c              |    1 +
 net/sunrpc/cache.c                         |   44 +-
 net/sunrpc/clnt.c                          |  548 ++++++++++++++++-----
 net/sunrpc/netns.h                         |   14 +
 net/sunrpc/rpc_pipe.c                      |  501 ++++++++++++--------
 net/sunrpc/rpcb_clnt.c                     |  188 ++++----
 net/sunrpc/sched.c                         |   73 +++-
 net/sunrpc/stats.c                         |   35 +-
 net/sunrpc/sunrpc.h                        |    2 +
 net/sunrpc/sunrpc_syms.c                   |   17 +-
 net/sunrpc/svc.c                           |   98 +++--
 net/sunrpc/svc_xprt.c                      |   51 ++-
 net/sunrpc/svcauth_unix.c                  |  126 +++--
 net/sunrpc/svcsock.c                       |    5 +-
 net/sunrpc/sysctl.c                        |    4 +-
 net/sunrpc/xprt.c                          |   80 ++--
 net/sunrpc/xprtrdma/rpc_rdma.c             |    9 +-
 net/sunrpc/xprtrdma/verbs.c                |   17 +-
 net/sunrpc/xprtsock.c                      |   33 +-
 security/keys/key.c                        |   20 +
 security/keys/keyctl.c                     |   18 +-
 127 files changed, 5217 insertions(+), 2987 deletions(-)

Andy Adamson (4):
      SUNRPC: add sending,pending queue and max slot to xprt stats
      NFSv4.1 set highest_used_slotid to NFS4_NO_SLOT
      NFSv4.1 handle DS stateid errors
      NFSv4.1 cleanup DS stateid error handling

Benny Halevy (1):
      pnfs: clean up initiate_file_draining layout lookup

Boaz Harrosh (1):
      pnfs-obj: Uglify objio_segment allocation for the sake of the principle :-(

Bryan Schumaker (14):
      NFS: Pass a stateid to test_stateid() and free_stateid()
      NFS: Call test_stateid() and free_stateid() with correct stateids
      NFS: Fall back on old idmapper if request_key() fails
      NFS: Keep idmapper include files in one place
      NFS: Update idmapper documentation
      Created a function for setting timeouts on keys
      NFS: Store the legacy idmapper result in the keyring
      NFS: Undo changes to idmap.h
      NFS: Only define some function when v4.1 is enabled
      NFS: Check return value from rpc_queue_upcall()
      NFS: Remove nfs4_setup_sequence from generic write code
      NFS: Remove nfs4_setup_sequence from generic read code
      NFS: Remove nfs4_setup_sequence from generic unlink code
      NFS: Remove nfs4_setup_sequence from generic rename code

Chuck Lever (14):
      SUNRPC: Use KERN_DEFAULT for debugging printk's
      nfs: Clean up debugging in nfs_follow_mountpoint()
      NFS: Make nfs_cache_array.size a signed integer
      NFS: Clean up debugging in decode_pathname()
      NFS: Add debugging messages to NFSv4's CLOSE procedure
      SUNRPC: Add API to acquire source address
      NFS: Make clientaddr= optional
      NFS: Add a client-side function to display NFS file handles
      NFS: Simplify arguments of encode_renew()
      NFS: Introduce NFS_ATTR_FATTR_V4_LOCATIONS
      NFS: Request fh_expire_type attribute in "server caps" operation
      NFS: Reduce debugging noise from encode_compound_hdr
      NFS: Fix nfs4_verifier memory alignment
      SUNRPC: Kill compiler warning when RPC_DEBUG is unset

Dan Carpenter (2):
      SUNRPC: remove an unneeded NULL check in xprt_connect()
      NFS: null dereference in dev_remove()

Fred Isaman (3):
      NFS: remove NFS_PAGE_TAG_LOCKED
      NFS: remove nfs_inode radix tree
      NFS: ncommit count is being double decremented

Jeff Layton (1):
      nfs: remove unneeded NULL pointer check in nfs4_remote_mount

Randy Dunlap (1):
      sunrpc: fix stats.h for CONFIG_PROC_FS not enabled

Sachin Bhamare (1):
      pnfs-obj: autologin: Add support for protocol autologin

Sachin Prabhu (1):
      Try using machine credentials for RENEW calls

Stanislav Kinsbursky (90):
      SUNRPC: remove non-exclusive pipe creation from RPC pipefs
      SUNRPC: create RPC pipefs superblock per network namespace context
      SUNRPC: hold current network namespace while pipefs superblock is active
      SUNRPC: send notification events on pipefs sb creation and destruction
      SUNRPC: pipefs dentry lookup helper introduced
      SUNRPC: put pipefs superblock link on network namespace
      SUNRPC: pipefs per-net operations helper introduced
      SUNRPC: added debug messages to RPC pipefs
      SUNRPC: replace inode lock with pipe lock for RPC PipeFS operations
      SUNRPC: split SUNPRC PipeFS pipe data and inode creation
      SUNRPC: cleanup PipeFS redundant RPC inode usage
      SUNPRC: cleanup RPC PipeFS pipes upcall interface
      SUNRPC: cleanup GSS pipes usage
      SUNRPC: split SUNPRC PipeFS dentry and private pipe data creation
      SUNRPC: handle RPC client pipefs dentries by network namespace aware routines
      SUNRPC: handle GSS AUTH pipes by network namespace aware routines
      SUNRPC: make SUNPRC clients list per network namespace context
      SUNRPC: subscribe RPC clients to pipefs notifications
      SUNRPC: remove RPC client pipefs dentries after unregister
      SUNRPC: remove RPC pipefs mount point manipulations from RPC clients code
      SUNRPC: remove RPC PipeFS mount point reference from RPC client
      SUNRPC: split cache creation and PipeFS registration
      NFS: split cache creation and PipeFS registration
      NFS: handle NFS caches dentries by network namespace aware routines
      NFS: DNS resolver cache per network namespace context introduced
      NFS: DNS resolver PipeFS notifier introduced
      NFS: remove RPC PipeFS mount point references from NFS cache routines
      SUNRPC: fix pipe->ops cleanup on pipe dentry unlink
      NFS: make NFS client allocated per network namespace context
      NFS: pass NFS client owner network namespace to RPC client creation routine
      NFS: create callback transports in parent transport network namespace
      NFS: handle NFS idmap pipe PipeFS dentries by network namespace aware routines
      NFS: idmap PipeFS notifier introduced
      NFS: handle blocklayout pipe PipeFS dentry by network namespace aware routines
      NFS: blocklayout pipe creation per network namespace context introduced
      NFS: blocklayout PipeFS notifier introduced
      NFS: remove RPC PipeFS mount point reference from blocklayout routines
      SUNRPC: kernel PipeFS mount point creation routines removed
      SUNRPC: move rpcbind internals to sunrpc part of network namespace context
      SUNRPC: optimize net_ns dereferencing in rpcbind creation calls
      SUNRPC: optimize net_ns dereferencing in rpcbind registering calls
      SUNRPC: create rpcbind client in passed network namespace context
      SUNRPC: register rpcbind programs in passed network namespase context
      SUNRPC: parametrize local rpcbind clients creation with net ns
      SUNRPC: parametrize rpc_parse_scope_id() by network context
      SUNRPC: parametrize rpc_pton6() by network context
      SUNRPC: parametrize rpc_pton() by network context
      SUNRPC: parametrize rpc_uaddr2sockaddr() by network context
      SUNRPC: use proper network namespace in rpcbind RPCBPROC_GETADDR procedure
      SUNRPC: pass network namespace to service registering routines
      SUNRPC: register service on creation in current network namespace
      SUNRPC: unregister service on creation in current network namespace
      SUNRPC: cache creation and destruction routines introduced
      SUNRPC: create unix gid cache per network namespace
      SUNRPC: create GSS auth cache per network namespace
      SUNRPC: ip map cache per network namespace cleanup
      SUNRPC: generic cache register routines removed
      NFS: parse DNS cache in proper network namespace context
      NFS: decode destination address in proper network namespace context
      SUNRPC: register RPC stats /proc entries in passed network namespace context
      SUNRPC: register service stats /proc entries in passed network namespace context
      NFS: remove unused nfs4_find_client_no_ident function
      SUNRPC: search for service transports in network namespace context
      NFS: make nfs_client_list per net ns
      NFS: make nfs_volume_list per net ns
      NFS: make cb_ident_idr per net ns
      NFS: make nfs_client_lock per net ns
      NFS: pass proper net rpc_pton() in nfs_dns_resolve_name()
      NFS: search for client session id in proper network namespace
      NFS: pass current net to rpc_pton() while parsing mount options
      NFS: pass transport net to rpc_pton() while parse server name
      NFS: build fixed in case of NFS_USE_NEW_IDMAPPER is undefined
      SUNRPC: clear svc pools lists helper introduced
      SUNRPC: clear svc transports lists helper introduced
      SUNRPC: service destruction in network namespace context
      SUNRPC: service shutdown function in network namespace context introduced
      Lockd: create permanent lockd sockets in current network namespace
      Lockd: pernet usage counter introduced
      Lockd: per-net up and down routines introduced
      LockD: make nlm hosts network namespace aware
      LockD: make NSM network namespace aware
      Lockd: shutdown NLM hosts in network namespace context
      NFS: fix nfs4_find_client_sessionid() arguments list
      SUNRPC: init per-net rpcbind spinlock
      SUNRPC: release per-net clients lock before calling PipeFS dentries creation
      NFS: release per-net clients lock before calling PipeFS dentries creation
      SUNRPC: check RPC inode's pipe reference before dereferencing
      SUNRPC: move waitq from RPC pipe to RPC inode
      NFS: replace global bl_mount_reply with per-net one
      NFS: replace global bl_wq with per-net one

Stephen Rothwell (1):
      nfs: non void functions must return a value

Steve Dickson (1):
      SUNRPC: Adding status trace points

Tom Tucker (2):
      xprtrdma: The transport should not bug-check when a dup reply is received
      xprtrdma: Remove assumption that each segment is <= PAGE_SIZE

Trond Myklebust (73):
      NFS: Remove unnecessary includes from linux/nfs_fs_i.h
      NFSv4: Clean up nfs4_get_state_owner
      NFSv4: Replace state_owner->so_owner_id with an ida based allocator
      NFSv4: Replace lock_owner->ld_id with an ida based allocator
      NFSv41: Add a new helper nfs4_init_sequence()
      NFSv4: Move contents of struct rpc_sequence into struct nfs_seqid_counter
      NFS: Move struct nfs_unique_id into struct nfs_seqid_counter
      NFS: Optimise away unnecessary setattrs for open(O_TRUNC);
      NFS: Ensure that mmapped pages remain stable during writeback
      SUNRPC: Fix potential races in xprt_lock_write_next()
      SUNRPC: constify rpc_clnt fields cl_server and cl_protname
      SUNRPC: constify rpc_program->name
      SUNRPC: constify the rpc_program
      SUNRPC: Add trace events to the sunrpc subsystem
      NFSv4: Avoid thundering herd issues with nfs_release_seqid
      NFS: Use kcalloc() when allocating arrays
      SUNRPC: fixup for namespace changes
      NFSv4: Don't decode fs_locations if we didn't ask for them...
      NFSv4: ACCESS validation doesn't require a full attribute refresh
      SUNRPC: Fix up sunrpc trace events
      SUNRPC: Change the default limit to the number of TCP slots
      NFSv4.1: Convert slotid from u8 to u32
      NFSv4.1: Add a module parameter to set the number of session slots
      NFS: Initialise the nfs_net->nfs_client_lock
      NFSv4: Reduce the footprint of the idmapper
      NFSv4: The idmapper now depends on keyring functionality
      NFSv4: Further reduce the footprint of the idmapper
      SUNRPC: Ensure that we can trace waitqueues when !defined(CONFIG_SYSCTL)
      NFS: Ensure that the nfs_client 'net' field is always set
      NFS: Ensure struct nfs_client holds a reference to the net namespace
      NFSv4.1: Don't call nfs4_deviceid_purge_client() unless we're NFSv4.1
      NFSv4.1: Get rid of redundant NFS4CLNT_LAYOUTRECALL tests
      NFSv4.1: Get rid of NFS4CLNT_LAYOUTRECALL
      NFS: Extend the -overs= mount option to allow 4.x minorversions
      NFS: Ensure we display the minor version correctly in /proc/mounts etc.
      NFS: Consolidate the parsing of the '-ov4.x' and '-overs=4.x' mount options
      SUNRPC: Use RCU to dereference the rpc_clnt.cl_xprt field
      SUNRPC: Move clnt->cl_server into struct rpc_xprt
      NFS: Fix a compile issue when !CONFIG_NFS_V4_1
      NFS: Fix a typo in _nfs_display_fhandle
      NFS: Properly handle the case where the delegation is revoked
      NFSv4.1: Fix matching of the stateids when returning a delegation
      NFSv4: Further clean-ups of delegation stateid validation
      NFSv4: Rename encode_stateid() to encode_open_stateid()
      NFSv4: Add a helper for encoding opaque data
      NFSv4: Add a helper for encoding stateids
      NFSv4: Rename nfs4_copy_stateid()
      NFSv4: Add helpers for basic copying of stateids
      NFSv4: Simplify the struct nfs4_stateid
      NFSv4: Minor clean ups for encode_string()
      NFSv4: Add a helper for encoding NFSv4 sequence ids
      NFSv4: Add a encode op helper
      NFSv4: Cleanup - convert more functions to use encode_op_hdr
      NFSv4: More xdr cleanups
      NFSv4: Add a helper encode_uint64
      NFSv4: Don't free the nfs4_lock_state until after the release_lockowner
      NFSv4: Return the delegation if the server returns NFS4ERR_OPENMODE
      NFS: Don't copy read delegation stateids in setattr
      NFSv4: Clean up nfs4_select_rw_stateid()
      NFSv4.0: Re-establish the callback channel on NFS4ERR_CB_PATHDOWN
      NFS: Fix a number of sparse warnings
      SUNRPC: Fix a few sparse warnings
      SUNRPC: Don't use variable length automatic arrays in kernel code
      NFSv4: Rate limit the state manager warning messages
      NFS: Fix a compile error when !defined NFS_DEBUG
      NFSv4.1: Clean ups and bugfixes for the pNFS read/writeback/commit code
      NFSv4.1: Fix a few issues in filelayout_commit_pagelist
      SUNRPC: We must not use list_for_each_entry_safe() in rpc_wake_up()
      NFSv4: It is not safe to dereference lsp->ls_state in release_lockowner
      NFS: Use cond_resched_lock() to reduce latencies in the commit scans
      SUNRPC/NFS: Add Kbuild dependencies for NFS_DEBUG/RPC_DEBUG
      SUNRPC/LOCKD: Fix build warnings when CONFIG_SUNRPC_DEBUG is undefined
      NFS: Fix more NFS debug related build warnings

Vitaliy Gusev (1):
      nfs41: Verify channel's attributes accordingly to RFC v2

Vivek Trivedi (1):
      NFS: fix sb->s_id in nfs debug prints

Weston Andros Adamson (11):
      NFS: printks in fs/nfs/ should start with NFS:
      NFS: start printks w/ NFS: even if __func__ shown
      NFS: Fix comparison between DS address lists
      NFS: add mount options 'v4.0' and 'v4.1'
      NFS: dont allow minorversion= opt when vers != 4
      NFS: include filelayout DS rpc stats in mountstats
      NFSv4: Send implementation id with exchange_id
      NFSv4: fix server_scope memory leak
      NFSv4: parse and display server implementation ids
      NFS: add filehandle crc for debug display
      NFS: add fh_crc to debug output

William Dauchy (1):
      NFSv4: Rate limit the state manager for lock reclaim warning messages



-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com

ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
