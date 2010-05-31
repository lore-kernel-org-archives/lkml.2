Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756590Ab0EaPZP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 11:25:15 -0400
Received: from icebox.esperi.org.uk ([81.187.191.129]:46820 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754722Ab0EaPZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 11:25:13 -0400
X-Greylist: delayed 2620 seconds by postgrey-1.27 at vger.kernel.org; Mon, 31 May 2010 11:25:13 EDT
To: linux-kernel@vger.kernel.org,
       Linux NFS Mailing List <nfs@lists.sourceforge.net>
Subject: 2.6.34 nfs fsync() deadlock
From: Nix <nix@esperi.org.uk>
Emacs: because extension languages should come with the editor built in.
Date: Mon, 31 May 2010 15:41:22 +0100
Message-ID: <87r5ksjfql.fsf@spindle.srvr.nix>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.5-b29 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-DCC-URT-Metrics: spindle 1060; Body=2 Fuz1=2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I just got a deadlock while doing a postgresql 'make check' on an NFSv3
TCP mount (the server is Linux 2.6.34 as well; the underlying filesystem
is ext4). This testsuite is notable for doing a lot of things in
parallel, each of which is generally doing a lot of fsync()ing.

/proc/mounts for the filesystem of discourse:

package.srvr.nix:/usr/src /usr/src nfs rw,relatime,vers=3,rsize=1048576,wsize=1048576,namlen=255,hard,proto=tcp,timeo=600,retrans=2,sec=sys,mountaddr=192.168.14.15,mountvers=3,mountport=50892,mountproto=udp,addr=192.168.14.15 0 0

/etc/exports for it on the server:

/usr/src mutilate(rw,no_root_squash,no_subtree_check,async)

dmesg:

[ 6161.193031] INFO: task postgres:12472 blocked for more than 120 seconds.
[ 6161.193039] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 6161.193044] postgres      D 0000000000000004     0 12472  12448 0x00000000
[ 6161.193060]  ffff880190f33c28 0000000000000046 ffff880190f33bc8 ffffffff810d92e0
[ 6161.193096]  ffff880190f33fd8 ffff880336758340 ffff880190f33fd8 ffff880190f32000
[ 6161.193128]  ffff880190f32000 ffff880190f33fd8 ffff880190f32000 ffff880190f33fd8
[ 6161.193159] Call Trace:
[ 6161.193179]  [<ffffffff810d92e0>] ? find_get_pages_tag+0xd9/0x103
[ 6161.193186]  [<ffffffff8111e561>] ? inode_wait+0x0/0x12
[ 6161.193195]  [<ffffffff8111e56f>] inode_wait+0xe/0x12
[ 6161.193206]  [<ffffffff814d87dc>] __wait_on_bit+0x48/0x7b
[ 6161.193216]  [<ffffffff811b80b6>] ? nfs_writepages+0xd5/0xf8
[ 6161.193226]  [<ffffffff81127974>] inode_wait_for_writeback+0x8d/0xad
[ 6161.193238]  [<ffffffff81081276>] ? wake_bit_function+0x0/0x33
[ 6161.193247]  [<ffffffff81127a44>] writeback_single_inode+0xb0/0x2dc
[ 6161.193257]  [<ffffffff81127c9d>] sync_inode+0x2d/0x46
[ 6161.193266]  [<ffffffff811b6f99>] nfs_wb_all+0x42/0x44
[ 6161.193276]  [<ffffffff811abf4b>] nfs_do_fsync+0x20/0x3d
[ 6161.193286]  [<ffffffff811ac130>] nfs_file_flush+0x75/0x7d
[ 6161.193296]  [<ffffffff8110a58c>] filp_close+0x43/0x72
[ 6161.193306]  [<ffffffff8106903a>] put_files_struct+0x74/0xcc
[ 6161.193316]  [<ffffffff810690dd>] exit_files+0x4b/0x53
[ 6161.193325]  [<ffffffff8106a77c>] do_exit+0x269/0x6fb
[ 6161.193334]  [<ffffffff8106ac86>] do_group_exit+0x78/0xa1
[ 6161.193344]  [<ffffffff8106acc6>] sys_exit_group+0x17/0x1b
[ 6161.193353]  [<ffffffff8102e0eb>] system_call_fastpath+0x16/0x1b
[ 6161.193367] INFO: task postgres:12477 blocked for more than 120 seconds.
[ 6161.193371] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 6161.193374] postgres      D 0000000000000001     0 12477  12448 0x00000000
[ 6161.193396]  ffff8803382e7a38 0000000000000046 ffff8803382e7988 ffffffffffffffff
[ 6161.193427]  ffff8803382e7fd8 ffff8802f3606800 ffff8803382e7fd8 ffff8803382e6000
[ 6161.193458]  ffff8803382e6000 ffff8803382e7fd8 ffff8803382e6000 ffff8803382e7fd8
[ 6161.193489] Call Trace:
[ 6161.193503]  [<ffffffff810d96e0>] ? sync_page+0x0/0x4a
[ 6161.193508]  [<ffffffff814d81f4>] io_schedule+0x3d/0x52
[ 6161.193517]  [<ffffffff810d9726>] sync_page+0x46/0x4a
[ 6161.193526]  [<ffffffff814d86d2>] __wait_on_bit_lock+0x46/0x8f
[ 6161.193535]  [<ffffffff810d96c7>] __lock_page+0x66/0x6d
[ 6161.193545]  [<ffffffff81081276>] ? wake_bit_function+0x0/0x33
[ 6161.193555]  [<ffffffff810dfb71>] write_cache_pages+0x19b/0x329
[ 6161.193565]  [<ffffffff811b80d9>] ? nfs_writepages_callback+0x0/0x7c
[ 6161.193579]  [<ffffffff811b8097>] nfs_writepages+0xb6/0xf8
[ 6161.193584]  [<ffffffff811b8c30>] ? nfs_flush_one+0x0/0xdf
[ 6161.193594]  [<ffffffff81081276>] ? wake_bit_function+0x0/0x33
[ 6161.193604]  [<ffffffff810dfd46>] do_writepages+0x21/0x2a
[ 6161.193613]  [<ffffffff81127a7b>] writeback_single_inode+0xe7/0x2dc
[ 6161.193622]  [<ffffffff81127c9d>] sync_inode+0x2d/0x46
[ 6161.193631]  [<ffffffff811b6f99>] nfs_wb_all+0x42/0x44
[ 6161.193641]  [<ffffffff811abf4b>] nfs_do_fsync+0x20/0x3d
[ 6161.193650]  [<ffffffff811ac130>] nfs_file_flush+0x75/0x7d
[ 6161.193660]  [<ffffffff8110a58c>] filp_close+0x43/0x72
[ 6161.193669]  [<ffffffff8106903a>] put_files_struct+0x74/0xcc
[ 6161.193678]  [<ffffffff810690dd>] exit_files+0x4b/0x53
[ 6161.193687]  [<ffffffff8106a77c>] do_exit+0x269/0x6fb
[ 6161.193697]  [<ffffffff8106ac86>] do_group_exit+0x78/0xa1
[ 6161.193706]  [<ffffffff8106acc6>] sys_exit_group+0x17/0x1b
[ 6161.193715]  [<ffffffff8102e0eb>] system_call_fastpath+0x16/0x1b
[ 6161.193729] INFO: task postgres:12483 blocked for more than 120 seconds.
[ 6161.193733] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 6161.193736] postgres      D 0000000000000004     0 12483  12448 0x00000000
[ 6161.193758]  ffff880332079c28 0000000000000046 ffff880332079bc8 ffffffffffffffff
[ 6161.193795]  ffff880332079fd8 ffff880190f66880 ffff880332079fd8 ffff880332078000
[ 6161.193825]  ffff880332078000 ffff880332079fd8 ffff880332078000 ffff880332079fd8
[ 6161.193868] Call Trace:
[ 6161.193882]  [<ffffffff8111e561>] ? inode_wait+0x0/0x12
[ 6161.193890]  [<ffffffff8111e56f>] inode_wait+0xe/0x12
[ 6161.193905]  [<ffffffff814d87dc>] __wait_on_bit+0x48/0x7b
[ 6161.193913]  [<ffffffff81081160>] ? bit_waitqueue+0x17/0x97
[ 6161.193928]  [<ffffffff81127974>] inode_wait_for_writeback+0x8d/0xad
[ 6161.193952]  [<ffffffff81081276>] ? wake_bit_function+0x0/0x33
[ 6161.193960]  [<ffffffff81127a44>] writeback_single_inode+0xb0/0x2dc
[ 6161.193978]  [<ffffffff81127c9d>] sync_inode+0x2d/0x46
[ 6161.193987]  [<ffffffff811b6f99>] nfs_wb_all+0x42/0x44
[ 6161.194004]  [<ffffffff811abf4b>] nfs_do_fsync+0x20/0x3d
[ 6161.194014]  [<ffffffff811ac130>] nfs_file_flush+0x75/0x7d
[ 6161.194031]  [<ffffffff8110a58c>] filp_close+0x43/0x72
[ 6161.194041]  [<ffffffff8106903a>] put_files_struct+0x74/0xcc
[ 6161.194058]  [<ffffffff810690dd>] exit_files+0x4b/0x53
[ 6161.194067]  [<ffffffff8106a77c>] do_exit+0x269/0x6fb
[ 6161.194084]  [<ffffffff8106ac86>] do_group_exit+0x78/0xa1
[ 6161.194095]  [<ffffffff8106acc6>] sys_exit_group+0x17/0x1b
[ 6161.194112]  [<ffffffff8102e0eb>] system_call_fastpath+0x16/0x1b
[ 6161.194124] INFO: task postgres:12491 blocked for more than 120 seconds.
[ 6161.194140] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 6161.194149] postgres      D 0000000000000006     0 12491  12448 0x00000000
[ 6161.194179]  ffff8803318afc28 0000000000000046 ffff8803318afb88 ffff880001f13200
[ 6161.194205]  ffff8803318affd8 ffff880338612540 ffff8803318affd8 ffff8803318ae000
[ 6161.194242]  ffff8803318ae000 ffff8803318affd8 ffff8803318ae000 ffff8803318affd8
[ 6161.194276] Call Trace:
[ 6161.194296]  [<ffffffff8111e561>] ? inode_wait+0x0/0x12
[ 6161.194306]  [<ffffffff8111e56f>] inode_wait+0xe/0x12
[ 6161.194322]  [<ffffffff814d87dc>] __wait_on_bit+0x48/0x7b
[ 6161.194334]  [<ffffffff81081276>] ? wake_bit_function+0x0/0x33
[ 6161.194351]  [<ffffffff81127974>] inode_wait_for_writeback+0x8d/0xad
[ 6161.194362]  [<ffffffff81081276>] ? wake_bit_function+0x0/0x33
[ 6161.194380]  [<ffffffff81127a44>] writeback_single_inode+0xb0/0x2dc
[ 6161.194390]  [<ffffffff81127c9d>] sync_inode+0x2d/0x46
[ 6161.194406]  [<ffffffff811b6f99>] nfs_wb_all+0x42/0x44
[ 6161.194417]  [<ffffffff811abf4b>] nfs_do_fsync+0x20/0x3d
[ 6161.194434]  [<ffffffff811ac130>] nfs_file_flush+0x75/0x7d
[ 6161.194444]  [<ffffffff8110a58c>] filp_close+0x43/0x72
[ 6161.194460]  [<ffffffff8106903a>] put_files_struct+0x74/0xcc
[ 6161.194470]  [<ffffffff810690dd>] exit_files+0x4b/0x53
[ 6161.194482]  [<ffffffff8106a77c>] do_exit+0x269/0x6fb
[ 6161.194498]  [<ffffffff8106ac86>] do_group_exit+0x78/0xa1
[ 6161.194505]  [<ffffffff8106acc6>] sys_exit_group+0x17/0x1b
[ 6161.194516]  [<ffffffff8102e0eb>] system_call_fastpath+0x16/0x1b
[ 6161.194533] INFO: task postgres:12497 blocked for more than 120 seconds.
[ 6161.194540] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 6161.194551] postgres      D 0000000000000007     0 12497  12448 0x00000004
[ 6161.194575]  ffff880337261988 0000000000000082 ffff8803372618f8 ffffffff814b3a8b
[ 6161.194611]  ffff880337261fd8 ffff8803323e66c0 ffff880337261fd8 ffff880337260000
[ 6161.194646]  ffff880337260000 ffff880337261fd8 ffff880337260000 ffff880337261fd8
[ 6161.194681] Call Trace:
[ 6161.194698]  [<ffffffff814b3a8b>] ? __rpc_execute+0xc8/0x25b
[ 6161.194707]  [<ffffffff811b744b>] ? nfs_write_rpcsetup+0x243/0x258
[ 6161.194719]  [<ffffffff8111e561>] ? inode_wait+0x0/0x12
[ 6161.194731]  [<ffffffff8111e56f>] inode_wait+0xe/0x12
[ 6161.194743]  [<ffffffff814d87dc>] __wait_on_bit+0x48/0x7b
[ 6161.194759]  [<ffffffff81127974>] inode_wait_for_writeback+0x8d/0xad
[ 6161.194765]  [<ffffffff81081276>] ? wake_bit_function+0x0/0x33
[ 6161.194775]  [<ffffffff81127a44>] writeback_single_inode+0xb0/0x2dc
[ 6161.194784]  [<ffffffff81127c9d>] sync_inode+0x2d/0x46
[ 6161.194793]  [<ffffffff811b7792>] nfs_wb_page+0x81/0x9a
[ 6161.194802]  [<ffffffff811b7807>] nfs_flush_incompatible+0x5c/0x6c
[ 6161.194812]  [<ffffffff811abdb6>] nfs_write_begin+0xeb/0x1b6
[ 6161.194823]  [<ffffffff810d8d91>] generic_file_buffered_write+0x116/0x273
[ 6161.194833]  [<ffffffff811be17f>] ? nfs3_getxattr+0x50/0xc0
[ 6161.194848]  [<ffffffff810da840>] __generic_file_aio_write+0x395/0x3ca
[ 6161.194855]  [<ffffffff811f2567>] ? sys_semtimedop+0x794/0x8f6
[ 6161.194864]  [<ffffffff810da8d2>] generic_file_aio_write+0x5d/0xa7
[ 6161.194874]  [<ffffffff811ac81a>] nfs_file_write+0xdc/0x184
[ 6161.194884]  [<ffffffff8110be84>] do_sync_write+0xcb/0x108
[ 6161.194899]  [<ffffffff811ac998>] ? nfs_file_llseek+0x0/0xb8
[ 6161.194904]  [<ffffffff8110c7a4>] vfs_write+0xb2/0x153
[ 6161.194914]  [<ffffffff8110c908>] sys_write+0x4a/0x71
[ 6161.194923]  [<ffffffff8102e0eb>] system_call_fastpath+0x16/0x1b
[ 6161.194942] INFO: task postgres:12498 blocked for more than 120 seconds.
[ 6161.194946] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 6161.194950] postgres      D 0000000000000000     0 12498  12448 0x00000000
[ 6161.194972]  ffff8802f0681c28 0000000000000046 ffff8802f0681bc8 ffffffff810d92e0
[ 6161.195004]  ffff8802f0681fd8 ffff880337624700 ffff8802f0681fd8 ffff8802f0680000
[ 6161.195036]  ffff8802f0680000 ffff8802f0681fd8 ffff8802f0680000 ffff8802f0681fd8
[ 6161.195067] Call Trace:
[ 6161.195077]  [<ffffffff810d92e0>] ? find_get_pages_tag+0xd9/0x103
[ 6161.195092]  [<ffffffff8111e561>] ? inode_wait+0x0/0x12
[ 6161.195096]  [<ffffffff8111e56f>] inode_wait+0xe/0x12
[ 6161.195106]  [<ffffffff814d87dc>] __wait_on_bit+0x48/0x7b
[ 6161.195111]  [<ffffffff811b80b6>] ? nfs_writepages+0xd5/0xf8
[ 6161.195121]  [<ffffffff81127974>] inode_wait_for_writeback+0x8d/0xad
[ 6161.195131]  [<ffffffff81081276>] ? wake_bit_function+0x0/0x33
[ 6161.195140]  [<ffffffff81127a44>] writeback_single_inode+0xb0/0x2dc
[ 6161.195150]  [<ffffffff81127c9d>] sync_inode+0x2d/0x46
[ 6161.195159]  [<ffffffff811b6f99>] nfs_wb_all+0x42/0x44
[ 6161.195168]  [<ffffffff811abf4b>] nfs_do_fsync+0x20/0x3d
[ 6161.195178]  [<ffffffff811ac130>] nfs_file_flush+0x75/0x7d
[ 6161.195195]  [<ffffffff8110a58c>] filp_close+0x43/0x72
[ 6161.195200]  [<ffffffff8106903a>] put_files_struct+0x74/0xcc
[ 6161.195209]  [<ffffffff810690dd>] exit_files+0x4b/0x53
[ 6161.195219]  [<ffffffff8106a77c>] do_exit+0x269/0x6fb
[ 6161.195228]  [<ffffffff8106ac86>] do_group_exit+0x78/0xa1
[ 6161.195237]  [<ffffffff8106acc6>] sys_exit_group+0x17/0x1b
[ 6161.195247]  [<ffffffff8102e0eb>] system_call_fastpath+0x16/0x1b


NFS- and networking-related .config on the client:

CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=y
CONFIG_NFS_V3=y
CONFIG_NFS_V3_ACL=y
CONFIG_NFSD=y
CONFIG_NFSD_V2_ACL=y
CONFIG_NFSD_V3=y
CONFIG_NFSD_V3_ACL=y
CONFIG_LOCKD=y
CONFIG_LOCKD_V4=y
CONFIG_EXPORTFS=y
CONFIG_NFS_ACL_SUPPORT=y
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=y

CONFIG_PACKET=y
CONFIG_UNIX=y
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
CONFIG_IP_FIB_HASH=y
CONFIG_INET_LRO=y
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
CONFIG_BT=y
CONFIG_BT_L2CAP=y
CONFIG_BT_SCO=y
CONFIG_BT_RFCOMM=y
CONFIG_BT_HCIBTUSB=y

CONFIG_FIREWIRE=y
CONFIG_FIREWIRE_OHCI=y
CONFIG_FIREWIRE_OHCI_DEBUG=y
CONFIG_FIREWIRE_SBP2=y
CONFIG_NETDEVICES=y
CONFIG_MII=y
CONFIG_NETDEV_1000=y
CONFIG_R8169=y
