Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767791Ab2KONSk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 08:18:40 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39924 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767736Ab2KONSi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 08:18:38 -0500
Message-ID: <50A4EBA2.1040001@suse.com>
Date: Thu, 15 Nov 2012 18:48:26 +0530
From: Suresh Jayaraman <sjayaraman@suse.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121025 Thunderbird/16.0.2
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Cc: linux-cachefs@redhat.com
Subject: Re: [Linux-cachefs] Hang while doing cp from NFS mount to local disk
 when fsc is enabled
References: <509A5C46.8010404@suse.com>
In-Reply-To: <509A5C46.8010404@suse.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Cc lkml as well)

On 11/07/2012 06:34 PM, Suresh Jayaraman wrote:
> Hi David,
> 
> I'm observing a hang with the recent 3.4-ish kernel when trying to do
> something like the below:
> 
> mount -t nfs4 server:/share /mnt/nfs -o fsc
> cp /mnt/nfs/f_20M /tmp
> echo 3 > /proc/sys/vm/drop_caches
> cp /mnt/nfs/f_20M /share
> 
> The second cp hangs. Apparently, the cp process seems to be waiting to
> get exclusive access to a page that is already been locked but not
> released..
> 
> Here's a snip from SysRq + w output
> 
> [1898655.285852] SysRq : Show Blocked State
> [1898655.285864]   task                        PC stack   pid father
> [1898655.285909] cp              D 0000000000000000     0 20090  20083
> 0x00000000
> [1898655.285913]  ffff8804252b7bd8 0000000000000086 ffff880424334df0
> ffff8804252b6010
> [1898655.285917]  0000000000011180 0000000000011180 ffff8804252b7fd8
> ffff8804252b7fd8
> [1898655.285920]  0000000000011180 ffff8804248aa280 000000011c498cd4
> ffffffff81a0b020
> [1898655.285924] Call Trace:
> [1898655.285939]  [<ffffffff81441bbc>] io_schedule+0x9c/0xf0
> [1898655.285946]  [<ffffffff810ef999>] sleep_on_page_killable+0x9/0x40
> [1898655.285950]  [<ffffffff810efa66>] __lock_page_killable+0x96/0xd0
> [1898655.285954]  [<ffffffff810f0c57>] do_generic_file_read+0x227/0x490
> [1898655.285959]  [<ffffffff810f151c>] generic_file_aio_read+0xfc/0x260
> [1898655.285977]  [<ffffffffa04a4cf1>] nfs_file_read+0xf1/0x140 [nfs]
> [1898655.285996]  [<ffffffff8114fea0>] do_sync_read+0xc0/0x100
> [1898655.286000]  [<ffffffff81150647>] vfs_read+0xc7/0x130
> [1898655.286004]  [<ffffffff811507b3>] sys_read+0x53/0xa0
> [1898655.286009]  [<ffffffff8144b692>] system_call_fastpath+0x16/0x1b
> [1898655.286026]  [<00007f243130b1a0>] 0x7f243130b19f
> 
> 
> It's likely that the process that had acquired a lock on the page has
> already excited.
> 
> I see a similar report in the cache-fs mailing list
> 
> https://www.redhat.com/archives/linux-cachefs/2012-August/msg00000.html
> 
> I haven't enabled fscache and cachefiles debugging, yet. Before doing
> so, I thought I'll just check whether you see the problem and if it
> sounds familiar to you.
> 

Here's the debug log (fscache, cachefiles debugging along with nfs debugging
enabled) as promised. The file being copied is of size 4k (just to avoid
spamming of the logs).

It does look like fscache_read_or_alloc_pages() succeeded and the read has
been submitted to the cache for all pages via nfs_getpages_from_fscache().
However, it seems like the backpage monitor has not been woken up and the lock
on the page has not been released. Any further access that will require access
to the page will hang. Any clues where the problem could be? 

--snip--
[57655.776270] [kworke] ==> cachefiles_read_waiter({49},3,0,{ffff8804206317b0,2})
[57655.776285] [kworke] ==> cachefiles_read_waiter({36},3,0,{ffffea000e5d6d08,14})
[57655.776300] [kworke] ==> cachefiles_read_waiter({188},3,0,{ffffea000e722890,14})
[57655.776312] [kworke] ==> cachefiles_read_waiter({49},3,0,{ffff880420737e30,2})
[57657.761450] [kjourn] ==> cachefiles_read_waiter({0},3,0,{ffff88043efc1b58,22})
[57659.104009] nfs4_renew_state: start
[57659.104017] nfs4_renew_state: done
[57659.104029] encode_compound: tag=
[57659.104420] nfs4_schedule_state_renewal: requeueing work. Lease period = 60
[57659.104424] --> nfs_put_client({2})
[57659.105748] [kjourn] ==> cachefiles_read_waiter({0},3,0,{ffff88043efc1b58,22})
[57659.106443] [kworke] ==> cachefiles_read_waiter({144},3,0,{ffffea000e4a3fa0,14})
[57659.106581] [kjourn] ==> cachefiles_read_waiter({138},3,0,{ffff88043ef9ecf8,22})
[57659.106740] [kworke] ==> cachefiles_read_waiter({144},3,0,{ffffea000e4a3fa0,14})
[57659.106948] [syslog] ==> cachefiles_read_waiter({49},3,0,{ffff880420737e30,2})
[57672.144140] encode_compound: tag=
[57672.144898] [kworke] ==> cachefiles_read_waiter({144},3,0,{ffffea000e4a3fa0,14})
[57672.145192] [kjourn] ==> cachefiles_read_waiter({0},3,0,{ffff88043efc1b58,22})
[57672.165747] decode_attr_type: type=040000
[57672.165751] decode_attr_change: change attribute=904841240255817254
[57672.165753] decode_attr_size: file size=4096
[57672.165756] decode_attr_fsid: fsid=(0x8570e9a0a0c043f1/0x8e0c41ceba6133c4)
[57672.165758] decode_attr_fileid: fileid=2
[57672.165761] decode_attr_fs_locations: fs_locations done, error = 0
[57672.165763] decode_attr_mode: file mode=0777
[57672.165765] decode_attr_nlink: nlink=12
[57672.165768] decode_attr_owner: uid=0
[57672.165770] decode_attr_group: gid=0
[57672.165772] decode_attr_rdev: rdev=(0x0:0x0)
[57672.165774] decode_attr_space_used: space used=4096
[57672.165776] decode_attr_time_access: atime=1352954468
[57672.165778] decode_attr_time_metadata: ctime=1352961548
[57672.165780] decode_attr_time_modify: mtime=1352961548
[57672.165782] decode_attr_mounted_on_fileid: fileid=0
[57672.165783] decode_getfattr_attrs: xdr returned 0
[57672.165785] decode_getfattr_generic: xdr returned 0
[57672.165795] NFS: nfs_update_inode(0:15/2 ct=2 info=0x27e7f)
[57672.165798] NFS: change_attr change on server for file 0:15/2
[57672.165800] NFS: mtime change on server for file 0:15/2
[57672.165807] NFS: permission(0:15/2), mask=0x1, res=0
[57672.165812] NFS: atomic_lookup(0:15/2), f_4
[57672.165814] NFS: lookup(//f_4)
[57672.165825] NFS call  lookup f_4
[57672.165827] NFS call  lookupfh f_4
[57672.165837] encode_compound: tag=
[57672.166127] decode_attr_type: type=0100000
[57672.166131] decode_attr_change: change attribute=904841240255817254
[57672.166134] decode_attr_size: file size=4096
[57672.166136] decode_attr_fsid: fsid=(0x8570e9a0a0c043f1/0x8e0c41ceba6133c4)
[57672.166139] decode_attr_fileid: fileid=43
[57672.166141] decode_attr_fs_locations: fs_locations done, error = 0
[57672.166143] decode_attr_mode: file mode=0644
[57672.166145] decode_attr_nlink: nlink=1
[57672.166148] decode_attr_owner: uid=1000
[57672.166150] decode_attr_group: gid=100
[57672.166153] decode_attr_rdev: rdev=(0x0:0x0)
[57672.166155] decode_attr_space_used: space used=4096
[57672.166157] decode_attr_time_access: atime=1352961548
[57672.166159] decode_attr_time_metadata: ctime=1352961548
[57672.166160] decode_attr_time_modify: mtime=1352961548
[57672.166162] decode_attr_mounted_on_fileid: fileid=0
[57672.166164] decode_getfattr_attrs: xdr returned 0
[57672.166166] decode_getfattr_generic: xdr returned 0
[57672.166174] NFS reply lookupfh: 0
[57672.166176] NFS reply lookup: 0
[57672.166185] NFS: nfs_fhget(0:15/43 ct=1)
[57672.166194] NFS: dentry_delete(//f_4, c010)
[57672.166249] encode_compound: tag=
[57672.166570] decode_attr_type: type=040000
[57672.166573] decode_attr_change: change attribute=904841240255817254
[57672.166575] decode_attr_size: file size=4096
[57672.166578] decode_attr_fsid: fsid=(0x8570e9a0a0c043f1/0x8e0c41ceba6133c4)
[57672.166580] decode_attr_fileid: fileid=2
[57672.166582] decode_attr_fs_locations: fs_locations done, error = 0
[57672.166584] decode_attr_mode: file mode=0777
[57672.166586] decode_attr_nlink: nlink=12
[57672.166588] decode_attr_owner: uid=0
[57672.166590] decode_attr_group: gid=0
[57672.166591] decode_attr_rdev: rdev=(0x0:0x0)
[57672.166593] decode_attr_space_used: space used=4096
[57672.166595] decode_attr_time_access: atime=1352954468
[57672.166597] decode_attr_time_metadata: ctime=1352961548
[57672.166599] decode_attr_time_modify: mtime=1352961548
[57672.166601] decode_attr_mounted_on_fileid: fileid=0
[57672.166603] decode_getfattr_attrs: xdr returned 0
[57672.166604] decode_getfattr_generic: xdr returned 0
[57672.166610] NFS: nfs_update_inode(0:15/2 ct=2 info=0x27e7f)
[57672.166616] NFS: permission(0:15/2), mask=0x1, res=0
[57672.166633] <-- nfs4_setup_sequence status=0
[57672.166637] encode_compound: tag=
[57672.167007] decode_attr_type: type=0100000
[57672.167010] decode_attr_change: change attribute=904841240255817254
[57672.167013] decode_attr_size: file size=4096
[57672.167015] decode_attr_fsid: fsid=(0x8570e9a0a0c043f1/0x8e0c41ceba6133c4)
[57672.167017] decode_attr_fileid: fileid=43
[57672.167020] decode_attr_fs_locations: fs_locations done, error = 0
[57672.167022] decode_attr_mode: file mode=0644
[57672.167024] decode_attr_nlink: nlink=1
[57672.167026] decode_attr_owner: uid=-2
[57672.167028] decode_attr_group: gid=-2
[57672.167030] decode_attr_rdev: rdev=(0x0:0x0)
[57672.167032] decode_attr_space_used: space used=4096
[57672.167034] decode_attr_time_access: atime=1352961548
[57672.167036] decode_attr_time_metadata: ctime=1352961548
[57672.167038] decode_attr_time_modify: mtime=1352961548
[57672.167040] decode_attr_mounted_on_fileid: fileid=0
[57672.167041] decode_getfattr_attrs: xdr returned 0
[57672.167043] decode_getfattr_generic: xdr returned 0
[57672.167045] decode_attr_type: type=040000
[57672.167047] decode_attr_change: change attribute=904841240255817254
[57672.167049] decode_attr_size: file size=4096
[57672.167051] decode_attr_fsid: fsid=(0x8570e9a0a0c043f1/0x8e0c41ceba6133c4)
[57672.167053] decode_attr_fileid: fileid=2
[57672.167055] decode_attr_fs_locations: fs_locations done, error = 0
[57672.167057] decode_attr_mode: file mode=0777
[57672.167058] decode_attr_nlink: nlink=12
[57672.167060] decode_attr_owner: uid=-2
[57672.167062] decode_attr_group: gid=-2
[57672.167063] decode_attr_rdev: rdev=(0x0:0x0)
[57672.167065] decode_attr_space_used: space used=4096
[57672.167067] decode_attr_time_access: atime=1352954468
[57672.167069] decode_attr_time_metadata: ctime=1352961548
[57672.167071] decode_attr_time_modify: mtime=1352961548
[57672.167072] decode_attr_mounted_on_fileid: fileid=0
[57672.167074] decode_getfattr_attrs: xdr returned 0
[57672.167081] decode_getfattr_generic: xdr returned 0
[57672.167102] NFS: nfs_update_inode(0:15/2 ct=2 info=0x27e67)
[57672.167106] NFS: nfs_update_inode(0:15/43 ct=3 info=0x27e67)
[57672.167108] NFS: nfs_fhget(0:15/43 ct=3)
[57672.167119] [cp    ] ==> __fscache_acquire_cookie({NFS.super},{NFS.fh},ffff8804204c12c0)
[57672.167123] [cp    ] ==> fscache_acquire_non_index_cookie()
[57672.167125] [cp    ] ==> fscache_select_cache_for_object()
[57672.167128] [cp    ] <== fscache_select_cache_for_object() = ffff880421088800 [parent]
[57672.167131] [cp    ] cache mycache
[57672.167133] [cp    ] ==> fscache_alloc_object(ffff880421088800,ffff880421240858{NFS.fh})
[57672.167137] [cp    ] ==> cachefiles_alloc_object({sda3},ffff880421240858,)
[57672.167141] [cp    ] ==> cachefiles_cook_key(,30)
[57672.167143] [cp    ] max: 53
[57672.167145] [cp    ] acc: 01001c
[57672.167147] [cp    ] acc: 010600
[57672.167148] [cp    ] acc: e97085
[57672.167150] [cp    ] acc: c0a0a0
[57672.167152] [cp    ] acc: 8ef143
[57672.167153] [cp    ] acc: ce410c
[57672.167155] [cp    ] acc: 3361ba
[57672.167156] [cp    ] acc: 002bc4
[57672.167158] [cp    ] acc: 090000
[57672.167160] [cp    ] acc: dd9aad
[57672.167162] [cp    ] <== cachefiles_cook_key() = ffff880426abff40 46
[57672.167165] [cp    ] <== cachefiles_alloc_object() = ffff880425336680 [ffff880421b6ccc0]
[57672.167168] [cp    ] ALLOC OBJa: NFS.fh {0}
[57672.167170] [cp    ] ==> fscache_alloc_object(ffff880421088800,ffff880421240270{NFS.super})
[57672.167172] [cp    ] <== fscache_alloc_object() = 0 [found]
[57672.167175] [cp    ] ==> fscache_attach_object({NFS.fh},{OBJa})
[57672.167178] [cp    ] <== fscache_attach_object() = 0
[57672.167180] [cp    ] <== fscache_alloc_object() = 0
[57672.167183] [cp    ] ==> fscache_enqueue_object({OBJa})
[57672.167186] [cp    ] ==> cachefiles_grab_object({OBJa,1})
[57672.167190] [cp    ] <== fscache_acquire_non_index_cookie() = 0 [deferred]
[57672.167193] [cp    ] <== __fscache_acquire_cookie() = ffff880421240858
[57672.167211] [kworke] ==> fscache_object_work_func({OBJa})
[57672.167220] [kworke] ==> fscache_object_state_machine({OBJa,OBJECT_INIT,0})
[57672.167229] NFS: get FH cookie (0xffff88042203dc00/0xffff8804204c12c0/0xffff880421240858)
[57672.167240] [kworke] ==> fscache_initialise_object()
[57672.167247] [kworke] parent OBJECT_ACTIVE
[57672.167250] NFS: permission(0:15/43), mask=0x24, res=0
[57672.167257] [kworke] go
[57672.167259] [kworke] <== fscache_initialise_object()
[57672.167260] [kworke] <== fscache_object_state_machine() [->OBJECT_LOOKING_UP]
[57672.167263] [kworke] ==> fscache_enqueue_object({OBJa})
[57672.167266] [kworke] ==> cachefiles_grab_object({OBJa,2})
[57672.167272] [kworke] ==> cachefiles_put_object({OBJa,3})
[57672.167274] [kworke] <== cachefiles_put_object()
[57672.167276] [kworke] ==> fscache_object_work_func({OBJa})
[57672.167278] [kworke] ==> fscache_object_state_machine({OBJa,OBJECT_LOOKING_UP,0})
[57672.167281] [kworke] ==> fscache_lookup_object()
[57672.167283] [kworke] LOOKUP "NFS.super/NFS.fh" in "mycache"
[57672.167285] [kworke] ==> cachefiles_lookup_object({OBJa})
[57672.167288] [kworke] ==> cachefiles_walk_to_object(OBJ2{ffff880424fc5600},OBJa,@49,)
[57672.167291] [kworke] lookup '@49'
[57672.167301] [kworke] next -> ffff88043ef45800 negative
[57672.167303] [kworke] ==> fscache_object_lookup_negative({OBJa,OBJECT_LOOKING_UP})
[57672.167305] [kworke] wake up lookup ffff880421240898
[57672.167307] [kworke] <== fscache_object_lookup_negative()
[57672.167351] NFS: read(//f_4, 524288@0)
[57672.167356] NFS: nfs_readpages (0:15/43 1)
[57672.167359] NFS: nfs_getpages_from_fscache (0xffff880421240858/1/0xffff8804204c1488)
[57672.167362] [cp    ] ==> __fscache_read_or_alloc_pages(ffff880421240858,,1,,,)
[57672.167364] [cp    ] ==> fscache_wait_for_deferred_lookup()
[57672.167366] [cp    ] <== fscache_wait_for_deferred_lookup() = 0 [imm]
[57672.167371] [cp    ] ==> fscache_submit_op({OBJa OP1a},{1})
[57672.167374] [cp    ] >>> WT
[57672.194018] [kworke] mkdir -> ffff88043ef45800{ffff88043ed5fda0{ino=697704}}
[57672.194020] [kworke] advance
[57672.194022] [kworke] lookup 'Es0g00og052nWw2aM35Lzc4APW6Sc4L2000g2JGpT'
[57672.194027] [kworke] next -> ffff88042070ed40 negative
[57672.194029] [kworke] ==> fscache_object_lookup_negative({OBJa,OBJECT_CREATING})
[57672.194032] [kworke] <== fscache_object_lookup_negative()
[57672.194044] [kworke] create -> ffff88042070ed40{ffff88043ed5fa70{ino=697705}}
[57672.194047] [kworke] ==> cachefiles_mark_object_active(,ffff880425336680)
[57672.194050] [kworke] <== cachefiles_mark_object_active() = 0
[57672.194051] [kworke] === OBTAINED_OBJECT ===
[57672.194054] [kworke] ==> cachefiles_set_object_xattr(ffff880425336680,#49)
[57672.194057] [kworke] SET NFS.fh #49
[57672.194065] [kworke] <== cachefiles_set_object_xattr() = 0
[57672.194068] [kworke] ==> fscache_obtained_object({OBJa,OBJECT_CREATING})
[57672.194070] [kworke] <== fscache_obtained_object()
[57672.194072] [kworke] <== cachefiles_walk_to_object() = 0 [697705]
[57672.194075] [kworke] ==> cachefiles_attr_changed({OBJa},[4096])
[57672.194102] [kworke] <== cachefiles_attr_changed() = 0
[57672.194104] [kworke] <== cachefiles_lookup_object() [0]
[57672.194106] [kworke] <== fscache_lookup_object()
[57672.194107] [kworke] <== fscache_object_state_machine() [->OBJECT_AVAILABLE]
[57672.194109] [kworke] ==> fscache_enqueue_object({OBJa})
[57672.194111] [kworke] ==> cachefiles_grab_object({OBJa,2})
[57672.194115] [kworke] ==> cachefiles_put_object({OBJa,3})
[57672.194117] [kworke] <== cachefiles_put_object()
[57672.194120] [kworke] ==> fscache_object_work_func({OBJa})
[57672.194122] [kworke] ==> fscache_object_state_machine({OBJa,OBJECT_AVAILABLE,0})
[57672.194124] [kworke] ==> fscache_object_available({OBJa})
[57672.194126] [kworke] ==> fscache_done_parent_op(OBJa {OBJ2,1})
[57672.194131] [kworke] ==> fscache_put_operation({OBJa OP1a,2})
[57672.194137] [kworke] woke 1 ops on OBJa
[57672.194139] [kworke] ==> cachefiles_lookup_complete({OBJa,ffff880421b6ccc0})
[57672.194147] [cp    ] <<< GO
[57672.194154] [cp    ] ==> cachefiles_allocate_pages(ffff880425336680,,,1,)
[57672.194163] [kworke] ==> fscache_enqueue_dependents({OBJa})
[57672.194170] [kworke] <== fscache_object_available()
[57672.194177] [kworke] <== fscache_object_state_machine() [->OBJECT_ACTIVE]
[57672.194187] [kworke] ==> cachefiles_put_object({OBJa,2})
[57672.194189] [kworke] <== cachefiles_put_object()
[57672.194191] [cp    ] - mark ffffea000e6d38a0{0}
[57672.194193] [cp    ] <== cachefiles_allocate_pages() = -61
[57672.194195] [cp    ] ==> fscache_put_operation({OBJa OP1a,1})
[57672.194202] [cp    ] PUT OP
[57672.194204] [cp    ] ==> fscache_release_retrieval_op({OP1a})
[57672.194206] [cp    ] <== fscache_release_retrieval_op()
[57672.194208] [cp    ] woke 0 ops on OBJa
[57672.194210] [cp    ] <== fscache_put_operation() [done]
[57672.194212] [cp    ] <== __fscache_read_or_alloc_pages() = -61
[57672.194213] NFS: nfs_getpages_from_fscache: no page: -61
[57672.194224] NFS:     0 initiated read call (req 0:15/43, 4096 bytes @ offset 0)
[57672.194232] <-- nfs4_setup_sequence status=0
[57672.194237] encode_compound: tag=
[57672.194737] NFS: nfs_readpage_result:   396, (status 4096)
[57672.194741] --> nfs4_read_done
[57672.194752] NFS: readpage_to_fscache(fsc:ffff880421240858/p:ffffea000e6d38a0(i:0 f:20000000002013)/0)
[57672.194756] [kworke] ==> __fscache_write_page(ffff880421240858,2013,)
[57672.194759] [kworke] store limit 1
[57672.194762] [kworke] ==> fscache_submit_op({OBJa OP1c},{1})
[57672.194766] [kworke] ==> fscache_enqueue_operation({OBJa OP1c,1})
[57672.194769] [kworke] queue async
[57672.194774] [kworke] ==> fscache_put_operation({OBJa OP1c,2})
[57672.194777] [kworke] <== __fscache_write_page() = 0
[57672.194779] NFS:     readpage_to_fscache: p:ffffea000e6d38a0(i:0 f:20000000002013) ret 0
[57672.194784] [kworke] ==> fscache_op_work_func({OBJa OP1c,1})
[57672.194788] [kworke] ==> fscache_write_op({OP1c,1})
[57672.194792] [kworke] gang 1 [0]
[57672.194796] [kworke] ==> cachefiles_write_page(ffff880425336680,ffffea000e6d38a0{0},,,)
[57672.194805] [kworke] ==> cachefiles_read_waiter({169},3,0,{ffffea000e6d38a0,0})
[57672.194817] NFS: nfs_readpage (ffffea000e6d36e0 4096@1)
[57672.194840] NFS: read done (0:15/43 4096@0)
[57672.194845] NFS: readpage_from_fscache(fsc:ffff880421240858/p:ffffea000e6d36e0(i:1 f:20000000000001)/0xffff8804204c1488)
[57672.194867] [cp    ] ==> __fscache_read_or_alloc_page(ffff880421240858,ffffea000e6d36e0,,,)
[57672.194880] [cp    ] ==> fscache_wait_for_deferred_lookup()
[57672.194895] [cp    ] <== fscache_wait_for_deferred_lookup() = 0 [imm]
[57672.194904] [cp    ] ==> fscache_submit_op({OBJa OP1d},{1})
[57672.194908] [cp    ] ==> cachefiles_allocate_page(ffff880425336680,{1},)
[57672.194910] [cp    ] - mark ffffea000e6d36e0{1}
[57672.194912] [cp    ] <== cachefiles_allocate_page() = 0
[57672.194914] [cp    ] ==> fscache_put_operation({OBJa OP1d,1})
[57672.194915] [cp    ] PUT OP
[57672.194917] [cp    ] ==> fscache_release_retrieval_op({OP1d})
[57672.194919] [cp    ] <== fscache_release_retrieval_op()
[57672.194921] [cp    ] <== fscache_put_operation() [done]
[57672.194922] [cp    ] <== __fscache_read_or_alloc_page() = -61
[57672.194924] NFS:    readpage_from_fscache -61
[57672.194926] [kworke] <== cachefiles_write_page() = 4096
[57672.194935] [kworke] ==> fscache_enqueue_operation({OBJa OP1c,1})
[57672.194937] [kworke] queue async
[57672.194941] [kworke] <== fscache_write_op()
[57672.194943] [kworke] ==> fscache_put_operation({OBJa OP1c,2})
[57672.194945] [kworke] <== fscache_op_work_func()
[57672.194947] [kworke] ==> fscache_op_work_func({OBJa OP1c,1})
[57672.194949] [kworke] ==> fscache_write_op({OP1c,1})
[57672.194951] [kworke] cease
[57672.194952] [kworke] <== fscache_write_op()
[57672.194954] [kworke] ==> fscache_put_operation({OBJa OP1c,1})
[57672.194956] [kworke] PUT OP
[57672.194957] [kworke] ==> fscache_release_write_op({OP1c})
[57672.194959] [kworke] woke 0 ops on OBJa
[57672.194961] [kworke] <== fscache_put_operation() [done]
[57672.194962] [kworke] <== fscache_op_work_func()
[57672.194983] NFS: read(//f_4, 524288@4096)
[57672.194989] NFS: flush(//f_4)
[57672.194990] NFS: release(//f_4)
[57672.195002] <-- nfs4_setup_sequence status=0
[57672.195008] encode_compound: tag=
[57672.195334] decode_attr_type: type=00
[57672.195337] decode_attr_change: change attribute=904841240255817254
[57672.195339] decode_attr_size: file size=4096
[57672.195341] decode_attr_fsid: fsid=(0x0/0x0)
[57672.195342] decode_attr_fileid: fileid=0
[57672.195344] decode_attr_fs_locations: fs_locations done, error = 0
[57672.195346] decode_attr_mode: file mode=00
[57672.195348] decode_attr_nlink: nlink=1
[57672.195350] decode_attr_owner: uid=-2
[57672.195351] decode_attr_group: gid=-2
[57672.195353] decode_attr_rdev: rdev=(0x0:0x0)
[57672.195354] decode_attr_space_used: space used=0
[57672.195356] decode_attr_time_access: atime=0
[57672.195358] decode_attr_time_metadata: ctime=1352961548
[57672.195360] decode_attr_time_modify: mtime=1352961548
[57672.195362] decode_attr_mounted_on_fileid: fileid=0
[57672.195363] decode_getfattr_attrs: xdr returned 0
[57672.195365] decode_getfattr_generic: xdr returned 0
[57672.195370] NFS: nfs_update_inode(0:15/43 ct=2 info=0x26040)
[57672.195389] NFS: dentry_delete(//f_4, c018)
[57672.204327] [swappe] ==> cachefiles_read_waiter({144},3,0,{ffffea000e4a3fa0,14})
[57672.204632] [kjourn] ==> cachefiles_read_waiter({138},3,0,{ffff88043ef9ecf8,22})
[57672.204642] [kjourn] ==> cachefiles_read_waiter({0},3,0,{ffff88043efc1b58,22})
[57672.204847] [swappe] ==> cachefiles_read_waiter({144},3,0,{ffffea000e4a3fa0,14})
[57672.205146] [swappe] ==> cachefiles_read_waiter({144},3,0,{ffffea000e4a3fa0,14})
[57672.205462] [swappe] ==> cachefiles_read_waiter({144},3,0,{ffffea000e4a3fa0,14})
[57672.205758] [swappe] ==> cachefiles_read_waiter({144},3,0,{ffffea000e4a3fa0,14})
[57672.206038] [swappe] ==> cachefiles_read_waiter({144},3,0,{ffffea000e4a3fa0,14})
[57672.206325] [swappe] ==> cachefiles_read_waiter({144},3,0,{ffffea000e4a3fa0,14})
[57672.206619] [swappe] ==> cachefiles_read_waiter({144},3,0,{ffffea000e4a3fa0,14})
[57672.206890] [swappe] ==> cachefiles_read_waiter({144},3,0,{ffffea000e4a3fa0,14})
[57672.207175] [swappe] ==> cachefiles_read_waiter({144},3,0,{ffffea000e4a3fa0,14})
[57672.207855] [swappe] ==> cachefiles_read_waiter({144},3,0,{ffffea000e4a3fa0,14})
[57672.208058] [kjourn] ==> cachefiles_read_waiter({0},3,0,{ffff88043efc1b58,22})
[57672.208219] [swappe] ==> cachefiles_read_waiter({144},3,0,{ffffea000e4a3fa0,14})
[57672.208518] [swappe] ==> cachefiles_read_waiter({144},3,0,{ffffea000e4a3fa0,14})
[57672.208808] [swappe] ==> cachefiles_read_waiter({144},3,0,{ffffea000e4a3fa0,14})
[57672.209089] [swappe] ==> cachefiles_read_waiter({144},3,0,{ffffea000e4a3fa0,14})
[57672.209388] [swappe] ==> cachefiles_read_waiter({144},3,0,{ffffea000e4a3fa0,14})
[57672.209692] [swappe] ==> cachefiles_read_waiter({144},3,0,{ffffea000e4a3fa0,14})
[57672.209989] [swappe] ==> cachefiles_read_waiter({144},3,0,{ffffea000e4a3fa0,14})
[57672.210255] [swappe] ==> cachefiles_read_waiter({144},3,0,{ffffea000e4a3fa0,14})
[57672.210539] [swappe] ==> cachefiles_read_waiter({144},3,0,{ffffea000e4a3fa0,14})
[57672.210814] [syslog] ==> cachefiles_read_waiter({49},3,0,{ffff880420737e30,2})
[57672.211233] [swappe] ==> cachefiles_read_waiter({144},3,0,{ffffea000e4a3fa0,14})
[57672.211501] [kjourn] ==> cachefiles_read_waiter({0},3,0,{ffff88043efc1b58,22})
[57672.211674] [swappe] ==> cachefiles_read_waiter({144},3,0,{ffffea000e4a3fa0,14})
[57672.211952] [swappe] ==> cachefiles_read_waiter({144},3,0,{ffffea000e4a3fa0,14})
[57672.212241] [swappe] ==> cachefiles_read_waiter({144},3,0,{ffffea000e4a3fa0,14})
[57672.212527] [swappe] ==> cachefiles_read_waiter({144},3,0,{ffffea000e4a3fa0,14})
[57672.212805] [swappe] ==> cachefiles_read_waiter({144},3,0,{ffffea000e4a3fa0,14})
[57672.213093] [swappe] ==> cachefiles_read_waiter({144},3,0,{ffffea000e4a3fa0,14})
[57672.213389] [swappe] ==> cachefiles_read_waiter({144},3,0,{ffffea000e4a3fa0,14})
[57672.213661] [swappe] ==> cachefiles_read_waiter({144},3,0,{ffffea000e4a3fa0,14})
[57672.213961] [swappe] ==> cachefiles_read_waiter({144},3,0,{ffffea000e4a3fa0,14})
[57672.214631] [swappe] ==> cachefiles_read_waiter({144},3,0,{ffffea000e4a3fa0,14})
[57672.214833] [kjourn] ==> cachefiles_read_waiter({0},3,0,{ffff88043efc1b58,22})
[57672.214993] [swappe] ==> cachefiles_read_waiter({144},3,0,{ffffea000e4a3fa0,14})
[57672.215290] [swappe] ==> cachefiles_read_waiter({144},3,0,{ffffea000e4a3fa0,14})
[57672.215573] [swappe] ==> cachefiles_read_waiter({144},3,0,{ffffea000e4a3fa0,14})
[57672.215853] [swappe] ==> cachefiles_read_waiter({144},3,0,{ffffea000e4a3fa0,14})
[57672.216134] [swappe] ==> cachefiles_read_waiter({144},3,0,{ffffea000e4a3fa0,14})
[57672.216428] [swappe] ==> cachefiles_read_waiter({144},3,0,{ffffea000e4a3fa0,14})
[57672.216730] [swappe] ==> cachefiles_read_waiter({144},3,0,{ffffea000e4a3fa0,14})
[57672.217000] [swappe] ==> cachefiles_read_waiter({144},3,0,{ffffea000e4a3fa0,14})
[57672.217288] [swappe] ==> cachefiles_read_waiter({144},3,0,{ffffea000e4a3fa0,14})
[57672.217950] [swappe] ==> cachefiles_read_waiter({144},3,0,{ffffea000e4a3fa0,14})
[57672.218147] [kjourn] ==> cachefiles_read_waiter({0},3,0,{ffff88043efc1b58,22})
[57672.218305] [swappe] ==> cachefiles_read_waiter({144},3,0,{ffffea000e4a3fa0,14})
[57672.218589] [swappe] ==> cachefiles_read_waiter({144},3,0,{ffffea000e4a3fa0,14})
[57672.218886] [swappe] ==> cachefiles_read_waiter({144},3,0,{ffffea000e4a3fa0,14})
[57672.219171] [swappe] ==> cachefiles_read_waiter({144},3,0,{ffffea000e4a3fa0,14})
[57672.219468] [swappe] ==> cachefiles_read_waiter({144},3,0,{ffffea000e4a3fa0,14})
[57672.219798] [swappe] ==> cachefiles_read_waiter({144},3,0,{ffffea000e4a3fa0,14})
[57672.219958] [kjourn] ==> cachefiles_read_waiter({138},3,0,{ffff88043ef9ecf8,22})
[57672.221562] [kjourn] ==> cachefiles_read_waiter({0},3,0,{ffff88043efc1b58,22})
[57672.224837] [kjourn] ==> cachefiles_read_waiter({0},3,0,{ffff88043efc1b58,22})
[57672.227491] [syslog] ==> cachefiles_read_waiter({49},3,0,{ffff880420737e30,2})
[57672.228134] [kjourn] ==> cachefiles_read_waiter({0},3,0,{ffff88043efc1b58,22})
[57672.231410] [kjourn] ==> cachefiles_read_waiter({0},3,0,{ffff88043efc1b58,22})
[57672.233550] [kjourn] ==> cachefiles_read_waiter({107},3,0,{ffff8804204b3f68,2})
[57672.233629] [kworke] ==> cachefiles_read_waiter({107},3,0,{ffff8804204b3f68,2})
[57672.233847] [kjourn] ==> cachefiles_read_waiter({247},3,0,{ffff8804204b3e98,2})
[57672.233926] [kworke] ==> cachefiles_read_waiter({247},3,0,{ffff8804204b3e98,2})
[57672.233936] [kworke] ==> cachefiles_read_waiter({49},3,0,{ffff8804204b3e30,2})
[57672.233958] [kjourn] ==> cachefiles_read_waiter({49},3,0,{ffff8804204b3e30,2})
[57672.234051] [kworke] ==> cachefiles_read_waiter({49},3,0,{ffff8804204b3e30,2})
[57672.234706] [kjourn] ==> cachefiles_read_waiter({0},3,0,{ffff88043efc1b58,22})
[57672.235880] [kworke] ==> cachefiles_read_waiter({18},3,0,{ffff8804204b3af0,2})
[57672.235888] [kworke] ==> cachefiles_read_waiter({86},3,0,{ffff8804204b3a88,2})
[57672.235896] [kworke] ==> cachefiles_read_waiter({59},3,0,{ffff8804204b3a20,2})
[57672.235919] [kjourn] ==> cachefiles_read_waiter({138},3,0,{ffff88043ef9ecf8,22})
[57672.235933] [kjourn] ==> cachefiles_read_waiter({18},3,0,{ffff8804204b3af0,2})
[57672.236010] [kworke] ==> cachefiles_read_waiter({18},3,0,{ffff8804204b3af0,2})
[57672.236143] [kjourn] ==> cachefiles_read_waiter({185},3,0,{ffff8804204b3950,2})
[57672.236231] [kworke] ==> cachefiles_read_waiter({185},3,0,{ffff8804204b3950,2})
[57672.236244] [kworke] ==> cachefiles_read_waiter({107},3,0,{ffff8804204b38e8,2})
[57672.236265] [kjourn] ==> cachefiles_read_waiter({107},3,0,{ffff8804204b38e8,2})
[57672.236334] [kworke] ==> cachefiles_read_waiter({107},3,0,{ffff8804204b38e8,2})
[57672.236530] [kworke] ==> cachefiles_read_waiter({247},3,0,{ffff8804204b3818,2})
[57672.236551] [kjourn] ==> cachefiles_read_waiter({247},3,0,{ffff8804204b3818,2})
[57672.236629] [kworke] ==> cachefiles_read_waiter({247},3,0,{ffff8804204b3818,2})
[57672.236737] [kjourn] ==> cachefiles_read_waiter({49},3,0,{ffff8804204b37b0,2})
[57672.236846] [kworke] ==> cachefiles_read_waiter({49},3,0,{ffff8804204b37b0,2})
[57672.238043] [kjourn] ==> cachefiles_read_waiter({86},3,0,{ffff8804204b3a88,2})
[57672.238132] [kworke] ==> cachefiles_read_waiter({86},3,0,{ffff8804204b3a88,2})
[57672.238144] [kworke] ==> cachefiles_read_waiter({59},3,0,{ffff8804204b3a20,2})
[57672.238156] [kjourn] ==> cachefiles_read_waiter({0},3,0,{ffff88043efc1b58,22})
[57672.238166] [kjourn] ==> cachefiles_read_waiter({59},3,0,{ffff8804204b3a20,2})
[57672.238235] [kworke] ==> cachefiles_read_waiter({59},3,0,{ffff8804204b3a20,2})
[57672.238645] [kjourn] ==> cachefiles_read_waiter({18},3,0,{ffff8804204b3470,2})
[57672.238725] [kworke] ==> cachefiles_read_waiter({18},3,0,{ffff8804204b3470,2})
[57672.238735] [kworke] ==> cachefiles_read_waiter({86},3,0,{ffff8804204b3408,2})
[57672.238759] [kjourn] ==> cachefiles_read_waiter({86},3,0,{ffff8804204b3408,2})
[57672.238827] [kworke] ==> cachefiles_read_waiter({86},3,0,{ffff8804204b3408,2})
[57672.238936] [kjourn] ==> cachefiles_read_waiter({59},3,0,{ffff8804204b33a0,2})
[57672.239024] [kworke] ==> cachefiles_read_waiter({59},3,0,{ffff8804204b33a0,2})
[57672.239223] [kjourn] ==> cachefiles_read_waiter({185},3,0,{ffff8804204b32d0,2})
[57672.239323] [kworke] ==> cachefiles_read_waiter({185},3,0,{ffff8804204b32d0,2})
[57672.239331] [kworke] ==> cachefiles_read_waiter({107},3,0,{ffff8804204b3268,2})
[57672.239353] [kjourn] ==> cachefiles_read_waiter({107},3,0,{ffff8804204b3268,2})
[57672.239422] [kworke] ==> cachefiles_read_waiter({107},3,0,{ffff8804204b3268,2})
[57672.239618] [kworke] ==> cachefiles_read_waiter({247},3,0,{ffff8804204b3198,2})
[57672.239645] [kjourn] ==> cachefiles_read_waiter({247},3,0,{ffff8804204b3198,2})
[57672.239715] [kworke] ==> cachefiles_read_waiter({247},3,0,{ffff8804204b3198,2})
[57672.239839] [kjourn] ==> cachefiles_read_waiter({49},3,0,{ffff8804204b3130,2})
[57672.239918] [kworke] ==> cachefiles_read_waiter({49},3,0,{ffff8804204b3130,2})
[57672.241432] [kjourn] ==> cachefiles_read_waiter({0},3,0,{ffff88043efc1b58,22})
[57672.241561] [syslog] ==> cachefiles_read_waiter({49},3,0,{ffff880420737e30,2})
[57672.242726] [kjourn] ==> cachefiles_read_waiter({0},3,0,{ffff88043efc1b58,22})
[57672.243952] [kjourn] ==> cachefiles_read_waiter({0},3,0,{ffff88043efc1b58,22})
[57672.244643] [syslog] ==> cachefiles_read_waiter({49},3,0,{ffff880420737e30,2})
[57672.245686] [syslog] ==> cachefiles_read_waiter({49},3,0,{ffff880420737e30,2})
[57672.246578] [kjourn] ==> cachefiles_read_waiter({0},3,0,{ffff88043efc1b58,22})
[57672.248926] [kjourn] ==> cachefiles_read_waiter({0},3,0,{ffff88043efc1b58,22})
[57672.249595] [kjourn] ==> cachefiles_read_waiter({0},3,0,{ffff88043efc1b58,22})
[57672.250314] [syslog] ==> cachefiles_read_waiter({49},3,0,{ffff880420737e30,2})
[57672.251140] [kjourn] ==> cachefiles_read_waiter({0},3,0,{ffff88043efc1b58,22})
[57672.251803] [kjourn] ==> cachefiles_read_waiter({0},3,0,{ffff88043efc1b58,22})
[57672.253074] [kjourn] ==> cachefiles_read_waiter({0},3,0,{ffff88043efc1b58,22})
[57672.253927] [kworke] ==> cachefiles_read_waiter({107},3,0,{ffff880420494f68,2})
[57672.253949] [kjourn] ==> cachefiles_read_waiter({107},3,0,{ffff880420494f68,2})
[57672.254018] [kworke] ==> cachefiles_read_waiter({107},3,0,{ffff880420494f68,2})
[57672.254222] [kworke] ==> cachefiles_read_waiter({247},3,0,{ffff880420494e98,2})
[57672.254243] [kjourn] ==> cachefiles_read_waiter({247},3,0,{ffff880420494e98,2})
[57672.254316] [kworke] ==> cachefiles_read_waiter({247},3,0,{ffff880420494e98,2})
[57672.254430] [kjourn] ==> cachefiles_read_waiter({49},3,0,{ffff880420494e30,2})
[57672.254518] [kworke] ==> cachefiles_read_waiter({49},3,0,{ffff880420494e30,2})
[57672.255565] [kjourn] ==> cachefiles_read_waiter({18},3,0,{ffff880420494af0,2})
[57672.255643] [kworke] ==> cachefiles_read_waiter({18},3,0,{ffff880420494af0,2})
[57672.255657] [kworke] ==> cachefiles_read_waiter({86},3,0,{ffff880420494a88,2})
[57672.255688] [kjourn] ==> cachefiles_read_waiter({86},3,0,{ffff880420494a88,2})
[57672.255757] [kworke] ==> cachefiles_read_waiter({86},3,0,{ffff880420494a88,2})
[57672.256479] [kjourn] ==> cachefiles_read_waiter({138},3,0,{ffff88043ef9ecf8,22})
[57672.256488] [kjourn] ==> cachefiles_read_waiter({0},3,0,{ffff88043efc1b58,22})
[57672.256702] [kjourn] ==> cachefiles_read_waiter({59},3,0,{ffff880420494a20,2})
[57672.256782] [kworke] ==> cachefiles_read_waiter({59},3,0,{ffff880420494a20,2})
[57672.256998] [kjourn] ==> cachefiles_read_waiter({185},3,0,{ffff880420494950,2})
[57672.257076] [kworke] ==> cachefiles_read_waiter({185},3,0,{ffff880420494950,2})
[57672.257085] [kworke] ==> cachefiles_read_waiter({107},3,0,{ffff8804204948e8,2})
[57672.257109] [kjourn] ==> cachefiles_read_waiter({107},3,0,{ffff8804204948e8,2})
[57672.257184] [kworke] ==> cachefiles_read_waiter({107},3,0,{ffff8804204948e8,2})
[57672.257378] [kworke] ==> cachefiles_read_waiter({247},3,0,{ffff880420494818,2})
[57672.257395] [kjourn] ==> cachefiles_read_waiter({247},3,0,{ffff880420494818,2})
[57672.257464] [kworke] ==> cachefiles_read_waiter({247},3,0,{ffff880420494818,2})
[57672.257572] [kjourn] ==> cachefiles_read_waiter({49},3,0,{ffff8804204947b0,2})
[57672.257673] [kworke] ==> cachefiles_read_waiter({49},3,0,{ffff8804204947b0,2})
[57672.258702] [kjourn] ==> cachefiles_read_waiter({18},3,0,{ffff880420494470,2})
[57672.258787] [kworke] ==> cachefiles_read_waiter({18},3,0,{ffff880420494470,2})
[57672.258801] [kworke] ==> cachefiles_read_waiter({86},3,0,{ffff880420494408,2})
[57672.258819] [kjourn] ==> cachefiles_read_waiter({86},3,0,{ffff880420494408,2})
[57672.258887] [kworke] ==> cachefiles_read_waiter({86},3,0,{ffff880420494408,2})
[57672.258995] [kjourn] ==> cachefiles_read_waiter({59},3,0,{ffff8804204943a0,2})
[57672.259082] [kworke] ==> cachefiles_read_waiter({59},3,0,{ffff8804204943a0,2})
[57672.259224] [syslog] ==> cachefiles_read_waiter({49},3,0,{ffff880420737e30,2})
[57672.259831] [kjourn] ==> cachefiles_read_waiter({0},3,0,{ffff88043efc1b58,22})
[57672.260062] [kjourn] ==> cachefiles_read_waiter({185},3,0,{ffff8804204942d0,2})
[57672.260141] [kworke] ==> cachefiles_read_waiter({185},3,0,{ffff8804204942d0,2})
[57672.260151] [kworke] ==> cachefiles_read_waiter({107},3,0,{ffff880420494268,2})
[57672.260172] [kjourn] ==> cachefiles_read_waiter({107},3,0,{ffff880420494268,2})
[57672.260246] [kworke] ==> cachefiles_read_waiter({107},3,0,{ffff880420494268,2})
[57672.261069] [syslog] ==> cachefiles_read_waiter({49},3,0,{ffff880420737e30,2})
[57672.262091] [syslog] ==> cachefiles_read_waiter({49},3,0,{ffff880420737e30,2})
[57672.263102] [syslog] ==> cachefiles_read_waiter({49},3,0,{ffff880420737e30,2})
[57672.264130] [syslog] ==> cachefiles_read_waiter({49},3,0,{ffff880420737e30,2})
[57672.265143] [syslog] ==> cachefiles_read_waiter({49},3,0,{ffff880420737e30,2})
[57672.266157] [syslog] ==> cachefiles_read_waiter({49},3,0,{ffff880420737e30,2})
[57672.267170] [syslog] ==> cachefiles_read_waiter({49},3,0,{ffff880420737e30,2})
[57672.268199] [syslog] ==> cachefiles_read_waiter({49},3,0,{ffff880420737e30,2})
[57672.269387] [syslog] ==> cachefiles_read_waiter({49},3,0,{ffff880420737e30,2})
[57672.270399] [syslog] ==> cachefiles_read_waiter({49},3,0,{ffff880420737e30,2})
[57672.271408] [syslog] ==> cachefiles_read_waiter({49},3,0,{ffff880420737e30,2})
[57672.272431] [syslog] ==> cachefiles_read_waiter({49},3,0,{ffff880420737e30,2})
[57675.776030] [flush-] ==> cachefiles_read_waiter({70},3,0,{ffffea000e642900,14})
[57675.776285] [klogd ] ==> cachefiles_read_waiter({1},3,0,{ffffea000e4b4dc8,14})
[57675.776317] [klogd ] ==> cachefiles_read_waiter({9},3,0,{ffffea000e723f88,14})
[57675.776536] [syslog] ==> cachefiles_read_waiter({49},3,0,{ffff880420737e30,2})
[57675.805952] [kworke] ==> cachefiles_read_waiter({179},3,0,{ffffea000e63fd40,14})
[57675.805960] [kworke] ==> cachefiles_read_waiter({108},3,0,{ffffea000e41dd78,14})
[57676.048039] NFS: nfs_lookup_revalidate(///) is valid
[57676.048047] NFS: permission(0:15/2), mask=0x1, res=0
[57676.048049] NFS: nfs_lookup_revalidate(///) is valid
[57676.048470] NFS: permission(0:15/2), mask=0x1, res=0
[57676.048472] NFS: nfs_lookup_revalidate(///) is valid
[57676.048805] [drop_c] ==> cachefiles_read_waiter({247},3,0,{ffff880420741198,2})
[57676.048812] [drop_c] ==> cachefiles_read_waiter({247},3,0,{ffff880420741198,2})
[57676.049668] [flush-] ==> cachefiles_read_waiter({235},3,0,{ffffea000e542568,14})
[57676.049718] [flush-] ==> cachefiles_read_waiter({49},3,0,{ffff880420737e30,2})
[57676.049961] [kworke] ==> cachefiles_read_waiter({9},3,0,{ffffea000e723f88,14})
[57676.049991] [kworke] ==> cachefiles_read_waiter({0},3,0,{ffffea000e5bf1f0,14})
[57676.050039] [kjourn] ==> cachefiles_read_waiter({247},3,0,{ffff880420494198,2})
[57676.050216] [kjourn] ==> cachefiles_read_waiter({0},3,0,{ffff88043efc1b58,22})
[57676.050249] [kworke] ==> cachefiles_read_waiter({247},3,0,{ffff880420494198,2})
[57676.050257] [kworke] ==> cachefiles_read_waiter({49},3,0,{ffff880420494130,2})
[57676.050297] [kjourn] ==> cachefiles_read_waiter({49},3,0,{ffff880420494130,2})
[57676.050378] [kworke] ==> cachefiles_read_waiter({49},3,0,{ffff880420494130,2})
[57676.060436] [sync  ] ==> cachefiles_read_waiter({49},3,0,{ffff880420737e30,2})
[57676.060453] [sync  ] ==> cachefiles_read_waiter({247},3,0,{ffff880420741198,2})
[57676.068518] [kjourn] ==> cachefiles_read_waiter({0},3,0,{ffff88043efc1b58,22})
[57676.068946] [kjourn] ==> cachefiles_read_waiter({0},3,0,{ffff88043efc1b58,22})
[57676.069168] [syslog] ==> cachefiles_read_waiter({49},3,0,{ffff880420737e30,2})
[57676.071808] [kjourn] ==> cachefiles_read_waiter({0},3,0,{ffff88043efc1b58,22})
[57676.072051] [sync  ] ==> cachefiles_read_waiter({49},3,0,{ffff880420737e30,2})
[57676.096426] NFS: release_page(ffffea000e6d38a0)
[57676.096431] NFS: fscache releasepage (0xffff880421240858/0xffffea000e6d38a0/0xffff8804204c12c0)
[57676.096435] [drop_c] ==> __fscache_maybe_release_page(ffff880421240858,ffffea000e6d38a0,0)
[57676.096438] [drop_c] ==> __fscache_uncache_page(,ffffea000e6d38a0)
[57676.096442] [drop_c] ==> cachefiles_uncache_page(ffff880425336680,{0})
[57676.096443] [drop_c] <== __fscache_uncache_page()
[57676.096446] NFS: release_page(ffffea000e6d36e0)
[57676.096448] NFS: fscache releasepage (0xffff880421240858/0xffffea000e6d36e0/0xffff8804204c12c0)
[57676.096450] [drop_c] ==> __fscache_maybe_release_page(ffff880421240858,ffffea000e6d36e0,0)
[57676.096452] [drop_c] ==> __fscache_uncache_page(,ffffea000e6d36e0)
[57676.096454] [drop_c] ==> cachefiles_uncache_page(ffff880425336680,{1})
[57676.096456] [drop_c] <== __fscache_uncache_page()
[57676.098433] [kjourn] ==> cachefiles_read_waiter({0},3,0,{ffff88043efc1b58,22})
[57676.099229] [syslog] ==> cachefiles_read_waiter({49},3,0,{ffff880420737e30,2})
[57676.114190] NFS: clear cookie (0xffff880424dcdb30/0x          (null))
[57676.114195] NFS: clear cookie (0xffff880424dcd718/0x          (null))
[57676.114198] NFS: clear cookie (0xffff880424dcd300/0x          (null))
[57676.114200] NFS: clear cookie (0xffff8804206bfb70/0x          (null))
[57676.114203] NFS: clear cookie (0xffff8804206bf758/0x          (null))
[57676.114205] NFS: clear cookie (0xffff8804206bf340/0x          (null))
[57676.114207] NFS: clear cookie (0xffff880424e18870/0x          (null))
[57676.114210] NFS: clear cookie (0xffff880424e18458/0x          (null))
[57676.114212] NFS: clear cookie (0xffff880424e18040/0x          (null))
[57676.114214] NFS: clear cookie (0xffff8804206fd8b0/0x          (null))
[57676.114217] NFS: clear cookie (0xffff8804206fd498/0x          (null))
[57676.114219] NFS: clear cookie (0xffff8804206fd080/0x          (null))
[57676.114221] NFS: clear cookie (0xffff880424e9a8f0/0x          (null))
[57676.114224] NFS: clear cookie (0xffff880424e9a4d8/0x          (null))
[57676.114226] NFS: clear cookie (0xffff880424e9a0c0/0x          (null))
[57676.114228] NFS: clear cookie (0xffff8804207a2930/0x          (null))
[57676.114231] NFS: clear cookie (0xffff8804207a2518/0x          (null))
[57676.114233] NFS: clear cookie (0xffff88043ed6c970/0x          (null))
[57676.114236] NFS: clear cookie (0xffff88043ed6c558/0x          (null))
[57676.114238] NFS: clear cookie (0xffff88043ed6c140/0x          (null))
[57676.114262] NFS: clear cookie (0xffff8804204c12c0/0xffff880421240858)
[57676.114266] [drop_c] ==> __fscache_relinquish_cookie(ffff880421240858{NFS.fh,ffff8804204c12c0},0)
[57676.114268] [drop_c] RELEASE OBJa
[57676.114271] [drop_c] ==> fscache_enqueue_object({OBJa})
[57676.114274] [drop_c] ==> cachefiles_grab_object({OBJa,1})
[57676.114280] [drop_c] ==> __fscache_cookie_put(ffff880421240858)
[57676.114281] [drop_c] FREE COOKIE ffff880421240858
[57676.114286] [kworke] ==> fscache_object_work_func({OBJa})
[57676.114287] [drop_c] <== __fscache_cookie_put()
[57676.114289] [drop_c] <== __fscache_relinquish_cookie()
[57676.114294] [kworke] ==> fscache_object_state_machine({OBJa,OBJECT_ACTIVE,14})
[57676.114296] [kworke] <== fscache_object_state_machine() [->OBJECT_DYING]
[57676.114298] [kworke] ==> fscache_enqueue_object({OBJa})
[57676.114301] [kworke] ==> cachefiles_grab_object({OBJa,2})
[57676.114306] [kworke] ==> cachefiles_put_object({OBJa,3})
[57676.114308] [kworke] <== cachefiles_put_object()
[57676.114310] [kworke] ==> fscache_object_work_func({OBJa})
[57676.114312] [kworke] ==> fscache_object_state_machine({OBJa,OBJECT_DYING,14})
[57676.114314] [kworke] dying OBJa {0,0}
[57676.114316] [kworke] ==> fscache_enqueue_dependents({OBJa})
[57676.114318] [kworke] woke 0 ops on OBJa
[57676.114320] [kworke] <== fscache_object_state_machine() [->OBJECT_RELEASING]
[57676.114322] [kworke] ==> fscache_enqueue_object({OBJa})
[57676.114324] [kworke] ==> cachefiles_grab_object({OBJa,2})
[57676.114328] [kworke] ==> cachefiles_put_object({OBJa,3})
[57676.114329] [kworke] <== cachefiles_put_object()
[57676.114333] [kworke] ==> fscache_object_work_func({OBJa})
[57676.114335] [kworke] ==> fscache_object_state_machine({OBJa,OBJECT_RELEASING,10})
[57676.114337] [kworke] ==> fscache_release_object()
[57676.114339] [kworke] ==> fscache_drop_object({OBJa,0})
[57676.114341] [kworke] ==> cachefiles_drop_object({OBJa,2})
[57676.114344] [kworke] <== cachefiles_drop_object()
[57676.114346] [kworke] release parent OBJ2 {4}
[57676.114348] [kworke] ==> cachefiles_put_object({OBJa,2})
[57676.114349] [kworke] <== cachefiles_put_object()
[57676.114351] [kworke] <== fscache_drop_object()
[57676.114353] [kworke] <== fscache_object_state_machine() [->OBJECT_DEAD]
[57676.114355] [kworke] ==> cachefiles_put_object({OBJa,1})
[57676.114356] [kworke] - kill object OBJa
[57676.114358] [kworke] <== cachefiles_put_object()
[57676.114359] <-- nfs4_setup_sequence status=0
[57676.114374] encode_compound: tag=
[57676.114833] decode_attr_type: type=0100000
[57676.114836] decode_attr_change: change attribute=904841240255817254
[57676.114838] decode_attr_size: file size=4096
[57676.114840] decode_attr_fsid: fsid=(0x8570e9a0a0c043f1/0x8e0c41ceba6133c4)
[57676.114842] decode_attr_fileid: fileid=43
[57676.114844] decode_attr_fs_locations: fs_locations done, error = 0
[57676.114847] decode_attr_mode: file mode=0644
[57676.114848] decode_attr_nlink: nlink=1
[57676.114850] decode_attr_owner: uid=-2
[57676.114852] decode_attr_group: gid=-2
[57676.114854] decode_attr_rdev: rdev=(0x0:0x0)
[57676.114855] decode_attr_space_used: space used=4096
[57676.114857] decode_attr_time_access: atime=1352961557
[57676.114859] decode_attr_time_metadata: ctime=1352961548
[57676.114861] decode_attr_time_modify: mtime=1352961548
[57676.114863] decode_attr_mounted_on_fileid: fileid=0
[57676.114865] decode_getfattr_attrs: xdr returned 0
[57676.114866] decode_getfattr_generic: xdr returned 0
[57676.150142] [kjourn] ==> cachefiles_read_waiter({0},3,0,{ffff88043efc1b58,22})
[57676.151357] [kjourn] ==> cachefiles_read_waiter({247},3,0,{ffff880420735e98,2})
[57676.151435] [kworke] ==> cachefiles_read_waiter({247},3,0,{ffff880420735e98,2})
[57676.151445] [kworke] ==> cachefiles_read_waiter({185},3,0,{ffff880420735950,2})
[57676.151465] [kjourn] ==> cachefiles_read_waiter({185},3,0,{ffff880420735950,2})
[57676.151546] [kworke] ==> cachefiles_read_waiter({185},3,0,{ffff880420735950,2})
[57676.151774] [kworke] ==> cachefiles_read_waiter({18},3,0,{ffff880420735af0,2})
[57676.151793] [kjourn] ==> cachefiles_read_waiter({18},3,0,{ffff880420735af0,2})
[57676.151867] [kworke] ==> cachefiles_read_waiter({18},3,0,{ffff880420735af0,2})
[57676.151970] [kjourn] ==> cachefiles_read_waiter({247},3,0,{ffff88042066be98,2})
[57676.152052] [kworke] ==> cachefiles_read_waiter({247},3,0,{ffff88042066be98,2})
[57676.152232] [kjourn] ==> cachefiles_read_waiter({107},3,0,{ffff880420735268,2})
[57676.152308] [kworke] ==> cachefiles_read_waiter({107},3,0,{ffff880420735268,2})
[57676.153299] [kjourn] ==> cachefiles_read_waiter({0},3,0,{ffff88043efc1b58,22})
[57676.153801] [kworke] ==> cachefiles_read_waiter({59},3,0,{ffff880420510a20,2})
[57676.153827] [kjourn] ==> cachefiles_read_waiter({59},3,0,{ffff880420510a20,2})
[57676.153907] [kworke] ==> cachefiles_read_waiter({59},3,0,{ffff880420510a20,2})
[57676.154074] [kworke] ==> cachefiles_read_waiter({18},3,0,{ffff880420510af0,2})
[57676.154094] [kjourn] ==> cachefiles_read_waiter({18},3,0,{ffff880420510af0,2})
[57676.154174] [kworke] ==> cachefiles_read_waiter({18},3,0,{ffff880420510af0,2})
[57676.156217] [kjourn] ==> cachefiles_read_waiter({0},3,0,{ffff88043efc1b58,22})
[57676.156336] [syslog] ==> cachefiles_read_waiter({49},3,0,{ffff880420737e30,2})
[57676.159863] [kjourn] ==> cachefiles_read_waiter({0},3,0,{ffff88043eefeb58,22})
[57676.159873] [kjourn] ==> cachefiles_read_waiter({138},3,0,{ffff88043ef9ecf8,22})
[57676.159884] [kjourn] ==> cachefiles_read_waiter({0},3,0,{ffff88043efc1b58,22})
[57676.162306] [syslog] ==> cachefiles_read_waiter({49},3,0,{ffff880420737e30,2})
[57676.162918] [kjourn] ==> cachefiles_read_waiter({0},3,0,{ffff88043efc1b58,22})
[57676.166302] [syslog] ==> cachefiles_read_waiter({49},3,0,{ffff880420737e30,2})
[57676.167302] [syslog] ==> cachefiles_read_waiter({49},3,0,{ffff880420737e30,2})
[57676.286881] [kworke] ==> cachefiles_read_waiter({214},3,0,{ffffea000e367800,0})
[57676.310903] [kworke] ==> cachefiles_read_waiter({49},3,0,{ffff88042074fe30,2})
[57676.355065] [kworke] ==> cachefiles_read_waiter({247},3,0,{ffff880420606198,2})
[57676.390347] [flush-] ==> cachefiles_read_waiter({49},3,0,{ffff880420737e30,2})
[57676.396690] [kworke] ==> cachefiles_read_waiter({53},3,0,{ffffea000e5a43e0,14})
[57676.396932] [kjourn] ==> cachefiles_read_waiter({0},3,0,{ffff88043efc1b58,22})
[57676.397158] [kworke] ==> cachefiles_read_waiter({49},3,0,{ffff880420737e30,2})
[57676.397369] [kjourn] ==> cachefiles_read_waiter({0},3,0,{ffff88043efc1b58,22})
[57678.676688] [kworke] ==> cachefiles_read_waiter({185},3,0,{ffff8804206062d0,2})
[57678.677015] [syslog] ==> cachefiles_read_waiter({49},3,0,{ffff880420737e30,2})
[57678.701643] [kworke] ==> cachefiles_read_waiter({107},3,0,{ffffea000e400db8,0})
[57678.729954] [kworke] ==> cachefiles_read_waiter({148},3,0,{ffffea000e415d10,0})
[57678.750859] [kworke] ==> cachefiles_read_waiter({111},3,0,{ffffea000e6d3be8,0})
[57678.767271] NFS: permission(0:15/2), mask=0x1, res=0
[57678.767274] NFS: atomic_lookup(0:15/2), f_4
[57678.767276] NFS: lookup(//f_4)
[57678.767279] NFS call  lookup f_4
[57678.767281] NFS call  lookupfh f_4
[57678.767287] encode_compound: tag=
[57678.767666] decode_attr_type: type=0100000
[57678.767669] decode_attr_change: change attribute=904841240255817254
[57678.767671] decode_attr_size: file size=4096
[57678.767673] decode_attr_fsid: fsid=(0x8570e9a0a0c043f1/0x8e0c41ceba6133c4)
[57678.767675] decode_attr_fileid: fileid=43
[57678.767677] decode_attr_fs_locations: fs_locations done, error = 0
[57678.767679] decode_attr_mode: file mode=0644
[57678.767681] decode_attr_nlink: nlink=1
[57678.767684] decode_attr_owner: uid=1000
[57678.767685] decode_attr_group: gid=100
[57678.767687] decode_attr_rdev: rdev=(0x0:0x0)
[57678.767689] decode_attr_space_used: space used=4096
[57678.767691] decode_attr_time_access: atime=1352961557
[57678.767693] decode_attr_time_metadata: ctime=1352961548
[57678.767695] decode_attr_time_modify: mtime=1352961548
[57678.767696] decode_attr_mounted_on_fileid: fileid=0
[57678.767698] decode_getfattr_attrs: xdr returned 0
[57678.767700] decode_getfattr_generic: xdr returned 0
[57678.767704] NFS reply lookupfh: 0
[57678.767706] NFS reply lookup: 0
[57678.767711] NFS: nfs_fhget(0:15/43 ct=1)
[57678.767716] NFS: dentry_delete(//f_4, c010)
[57678.767736] NFS: permission(0:15/2), mask=0x1, res=0
[57678.767747] <-- nfs4_setup_sequence status=0
[57678.767755] encode_compound: tag=
[57678.768079] decode_attr_type: type=0100000
[57678.768082] decode_attr_change: change attribute=904841240255817254
[57678.768084] decode_attr_size: file size=4096
[57678.768086] decode_attr_fsid: fsid=(0x8570e9a0a0c043f1/0x8e0c41ceba6133c4)
[57678.768089] decode_attr_fileid: fileid=43
[57678.768091] decode_attr_fs_locations: fs_locations done, error = 0
[57678.768094] decode_attr_mode: file mode=0644
[57678.768096] decode_attr_nlink: nlink=1
[57678.768098] decode_attr_owner: uid=-2
[57678.768100] decode_attr_group: gid=-2
[57678.768102] decode_attr_rdev: rdev=(0x0:0x0)
[57678.768104] decode_attr_space_used: space used=4096
[57678.768106] decode_attr_time_access: atime=1352961557
[57678.768108] decode_attr_time_metadata: ctime=1352961548
[57678.768109] decode_attr_time_modify: mtime=1352961548
[57678.768111] decode_attr_mounted_on_fileid: fileid=0
[57678.768113] decode_getfattr_attrs: xdr returned 0
[57678.768115] decode_getfattr_generic: xdr returned 0
[57678.768117] decode_attr_type: type=040000
[57678.768119] decode_attr_change: change attribute=904841240255817254
[57678.768121] decode_attr_size: file size=4096
[57678.768123] decode_attr_fsid: fsid=(0x8570e9a0a0c043f1/0x8e0c41ceba6133c4)
[57678.768125] decode_attr_fileid: fileid=2
[57678.768127] decode_attr_fs_locations: fs_locations done, error = 0
[57678.768129] decode_attr_mode: file mode=0777
[57678.768130] decode_attr_nlink: nlink=12
[57678.768132] decode_attr_owner: uid=-2
[57678.768133] decode_attr_group: gid=-2
[57678.768135] decode_attr_rdev: rdev=(0x0:0x0)
[57678.768137] decode_attr_space_used: space used=4096
[57678.768138] decode_attr_time_access: atime=1352954468
[57678.768140] decode_attr_time_metadata: ctime=1352961548
[57678.768142] decode_attr_time_modify: mtime=1352961548
[57678.768144] decode_attr_mounted_on_fileid: fileid=0
[57678.768146] decode_getfattr_attrs: xdr returned 0
[57678.768147] decode_getfattr_generic: xdr returned 0
[57678.768179] NFS: nfs_update_inode(0:15/2 ct=2 info=0x27e67)
[57678.768182] NFS: nfs_update_inode(0:15/43 ct=3 info=0x27e67)
[57678.768184] NFS: nfs_fhget(0:15/43 ct=3)
[57678.768189] [cp    ] ==> __fscache_acquire_cookie({NFS.super},{NFS.fh},ffff8804207a2100)
[57678.768192] [cp    ] ==> fscache_acquire_non_index_cookie()
[57678.768194] [cp    ] ==> fscache_select_cache_for_object()
[57678.768196] [cp    ] <== fscache_select_cache_for_object() = ffff880421088800 [parent]
[57678.768198] [cp    ] cache mycache
[57678.768200] [cp    ] ==> fscache_alloc_object(ffff880421088800,ffff880421240e40{NFS.fh})
[57678.768203] [cp    ] ==> cachefiles_alloc_object({sda3},ffff880421240e40,)
[57678.768205] [cp    ] ==> cachefiles_cook_key(,30)
[57678.768207] [cp    ] max: 53
[57678.768208] [cp    ] acc: 01001c
[57678.768210] [cp    ] acc: 010600
[57678.768211] [cp    ] acc: e97085
[57678.768212] [cp    ] acc: c0a0a0
[57678.768214] [cp    ] acc: 8ef143
[57678.768215] [cp    ] acc: ce410c
[57678.768216] [cp    ] acc: 3361ba
[57678.768217] [cp    ] acc: 002bc4
[57678.768218] [cp    ] acc: 090000
[57678.768220] [cp    ] acc: dd9aad
[57678.768221] [cp    ] <== cachefiles_cook_key() = ffff880421850200 46
[57678.768224] [cp    ] <== cachefiles_alloc_object() = ffff880425336800 [ffff88042145f600]
[57678.768226] [cp    ] ALLOC OBJb: NFS.fh {0}
[57678.768228] [cp    ] ==> fscache_alloc_object(ffff880421088800,ffff880421240270{NFS.super})
[57678.768230] [cp    ] <== fscache_alloc_object() = 0 [found]
[57678.768232] [cp    ] ==> fscache_attach_object({NFS.fh},{OBJb})
[57678.768234] [cp    ] <== fscache_attach_object() = 0
[57678.768236] [cp    ] <== fscache_alloc_object() = 0
[57678.768238] [cp    ] ==> fscache_enqueue_object({OBJb})
[57678.768240] [cp    ] ==> cachefiles_grab_object({OBJb,1})
[57678.768244] [cp    ] <== fscache_acquire_non_index_cookie() = 0 [deferred]
[57678.768250] [cp    ] <== __fscache_acquire_cookie() = ffff880421240e40
[57678.768252] NFS: get FH cookie (0xffff88042203dc00/0xffff8804207a2100/0xffff880421240e40)
[57678.768260] [kworke] ==> fscache_object_work_func({OBJb})
[57678.768272] [kworke] ==> fscache_object_state_machine({OBJb,OBJECT_INIT,0})
[57678.768284] [kworke] ==> fscache_initialise_object()
[57678.768293] [kworke] parent OBJECT_ACTIVE
[57678.768298] NFS: permission(0:15/43), mask=0x24, res=0
[57678.768306] [kworke] go
[57678.768308] [kworke] <== fscache_initialise_object()
[57678.768311] [kworke] <== fscache_object_state_machine() [->OBJECT_LOOKING_UP]
[57678.768315] [kworke] ==> fscache_enqueue_object({OBJb})
[57678.768318] [kworke] ==> cachefiles_grab_object({OBJb,2})
[57678.768324] [kworke] ==> cachefiles_put_object({OBJb,3})
[57678.768327] [kworke] <== cachefiles_put_object()
[57678.768331] [kworke] ==> fscache_object_work_func({OBJb})
[57678.768334] [kworke] ==> fscache_object_state_machine({OBJb,OBJECT_LOOKING_UP,0})
[57678.768337] [kworke] ==> fscache_lookup_object()
[57678.768341] [kworke] LOOKUP "NFS.super/NFS.fh" in "mycache"
[57678.768344] [kworke] ==> cachefiles_lookup_object({OBJb})
[57678.768348] [kworke] ==> cachefiles_walk_to_object(OBJ2{ffff880424fc5600},OBJb,@49,)
[57678.768352] [kworke] lookup '@49'
[57678.768359] NFS: read(//f_4, 524288@0)
[57678.768366] NFS: nfs_readpages (0:15/43 1)
[57678.768374] [kworke] next -> ffff88043ef45800 positive
[57678.768382] [kworke] advance
[57678.768388] [kworke] lookup 'Es0g00og052nWw2aM35Lzc4APW6Sc4L2000g2JGpT'
[57678.768400] [kworke] next -> ffff88042070ed40 positive
[57678.768409] NFS: nfs_getpages_from_fscache (0xffff880421240e40/1/0xffff8804207a22c8)
[57678.768419] [cp    ] ==> __fscache_read_or_alloc_pages(ffff880421240e40,,1,,,)
[57678.768439] [cp    ] ==> fscache_wait_for_deferred_lookup()
[57678.768448] [kworke] validate 'Es0g00og052nWw2aM35Lzc4APW6Sc4L2000g2JGpT'
[57678.768452] [kworke] ==> cachefiles_check_object_xattr(ffff880425336800,#49)
[57678.768537] [klogd ] ==> cachefiles_read_waiter({247},3,0,{ffff880420601e98,2})
[57678.768541] [kworke] checkaux NFS.fh #48
[57678.768546] [kworke] <== cachefiles_check_object_xattr() = 0
[57678.768549] [kworke] ==> cachefiles_mark_object_active(,ffff880425336800)
[57678.768555] [kworke] <== cachefiles_mark_object_active() = 0
[57678.768556] [kworke] === OBTAINED_OBJECT ===
[57678.768562] [kworke] ==> cachefiles_read_waiter({247},3,0,{ffff880420601e98,2})
[57678.768572] [kworke] ==> cachefiles_read_waiter({247},3,0,{ffff880420601e98,2})
[57678.768583] [kworke] ==> fscache_obtained_object({OBJb,OBJECT_LOOKING_UP})
[57678.768593] [kworke] <== fscache_obtained_object()
[57678.768595] [kworke] <== cachefiles_walk_to_object() = 0 [697705]
[57678.768602] [cp    ] <== fscache_wait_for_deferred_lookup() = 0 [dly]
[57678.768613] [cp    ] ==> fscache_submit_op({OBJb OP1e},{1})
[57678.768622] [kworke] ==> cachefiles_attr_changed({OBJb},[4096])
[57678.768633] [cp    ] ==> cachefiles_read_or_alloc_pages({OBJb,1},,1,,)
[57678.768642] [kworke] <== cachefiles_lookup_object() [0]
[57678.768648] [cp    ] 0 -> 2a9007
[57678.768654] [cp    ] ==> cachefiles_read_backing_file()
[57678.768662] [cp    ] read back ffffea000e631f38{0,1}
[57678.768669] [kworke] <== fscache_lookup_object()
[57678.768678] [cp    ] - new ffffea000e6d3248
[57678.768684] [kworke] <== fscache_object_state_machine() [->OBJECT_AVAILABLE]
[57678.768688] [kworke] ==> fscache_enqueue_object({OBJb})
[57678.768696] [cp    ] - monitor add
[57678.768702] [kworke] ==> cachefiles_grab_object({OBJb,2})
[57678.768712] [cp    ] out
[57678.768718] [cp    ] <== cachefiles_read_backing_file() = 0
[57678.768726] [kworke] ==> cachefiles_put_object({OBJb,3})
[57678.768736] [kworke] <== cachefiles_put_object()
[57678.768744] [cp    ] <== cachefiles_read_or_alloc_pages() = 0 [nr=0 empty]
[57678.768754] [kworke] ==> fscache_object_work_func({OBJb})
[57678.768763] [kworke] ==> fscache_object_state_machine({OBJb,OBJECT_AVAILABLE,0})
[57678.768776] [kworke] ==> fscache_object_available({OBJb})
[57678.768786] [kworke] ==> fscache_done_parent_op(OBJb {OBJ2,1})
[57678.768796] [kworke] ==> cachefiles_lookup_complete({OBJb,ffff88042145f600})
[57678.768809] [kworke] ==> fscache_enqueue_dependents({OBJb})
[57678.768828] [cp    ] ==> fscache_put_operation({OBJb OP1e,2})
[57678.768841] [cp    ] <== __fscache_read_or_alloc_pages() = 0
[57678.768849] NFS: nfs_getpages_from_fscache: submitted
[57678.768856] [kworke] <== fscache_object_available()
[57678.768859] [kworke] <== fscache_object_state_machine() [->OBJECT_ACTIVE]
[57678.768863] [kworke] ==> cachefiles_put_object({OBJb,2})
[57678.768870] [kworke] <== cachefiles_put_object()
[57678.784436] [kjourn] ==> cachefiles_read_waiter({138},3,0,{ffff88043ef9ecf8,22})
[57678.784449] [kjourn] ==> cachefiles_read_waiter({0},3,0,{ffff88043efc1b58,22})
[57678.804279] [kjourn] ==> cachefiles_read_waiter({0},3,0,{ffff88043efc1b58,22})
[57678.804499] [kjourn] ==> cachefiles_read_waiter({49},3,0,{ffff880420601e30,2})
[57678.804578] [kworke] ==> cachefiles_read_waiter({49},3,0,{ffff880420601e30,2})
[57678.804588] [kworke] ==> cachefiles_read_waiter({59},3,0,{ffff880420601a20,2})
[57678.804610] [kjourn] ==> cachefiles_read_waiter({59},3,0,{ffff880420601a20,2})
[57678.804696] [kworke] ==> cachefiles_read_waiter({59},3,0,{ffff880420601a20,2})
[57678.806831] [kworke] ==> cachefiles_read_waiter({86},3,0,{ffff880420606a88,2})
[57678.806853] [kjourn] ==> cachefiles_read_waiter({86},3,0,{ffff880420606a88,2})
[57678.806928] [kworke] ==> cachefiles_read_waiter({86},3,0,{ffff880420606a88,2})
[57678.807570] [kjourn] ==> cachefiles_read_waiter({0},3,0,{ffff88043efc1b58,22})
[57678.807758] [kjourn] ==> cachefiles_read_waiter({107},3,0,{ffff88042074f8e8,2})
[57678.807848] [kworke] ==> cachefiles_read_waiter({107},3,0,{ffff88042074f8e8,2})
[57678.808046] [kjourn] ==> cachefiles_read_waiter({86},3,0,{ffff880420606408,2})
[57678.808141] [kworke] ==> cachefiles_read_waiter({86},3,0,{ffff880420606408,2})
[57678.808641] [kjourn] ==> cachefiles_read_waiter({86},3,0,{ffff880420523408,2})
[57678.808719] [kworke] ==> cachefiles_read_waiter({86},3,0,{ffff880420523408,2})
[57678.810189] [kworke] ==> cachefiles_read_waiter({18},3,0,{ffff880420523470,2})
[57678.810205] [kjourn] ==> cachefiles_read_waiter({0},3,0,{ffff88043eefeb58,22})
[57678.810213] [kjourn] ==> cachefiles_read_waiter({138},3,0,{ffff88043ef9ecf8,22})
[57678.810919] [kworke] ==> cachefiles_read_waiter({18},3,0,{ffff880420523470,2})
[57678.810938] [kjourn] ==> cachefiles_read_waiter({0},3,0,{ffff88043efc1b58,22})
[57678.811662] [kjourn] ==> cachefiles_read_waiter({59},3,0,{ffff8804205233a0,2})
[57678.811746] [kworke] ==> cachefiles_read_waiter({59},3,0,{ffff8804205233a0,2})
[57678.812211] [kjourn] ==> cachefiles_read_waiter({86},3,0,{ffff880420558408,2})
[57678.812290] [kworke] ==> cachefiles_read_waiter({86},3,0,{ffff880420558408,2})
[57678.813521] [syslog] ==> cachefiles_read_waiter({49},3,0,{ffff880420737e30,2})
[57678.814097] [kjourn] ==> cachefiles_read_waiter({18},3,0,{ffff880420523470,2})
[57678.814215] [kworke] ==> cachefiles_read_waiter({18},3,0,{ffff880420523470,2})
[57678.814235] [kjourn] ==> cachefiles_read_waiter({0},3,0,{ffff88043efc1b58,22})
[57678.814735] [kjourn] ==> cachefiles_read_waiter({49},3,0,{ffff8804205587b0,2})
[57678.814813] [kworke] ==> cachefiles_read_waiter({49},3,0,{ffff8804205587b0,2})
[57678.815104] [kworke] ==> cachefiles_read_waiter({107},3,0,{ffff880420558268,2})
[57678.815126] [kjourn] ==> cachefiles_read_waiter({107},3,0,{ffff880420558268,2})
[57678.815202] [kworke] ==> cachefiles_read_waiter({107},3,0,{ffff880420558268,2})
[57678.817514] [kjourn] ==> cachefiles_read_waiter({0},3,0,{ffff88043efc1b58,22})
[57678.818055] [kworke] ==> cachefiles_read_waiter({18},3,0,{ffff880420558470,2})
[57678.818073] [kjourn] ==> cachefiles_read_waiter({18},3,0,{ffff880420558470,2})
[57678.818143] [kworke] ==> cachefiles_read_waiter({18},3,0,{ffff880420558470,2})
[57678.820694] [kjourn] ==> cachefiles_read_waiter({0},3,0,{ffff88043efc1b58,22})
[57678.821153] [kjourn] ==> cachefiles_read_waiter({185},3,0,{ffff880420523950,2})
[57678.821236] [kworke] ==> cachefiles_read_waiter({185},3,0,{ffff880420523950,2})
[57678.823567] [syslog] ==> cachefiles_read_waiter({49},3,0,{ffff880420737e30,2})
[57678.824492] [kworke] ==> cachefiles_read_waiter({185},3,0,{ffff880420606950,2})
[57678.824647] [kjourn] ==> cachefiles_read_waiter({0},3,0,{ffff88043efc1b58,22})
[57678.825761] [kworke] ==> cachefiles_read_waiter({185},3,0,{ffff880420606950,2})
[57678.825891] [kjourn] ==> cachefiles_read_waiter({0},3,0,{ffff88043efc1b58,22})
[57678.826575] [syslog] ==> cachefiles_read_waiter({49},3,0,{ffff880420737e30,2})
[57678.827645] [syslog] ==> cachefiles_read_waiter({49},3,0,{ffff880420737e30,2})
[57678.828052] [kworke] ==> cachefiles_read_waiter({185},3,0,{ffff880420606950,2})
[57678.828204] [kjourn] ==> cachefiles_read_waiter({0},3,0,{ffff88043efc1b58,22})
[57678.829130] [syslog] ==> cachefiles_read_waiter({49},3,0,{ffff880420737e30,2})
[57678.830148] [syslog] ==> cachefiles_read_waiter({49},3,0,{ffff880420737e30,2})
[57678.831375] [syslog] ==> cachefiles_read_waiter({49},3,0,{ffff880420737e30,2})
[57678.832379] [syslog] ==> cachefiles_read_waiter({49},3,0,{ffff880420737e30,2})

--end snip--



-- 
Suresh Jayaraman
