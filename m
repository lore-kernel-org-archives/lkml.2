Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755438Ab0IPRjt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 13:39:49 -0400
Received: from smtp102.prem.mail.ac4.yahoo.com ([76.13.13.41]:24956 "HELO
	smtp102.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753907Ab0IPRjs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 13:39:48 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: pY8y_FsVM1kPIvRZWppV.9noUbh.kdK0mHf.CNe_xE4gsd6
 EbiXPc.kO6LtJ.Yy1xWVVnQusCe2YH6rFZ62WLsmXTvomOKjFUzD.p.wqVVW
 _SGt.n7abMTp59a75yZWc1GxCilOmP0dYZXO5limmzWfJVSIKdJ4guE2REgr
 .GloqbifGhYZKMZlVJ3tD41zxgRx.tjZDTAuSFSDy_R1qPdEw8LJmzCfG0US
 CMyyI47647BCr1uDRpxNxrz.h0hey
X-Yahoo-Newman-Property: ymail-3
Date: Thu, 16 Sep 2010 12:39:44 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: David Rientjes <rientjes@google.com>
cc: "Ted Ts'o" <tytso@mit.edu>, Pekka Enberg <penberg@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] SLUB: Mark merged slab caches in /proc/slabinfo
In-Reply-To: <alpine.DEB.2.00.1009151537080.15256@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.1009161209240.22849@router.home>
References: <1284490101-2362-1-git-send-email-penberg@kernel.org> <1284490101-2362-2-git-send-email-penberg@kernel.org> <alpine.DEB.2.00.1009141243290.1470@chino.kir.corp.google.com> <AANLkTinj2P_QbdgdLS3BweSMDzhQH5g4p2B3SqS=CNYc@mail.gmail.com>
 <alpine.DEB.2.00.1009141320090.7123@chino.kir.corp.google.com> <4C8FE263.5070101@kernel.org> <alpine.DEB.2.00.1009141646350.26982@chino.kir.corp.google.com> <1097CAA8-8234-4FE2-BAA1-9C7D9FA01CEC@mit.edu> <alpine.DEB.2.00.1009151322370.29425@chino.kir.corp.google.com>
 <20100915222509.GE3730@thunk.org> <alpine.DEB.2.00.1009151537080.15256@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The main point of merging slabs is to reduce memory footprint and
avoid the overhead of managing more slab caches. Performance is a side
effect that may come about due to a reduced cache footprint if multiple
caches that are mapped to the same merged cache are used in the same
context.

Merging also makes kmem_cache_create() much cheaper (takes a refcount
instead of allocating new memory and managing it) which means that we
could reduce our memory footprint by replacing kmalloc() in various
places. If we do that then we can also associate names with more kernel
objects that are currently using kmalloc resulting in an enhanced
debuggability since any debug option will separate the caches again so
that a problem can be pin-pointed correctly.

kmalloc mostly rounds up to the power of 2 which causes some amount memory
being wasted. Merging allows finer grained sizes that are used by multiple
kernel components. kfree() also requires a lookup of the cache on free
whereas kmem_cache_free() can avoid such a lookup.

Here is an example of slab cache merging on my system. One basically ends
up with a kind of more refined kmalloc array.

christoph@:~/n/linux-2.6$ slabinfo -a

:at-0000016  <- revoke_table jbd2_revoke_table
:at-0000024  <- journal_handle jbd2_journal_handle
:at-0000032  <- revoke_record jbd2_revoke_record
:at-0000088  <- ext2_xattr ext4_xattr ext3_xattr extent_map
:at-0000112  <- jbd2_journal_head journal_head
:at-0000144  <- ext4_alloc_context extent_buffers btrfs_path_cache
:t-0000016   <- dm_rq_clone_bio_info dm_mpath_io kmalloc-16 biovec-1 ecryptfs_file_cache
:t-0000024   <- xfs_dabuf fstrm_item scsi_data_buffer dm_target_io fsnotify_event_holder numa_policy dm_snap_tracked_chunk fasync_cache xfs_bmap_free_item
:t-0000032   <- ecryptfs_dentry_info_cache ecryptfs_key_sig_cache xfs_mru_cache_elem sd_ext_cdb dm_snap_exception ip_fib_alias dnotify_struct inotify_event_private_data kmalloc-32 Acpi-Namespace nv_pte_t
:t-0000040   <- kvm_rmap_desc dm_io
:t-0000048   <- Acpi-Parse shared_policy_node nsproxy
:t-0000056   <- ksm_mm_slot uhci_urb_priv kvm_pte_chain
:t-0000064   <- xfs_ifork kmalloc-64 ecryptfs_global_auth_tok_cache ntfs_attr_ctx_cache fib6_nodes tcp_bind_bucket biovec-4 inet_peer_cache secpath_cache ksm_rmap_item fs_cache
:t-0000072   <- Acpi-ParseExt nfsd4_files Acpi-Operand ip_fib_hash eventpoll_pwq
:t-0000080   <- sysfs_dir_cache Acpi-State blkdev_ioc
:t-0000096   <- flow_cache xfs_ioend kmalloc-96
:t-0000112   <- inotify_inode_mark_entry dm_snap_pending_exception blkdev_integrity dnotify_mark_entry
:t-0000128   <- ecryptfs_open_req_cache ip_mrt_cache scsi_sense_cache eventpoll_epi ntfs_index_ctx_cache pid bip-1 kmalloc-128 uid_cache nfsd4_stateids pid_2 request_sock_TCP ecryptfs_key_tfm_cache
:t-0000168   <- cfq_queue cfq_io_context
:t-0000176   <- posix_timers_cache vm_area_struct kvm_mmu_page_header
:t-0000192   <- filp request_sock_TCPv6 key_jar bip-4 cred_jar ecryptfs_sb_cache kmalloc-192 xfs_buf_item xfs_ili bio-0
:t-0000256   <- skbuff_head_cache kmalloc-256 sgpool-8 scsi_cmd_cache arp_cache kiocb biovec-16 ndisc_cache mnt_cache
:t-0000320   <- rpc_tasks ip6_dst_cache
:t-0000368   <- xfs_efd_item kcopyd_job
:t-0000384   <- xfs_buf bip-16 kioctx xfrm_dst_cache ip_dst_cache
:t-0000512   <- skbuff_fclone_cache task_xstate ntfs_name_cache kmalloc-512 sgpool-16
:t-0000768   <- RAW UNIX
:t-0000960   <- RAWv6 signal_cache
:t-0001024   <- sgpool-32 biovec-64 kmalloc-1024
:t-0002048   <- sgpool-64 kmalloc-2048 net_namespace biovec-128 rpc_buffers
:t-0004096   <- ecryptfs_headers_1 ecryptfs_headers_2 ecryptfs_xattr_cache sgpool-128 biovec-256 kmalloc-4096 names_cache

