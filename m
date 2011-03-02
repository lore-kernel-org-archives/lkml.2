Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757121Ab1CBTdJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 14:33:09 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54541 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752980Ab1CBTdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 14:33:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=uFPCwgzP2ZB+4Kggf7La/0jiWoOJPLKGYh5FUDxGzMsKfior5E8+RHEzjoFYrcN9wn
         ljM7TIUq0FfX1qoL7tO5rYGdczEPEPy2GI3qb/qhT10hyaTN5pE2J6eizUV7uyZK0A0L
         kM+/GiAZ4bQfo97OJwQ5LE757F2gXf+cTFrMY=
MIME-Version: 1.0
Date: Wed, 2 Mar 2011 19:33:06 +0000
Message-ID: <AANLkTine5sru_JsK1LmRVa9fwxjPsaDdZUTFPCBi6A+c@mail.gmail.com>
Subject: 2.6.38-rc7, OOM behaviour?
From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

(please cc as not subscribed)

Ubuntu 10.10, 2.6.37-rc8, Core2Duo laptop, 6GB DDR2, Intel 160GB SSD.

I wanted to see what happens when I exhaust the memory of my system.
It's got 6GB ram and I created a 1GB swap with
http://code.google.com/p/compcache/ . To use more memory I launched
google-chrome processes, each with 25 tabs containing various sites
etc. When I reached 11 Google Chrome windows each with 25 tabs I maxed
out the memory, and things became real slow (sluggish mouse pointer,
system generally not responding) and the "HDD"  activity light was
pretty constant.

I don't have any on disk swap.

I couldn't recovery the system at this point (it had stopped
responding, no HDD indicator, no mouse pointer movement), so I had to
reboot it using SysRq+b. This is what I saw in the kernel log after
reboot:

[snip]
Mar  2 18:34:26 hostname kernel: [22039.152074] [18915]  1000 18915
90784     7427   0       7           411 chrome
Mar  2 18:34:26 hostname kernel: [22039.152077] [19766]  1000 19766
63357     1196   0       0             0 gnome-terminal
Mar  2 18:34:26 hostname kernel: [22039.152081] [19777]  1000 19777
 3634       41   0       0             0 gnome-pty-helpe
Mar  2 18:34:26 hostname kernel: [22039.152084] [19778]  1000 19778
 5825      793   0       0             0 bash
Mar  2 18:34:26 hostname kernel: [22039.152087] [19840]  1000 19840
 2871      131   0       0             0 watch
Mar  2 18:34:26 hostname kernel: [22039.152090] [20136]  1000 20136
93107     3997   0      10           588 chrome
Mar  2 18:34:26 hostname kernel: [22039.152093] Out of memory: Kill
process 20136 (chrome) score 590 or sacrifice child
Mar  2 18:34:26 hostname kernel: [22039.152097] Killed process 20136
(chrome) total-vm:372428kB, anon-rss:15556kB, file-rss:432kB
Mar  2 18:34:32 hostname kernel: [22042.872291] chrome invoked
oom-killer: gfp_mask=0x84d0, order=0, oom_adj=0, oom_score_adj=0
Mar  2 18:34:36 hostname kernel: [22042.872295] chrome cpuset=/ mems_allowed=0
Mar  2 18:34:38 hostname kernel: [22042.872298] Pid: 16321, comm:
chrome Tainted: P            2.6.38-rc7 #1
Mar  2 18:34:38 hostname kernel: [22042.872300] Call Trace:
Mar  2 18:34:38 hostname kernel: [22042.872308]  [<ffffffff810b2ca2>]
? dump_header+0xa2/0x230
Mar  2 18:34:38 hostname kernel: [22042.872312]  [<ffffffff81205f79>]
? apparmor_capable+0x29/0xa0
Mar  2 18:34:38 hostname kernel: [22042.872317]  [<ffffffff811d40b6>]
? security_real_capable_noaudit+0x36/0x70
Mar  2 18:34:38 hostname kernel: [22042.872320]  [<ffffffff810b31ce>]
? oom_kill_process+0x9e/0x290
Mar  2 18:34:38 hostname kernel: [22042.872323]  [<ffffffff810b3678>]
? out_of_memory+0x2b8/0x3d0
Mar  2 18:34:38 hostname kernel: [22042.872325]  [<ffffffff810b8028>]
? __alloc_pages_nodemask+0x848/0x860
Mar  2 18:34:38 hostname kernel: [22042.872330]  [<ffffffff810e7e64>]
? alloc_pages_current+0x94/0x110
Mar  2 18:34:38 hostname kernel: [22042.872333]  [<ffffffff8102ad9e>]
? pte_alloc_one+0xe/0x30
Mar  2 18:34:38 hostname kernel: [22042.872336]  [<ffffffff810cb2f6>]
? __pte_alloc+0x26/0xd0
Mar  2 18:34:38 hostname kernel: [22042.872339]  [<ffffffff810cec0e>]
? handle_mm_fault+0xee/0x1e0
Mar  2 18:34:38 hostname kernel: [22042.872342]  [<ffffffff814b5227>]
? do_page_fault+0x1a7/0x4b0
Mar  2 18:34:38 hostname kernel: [22042.872346]  [<ffffffff81138f21>]
? sys_epoll_wait+0xb1/0x420
Mar  2 18:34:38 hostname kernel: [22042.872350]  [<ffffffff8103a970>]
? default_wake_function+0x0/0x20
Mar  2 18:34:38 hostname kernel: [22042.872354]  [<ffffffff814b2a0f>]
? page_fault+0x1f/0x30
Mar  2 18:34:38 hostname kernel: [22042.872356] Mem-Info:
Mar  2 18:34:38 hostname kernel: [22042.872357] Node 0 DMA per-cpu:
Mar  2 18:34:38 hostname kernel: [22042.872359] CPU    0: hi:    0,
btch:   1 usd:   0
Mar  2 18:34:38 hostname kernel: [22042.872361] CPU    1: hi:    0,
btch:   1 usd:   0
Mar  2 18:34:38 hostname kernel: [22042.872362] Node 0 DMA32 per-cpu:
Mar  2 18:34:38 hostname kernel: [22042.872365] CPU    0: hi:  186,
btch:  31 usd:  30
Mar  2 18:34:38 hostname kernel: [22042.872366] CPU    1: hi:  186,
btch:  31 usd:   0
Mar  2 18:34:38 hostname kernel: [22042.872367] Node 0 Normal per-cpu:
Mar  2 18:34:38 hostname kernel: [22042.872369] CPU    0: hi:  186,
btch:  31 usd:  63
Mar  2 18:34:38 hostname kernel: [22042.872371] CPU    1: hi:  186,
btch:  31 usd:   0
Mar  2 18:34:38 hostname kernel: [22042.872375] active_anon:1116980
inactive_anon:242817 isolated_anon:0
Mar  2 18:34:38 hostname kernel: [22042.872376]  active_file:507
inactive_file:689 isolated_file:11
Mar  2 18:34:38 hostname kernel: [22042.872377]  unevictable:30
dirty:0 writeback:17 unstable:0
Mar  2 18:34:38 hostname kernel: [22042.872377]  free:8848
slab_reclaimable:3286 slab_unreclaimable:8905
Mar  2 18:34:38 hostname kernel: [22042.872378]  mapped:8639
shmem:6657 pagetables:15118 bounce:0
Mar  2 18:34:38 hostname kernel: [22042.872380] Node 0 DMA
free:15452kB min:24kB low:28kB high:36kB active_anon:0kB
inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB
isolated(anon):0kB isolated(file):0kB present:15684kB mlocked:0kB
dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:0kB
slab_unreclaimable:424kB kernel_stack:0kB pagetables:0kB unstable:0kB
bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? yes
Mar  2 18:34:38 hostname kernel: [22042.872388] lowmem_reserve[]: 0
3510 6035 6035
Mar  2 18:34:38 hostname kernel: [22042.872391] Node 0 DMA32
free:15856kB min:5776kB low:7220kB high:8664kB active_anon:2916400kB
inactive_anon:583368kB active_file:792kB inactive_file:1192kB
unevictable:0kB isolated(anon):0kB isolated(file):44kB
present:3594900kB mlocked:0kB dirty:0kB writeback:24kB mapped:14068kB
shmem:14344kB slab_reclaimable:1576kB slab_unreclaimable:9256kB
kernel_stack:1112kB pagetables:26496kB unstable:0kB bounce:0kB
writeback_tmp:0kB pages_scanned:507 all_unreclaimable? no
Mar  2 18:34:38 hostname kernel: [22042.872399] lowmem_reserve[]: 0 0 2524 2524
Mar  2 18:34:38 hostname kernel: [22042.872402] Node 0 Normal
free:4084kB min:4152kB low:5188kB high:6228kB active_anon:1551520kB
inactive_anon:387900kB active_file:1236kB inactive_file:1564kB
unevictable:120kB isolated(anon):0kB isolated(file):0kB
present:2585592kB mlocked:112kB dirty:0kB writeback:44kB
mapped:20488kB shmem:12284kB slab_reclaimable:11568kB
slab_unreclaimable:25940kB kernel_stack:2864kB pagetables:33976kB
unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:400
all_unreclaimable? no
Mar  2 18:34:38 hostname kernel: [22042.872411] lowmem_reserve[]: 0 0 0 0
Mar  2 18:34:38 hostname kernel: [22042.872414] Node 0 DMA: 1*4kB
1*8kB 1*16kB 0*32kB 1*64kB 0*128kB 0*256kB 0*512kB 1*1024kB 1*2048kB
3*4096kB = 15452kB
Mar  2 18:34:38 hostname kernel: [22042.872421] Node 0 DMA32: 126*4kB
103*8kB 78*16kB 29*32kB 11*64kB 9*128kB 9*256kB 4*512kB 2*1024kB
0*2048kB 1*4096kB = 15856kB
Mar  2 18:34:38 hostname kernel: [22042.872429] Node 0 Normal: 533*4kB
14*8kB 3*16kB 1*32kB 1*64kB 2*128kB 0*256kB 1*512kB 1*1024kB 0*2048kB
0*4096kB = 4180kB
Mar  2 18:34:38 hostname kernel: [22042.872436] 60090 total pagecache pages
Mar  2 18:34:38 hostname kernel: [22042.872437] 52166 pages in swap cache
Mar  2 18:34:38 hostname kernel: [22042.872439] Swap cache stats: add
753370, delete 701204, find 73773/125774
Mar  2 18:34:38 hostname kernel: [22042.872441] Free swap  = 0kB
Mar  2 18:34:38 hostname kernel: [22042.872442] Total swap = 1048572kB
Mar  2 18:34:38 hostname kernel: [22042.898366] 1572848 pages RAM
Mar  2 18:34:38 hostname kernel: [22042.898368] 41030 pages reserved
Mar  2 18:34:38 hostname kernel: [22042.898369] 36046 pages shared
Mar  2 18:34:38 hostname kernel: [22042.898370] 1512687 pages non-shared
Mar  2 18:34:38 hostname kernel: [22042.898372] [ pid ]   uid  tgid
total_vm      rss cpu oom_adj oom_score_adj name
Mar  2 18:34:38 hostname kernel: [22042.898382] [  289]     0   289
 4241       39   1       0             0 upstart-udev-br
Mar  2 18:34:38 hostname kernel: [22042.898386] [  297]     0   297
 4304       36   1     -17         -1000 udevd
Mar  2 18:34:38 hostname kernel: [22042.898391] [  533]     0   533
 2963       40   0       0             0 lt-ntfs
[snip]

Is this normal?

Regards,
// Mathias
