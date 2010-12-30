Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754799Ab0L3PoV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Dec 2010 10:44:21 -0500
Received: from krak.alatek.krakow.pl ([217.96.2.229]:3642 "EHLO
	krak.alatek.krakow.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754501Ab0L3PoU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Dec 2010 10:44:20 -0500
X-Greylist: delayed 2107 seconds by postgrey-1.27 at vger.kernel.org; Thu, 30 Dec 2010 10:44:19 EST
From: Pawel Sikora <pluto@agmk.net>
To: linux-kernel@vger.kernel.org
Subject: [2.6.37-rc8] BUG kmalloc-256: Poison overwritten.
Date: Thu, 30 Dec 2010 16:08:40 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.36.2-2; KDE/4.5.4; x86_64; ; )
Cc: penberg@cs.helsinki.fi
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201012301608.40859.pluto@agmk.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

i'm currently testing mainline kernel to isolate some ugly fault
which corrupts memory (see https://bugzilla.kernel.org/show_bug.cgi?id=25782).

during soft raid reogranization (stopping e92.0,e93.0 AoE exports -> dropping md2, md3
-> recreating one bigger md2 -> reexporting md2 as e92.0) i've observed some debug
messages (slub_debug=FZPU) in dmesg.

(...)
[   77.175405] md3: detected capacity change from 0 to 434951421952
[   77.188128]  md3: unknown partition table
[   77.235477] md2: detected capacity change from 0 to 434951421952
[   77.596970]  md2: unknown partition table
[   77.673776] aoe: 002590289362 e92.0 v0100 has 849514496 sectors
[   77.673800] aoe: 002590289363 e93.0 v0100 has 849514496 sectors
[   77.677110]  etherd/e93.0: unknown partition table
[   77.677773]  etherd/e92.0: unknown partition table
[ 1675.621938] md: md3 still in use.
[ 1810.215053] md: md2 still in use.
[ 1848.694133] md: md2: resync done.
[ 1849.116128] md: checkpointing resync of md2.
[ 1849.211809] md2: detected capacity change from 434951421952 to 0
[ 1849.211816] md: md2 stopped.
[ 1849.211833] md: unbind<sda4>
[ 1849.236522] md: export_rdev(sda4)
[ 1849.236617] md: unbind<sdb4>
[ 1849.266532] md: export_rdev(sdb4)
[ 1851.148856] md3: detected capacity change from 434951421952 to 0
[ 1851.148865] md: md3 stopped.
[ 1851.148873] md: unbind<sdc4>
[ 1851.173201] md: export_rdev(sdc4)
[ 1851.173306] md: unbind<sdd4>
[ 1851.199873] md: export_rdev(sdd4)
[ 1863.448308] =============================================================================
[ 1863.448313] BUG kmalloc-256: Poison overwritten
[ 1863.448315] -----------------------------------------------------------------------------
[ 1863.448316] 
[ 1863.448319] INFO: 0xffff8807ffc7e7c4-0xffff8807ffc7e7c5. First byte 0x6c instead of 0x6b
[ 1863.448331] INFO: Allocated in setup_conf+0x12b/0x360 [raid10] age=554800 cpu=5 pid=2766
[ 1863.448336] INFO: Freed in stop+0x66/0x80 [raid10] age=4271 cpu=3 pid=5266
[ 1863.448339] INFO: Slab 0xffffea001bff3b90 objects=24 used=11 fp=0xffff8807ffc7e7b0 flags=0x6000000000040c1
[ 1863.448341] INFO: Object 0xffff8807ffc7e7b0 @offset=1968 fp=0xffff8807ffc7f338
[ 1863.448343] 
[ 1863.448345] Bytes b4 0xffff8807ffc7e7a0:  a9 c6 fe ff 00 00 00 00 5a 5a 5a 5a 5a 5a 5a 5a ����....ZZZZZZZZ
[ 1863.448353]   Object 0xffff8807ffc7e7b0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 1863.448362]   Object 0xffff8807ffc7e7c0:  6b 6b 6b 6b 6c 6c 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkllkkkkkkkkkk
[ 1863.448369]   Object 0xffff8807ffc7e7d0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 1863.448377]   Object 0xffff8807ffc7e7e0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 1863.448384]   Object 0xffff8807ffc7e7f0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 1863.448391]   Object 0xffff8807ffc7e800:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 1863.448399]   Object 0xffff8807ffc7e810:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 1863.448406]   Object 0xffff8807ffc7e820:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 1863.448413]   Object 0xffff8807ffc7e830:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 1863.448421]   Object 0xffff8807ffc7e840:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 1863.448428]   Object 0xffff8807ffc7e850:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 1863.448435]   Object 0xffff8807ffc7e860:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 1863.448442]   Object 0xffff8807ffc7e870:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 1863.448450]   Object 0xffff8807ffc7e880:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 1863.448457]   Object 0xffff8807ffc7e890:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 1863.448464]   Object 0xffff8807ffc7e8a0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b a5 kkkkkkkkkkkkkkk�
[ 1863.448472]  Redzone 0xffff8807ffc7e8b0:  bb bb bb bb bb bb bb bb                         ��������        
[ 1863.448478]  Padding 0xffff8807ffc7e8f0:  5a 5a 5a 5a 5a 5a 5a 5a                         ZZZZZZZZ        
[ 1863.448487] Pid: 5282, comm: udevd Not tainted 2.6.37-rc8 #1
[ 1863.448489] Call Trace:
[ 1863.448499]  [<ffffffff8111ea1e>] print_trailer+0xfe/0x160
[ 1863.448503]  [<ffffffff8111f074>] check_bytes_and_report+0xf4/0x130
[ 1863.448506]  [<ffffffff8111f2da>] check_object+0x22a/0x270
[ 1863.448512]  [<ffffffff81137cc9>] ? do_execve+0x59/0x390
[ 1863.448515]  [<ffffffff81137cc9>] ? do_execve+0x59/0x390
[ 1863.448519]  [<ffffffff81120380>] alloc_debug_processing+0x110/0x1f0
[ 1863.448522]  [<ffffffff811211c9>] __slab_alloc+0x3a9/0x410
[ 1863.448528]  [<ffffffff8140254c>] ? do_page_fault+0x1cc/0x4b0
[ 1863.448531]  [<ffffffff81137cc9>] ? do_execve+0x59/0x390
[ 1863.448534]  [<ffffffff81121888>] kmem_cache_alloc_notrace+0xb8/0xc0
[ 1863.448538]  [<ffffffff81137cc9>] do_execve+0x59/0x390
[ 1863.448543]  [<ffffffff8121f0c1>] ? strncpy_from_user+0x31/0x50
[ 1863.448548]  [<ffffffff8100b205>] sys_execve+0x45/0x70
[ 1863.448553]  [<ffffffff8100319c>] stub_execve+0x6c/0xc0
[ 1863.448556] FIX kmalloc-256: Restoring 0xffff8807ffc7e7c4-0xffff8807ffc7e7c5=0x6b
[ 1863.448557] 
[ 1863.448559] FIX kmalloc-256: Marking all objects used
[ 1884.013716] md: bind<sda4>
[ 1884.013908] md: bind<sdb4>
[ 1884.015670] md: bind<sdc4>
[ 1884.042060] md: bind<sdd4>
[ 1884.044120] md/raid0:md2: looking at sdd4
[ 1884.044123] md/raid0:md2:   comparing sdd4(849514496) with sdd4(849514496)
[ 1884.044126] md/raid0:md2:   END
[ 1884.044128] md/raid0:md2:   ==> UNIQUE
[ 1884.044129] md/raid0:md2: 1 zones
[ 1884.044130] md/raid0:md2: looking at sdc4
[ 1884.044132] md/raid0:md2:   comparing sdc4(849514496) with sdd4(849514496)
[ 1884.044135] md/raid0:md2:   EQUAL
[ 1884.044136] md/raid0:md2: looking at sdb4
[ 1884.044138] md/raid0:md2:   comparing sdb4(849514496) with sdd4(849514496)
[ 1884.044140] md/raid0:md2:   EQUAL
[ 1884.044142] md/raid0:md2: looking at sda4
[ 1884.044143] md/raid0:md2:   comparing sda4(849514496) with sdd4(849514496)
[ 1884.044146] md/raid0:md2:   EQUAL
[ 1884.044147] md/raid0:md2: FINAL 1 zones
[ 1884.044151] md/raid0:md2: done.
[ 1884.044153] md/raid0:md2: md_size is 3398057984 sectors.
[ 1884.044154] ******* md2 configuration *********
[ 1884.044156] zone0=[sda4/sdb4/sdc4/sdd4/]
[ 1884.044160]         zone offset=0kb device offset=0kb size=1699028992kb
[ 1884.044162] **********************************
[ 1884.044163] 
[ 1884.044181] md2: detected capacity change from 0 to 1739805687808
[ 1884.044338] md2: detected capacity change from 0 to 1739805687808
[ 1884.044796]  md2: unknown partition table
[ 2402.479826] aoe: device 92.0 is not up
[ 2402.479841] aoe: device 92.0 is not up
[ 2402.479852] aoe: device 92.0 is not up
[ 2434.879826] aoe: device 93.0 is not up
[ 2434.879838] aoe: device 93.0 is not up
[ 2434.879849] aoe: device 93.0 is not up
[ 2625.045477] FS-Cache: Loaded
[ 2625.185242] Registering the id_resolver key type
[ 2625.185275] FS-Cache: Netfs 'nfs' registered for caching
[ 2662.391950] OCFS2 Node Manager 1.5.0
[ 2662.421336] OCFS2 DLM 1.5.0
[ 2662.445297] OCFS2 DLMFS 1.5.0
[ 2662.445505] OCFS2 User DLM kernel interface loaded
[ 2673.692803] OCFS2 1.5.0
[ 2673.727998] ocfs2: Registered cluster interface o2cb
[ 2673.728595] o2dlm: Nodes in domain 1901FEFE8A824A46A44C7A6F97655306: 2 
[ 2673.757023] JBD: Ignoring recovery information on journal
[ 2673.847489] ocfs2: Mounting device (9,2) on (node 2, slot 0) with ordered data mode.
[ 2702.479609] =============================================================================
[ 2702.479613] BUG kmalloc-256: Poison overwritten
[ 2702.479615] -----------------------------------------------------------------------------
[ 2702.479617] 
[ 2702.479619] INFO: 0xffff8807fecd690c-0xffff8807fecd690d. First byte 0x6c instead of 0x6b
[ 2702.479634] INFO: Allocated in setup_conf+0x12b/0x360 [raid10] age=806494 cpu=4 pid=2766
[ 2702.479638] INFO: Freed in stop+0x66/0x80 [raid10] age=255399 cpu=9 pid=5270
[ 2702.479641] INFO: Slab 0xffffea001bfbced0 objects=24 used=16 fp=0xffff8807fecd68f8 flags=0x6000000000040c1
[ 2702.479644] INFO: Object 0xffff8807fecd68f8 @offset=2296 fp=0xffff8807fecd7480
[ 2702.479645] 
[ 2702.479647] Bytes b4 0xffff8807fecd68e8:  00 00 00 00 00 00 00 00 5a 5a 5a 5a 5a 5a 5a 5a ........ZZZZZZZZ
[ 2702.479656]   Object 0xffff8807fecd68f8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 2702.479664]   Object 0xffff8807fecd6908:  6b 6b 6b 6b 6c 6c 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkllkkkkkkkkkk
[ 2702.479671]   Object 0xffff8807fecd6918:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 2702.479679]   Object 0xffff8807fecd6928:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 2702.479686]   Object 0xffff8807fecd6938:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 2702.479693]   Object 0xffff8807fecd6948:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 2702.479700]   Object 0xffff8807fecd6958:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 2702.479708]   Object 0xffff8807fecd6968:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 2702.479715]   Object 0xffff8807fecd6978:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 2702.479722]   Object 0xffff8807fecd6988:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 2702.479729]   Object 0xffff8807fecd6998:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 2702.479737]   Object 0xffff8807fecd69a8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 2702.479744]   Object 0xffff8807fecd69b8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 2702.479751]   Object 0xffff8807fecd69c8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 2702.479758]   Object 0xffff8807fecd69d8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[ 2702.479766]   Object 0xffff8807fecd69e8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b a5 kkkkkkkkkkkkkkk�
[ 2702.479773]  Redzone 0xffff8807fecd69f8:  bb bb bb bb bb bb bb bb                         ��������        
[ 2702.479780]  Padding 0xffff8807fecd6a38:  5a 5a 5a 5a 5a 5a 5a 5a                         ZZZZZZZZ        
[ 2702.479789] Pid: 5970, comm: sshd Not tainted 2.6.37-rc8 #1
[ 2702.479791] Call Trace:
[ 2702.479801]  [<ffffffff8111ea1e>] print_trailer+0xfe/0x160
[ 2702.479805]  [<ffffffff8111f074>] check_bytes_and_report+0xf4/0x130
[ 2702.479808]  [<ffffffff8111f2da>] check_object+0x22a/0x270
[ 2702.479815]  [<ffffffffa02055a4>] ? autofs4_wait+0x54/0x800 [autofs4]
[ 2702.479820]  [<ffffffffa02055a4>] ? autofs4_wait+0x54/0x800 [autofs4]
[ 2702.479824]  [<ffffffff81120380>] alloc_debug_processing+0x110/0x1f0
[ 2702.479827]  [<ffffffff811211c9>] __slab_alloc+0x3a9/0x410
[ 2702.479832]  [<ffffffffa02055a4>] ? autofs4_wait+0x54/0x800 [autofs4]
[ 2702.479836]  [<ffffffff81121888>] kmem_cache_alloc_notrace+0xb8/0xc0
[ 2702.479841]  [<ffffffffa02055a4>] autofs4_wait+0x54/0x800 [autofs4]
[ 2702.479844]  [<ffffffff811211c9>] ? __slab_alloc+0x3a9/0x410
[ 2702.479847]  [<ffffffff8111f15f>] ? check_object+0xaf/0x270
[ 2702.479851]  [<ffffffffa0203cc8>] try_to_fill_dentry+0xd8/0x100 [autofs4]
[ 2702.479856]  [<ffffffffa0203f71>] autofs4_revalidate+0xf1/0x170 [autofs4]
[ 2702.479861]  [<ffffffffa020487a>] autofs4_lookup+0x4fa/0x590 [autofs4]
[ 2702.479865]  [<ffffffff8113b3c7>] d_alloc_and_lookup+0x47/0x90
[ 2702.479870]  [<ffffffff811464a0>] ? d_lookup+0x30/0x60
[ 2702.479873]  [<ffffffff8113b528>] do_lookup+0x118/0x170
[ 2702.479876]  [<ffffffff8113d379>] link_path_walk+0x309/0xac0
[ 2702.479879]  [<ffffffff8113d5bb>] link_path_walk+0x54b/0xac0
[ 2702.479883]  [<ffffffff8113ee8c>] do_filp_open+0x26c/0x680
[ 2702.479886]  [<ffffffff8111f706>] ? init_object+0x46/0x80
[ 2702.479889]  [<ffffffff8113cc66>] ? getname+0x36/0x220
[ 2702.479893]  [<ffffffff8114a207>] ? alloc_fd+0x47/0x140
[ 2702.479897]  [<ffffffff81130534>] do_sys_open+0x64/0x110
[ 2702.479902]  [<ffffffff8105e408>] ? sys_setresuid+0x148/0x150
[ 2702.479905]  [<ffffffff811305fb>] sys_open+0x1b/0x20
[ 2702.479910]  [<ffffffff81002d7b>] system_call_fastpath+0x16/0x1b
[ 2702.479914] FIX kmalloc-256: Restoring 0xffff8807fecd690c-0xffff8807fecd690d=0x6b
[ 2702.479915] 
[ 2702.479917] FIX kmalloc-256: Marking all objects used
[ 4819.470336] ocfs2: Unmounting device (9,2) on (node 2)
[ 6930.496519] aoe: 002590289362 e92.0 v0100 has 3398057984 sectors
[ 6930.498397]  etherd/e92.0: unknown partition table
[ 6930.500655] aoe: ata error cmd=24h stat=41h from e92.0
[ 6930.500664] aoe: ata error cmd=24h stat=41h from e92.0
[ 6930.500671] aoe: ata error cmd=24h stat=41h from e92.0
[ 6930.500677] aoe: ata error cmd=24h stat=41h from e92.0
[ 6930.500682] Buffer I/O error on device etherd/e92.0, logical block 424757232
[ 6930.500864] aoe: ata error cmd=24h stat=41h from e92.0
[ 6930.500872] aoe: ata error cmd=24h stat=41h from e92.0
[ 6930.500878] aoe: ata error cmd=24h stat=41h from e92.0
[ 6930.500883] aoe: ata error cmd=24h stat=41h from e92.0
[ 6930.500887] Buffer I/O error on device etherd/e92.0, logical block 424757232
[ 6930.501082] aoe: ata error cmd=24h stat=41h from e92.0
[ 6930.501091] aoe: ata error cmd=24h stat=41h from e92.0

could you please put some light on this?

BR,
Pawel.

ps).
please CC me on reply.
