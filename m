Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752332Ab1EDIhD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 04:37:03 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37046 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751946Ab1EDIgm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 04:36:42 -0400
Date: Wed, 4 May 2011 10:35:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: werner <w.landgraf@ru.ru>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [block IO crash] Re: 2.6.39-rc5-git2 boot crashs
Message-ID: <20110504083559.GB25724@elte.hu>
References: <web-516671337@zbackend1.aha.ru>
 <BANLkTikFqF1vzMq3L9zDB=MDnCOFYp+XEQ@mail.gmail.com>
 <web-516990066@zbackend1.aha.ru>
 <BANLkTinCKC23WfG7jnd-ihW9kXz-6SEgFQ@mail.gmail.com>
 <20110503190822.GA20520@elte.hu>
 <BANLkTi=6_oXX1BM5O3kJ6bVevh9=ydjj3g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="ftEhullJWpWg/VHq"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTi=6_oXX1BM5O3kJ6bVevh9=ydjj3g@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_00,FR_ALMOST_VIAG2 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	1.5 FR_ALMOST_VIAG2        RAW: Almost looks like viagra.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ftEhullJWpWg/VHq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Tue, May 3, 2011 at 12:08 PM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > I have no smart ideas straight away - just an observation: i keep testing 
> > CONFIG_X86_ELAN=y on real hardware, and it's enabled in about 4% of my 
> > configs:
> 
> So how often do you do more than just boot?

Not very often - but 'to boot' means a certain amount of filesystem work - and 
so does the 'prepare to boot the next kernel' step.

So i took Werner's .config.zipproblem and modified it to make it bootable: 
removed CONFIG_ROOT_NFS=y and disabled CONFIG_IDE - both of which keep my box 
from booting. I've attached an updated .config.zipproblem2 file: Werner, can 
you confirm that this still fails for you?

So i booted v2.6.39-rc5-254-g5933f2a on an AMD box (which is SMP in fact, so 
should trigger races even faster):

   Kernel 2.6.39-rc5-i486-1sys+ on an i686

and started a couple of such IO-intense loops:

  FILE=bigfile.$RANDOM;
  while sync; do rm -f $FILE; dd if=/dev/urandom of=$FILE bs=1000 count=10000; done &

this creates patterns of high IO combined with periods waiting for IO to flush:

procs -----------memory---------- ---swap-- -----io---- --system-- -----cpu------
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa st
 8  0      0 621140   8968 346500    0    0    29   874 1044  135  0 27 71  2  0
 8  0      0 614692   8984 352904    0    0     0     0 2011  658  0 100  0  0  0
 8  0      0 608492   8992 359104    0    0     0     0 2096  709  1 99  0  0  0
 8  0      0 602016   8992 365332    0    0     0     0 2006  651  0 100  0  0  0
 8  0      0 595692   8992 371760    0    0     0     0 2005  647  0 100  0  0  0
 4  5      0 588128   9000 378080    0    0     0 31508 2031  610  0 100  0  0  0
 6  2      0 583168   9068 383664    0    0     4  7532 2256  668  0 91  0  9  0
 8  0      0 586888   9116 380212    0    0     0   456 2073  804  1 100  0  0  0
 5  3      0 620484   9408 346904    0    0     0 14932 2768 1901  0 94  1  6  0
 8  0      0 633656   9576 333392    0    0     0  6180 2369 1232  0 98  0  2  0
 8  0      0 627208   9576 339720    0    0     0     0 2004  650  0 100  0  0  0
 8  0      0 621008   9580 346032    0    0     0     0 2048  680  1 100  0  0  0
 8  0      0 614436   9588 352296    0    0     0     0 2004  657  0 100  0  0  0
 8  0      0 618652   9708 348296    0    0     0 25984 2283  816  0 92  0  7  0
 8  0      0 612424   9708 354576    0    0     0     0 2005  651  0 100  0  0  0
 8  0      0 605976   9716 360892    0    0     0     0 2004  652  0 100  0  0  0
 8  0      0 599652   9716 367208    0    0     0     0 2006  654  0 100  0  0  0
 8  0      0 593204   9720 373528    0    0     0     0 2004  652  0 100  0  0  0
 7  2      0 585764   9728 379852    0    0     0 31612 2038  649  0 100  0  0  0
 8  0      0 590104   9832 376180    0    0     4  7400 2274  920  0 98  0  2  0
 2  6      0 597288  10008 368892    0    0     0  8636 2432 1373  0 95  0  5  0
 8  0      0 627180  10208 339096    0    0     0  4324 2426 1429  0 97  0  2  0
 8  0      0 630404  10284 335480    0    0     0  6408 2202  970  1 97  0  2  0

And indeed, after a couple of minutes testing i triggered this beauty:

BUG: unable to handle kernel NULL pointer dereference at 00000008
IP: [<c14e85c0>] generic_make_request+0x86/0x3f4
*pde = 00000000 
Oops: 0000 [#1] SMP 
last sysfs file: /sys/devices/pci0000:00/0000:00:0a.0/net/eth0/address
Modules linked in:

Pid: 2969, comm: flush-8:0 Not tainted 2.6.39-rc5-i486-1sys+ #122580 System manufacturer System Product Name/A8N-E
EIP: 0060:[<c14e85c0>] EFLAGS: 00010202 CPU: 1
EIP is at generic_make_request+0x86/0x3f4
EAX: 00000000 EBX: f569e280 ECX: f6a00000 EDX: f5528000
ESI: 00000008 EDI: 00000001 EBP: f5fd7c8c ESP: f5fd7c14
 DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
Process flush-8:0 (pid: 2969, ti=f5fd6000 task=f64d0ab0 task.ti=f5fd6000)
Stack:
 f569e280 c10988af f5fd7c84 c1d74030 f6402400 f569e300 00081ddb f569e280
 c10988af f5fd7c84 f64d0ab0 0000007b 0000007b 000000d8 00000008 ffffffc1
 00000000 00000000 00000246 f6a06c80 055c08fe 00000000 c10988af 00000080
Call Trace:
 [<c10988af>] ? mempool_alloc_slab+0x13/0x15
 [<c1d74030>] ? common_interrupt+0x30/0x40
 [<c10988af>] ? mempool_alloc_slab+0x13/0x15
 [<c10988af>] ? mempool_alloc_slab+0x13/0x15
 [<c14e89f9>] submit_bio+0xcb/0xe4
 [<c10a8048>] ? inc_zone_page_state+0xe/0x88
 [<c10ed8b5>] ? bio_init+0x9/0x2e
 [<c10ee05b>] ? bio_alloc_bioset+0x3c/0x9c
 [<c10ea27a>] submit_bh+0xc6/0xe0
 [<c10eb8f3>] __block_write_full_page+0x20a/0x2df
 [<c10ed9d9>] ? bio_put+0x8/0x2c
 [<c10ea9e5>] ? end_buffer_async_read+0xd5/0xd5
 [<c10eba88>] block_write_full_page_endio+0xc0/0xc8
 [<c10ea9e5>] ? end_buffer_async_read+0xd5/0xd5
 [<c10ebaa7>] block_write_full_page+0x17/0x19
 [<c10ea9e5>] ? end_buffer_async_read+0xd5/0xd5
 [<c1156fd0>] ext3_ordered_writepage+0xc8/0x19c
 [<c11566ee>] ? bput_one+0x10/0x10
 [<c109c9ce>] __writepage+0x10/0x28
 [<c109cd96>] write_cache_pages+0x1c9/0x283
 [<c109c9be>] ? bdi_set_max_ratio+0x52/0x52
 [<c109ce86>] generic_writepages+0x36/0x49
 [<c109d994>] do_writepages+0x28/0x2b
 [<c10e5642>] writeback_single_inode+0xa6/0x18d
 [<c10e58ef>] writeback_sb_inodes+0xa6/0x10b
 [<c10e6267>] writeback_inodes_wb+0xd9/0xee
 [<c10e642b>] wb_writeback+0x1af/0x26d
 [<c1045c12>] ? try_to_del_timer_sync+0x81/0x89
 [<c103faca>] ? local_bh_disable+0x8/0x18
 [<c10e655a>] wb_do_writeback+0x71/0x181
 [<c1045dc0>] ? add_timer_on+0x95/0x95
 [<c1045cb1>] ? del_timer+0xc/0x86
 [<c10e66d8>] bdi_writeback_thread+0x6e/0x186
 [<c10e666a>] ? wb_do_writeback+0x181/0x181
 [<c1051f73>] kthread+0x67/0x6c
 [<c1051f0c>] ? kthread_worker_fn+0x114/0x114
 [<c1d74046>] kernel_thread_helper+0x6/0x10
Code: 00 c7 45 c8 00 00 00 00 8d 55 c8 89 90 f4 02 00 00 89 45 b0 8b 53 20 c1 ea 09 89 55 c0 e8 e3 8c 88 00 83 7d c0 00 74 69 8b 43 0c <8b> 40 08 8b 90 84 00 00 00 f6 c2 01 74 04 f3 90 eb f1 8b 70 7c 
EIP: [<c14e85c0>] generic_make_request+0x86/0x3f4 SS:ESP 0068:f5fd7c14
CR2: 0000000000000008
---[ end trace c45e837de578cd2f ]---
------------[ cut here ]------------

 ( the full crashlog is attached as well - hardware details can be found there
   although i doubt it matters. )

Seems to be a generic IO/BDI badness at first sight. It gives me the appearance 
of a race or boundary condition bug, not that of memory corruption.

Here's the crashing generic_make_request() function:

c14e853a <generic_make_request>:
c14e853a:	55                   	push   %ebp
c14e853b:	89 e5                	mov    %esp,%ebp
c14e853d:	57                   	push   %edi
c14e853e:	56                   	push   %esi
c14e853f:	53                   	push   %ebx
c14e8540:	83 ec 6c             	sub    $0x6c,%esp
c14e8543:	e8 08 bb 88 00       	call   c1d74050 <mcount>
c14e8548:	89 c3                	mov    %eax,%ebx
c14e854a:	65 a1 14 00 00 00    	mov    %gs:0x14,%eax
c14e8550:	89 45 f0             	mov    %eax,-0x10(%ebp)
c14e8553:	31 c0                	xor    %eax,%eax
c14e8555:	64 a1 c4 c4 38 c2    	mov    %fs:0xc238c4c4,%eax
c14e855b:	83 b8 f4 02 00 00 00 	cmpl   $0x0,0x2f4(%eax)
c14e8562:	74 23                	je     c14e8587 <generic_make_request+0x4d>
c14e8564:	8b 80 f4 02 00 00    	mov    0x2f4(%eax),%eax
c14e856a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
c14e8571:	8b 50 04             	mov    0x4(%eax),%edx
c14e8574:	85 d2                	test   %edx,%edx
c14e8576:	74 05                	je     c14e857d <generic_make_request+0x43>
c14e8578:	89 5a 08             	mov    %ebx,0x8(%edx)
c14e857b:	eb 02                	jmp    c14e857f <generic_make_request+0x45>
c14e857d:	89 18                	mov    %ebx,(%eax)
c14e857f:	89 58 04             	mov    %ebx,0x4(%eax)
c14e8582:	e9 8e 03 00 00       	jmp    c14e8915 <generic_make_request+0x3db>
c14e8587:	83 7b 08 00          	cmpl   $0x0,0x8(%ebx)
c14e858b:	74 02                	je     c14e858f <generic_make_request+0x55>
c14e858d:	0f 0b                	ud2    
c14e858f:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
c14e8596:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
c14e859d:	8d 55 c8             	lea    -0x38(%ebp),%edx
c14e85a0:	89 90 f4 02 00 00    	mov    %edx,0x2f4(%eax)
c14e85a6:	89 45 b0             	mov    %eax,-0x50(%ebp)
c14e85a9:	8b 53 20             	mov    0x20(%ebx),%edx
c14e85ac:	c1 ea 09             	shr    $0x9,%edx
c14e85af:	89 55 c0             	mov    %edx,-0x40(%ebp)
c14e85b2:	e8 e3 8c 88 00       	call   c1d7129a <_cond_resched>
c14e85b7:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
c14e85bb:	74 69                	je     c14e8626 <generic_make_request+0xec>
c14e85bd:	8b 43 0c             	mov    0xc(%ebx),%eax
c14e85c0:	8b 40 08             	mov    0x8(%eax),%eax
c14e85c3:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
c14e85c9:	f6 c2 01             	test   $0x1,%dl
c14e85cc:	74 04                	je     c14e85d2 <generic_make_request+0x98>
c14e85ce:	f3 90                	pause  
c14e85d0:	eb f1                	jmp    c14e85c3 <generic_make_request+0x89>
c14e85d2:	8b 70 7c             	mov    0x7c(%eax),%esi
c14e85d5:	8b b8 80 00 00 00    	mov    0x80(%eax),%edi
c14e85db:	39 90 84 00 00 00    	cmp    %edx,0x84(%eax)
c14e85e1:	75 e0                	jne    c14e85c3 <generic_make_request+0x89>
c14e85e3:	89 f0                	mov    %esi,%eax
c14e85e5:	89 fa                	mov    %edi,%edx
c14e85e7:	0f ac d0 09          	shrd   $0x9,%edx,%eax
c14e85eb:	c1 fa 09             	sar    $0x9,%edx
c14e85ee:	89 d1                	mov    %edx,%ecx
c14e85f0:	09 c1                	or     %eax,%ecx
c14e85f2:	74 32                	je     c14e8626 <generic_make_request+0xec>
c14e85f4:	8b 0b                	mov    (%ebx),%ecx
c14e85f6:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
c14e85f9:	8b 4b 04             	mov    0x4(%ebx),%ecx
c14e85fc:	8b 75 c0             	mov    -0x40(%ebp),%esi
c14e85ff:	31 ff                	xor    %edi,%edi
c14e8601:	83 fa 00             	cmp    $0x0,%edx
c14e8604:	77 09                	ja     c14e860f <generic_make_request+0xd5>
c14e8606:	3b 45 c0             	cmp    -0x40(%ebp),%eax
c14e8609:	0f 82 21 02 00 00    	jb     c14e8830 <generic_make_request+0x2f6>
c14e860f:	29 f0                	sub    %esi,%eax
c14e8611:	19 fa                	sbb    %edi,%edx
c14e8613:	39 ca                	cmp    %ecx,%edx
c14e8615:	77 0f                	ja     c14e8626 <generic_make_request+0xec>
c14e8617:	0f 82 13 02 00 00    	jb     c14e8830 <generic_make_request+0x2f6>
c14e861d:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
c14e8620:	0f 82 0a 02 00 00    	jb     c14e8830 <generic_make_request+0x2f6>
c14e8626:	c7 45 b4 00 00 00 00 	movl   $0x0,-0x4c(%ebp)
c14e862d:	c7 45 b8 ff ff ff ff 	movl   $0xffffffff,-0x48(%ebp)
c14e8634:	c7 45 bc ff ff ff ff 	movl   $0xffffffff,-0x44(%ebp)
c14e863b:	8b 45 c0             	mov    -0x40(%ebp),%eax
c14e863e:	89 45 9c             	mov    %eax,-0x64(%ebp)
c14e8641:	c7 45 a0 00 00 00 00 	movl   $0x0,-0x60(%ebp)
c14e8648:	8b 43 0c             	mov    0xc(%ebx),%eax
c14e864b:	89 45 98             	mov    %eax,-0x68(%ebp)
c14e864e:	89 c2                	mov    %eax,%edx
c14e8650:	8b 40 58             	mov    0x58(%eax),%eax
c14e8653:	8b 80 c8 01 00 00    	mov    0x1c8(%eax),%eax
c14e8659:	89 45 c4             	mov    %eax,-0x3c(%ebp)
c14e865c:	85 c0                	test   %eax,%eax
c14e865e:	75 33                	jne    c14e8693 <generic_make_request+0x159>
c14e8660:	89 d1                	mov    %edx,%ecx
c14e8662:	8b 33                	mov    (%ebx),%esi
c14e8664:	8b 7b 04             	mov    0x4(%ebx),%edi
c14e8667:	8d 55 d0             	lea    -0x30(%ebp),%edx
c14e866a:	89 c8                	mov    %ecx,%eax
c14e866c:	e8 27 8c c2 ff       	call   c1111298 <bdevname>
c14e8671:	89 74 24 08          	mov    %esi,0x8(%esp)
c14e8675:	89 7c 24 0c          	mov    %edi,0xc(%esp)
c14e8679:	89 44 24 04          	mov    %eax,0x4(%esp)
c14e867d:	c7 04 24 52 b5 01 c2 	movl   $0xc201b552,(%esp)
c14e8684:	e8 79 17 87 00       	call   c1d59e02 <printk>
c14e8689:	ba fb ff ff ff       	mov    $0xfffffffb,%edx
c14e868e:	e9 43 02 00 00       	jmp    c14e88d6 <generic_make_request+0x39c>
c14e8693:	f6 43 14 40          	testb  $0x40,0x14(%ebx)
c14e8697:	75 36                	jne    c14e86cf <generic_make_request+0x195>
c14e8699:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c14e869c:	8b b9 3c 02 00 00    	mov    0x23c(%ecx),%edi
c14e86a2:	39 7d c0             	cmp    %edi,-0x40(%ebp)
c14e86a5:	76 28                	jbe    c14e86cf <generic_make_request+0x195>
c14e86a7:	8b 4d 98             	mov    -0x68(%ebp),%ecx
c14e86aa:	8b 73 20             	mov    0x20(%ebx),%esi
c14e86ad:	c1 ee 09             	shr    $0x9,%esi
c14e86b0:	8d 55 d0             	lea    -0x30(%ebp),%edx
c14e86b3:	89 c8                	mov    %ecx,%eax
c14e86b5:	e8 de 8b c2 ff       	call   c1111298 <bdevname>
c14e86ba:	89 7c 24 0c          	mov    %edi,0xc(%esp)
c14e86be:	89 74 24 08          	mov    %esi,0x8(%esp)
c14e86c2:	89 44 24 04          	mov    %eax,0x4(%esp)
c14e86c6:	c7 04 24 9f b5 01 c2 	movl   $0xc201b59f,(%esp)
c14e86cd:	eb b5                	jmp    c14e8684 <generic_make_request+0x14a>
c14e86cf:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c14e86d2:	8b 82 a4 01 00 00    	mov    0x1a4(%edx),%eax
c14e86d8:	a8 20                	test   $0x20,%al
c14e86da:	75 ad                	jne    c14e8689 <generic_make_request+0x14f>
c14e86dc:	8b 43 20             	mov    0x20(%ebx),%eax
c14e86df:	c1 e8 09             	shr    $0x9,%eax
c14e86e2:	0f 84 80 00 00 00    	je     c14e8768 <generic_make_request+0x22e>
c14e86e8:	8b 45 98             	mov    -0x68(%ebp),%eax
c14e86eb:	3b 40 44             	cmp    0x44(%eax),%eax
c14e86ee:	74 78                	je     c14e8768 <generic_make_request+0x22e>
c14e86f0:	8b 50 4c             	mov    0x4c(%eax),%edx
c14e86f3:	89 55 a8             	mov    %edx,-0x58(%ebp)
c14e86f6:	8b 32                	mov    (%edx),%esi
c14e86f8:	8b 7a 04             	mov    0x4(%edx),%edi
c14e86fb:	03 33                	add    (%ebx),%esi
c14e86fd:	13 7b 04             	adc    0x4(%ebx),%edi
c14e8700:	89 33                	mov    %esi,(%ebx)
c14e8702:	89 7b 04             	mov    %edi,0x4(%ebx)
c14e8705:	8b 40 44             	mov    0x44(%eax),%eax
c14e8708:	89 45 a4             	mov    %eax,-0x5c(%ebp)
c14e870b:	89 43 0c             	mov    %eax,0xc(%ebx)
c14e870e:	89 f2                	mov    %esi,%edx
c14e8710:	89 f9                	mov    %edi,%ecx
c14e8712:	8b 45 a8             	mov    -0x58(%ebp),%eax
c14e8715:	2b 10                	sub    (%eax),%edx
c14e8717:	1b 48 04             	sbb    0x4(%eax),%ecx
c14e871a:	89 55 a8             	mov    %edx,-0x58(%ebp)
c14e871d:	89 4d ac             	mov    %ecx,-0x54(%ebp)
c14e8720:	8b 45 98             	mov    -0x68(%ebp),%eax
c14e8723:	8b 38                	mov    (%eax),%edi
c14e8725:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c14e8728:	8b 42 58             	mov    0x58(%edx),%eax
c14e872b:	8b 80 c8 01 00 00    	mov    0x1c8(%eax),%eax
c14e8731:	89 45 a4             	mov    %eax,-0x5c(%ebp)
c14e8734:	e9 00 00 00 00       	jmp    c14e8739 <generic_make_request+0x1ff>
c14e8739:	eb 2d                	jmp    c14e8768 <generic_make_request+0x22e>
c14e873b:	8b 35 84 4e 2a c2    	mov    0xc22a4e84,%esi
c14e8741:	85 f6                	test   %esi,%esi
c14e8743:	74 23                	je     c14e8768 <generic_make_request+0x22e>
c14e8745:	8b 46 04             	mov    0x4(%esi),%eax
c14e8748:	8b 55 a8             	mov    -0x58(%ebp),%edx
c14e874b:	8b 4d ac             	mov    -0x54(%ebp),%ecx
c14e874e:	89 54 24 04          	mov    %edx,0x4(%esp)
c14e8752:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c14e8756:	89 3c 24             	mov    %edi,(%esp)
c14e8759:	89 d9                	mov    %ebx,%ecx
c14e875b:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c14e875e:	ff 16                	call   *(%esi)
c14e8760:	83 c6 08             	add    $0x8,%esi
c14e8763:	83 3e 00             	cmpl   $0x0,(%esi)
c14e8766:	eb db                	jmp    c14e8743 <generic_make_request+0x209>
c14e8768:	89 d8                	mov    %ebx,%eax
c14e876a:	e8 a1 a2 c0 ff       	call   c10f2a10 <bio_integrity_enabled>
c14e876f:	85 c0                	test   %eax,%eax
c14e8771:	74 0f                	je     c14e8782 <generic_make_request+0x248>
c14e8773:	89 d8                	mov    %ebx,%eax
c14e8775:	e8 06 a4 c0 ff       	call   c10f2b80 <bio_integrity_prep>
c14e877a:	85 c0                	test   %eax,%eax
c14e877c:	0f 85 07 ff ff ff    	jne    c14e8689 <generic_make_request+0x14f>
c14e8782:	83 7d bc ff          	cmpl   $0xffffffff,-0x44(%ebp)
c14e8786:	75 06                	jne    c14e878e <generic_make_request+0x254>
c14e8788:	83 7d b8 ff          	cmpl   $0xffffffff,-0x48(%ebp)
c14e878c:	74 37                	je     c14e87c5 <generic_make_request+0x28b>
c14e878e:	e9 00 00 00 00       	jmp    c14e8793 <generic_make_request+0x259>
c14e8793:	eb 30                	jmp    c14e87c5 <generic_make_request+0x28b>
c14e8795:	8b 35 84 4e 2a c2    	mov    0xc22a4e84,%esi
c14e879b:	85 f6                	test   %esi,%esi
c14e879d:	74 26                	je     c14e87c5 <generic_make_request+0x28b>
c14e879f:	8b 46 04             	mov    0x4(%esi),%eax
c14e87a2:	8b 55 b8             	mov    -0x48(%ebp),%edx
c14e87a5:	8b 4d bc             	mov    -0x44(%ebp),%ecx
c14e87a8:	89 54 24 04          	mov    %edx,0x4(%esp)
c14e87ac:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c14e87b0:	8b 4d b4             	mov    -0x4c(%ebp),%ecx
c14e87b3:	89 0c 24             	mov    %ecx,(%esp)
c14e87b6:	89 d9                	mov    %ebx,%ecx
c14e87b8:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c14e87bb:	ff 16                	call   *(%esi)
c14e87bd:	83 c6 08             	add    $0x8,%esi
c14e87c0:	83 3e 00             	cmpl   $0x0,(%esi)
c14e87c3:	eb d8                	jmp    c14e879d <generic_make_request+0x263>
c14e87c5:	8b 03                	mov    (%ebx),%eax
c14e87c7:	8b 53 04             	mov    0x4(%ebx),%edx
c14e87ca:	89 45 b8             	mov    %eax,-0x48(%ebp)
c14e87cd:	89 55 bc             	mov    %edx,-0x44(%ebp)
c14e87d0:	8b 43 0c             	mov    0xc(%ebx),%eax
c14e87d3:	8b 10                	mov    (%eax),%edx
c14e87d5:	89 55 b4             	mov    %edx,-0x4c(%ebp)
c14e87d8:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
c14e87dc:	74 5e                	je     c14e883c <generic_make_request+0x302>
c14e87de:	8b 50 08             	mov    0x8(%eax),%edx
c14e87e1:	8b 82 84 00 00 00    	mov    0x84(%edx),%eax
c14e87e7:	a8 01                	test   $0x1,%al
c14e87e9:	74 04                	je     c14e87ef <generic_make_request+0x2b5>
c14e87eb:	f3 90                	pause  
c14e87ed:	eb f2                	jmp    c14e87e1 <generic_make_request+0x2a7>
c14e87ef:	8b 72 7c             	mov    0x7c(%edx),%esi
c14e87f2:	8b ba 80 00 00 00    	mov    0x80(%edx),%edi
c14e87f8:	39 82 84 00 00 00    	cmp    %eax,0x84(%edx)
c14e87fe:	75 e1                	jne    c14e87e1 <generic_make_request+0x2a7>
c14e8800:	89 f0                	mov    %esi,%eax
c14e8802:	89 fa                	mov    %edi,%edx
c14e8804:	0f ac d0 09          	shrd   $0x9,%edx,%eax
c14e8808:	c1 fa 09             	sar    $0x9,%edx
c14e880b:	89 d1                	mov    %edx,%ecx
c14e880d:	09 c1                	or     %eax,%ecx
c14e880f:	74 2b                	je     c14e883c <generic_make_request+0x302>
c14e8811:	8b 33                	mov    (%ebx),%esi
c14e8813:	8b 4b 04             	mov    0x4(%ebx),%ecx
c14e8816:	83 fa 00             	cmp    $0x0,%edx
c14e8819:	77 05                	ja     c14e8820 <generic_make_request+0x2e6>
c14e881b:	3b 45 c0             	cmp    -0x40(%ebp),%eax
c14e881e:	72 10                	jb     c14e8830 <generic_make_request+0x2f6>
c14e8820:	2b 45 9c             	sub    -0x64(%ebp),%eax
c14e8823:	1b 55 a0             	sbb    -0x60(%ebp),%edx
c14e8826:	39 ca                	cmp    %ecx,%edx
c14e8828:	77 12                	ja     c14e883c <generic_make_request+0x302>
c14e882a:	72 04                	jb     c14e8830 <generic_make_request+0x2f6>
c14e882c:	39 f0                	cmp    %esi,%eax
c14e882e:	73 0c                	jae    c14e883c <generic_make_request+0x302>
c14e8830:	89 d8                	mov    %ebx,%eax
c14e8832:	e8 87 e7 ff ff       	call   c14e6fbe <handle_bad_sector>
c14e8837:	e9 4d fe ff ff       	jmp    c14e8689 <generic_make_request+0x14f>
c14e883c:	8b 43 14             	mov    0x14(%ebx),%eax
c14e883f:	a9 00 10 80 00       	test   $0x801000,%eax
c14e8844:	74 1a                	je     c14e8860 <generic_make_request+0x326>
c14e8846:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c14e8849:	83 ba 7c 02 00 00 00 	cmpl   $0x0,0x27c(%edx)
c14e8850:	75 0e                	jne    c14e8860 <generic_make_request+0x326>
c14e8852:	25 ff ef 7f ff       	and    $0xff7fefff,%eax
c14e8857:	89 43 14             	mov    %eax,0x14(%ebx)
c14e885a:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
c14e885e:	74 6d                	je     c14e88cd <generic_make_request+0x393>
c14e8860:	8b 43 14             	mov    0x14(%ebx),%eax
c14e8863:	a8 40                	test   $0x40,%al
c14e8865:	74 2d                	je     c14e8894 <generic_make_request+0x35a>
c14e8867:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c14e886a:	8b 91 a4 01 00 00    	mov    0x1a4(%ecx),%edx
c14e8870:	80 e6 40             	and    $0x40,%dh
c14e8873:	74 5c                	je     c14e88d1 <generic_make_request+0x397>
c14e8875:	a9 00 00 00 08       	test   $0x8000000,%eax
c14e887a:	74 18                	je     c14e8894 <generic_make_request+0x35a>
c14e887c:	8b 81 a4 01 00 00    	mov    0x1a4(%ecx),%eax
c14e8882:	f6 c4 40             	test   $0x40,%ah
c14e8885:	74 4a                	je     c14e88d1 <generic_make_request+0x397>
c14e8887:	8b 81 a4 01 00 00    	mov    0x1a4(%ecx),%eax
c14e888d:	a9 00 00 02 00       	test   $0x20000,%eax
c14e8892:	74 3d                	je     c14e88d1 <generic_make_request+0x397>
c14e8894:	85 db                	test   %ebx,%ebx
c14e8896:	74 45                	je     c14e88dd <generic_make_request+0x3a3>
c14e8898:	e9 00 00 00 00       	jmp    c14e889d <generic_make_request+0x363>
c14e889d:	eb 1c                	jmp    c14e88bb <generic_make_request+0x381>
c14e889f:	8b 35 fc 4e 2a c2    	mov    0xc22a4efc,%esi
c14e88a5:	85 f6                	test   %esi,%esi
c14e88a7:	74 12                	je     c14e88bb <generic_make_request+0x381>
c14e88a9:	8b 46 04             	mov    0x4(%esi),%eax
c14e88ac:	89 d9                	mov    %ebx,%ecx
c14e88ae:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c14e88b1:	ff 16                	call   *(%esi)
c14e88b3:	83 c6 08             	add    $0x8,%esi
c14e88b6:	83 3e 00             	cmpl   $0x0,(%esi)
c14e88b9:	eb ec                	jmp    c14e88a7 <generic_make_request+0x36d>
c14e88bb:	89 da                	mov    %ebx,%edx
c14e88bd:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c14e88c0:	ff 50 44             	call   *0x44(%eax)
c14e88c3:	85 c0                	test   %eax,%eax
c14e88c5:	0f 85 7d fd ff ff    	jne    c14e8648 <generic_make_request+0x10e>
c14e88cb:	eb 10                	jmp    c14e88dd <generic_make_request+0x3a3>
c14e88cd:	31 d2                	xor    %edx,%edx
c14e88cf:	eb 05                	jmp    c14e88d6 <generic_make_request+0x39c>
c14e88d1:	ba a1 ff ff ff       	mov    $0xffffffa1,%edx
c14e88d6:	89 d8                	mov    %ebx,%eax
c14e88d8:	e8 b8 49 c0 ff       	call   c10ed295 <bio_endio>
c14e88dd:	8b 55 b0             	mov    -0x50(%ebp),%edx
c14e88e0:	8b 82 f4 02 00 00    	mov    0x2f4(%edx),%eax
c14e88e6:	8b 18                	mov    (%eax),%ebx
c14e88e8:	85 db                	test   %ebx,%ebx
c14e88ea:	74 1c                	je     c14e8908 <generic_make_request+0x3ce>
c14e88ec:	8b 53 08             	mov    0x8(%ebx),%edx
c14e88ef:	89 10                	mov    %edx,(%eax)
c14e88f1:	85 d2                	test   %edx,%edx
c14e88f3:	75 07                	jne    c14e88fc <generic_make_request+0x3c2>
c14e88f5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
c14e88fc:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
c14e8903:	e9 a1 fc ff ff       	jmp    c14e85a9 <generic_make_request+0x6f>
c14e8908:	8b 4d b0             	mov    -0x50(%ebp),%ecx
c14e890b:	c7 81 f4 02 00 00 00 	movl   $0x0,0x2f4(%ecx)
c14e8912:	00 00 00 
c14e8915:	8b 45 f0             	mov    -0x10(%ebp),%eax
c14e8918:	65 33 05 14 00 00 00 	xor    %gs:0x14,%eax
c14e891f:	74 05                	je     c14e8926 <generic_make_request+0x3ec>
c14e8921:	e8 56 27 b5 ff       	call   c103b07c <__stack_chk_fail>
c14e8926:	83 c4 6c             	add    $0x6c,%esp
c14e8929:	5b                   	pop    %ebx
c14e892a:	5e                   	pop    %esi
c14e892b:	5f                   	pop    %edi
c14e892c:	5d                   	pop    %ebp
c14e892d:	c3                   	ret    

The crash is at:

  c14e85ac:       c1 ea 09                shr    $0x9,%edx
  c14e85af:       89 55 c0                mov    %edx,-0x40(%ebp)
  c14e85b2:       e8 e3 8c 88 00          call   c1d7129a <_cond_resched>
  c14e85b7:       83 7d c0 00             cmpl   $0x0,-0x40(%ebp)
  c14e85bb:       74 69                   je     c14e8626 <generic_make_request+0xec>
  c14e85bd:       8b 43 0c                mov    0xc(%ebx),%eax
* c14e85c0:       8b 40 08                mov    0x8(%eax),%eax   <==== [ **CRASH** ]
  c14e85c3:       8b 90 84 00 00 00       mov    0x84(%eax),%edx
  c14e85c9:       f6 c2 01                test   $0x1,%dl

which corresponds to:

1414	
1415		if (!nr_sectors)
1416			return 0;
1417	
1418		/* Test device or partition size, when known. */
1419		maxsector = i_size_read(bio->bi_bdev->bd_inode) >> 9;   <==== [ **CRASH** ]
1420		if (maxsector) {
1421			sector_t sector = bio->bi_sector;
1422	
1423			if (maxsector < nr_sectors || maxsector - nr_sectors < sector) {

bio->bi_bdev has become NULL?

I do not think the _cond_resched() was called, judging from stack contents. But 
we just had an IRQ:

 [<c1d74030>] ? common_interrupt+0x30/0x40

So we might have raced with block IO IRQ queue-completion/submission activites.

But maybe it was a reschedule after all, just the stack does not carry any 
traces of it anymore. IRQs do not clear ->bi_bdev, right? Unless the bio 
refcounts are wrong and an IRQ's completion actually frees the bio, right?

I've built a CONFIG_DEBUG_PAGEALLOC=y and CONFIG_SLUB_DEBUG=y kernel, maybe the 
crash triggers in a more revealing way.

Thanks,

	Ingo

--ftEhullJWpWg/VHq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config.zipproblem2"

#
# Automatically generated make config: don't edit
# Linux/i386 2.6.39-rc5 Kernel Configuration
# Wed May  4 11:12:22 2011
#
# CONFIG_64BIT is not set
CONFIG_X86_32=y
# CONFIG_X86_64 is not set
CONFIG_X86=y
CONFIG_INSTRUCTION_DECODER=y
CONFIG_OUTPUT_FORMAT="elf32-i386"
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/i386_defconfig"
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_MMU=y
CONFIG_ZONE_DMA=y
CONFIG_NEED_DMA_MAP_STATE=y
CONFIG_NEED_SG_DMA_LENGTH=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_GENERIC_GPIO=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
# CONFIG_RWSEM_GENERIC_SPINLOCK is not set
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
CONFIG_ARCH_HAS_CPU_IDLE_WAIT=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
# CONFIG_GENERIC_TIME_VSYSCALL is not set
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_DEFAULT_IDLE=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
# CONFIG_HAVE_CPUMASK_OF_CPU_MAP is not set
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
# CONFIG_ZONE_DMA32 is not set
CONFIG_ARCH_POPULATES_NODE_MAP=y
# CONFIG_AUDIT_ARCH is not set
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_HAVE_INTEL_TXT=y
CONFIG_X86_32_SMP=y
CONFIG_X86_HT=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-ecx -fcall-saved-edx"
CONFIG_KTIME_SCALAR=y
CONFIG_ARCH_CPU_PROBE_RELEASE=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_CONSTRUCTORS=y
CONFIG_HAVE_IRQ_WORK=y
CONFIG_IRQ_WORK=y

#
# General setup
#
CONFIG_EXPERIMENTAL=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_CROSS_COMPILE=""
CONFIG_LOCALVERSION="-i486-1sys"
# CONFIG_LOCALVERSION_AUTO is not set
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_XZ=y
CONFIG_HAVE_KERNEL_LZO=y
CONFIG_KERNEL_GZIP=y
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
# CONFIG_FHANDLE is not set
# CONFIG_TASKSTATS is not set
CONFIG_AUDIT=y
CONFIG_AUDITSYSCALL=y
CONFIG_AUDIT_WATCH=y
CONFIG_AUDIT_TREE=y
CONFIG_HAVE_GENERIC_HARDIRQS=y

#
# IRQ subsystem
#
CONFIG_GENERIC_HARDIRQS=y
CONFIG_HAVE_SPARSE_IRQ=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_IRQ_FORCED_THREADING=y
# CONFIG_SPARSE_IRQ is not set

#
# RCU Subsystem
#
CONFIG_TREE_RCU=y
# CONFIG_PREEMPT_RCU is not set
# CONFIG_RCU_TRACE is not set
CONFIG_RCU_FANOUT=32
# CONFIG_RCU_FANOUT_EXACT is not set
# CONFIG_TREE_RCU_TRACE is not set
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=21
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
# CONFIG_CGROUP_NS is not set
# CONFIG_CGROUP_FREEZER is not set
# CONFIG_CGROUP_DEVICE is not set
# CONFIG_CPUSETS is not set
# CONFIG_CGROUP_CPUACCT is not set
# CONFIG_RESOURCE_COUNTERS is not set
# CONFIG_CGROUP_PERF is not set
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
# CONFIG_RT_GROUP_SCHED is not set
# CONFIG_BLK_CGROUP is not set
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
CONFIG_IPC_NS=y
CONFIG_USER_NS=y
CONFIG_PID_NS=y
CONFIG_NET_NS=y
CONFIG_SCHED_AUTOGROUP=y
CONFIG_SYSFS_DEPRECATED=y
# CONFIG_SYSFS_DEPRECATED_V2 is not set
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
CONFIG_RD_LZMA=y
CONFIG_RD_XZ=y
CONFIG_RD_LZO=y
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
CONFIG_EXPERT=y
CONFIG_UID16=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
# CONFIG_KALLSYMS_EXTRA_PASS is not set
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_EMBEDDED=y
CONFIG_HAVE_PERF_EVENTS=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_PERF_COUNTERS is not set
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_PCI_QUIRKS=y
CONFIG_SLUB_DEBUG=y
CONFIG_COMPAT_BRK=y
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
CONFIG_OPROFILE=y
CONFIG_OPROFILE_EVENT_MULTIPLEX=y
CONFIG_HAVE_OPROFILE=y
# CONFIG_KPROBES is not set
CONFIG_JUMP_LABEL=y
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_OPTPROBES=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_ATTRS=y
CONFIG_USE_GENERIC_SMP_HELPERS=y
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
CONFIG_HAVE_DMA_API_DEBUG=y
CONFIG_HAVE_HW_BREAKPOINT=y
CONFIG_HAVE_MIXED_BREAKPOINTS_REGS=y
CONFIG_HAVE_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_PERF_EVENTS_NMI=y
CONFIG_HAVE_ARCH_JUMP_LABEL=y

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
CONFIG_HAVE_GENERIC_DMA_COHERENT=y
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
CONFIG_MODULE_FORCE_LOAD=y
CONFIG_MODULE_UNLOAD=y
CONFIG_MODULE_FORCE_UNLOAD=y
# CONFIG_MODVERSIONS is not set
# CONFIG_MODULE_SRCVERSION_ALL is not set
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_LBDAF=y
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_INTEGRITY=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
# CONFIG_DEFAULT_DEADLINE is not set
CONFIG_DEFAULT_CFQ=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="cfq"
CONFIG_PREEMPT_NOTIFIERS=y
CONFIG_PADATA=y
# CONFIG_INLINE_SPIN_TRYLOCK is not set
# CONFIG_INLINE_SPIN_TRYLOCK_BH is not set
# CONFIG_INLINE_SPIN_LOCK is not set
# CONFIG_INLINE_SPIN_LOCK_BH is not set
# CONFIG_INLINE_SPIN_LOCK_IRQ is not set
# CONFIG_INLINE_SPIN_LOCK_IRQSAVE is not set
CONFIG_INLINE_SPIN_UNLOCK=y
# CONFIG_INLINE_SPIN_UNLOCK_BH is not set
CONFIG_INLINE_SPIN_UNLOCK_IRQ=y
# CONFIG_INLINE_SPIN_UNLOCK_IRQRESTORE is not set
# CONFIG_INLINE_READ_TRYLOCK is not set
# CONFIG_INLINE_READ_LOCK is not set
# CONFIG_INLINE_READ_LOCK_BH is not set
# CONFIG_INLINE_READ_LOCK_IRQ is not set
# CONFIG_INLINE_READ_LOCK_IRQSAVE is not set
CONFIG_INLINE_READ_UNLOCK=y
# CONFIG_INLINE_READ_UNLOCK_BH is not set
CONFIG_INLINE_READ_UNLOCK_IRQ=y
# CONFIG_INLINE_READ_UNLOCK_IRQRESTORE is not set
# CONFIG_INLINE_WRITE_TRYLOCK is not set
# CONFIG_INLINE_WRITE_LOCK is not set
# CONFIG_INLINE_WRITE_LOCK_BH is not set
# CONFIG_INLINE_WRITE_LOCK_IRQ is not set
# CONFIG_INLINE_WRITE_LOCK_IRQSAVE is not set
CONFIG_INLINE_WRITE_UNLOCK=y
# CONFIG_INLINE_WRITE_UNLOCK_BH is not set
CONFIG_INLINE_WRITE_UNLOCK_IRQ=y
# CONFIG_INLINE_WRITE_UNLOCK_IRQRESTORE is not set
CONFIG_MUTEX_SPIN_ON_OWNER=y
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_TICK_ONESHOT=y
# CONFIG_NO_HZ is not set
CONFIG_HIGH_RES_TIMERS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_SMP=y
CONFIG_X86_MPPARSE=y
CONFIG_X86_BIGSMP=y
CONFIG_X86_EXTENDED_PLATFORM=y
CONFIG_X86_ELAN=y
# CONFIG_X86_MRST is not set
CONFIG_X86_RDC321X=y
# CONFIG_X86_32_NON_STANDARD is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
CONFIG_X86_32_IRIS=y
CONFIG_SCHED_OMIT_FRAME_POINTER=y
CONFIG_PARAVIRT_GUEST=y
# CONFIG_XEN_PRIVILEGED_GUEST is not set
CONFIG_KVM_CLOCK=y
CONFIG_KVM_GUEST=y
CONFIG_LGUEST_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_SPINLOCKS is not set
CONFIG_PARAVIRT_CLOCK=y
CONFIG_NO_BOOTMEM=y
CONFIG_MEMTEST=y
CONFIG_X86_INTERNODE_CACHE_SHIFT=4
CONFIG_X86_CMPXCHG=y
CONFIG_CMPXCHG_LOCAL=y
CONFIG_X86_L1_CACHE_SHIFT=4
CONFIG_X86_XADD=y
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_INVLPG=y
CONFIG_X86_BSWAP=y
CONFIG_X86_POPAD_OK=y
CONFIG_X86_ALIGNMENT_16=y
CONFIG_X86_MINIMUM_CPU_FAMILY=4
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_PROCESSOR_SELECT=y
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_CYRIX_32=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_CPU_SUP_TRANSMETA_32=y
CONFIG_CPU_SUP_UMC_32=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
# CONFIG_IOMMU_HELPER is not set
CONFIG_IOMMU_API=y
CONFIG_NR_CPUS=32
CONFIG_SCHED_SMT=y
CONFIG_SCHED_MC=y
# CONFIG_IRQ_TIME_ACCOUNTING is not set
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y
CONFIG_X86_MCE_AMD=y
CONFIG_X86_ANCIENT_MCE=y
CONFIG_X86_MCE_THRESHOLD=y
CONFIG_X86_MCE_INJECT=y
CONFIG_X86_THERMAL_VECTOR=y
CONFIG_VM86=y
# CONFIG_TOSHIBA is not set
CONFIG_I8K=y
CONFIG_X86_REBOOTFIXUPS=y
CONFIG_MICROCODE=y
CONFIG_MICROCODE_INTEL=y
CONFIG_MICROCODE_AMD=y
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
# CONFIG_NOHIGHMEM is not set
CONFIG_HIGHMEM4G=y
# CONFIG_HIGHMEM64G is not set
CONFIG_VMSPLIT_3G=y
# CONFIG_VMSPLIT_3G_OPT is not set
# CONFIG_VMSPLIT_2G is not set
# CONFIG_VMSPLIT_2G_OPT is not set
# CONFIG_VMSPLIT_1G is not set
CONFIG_PAGE_OFFSET=0xC0000000
CONFIG_HIGHMEM=y
# CONFIG_ARCH_PHYS_ADDR_T_64BIT is not set
# CONFIG_ARCH_DMA_ADDR_T_64BIT is not set
CONFIG_ARCH_FLATMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ILLEGAL_POINTER_VALUE=0
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_FLATMEM_MANUAL=y
# CONFIG_SPARSEMEM_MANUAL is not set
CONFIG_FLATMEM=y
CONFIG_FLAT_NODE_MEM_MAP=y
CONFIG_SPARSEMEM_STATIC=y
CONFIG_HAVE_MEMBLOCK=y
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
# CONFIG_PHYS_ADDR_T_64BIT is not set
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_MMU_NOTIFIER=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=65536
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
CONFIG_MEMORY_FAILURE=y
CONFIG_TRANSPARENT_HUGEPAGE=y
CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS=y
# CONFIG_TRANSPARENT_HUGEPAGE_MADVISE is not set
CONFIG_HIGHPTE=y
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK=y
CONFIG_X86_RESERVE_LOW=64
CONFIG_MATH_EMULATION=y
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
CONFIG_EFI=y
CONFIG_SECCOMP=y
CONFIG_CC_STACKPROTECTOR=y
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
CONFIG_HZ_1000=y
CONFIG_HZ=1000
CONFIG_SCHED_HRTICK=y
# CONFIG_KEXEC is not set
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x100000
CONFIG_HOTPLUG_CPU=y
CONFIG_COMPAT_VDSO=y
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management and ACPI options
#
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_HIBERNATE_CALLBACKS=y
CONFIG_HIBERNATION=y
CONFIG_PM_STD_PARTITION="\"\""
CONFIG_PM_SLEEP=y
CONFIG_PM_SLEEP_SMP=y
CONFIG_PM_RUNTIME=y
CONFIG_PM=y
# CONFIG_PM_DEBUG is not set
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
CONFIG_ACPI_PROCFS=y
CONFIG_ACPI_PROCFS_POWER=y
CONFIG_ACPI_POWER_METER=m
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_PROC_EVENT=y
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_VIDEO=y
CONFIG_ACPI_FAN=y
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_IPMI=m
CONFIG_ACPI_HOTPLUG_CPU=y
CONFIG_ACPI_PROCESSOR_AGGREGATOR=y
CONFIG_ACPI_THERMAL=y
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=2001
# CONFIG_ACPI_DEBUG is not set
CONFIG_ACPI_PCI_SLOT=y
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
CONFIG_ACPI_SBS=y
CONFIG_ACPI_HED=y
CONFIG_ACPI_APEI=y
CONFIG_ACPI_APEI_GHES=m
# CONFIG_ACPI_APEI_PCIEAER is not set
# CONFIG_ACPI_APEI_EINJ is not set
# CONFIG_ACPI_APEI_ERST_DEBUG is not set
CONFIG_SFI=y
CONFIG_X86_APM_BOOT=y
CONFIG_APM=y
# CONFIG_APM_IGNORE_USER_SUSPEND is not set
# CONFIG_APM_DO_ENABLE is not set
# CONFIG_APM_CPU_IDLE is not set
# CONFIG_APM_DISPLAY_BLANK is not set
# CONFIG_APM_ALLOW_INTS is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
# CONFIG_CPU_FREQ_DEBUG is not set
CONFIG_CPU_FREQ_STAT=y
CONFIG_CPU_FREQ_STAT_DETAILS=y
CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y

#
# CPUFreq processor drivers
#
CONFIG_X86_PCC_CPUFREQ=y
CONFIG_X86_ACPI_CPUFREQ=y
CONFIG_ELAN_CPUFREQ=y
CONFIG_SC520_CPUFREQ=y
CONFIG_X86_POWERNOW_K6=y
CONFIG_X86_POWERNOW_K7=y
CONFIG_X86_POWERNOW_K7_ACPI=y
CONFIG_X86_POWERNOW_K8=y
CONFIG_X86_GX_SUSPMOD=y
CONFIG_X86_SPEEDSTEP_CENTRINO=y
CONFIG_X86_SPEEDSTEP_CENTRINO_TABLE=y
CONFIG_X86_SPEEDSTEP_ICH=y
CONFIG_X86_SPEEDSTEP_SMI=y
CONFIG_X86_P4_CLOCKMOD=y
CONFIG_X86_CPUFREQ_NFORCE2=y
CONFIG_X86_LONGRUN=y
CONFIG_X86_LONGHAUL=y
CONFIG_X86_E_POWERSAVER=y

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=y
CONFIG_X86_SPEEDSTEP_RELAXED_CAP_CHECK=y
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_INTEL_IDLE=y

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
# CONFIG_PCI_GOBIOS is not set
# CONFIG_PCI_GOMMCONFIG is not set
# CONFIG_PCI_GODIRECT is not set
# CONFIG_PCI_GOOLPC is not set
CONFIG_PCI_GOANY=y
CONFIG_PCI_BIOS=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_OLPC=y
CONFIG_PCI_DOMAINS=y
CONFIG_PCI_CNB20LE_QUIRK=y
CONFIG_DMAR=y
CONFIG_DMAR_DEFAULT_ON=y
CONFIG_DMAR_FLOPPY_WA=y
CONFIG_PCIEPORTBUS=y
CONFIG_HOTPLUG_PCI_PCIE=y
CONFIG_PCIEAER=y
CONFIG_PCIE_ECRC=y
CONFIG_PCIEAER_INJECT=y
CONFIG_PCIEASPM=y
CONFIG_PCIEASPM_DEBUG=y
CONFIG_PCIE_PME=y
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
# CONFIG_PCI_STUB is not set
CONFIG_HT_IRQ=y
CONFIG_PCI_IOV=y
CONFIG_PCI_IOAPIC=y
CONFIG_PCI_LABEL=y
CONFIG_ISA_DMA_API=y
CONFIG_ISA=y
CONFIG_EISA=y
CONFIG_EISA_VLB_PRIMING=y
CONFIG_EISA_PCI_EISA=y
CONFIG_EISA_VIRTUAL_ROOT=y
CONFIG_EISA_NAMES=y
CONFIG_MCA=y
CONFIG_MCA_LEGACY=y
CONFIG_MCA_PROC_FS=y
CONFIG_SCx200=y
CONFIG_SCx200HR_TIMER=y
CONFIG_OLPC=y
CONFIG_OLPC_XO1=m
CONFIG_AMD_NB=y
CONFIG_PCCARD=y
CONFIG_PCMCIA=y
CONFIG_PCMCIA_LOAD_CIS=y
CONFIG_CARDBUS=y

#
# PC-card bridges
#
CONFIG_YENTA=y
CONFIG_YENTA_O2=y
CONFIG_YENTA_RICOH=y
CONFIG_YENTA_TI=y
CONFIG_YENTA_ENE_TUNE=y
CONFIG_YENTA_TOSHIBA=y
CONFIG_PD6729=y
CONFIG_I82092=y
CONFIG_I82365=y
CONFIG_TCIC=y
CONFIG_PCMCIA_PROBE=y
CONFIG_PCCARD_NONSTATIC=y
CONFIG_HOTPLUG_PCI=y
# CONFIG_HOTPLUG_PCI_FAKE is not set
CONFIG_HOTPLUG_PCI_COMPAQ=y
# CONFIG_HOTPLUG_PCI_COMPAQ_NVRAM is not set
CONFIG_HOTPLUG_PCI_IBM=y
CONFIG_HOTPLUG_PCI_ACPI=y
CONFIG_HOTPLUG_PCI_ACPI_IBM=y
CONFIG_HOTPLUG_PCI_CPCI=y
CONFIG_HOTPLUG_PCI_CPCI_ZT5550=y
CONFIG_HOTPLUG_PCI_CPCI_GENERIC=y
CONFIG_HOTPLUG_PCI_SHPC=y
CONFIG_RAPIDIO=y
CONFIG_RAPIDIO_DISC_TIMEOUT=30
CONFIG_RAPIDIO_ENABLE_RX_TX_PORTS=y
CONFIG_RAPIDIO_TSI57X=y
CONFIG_RAPIDIO_CPS_XX=y
CONFIG_RAPIDIO_TSI568=y
CONFIG_RAPIDIO_CPS_GEN2=y
CONFIG_RAPIDIO_TSI500=y
CONFIG_RAPIDIO_DEBUG=y

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
# CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS is not set
CONFIG_HAVE_AOUT=y
CONFIG_BINFMT_AOUT=y
CONFIG_BINFMT_MISC=y
CONFIG_HAVE_ATOMIC_IOMAP=y
CONFIG_HAVE_TEXT_POKE_SMP=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_UNIX=y
CONFIG_XFRM=y
CONFIG_XFRM_USER=y
CONFIG_XFRM_SUB_POLICY=y
CONFIG_XFRM_MIGRATE=y
CONFIG_XFRM_STATISTICS=y
CONFIG_XFRM_IPCOMP=m
CONFIG_NET_KEY=m
CONFIG_NET_KEY_MIGRATE=y
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
CONFIG_IP_ADVANCED_ROUTER=y
CONFIG_IP_FIB_TRIE_STATS=y
CONFIG_IP_MULTIPLE_TABLES=y
CONFIG_IP_ROUTE_MULTIPATH=y
CONFIG_IP_ROUTE_VERBOSE=y
CONFIG_IP_ROUTE_CLASSID=y
CONFIG_IP_PNP=y
CONFIG_IP_PNP_DHCP=y
CONFIG_IP_PNP_BOOTP=y
CONFIG_IP_PNP_RARP=y
CONFIG_NET_IPIP=y
CONFIG_NET_IPGRE_DEMUX=m
CONFIG_NET_IPGRE=m
CONFIG_NET_IPGRE_BROADCAST=y
CONFIG_IP_MROUTE=y
CONFIG_IP_MROUTE_MULTIPLE_TABLES=y
CONFIG_IP_PIMSM_V1=y
CONFIG_IP_PIMSM_V2=y
CONFIG_ARPD=y
CONFIG_SYN_COOKIES=y
CONFIG_INET_AH=m
CONFIG_INET_ESP=m
CONFIG_INET_IPCOMP=m
CONFIG_INET_XFRM_TUNNEL=m
CONFIG_INET_TUNNEL=y
CONFIG_INET_XFRM_MODE_TRANSPORT=m
CONFIG_INET_XFRM_MODE_TUNNEL=m
CONFIG_INET_XFRM_MODE_BEET=m
CONFIG_INET_LRO=y
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
CONFIG_TCP_CONG_ADVANCED=y
CONFIG_TCP_CONG_BIC=m
CONFIG_TCP_CONG_CUBIC=y
CONFIG_TCP_CONG_WESTWOOD=m
CONFIG_TCP_CONG_HTCP=m
CONFIG_TCP_CONG_HSTCP=m
CONFIG_TCP_CONG_HYBLA=m
CONFIG_TCP_CONG_VEGAS=m
CONFIG_TCP_CONG_SCALABLE=m
CONFIG_TCP_CONG_LP=m
CONFIG_TCP_CONG_VENO=m
CONFIG_TCP_CONG_YEAH=m
CONFIG_TCP_CONG_ILLINOIS=m
CONFIG_DEFAULT_CUBIC=y
# CONFIG_DEFAULT_RENO is not set
CONFIG_DEFAULT_TCP_CONG="cubic"
CONFIG_TCP_MD5SIG=y
CONFIG_IPV6=y
CONFIG_IPV6_PRIVACY=y
CONFIG_IPV6_ROUTER_PREF=y
CONFIG_IPV6_ROUTE_INFO=y
CONFIG_IPV6_OPTIMISTIC_DAD=y
CONFIG_INET6_AH=m
CONFIG_INET6_ESP=m
CONFIG_INET6_IPCOMP=m
CONFIG_IPV6_MIP6=m
CONFIG_INET6_XFRM_TUNNEL=m
CONFIG_INET6_TUNNEL=m
CONFIG_INET6_XFRM_MODE_TRANSPORT=m
CONFIG_INET6_XFRM_MODE_TUNNEL=m
CONFIG_INET6_XFRM_MODE_BEET=m
CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION=m
CONFIG_IPV6_SIT=m
CONFIG_IPV6_SIT_6RD=y
CONFIG_IPV6_NDISC_NODETYPE=y
CONFIG_IPV6_TUNNEL=m
CONFIG_IPV6_MULTIPLE_TABLES=y
CONFIG_IPV6_SUBTREES=y
CONFIG_IPV6_MROUTE=y
CONFIG_IPV6_MROUTE_MULTIPLE_TABLES=y
CONFIG_IPV6_PIMSM_V2=y
CONFIG_NETLABEL=y
# CONFIG_NETWORK_SECMARK is not set
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set
CONFIG_NETFILTER_ADVANCED=y
CONFIG_BRIDGE_NETFILTER=y

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_NETLINK=m
CONFIG_NETFILTER_NETLINK_QUEUE=m
CONFIG_NETFILTER_NETLINK_LOG=m
CONFIG_NF_CONNTRACK=m
CONFIG_NF_CONNTRACK_MARK=y
# CONFIG_NF_CONNTRACK_ZONES is not set
# CONFIG_NF_CONNTRACK_EVENTS is not set
# CONFIG_NF_CONNTRACK_TIMESTAMP is not set
CONFIG_NF_CT_PROTO_DCCP=m
CONFIG_NF_CT_PROTO_GRE=m
CONFIG_NF_CT_PROTO_SCTP=m
CONFIG_NF_CT_PROTO_UDPLITE=m
CONFIG_NF_CONNTRACK_AMANDA=m
CONFIG_NF_CONNTRACK_FTP=m
CONFIG_NF_CONNTRACK_H323=m
CONFIG_NF_CONNTRACK_IRC=m
CONFIG_NF_CONNTRACK_BROADCAST=m
CONFIG_NF_CONNTRACK_NETBIOS_NS=m
CONFIG_NF_CONNTRACK_SNMP=m
CONFIG_NF_CONNTRACK_PPTP=m
CONFIG_NF_CONNTRACK_SANE=m
CONFIG_NF_CONNTRACK_SIP=m
CONFIG_NF_CONNTRACK_TFTP=m
CONFIG_NF_CT_NETLINK=m
CONFIG_NETFILTER_TPROXY=m
CONFIG_NETFILTER_XTABLES=m

#
# Xtables combined modules
#
CONFIG_NETFILTER_XT_MARK=m
CONFIG_NETFILTER_XT_CONNMARK=m
# CONFIG_NETFILTER_XT_SET is not set

#
# Xtables targets
#
CONFIG_NETFILTER_XT_TARGET_AUDIT=m
CONFIG_NETFILTER_XT_TARGET_CHECKSUM=m
CONFIG_NETFILTER_XT_TARGET_CLASSIFY=m
CONFIG_NETFILTER_XT_TARGET_CONNMARK=m
CONFIG_NETFILTER_XT_TARGET_CT=m
CONFIG_NETFILTER_XT_TARGET_DSCP=m
CONFIG_NETFILTER_XT_TARGET_HL=m
CONFIG_NETFILTER_XT_TARGET_IDLETIMER=m
CONFIG_NETFILTER_XT_TARGET_LED=m
CONFIG_NETFILTER_XT_TARGET_MARK=m
CONFIG_NETFILTER_XT_TARGET_NFLOG=m
CONFIG_NETFILTER_XT_TARGET_NFQUEUE=m
CONFIG_NETFILTER_XT_TARGET_NOTRACK=m
CONFIG_NETFILTER_XT_TARGET_RATEEST=m
CONFIG_NETFILTER_XT_TARGET_TEE=m
CONFIG_NETFILTER_XT_TARGET_TPROXY=m
CONFIG_NETFILTER_XT_TARGET_TRACE=m
CONFIG_NETFILTER_XT_TARGET_TCPMSS=m
CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP=m

#
# Xtables matches
#
CONFIG_NETFILTER_XT_MATCH_ADDRTYPE=m
CONFIG_NETFILTER_XT_MATCH_CLUSTER=m
CONFIG_NETFILTER_XT_MATCH_COMMENT=m
CONFIG_NETFILTER_XT_MATCH_CONNBYTES=m
CONFIG_NETFILTER_XT_MATCH_CONNLIMIT=m
CONFIG_NETFILTER_XT_MATCH_CONNMARK=m
CONFIG_NETFILTER_XT_MATCH_CONNTRACK=m
CONFIG_NETFILTER_XT_MATCH_CPU=m
CONFIG_NETFILTER_XT_MATCH_DCCP=m
CONFIG_NETFILTER_XT_MATCH_DEVGROUP=m
CONFIG_NETFILTER_XT_MATCH_DSCP=m
CONFIG_NETFILTER_XT_MATCH_ESP=m
CONFIG_NETFILTER_XT_MATCH_HASHLIMIT=m
CONFIG_NETFILTER_XT_MATCH_HELPER=m
CONFIG_NETFILTER_XT_MATCH_HL=m
CONFIG_NETFILTER_XT_MATCH_IPRANGE=m
CONFIG_NETFILTER_XT_MATCH_IPVS=m
CONFIG_NETFILTER_XT_MATCH_LENGTH=m
CONFIG_NETFILTER_XT_MATCH_LIMIT=m
CONFIG_NETFILTER_XT_MATCH_MAC=m
CONFIG_NETFILTER_XT_MATCH_MARK=m
CONFIG_NETFILTER_XT_MATCH_MULTIPORT=m
CONFIG_NETFILTER_XT_MATCH_OSF=m
CONFIG_NETFILTER_XT_MATCH_OWNER=m
CONFIG_NETFILTER_XT_MATCH_POLICY=m
CONFIG_NETFILTER_XT_MATCH_PHYSDEV=m
CONFIG_NETFILTER_XT_MATCH_PKTTYPE=m
CONFIG_NETFILTER_XT_MATCH_QUOTA=m
CONFIG_NETFILTER_XT_MATCH_RATEEST=m
CONFIG_NETFILTER_XT_MATCH_REALM=m
CONFIG_NETFILTER_XT_MATCH_RECENT=m
CONFIG_NETFILTER_XT_MATCH_SCTP=m
CONFIG_NETFILTER_XT_MATCH_SOCKET=m
CONFIG_NETFILTER_XT_MATCH_STATE=m
CONFIG_NETFILTER_XT_MATCH_STATISTIC=m
CONFIG_NETFILTER_XT_MATCH_STRING=m
CONFIG_NETFILTER_XT_MATCH_TCPMSS=m
CONFIG_NETFILTER_XT_MATCH_TIME=m
CONFIG_NETFILTER_XT_MATCH_U32=m
CONFIG_IP_SET=m
CONFIG_IP_SET_MAX=256
CONFIG_IP_SET_BITMAP_IP=m
CONFIG_IP_SET_BITMAP_IPMAC=m
CONFIG_IP_SET_BITMAP_PORT=m
CONFIG_IP_SET_HASH_IP=m
CONFIG_IP_SET_HASH_IPPORT=m
CONFIG_IP_SET_HASH_IPPORTIP=m
CONFIG_IP_SET_HASH_IPPORTNET=m
CONFIG_IP_SET_HASH_NET=m
CONFIG_IP_SET_HASH_NETPORT=m
CONFIG_IP_SET_LIST_SET=m
CONFIG_IP_VS=m
CONFIG_IP_VS_IPV6=y
# CONFIG_IP_VS_DEBUG is not set
CONFIG_IP_VS_TAB_BITS=12

#
# IPVS transport protocol load balancing support
#
CONFIG_IP_VS_PROTO_TCP=y
CONFIG_IP_VS_PROTO_UDP=y
CONFIG_IP_VS_PROTO_AH_ESP=y
CONFIG_IP_VS_PROTO_ESP=y
CONFIG_IP_VS_PROTO_AH=y
CONFIG_IP_VS_PROTO_SCTP=y

#
# IPVS scheduler
#
CONFIG_IP_VS_RR=m
CONFIG_IP_VS_WRR=m
CONFIG_IP_VS_LC=m
CONFIG_IP_VS_WLC=m
CONFIG_IP_VS_LBLC=m
CONFIG_IP_VS_LBLCR=m
CONFIG_IP_VS_DH=m
CONFIG_IP_VS_SH=m
CONFIG_IP_VS_SED=m
CONFIG_IP_VS_NQ=m

#
# IPVS application helper
#
CONFIG_IP_VS_FTP=m
CONFIG_IP_VS_NFCT=y
CONFIG_IP_VS_PE_SIP=m

#
# IP: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV4=m
CONFIG_NF_CONNTRACK_IPV4=m
CONFIG_NF_CONNTRACK_PROC_COMPAT=y
CONFIG_IP_NF_QUEUE=m
CONFIG_IP_NF_IPTABLES=m
CONFIG_IP_NF_MATCH_AH=m
CONFIG_IP_NF_MATCH_ECN=m
CONFIG_IP_NF_MATCH_TTL=m
CONFIG_IP_NF_FILTER=m
CONFIG_IP_NF_TARGET_REJECT=m
CONFIG_IP_NF_TARGET_LOG=m
CONFIG_IP_NF_TARGET_ULOG=m
CONFIG_NF_NAT=m
CONFIG_NF_NAT_NEEDED=y
CONFIG_IP_NF_TARGET_MASQUERADE=m
CONFIG_IP_NF_TARGET_NETMAP=m
CONFIG_IP_NF_TARGET_REDIRECT=m
CONFIG_NF_NAT_SNMP_BASIC=m
CONFIG_NF_NAT_PROTO_DCCP=m
CONFIG_NF_NAT_PROTO_GRE=m
CONFIG_NF_NAT_PROTO_UDPLITE=m
CONFIG_NF_NAT_PROTO_SCTP=m
CONFIG_NF_NAT_FTP=m
CONFIG_NF_NAT_IRC=m
CONFIG_NF_NAT_TFTP=m
CONFIG_NF_NAT_AMANDA=m
CONFIG_NF_NAT_PPTP=m
CONFIG_NF_NAT_H323=m
CONFIG_NF_NAT_SIP=m
CONFIG_IP_NF_MANGLE=m
CONFIG_IP_NF_TARGET_CLUSTERIP=m
CONFIG_IP_NF_TARGET_ECN=m
CONFIG_IP_NF_TARGET_TTL=m
CONFIG_IP_NF_RAW=m
CONFIG_IP_NF_SECURITY=m
CONFIG_IP_NF_ARPTABLES=m
CONFIG_IP_NF_ARPFILTER=m
CONFIG_IP_NF_ARP_MANGLE=m

#
# IPv6: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV6=m
CONFIG_NF_CONNTRACK_IPV6=m
CONFIG_IP6_NF_QUEUE=m
CONFIG_IP6_NF_IPTABLES=m
CONFIG_IP6_NF_MATCH_AH=m
CONFIG_IP6_NF_MATCH_EUI64=m
CONFIG_IP6_NF_MATCH_FRAG=m
CONFIG_IP6_NF_MATCH_OPTS=m
CONFIG_IP6_NF_MATCH_HL=m
CONFIG_IP6_NF_MATCH_IPV6HEADER=m
CONFIG_IP6_NF_MATCH_MH=m
CONFIG_IP6_NF_MATCH_RT=m
CONFIG_IP6_NF_TARGET_HL=m
CONFIG_IP6_NF_TARGET_LOG=m
CONFIG_IP6_NF_FILTER=m
CONFIG_IP6_NF_TARGET_REJECT=m
CONFIG_IP6_NF_MANGLE=m
CONFIG_IP6_NF_RAW=m
CONFIG_IP6_NF_SECURITY=m

#
# DECnet: Netfilter Configuration
#
CONFIG_DECNET_NF_GRABULATOR=m
CONFIG_BRIDGE_NF_EBTABLES=m
CONFIG_BRIDGE_EBT_BROUTE=m
CONFIG_BRIDGE_EBT_T_FILTER=m
CONFIG_BRIDGE_EBT_T_NAT=m
CONFIG_BRIDGE_EBT_802_3=m
CONFIG_BRIDGE_EBT_AMONG=m
CONFIG_BRIDGE_EBT_ARP=m
CONFIG_BRIDGE_EBT_IP=m
CONFIG_BRIDGE_EBT_IP6=m
CONFIG_BRIDGE_EBT_LIMIT=m
CONFIG_BRIDGE_EBT_MARK=m
CONFIG_BRIDGE_EBT_PKTTYPE=m
CONFIG_BRIDGE_EBT_STP=m
CONFIG_BRIDGE_EBT_VLAN=m
CONFIG_BRIDGE_EBT_ARPREPLY=m
CONFIG_BRIDGE_EBT_DNAT=m
CONFIG_BRIDGE_EBT_MARK_T=m
CONFIG_BRIDGE_EBT_REDIRECT=m
CONFIG_BRIDGE_EBT_SNAT=m
CONFIG_BRIDGE_EBT_LOG=m
CONFIG_BRIDGE_EBT_ULOG=m
CONFIG_BRIDGE_EBT_NFLOG=m
CONFIG_IP_DCCP=m
CONFIG_INET_DCCP_DIAG=m

#
# DCCP CCIDs Configuration (EXPERIMENTAL)
#
# CONFIG_IP_DCCP_CCID2_DEBUG is not set
CONFIG_IP_DCCP_CCID3=y
# CONFIG_IP_DCCP_CCID3_DEBUG is not set
CONFIG_IP_DCCP_TFRC_LIB=y
CONFIG_IP_SCTP=y
# CONFIG_SCTP_DBG_MSG is not set
# CONFIG_SCTP_DBG_OBJCNT is not set
# CONFIG_SCTP_HMAC_NONE is not set
# CONFIG_SCTP_HMAC_SHA1 is not set
CONFIG_SCTP_HMAC_MD5=y
CONFIG_RDS=m
CONFIG_RDS_RDMA=m
CONFIG_RDS_TCP=m
# CONFIG_RDS_DEBUG is not set
CONFIG_TIPC=m
CONFIG_TIPC_ADVANCED=y
CONFIG_TIPC_PORTS=8191
CONFIG_TIPC_LOG=0
# CONFIG_TIPC_DEBUG is not set
CONFIG_ATM=y
CONFIG_ATM_CLIP=y
# CONFIG_ATM_CLIP_NO_ICMP is not set
CONFIG_ATM_LANE=y
CONFIG_ATM_MPOA=y
CONFIG_ATM_BR2684=m
# CONFIG_ATM_BR2684_IPFILTER is not set
CONFIG_L2TP=m
# CONFIG_L2TP_DEBUGFS is not set
CONFIG_L2TP_V3=y
CONFIG_L2TP_IP=m
CONFIG_L2TP_ETH=m
CONFIG_STP=m
CONFIG_GARP=m
CONFIG_BRIDGE=m
CONFIG_BRIDGE_IGMP_SNOOPING=y
CONFIG_NET_DSA=y
CONFIG_NET_DSA_TAG_DSA=y
CONFIG_NET_DSA_TAG_EDSA=y
CONFIG_NET_DSA_TAG_TRAILER=y
CONFIG_NET_DSA_MV88E6XXX=y
CONFIG_NET_DSA_MV88E6060=y
CONFIG_NET_DSA_MV88E6XXX_NEED_PPU=y
CONFIG_NET_DSA_MV88E6131=y
CONFIG_NET_DSA_MV88E6123_61_65=y
CONFIG_VLAN_8021Q=m
CONFIG_VLAN_8021Q_GVRP=y
CONFIG_DECNET=m
CONFIG_DECNET_ROUTER=y
CONFIG_LLC=y
CONFIG_LLC2=m
CONFIG_IPX=m
CONFIG_IPX_INTERN=y
CONFIG_ATALK=m
CONFIG_DEV_APPLETALK=m
CONFIG_LTPC=m
# CONFIG_COPS is not set
CONFIG_IPDDP=m
CONFIG_IPDDP_ENCAP=y
CONFIG_IPDDP_DECAP=y
CONFIG_X25=m
CONFIG_LAPB=m
CONFIG_ECONET=m
CONFIG_ECONET_AUNUDP=y
CONFIG_ECONET_NATIVE=y
CONFIG_WAN_ROUTER=y
CONFIG_PHONET=m
CONFIG_IEEE802154=m
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
CONFIG_NET_SCH_CBQ=m
CONFIG_NET_SCH_HTB=m
CONFIG_NET_SCH_HFSC=m
CONFIG_NET_SCH_ATM=m
CONFIG_NET_SCH_PRIO=m
CONFIG_NET_SCH_MULTIQ=m
CONFIG_NET_SCH_RED=m
# CONFIG_NET_SCH_SFB is not set
CONFIG_NET_SCH_SFQ=m
CONFIG_NET_SCH_TEQL=m
CONFIG_NET_SCH_TBF=m
CONFIG_NET_SCH_GRED=m
CONFIG_NET_SCH_DSMARK=m
CONFIG_NET_SCH_NETEM=m
CONFIG_NET_SCH_DRR=m
# CONFIG_NET_SCH_MQPRIO is not set
# CONFIG_NET_SCH_CHOKE is not set
CONFIG_NET_SCH_INGRESS=m

#
# Classification
#
CONFIG_NET_CLS=y
CONFIG_NET_CLS_BASIC=m
CONFIG_NET_CLS_TCINDEX=m
CONFIG_NET_CLS_ROUTE4=m
CONFIG_NET_CLS_FW=m
CONFIG_NET_CLS_U32=m
CONFIG_CLS_U32_PERF=y
CONFIG_CLS_U32_MARK=y
CONFIG_NET_CLS_RSVP=m
CONFIG_NET_CLS_RSVP6=m
CONFIG_NET_CLS_FLOW=m
# CONFIG_NET_CLS_CGROUP is not set
# CONFIG_NET_EMATCH is not set
CONFIG_NET_CLS_ACT=y
CONFIG_NET_ACT_POLICE=y
CONFIG_NET_ACT_GACT=m
CONFIG_GACT_PROB=y
CONFIG_NET_ACT_MIRRED=m
CONFIG_NET_ACT_IPT=m
CONFIG_NET_ACT_NAT=m
CONFIG_NET_ACT_PEDIT=m
CONFIG_NET_ACT_SIMP=m
CONFIG_NET_ACT_SKBEDIT=m
CONFIG_NET_ACT_CSUM=m
CONFIG_NET_CLS_IND=y
CONFIG_NET_SCH_FIFO=y
CONFIG_DCB=y
CONFIG_DNS_RESOLVER=y
CONFIG_BATMAN_ADV=m
# CONFIG_BATMAN_ADV_DEBUG is not set
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
# CONFIG_NET_DROP_MONITOR is not set
CONFIG_HAMRADIO=y

#
# Packet Radio protocols
#
CONFIG_AX25=m
CONFIG_AX25_DAMA_SLAVE=y
CONFIG_NETROM=m
CONFIG_ROSE=m

#
# AX.25 network device drivers
#
CONFIG_MKISS=m
CONFIG_6PACK=m
CONFIG_BPQETHER=m
CONFIG_SCC=m
CONFIG_SCC_DELAY=y
CONFIG_SCC_TRXECHO=y
CONFIG_BAYCOM_SER_FDX=m
CONFIG_BAYCOM_SER_HDX=m
CONFIG_BAYCOM_PAR=m
CONFIG_BAYCOM_EPP=m
CONFIG_YAM=m
CONFIG_CAN=m
CONFIG_CAN_RAW=m
CONFIG_CAN_BCM=m

#
# CAN Device Drivers
#
CONFIG_CAN_VCAN=m
CONFIG_CAN_SLCAN=m
CONFIG_CAN_DEV=m
CONFIG_CAN_CALC_BITTIMING=y
CONFIG_CAN_MCP251X=m
CONFIG_CAN_JANZ_ICAN3=m
CONFIG_PCH_CAN=m
CONFIG_CAN_SJA1000=m
CONFIG_CAN_SJA1000_ISA=m
CONFIG_CAN_SJA1000_PLATFORM=m
CONFIG_CAN_EMS_PCI=m
CONFIG_CAN_KVASER_PCI=m
CONFIG_CAN_PLX_PCI=m
CONFIG_CAN_TSCAN1=m
CONFIG_CAN_C_CAN=m
CONFIG_CAN_C_CAN_PLATFORM=m

#
# CAN USB interfaces
#
CONFIG_CAN_EMS_USB=m
CONFIG_CAN_ESD_USB2=m
CONFIG_CAN_SOFTING=m
CONFIG_CAN_SOFTING_CS=m
# CONFIG_CAN_DEBUG_DEVICES is not set
CONFIG_IRDA=m

#
# IrDA protocols
#
CONFIG_IRLAN=m
CONFIG_IRNET=m
CONFIG_IRCOMM=m
CONFIG_IRDA_ULTRA=y

#
# IrDA options
#
CONFIG_IRDA_CACHE_LAST_LSAP=y
CONFIG_IRDA_FAST_RR=y
# CONFIG_IRDA_DEBUG is not set

#
# Infrared-port device drivers
#

#
# SIR device drivers
#
CONFIG_IRTTY_SIR=m

#
# Dongle support
#
CONFIG_DONGLE=y
CONFIG_ESI_DONGLE=m
CONFIG_ACTISYS_DONGLE=m
CONFIG_TEKRAM_DONGLE=m
CONFIG_TOIM3232_DONGLE=m
CONFIG_LITELINK_DONGLE=m
CONFIG_MA600_DONGLE=m
CONFIG_GIRBIL_DONGLE=m
CONFIG_MCP2120_DONGLE=m
CONFIG_OLD_BELKIN_DONGLE=m
CONFIG_ACT200L_DONGLE=m
CONFIG_KINGSUN_DONGLE=m
CONFIG_KSDAZZLE_DONGLE=m
CONFIG_KS959_DONGLE=m

#
# FIR device drivers
#
CONFIG_USB_IRDA=m
CONFIG_SIGMATEL_FIR=m
CONFIG_NSC_FIR=m
CONFIG_WINBOND_FIR=m
CONFIG_TOSHIBA_FIR=m
CONFIG_SMC_IRCC_FIR=m
CONFIG_ALI_FIR=m
CONFIG_VLSI_FIR=m
CONFIG_VIA_FIR=m
CONFIG_MCS_FIR=m
CONFIG_BT=m
CONFIG_BT_L2CAP=y
CONFIG_BT_SCO=y
CONFIG_BT_RFCOMM=m
CONFIG_BT_RFCOMM_TTY=y
CONFIG_BT_BNEP=m
CONFIG_BT_BNEP_MC_FILTER=y
CONFIG_BT_BNEP_PROTO_FILTER=y
CONFIG_BT_CMTP=m
CONFIG_BT_HIDP=m

#
# Bluetooth device drivers
#
CONFIG_BT_HCIBTUSB=m
CONFIG_BT_HCIBTSDIO=m
CONFIG_BT_HCIUART=m
CONFIG_BT_HCIUART_H4=y
CONFIG_BT_HCIUART_BCSP=y
CONFIG_BT_HCIUART_ATH3K=y
CONFIG_BT_HCIUART_LL=y
CONFIG_BT_HCIBCM203X=m
CONFIG_BT_HCIBPA10X=m
CONFIG_BT_HCIBFUSB=m
CONFIG_BT_HCIDTL1=m
CONFIG_BT_HCIBT3C=m
CONFIG_BT_HCIBLUECARD=m
CONFIG_BT_HCIBTUART=m
CONFIG_BT_HCIVHCI=m
CONFIG_BT_MRVL=m
CONFIG_BT_MRVL_SDIO=m
CONFIG_BT_ATH3K=m
CONFIG_BT_WILINK=m
CONFIG_AF_RXRPC=y
# CONFIG_AF_RXRPC_DEBUG is not set
CONFIG_RXKAD=m
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
CONFIG_WIRELESS_EXT=y
CONFIG_WEXT_CORE=y
CONFIG_WEXT_PROC=y
CONFIG_WEXT_SPY=y
CONFIG_WEXT_PRIV=y
CONFIG_CFG80211=m
# CONFIG_NL80211_TESTMODE is not set
# CONFIG_CFG80211_DEVELOPER_WARNINGS is not set
# CONFIG_CFG80211_REG_DEBUG is not set
CONFIG_CFG80211_DEFAULT_PS=y
# CONFIG_CFG80211_DEBUGFS is not set
# CONFIG_CFG80211_INTERNAL_REGDB is not set
CONFIG_CFG80211_WEXT=y
CONFIG_WIRELESS_EXT_SYSFS=y
CONFIG_LIB80211=y
CONFIG_LIB80211_CRYPT_WEP=y
CONFIG_LIB80211_CRYPT_CCMP=y
CONFIG_LIB80211_CRYPT_TKIP=y
# CONFIG_LIB80211_DEBUG is not set
CONFIG_MAC80211=m
CONFIG_MAC80211_HAS_RC=y
CONFIG_MAC80211_RC_PID=y
CONFIG_MAC80211_RC_MINSTREL=y
CONFIG_MAC80211_RC_MINSTREL_HT=y
# CONFIG_MAC80211_RC_DEFAULT_PID is not set
CONFIG_MAC80211_RC_DEFAULT_MINSTREL=y
CONFIG_MAC80211_RC_DEFAULT="minstrel_ht"
CONFIG_MAC80211_MESH=y
CONFIG_MAC80211_LEDS=y
# CONFIG_MAC80211_DEBUGFS is not set
# CONFIG_MAC80211_DEBUG_MENU is not set
CONFIG_WIMAX=m
CONFIG_WIMAX_DEBUG_LEVEL=8
CONFIG_RFKILL=y
CONFIG_RFKILL_LEDS=y
CONFIG_RFKILL_INPUT=y
CONFIG_NET_9P=m
CONFIG_NET_9P_VIRTIO=m
CONFIG_NET_9P_RDMA=m
# CONFIG_NET_9P_DEBUG is not set
CONFIG_CAIF=m
# CONFIG_CAIF_DEBUG is not set
CONFIG_CAIF_NETDEV=m
CONFIG_CEPH_LIB=y
# CONFIG_CEPH_LIB_PRETTYDEBUG is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
CONFIG_DEVTMPFS=y
CONFIG_DEVTMPFS_MOUNT=y
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
# CONFIG_FIRMWARE_IN_KERNEL is not set
CONFIG_EXTRA_FIRMWARE=""
# CONFIG_SYS_HYPERVISOR is not set
CONFIG_ARCH_NO_SYSDEV_OPS=y
CONFIG_CONNECTOR=y
CONFIG_PROC_EVENTS=y
# CONFIG_MTD is not set
CONFIG_OF=y

#
# Device Tree and Open Firmware support
#
CONFIG_PROC_DEVICETREE=y
CONFIG_OF_PROMTREE=y
CONFIG_OF_ADDRESS=y
CONFIG_OF_IRQ=y
CONFIG_OF_DEVICE=y
CONFIG_OF_GPIO=y
CONFIG_OF_I2C=y
CONFIG_OF_NET=y
CONFIG_OF_SPI=y
CONFIG_OF_MDIO=y
CONFIG_OF_PCI=y
CONFIG_PARPORT=y
CONFIG_PARPORT_PC=y
CONFIG_PARPORT_SERIAL=y
CONFIG_PARPORT_PC_FIFO=y
CONFIG_PARPORT_PC_SUPERIO=y
CONFIG_PARPORT_PC_PCMCIA=y
# CONFIG_PARPORT_GSC is not set
CONFIG_PARPORT_AX88796=y
CONFIG_PARPORT_1284=y
CONFIG_PARPORT_NOT_PC=y
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_ISAPNP=y
CONFIG_PNPBIOS=y
CONFIG_PNPBIOS_PROC_FS=y
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_FD=y
CONFIG_BLK_DEV_XD=y
# CONFIG_PARIDE is not set
CONFIG_BLK_CPQ_DA=y
CONFIG_BLK_CPQ_CISS_DA=y
CONFIG_CISS_SCSI_TAPE=y
CONFIG_BLK_DEV_DAC960=y
CONFIG_BLK_DEV_UMEM=y
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=y
CONFIG_BLK_DEV_CRYPTOLOOP=y
CONFIG_BLK_DEV_DRBD=y
# CONFIG_DRBD_FAULT_INJECTION is not set
CONFIG_BLK_DEV_NBD=y
CONFIG_BLK_DEV_OSD=y
CONFIG_BLK_DEV_SX8=y
CONFIG_BLK_DEV_UB=y
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=16384
CONFIG_BLK_DEV_XIP=y
CONFIG_CDROM_PKTCDVD=y
CONFIG_CDROM_PKTCDVD_BUFFERS=8
CONFIG_CDROM_PKTCDVD_WCACHE=y
CONFIG_ATA_OVER_ETH=y
CONFIG_VIRTIO_BLK=y
CONFIG_BLK_DEV_HD=y
CONFIG_BLK_DEV_RBD=y
CONFIG_SENSORS_LIS3LV02D=y
CONFIG_MISC_DEVICES=y
CONFIG_AD525X_DPOT=m
CONFIG_AD525X_DPOT_I2C=m
CONFIG_AD525X_DPOT_SPI=m
CONFIG_IBM_ASM=y
CONFIG_PHANTOM=y
CONFIG_SGI_IOC4=y
CONFIG_TIFM_CORE=y
CONFIG_TIFM_7XX1=y
CONFIG_ICS932S401=y
CONFIG_ENCLOSURE_SERVICES=y
CONFIG_CS5535_MFGPT=m
CONFIG_CS5535_MFGPT_DEFAULT_IRQ=7
CONFIG_CS5535_CLOCK_EVENT_SRC=m
CONFIG_HP_ILO=y
CONFIG_APDS9802ALS=m
CONFIG_ISL29003=y
CONFIG_ISL29020=y
CONFIG_SENSORS_TSL2550=m
CONFIG_SENSORS_BH1780=m
CONFIG_SENSORS_BH1770=m
CONFIG_SENSORS_APDS990X=m
CONFIG_HMC6352=m
CONFIG_DS1682=m
CONFIG_TI_DAC7512=m
CONFIG_VMWARE_BALLOON=m
CONFIG_BMP085=m
CONFIG_PCH_PHUB=m
CONFIG_C2PORT=y
CONFIG_C2PORT_DURAMAR_2150=y

#
# EEPROM support
#
CONFIG_EEPROM_AT24=y
CONFIG_EEPROM_AT25=y
CONFIG_EEPROM_LEGACY=y
CONFIG_EEPROM_MAX6875=y
CONFIG_EEPROM_93CX6=y
CONFIG_CB710_CORE=y
# CONFIG_CB710_DEBUG is not set
CONFIG_CB710_DEBUG_ASSUMPTIONS=y
CONFIG_IWMC3200TOP=m
# CONFIG_IWMC3200TOP_DEBUG is not set
# CONFIG_IWMC3200TOP_DEBUGFS is not set

#
# Texas Instruments shared transport line discipline
#
CONFIG_TI_ST=m
CONFIG_SENSORS_LIS3_I2C=m
CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
CONFIG_RAID_ATTRS=y
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
CONFIG_SCSI_TGT=y
CONFIG_SCSI_NETLINK=y
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
CONFIG_CHR_DEV_ST=y
CONFIG_CHR_DEV_OSST=y
CONFIG_BLK_DEV_SR=y
CONFIG_BLK_DEV_SR_VENDOR=y
CONFIG_CHR_DEV_SG=y
CONFIG_CHR_DEV_SCH=y
CONFIG_SCSI_ENCLOSURE=y
CONFIG_SCSI_MULTI_LUN=y
CONFIG_SCSI_CONSTANTS=y
CONFIG_SCSI_LOGGING=y
CONFIG_SCSI_SCAN_ASYNC=y
CONFIG_SCSI_WAIT_SCAN=m

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
CONFIG_SCSI_FC_ATTRS=y
CONFIG_SCSI_FC_TGT_ATTRS=y
CONFIG_SCSI_ISCSI_ATTRS=y
CONFIG_SCSI_SAS_ATTRS=y
CONFIG_SCSI_SAS_LIBSAS=y
CONFIG_SCSI_SAS_ATA=y
CONFIG_SCSI_SAS_HOST_SMP=y
CONFIG_SCSI_SRP_ATTRS=m
CONFIG_SCSI_SRP_TGT_ATTRS=y
CONFIG_SCSI_LOWLEVEL=y
CONFIG_ISCSI_TCP=y
CONFIG_ISCSI_BOOT_SYSFS=y
CONFIG_SCSI_CXGB3_ISCSI=y
CONFIG_SCSI_CXGB4_ISCSI=y
CONFIG_SCSI_BNX2_ISCSI=y
CONFIG_SCSI_BNX2X_FCOE=y
CONFIG_BE2ISCSI=y
CONFIG_BLK_DEV_3W_XXXX_RAID=y
CONFIG_SCSI_HPSA=y
CONFIG_SCSI_3W_9XXX=y
CONFIG_SCSI_3W_SAS=y
CONFIG_SCSI_7000FASST=y
CONFIG_SCSI_ACARD=y
CONFIG_SCSI_AHA152X=y
CONFIG_SCSI_AHA1542=y
CONFIG_SCSI_AHA1740=y
CONFIG_SCSI_AACRAID=y
CONFIG_SCSI_AIC7XXX=y
CONFIG_AIC7XXX_CMDS_PER_DEVICE=4
CONFIG_AIC7XXX_RESET_DELAY_MS=15000
# CONFIG_AIC7XXX_DEBUG_ENABLE is not set
CONFIG_AIC7XXX_DEBUG_MASK=0
# CONFIG_AIC7XXX_REG_PRETTY_PRINT is not set
CONFIG_SCSI_AIC7XXX_OLD=y
CONFIG_SCSI_AIC79XX=y
CONFIG_AIC79XX_CMDS_PER_DEVICE=4
CONFIG_AIC79XX_RESET_DELAY_MS=15000
# CONFIG_AIC79XX_DEBUG_ENABLE is not set
CONFIG_AIC79XX_DEBUG_MASK=0
# CONFIG_AIC79XX_REG_PRETTY_PRINT is not set
CONFIG_SCSI_AIC94XX=y
# CONFIG_AIC94XX_DEBUG is not set
CONFIG_SCSI_MVSAS=y
CONFIG_SCSI_MVSAS_DEBUG=y
CONFIG_SCSI_DPT_I2O=y
CONFIG_SCSI_ADVANSYS=y
CONFIG_SCSI_IN2000=y
CONFIG_SCSI_ARCMSR=y
CONFIG_SCSI_ARCMSR_AER=y
CONFIG_MEGARAID_NEWGEN=y
CONFIG_MEGARAID_MM=y
CONFIG_MEGARAID_MAILBOX=y
CONFIG_MEGARAID_LEGACY=y
CONFIG_MEGARAID_SAS=y
CONFIG_SCSI_MPT2SAS=y
CONFIG_SCSI_MPT2SAS_MAX_SGE=128
CONFIG_SCSI_MPT2SAS_LOGGING=y
CONFIG_SCSI_HPTIOP=y
CONFIG_SCSI_BUSLOGIC=y
CONFIG_SCSI_FLASHPOINT=y
CONFIG_VMWARE_PVSCSI=y
CONFIG_LIBFC=y
CONFIG_LIBFCOE=y
CONFIG_FCOE=y
CONFIG_FCOE_FNIC=y
CONFIG_SCSI_DMX3191D=y
CONFIG_SCSI_DTC3280=y
CONFIG_SCSI_EATA=y
CONFIG_SCSI_EATA_TAGGED_QUEUE=y
CONFIG_SCSI_EATA_LINKED_COMMANDS=y
CONFIG_SCSI_EATA_MAX_TAGS=16
CONFIG_SCSI_FUTURE_DOMAIN=y
CONFIG_SCSI_FD_MCS=y
CONFIG_SCSI_GDTH=y
CONFIG_SCSI_GENERIC_NCR5380=y
CONFIG_SCSI_GENERIC_NCR5380_MMIO=y
CONFIG_SCSI_GENERIC_NCR53C400=y
CONFIG_SCSI_IBMMCA=y
CONFIG_IBMMCA_SCSI_ORDER_STANDARD=y
CONFIG_IBMMCA_SCSI_DEV_RESET=y
CONFIG_SCSI_IPS=y
CONFIG_SCSI_INITIO=y
CONFIG_SCSI_INIA100=y
CONFIG_SCSI_PPA=y
CONFIG_SCSI_IMM=y
CONFIG_SCSI_IZIP_EPP16=y
# CONFIG_SCSI_IZIP_SLOW_CTR is not set
CONFIG_SCSI_NCR53C406A=y
CONFIG_SCSI_NCR_D700=y
CONFIG_SCSI_STEX=y
CONFIG_SCSI_SYM53C8XX_2=y
CONFIG_SCSI_SYM53C8XX_DMA_ADDRESSING_MODE=1
CONFIG_SCSI_SYM53C8XX_DEFAULT_TAGS=16
CONFIG_SCSI_SYM53C8XX_MAX_TAGS=64
CONFIG_SCSI_SYM53C8XX_MMIO=y
CONFIG_SCSI_IPR=y
CONFIG_SCSI_IPR_TRACE=y
CONFIG_SCSI_IPR_DUMP=y
CONFIG_SCSI_NCR_Q720=y
CONFIG_SCSI_NCR53C8XX_DEFAULT_TAGS=8
CONFIG_SCSI_NCR53C8XX_MAX_TAGS=32
CONFIG_SCSI_NCR53C8XX_SYNC=20
CONFIG_SCSI_PAS16=y
CONFIG_SCSI_QLOGIC_FAS=y
CONFIG_SCSI_QLOGIC_1280=y
CONFIG_SCSI_QLA_FC=y
CONFIG_SCSI_QLA_ISCSI=y
CONFIG_SCSI_LPFC=y
CONFIG_SCSI_LPFC_DEBUG_FS=y
CONFIG_SCSI_SIM710=y
CONFIG_SCSI_SYM53C416=y
CONFIG_SCSI_DC395x=y
CONFIG_SCSI_DC390T=y
CONFIG_SCSI_T128=y
CONFIG_SCSI_U14_34F=y
CONFIG_SCSI_U14_34F_TAGGED_QUEUE=y
CONFIG_SCSI_U14_34F_LINKED_COMMANDS=y
CONFIG_SCSI_U14_34F_MAX_TAGS=8
CONFIG_SCSI_ULTRASTOR=y
CONFIG_SCSI_NSP32=y
# CONFIG_SCSI_DEBUG is not set
CONFIG_SCSI_PMCRAID=y
CONFIG_SCSI_PM8001=y
CONFIG_SCSI_SRP=y
CONFIG_SCSI_BFA_FC=y
CONFIG_SCSI_LOWLEVEL_PCMCIA=y
CONFIG_PCMCIA_AHA152X=m
CONFIG_PCMCIA_FDOMAIN=m
CONFIG_PCMCIA_NINJA_SCSI=m
CONFIG_PCMCIA_QLOGIC=m
CONFIG_PCMCIA_SYM53C500=m
CONFIG_SCSI_DH=y
CONFIG_SCSI_DH_RDAC=y
CONFIG_SCSI_DH_HP_SW=y
CONFIG_SCSI_DH_EMC=y
CONFIG_SCSI_DH_ALUA=y
CONFIG_SCSI_OSD_INITIATOR=y
CONFIG_SCSI_OSD_ULD=y
CONFIG_SCSI_OSD_DPRINT_SENSE=1
# CONFIG_SCSI_OSD_DEBUG is not set
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_VERBOSE_ERROR=y
CONFIG_ATA_ACPI=y
CONFIG_SATA_PMP=y

#
# Controllers with non-SFF native interface
#
CONFIG_SATA_AHCI=y
CONFIG_SATA_AHCI_PLATFORM=y
CONFIG_SATA_INIC162X=y
CONFIG_SATA_ACARD_AHCI=y
CONFIG_SATA_SIL24=y
CONFIG_ATA_SFF=y

#
# SFF controllers with custom DMA interface
#
CONFIG_PDC_ADMA=y
CONFIG_SATA_QSTOR=y
CONFIG_SATA_SX4=y
CONFIG_ATA_BMDMA=y

#
# SATA SFF controllers with BMDMA
#
CONFIG_ATA_PIIX=y
CONFIG_SATA_MV=y
CONFIG_SATA_NV=y
CONFIG_SATA_PROMISE=y
CONFIG_SATA_SIL=y
CONFIG_SATA_SIS=y
CONFIG_SATA_SVW=y
CONFIG_SATA_ULI=y
CONFIG_SATA_VIA=y
CONFIG_SATA_VITESSE=y

#
# PATA SFF controllers with BMDMA
#
CONFIG_PATA_ALI=y
CONFIG_PATA_AMD=y
CONFIG_PATA_ARASAN_CF=y
CONFIG_PATA_ARTOP=y
CONFIG_PATA_ATIIXP=y
CONFIG_PATA_ATP867X=y
CONFIG_PATA_CMD64X=y
CONFIG_PATA_CS5520=y
CONFIG_PATA_CS5530=y
CONFIG_PATA_CS5535=y
CONFIG_PATA_CS5536=y
CONFIG_PATA_CYPRESS=y
CONFIG_PATA_EFAR=y
CONFIG_PATA_HPT366=y
CONFIG_PATA_HPT37X=y
CONFIG_PATA_HPT3X2N=y
CONFIG_PATA_HPT3X3=y
CONFIG_PATA_HPT3X3_DMA=y
CONFIG_PATA_IT8213=y
CONFIG_PATA_IT821X=y
CONFIG_PATA_JMICRON=y
CONFIG_PATA_MARVELL=y
CONFIG_PATA_NETCELL=y
CONFIG_PATA_NINJA32=y
CONFIG_PATA_NS87415=y
CONFIG_PATA_OLDPIIX=y
CONFIG_PATA_OPTIDMA=y
CONFIG_PATA_PDC2027X=y
CONFIG_PATA_PDC_OLD=y
CONFIG_PATA_RADISYS=y
CONFIG_PATA_RDC=y
CONFIG_PATA_SC1200=y
CONFIG_PATA_SCH=y
CONFIG_PATA_SERVERWORKS=y
CONFIG_PATA_SIL680=y
CONFIG_PATA_SIS=y
CONFIG_PATA_TOSHIBA=y
CONFIG_PATA_TRIFLEX=y
CONFIG_PATA_VIA=y
CONFIG_PATA_WINBOND=y

#
# PIO-only SFF controllers
#
CONFIG_PATA_CMD640_PCI=y
CONFIG_PATA_ISAPNP=y
CONFIG_PATA_MPIIX=y
CONFIG_PATA_NS87410=y
CONFIG_PATA_OPTI=y
CONFIG_PATA_PCMCIA=y
CONFIG_PATA_PLATFORM=y
CONFIG_PATA_QDI=y
CONFIG_PATA_RZ1000=y
CONFIG_PATA_WINBOND_VLB=y

#
# Generic fallback / legacy drivers
#
CONFIG_PATA_ACPI=y
CONFIG_ATA_GENERIC=y
CONFIG_PATA_LEGACY=y
CONFIG_MD=y
CONFIG_BLK_DEV_MD=y
CONFIG_MD_AUTODETECT=y
CONFIG_MD_LINEAR=y
CONFIG_MD_RAID0=y
CONFIG_MD_RAID1=y
CONFIG_MD_RAID10=y
CONFIG_MD_RAID456=y
CONFIG_MULTICORE_RAID456=y
CONFIG_MD_MULTIPATH=y
CONFIG_MD_FAULTY=y
CONFIG_BLK_DEV_DM=y
# CONFIG_DM_DEBUG is not set
CONFIG_DM_CRYPT=y
CONFIG_DM_SNAPSHOT=y
CONFIG_DM_MIRROR=y
CONFIG_DM_RAID=m
# CONFIG_DM_LOG_USERSPACE is not set
CONFIG_DM_ZERO=y
CONFIG_DM_MULTIPATH=y
# CONFIG_DM_MULTIPATH_QL is not set
# CONFIG_DM_MULTIPATH_ST is not set
# CONFIG_DM_DELAY is not set
CONFIG_DM_UEVENT=y
CONFIG_DM_FLAKEY=y
CONFIG_TARGET_CORE=m
CONFIG_TCM_IBLOCK=m
CONFIG_TCM_FILEIO=m
CONFIG_TCM_PSCSI=m
CONFIG_LOOPBACK_TARGET=m
# CONFIG_LOOPBACK_TARGET_CDB_DEBUG is not set
CONFIG_FUSION=y
CONFIG_FUSION_SPI=y
CONFIG_FUSION_FC=y
CONFIG_FUSION_SAS=y
CONFIG_FUSION_MAX_SGE=128
CONFIG_FUSION_CTL=y
CONFIG_FUSION_LAN=y
CONFIG_FUSION_LOGGING=y

#
# IEEE 1394 (FireWire) support
#
CONFIG_FIREWIRE=y
CONFIG_FIREWIRE_OHCI=y
CONFIG_FIREWIRE_OHCI_DEBUG=y
CONFIG_FIREWIRE_SBP2=y
CONFIG_FIREWIRE_NET=y
CONFIG_FIREWIRE_NOSY=y
CONFIG_I2O=y
CONFIG_I2O_LCT_NOTIFY_ON_CHANGES=y
CONFIG_I2O_EXT_ADAPTEC=y
CONFIG_I2O_CONFIG=y
CONFIG_I2O_CONFIG_OLD_IOCTL=y
CONFIG_I2O_BUS=y
CONFIG_I2O_BLOCK=y
CONFIG_I2O_SCSI=y
CONFIG_I2O_PROC=y
CONFIG_MACINTOSH_DRIVERS=y
CONFIG_MAC_EMUMOUSEBTN=y
CONFIG_NETDEVICES=y
CONFIG_IFB=m
CONFIG_DUMMY=m
CONFIG_BONDING=m
CONFIG_MACVLAN=m
CONFIG_MACVTAP=m
CONFIG_EQUALIZER=m
CONFIG_TUN=m
CONFIG_VETH=m
CONFIG_NET_SB1000=m
CONFIG_ARCNET=m
CONFIG_ARCNET_1201=m
CONFIG_ARCNET_1051=m
CONFIG_ARCNET_RAW=m
CONFIG_ARCNET_CAP=m
CONFIG_ARCNET_COM90xx=m
CONFIG_ARCNET_COM90xxIO=m
CONFIG_ARCNET_RIM_I=m
CONFIG_ARCNET_COM20020=m
CONFIG_ARCNET_COM20020_ISA=m
CONFIG_ARCNET_COM20020_PCI=m
CONFIG_MII=y
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
CONFIG_MARVELL_PHY=m
CONFIG_DAVICOM_PHY=m
CONFIG_QSEMI_PHY=m
CONFIG_LXT_PHY=m
CONFIG_CICADA_PHY=m
CONFIG_VITESSE_PHY=m
CONFIG_SMSC_PHY=m
CONFIG_BROADCOM_PHY=m
CONFIG_BCM63XX_PHY=m
CONFIG_ICPLUS_PHY=m
CONFIG_REALTEK_PHY=m
CONFIG_NATIONAL_PHY=m
CONFIG_STE10XP=m
CONFIG_LSI_ET1011C_PHY=m
CONFIG_MICREL_PHY=m
CONFIG_FIXED_PHY=y
CONFIG_MDIO_BITBANG=m
CONFIG_MDIO_GPIO=m
CONFIG_NET_ETHERNET=y
CONFIG_HAPPYMEAL=m
CONFIG_SUNGEM=m
CONFIG_CASSINI=m
CONFIG_NET_VENDOR_3COM=y
CONFIG_EL1=m
CONFIG_EL2=m
CONFIG_ELPLUS=m
CONFIG_EL16=m
CONFIG_EL3=m
CONFIG_3C515=m
CONFIG_ELMC=m
CONFIG_ELMC_II=m
CONFIG_VORTEX=y
CONFIG_TYPHOON=m
CONFIG_LANCE=m
CONFIG_NET_VENDOR_SMC=y
CONFIG_WD80x3=m
CONFIG_ULTRAMCA=m
CONFIG_ULTRA=m
CONFIG_ULTRA32=m
CONFIG_SMC9194=m
CONFIG_ENC28J60=m
# CONFIG_ENC28J60_WRITEVERIFY is not set
CONFIG_ETHOC=m
CONFIG_NET_VENDOR_RACAL=y
CONFIG_NI52=m
CONFIG_NI65=m
CONFIG_DNET=m
CONFIG_NET_TULIP=y
CONFIG_DE2104X=m
CONFIG_DE2104X_DSL=0
CONFIG_TULIP=m
CONFIG_TULIP_MWI=y
CONFIG_TULIP_MMIO=y
CONFIG_TULIP_NAPI=y
CONFIG_TULIP_NAPI_HW_MITIGATION=y
CONFIG_DE4X5=m
CONFIG_WINBOND_840=m
CONFIG_DM9102=m
CONFIG_ULI526X=m
CONFIG_PCMCIA_XIRCOM=m
CONFIG_AT1700=m
CONFIG_DEPCA=m
CONFIG_HP100=m
CONFIG_NET_ISA=y
CONFIG_E2100=m
CONFIG_EWRK3=m
CONFIG_EEXPRESS=m
CONFIG_EEXPRESS_PRO=m
CONFIG_HPLAN_PLUS=m
CONFIG_HPLAN=m
CONFIG_LP486E=m
CONFIG_ETH16I=m
CONFIG_NE2000=m
CONFIG_ZNET=m
CONFIG_SEEQ8005=m
CONFIG_NE2_MCA=m
CONFIG_IBMLANA=m
# CONFIG_IBM_NEW_EMAC_ZMII is not set
# CONFIG_IBM_NEW_EMAC_RGMII is not set
# CONFIG_IBM_NEW_EMAC_TAH is not set
# CONFIG_IBM_NEW_EMAC_EMAC4 is not set
# CONFIG_IBM_NEW_EMAC_NO_FLOW_CTRL is not set
# CONFIG_IBM_NEW_EMAC_MAL_CLR_ICINTSTAT is not set
# CONFIG_IBM_NEW_EMAC_MAL_COMMON_ERR is not set
CONFIG_NET_PCI=y
CONFIG_PCNET32=m
CONFIG_AMD8111_ETH=m
CONFIG_ADAPTEC_STARFIRE=m
CONFIG_AC3200=m
CONFIG_KSZ884X_PCI=m
CONFIG_APRICOT=m
CONFIG_B44=m
CONFIG_B44_PCI_AUTOSELECT=y
CONFIG_B44_PCICORE_AUTOSELECT=y
CONFIG_B44_PCI=y
CONFIG_FORCEDETH=y
CONFIG_CS89x0=m
CONFIG_E100=y
CONFIG_LNE390=m
CONFIG_FEALNX=m
CONFIG_NATSEMI=m
CONFIG_NE2K_PCI=m
CONFIG_NE3210=m
CONFIG_ES3210=m
CONFIG_8139CP=m
CONFIG_8139TOO=y
CONFIG_8139TOO_PIO=y
CONFIG_8139TOO_TUNE_TWISTER=y
CONFIG_8139TOO_8129=y
# CONFIG_8139_OLD_RX_RESET is not set
CONFIG_R6040=m
CONFIG_SIS900=m
CONFIG_EPIC100=m
CONFIG_SMSC9420=m
CONFIG_SUNDANCE=m
# CONFIG_SUNDANCE_MMIO is not set
CONFIG_TLAN=m
CONFIG_KS8842=m
CONFIG_KS8851=m
CONFIG_KS8851_MLL=m
CONFIG_VIA_RHINE=y
CONFIG_VIA_RHINE_MMIO=y
CONFIG_SC92031=m
CONFIG_NET_POCKET=y
CONFIG_ATP=y
CONFIG_DE600=y
CONFIG_DE620=y
CONFIG_ATL2=y
CONFIG_NETDEV_1000=y
CONFIG_ACENIC=m
# CONFIG_ACENIC_OMIT_TIGON_I is not set
CONFIG_DL2K=m
CONFIG_E1000=m
CONFIG_E1000E=y
CONFIG_IP1000=m
CONFIG_IGB=m
CONFIG_IGB_DCA=y
CONFIG_IGBVF=m
CONFIG_NS83820=m
CONFIG_HAMACHI=m
CONFIG_YELLOWFIN=m
CONFIG_R8169=y
CONFIG_SIS190=m
CONFIG_SKGE=y
# CONFIG_SKGE_DEBUG is not set
CONFIG_SKY2=m
# CONFIG_SKY2_DEBUG is not set
CONFIG_VIA_VELOCITY=m
CONFIG_TIGON3=y
CONFIG_BNX2=y
CONFIG_CNIC=y
CONFIG_QLA3XXX=m
CONFIG_ATL1=m
CONFIG_ATL1E=m
CONFIG_ATL1C=m
CONFIG_JME=m
CONFIG_STMMAC_ETH=m
CONFIG_STMMAC_DA=y
CONFIG_STMMAC_DUAL_MAC=y
CONFIG_PCH_GBE=m
CONFIG_NETDEV_10000=y
CONFIG_MDIO=y
CONFIG_CHELSIO_T1=m
CONFIG_CHELSIO_T1_1G=y
CONFIG_CHELSIO_T3=y
CONFIG_CHELSIO_T4=y
CONFIG_CHELSIO_T4VF=m
CONFIG_ENIC=m
CONFIG_IXGBE=m
CONFIG_IXGBE_DCA=y
CONFIG_IXGBE_DCB=y
CONFIG_IXGBEVF=m
CONFIG_IXGB=m
CONFIG_S2IO=m
CONFIG_VXGE=m
# CONFIG_VXGE_DEBUG_TRACE_ALL is not set
CONFIG_MYRI10GE=m
CONFIG_MYRI10GE_DCA=y
CONFIG_NETXEN_NIC=m
CONFIG_NIU=m
CONFIG_MLX4_EN=m
CONFIG_MLX4_CORE=m
CONFIG_MLX4_DEBUG=y
CONFIG_TEHUTI=m
CONFIG_BNX2X=m
CONFIG_QLCNIC=m
CONFIG_QLGE=m
CONFIG_BNA=m
CONFIG_SFC=m
CONFIG_BE2NET=m
CONFIG_TR=y
CONFIG_IBMTR=m
CONFIG_IBMOL=m
CONFIG_IBMLS=m
CONFIG_3C359=m
CONFIG_TMS380TR=m
CONFIG_TMSPCI=m
CONFIG_SKISA=m
CONFIG_PROTEON=m
CONFIG_ABYSS=m
CONFIG_MADGEMC=m
CONFIG_SMCTR=m
CONFIG_WLAN=y
CONFIG_PCMCIA_RAYCS=m
CONFIG_LIBERTAS_THINFIRM=m
# CONFIG_LIBERTAS_THINFIRM_DEBUG is not set
CONFIG_LIBERTAS_THINFIRM_USB=m
CONFIG_AIRO=m
CONFIG_ATMEL=m
CONFIG_PCI_ATMEL=m
CONFIG_PCMCIA_ATMEL=m
CONFIG_AT76C50X_USB=m
CONFIG_AIRO_CS=m
CONFIG_PCMCIA_WL3501=m
CONFIG_PRISM54=m
CONFIG_USB_ZD1201=m
CONFIG_USB_NET_RNDIS_WLAN=m
CONFIG_RTL8180=m
CONFIG_RTL8187=m
CONFIG_RTL8187_LEDS=y
CONFIG_ADM8211=m
CONFIG_MAC80211_HWSIM=m
CONFIG_MWL8K=m
CONFIG_ATH_COMMON=m
# CONFIG_ATH_DEBUG is not set
CONFIG_ATH5K=m
# CONFIG_ATH5K_DEBUG is not set
# CONFIG_ATH5K_TRACER is not set
CONFIG_ATH5K_PCI=y
CONFIG_ATH9K_HW=m
CONFIG_ATH9K_COMMON=m
CONFIG_ATH9K=m
# CONFIG_ATH9K_DEBUGFS is not set
CONFIG_ATH9K_RATE_CONTROL=y
CONFIG_ATH9K_HTC=m
# CONFIG_ATH9K_HTC_DEBUGFS is not set
CONFIG_AR9170_USB=m
CONFIG_AR9170_LEDS=y
# CONFIG_CARL9170 is not set
CONFIG_B43=m
CONFIG_B43_PCI_AUTOSELECT=y
CONFIG_B43_PCICORE_AUTOSELECT=y
CONFIG_B43_PCMCIA=y
CONFIG_B43_SDIO=y
CONFIG_B43_PIO=y
CONFIG_B43_PHY_N=y
CONFIG_B43_PHY_LP=y
CONFIG_B43_LEDS=y
CONFIG_B43_HWRNG=y
# CONFIG_B43_DEBUG is not set
CONFIG_B43LEGACY=m
CONFIG_B43LEGACY_PCI_AUTOSELECT=y
CONFIG_B43LEGACY_PCICORE_AUTOSELECT=y
CONFIG_B43LEGACY_LEDS=y
CONFIG_B43LEGACY_HWRNG=y
# CONFIG_B43LEGACY_DEBUG is not set
CONFIG_B43LEGACY_DMA=y
CONFIG_B43LEGACY_PIO=y
CONFIG_B43LEGACY_DMA_AND_PIO_MODE=y
# CONFIG_B43LEGACY_DMA_MODE is not set
# CONFIG_B43LEGACY_PIO_MODE is not set
CONFIG_HOSTAP=y
CONFIG_HOSTAP_FIRMWARE=y
CONFIG_HOSTAP_FIRMWARE_NVRAM=y
CONFIG_HOSTAP_PLX=m
CONFIG_HOSTAP_PCI=m
CONFIG_HOSTAP_CS=m
CONFIG_IPW2100=m
CONFIG_IPW2100_MONITOR=y
# CONFIG_IPW2100_DEBUG is not set
CONFIG_IPW2200=m
CONFIG_IPW2200_MONITOR=y
CONFIG_IPW2200_RADIOTAP=y
CONFIG_IPW2200_PROMISCUOUS=y
CONFIG_IPW2200_QOS=y
# CONFIG_IPW2200_DEBUG is not set
CONFIG_LIBIPW=m
# CONFIG_LIBIPW_DEBUG is not set
CONFIG_IWLAGN=m

#
# Debugging Options
#
# CONFIG_IWLWIFI_DEBUG is not set
CONFIG_IWLWIFI_DEVICE_TRACING=y
CONFIG_IWL_P2P=y
CONFIG_IWLWIFI_LEGACY=m

#
# Debugging Options
#
# CONFIG_IWLWIFI_LEGACY_DEBUG is not set
# CONFIG_IWLWIFI_LEGACY_DEVICE_TRACING is not set
CONFIG_IWL4965=m
CONFIG_IWL3945=m
CONFIG_IWM=m
# CONFIG_IWM_DEBUG is not set
CONFIG_IWM_TRACING=y
CONFIG_LIBERTAS=m
CONFIG_LIBERTAS_USB=m
CONFIG_LIBERTAS_CS=m
CONFIG_LIBERTAS_SDIO=m
CONFIG_LIBERTAS_SPI=m
# CONFIG_LIBERTAS_DEBUG is not set
CONFIG_LIBERTAS_MESH=y
CONFIG_HERMES=m
CONFIG_HERMES_PRISM=y
CONFIG_HERMES_CACHE_FW_ON_INIT=y
CONFIG_PLX_HERMES=m
CONFIG_TMD_HERMES=m
CONFIG_NORTEL_HERMES=m
CONFIG_PCI_HERMES=m
CONFIG_PCMCIA_HERMES=m
CONFIG_PCMCIA_SPECTRUM=m
CONFIG_ORINOCO_USB=m
CONFIG_P54_COMMON=m
CONFIG_P54_USB=m
CONFIG_P54_PCI=m
CONFIG_P54_SPI=m
CONFIG_P54_SPI_DEFAULT_EEPROM=y
CONFIG_P54_LEDS=y
CONFIG_RT2X00=m
CONFIG_RT2400PCI=m
CONFIG_RT2500PCI=m
CONFIG_RT61PCI=m
CONFIG_RT2800PCI=m
CONFIG_RT2800PCI_RT33XX=y
CONFIG_RT2800PCI_RT35XX=y
CONFIG_RT2800PCI_RT53XX=y
CONFIG_RT2500USB=m
CONFIG_RT73USB=m
CONFIG_RT2800USB=m
CONFIG_RT2800USB_RT33XX=y
CONFIG_RT2800USB_RT35XX=y
CONFIG_RT2800USB_UNKNOWN=y
CONFIG_RT2800_LIB=m
CONFIG_RT2X00_LIB_PCI=m
CONFIG_RT2X00_LIB_USB=m
CONFIG_RT2X00_LIB=m
CONFIG_RT2X00_LIB_HT=y
CONFIG_RT2X00_LIB_FIRMWARE=y
CONFIG_RT2X00_LIB_CRYPTO=y
CONFIG_RT2X00_LIB_LEDS=y
# CONFIG_RT2X00_DEBUG is not set
CONFIG_RTL8192CE=m
CONFIG_RTL8192CU=m
CONFIG_RTLWIFI=m
CONFIG_RTL8192C_COMMON=m
CONFIG_WL1251=m
CONFIG_WL1251_SPI=m
CONFIG_WL1251_SDIO=m
CONFIG_WL12XX_MENU=m
CONFIG_WL12XX=m
CONFIG_WL12XX_HT=y
CONFIG_WL12XX_SPI=m
CONFIG_WL12XX_SDIO=m
CONFIG_WL12XX_SDIO_TEST=m
CONFIG_WL12XX_PLATFORM_DATA=y
CONFIG_ZD1211RW=m
# CONFIG_ZD1211RW_DEBUG is not set

#
# WiMAX Wireless Broadband devices
#
CONFIG_WIMAX_I2400M=m
CONFIG_WIMAX_I2400M_USB=m
CONFIG_WIMAX_I2400M_SDIO=m
CONFIG_WIMAX_IWMC3200_SDIO=y
CONFIG_WIMAX_I2400M_DEBUG_LEVEL=8

#
# USB Network Adapters
#
CONFIG_USB_CATC=m
CONFIG_USB_KAWETH=m
CONFIG_USB_PEGASUS=m
CONFIG_USB_RTL8150=m
CONFIG_USB_USBNET=m
CONFIG_USB_NET_AX8817X=m
CONFIG_USB_NET_CDCETHER=m
CONFIG_USB_NET_CDC_EEM=m
CONFIG_USB_NET_CDC_NCM=m
CONFIG_USB_NET_DM9601=m
CONFIG_USB_NET_SMSC75XX=m
CONFIG_USB_NET_SMSC95XX=m
CONFIG_USB_NET_GL620A=m
CONFIG_USB_NET_NET1080=m
CONFIG_USB_NET_PLUSB=m
CONFIG_USB_NET_MCS7830=m
CONFIG_USB_NET_RNDIS_HOST=m
CONFIG_USB_NET_CDC_SUBSET=m
CONFIG_USB_ALI_M5632=y
CONFIG_USB_AN2720=y
CONFIG_USB_BELKIN=y
CONFIG_USB_ARMLINUX=y
CONFIG_USB_EPSON2888=y
CONFIG_USB_KC2190=y
CONFIG_USB_NET_ZAURUS=m
CONFIG_USB_NET_CX82310_ETH=m
CONFIG_USB_HSO=m
CONFIG_USB_NET_INT51X1=m
CONFIG_USB_CDC_PHONET=m
CONFIG_USB_IPHETH=m
CONFIG_USB_SIERRA_NET=m
CONFIG_USB_VL600=m
CONFIG_NET_PCMCIA=y
CONFIG_PCMCIA_3C589=m
CONFIG_PCMCIA_3C574=m
CONFIG_PCMCIA_FMVJ18X=m
CONFIG_PCMCIA_PCNET=m
CONFIG_PCMCIA_NMCLAN=m
CONFIG_PCMCIA_SMC91C92=m
CONFIG_PCMCIA_XIRC2PS=m
CONFIG_PCMCIA_AXNET=m
CONFIG_ARCNET_COM20020_CS=m
CONFIG_PCMCIA_IBMTR=m
CONFIG_WAN=y
CONFIG_HOSTESS_SV11=m
CONFIG_COSA=m
CONFIG_LANMEDIA=m
CONFIG_SEALEVEL_4021=m
CONFIG_HDLC=m
CONFIG_HDLC_RAW=m
CONFIG_HDLC_RAW_ETH=m
CONFIG_HDLC_CISCO=m
CONFIG_HDLC_FR=m
CONFIG_HDLC_PPP=m
CONFIG_HDLC_X25=m
CONFIG_PCI200SYN=m
CONFIG_WANXL=m
CONFIG_PC300TOO=m
CONFIG_N2=m
CONFIG_C101=m
CONFIG_FARSYNC=m
CONFIG_DSCC4=m
CONFIG_DSCC4_PCISYNC=y
CONFIG_DSCC4_PCI_RST=y
CONFIG_DLCI=m
CONFIG_DLCI_MAX=8
CONFIG_SDLA=m
CONFIG_WAN_ROUTER_DRIVERS=m
CONFIG_CYCLADES_SYNC=m
CONFIG_CYCLOMX_X25=y
CONFIG_LAPBETHER=m
CONFIG_X25_ASY=m
CONFIG_SBNI=m
CONFIG_SBNI_MULTILINE=y
CONFIG_ATM_DRIVERS=y
# CONFIG_ATM_DUMMY is not set
CONFIG_ATM_TCP=m
CONFIG_ATM_LANAI=m
CONFIG_ATM_ENI=m
# CONFIG_ATM_ENI_DEBUG is not set
# CONFIG_ATM_ENI_TUNE_BURST is not set
CONFIG_ATM_FIRESTREAM=m
CONFIG_ATM_ZATM=m
# CONFIG_ATM_ZATM_DEBUG is not set
CONFIG_ATM_NICSTAR=m
# CONFIG_ATM_NICSTAR_USE_SUNI is not set
CONFIG_ATM_NICSTAR_USE_IDT77105=y
CONFIG_ATM_IDT77252=m
# CONFIG_ATM_IDT77252_DEBUG is not set
# CONFIG_ATM_IDT77252_RCV_ALL is not set
CONFIG_ATM_IDT77252_USE_SUNI=y
CONFIG_ATM_AMBASSADOR=m
# CONFIG_ATM_AMBASSADOR_DEBUG is not set
CONFIG_ATM_HORIZON=m
# CONFIG_ATM_HORIZON_DEBUG is not set
CONFIG_ATM_IA=m
# CONFIG_ATM_IA_DEBUG is not set
CONFIG_ATM_FORE200E=m
CONFIG_ATM_FORE200E_USE_TASKLET=y
CONFIG_ATM_FORE200E_TX_RETRY=16
CONFIG_ATM_FORE200E_DEBUG=0
CONFIG_ATM_HE=m
# CONFIG_ATM_HE_USE_SUNI is not set
CONFIG_ATM_SOLOS=m
CONFIG_IEEE802154_DRIVERS=m
CONFIG_IEEE802154_FAKEHARD=m

#
# CAIF transport drivers
#
CONFIG_CAIF_TTY=m
CONFIG_CAIF_SPI_SLAVE=m
CONFIG_CAIF_SPI_SYNC=y
CONFIG_RIONET=m
CONFIG_RIONET_TX_SIZE=128
CONFIG_RIONET_RX_SIZE=128
CONFIG_FDDI=y
CONFIG_DEFXX=m
# CONFIG_DEFXX_MMIO is not set
CONFIG_SKFP=m
CONFIG_HIPPI=y
CONFIG_ROADRUNNER=m
# CONFIG_ROADRUNNER_LARGE_RINGS is not set
CONFIG_PLIP=y
CONFIG_PPP=y
CONFIG_PPP_MULTILINK=y
CONFIG_PPP_FILTER=y
CONFIG_PPP_ASYNC=y
CONFIG_PPP_SYNC_TTY=y
CONFIG_PPP_DEFLATE=y
CONFIG_PPP_BSDCOMP=y
CONFIG_PPP_MPPE=y
CONFIG_PPPOE=y
CONFIG_PPTP=m
CONFIG_PPPOATM=y
CONFIG_PPPOL2TP=m
CONFIG_SLIP=y
CONFIG_SLIP_COMPRESSED=y
CONFIG_SLHC=y
CONFIG_SLIP_SMART=y
CONFIG_SLIP_MODE_SLIP6=y
CONFIG_NET_FC=y
CONFIG_NETCONSOLE=y
CONFIG_NETCONSOLE_DYNAMIC=y
CONFIG_NETPOLL=y
CONFIG_NETPOLL_TRAP=y
CONFIG_NET_POLL_CONTROLLER=y
CONFIG_VIRTIO_NET=m
CONFIG_VMXNET3=m
CONFIG_ISDN=y
CONFIG_ISDN_I4L=m
CONFIG_ISDN_PPP=y
CONFIG_ISDN_PPP_VJ=y
CONFIG_ISDN_MPP=y
CONFIG_IPPP_FILTER=y
CONFIG_ISDN_PPP_BSDCOMP=m
CONFIG_ISDN_AUDIO=y
CONFIG_ISDN_TTY_FAX=y
CONFIG_ISDN_X25=y

#
# ISDN feature submodules
#
CONFIG_ISDN_DIVERSION=m

#
# ISDN4Linux hardware drivers
#

#
# Passive cards
#
CONFIG_ISDN_DRV_HISAX=m

#
# D-channel protocol features
#
CONFIG_HISAX_EURO=y
CONFIG_DE_AOC=y
CONFIG_HISAX_NO_SENDCOMPLETE=y
CONFIG_HISAX_NO_LLC=y
CONFIG_HISAX_NO_KEYPAD=y
CONFIG_HISAX_1TR6=y
CONFIG_HISAX_NI1=y
CONFIG_HISAX_MAX_CARDS=8

#
# HiSax supported cards
#
CONFIG_HISAX_16_0=y
CONFIG_HISAX_16_3=y
CONFIG_HISAX_TELESPCI=y
CONFIG_HISAX_S0BOX=y
CONFIG_HISAX_AVM_A1=y
CONFIG_HISAX_FRITZPCI=y
CONFIG_HISAX_AVM_A1_PCMCIA=y
CONFIG_HISAX_ELSA=y
CONFIG_HISAX_IX1MICROR2=y
CONFIG_HISAX_DIEHLDIVA=y
CONFIG_HISAX_ASUSCOM=y
CONFIG_HISAX_TELEINT=y
CONFIG_HISAX_HFCS=y
CONFIG_HISAX_SEDLBAUER=y
CONFIG_HISAX_SPORTSTER=y
CONFIG_HISAX_MIC=y
CONFIG_HISAX_NETJET=y
CONFIG_HISAX_NETJET_U=y
CONFIG_HISAX_NICCY=y
CONFIG_HISAX_ISURF=y
CONFIG_HISAX_HSTSAPHIR=y
CONFIG_HISAX_BKM_A4T=y
CONFIG_HISAX_SCT_QUADRO=y
CONFIG_HISAX_GAZEL=y
CONFIG_HISAX_HFC_PCI=y
CONFIG_HISAX_W6692=y
CONFIG_HISAX_HFC_SX=y
CONFIG_HISAX_ENTERNOW_PCI=y
# CONFIG_HISAX_DEBUG is not set

#
# HiSax PCMCIA card service modules
#
CONFIG_HISAX_SEDLBAUER_CS=m
CONFIG_HISAX_ELSA_CS=m
CONFIG_HISAX_AVM_A1_CS=m
CONFIG_HISAX_TELES_CS=m

#
# HiSax sub driver modules
#
CONFIG_HISAX_ST5481=m
CONFIG_HISAX_HFCUSB=m
CONFIG_HISAX_HFC4S8S=m
CONFIG_HISAX_FRITZ_PCIPNP=m

#
# Active cards
#
# CONFIG_ISDN_DRV_ICN is not set
CONFIG_ISDN_DRV_PCBIT=m
CONFIG_ISDN_DRV_SC=m
CONFIG_ISDN_DRV_ACT2000=m
CONFIG_ISDN_CAPI=m
CONFIG_ISDN_DRV_AVMB1_VERBOSE_REASON=y
CONFIG_CAPI_TRACE=y
CONFIG_ISDN_CAPI_MIDDLEWARE=y
CONFIG_ISDN_CAPI_CAPI20=m
CONFIG_ISDN_CAPI_CAPIFS_BOOL=y
CONFIG_ISDN_CAPI_CAPIFS=m
CONFIG_ISDN_CAPI_CAPIDRV=m

#
# CAPI hardware drivers
#
CONFIG_CAPI_AVM=y
CONFIG_ISDN_DRV_AVMB1_B1ISA=m
CONFIG_ISDN_DRV_AVMB1_B1PCI=m
CONFIG_ISDN_DRV_AVMB1_B1PCIV4=y
CONFIG_ISDN_DRV_AVMB1_T1ISA=m
CONFIG_ISDN_DRV_AVMB1_B1PCMCIA=m
CONFIG_ISDN_DRV_AVMB1_AVM_CS=m
CONFIG_ISDN_DRV_AVMB1_T1PCI=m
CONFIG_ISDN_DRV_AVMB1_C4=m
CONFIG_CAPI_EICON=y
CONFIG_ISDN_DIVAS=m
CONFIG_ISDN_DIVAS_BRIPCI=y
CONFIG_ISDN_DIVAS_PRIPCI=y
CONFIG_ISDN_DIVAS_DIVACAPI=m
CONFIG_ISDN_DIVAS_USERIDI=m
CONFIG_ISDN_DIVAS_MAINT=m
CONFIG_ISDN_DRV_GIGASET=m
CONFIG_GIGASET_CAPI=y
# CONFIG_GIGASET_I4L is not set
# CONFIG_GIGASET_DUMMYLL is not set
CONFIG_GIGASET_BASE=m
CONFIG_GIGASET_M105=m
CONFIG_GIGASET_M101=m
# CONFIG_GIGASET_DEBUG is not set
CONFIG_HYSDN=m
CONFIG_HYSDN_CAPI=y
CONFIG_MISDN=m
CONFIG_MISDN_DSP=m
CONFIG_MISDN_L1OIP=m

#
# mISDN hardware drivers
#
CONFIG_MISDN_HFCPCI=m
CONFIG_MISDN_HFCMULTI=m
CONFIG_MISDN_HFCUSB=m
CONFIG_MISDN_AVMFRITZ=m
CONFIG_MISDN_SPEEDFAX=m
CONFIG_MISDN_INFINEON=m
CONFIG_MISDN_W6692=m
CONFIG_MISDN_NETJET=m
CONFIG_MISDN_IPAC=m
CONFIG_MISDN_ISAR=m
CONFIG_ISDN_HDLC=m
CONFIG_PHONE=m
CONFIG_PHONE_IXJ=m
CONFIG_PHONE_IXJ_PCMCIA=m

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=y
CONFIG_INPUT_POLLDEV=y
CONFIG_INPUT_SPARSEKMAP=y

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_JOYDEV=y
CONFIG_INPUT_EVDEV=y
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ADP5520=y
CONFIG_KEYBOARD_ADP5588=y
CONFIG_KEYBOARD_ATKBD=y
CONFIG_KEYBOARD_QT1070=y
CONFIG_KEYBOARD_QT2160=y
CONFIG_KEYBOARD_LKKBD=y
CONFIG_KEYBOARD_GPIO=y
CONFIG_KEYBOARD_GPIO_POLLED=y
CONFIG_KEYBOARD_TCA6416=y
CONFIG_KEYBOARD_MATRIX=y
CONFIG_KEYBOARD_LM8323=y
CONFIG_KEYBOARD_MAX7359=y
CONFIG_KEYBOARD_MCS=y
CONFIG_KEYBOARD_NEWTON=y
CONFIG_KEYBOARD_OPENCORES=y
CONFIG_KEYBOARD_STOWAWAY=y
CONFIG_KEYBOARD_SUNKBD=y
CONFIG_KEYBOARD_STMPE=y
CONFIG_KEYBOARD_TC3589X=y
CONFIG_KEYBOARD_TWL4030=y
CONFIG_KEYBOARD_XTKBD=y
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
CONFIG_MOUSE_PS2_ELANTECH=y
CONFIG_MOUSE_PS2_SENTELIC=y
CONFIG_MOUSE_PS2_TOUCHKIT=y
CONFIG_MOUSE_PS2_OLPC=y
CONFIG_MOUSE_SERIAL=y
CONFIG_MOUSE_APPLETOUCH=y
CONFIG_MOUSE_BCM5974=y
CONFIG_MOUSE_INPORT=y
CONFIG_MOUSE_ATIXL=y
CONFIG_MOUSE_LOGIBM=y
CONFIG_MOUSE_PC110PAD=y
CONFIG_MOUSE_VSXXXAA=y
CONFIG_MOUSE_GPIO=y
CONFIG_MOUSE_SYNAPTICS_I2C=y
CONFIG_INPUT_JOYSTICK=y
CONFIG_JOYSTICK_ANALOG=y
CONFIG_JOYSTICK_A3D=m
CONFIG_JOYSTICK_ADI=m
CONFIG_JOYSTICK_COBRA=m
CONFIG_JOYSTICK_GF2K=m
CONFIG_JOYSTICK_GRIP=m
CONFIG_JOYSTICK_GRIP_MP=m
CONFIG_JOYSTICK_GUILLEMOT=m
CONFIG_JOYSTICK_INTERACT=m
CONFIG_JOYSTICK_SIDEWINDER=m
CONFIG_JOYSTICK_TMDC=m
CONFIG_JOYSTICK_IFORCE=m
CONFIG_JOYSTICK_IFORCE_USB=y
CONFIG_JOYSTICK_IFORCE_232=y
CONFIG_JOYSTICK_WARRIOR=m
CONFIG_JOYSTICK_MAGELLAN=m
CONFIG_JOYSTICK_SPACEORB=m
CONFIG_JOYSTICK_SPACEBALL=m
CONFIG_JOYSTICK_STINGER=m
CONFIG_JOYSTICK_TWIDJOY=m
CONFIG_JOYSTICK_ZHENHUA=m
CONFIG_JOYSTICK_DB9=m
CONFIG_JOYSTICK_GAMECON=m
CONFIG_JOYSTICK_TURBOGRAFX=m
CONFIG_JOYSTICK_AS5011=m
CONFIG_JOYSTICK_JOYDUMP=m
CONFIG_JOYSTICK_XPAD=m
CONFIG_JOYSTICK_XPAD_FF=y
CONFIG_JOYSTICK_XPAD_LEDS=y
CONFIG_JOYSTICK_WALKERA0701=m
CONFIG_INPUT_TABLET=y
CONFIG_TABLET_USB_ACECAD=y
CONFIG_TABLET_USB_AIPTEK=y
CONFIG_TABLET_USB_GTCO=y
CONFIG_TABLET_USB_HANWANG=y
CONFIG_TABLET_USB_KBTAB=y
CONFIG_TABLET_USB_WACOM=y
CONFIG_INPUT_TOUCHSCREEN=y
CONFIG_TOUCHSCREEN_88PM860X=y
CONFIG_TOUCHSCREEN_ADS7846=y
CONFIG_TOUCHSCREEN_AD7877=y
CONFIG_TOUCHSCREEN_AD7879=y
CONFIG_TOUCHSCREEN_AD7879_I2C=y
CONFIG_TOUCHSCREEN_AD7879_SPI=y
CONFIG_TOUCHSCREEN_ATMEL_MXT=y
CONFIG_TOUCHSCREEN_BU21013=y
CONFIG_TOUCHSCREEN_CY8CTMG110=y
CONFIG_TOUCHSCREEN_DA9034=y
CONFIG_TOUCHSCREEN_DYNAPRO=y
CONFIG_TOUCHSCREEN_HAMPSHIRE=y
CONFIG_TOUCHSCREEN_EETI=y
CONFIG_TOUCHSCREEN_FUJITSU=y
CONFIG_TOUCHSCREEN_GUNZE=y
CONFIG_TOUCHSCREEN_ELO=y
CONFIG_TOUCHSCREEN_WACOM_W8001=y
CONFIG_TOUCHSCREEN_MCS5000=y
CONFIG_TOUCHSCREEN_MTOUCH=y
CONFIG_TOUCHSCREEN_INEXIO=y
CONFIG_TOUCHSCREEN_MK712=y
CONFIG_TOUCHSCREEN_HTCPEN=y
CONFIG_TOUCHSCREEN_PENMOUNT=y
CONFIG_TOUCHSCREEN_TOUCHRIGHT=y
CONFIG_TOUCHSCREEN_TOUCHWIN=y
CONFIG_TOUCHSCREEN_UCB1400=m
CONFIG_TOUCHSCREEN_WM831X=y
CONFIG_TOUCHSCREEN_WM97XX=m
CONFIG_TOUCHSCREEN_WM9705=y
CONFIG_TOUCHSCREEN_WM9712=y
CONFIG_TOUCHSCREEN_WM9713=y
CONFIG_TOUCHSCREEN_USB_COMPOSITE=y
CONFIG_TOUCHSCREEN_MC13783=m
CONFIG_TOUCHSCREEN_USB_EGALAX=y
CONFIG_TOUCHSCREEN_USB_PANJIT=y
CONFIG_TOUCHSCREEN_USB_3M=y
CONFIG_TOUCHSCREEN_USB_ITM=y
CONFIG_TOUCHSCREEN_USB_ETURBO=y
CONFIG_TOUCHSCREEN_USB_GUNZE=y
CONFIG_TOUCHSCREEN_USB_DMC_TSC10=y
CONFIG_TOUCHSCREEN_USB_IRTOUCH=y
CONFIG_TOUCHSCREEN_USB_IDEALTEK=y
CONFIG_TOUCHSCREEN_USB_GENERAL_TOUCH=y
CONFIG_TOUCHSCREEN_USB_GOTOP=y
CONFIG_TOUCHSCREEN_USB_JASTEC=y
CONFIG_TOUCHSCREEN_USB_E2I=y
CONFIG_TOUCHSCREEN_USB_ZYTRONIC=y
CONFIG_TOUCHSCREEN_USB_ETT_TC45USB=y
CONFIG_TOUCHSCREEN_USB_NEXIO=y
CONFIG_TOUCHSCREEN_TOUCHIT213=y
CONFIG_TOUCHSCREEN_TSC2005=y
CONFIG_TOUCHSCREEN_TSC2007=y
CONFIG_TOUCHSCREEN_PCAP=y
CONFIG_TOUCHSCREEN_ST1232=y
CONFIG_TOUCHSCREEN_STMPE=y
CONFIG_TOUCHSCREEN_TPS6507X=y
CONFIG_INPUT_MISC=y
CONFIG_INPUT_88PM860X_ONKEY=y
CONFIG_INPUT_AB8500_PONKEY=y
CONFIG_INPUT_AD714X=y
CONFIG_INPUT_AD714X_I2C=y
CONFIG_INPUT_AD714X_SPI=y
CONFIG_INPUT_PCSPKR=y
CONFIG_INPUT_MAX8925_ONKEY=y
CONFIG_INPUT_APANEL=y
CONFIG_INPUT_WISTRON_BTNS=y
CONFIG_INPUT_ATLAS_BTNS=y
CONFIG_INPUT_ATI_REMOTE=y
CONFIG_INPUT_ATI_REMOTE2=y
CONFIG_INPUT_KEYSPAN_REMOTE=y
CONFIG_INPUT_POWERMATE=y
CONFIG_INPUT_YEALINK=y
CONFIG_INPUT_CM109=y
CONFIG_INPUT_TWL4030_PWRBUTTON=y
CONFIG_INPUT_TWL4030_VIBRA=y
CONFIG_INPUT_UINPUT=y
CONFIG_INPUT_PCF50633_PMU=m
CONFIG_INPUT_PCF8574=y
CONFIG_INPUT_GPIO_ROTARY_ENCODER=y
CONFIG_INPUT_WM831X_ON=y
CONFIG_INPUT_PCAP=y
CONFIG_INPUT_ADXL34X=y
CONFIG_INPUT_ADXL34X_I2C=y
CONFIG_INPUT_ADXL34X_SPI=y
CONFIG_INPUT_CMA3000=y
CONFIG_INPUT_CMA3000_I2C=y

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
CONFIG_SERIO_CT82C710=y
CONFIG_SERIO_PARKBD=y
CONFIG_SERIO_PCIPS2=y
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=y
CONFIG_SERIO_ALTERA_PS2=y
CONFIG_SERIO_PS2MULT=y
CONFIG_GAMEPORT=y
CONFIG_GAMEPORT_NS558=y
CONFIG_GAMEPORT_L4=y
CONFIG_GAMEPORT_EMU10K1=y
CONFIG_GAMEPORT_FM801=y

#
# Character devices
#
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
CONFIG_VT_HW_CONSOLE_BINDING=y
CONFIG_UNIX98_PTYS=y
CONFIG_DEVPTS_MULTIPLE_INSTANCES=y
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
CONFIG_SERIAL_NONSTANDARD=y
CONFIG_ROCKETPORT=m
CONFIG_CYCLADES=m
CONFIG_CYZ_INTR=y
CONFIG_MOXA_INTELLIO=m
CONFIG_MOXA_SMARTIO=m
CONFIG_SYNCLINK=m
CONFIG_SYNCLINKMP=m
CONFIG_SYNCLINK_GT=m
CONFIG_NOZOMI=m
CONFIG_ISI=m
CONFIG_N_HDLC=m
CONFIG_N_GSM=m
CONFIG_DEVKMEM=y
CONFIG_STALDRV=y

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_CS=m
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
CONFIG_SERIAL_8250_FOURPORT=m
CONFIG_SERIAL_8250_ACCENT=m
CONFIG_SERIAL_8250_BOCA=m
CONFIG_SERIAL_8250_EXAR_ST16C554=m
CONFIG_SERIAL_8250_HUB6=m
CONFIG_SERIAL_8250_SHARE_IRQ=y
CONFIG_SERIAL_8250_DETECT_IRQ=y
CONFIG_SERIAL_8250_RSA=y
CONFIG_SERIAL_8250_MCA=m

#
# Non-8250 serial port support
#
CONFIG_SERIAL_MAX3100=m
CONFIG_SERIAL_MAX3107=m
CONFIG_SERIAL_MRST_MAX3110=m
CONFIG_SERIAL_MFD_HSU=m
CONFIG_SERIAL_UARTLITE=m
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_SERIAL_JSM=m
CONFIG_SERIAL_OF_PLATFORM=m
CONFIG_SERIAL_TIMBERDALE=m
CONFIG_SERIAL_ALTERA_JTAGUART=m
CONFIG_SERIAL_ALTERA_UART=m
CONFIG_SERIAL_ALTERA_UART_MAXPORTS=4
CONFIG_SERIAL_ALTERA_UART_BAUDRATE=115200
CONFIG_SERIAL_IFX6X60=m
CONFIG_SERIAL_PCH_UART=m
CONFIG_TTY_PRINTK=y
CONFIG_PRINTER=y
CONFIG_LP_CONSOLE=y
CONFIG_PPDEV=m
CONFIG_HVC_DRIVER=y
CONFIG_VIRTIO_CONSOLE=y
CONFIG_IPMI_HANDLER=m
# CONFIG_IPMI_PANIC_EVENT is not set
CONFIG_IPMI_DEVICE_INTERFACE=m
CONFIG_IPMI_SI=m
CONFIG_IPMI_WATCHDOG=m
CONFIG_IPMI_POWEROFF=m
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_TIMERIOMEM=m
CONFIG_HW_RANDOM_INTEL=m
CONFIG_HW_RANDOM_AMD=m
CONFIG_HW_RANDOM_GEODE=m
CONFIG_HW_RANDOM_VIA=m
CONFIG_HW_RANDOM_VIRTIO=m
CONFIG_NVRAM=y
CONFIG_DTLK=m
CONFIG_R3964=m
CONFIG_APPLICOM=m
CONFIG_SONYPI=m

#
# PCMCIA character devices
#
CONFIG_SYNCLINK_CS=m
CONFIG_CARDMAN_4000=m
CONFIG_CARDMAN_4040=m
CONFIG_IPWIRELESS=m
CONFIG_MWAVE=m
CONFIG_SCx200_GPIO=m
CONFIG_PC8736x_GPIO=m
CONFIG_NSC_GPIO=m
CONFIG_RAW_DRIVER=m
CONFIG_MAX_RAW_DEVS=256
CONFIG_HPET=y
CONFIG_HPET_MMAP=y
CONFIG_HANGCHECK_TIMER=m
CONFIG_TCG_TPM=m
CONFIG_TCG_TIS=m
CONFIG_TCG_NSC=m
CONFIG_TCG_ATMEL=m
CONFIG_TCG_INFINEON=m
CONFIG_TELCLOCK=m
CONFIG_DEVPORT=y
CONFIG_RAMOOPS=m
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
CONFIG_I2C_CHARDEV=y
CONFIG_I2C_MUX=m

#
# Multiplexer I2C Chip support
#
CONFIG_I2C_MUX_GPIO=m
CONFIG_I2C_MUX_PCA9541=m
CONFIG_I2C_MUX_PCA954x=m
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_SMBUS=m
CONFIG_I2C_ALGOBIT=y
CONFIG_I2C_ALGOPCA=m

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
CONFIG_I2C_ALI1535=m
CONFIG_I2C_ALI1563=m
CONFIG_I2C_ALI15X3=m
CONFIG_I2C_AMD756=m
CONFIG_I2C_AMD756_S4882=m
CONFIG_I2C_AMD8111=m
CONFIG_I2C_I801=m
CONFIG_I2C_ISCH=m
CONFIG_I2C_PIIX4=m
CONFIG_I2C_NFORCE2=m
CONFIG_I2C_NFORCE2_S4985=m
CONFIG_I2C_SIS5595=m
CONFIG_I2C_SIS630=m
CONFIG_I2C_SIS96X=m
CONFIG_I2C_VIA=m
CONFIG_I2C_VIAPRO=m

#
# ACPI drivers
#
CONFIG_I2C_SCMI=m

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
CONFIG_I2C_GPIO=m
# CONFIG_I2C_INTEL_MID is not set
CONFIG_I2C_OCORES=m
CONFIG_I2C_PCA_PLATFORM=m
CONFIG_I2C_PXA=m
CONFIG_I2C_PXA_PCI=y
CONFIG_I2C_SIMTEC=m
CONFIG_I2C_XILINX=m
CONFIG_I2C_EG20T=m

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_DIOLAN_U2C=m
CONFIG_I2C_PARPORT=m
CONFIG_I2C_PARPORT_LIGHT=m
CONFIG_I2C_TAOS_EVM=m
CONFIG_I2C_TINY_USB=m

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_PCA_ISA is not set
CONFIG_I2C_STUB=m
CONFIG_SCx200_I2C=m
CONFIG_SCx200_I2C_SCL=12
CONFIG_SCx200_I2C_SDA=13
CONFIG_SCx200_ACB=m
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
CONFIG_SPI=y
CONFIG_SPI_MASTER=y

#
# SPI Master Controller Drivers
#
CONFIG_SPI_ALTERA=m
CONFIG_SPI_BITBANG=m
CONFIG_SPI_BUTTERFLY=m
CONFIG_SPI_GPIO=m
CONFIG_SPI_LM70_LLP=m
CONFIG_SPI_OC_TINY=m
CONFIG_SPI_PXA2XX=m
CONFIG_SPI_PXA2XX_PCI=y
CONFIG_SPI_TOPCLIFF_PCH=m
CONFIG_SPI_XILINX=m
CONFIG_SPI_DESIGNWARE=y
CONFIG_SPI_DW_PCI=m
# CONFIG_SPI_DW_MID_DMA is not set

#
# SPI Protocol Masters
#
CONFIG_SPI_SPIDEV=m
CONFIG_SPI_TLE62X0=m

#
# PPS support
#
CONFIG_PPS=m
# CONFIG_PPS_DEBUG is not set
# CONFIG_NTP_PPS is not set

#
# PPS clients support
#
CONFIG_PPS_CLIENT_KTIMER=m
CONFIG_PPS_CLIENT_LDISC=m
CONFIG_PPS_CLIENT_PARPORT=m

#
# PPS generators support
#
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIOLIB=y
CONFIG_GPIO_SYSFS=y
CONFIG_GPIO_MAX730X=m

#
# Memory mapped GPIO expanders:
#
CONFIG_GPIO_BASIC_MMIO=m
CONFIG_GPIO_IT8761E=m
CONFIG_GPIO_SCH=m
CONFIG_GPIO_VX855=m

#
# I2C GPIO expanders:
#
CONFIG_GPIO_MAX7300=m
CONFIG_GPIO_MAX732X=m
CONFIG_GPIO_PCA953X=m
CONFIG_GPIO_PCF857X=m
CONFIG_GPIO_SX150X=y
CONFIG_GPIO_STMPE=y
CONFIG_GPIO_TC3589X=y
CONFIG_GPIO_TWL4030=m
CONFIG_GPIO_WM831X=m
CONFIG_GPIO_WM8350=m
CONFIG_GPIO_WM8994=m
CONFIG_GPIO_ADP5520=m
CONFIG_GPIO_ADP5588=m

#
# PCI GPIO expanders:
#
CONFIG_GPIO_CS5535=m
CONFIG_GPIO_LANGWELL=y
CONFIG_GPIO_PCH=m
CONFIG_GPIO_ML_IOH=m
CONFIG_GPIO_TIMBERDALE=y
CONFIG_GPIO_RDC321X=m

#
# SPI GPIO expanders:
#
CONFIG_GPIO_MAX7301=m
CONFIG_GPIO_MCP23S08=m
CONFIG_GPIO_MC33880=m
CONFIG_GPIO_74X164=m

#
# AC97 GPIO expanders:
#
CONFIG_GPIO_UCB1400=y

#
# MODULbus GPIO expanders:
#
CONFIG_GPIO_JANZ_TTL=m
CONFIG_W1=m
CONFIG_W1_CON=y

#
# 1-wire Bus Masters
#
CONFIG_W1_MASTER_MATROX=m
CONFIG_W1_MASTER_DS2490=m
CONFIG_W1_MASTER_DS2482=m
CONFIG_W1_MASTER_GPIO=m

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=m
CONFIG_W1_SLAVE_SMEM=m
CONFIG_W1_SLAVE_DS2423=m
CONFIG_W1_SLAVE_DS2431=m
CONFIG_W1_SLAVE_DS2433=m
CONFIG_W1_SLAVE_DS2433_CRC=y
CONFIG_W1_SLAVE_DS2760=m
CONFIG_W1_SLAVE_BQ27000=m
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
CONFIG_PDA_POWER=m
CONFIG_MAX8925_POWER=m
CONFIG_WM831X_BACKUP=m
CONFIG_WM831X_POWER=m
CONFIG_WM8350_POWER=m
# CONFIG_TEST_POWER is not set
CONFIG_BATTERY_DS2760=m
CONFIG_BATTERY_DS2782=m
CONFIG_BATTERY_OLPC=m
CONFIG_BATTERY_BQ20Z75=m
CONFIG_BATTERY_BQ27x00=m
CONFIG_BATTERY_BQ27X00_I2C=y
CONFIG_BATTERY_BQ27X00_PLATFORM=y
CONFIG_BATTERY_DA9030=m
CONFIG_BATTERY_MAX17040=m
CONFIG_BATTERY_MAX17042=m
CONFIG_CHARGER_PCF50633=m
CONFIG_CHARGER_ISP1704=m
CONFIG_CHARGER_TWL4030=m
CONFIG_CHARGER_GPIO=m
CONFIG_HWMON=y
CONFIG_HWMON_VID=m
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
CONFIG_SENSORS_ABITUGURU=m
CONFIG_SENSORS_ABITUGURU3=m
CONFIG_SENSORS_AD7414=m
CONFIG_SENSORS_AD7418=m
CONFIG_SENSORS_ADCXX=m
CONFIG_SENSORS_ADM1021=m
CONFIG_SENSORS_ADM1025=m
CONFIG_SENSORS_ADM1026=m
CONFIG_SENSORS_ADM1029=m
CONFIG_SENSORS_ADM1031=m
CONFIG_SENSORS_ADM9240=m
CONFIG_SENSORS_ADT7411=m
CONFIG_SENSORS_ADT7462=m
CONFIG_SENSORS_ADT7470=m
CONFIG_SENSORS_ADT7475=m
CONFIG_SENSORS_ASC7621=m
CONFIG_SENSORS_K8TEMP=m
CONFIG_SENSORS_K10TEMP=m
CONFIG_SENSORS_ASB100=m
CONFIG_SENSORS_ATXP1=m
CONFIG_SENSORS_DS620=m
CONFIG_SENSORS_DS1621=m
CONFIG_SENSORS_I5K_AMB=m
CONFIG_SENSORS_F71805F=m
CONFIG_SENSORS_F71882FG=m
CONFIG_SENSORS_F75375S=m
CONFIG_SENSORS_FSCHMD=m
CONFIG_SENSORS_G760A=m
CONFIG_SENSORS_GL518SM=m
CONFIG_SENSORS_GL520SM=m
CONFIG_SENSORS_GPIO_FAN=m
CONFIG_SENSORS_CORETEMP=m
CONFIG_SENSORS_PKGTEMP=m
CONFIG_SENSORS_IBMAEM=m
CONFIG_SENSORS_IBMPEX=m
CONFIG_SENSORS_IT87=m
CONFIG_SENSORS_JC42=m
CONFIG_SENSORS_LINEAGE=m
CONFIG_SENSORS_LM63=m
CONFIG_SENSORS_LM70=m
CONFIG_SENSORS_LM73=m
CONFIG_SENSORS_LM75=m
CONFIG_SENSORS_LM77=m
CONFIG_SENSORS_LM78=m
CONFIG_SENSORS_LM80=m
CONFIG_SENSORS_LM83=m
CONFIG_SENSORS_LM85=m
CONFIG_SENSORS_LM87=m
CONFIG_SENSORS_LM90=m
CONFIG_SENSORS_LM92=m
CONFIG_SENSORS_LM93=m
CONFIG_SENSORS_LTC4151=m
CONFIG_SENSORS_LTC4215=m
CONFIG_SENSORS_LTC4245=m
CONFIG_SENSORS_LTC4261=m
CONFIG_SENSORS_LM95241=m
CONFIG_SENSORS_MAX1111=m
CONFIG_SENSORS_MAX1619=m
CONFIG_SENSORS_MAX6639=m
CONFIG_SENSORS_MAX6650=m
CONFIG_SENSORS_PC87360=m
CONFIG_SENSORS_PC87427=m
CONFIG_SENSORS_PCF8591=m
CONFIG_PMBUS=m
CONFIG_SENSORS_PMBUS=m
CONFIG_SENSORS_MAX16064=m
CONFIG_SENSORS_MAX34440=m
CONFIG_SENSORS_MAX8688=m
CONFIG_SENSORS_SHT15=m
CONFIG_SENSORS_SHT21=m
CONFIG_SENSORS_SIS5595=m
CONFIG_SENSORS_SMM665=m
CONFIG_SENSORS_DME1737=m
CONFIG_SENSORS_EMC1403=m
CONFIG_SENSORS_EMC2103=m
CONFIG_SENSORS_SMSC47M1=m
CONFIG_SENSORS_SMSC47M192=m
CONFIG_SENSORS_SMSC47B397=m
CONFIG_SENSORS_SCH5627=m
CONFIG_SENSORS_ADS1015=m
CONFIG_SENSORS_ADS7828=m
CONFIG_SENSORS_ADS7871=m
CONFIG_SENSORS_AMC6821=m
CONFIG_SENSORS_THMC50=m
CONFIG_SENSORS_TMP102=m
CONFIG_SENSORS_TMP401=m
CONFIG_SENSORS_TMP421=m
# CONFIG_SENSORS_TWL4030_MADC is not set
CONFIG_SENSORS_VIA_CPUTEMP=m
CONFIG_SENSORS_VIA686A=m
CONFIG_SENSORS_VT1211=m
CONFIG_SENSORS_VT8231=m
CONFIG_SENSORS_W83781D=m
CONFIG_SENSORS_W83791D=m
CONFIG_SENSORS_W83792D=m
CONFIG_SENSORS_W83793=m
CONFIG_SENSORS_W83795=m
# CONFIG_SENSORS_W83795_FANCTRL is not set
CONFIG_SENSORS_W83L785TS=m
CONFIG_SENSORS_W83L786NG=m
CONFIG_SENSORS_W83627HF=m
CONFIG_SENSORS_W83627EHF=m
CONFIG_SENSORS_WM831X=m
CONFIG_SENSORS_WM8350=m
CONFIG_SENSORS_APPLESMC=m
CONFIG_SENSORS_MC13783_ADC=m

#
# ACPI drivers
#
CONFIG_SENSORS_ATK0110=m
CONFIG_THERMAL=y
CONFIG_THERMAL_HWMON=y
CONFIG_WATCHDOG=y
# CONFIG_WATCHDOG_NOWAYOUT is not set

#
# Watchdog Device Drivers
#
CONFIG_SOFT_WATCHDOG=m
CONFIG_WM831X_WATCHDOG=m
CONFIG_WM8350_WATCHDOG=m
CONFIG_TWL4030_WATCHDOG=m
CONFIG_ACQUIRE_WDT=m
CONFIG_ADVANTECH_WDT=m
CONFIG_ALIM1535_WDT=m
CONFIG_ALIM7101_WDT=m
CONFIG_F71808E_WDT=m
CONFIG_SP5100_TCO=m
CONFIG_GEODE_WDT=m
CONFIG_SC520_WDT=m
CONFIG_SBC_FITPC2_WATCHDOG=m
# CONFIG_EUROTECH_WDT is not set
CONFIG_IB700_WDT=m
CONFIG_IBMASR=m
CONFIG_WAFER_WDT=m
CONFIG_I6300ESB_WDT=m
CONFIG_ITCO_WDT=m
CONFIG_ITCO_VENDOR_SUPPORT=y
CONFIG_IT8712F_WDT=m
CONFIG_IT87_WDT=m
CONFIG_HP_WATCHDOG=m
CONFIG_HPWDT_NMI_DECODING=y
CONFIG_SC1200_WDT=m
CONFIG_SCx200_WDT=m
CONFIG_PC87413_WDT=m
CONFIG_NV_TCO=m
CONFIG_RDC321X_WDT=m
CONFIG_60XX_WDT=m
CONFIG_SBC8360_WDT=m
CONFIG_SBC7240_WDT=m
CONFIG_CPU5_WDT=m
CONFIG_SMSC_SCH311X_WDT=m
CONFIG_SMSC37B787_WDT=m
CONFIG_W83627HF_WDT=m
CONFIG_W83697HF_WDT=m
CONFIG_W83697UG_WDT=m
CONFIG_W83877F_WDT=m
CONFIG_W83977F_WDT=m
CONFIG_MACHZ_WDT=m
CONFIG_SBC_EPX_C3_WATCHDOG=m

#
# ISA-based Watchdog Cards
#
CONFIG_PCWATCHDOG=m
CONFIG_MIXCOMWD=m
# CONFIG_WDT is not set

#
# PCI-based Watchdog Cards
#
CONFIG_PCIPCWATCHDOG=m
CONFIG_WDTPCI=m

#
# USB-based Watchdog Cards
#
CONFIG_USBPCWATCHDOG=m
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
CONFIG_SSB=m
CONFIG_SSB_SPROM=y
CONFIG_SSB_BLOCKIO=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
CONFIG_SSB_B43_PCI_BRIDGE=y
CONFIG_SSB_PCMCIAHOST_POSSIBLE=y
CONFIG_SSB_PCMCIAHOST=y
CONFIG_SSB_SDIOHOST_POSSIBLE=y
CONFIG_SSB_SDIOHOST=y
# CONFIG_SSB_SILENT is not set
# CONFIG_SSB_DEBUG is not set
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
CONFIG_SSB_DRIVER_PCICORE=y
CONFIG_MFD_SUPPORT=y
CONFIG_MFD_CORE=y
CONFIG_MFD_88PM860X=y
CONFIG_MFD_SM501=m
CONFIG_MFD_SM501_GPIO=y
CONFIG_HTC_PASIC3=m
CONFIG_HTC_I2CPLD=y
CONFIG_UCB1400_CORE=m
CONFIG_TPS6105X=m
CONFIG_TPS65010=m
CONFIG_TPS6507X=m
CONFIG_TWL4030_CORE=y
CONFIG_TWL4030_MADC=m
CONFIG_TWL4030_CODEC=y
CONFIG_TWL6030_PWM=m
CONFIG_MFD_STMPE=y
CONFIG_MFD_TC3589X=y
# CONFIG_MFD_TMIO is not set
CONFIG_PMIC_DA903X=y
CONFIG_PMIC_ADP5520=y
CONFIG_MFD_MAX8925=y
CONFIG_MFD_MAX8997=y
CONFIG_MFD_MAX8998=y
CONFIG_MFD_WM8400=m
CONFIG_MFD_WM831X=y
CONFIG_MFD_WM831X_I2C=y
CONFIG_MFD_WM831X_SPI=y
CONFIG_MFD_WM8350=y
CONFIG_MFD_WM8350_I2C=y
CONFIG_MFD_WM8994=y
CONFIG_MFD_PCF50633=m
CONFIG_MFD_MC13783=m
CONFIG_MFD_MC13XXX=m
CONFIG_PCF50633_ADC=m
CONFIG_PCF50633_GPIO=m
CONFIG_ABX500_CORE=y
CONFIG_AB3100_CORE=y
CONFIG_AB3100_OTP=m
CONFIG_EZX_PCAP=y
CONFIG_AB8500_CORE=y
CONFIG_AB8500_DEBUG=y
CONFIG_AB8500_GPADC=y
CONFIG_AB3550_CORE=y
CONFIG_MFD_CS5535=m
CONFIG_MFD_TIMBERDALE=y
CONFIG_LPC_SCH=m
CONFIG_MFD_RDC321X=m
CONFIG_MFD_JANZ_CMODIO=m
CONFIG_MFD_TPS6586X=y
CONFIG_MFD_VX855=m
CONFIG_MFD_WL1273_CORE=m
CONFIG_REGULATOR=y
# CONFIG_REGULATOR_DEBUG is not set
CONFIG_REGULATOR_DUMMY=y
CONFIG_REGULATOR_FIXED_VOLTAGE=m
CONFIG_REGULATOR_VIRTUAL_CONSUMER=m
CONFIG_REGULATOR_USERSPACE_CONSUMER=m
CONFIG_REGULATOR_BQ24022=m
CONFIG_REGULATOR_MAX1586=m
CONFIG_REGULATOR_MAX8649=m
CONFIG_REGULATOR_MAX8660=m
CONFIG_REGULATOR_MAX8925=m
CONFIG_REGULATOR_MAX8952=m
CONFIG_REGULATOR_MAX8997=m
CONFIG_REGULATOR_MAX8998=m
CONFIG_REGULATOR_TWL4030=y
CONFIG_REGULATOR_WM831X=m
CONFIG_REGULATOR_WM8350=m
CONFIG_REGULATOR_WM8400=m
CONFIG_REGULATOR_WM8994=m
CONFIG_REGULATOR_DA903X=m
CONFIG_REGULATOR_PCF50633=m
CONFIG_REGULATOR_LP3971=m
CONFIG_REGULATOR_LP3972=m
CONFIG_REGULATOR_PCAP=m
CONFIG_REGULATOR_MC13XXX_CORE=m
CONFIG_REGULATOR_MC13783=m
CONFIG_REGULATOR_MC13892=m
CONFIG_REGULATOR_AB3100=m
CONFIG_REGULATOR_TPS6105X=m
CONFIG_REGULATOR_TPS65023=m
CONFIG_REGULATOR_TPS6507X=m
CONFIG_REGULATOR_88PM8607=y
CONFIG_REGULATOR_ISL6271A=m
CONFIG_REGULATOR_AD5398=m
CONFIG_REGULATOR_AB8500=y
CONFIG_REGULATOR_TPS6586X=m
CONFIG_REGULATOR_TPS6524X=m
CONFIG_MEDIA_SUPPORT=y

#
# Multimedia core support
#
CONFIG_MEDIA_CONTROLLER=y
CONFIG_VIDEO_DEV=y
CONFIG_VIDEO_V4L2_COMMON=y
CONFIG_VIDEO_V4L2_SUBDEV_API=y
CONFIG_DVB_CORE=y
CONFIG_VIDEO_MEDIA=y

#
# Multimedia drivers
#
CONFIG_VIDEO_SAA7146=m
CONFIG_VIDEO_SAA7146_VV=m
CONFIG_RC_CORE=y
CONFIG_LIRC=y
CONFIG_RC_MAP=y
CONFIG_IR_NEC_DECODER=y
CONFIG_IR_RC5_DECODER=y
CONFIG_IR_RC6_DECODER=y
CONFIG_IR_JVC_DECODER=y
CONFIG_IR_SONY_DECODER=y
CONFIG_IR_RC5_SZ_DECODER=y
CONFIG_IR_LIRC_CODEC=y
CONFIG_IR_ENE=m
CONFIG_IR_IMON=m
CONFIG_IR_MCEUSB=m
CONFIG_IR_ITE_CIR=m
CONFIG_IR_NUVOTON=m
CONFIG_IR_STREAMZAP=m
CONFIG_IR_WINBOND_CIR=m
# CONFIG_RC_LOOPBACK is not set
CONFIG_MEDIA_ATTACH=y
CONFIG_MEDIA_TUNER=y
CONFIG_MEDIA_TUNER_CUSTOMISE=y

#
# Customize TV tuners
#
CONFIG_MEDIA_TUNER_SIMPLE=m
CONFIG_MEDIA_TUNER_TDA8290=m
CONFIG_MEDIA_TUNER_TDA827X=m
CONFIG_MEDIA_TUNER_TDA18271=m
CONFIG_MEDIA_TUNER_TDA9887=m
CONFIG_MEDIA_TUNER_TEA5761=m
CONFIG_MEDIA_TUNER_TEA5767=m
CONFIG_MEDIA_TUNER_MT20XX=m
CONFIG_MEDIA_TUNER_MT2060=m
CONFIG_MEDIA_TUNER_MT2266=m
CONFIG_MEDIA_TUNER_MT2131=m
CONFIG_MEDIA_TUNER_QT1010=m
CONFIG_MEDIA_TUNER_XC2028=m
CONFIG_MEDIA_TUNER_XC5000=m
CONFIG_MEDIA_TUNER_MXL5005S=m
CONFIG_MEDIA_TUNER_MXL5007T=m
CONFIG_MEDIA_TUNER_MC44S803=m
CONFIG_MEDIA_TUNER_MAX2165=m
CONFIG_MEDIA_TUNER_TDA18218=m
CONFIG_VIDEO_V4L2=y
CONFIG_VIDEOBUF_GEN=m
CONFIG_VIDEOBUF_DMA_SG=m
CONFIG_VIDEOBUF_VMALLOC=m
CONFIG_VIDEOBUF_DMA_CONTIG=m
CONFIG_VIDEOBUF_DVB=m
CONFIG_VIDEO_BTCX=m
CONFIG_VIDEO_TVEEPROM=m
CONFIG_VIDEO_TUNER=m
CONFIG_VIDEOBUF2_CORE=m
CONFIG_VIDEO_CAPTURE_DRIVERS=y
# CONFIG_VIDEO_ADV_DEBUG is not set
# CONFIG_VIDEO_FIXED_MINOR_RANGES is not set
CONFIG_VIDEO_HELPER_CHIPS_AUTO=y
CONFIG_VIDEO_IR_I2C=y

#
# Audio decoders
#
CONFIG_VIDEO_TVAUDIO=m
CONFIG_VIDEO_TDA7432=m
CONFIG_VIDEO_TDA9840=m
CONFIG_VIDEO_TEA6415C=m
CONFIG_VIDEO_TEA6420=m
CONFIG_VIDEO_MSP3400=m
CONFIG_VIDEO_CS5345=m
CONFIG_VIDEO_CS53L32A=m
CONFIG_VIDEO_M52790=m
CONFIG_VIDEO_WM8775=m
CONFIG_VIDEO_WM8739=m
CONFIG_VIDEO_VP27SMPX=m

#
# RDS decoders
#
CONFIG_VIDEO_SAA6588=m

#
# Video decoders
#
CONFIG_VIDEO_ADV7180=m
CONFIG_VIDEO_BT819=m
CONFIG_VIDEO_BT856=m
CONFIG_VIDEO_BT866=m
CONFIG_VIDEO_KS0127=m
CONFIG_VIDEO_OV7670=m
CONFIG_VIDEO_MT9V011=m
CONFIG_VIDEO_SAA7110=m
CONFIG_VIDEO_SAA711X=m
CONFIG_VIDEO_SAA717X=m
CONFIG_VIDEO_TVP5150=m
CONFIG_VIDEO_VPX3220=m

#
# Video and audio decoders
#
CONFIG_VIDEO_CX25840=m

#
# MPEG video encoders
#
CONFIG_VIDEO_CX2341X=m

#
# Video encoders
#
CONFIG_VIDEO_SAA7127=m
CONFIG_VIDEO_SAA7185=m
CONFIG_VIDEO_ADV7170=m
CONFIG_VIDEO_ADV7175=m

#
# Video improvement chips
#
CONFIG_VIDEO_UPD64031A=m
CONFIG_VIDEO_UPD64083=m
CONFIG_VIDEO_BT848=m
CONFIG_VIDEO_BT848_DVB=y
CONFIG_VIDEO_PMS=m
CONFIG_VIDEO_BWQCAM=m
CONFIG_VIDEO_CQCAM=m
CONFIG_VIDEO_W9966=m
CONFIG_VIDEO_CPIA2=m
CONFIG_VIDEO_ZORAN=m
CONFIG_VIDEO_ZORAN_DC30=m
CONFIG_VIDEO_ZORAN_ZR36060=m
CONFIG_VIDEO_ZORAN_BUZ=m
CONFIG_VIDEO_ZORAN_DC10=m
CONFIG_VIDEO_ZORAN_LML33=m
CONFIG_VIDEO_ZORAN_LML33R10=m
CONFIG_VIDEO_ZORAN_AVS6EYES=m
CONFIG_VIDEO_MEYE=m
CONFIG_VIDEO_SAA7134=m
CONFIG_VIDEO_SAA7134_ALSA=m
CONFIG_VIDEO_SAA7134_RC=y
CONFIG_VIDEO_SAA7134_DVB=m
CONFIG_VIDEO_MXB=m
CONFIG_VIDEO_HEXIUM_ORION=m
CONFIG_VIDEO_HEXIUM_GEMINI=m
CONFIG_VIDEO_TIMBERDALE=m
CONFIG_VIDEO_CX88=m
CONFIG_VIDEO_CX88_ALSA=m
CONFIG_VIDEO_CX88_BLACKBIRD=m
CONFIG_VIDEO_CX88_DVB=m
CONFIG_VIDEO_CX88_MPEG=m
CONFIG_VIDEO_CX88_VP3054=m
CONFIG_VIDEO_CX23885=m
CONFIG_MEDIA_ALTERA_CI=m
CONFIG_VIDEO_AU0828=m
CONFIG_VIDEO_IVTV=m
CONFIG_VIDEO_FB_IVTV=m
CONFIG_VIDEO_CX18=m
CONFIG_VIDEO_CX18_ALSA=m
CONFIG_VIDEO_SAA7164=m
CONFIG_VIDEO_CAFE_CCIC=m
CONFIG_VIDEO_SR030PC30=m
CONFIG_VIDEO_VIA_CAMERA=m
CONFIG_VIDEO_NOON010PC30=m
CONFIG_SOC_CAMERA=m
CONFIG_SOC_CAMERA_IMX074=m
CONFIG_SOC_CAMERA_MT9M001=m
CONFIG_SOC_CAMERA_MT9M111=m
CONFIG_SOC_CAMERA_MT9T031=m
CONFIG_SOC_CAMERA_MT9T112=m
CONFIG_SOC_CAMERA_MT9V022=m
CONFIG_SOC_CAMERA_RJ54N1=m
CONFIG_SOC_CAMERA_TW9910=m
CONFIG_SOC_CAMERA_PLATFORM=m
CONFIG_SOC_CAMERA_OV2640=m
CONFIG_SOC_CAMERA_OV6650=m
CONFIG_SOC_CAMERA_OV772X=m
CONFIG_SOC_CAMERA_OV9640=m
CONFIG_SOC_CAMERA_OV9740=m
CONFIG_V4L_USB_DRIVERS=y
CONFIG_USB_VIDEO_CLASS=m
CONFIG_USB_VIDEO_CLASS_INPUT_EVDEV=y
CONFIG_USB_GSPCA=m
CONFIG_USB_M5602=m
CONFIG_USB_STV06XX=m
CONFIG_USB_GL860=m
CONFIG_USB_GSPCA_BENQ=m
CONFIG_USB_GSPCA_CONEX=m
CONFIG_USB_GSPCA_CPIA1=m
CONFIG_USB_GSPCA_ETOMS=m
CONFIG_USB_GSPCA_FINEPIX=m
CONFIG_USB_GSPCA_JEILINJ=m
CONFIG_USB_GSPCA_KONICA=m
CONFIG_USB_GSPCA_MARS=m
CONFIG_USB_GSPCA_MR97310A=m
CONFIG_USB_GSPCA_NW80X=m
CONFIG_USB_GSPCA_OV519=m
CONFIG_USB_GSPCA_OV534=m
CONFIG_USB_GSPCA_OV534_9=m
CONFIG_USB_GSPCA_PAC207=m
CONFIG_USB_GSPCA_PAC7302=m
CONFIG_USB_GSPCA_PAC7311=m
CONFIG_USB_GSPCA_SN9C2028=m
CONFIG_USB_GSPCA_SN9C20X=m
CONFIG_USB_GSPCA_SONIXB=m
CONFIG_USB_GSPCA_SONIXJ=m
CONFIG_USB_GSPCA_SPCA500=m
CONFIG_USB_GSPCA_SPCA501=m
CONFIG_USB_GSPCA_SPCA505=m
CONFIG_USB_GSPCA_SPCA506=m
CONFIG_USB_GSPCA_SPCA508=m
CONFIG_USB_GSPCA_SPCA561=m
CONFIG_USB_GSPCA_SPCA1528=m
CONFIG_USB_GSPCA_SQ905=m
CONFIG_USB_GSPCA_SQ905C=m
CONFIG_USB_GSPCA_SQ930X=m
CONFIG_USB_GSPCA_STK014=m
CONFIG_USB_GSPCA_STV0680=m
CONFIG_USB_GSPCA_SUNPLUS=m
CONFIG_USB_GSPCA_T613=m
CONFIG_USB_GSPCA_TV8532=m
CONFIG_USB_GSPCA_VC032X=m
CONFIG_USB_GSPCA_VICAM=m
CONFIG_USB_GSPCA_XIRLINK_CIT=m
CONFIG_USB_GSPCA_ZC3XX=m
CONFIG_VIDEO_PVRUSB2=m
CONFIG_VIDEO_PVRUSB2_SYSFS=y
CONFIG_VIDEO_PVRUSB2_DVB=y
# CONFIG_VIDEO_PVRUSB2_DEBUGIFC is not set
CONFIG_VIDEO_HDPVR=m
CONFIG_VIDEO_EM28XX=m
CONFIG_VIDEO_EM28XX_ALSA=m
CONFIG_VIDEO_EM28XX_DVB=m
CONFIG_VIDEO_TLG2300=m
CONFIG_VIDEO_CX231XX=m
CONFIG_VIDEO_CX231XX_RC=y
CONFIG_VIDEO_CX231XX_ALSA=m
CONFIG_VIDEO_CX231XX_DVB=m
CONFIG_VIDEO_USBVISION=m
CONFIG_USB_ET61X251=m
CONFIG_USB_SN9C102=m
CONFIG_USB_PWC=m
# CONFIG_USB_PWC_DEBUG is not set
CONFIG_USB_PWC_INPUT_EVDEV=y
CONFIG_USB_ZR364XX=m
CONFIG_USB_STKWEBCAM=m
CONFIG_USB_S2255=m
CONFIG_V4L_MEM2MEM_DRIVERS=y
# CONFIG_VIDEO_MEM2MEM_TESTDEV is not set
CONFIG_RADIO_ADAPTERS=y
CONFIG_RADIO_CADET=m
CONFIG_RADIO_RTRACK=m
CONFIG_RADIO_RTRACK2=m
CONFIG_RADIO_AZTECH=m
CONFIG_RADIO_GEMTEK=m
CONFIG_RADIO_MAXIRADIO=m
CONFIG_RADIO_MAESTRO=m
CONFIG_RADIO_MIROPCM20=m
CONFIG_RADIO_SF16FMI=m
CONFIG_RADIO_SF16FMR2=m
CONFIG_RADIO_TERRATEC=m
CONFIG_RADIO_TRUST=m
CONFIG_RADIO_TYPHOON=m
CONFIG_RADIO_ZOLTRIX=m
CONFIG_I2C_SI4713=m
CONFIG_RADIO_SI4713=m
CONFIG_USB_DSBR=m
CONFIG_RADIO_SI470X=y
CONFIG_USB_SI470X=m
CONFIG_I2C_SI470X=m
CONFIG_USB_MR800=m
CONFIG_RADIO_TEA5764=m
CONFIG_RADIO_SAA7706H=m
CONFIG_RADIO_TEF6862=m
CONFIG_RADIO_TIMBERDALE=m
CONFIG_RADIO_WL1273=m

#
# Texas Instruments WL128x FM driver (ST based)
#
CONFIG_RADIO_WL128X=m
CONFIG_DVB_MAX_ADAPTERS=8
CONFIG_DVB_DYNAMIC_MINORS=y
CONFIG_DVB_CAPTURE_DRIVERS=y

#
# Supported SAA7146 based PCI Adapters
#
CONFIG_TTPCI_EEPROM=m
CONFIG_DVB_AV7110=m
CONFIG_DVB_AV7110_OSD=y
CONFIG_DVB_BUDGET_CORE=m
CONFIG_DVB_BUDGET=m
CONFIG_DVB_BUDGET_CI=m
CONFIG_DVB_BUDGET_AV=m
CONFIG_DVB_BUDGET_PATCH=m

#
# Supported USB Adapters
#
CONFIG_DVB_USB=m
# CONFIG_DVB_USB_DEBUG is not set
CONFIG_DVB_USB_A800=m
CONFIG_DVB_USB_DIBUSB_MB=m
CONFIG_DVB_USB_DIBUSB_MB_FAULTY=y
CONFIG_DVB_USB_DIBUSB_MC=m
CONFIG_DVB_USB_DIB0700=m
CONFIG_DVB_USB_UMT_010=m
CONFIG_DVB_USB_CXUSB=m
CONFIG_DVB_USB_M920X=m
CONFIG_DVB_USB_GL861=m
CONFIG_DVB_USB_AU6610=m
CONFIG_DVB_USB_DIGITV=m
CONFIG_DVB_USB_VP7045=m
CONFIG_DVB_USB_VP702X=m
CONFIG_DVB_USB_GP8PSK=m
CONFIG_DVB_USB_NOVA_T_USB2=m
CONFIG_DVB_USB_TTUSB2=m
CONFIG_DVB_USB_DTT200U=m
CONFIG_DVB_USB_OPERA1=m
CONFIG_DVB_USB_AF9005=m
CONFIG_DVB_USB_AF9005_REMOTE=m
CONFIG_DVB_USB_DW2102=m
CONFIG_DVB_USB_CINERGY_T2=m
CONFIG_DVB_USB_ANYSEE=m
CONFIG_DVB_USB_DTV5100=m
CONFIG_DVB_USB_AF9015=m
CONFIG_DVB_USB_CE6230=m
CONFIG_DVB_USB_FRIIO=m
CONFIG_DVB_USB_EC168=m
CONFIG_DVB_USB_AZ6027=m
CONFIG_DVB_USB_LME2510=m
CONFIG_DVB_USB_TECHNISAT_USB2=m
CONFIG_DVB_TTUSB_BUDGET=m
CONFIG_DVB_TTUSB_DEC=m
CONFIG_SMS_SIANO_MDTV=m

#
# Siano module components
#
CONFIG_SMS_USB_DRV=m
CONFIG_SMS_SDIO_DRV=m

#
# Supported FlexCopII (B2C2) Adapters
#
CONFIG_DVB_B2C2_FLEXCOP=m
CONFIG_DVB_B2C2_FLEXCOP_PCI=m
CONFIG_DVB_B2C2_FLEXCOP_USB=m
# CONFIG_DVB_B2C2_FLEXCOP_DEBUG is not set

#
# Supported BT878 Adapters
#
CONFIG_DVB_BT8XX=m

#
# Supported Pluto2 Adapters
#
CONFIG_DVB_PLUTO2=m

#
# Supported SDMC DM1105 Adapters
#
CONFIG_DVB_DM1105=m

#
# Supported FireWire (IEEE 1394) Adapters
#
CONFIG_DVB_FIREDTV=m
CONFIG_DVB_FIREDTV_INPUT=y

#
# Supported Earthsoft PT1 Adapters
#
CONFIG_DVB_PT1=m

#
# Supported Mantis Adapters
#
CONFIG_MANTIS_CORE=m
CONFIG_DVB_MANTIS=m
CONFIG_DVB_HOPPER=m

#
# Supported nGene Adapters
#
CONFIG_DVB_NGENE=m

#
# Supported DVB Frontends
#
CONFIG_DVB_FE_CUSTOMISE=y

#
# Customise DVB Frontends
#

#
# Multistandard (satellite) frontends
#
CONFIG_DVB_STB0899=m
CONFIG_DVB_STB6100=m
CONFIG_DVB_STV090x=m
CONFIG_DVB_STV6110x=m

#
# DVB-S (satellite) frontends
#
CONFIG_DVB_CX24110=m
CONFIG_DVB_CX24123=m
CONFIG_DVB_MT312=m
CONFIG_DVB_ZL10036=m
CONFIG_DVB_ZL10039=m
CONFIG_DVB_S5H1420=m
CONFIG_DVB_STV0288=m
CONFIG_DVB_STB6000=m
CONFIG_DVB_STV0299=m
CONFIG_DVB_STV6110=m
CONFIG_DVB_STV0900=m
CONFIG_DVB_TDA8083=m
CONFIG_DVB_TDA10086=m
CONFIG_DVB_TDA8261=m
CONFIG_DVB_VES1X93=m
CONFIG_DVB_TUNER_ITD1000=m
CONFIG_DVB_TUNER_CX24113=m
CONFIG_DVB_TDA826X=m
CONFIG_DVB_TUA6100=m
CONFIG_DVB_CX24116=m
CONFIG_DVB_SI21XX=m
CONFIG_DVB_DS3000=m
CONFIG_DVB_MB86A16=m

#
# DVB-T (terrestrial) frontends
#
CONFIG_DVB_SP8870=m
CONFIG_DVB_SP887X=m
CONFIG_DVB_CX22700=m
CONFIG_DVB_CX22702=m
CONFIG_DVB_S5H1432=m
CONFIG_DVB_DRX397XD=m
CONFIG_DVB_L64781=m
CONFIG_DVB_TDA1004X=m
CONFIG_DVB_NXT6000=m
CONFIG_DVB_MT352=m
CONFIG_DVB_ZL10353=m
CONFIG_DVB_DIB3000MB=m
CONFIG_DVB_DIB3000MC=m
CONFIG_DVB_DIB7000M=m
CONFIG_DVB_DIB7000P=m
CONFIG_DVB_DIB9000=m
CONFIG_DVB_TDA10048=m
CONFIG_DVB_AF9013=m
CONFIG_DVB_EC100=m
CONFIG_DVB_STV0367=m

#
# DVB-C (cable) frontends
#
CONFIG_DVB_VES1820=m
CONFIG_DVB_TDA10021=m
CONFIG_DVB_TDA10023=m
CONFIG_DVB_STV0297=m

#
# ATSC (North American/Korean Terrestrial/Cable DTV) frontends
#
CONFIG_DVB_NXT200X=m
CONFIG_DVB_OR51211=m
CONFIG_DVB_OR51132=m
CONFIG_DVB_BCM3510=m
CONFIG_DVB_LGDT330X=m
CONFIG_DVB_LGDT3305=m
CONFIG_DVB_S5H1409=m
CONFIG_DVB_AU8522=m
CONFIG_DVB_S5H1411=m

#
# ISDB-T (terrestrial) frontends
#
CONFIG_DVB_S921=m
CONFIG_DVB_DIB8000=m
CONFIG_DVB_MB86A20S=m

#
# Digital terrestrial only tuners/PLL
#
CONFIG_DVB_PLL=m
CONFIG_DVB_TUNER_DIB0070=m
CONFIG_DVB_TUNER_DIB0090=m

#
# SEC control devices for DVB-S
#
CONFIG_DVB_LNBP21=m
CONFIG_DVB_ISL6405=m
CONFIG_DVB_ISL6421=m
CONFIG_DVB_ISL6423=m
CONFIG_DVB_LGS8GL5=m
CONFIG_DVB_LGS8GXX=m
CONFIG_DVB_ATBM8830=m
CONFIG_DVB_TDA665x=m
CONFIG_DVB_IX2505V=m

#
# Tools to develop new frontends
#
# CONFIG_DVB_DUMMY_FE is not set

#
# Graphics support
#
CONFIG_AGP=y
CONFIG_AGP_ALI=y
CONFIG_AGP_ATI=y
CONFIG_AGP_AMD=y
CONFIG_AGP_AMD64=y
CONFIG_AGP_INTEL=y
CONFIG_AGP_NVIDIA=y
CONFIG_AGP_SIS=y
CONFIG_AGP_SWORKS=y
CONFIG_AGP_VIA=y
CONFIG_AGP_EFFICEON=y
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
CONFIG_VGA_SWITCHEROO=y
CONFIG_DRM=y
CONFIG_DRM_KMS_HELPER=y
CONFIG_DRM_TTM=y
CONFIG_DRM_TDFX=y
CONFIG_DRM_R128=y
CONFIG_DRM_RADEON=y
# CONFIG_DRM_RADEON_KMS is not set
CONFIG_DRM_I810=y
CONFIG_DRM_I915=m
CONFIG_DRM_I915_KMS=y
CONFIG_DRM_MGA=y
CONFIG_DRM_SIS=m
CONFIG_DRM_VIA=y
CONFIG_DRM_SAVAGE=y
CONFIG_STUB_POULSBO=m
CONFIG_VGASTATE=y
CONFIG_VIDEO_OUTPUT_CONTROL=y
CONFIG_FB=y
CONFIG_FIRMWARE_EDID=y
CONFIG_FB_DDC=y
CONFIG_FB_BOOT_VESA_SUPPORT=y
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
CONFIG_FB_SYS_FILLRECT=y
CONFIG_FB_SYS_COPYAREA=y
CONFIG_FB_SYS_IMAGEBLIT=y
CONFIG_FB_FOREIGN_ENDIAN=y
CONFIG_FB_BOTH_ENDIAN=y
# CONFIG_FB_BIG_ENDIAN is not set
# CONFIG_FB_LITTLE_ENDIAN is not set
CONFIG_FB_SYS_FOPS=y
# CONFIG_FB_WMT_GE_ROPS is not set
CONFIG_FB_DEFERRED_IO=y
CONFIG_FB_HECUBA=y
CONFIG_FB_SVGALIB=y
# CONFIG_FB_MACMODES is not set
CONFIG_FB_BACKLIGHT=y
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
CONFIG_FB_PM2=y
CONFIG_FB_PM2_FIFO_DISCONNECT=y
CONFIG_FB_CYBER2000=y
CONFIG_FB_CYBER2000_DDC=y
CONFIG_FB_ARC=y
# CONFIG_FB_ASILIANT is not set
CONFIG_FB_IMSTT=y
# CONFIG_FB_VGA16 is not set
CONFIG_FB_UVESA=y
# CONFIG_FB_VESA is not set
CONFIG_FB_EFI=y
CONFIG_FB_N411=y
CONFIG_FB_HGA=y
CONFIG_FB_S1D13XXX=y
CONFIG_FB_NVIDIA=y
CONFIG_FB_NVIDIA_I2C=y
# CONFIG_FB_NVIDIA_DEBUG is not set
CONFIG_FB_NVIDIA_BACKLIGHT=y
CONFIG_FB_RIVA=y
CONFIG_FB_RIVA_I2C=y
# CONFIG_FB_RIVA_DEBUG is not set
CONFIG_FB_RIVA_BACKLIGHT=y
CONFIG_FB_I810=y
CONFIG_FB_I810_GTF=y
CONFIG_FB_I810_I2C=y
CONFIG_FB_LE80578=y
CONFIG_FB_CARILLO_RANCH=y
CONFIG_FB_INTEL=m
# CONFIG_FB_INTEL_DEBUG is not set
CONFIG_FB_INTEL_I2C=y
CONFIG_FB_MATROX=y
CONFIG_FB_MATROX_MILLENIUM=y
CONFIG_FB_MATROX_MYSTIQUE=y
CONFIG_FB_MATROX_G=y
CONFIG_FB_MATROX_I2C=y
CONFIG_FB_MATROX_MAVEN=y
# CONFIG_FB_RADEON is not set
CONFIG_FB_ATY128=y
CONFIG_FB_ATY128_BACKLIGHT=y
CONFIG_FB_ATY=y
CONFIG_FB_ATY_CT=y
CONFIG_FB_ATY_GENERIC_LCD=y
CONFIG_FB_ATY_GX=y
CONFIG_FB_ATY_BACKLIGHT=y
CONFIG_FB_S3=y
CONFIG_FB_SAVAGE=y
CONFIG_FB_SAVAGE_I2C=y
CONFIG_FB_SAVAGE_ACCEL=y
CONFIG_FB_SIS=y
CONFIG_FB_SIS_300=y
CONFIG_FB_SIS_315=y
CONFIG_FB_VIA=y
# CONFIG_FB_VIA_DIRECT_PROCFS is not set
CONFIG_FB_NEOMAGIC=y
CONFIG_FB_KYRO=y
CONFIG_FB_3DFX=y
CONFIG_FB_3DFX_ACCEL=y
CONFIG_FB_3DFX_I2C=y
CONFIG_FB_VOODOO1=y
CONFIG_FB_VT8623=y
CONFIG_FB_TRIDENT=y
CONFIG_FB_ARK=y
CONFIG_FB_PM3=y
CONFIG_FB_CARMINE=y
# CONFIG_FB_CARMINE_DRAM_EVAL is not set
CONFIG_CARMINE_DRAM_CUSTOM=y
CONFIG_FB_GEODE=y
CONFIG_FB_GEODE_LX=y
CONFIG_FB_GEODE_GX=y
CONFIG_FB_GEODE_GX1=y
CONFIG_FB_TMIO=m
CONFIG_FB_TMIO_ACCELL=y
CONFIG_FB_SM501=m
CONFIG_FB_UDL=m
# CONFIG_FB_VIRTUAL is not set
CONFIG_FB_METRONOME=y
CONFIG_FB_MB862XX=y
CONFIG_FB_MB862XX_PCI_GDC=y
CONFIG_FB_BROADSHEET=y
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=m
CONFIG_LCD_L4F00242T03=m
CONFIG_LCD_LMS283GF05=m
CONFIG_LCD_LTV350QV=m
CONFIG_LCD_ILI9320=m
CONFIG_LCD_TDO24M=m
CONFIG_LCD_VGG2432A4=m
CONFIG_LCD_PLATFORM=m
CONFIG_LCD_S6E63M0=m
CONFIG_LCD_LD9040=m
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=y
CONFIG_BACKLIGHT_PROGEAR=m
CONFIG_BACKLIGHT_CARILLO_RANCH=m
CONFIG_BACKLIGHT_DA903X=m
CONFIG_BACKLIGHT_MAX8925=m
CONFIG_BACKLIGHT_APPLE=m
CONFIG_BACKLIGHT_SAHARA=m
CONFIG_BACKLIGHT_WM831X=m
CONFIG_BACKLIGHT_ADP5520=m
CONFIG_BACKLIGHT_ADP8860=m
CONFIG_BACKLIGHT_88PM860X=m
CONFIG_BACKLIGHT_PCF50633=m

#
# Display device support
#
CONFIG_DISPLAY_SUPPORT=y

#
# Display hardware drivers
#

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
CONFIG_VGACON_SOFT_SCROLLBACK=y
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=256
# CONFIG_MDA_CONSOLE is not set
CONFIG_DUMMY_CONSOLE=y
# CONFIG_FRAMEBUFFER_CONSOLE is not set
CONFIG_FONT_8x16=y
CONFIG_LOGO=y
# CONFIG_LOGO_LINUX_MONO is not set
CONFIG_LOGO_LINUX_VGA16=y
CONFIG_LOGO_LINUX_CLUT224=y
CONFIG_SOUND=m
CONFIG_SOUND_OSS_CORE=y
CONFIG_SOUND_OSS_CORE_PRECLAIM=y
CONFIG_SND=m
CONFIG_SND_TIMER=m
CONFIG_SND_PCM=m
CONFIG_SND_HWDEP=m
CONFIG_SND_RAWMIDI=m
CONFIG_SND_JACK=y
CONFIG_SND_SEQUENCER=m
CONFIG_SND_SEQ_DUMMY=m
CONFIG_SND_OSSEMUL=y
CONFIG_SND_MIXER_OSS=m
CONFIG_SND_PCM_OSS=m
CONFIG_SND_PCM_OSS_PLUGINS=y
CONFIG_SND_SEQUENCER_OSS=y
CONFIG_SND_HRTIMER=m
CONFIG_SND_SEQ_HRTIMER_DEFAULT=y
CONFIG_SND_DYNAMIC_MINORS=y
CONFIG_SND_SUPPORT_OLD_API=y
CONFIG_SND_VERBOSE_PROCFS=y
# CONFIG_SND_VERBOSE_PRINTK is not set
# CONFIG_SND_DEBUG is not set
CONFIG_SND_VMASTER=y
CONFIG_SND_DMA_SGBUF=y
CONFIG_SND_RAWMIDI_SEQ=m
CONFIG_SND_OPL3_LIB_SEQ=m
CONFIG_SND_OPL4_LIB_SEQ=m
CONFIG_SND_SBAWE_SEQ=m
CONFIG_SND_EMU10K1_SEQ=m
CONFIG_SND_MPU401_UART=m
CONFIG_SND_OPL3_LIB=m
CONFIG_SND_OPL4_LIB=m
CONFIG_SND_VX_LIB=m
CONFIG_SND_AC97_CODEC=m
CONFIG_SND_DRIVERS=y
CONFIG_SND_PCSP=m
CONFIG_SND_DUMMY=m
CONFIG_SND_ALOOP=m
CONFIG_SND_VIRMIDI=m
CONFIG_SND_MTPAV=m
CONFIG_SND_MTS64=m
CONFIG_SND_SERIAL_U16550=m
CONFIG_SND_MPU401=m
CONFIG_SND_PORTMAN2X4=m
CONFIG_SND_AC97_POWER_SAVE=y
CONFIG_SND_AC97_POWER_SAVE_DEFAULT=0
CONFIG_SND_WSS_LIB=m
CONFIG_SND_SB_COMMON=m
CONFIG_SND_SB8_DSP=m
CONFIG_SND_SB16_DSP=m
CONFIG_SND_ISA=y
CONFIG_SND_ADLIB=m
CONFIG_SND_AD1816A=m
CONFIG_SND_AD1848=m
CONFIG_SND_ALS100=m
CONFIG_SND_AZT1605=m
CONFIG_SND_AZT2316=m
CONFIG_SND_AZT2320=m
CONFIG_SND_CMI8330=m
CONFIG_SND_CS4231=m
CONFIG_SND_CS4236=m
CONFIG_SND_ES1688=m
CONFIG_SND_ES18XX=m
CONFIG_SND_SC6000=m
CONFIG_SND_GUSCLASSIC=m
CONFIG_SND_GUSEXTREME=m
CONFIG_SND_GUSMAX=m
CONFIG_SND_INTERWAVE=m
CONFIG_SND_INTERWAVE_STB=m
CONFIG_SND_JAZZ16=m
CONFIG_SND_OPL3SA2=m
CONFIG_SND_OPTI92X_AD1848=m
CONFIG_SND_OPTI92X_CS4231=m
CONFIG_SND_OPTI93X=m
CONFIG_SND_MIRO=m
CONFIG_SND_SB8=m
CONFIG_SND_SB16=m
CONFIG_SND_SBAWE=m
CONFIG_SND_SB16_CSP=y
CONFIG_SND_SSCAPE=m
CONFIG_SND_WAVEFRONT=m
CONFIG_SND_MSND_PINNACLE=m
CONFIG_SND_MSND_CLASSIC=m
CONFIG_SND_PCI=y
CONFIG_SND_AD1889=m
CONFIG_SND_ALS300=m
CONFIG_SND_ALS4000=m
CONFIG_SND_ALI5451=m
CONFIG_SND_ASIHPI=m
CONFIG_SND_ATIIXP=m
CONFIG_SND_ATIIXP_MODEM=m
CONFIG_SND_AU8810=m
CONFIG_SND_AU8820=m
CONFIG_SND_AU8830=m
CONFIG_SND_AW2=m
CONFIG_SND_AZT3328=m
CONFIG_SND_BT87X=m
# CONFIG_SND_BT87X_OVERCLOCK is not set
CONFIG_SND_CA0106=m
CONFIG_SND_CMIPCI=m
CONFIG_SND_OXYGEN_LIB=m
CONFIG_SND_OXYGEN=m
CONFIG_SND_CS4281=m
CONFIG_SND_CS46XX=m
CONFIG_SND_CS46XX_NEW_DSP=y
CONFIG_SND_CS5530=m
CONFIG_SND_CS5535AUDIO=m
CONFIG_SND_CTXFI=m
CONFIG_SND_DARLA20=m
CONFIG_SND_GINA20=m
CONFIG_SND_LAYLA20=m
CONFIG_SND_DARLA24=m
CONFIG_SND_GINA24=m
CONFIG_SND_LAYLA24=m
CONFIG_SND_MONA=m
CONFIG_SND_MIA=m
CONFIG_SND_ECHO3G=m
CONFIG_SND_INDIGO=m
CONFIG_SND_INDIGOIO=m
CONFIG_SND_INDIGODJ=m
CONFIG_SND_INDIGOIOX=m
CONFIG_SND_INDIGODJX=m
CONFIG_SND_EMU10K1=m
CONFIG_SND_EMU10K1X=m
CONFIG_SND_ENS1370=m
CONFIG_SND_ENS1371=m
CONFIG_SND_ES1938=m
CONFIG_SND_ES1968=m
CONFIG_SND_ES1968_INPUT=y
CONFIG_SND_FM801=m
CONFIG_SND_FM801_TEA575X_BOOL=y
CONFIG_SND_FM801_TEA575X=m
CONFIG_SND_HDA_INTEL=m
CONFIG_SND_HDA_HWDEP=y
CONFIG_SND_HDA_RECONFIG=y
CONFIG_SND_HDA_INPUT_BEEP=y
CONFIG_SND_HDA_INPUT_BEEP_MODE=1
CONFIG_SND_HDA_INPUT_JACK=y
# CONFIG_SND_HDA_PATCH_LOADER is not set
CONFIG_SND_HDA_CODEC_REALTEK=y
CONFIG_SND_HDA_CODEC_ANALOG=y
CONFIG_SND_HDA_CODEC_SIGMATEL=y
CONFIG_SND_HDA_CODEC_VIA=y
CONFIG_SND_HDA_CODEC_HDMI=y
CONFIG_SND_HDA_CODEC_CIRRUS=y
CONFIG_SND_HDA_CODEC_CONEXANT=y
CONFIG_SND_HDA_CODEC_CA0110=y
CONFIG_SND_HDA_CODEC_CMEDIA=y
CONFIG_SND_HDA_CODEC_SI3054=y
CONFIG_SND_HDA_GENERIC=y
# CONFIG_SND_HDA_POWER_SAVE is not set
CONFIG_SND_HDSP=m
CONFIG_SND_HDSPM=m
CONFIG_SND_ICE1712=m
CONFIG_SND_ICE1724=m
CONFIG_SND_INTEL8X0=m
CONFIG_SND_INTEL8X0M=m
CONFIG_SND_KORG1212=m
CONFIG_SND_LX6464ES=m
CONFIG_SND_MAESTRO3=m
CONFIG_SND_MAESTRO3_INPUT=y
CONFIG_SND_MIXART=m
CONFIG_SND_NM256=m
CONFIG_SND_PCXHR=m
CONFIG_SND_RIPTIDE=m
CONFIG_SND_RME32=m
CONFIG_SND_RME96=m
CONFIG_SND_RME9652=m
CONFIG_SND_SIS7019=m
CONFIG_SND_SONICVIBES=m
CONFIG_SND_TRIDENT=m
CONFIG_SND_VIA82XX=m
CONFIG_SND_VIA82XX_MODEM=m
CONFIG_SND_VIRTUOSO=m
CONFIG_SND_VX222=m
CONFIG_SND_YMFPCI=m
CONFIG_SND_SPI=y
CONFIG_SND_USB=y
CONFIG_SND_USB_AUDIO=m
CONFIG_SND_USB_UA101=m
CONFIG_SND_USB_USX2Y=m
CONFIG_SND_USB_CAIAQ=m
CONFIG_SND_USB_CAIAQ_INPUT=y
CONFIG_SND_USB_US122L=m
CONFIG_SND_USB_6FIRE=m
CONFIG_SND_FIREWIRE=y
CONFIG_SND_FIREWIRE_LIB=m
CONFIG_SND_FIREWIRE_SPEAKERS=m
CONFIG_SND_PCMCIA=y
CONFIG_SND_VXPOCKET=m
CONFIG_SND_PDAUDIOCF=m
CONFIG_SND_SOC=m
# CONFIG_SND_SOC_CACHE_LZO is not set
CONFIG_SND_SOC_I2C_AND_SPI=m
CONFIG_SND_SOC_ALL_CODECS=m
CONFIG_SND_SOC_88PM860X=m
CONFIG_SND_SOC_WM_HUBS=m
CONFIG_SND_SOC_AD1836=m
CONFIG_SND_SOC_AD193X=m
CONFIG_SND_SOC_AD73311=m
CONFIG_SND_SOC_ADS117X=m
CONFIG_SND_SOC_AK4104=m
CONFIG_SND_SOC_AK4535=m
CONFIG_SND_SOC_AK4642=m
CONFIG_SND_SOC_AK4671=m
CONFIG_SND_SOC_ALC5623=m
CONFIG_SND_SOC_CS42L51=m
CONFIG_SND_SOC_CS4270=m
CONFIG_SND_SOC_CS4271=m
CONFIG_SND_SOC_CX20442=m
CONFIG_SND_SOC_L3=m
CONFIG_SND_SOC_DA7210=m
CONFIG_SND_SOC_DFBMCS320=m
CONFIG_SND_SOC_MAX98088=m
CONFIG_SND_SOC_MAX9850=m
CONFIG_SND_SOC_PCM3008=m
CONFIG_SND_SOC_SGTL5000=m
CONFIG_SND_SOC_SPDIF=m
CONFIG_SND_SOC_SSM2602=m
CONFIG_SND_SOC_TLV320AIC23=m
CONFIG_SND_SOC_TLV320AIC26=m
CONFIG_SND_SOC_TVL320AIC32X4=m
CONFIG_SND_SOC_TLV320AIC3X=m
CONFIG_SND_SOC_TLV320DAC33=m
CONFIG_SND_SOC_TWL4030=m
CONFIG_SND_SOC_TWL6040=m
CONFIG_SND_SOC_UDA134X=m
CONFIG_SND_SOC_UDA1380=m
CONFIG_SND_SOC_WL1273=m
CONFIG_SND_SOC_WM8350=m
CONFIG_SND_SOC_WM8400=m
CONFIG_SND_SOC_WM8510=m
CONFIG_SND_SOC_WM8523=m
CONFIG_SND_SOC_WM8580=m
CONFIG_SND_SOC_WM8711=m
CONFIG_SND_SOC_WM8727=m
CONFIG_SND_SOC_WM8728=m
CONFIG_SND_SOC_WM8731=m
CONFIG_SND_SOC_WM8737=m
CONFIG_SND_SOC_WM8741=m
CONFIG_SND_SOC_WM8750=m
CONFIG_SND_SOC_WM8753=m
CONFIG_SND_SOC_WM8770=m
CONFIG_SND_SOC_WM8776=m
CONFIG_SND_SOC_WM8804=m
CONFIG_SND_SOC_WM8900=m
CONFIG_SND_SOC_WM8903=m
CONFIG_SND_SOC_WM8904=m
CONFIG_SND_SOC_WM8940=m
CONFIG_SND_SOC_WM8955=m
CONFIG_SND_SOC_WM8960=m
CONFIG_SND_SOC_WM8961=m
CONFIG_SND_SOC_WM8962=m
CONFIG_SND_SOC_WM8971=m
CONFIG_SND_SOC_WM8974=m
CONFIG_SND_SOC_WM8978=m
CONFIG_SND_SOC_WM8985=m
CONFIG_SND_SOC_WM8988=m
CONFIG_SND_SOC_WM8990=m
CONFIG_SND_SOC_WM8991=m
CONFIG_SND_SOC_WM8993=m
CONFIG_SND_SOC_WM8994=m
CONFIG_SND_SOC_WM8995=m
CONFIG_SND_SOC_WM9081=m
CONFIG_SND_SOC_LM4857=m
CONFIG_SND_SOC_MAX9877=m
CONFIG_SND_SOC_TPA6130A2=m
CONFIG_SND_SOC_WM2000=m
CONFIG_SND_SOC_WM9090=m
CONFIG_SOUND_PRIME=m
# CONFIG_SOUND_MSNDCLAS is not set
# CONFIG_SOUND_MSNDPIN is not set
CONFIG_SOUND_OSS=m
CONFIG_SOUND_TRACEINIT=y
CONFIG_SOUND_DMAP=y
CONFIG_SOUND_VMIDI=m
CONFIG_SOUND_TRIX=m
CONFIG_SOUND_MSS=m
CONFIG_SOUND_MPU401=m
CONFIG_SOUND_PAS=m
CONFIG_SOUND_PSS=m
CONFIG_PSS_MIXER=y
CONFIG_SOUND_SB=m
CONFIG_SOUND_YM3812=m
CONFIG_SOUND_UART6850=m
CONFIG_SOUND_AEDSP16=m
CONFIG_SC6600=y
CONFIG_SC6600_JOY=y
CONFIG_SC6600_CDROM=4
CONFIG_SC6600_CDROMBASE=0
CONFIG_SOUND_KAHLUA=m
CONFIG_AC97_BUS=m
CONFIG_HID_SUPPORT=y
CONFIG_HID=y
CONFIG_HIDRAW=y

#
# USB Input Devices
#
CONFIG_USB_HID=y
CONFIG_HID_PID=y
CONFIG_USB_HIDDEV=y

#
# Special HID drivers
#
CONFIG_HID_3M_PCT=y
CONFIG_HID_A4TECH=y
CONFIG_HID_ACRUX=m
CONFIG_HID_ACRUX_FF=m
CONFIG_HID_APPLE=y
CONFIG_HID_BELKIN=y
CONFIG_HID_CANDO=y
CONFIG_HID_CHERRY=y
CONFIG_HID_CHICONY=y
CONFIG_HID_PRODIKEYS=m
CONFIG_HID_CYPRESS=y
CONFIG_HID_DRAGONRISE=y
CONFIG_DRAGONRISE_FF=y
CONFIG_HID_EMS_FF=m
CONFIG_HID_ELECOM=m
CONFIG_HID_EZKEY=y
CONFIG_HID_KEYTOUCH=y
CONFIG_HID_KYE=y
CONFIG_HID_UCLOGIC=y
CONFIG_HID_WALTOP=y
CONFIG_HID_GYRATION=y
CONFIG_HID_TWINHAN=y
CONFIG_HID_KENSINGTON=y
CONFIG_HID_LCPOWER=y
CONFIG_HID_LOGITECH=y
CONFIG_LOGITECH_FF=y
CONFIG_LOGIRUMBLEPAD2_FF=y
CONFIG_LOGIG940_FF=y
CONFIG_LOGIWII_FF=y
CONFIG_HID_MAGICMOUSE=m
CONFIG_HID_MICROSOFT=y
CONFIG_HID_MOSART=y
CONFIG_HID_MONTEREY=y
CONFIG_HID_MULTITOUCH=y
CONFIG_HID_NTRIG=y
CONFIG_HID_ORTEK=y
CONFIG_HID_PANTHERLORD=y
CONFIG_PANTHERLORD_FF=y
CONFIG_HID_PETALYNX=y
CONFIG_HID_PICOLCD=m
CONFIG_HID_PICOLCD_FB=y
CONFIG_HID_PICOLCD_BACKLIGHT=y
CONFIG_HID_PICOLCD_LCD=y
CONFIG_HID_PICOLCD_LEDS=y
CONFIG_HID_QUANTA=y
CONFIG_HID_ROCCAT=y
CONFIG_HID_ROCCAT_COMMON=y
CONFIG_HID_ROCCAT_ARVO=y
CONFIG_HID_ROCCAT_KONE=y
CONFIG_HID_ROCCAT_KONEPLUS=y
CONFIG_HID_ROCCAT_KOVAPLUS=y
CONFIG_HID_ROCCAT_PYRA=y
CONFIG_HID_SAMSUNG=y
CONFIG_HID_SONY=y
CONFIG_HID_STANTUM=y
CONFIG_HID_SUNPLUS=y
CONFIG_HID_GREENASIA=y
CONFIG_GREENASIA_FF=y
CONFIG_HID_SMARTJOYPLUS=y
CONFIG_SMARTJOYPLUS_FF=y
CONFIG_HID_TOPSEED=y
CONFIG_HID_THRUSTMASTER=y
CONFIG_THRUSTMASTER_FF=y
CONFIG_HID_WACOM=m
CONFIG_HID_WACOM_POWER_SUPPLY=y
CONFIG_HID_ZEROPLUS=y
CONFIG_ZEROPLUS_FF=y
CONFIG_HID_ZYDACRON=m
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB=y
# CONFIG_USB_DEBUG is not set
CONFIG_USB_ANNOUNCE_NEW_DEVICES=y

#
# Miscellaneous USB options
#
# CONFIG_USB_DEVICEFS is not set
CONFIG_USB_DEVICE_CLASS=y
CONFIG_USB_DYNAMIC_MINORS=y
# CONFIG_USB_SUSPEND is not set
# CONFIG_USB_OTG_WHITELIST is not set
# CONFIG_USB_OTG_BLACKLIST_HUB is not set
CONFIG_USB_MON=y
CONFIG_USB_WUSB=y
CONFIG_USB_WUSB_CBAF=y
# CONFIG_USB_WUSB_CBAF_DEBUG is not set

#
# USB Host Controller Drivers
#
CONFIG_USB_C67X00_HCD=y
CONFIG_USB_XHCI_HCD=y
# CONFIG_USB_XHCI_HCD_DEBUGGING is not set
CONFIG_USB_EHCI_HCD=y
CONFIG_USB_EHCI_ROOT_HUB_TT=y
CONFIG_USB_EHCI_TT_NEWSCHED=y
CONFIG_USB_OXU210HP_HCD=y
CONFIG_USB_ISP116X_HCD=y
CONFIG_USB_ISP1760_HCD=y
CONFIG_USB_ISP1362_HCD=y
CONFIG_USB_OHCI_HCD=y
# CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_UHCI_HCD=y
CONFIG_USB_U132_HCD=m
CONFIG_USB_SL811_HCD=y
CONFIG_USB_SL811_CS=y
CONFIG_USB_R8A66597_HCD=y
CONFIG_USB_WHCI_HCD=y
CONFIG_USB_HWA_HCD=y

#
# USB Device Class drivers
#
CONFIG_USB_ACM=y
CONFIG_USB_PRINTER=y
CONFIG_USB_WDM=y
CONFIG_USB_TMC=y

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
CONFIG_USB_STORAGE=y
# CONFIG_USB_STORAGE_DEBUG is not set
CONFIG_USB_STORAGE_REALTEK=y
CONFIG_USB_STORAGE_DATAFAB=y
CONFIG_USB_STORAGE_FREECOM=y
CONFIG_USB_STORAGE_ISD200=y
CONFIG_USB_STORAGE_USBAT=y
CONFIG_USB_STORAGE_SDDR09=y
CONFIG_USB_STORAGE_SDDR55=y
CONFIG_USB_STORAGE_JUMPSHOT=y
CONFIG_USB_STORAGE_ALAUDA=y
CONFIG_USB_STORAGE_ONETOUCH=y
CONFIG_USB_STORAGE_KARMA=y
CONFIG_USB_STORAGE_CYPRESS_ATACB=y
CONFIG_USB_STORAGE_ENE_UB6250=y
CONFIG_USB_UAS=y
CONFIG_USB_LIBUSUAL=y

#
# USB Imaging devices
#
CONFIG_USB_MDC800=m
CONFIG_USB_MICROTEK=m

#
# USB port drivers
#
CONFIG_USB_USS720=m
CONFIG_USB_SERIAL=m
CONFIG_USB_EZUSB=y
CONFIG_USB_SERIAL_GENERIC=y
CONFIG_USB_SERIAL_AIRCABLE=m
CONFIG_USB_SERIAL_ARK3116=m
CONFIG_USB_SERIAL_BELKIN=m
CONFIG_USB_SERIAL_CH341=m
CONFIG_USB_SERIAL_WHITEHEAT=m
CONFIG_USB_SERIAL_DIGI_ACCELEPORT=m
CONFIG_USB_SERIAL_CP210X=m
CONFIG_USB_SERIAL_CYPRESS_M8=m
CONFIG_USB_SERIAL_EMPEG=m
CONFIG_USB_SERIAL_FTDI_SIO=m
CONFIG_USB_SERIAL_FUNSOFT=m
CONFIG_USB_SERIAL_VISOR=m
CONFIG_USB_SERIAL_IPAQ=m
CONFIG_USB_SERIAL_IR=m
CONFIG_USB_SERIAL_EDGEPORT=m
CONFIG_USB_SERIAL_EDGEPORT_TI=m
CONFIG_USB_SERIAL_GARMIN=m
CONFIG_USB_SERIAL_IPW=m
CONFIG_USB_SERIAL_IUU=m
CONFIG_USB_SERIAL_KEYSPAN_PDA=m
CONFIG_USB_SERIAL_KEYSPAN=m
CONFIG_USB_SERIAL_KLSI=m
CONFIG_USB_SERIAL_KOBIL_SCT=m
CONFIG_USB_SERIAL_MCT_U232=m
CONFIG_USB_SERIAL_MOS7720=m
CONFIG_USB_SERIAL_MOS7715_PARPORT=y
CONFIG_USB_SERIAL_MOS7840=m
CONFIG_USB_SERIAL_MOTOROLA=m
CONFIG_USB_SERIAL_NAVMAN=m
CONFIG_USB_SERIAL_PL2303=m
CONFIG_USB_SERIAL_OTI6858=m
CONFIG_USB_SERIAL_QCAUX=m
CONFIG_USB_SERIAL_QUALCOMM=m
CONFIG_USB_SERIAL_SPCP8X5=m
CONFIG_USB_SERIAL_HP4X=m
CONFIG_USB_SERIAL_SAFE=m
CONFIG_USB_SERIAL_SAFE_PADDED=y
CONFIG_USB_SERIAL_SAMBA=m
CONFIG_USB_SERIAL_SIEMENS_MPI=m
CONFIG_USB_SERIAL_SIERRAWIRELESS=m
CONFIG_USB_SERIAL_SYMBOL=m
CONFIG_USB_SERIAL_TI=m
CONFIG_USB_SERIAL_CYBERJACK=m
CONFIG_USB_SERIAL_XIRCOM=m
CONFIG_USB_SERIAL_WWAN=m
CONFIG_USB_SERIAL_OPTION=m
CONFIG_USB_SERIAL_OMNINET=m
CONFIG_USB_SERIAL_OPTICON=m
CONFIG_USB_SERIAL_VIVOPAY_SERIAL=m
CONFIG_USB_SERIAL_ZIO=m
CONFIG_USB_SERIAL_SSU100=m
CONFIG_USB_SERIAL_DEBUG=m

#
# USB Miscellaneous drivers
#
CONFIG_USB_EMI62=m
CONFIG_USB_EMI26=m
CONFIG_USB_ADUTUX=m
CONFIG_USB_SEVSEG=m
CONFIG_USB_RIO500=m
CONFIG_USB_LEGOTOWER=m
CONFIG_USB_LCD=m
CONFIG_USB_LED=m
CONFIG_USB_CYPRESS_CY7C63=m
CONFIG_USB_CYTHERM=m
CONFIG_USB_IDMOUSE=m
CONFIG_USB_FTDI_ELAN=m
CONFIG_USB_APPLEDISPLAY=m
CONFIG_USB_SISUSBVGA=m
CONFIG_USB_SISUSBVGA_CON=y
CONFIG_USB_LD=m
CONFIG_USB_TRANCEVIBRATOR=m
CONFIG_USB_IOWARRIOR=m
# CONFIG_USB_TEST is not set
CONFIG_USB_ISIGHTFW=m
CONFIG_USB_YUREX=m
CONFIG_USB_ATM=m
CONFIG_USB_SPEEDTOUCH=m
CONFIG_USB_CXACRU=m
CONFIG_USB_UEAGLEATM=m
CONFIG_USB_XUSBATM=m
CONFIG_USB_GADGET=m
# CONFIG_USB_GADGET_DEBUG_FILES is not set
# CONFIG_USB_GADGET_DEBUG_FS is not set
CONFIG_USB_GADGET_VBUS_DRAW=2
CONFIG_USB_GADGET_SELECTED=y
# CONFIG_USB_GADGET_FUSB300 is not set
# CONFIG_USB_GADGET_R8A66597 is not set
# CONFIG_USB_GADGET_PXA_U2O is not set
# CONFIG_USB_GADGET_M66592 is not set
# CONFIG_USB_GADGET_AMD5536UDC is not set
CONFIG_USB_GADGET_CI13XXX_PCI=y
CONFIG_USB_CI13XXX_PCI=m
# CONFIG_USB_GADGET_NET2280 is not set
# CONFIG_USB_GADGET_GOKU is not set
# CONFIG_USB_GADGET_LANGWELL is not set
# CONFIG_USB_GADGET_EG20T is not set
# CONFIG_USB_GADGET_DUMMY_HCD is not set
CONFIG_USB_GADGET_DUALSPEED=y
CONFIG_USB_ZERO=m
CONFIG_USB_AUDIO=m
CONFIG_USB_ETH=m
CONFIG_USB_ETH_RNDIS=y
CONFIG_USB_ETH_EEM=y
CONFIG_USB_G_NCM=m
CONFIG_USB_GADGETFS=m
CONFIG_USB_FUNCTIONFS=m
CONFIG_USB_FUNCTIONFS_ETH=y
CONFIG_USB_FUNCTIONFS_RNDIS=y
CONFIG_USB_FUNCTIONFS_GENERIC=y
CONFIG_USB_FILE_STORAGE=m
CONFIG_USB_FILE_STORAGE_TEST=y
CONFIG_USB_MASS_STORAGE=m
CONFIG_USB_G_SERIAL=m
CONFIG_USB_MIDI_GADGET=m
CONFIG_USB_G_PRINTER=m
CONFIG_USB_CDC_COMPOSITE=m
CONFIG_USB_G_NOKIA=m
CONFIG_USB_G_MULTI=m
CONFIG_USB_G_MULTI_RNDIS=y
CONFIG_USB_G_MULTI_CDC=y
CONFIG_USB_G_HID=m
CONFIG_USB_G_DBGP=m
CONFIG_USB_G_DBGP_PRINTK=y
# CONFIG_USB_G_DBGP_SERIAL is not set
CONFIG_USB_G_WEBCAM=m

#
# OTG and related infrastructure
#
CONFIG_USB_OTG_UTILS=y
CONFIG_USB_GPIO_VBUS=m
CONFIG_TWL4030_USB=m
CONFIG_TWL6030_USB=m
CONFIG_NOP_USB_XCEIV=m
CONFIG_AB8500_USB=m
CONFIG_UWB=y
CONFIG_UWB_HWA=y
CONFIG_UWB_WHCI=y
CONFIG_UWB_I1480U=m
CONFIG_MMC=y
# CONFIG_MMC_DEBUG is not set
# CONFIG_MMC_UNSAFE_RESUME is not set
# CONFIG_MMC_CLKGATE is not set

#
# MMC/SD/SDIO Card Drivers
#
CONFIG_MMC_BLOCK=y
CONFIG_MMC_BLOCK_MINORS=8
CONFIG_MMC_BLOCK_BOUNCE=y
CONFIG_SDIO_UART=y
CONFIG_MMC_TEST=y

#
# MMC/SD/SDIO Host Controller Drivers
#
CONFIG_MMC_SDHCI=y
CONFIG_MMC_SDHCI_PCI=y
CONFIG_MMC_RICOH_MMC=y
CONFIG_MMC_SDHCI_OF=y
CONFIG_MMC_SDHCI_PLTFM=y
CONFIG_MMC_WBSD=y
CONFIG_MMC_TIFM_SD=y
CONFIG_MMC_SDRICOH_CS=y
CONFIG_MMC_CB710=y
CONFIG_MMC_VIA_SDMMC=y
CONFIG_MMC_USHC=y
CONFIG_MEMSTICK=y
# CONFIG_MEMSTICK_DEBUG is not set

#
# MemoryStick drivers
#
# CONFIG_MEMSTICK_UNSAFE_RESUME is not set
CONFIG_MSPRO_BLOCK=y

#
# MemoryStick Host Controller Drivers
#
CONFIG_MEMSTICK_TIFM_MS=y
CONFIG_MEMSTICK_JMICRON_38X=y
CONFIG_MEMSTICK_R592=y
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
CONFIG_LEDS_88PM860X=m
CONFIG_LEDS_LM3530=m
CONFIG_LEDS_NET48XX=m
CONFIG_LEDS_NET5501=m
CONFIG_LEDS_WRAP=m
CONFIG_LEDS_ALIX2=m
CONFIG_LEDS_PCA9532=m
CONFIG_LEDS_GPIO=m
CONFIG_LEDS_GPIO_PLATFORM=y
CONFIG_LEDS_GPIO_OF=y
CONFIG_LEDS_LP3944=m
CONFIG_LEDS_LP5521=m
CONFIG_LEDS_LP5523=m
CONFIG_LEDS_CLEVO_MAIL=m
CONFIG_LEDS_PCA955X=m
CONFIG_LEDS_WM831X_STATUS=m
CONFIG_LEDS_WM8350=m
CONFIG_LEDS_DA903X=m
CONFIG_LEDS_DAC124S085=m
CONFIG_LEDS_REGULATOR=m
CONFIG_LEDS_BD2802=m
CONFIG_LEDS_INTEL_SS4200=m
CONFIG_LEDS_LT3593=m
CONFIG_LEDS_ADP5520=m
CONFIG_LEDS_DELL_NETBOOKS=m
CONFIG_LEDS_MC13783=m
CONFIG_LEDS_TRIGGERS=y

#
# LED Triggers
#
CONFIG_LEDS_TRIGGER_TIMER=m
CONFIG_LEDS_TRIGGER_HEARTBEAT=m
CONFIG_LEDS_TRIGGER_BACKLIGHT=m
CONFIG_LEDS_TRIGGER_GPIO=m
CONFIG_LEDS_TRIGGER_DEFAULT_ON=m

#
# iptables trigger is under Netfilter config (LED target)
#
CONFIG_NFC_DEVICES=y
CONFIG_PN544_NFC=m
CONFIG_ACCESSIBILITY=y
CONFIG_A11Y_BRAILLE_CONSOLE=y
CONFIG_INFINIBAND=m
CONFIG_INFINIBAND_USER_MAD=m
CONFIG_INFINIBAND_USER_ACCESS=m
CONFIG_INFINIBAND_USER_MEM=y
CONFIG_INFINIBAND_ADDR_TRANS=y
CONFIG_INFINIBAND_MTHCA=m
CONFIG_INFINIBAND_MTHCA_DEBUG=y
CONFIG_INFINIBAND_AMSO1100=m
# CONFIG_INFINIBAND_AMSO1100_DEBUG is not set
CONFIG_INFINIBAND_CXGB3=m
# CONFIG_INFINIBAND_CXGB3_DEBUG is not set
CONFIG_INFINIBAND_CXGB4=m
CONFIG_MLX4_INFINIBAND=m
CONFIG_INFINIBAND_NES=m
# CONFIG_INFINIBAND_NES_DEBUG is not set
CONFIG_INFINIBAND_IPOIB=m
CONFIG_INFINIBAND_IPOIB_CM=y
# CONFIG_INFINIBAND_IPOIB_DEBUG is not set
CONFIG_INFINIBAND_SRP=m
CONFIG_INFINIBAND_ISER=m
CONFIG_EDAC=y

#
# Reporting subsystems
#
# CONFIG_EDAC_DEBUG is not set
CONFIG_EDAC_DECODE_MCE=y
CONFIG_EDAC_MCE_INJ=m
CONFIG_EDAC_MM_EDAC=y
CONFIG_EDAC_MCE=y
CONFIG_EDAC_AMD76X=m
CONFIG_EDAC_E7XXX=m
CONFIG_EDAC_E752X=m
CONFIG_EDAC_I82875P=m
CONFIG_EDAC_I82975X=m
CONFIG_EDAC_I3000=m
CONFIG_EDAC_I3200=m
CONFIG_EDAC_X38=m
CONFIG_EDAC_I5400=m
CONFIG_EDAC_I7CORE=m
CONFIG_EDAC_I82860=m
CONFIG_EDAC_R82600=m
CONFIG_EDAC_I5000=m
CONFIG_EDAC_I5100=m
CONFIG_EDAC_I7300=m
CONFIG_RTC_LIB=m
CONFIG_RTC_CLASS=m

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
CONFIG_RTC_INTF_PROC=y
CONFIG_RTC_INTF_DEV=y
# CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
CONFIG_RTC_DRV_TEST=m

#
# I2C RTC drivers
#
CONFIG_RTC_DRV_DS1307=m
CONFIG_RTC_DRV_DS1374=m
CONFIG_RTC_DRV_DS1672=m
CONFIG_RTC_DRV_DS3232=m
CONFIG_RTC_DRV_MAX6900=m
CONFIG_RTC_DRV_MAX8925=m
CONFIG_RTC_DRV_MAX8998=m
CONFIG_RTC_DRV_RS5C372=m
CONFIG_RTC_DRV_ISL1208=m
CONFIG_RTC_DRV_ISL12022=m
CONFIG_RTC_DRV_X1205=m
CONFIG_RTC_DRV_PCF8563=m
CONFIG_RTC_DRV_PCF8583=m
CONFIG_RTC_DRV_M41T80=m
CONFIG_RTC_DRV_M41T80_WDT=y
CONFIG_RTC_DRV_BQ32K=m
CONFIG_RTC_DRV_TWL4030=m
CONFIG_RTC_DRV_S35390A=m
CONFIG_RTC_DRV_FM3130=m
CONFIG_RTC_DRV_RX8581=m
CONFIG_RTC_DRV_RX8025=m

#
# SPI RTC drivers
#
CONFIG_RTC_DRV_M41T94=m
CONFIG_RTC_DRV_DS1305=m
CONFIG_RTC_DRV_DS1390=m
CONFIG_RTC_DRV_MAX6902=m
CONFIG_RTC_DRV_R9701=m
CONFIG_RTC_DRV_RS5C348=m
CONFIG_RTC_DRV_DS3234=m
CONFIG_RTC_DRV_PCF2123=m

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=m
CONFIG_RTC_DRV_DS1286=m
CONFIG_RTC_DRV_DS1511=m
CONFIG_RTC_DRV_DS1553=m
CONFIG_RTC_DRV_DS1742=m
CONFIG_RTC_DRV_STK17TA8=m
CONFIG_RTC_DRV_M48T86=m
CONFIG_RTC_DRV_M48T35=m
CONFIG_RTC_DRV_M48T59=m
CONFIG_RTC_DRV_MSM6242=m
CONFIG_RTC_DRV_BQ4802=m
CONFIG_RTC_DRV_RP5C01=m
CONFIG_RTC_DRV_V3020=m
CONFIG_RTC_DRV_WM831X=m
CONFIG_RTC_DRV_WM8350=m
CONFIG_RTC_DRV_PCF50633=m
CONFIG_RTC_DRV_AB3100=m
CONFIG_RTC_DRV_AB8500=m

#
# on-CPU RTC drivers
#
CONFIG_RTC_DRV_PCAP=m
CONFIG_RTC_DRV_MC13XXX=m
CONFIG_DMADEVICES=y
# CONFIG_DMADEVICES_DEBUG is not set

#
# DMA Devices
#
CONFIG_INTEL_MID_DMAC=y
CONFIG_INTEL_IOATDMA=y
CONFIG_TIMB_DMA=y
CONFIG_PCH_DMA=y
CONFIG_DMA_ENGINE=y

#
# DMA Clients
#
CONFIG_NET_DMA=y
CONFIG_ASYNC_TX_DMA=y
# CONFIG_DMATEST is not set
CONFIG_DCA=y
CONFIG_AUXDISPLAY=y
CONFIG_KS0108=m
CONFIG_KS0108_PORT=0x378
CONFIG_KS0108_DELAY=2
CONFIG_CFAG12864B=m
CONFIG_CFAG12864B_RATE=20
CONFIG_UIO=y
CONFIG_UIO_CIF=m
CONFIG_UIO_PDRV=m
CONFIG_UIO_PDRV_GENIRQ=m
CONFIG_UIO_AEC=m
CONFIG_UIO_SERCOS3=m
CONFIG_UIO_PCI_GENERIC=m
CONFIG_UIO_NETX=m
CONFIG_STAGING=y
# CONFIG_STAGING_EXCLUDE_BUILD is not set
CONFIG_STALLION=m
CONFIG_ISTALLION=m
CONFIG_DIGIEPCA=m
CONFIG_RISCOM8=m
CONFIG_SPECIALIX=m
CONFIG_COMPUTONE=m
CONFIG_ET131X=m
# CONFIG_ET131X_DEBUG is not set
CONFIG_SLICOSS=m
CONFIG_VIDEO_GO7007=m
CONFIG_VIDEO_GO7007_USB=m
CONFIG_VIDEO_GO7007_USB_S2250_BOARD=m
CONFIG_VIDEO_GO7007_OV7640=m
CONFIG_VIDEO_GO7007_SAA7113=m
CONFIG_VIDEO_GO7007_SAA7115=m
CONFIG_VIDEO_GO7007_TW9903=m
CONFIG_VIDEO_GO7007_UDA1342=m
CONFIG_VIDEO_GO7007_SONY_TUNER=m
CONFIG_VIDEO_GO7007_TW2804=m
CONFIG_VIDEO_CX25821=m
CONFIG_VIDEO_CX25821_ALSA=m
CONFIG_VIDEO_TM6000=m
CONFIG_VIDEO_TM6000_ALSA=m
CONFIG_VIDEO_TM6000_DVB=m
CONFIG_DVB_CXD2099=m
CONFIG_USB_IP_COMMON=m
CONFIG_USB_IP_VHCI_HCD=m
CONFIG_USB_IP_HOST=m
# CONFIG_USB_IP_DEBUG_ENABLE is not set
CONFIG_W35UND=m
CONFIG_PRISM2_USB=m
CONFIG_ECHO=m
CONFIG_BRCM80211=m
CONFIG_BRCMSMAC=y
CONFIG_BRCMFMAC=y
CONFIG_BRCMDBG=y
CONFIG_RT2860=m
CONFIG_RT2870=m
CONFIG_COMEDI=m
# CONFIG_COMEDI_DEBUG is not set
CONFIG_COMEDI_MISC_DRIVERS=m
CONFIG_COMEDI_KCOMEDILIB=m
CONFIG_COMEDI_BOND=m
CONFIG_COMEDI_TEST=m
CONFIG_COMEDI_PARPORT=m
CONFIG_COMEDI_SERIAL2002=m
CONFIG_COMEDI_SKEL=m
CONFIG_COMEDI_ISA_DRIVERS=m
CONFIG_COMEDI_ACL7225B=m
CONFIG_COMEDI_PCL711=m
CONFIG_COMEDI_PCL724=m
CONFIG_COMEDI_PCL725=m
CONFIG_COMEDI_PCL726=m
CONFIG_COMEDI_PCL730=m
CONFIG_COMEDI_PCL812=m
CONFIG_COMEDI_PCL816=m
CONFIG_COMEDI_PCL818=m
CONFIG_COMEDI_PCM3724=m
CONFIG_COMEDI_PCM3730=m
CONFIG_COMEDI_RTI800=m
CONFIG_COMEDI_RTI802=m
CONFIG_COMEDI_DAS16M1=m
CONFIG_COMEDI_DAS16=m
CONFIG_COMEDI_DAS800=m
CONFIG_COMEDI_DAS1800=m
CONFIG_COMEDI_DAS6402=m
CONFIG_COMEDI_DT2801=m
CONFIG_COMEDI_DT2811=m
CONFIG_COMEDI_DT2814=m
CONFIG_COMEDI_DT2815=m
CONFIG_COMEDI_DT2817=m
CONFIG_COMEDI_DT282X=m
CONFIG_COMEDI_DMM32AT=m
CONFIG_COMEDI_FL512=m
CONFIG_COMEDI_AIO_AIO12_8=m
CONFIG_COMEDI_AIO_IIRO_16=m
CONFIG_COMEDI_C6XDIGIO=m
CONFIG_COMEDI_MPC624=m
CONFIG_COMEDI_ADQ12B=m
CONFIG_COMEDI_NI_AT_A2150=m
CONFIG_COMEDI_NI_AT_AO=m
CONFIG_COMEDI_NI_ATMIO=m
CONFIG_COMEDI_NI_ATMIO16D=m
CONFIG_COMEDI_PCMAD=m
CONFIG_COMEDI_PCMDA12=m
CONFIG_COMEDI_PCMMIO=m
CONFIG_COMEDI_PCMUIO=m
CONFIG_COMEDI_MULTIQ3=m
CONFIG_COMEDI_POC=m
CONFIG_COMEDI_PCI_DRIVERS=m
CONFIG_COMEDI_ADDI_APCI_035=m
CONFIG_COMEDI_ADDI_APCI_1032=m
CONFIG_COMEDI_ADDI_APCI_1500=m
CONFIG_COMEDI_ADDI_APCI_1516=m
CONFIG_COMEDI_ADDI_APCI_1564=m
CONFIG_COMEDI_ADDI_APCI_16XX=m
CONFIG_COMEDI_ADDI_APCI_2016=m
CONFIG_COMEDI_ADDI_APCI_2032=m
CONFIG_COMEDI_ADDI_APCI_2200=m
CONFIG_COMEDI_ADDI_APCI_3001=m
CONFIG_COMEDI_ADDI_APCI_3120=m
CONFIG_COMEDI_ADDI_APCI_3501=m
CONFIG_COMEDI_ADDI_APCI_3XXX=m
CONFIG_COMEDI_ADL_PCI6208=m
CONFIG_COMEDI_ADL_PCI7230=m
CONFIG_COMEDI_ADL_PCI7296=m
CONFIG_COMEDI_ADL_PCI7432=m
CONFIG_COMEDI_ADL_PCI8164=m
CONFIG_COMEDI_ADL_PCI9111=m
CONFIG_COMEDI_ADL_PCI9118=m
CONFIG_COMEDI_ADV_PCI1710=m
CONFIG_COMEDI_ADV_PCI1723=m
CONFIG_COMEDI_ADV_PCI_DIO=m
CONFIG_COMEDI_AMPLC_DIO200=m
CONFIG_COMEDI_AMPLC_PC236=m
CONFIG_COMEDI_AMPLC_PC263=m
CONFIG_COMEDI_AMPLC_PCI224=m
CONFIG_COMEDI_AMPLC_PCI230=m
CONFIG_COMEDI_CONTEC_PCI_DIO=m
CONFIG_COMEDI_DT3000=m
CONFIG_COMEDI_UNIOXX5=m
CONFIG_COMEDI_GSC_HPDI=m
CONFIG_COMEDI_ICP_MULTI=m
CONFIG_COMEDI_II_PCI20KC=m
CONFIG_COMEDI_DAQBOARD2000=m
CONFIG_COMEDI_JR3_PCI=m
CONFIG_COMEDI_KE_COUNTER=m
CONFIG_COMEDI_CB_PCIDAS64=m
CONFIG_COMEDI_CB_PCIDAS=m
CONFIG_COMEDI_CB_PCIDDA=m
CONFIG_COMEDI_CB_PCIDIO=m
CONFIG_COMEDI_CB_PCIMDAS=m
CONFIG_COMEDI_CB_PCIMDDA=m
CONFIG_COMEDI_ME4000=m
CONFIG_COMEDI_ME_DAQ=m
CONFIG_COMEDI_NI_6527=m
CONFIG_COMEDI_NI_65XX=m
CONFIG_COMEDI_NI_660X=m
CONFIG_COMEDI_NI_670X=m
CONFIG_COMEDI_NI_PCIDIO=m
CONFIG_COMEDI_NI_PCIMIO=m
CONFIG_COMEDI_RTD520=m
CONFIG_COMEDI_S526=m
CONFIG_COMEDI_S626=m
CONFIG_COMEDI_SSV_DNP=m
CONFIG_COMEDI_PCMCIA_DRIVERS=m
CONFIG_COMEDI_CB_DAS16_CS=m
CONFIG_COMEDI_DAS08_CS=m
CONFIG_COMEDI_NI_DAQ_700_CS=m
CONFIG_COMEDI_NI_DAQ_DIO24_CS=m
CONFIG_COMEDI_NI_LABPC_CS=m
CONFIG_COMEDI_NI_MIO_CS=m
CONFIG_COMEDI_QUATECH_DAQP_CS=m
CONFIG_COMEDI_USB_DRIVERS=m
CONFIG_COMEDI_DT9812=m
CONFIG_COMEDI_USBDUX=m
CONFIG_COMEDI_USBDUXFAST=m
CONFIG_COMEDI_VMK80XX=m
CONFIG_COMEDI_NI_COMMON=m
CONFIG_COMEDI_MITE=m
CONFIG_COMEDI_NI_TIO=m
CONFIG_COMEDI_NI_LABPC=m
CONFIG_COMEDI_8255=m
CONFIG_COMEDI_DAS08=m
CONFIG_COMEDI_FC=m
CONFIG_FB_OLPC_DCON=m
CONFIG_FB_OLPC_DCON_1=y
CONFIG_FB_OLPC_DCON_1_5=y
CONFIG_ASUS_OLED=m
CONFIG_PANEL=m
CONFIG_PANEL_PARPORT=0
CONFIG_PANEL_PROFILE=5
# CONFIG_PANEL_CHANGE_MESSAGE is not set
CONFIG_R8187SE=m
CONFIG_RTL8192U=m
CONFIG_RTL8192E=m
CONFIG_R8712U=m
CONFIG_R8712_AP=y
CONFIG_RTS_PSTOR=m
# CONFIG_RTS_PSTOR_DEBUG is not set
CONFIG_TRANZPORT=m
CONFIG_POHMELFS=m
# CONFIG_POHMELFS_DEBUG is not set
CONFIG_POHMELFS_CRYPTO=y
CONFIG_IDE_PHISON=m
CONFIG_LINE6_USB=m
CONFIG_LINE6_USB_DEBUG=y
CONFIG_LINE6_USB_DUMP_CTRL=y
CONFIG_LINE6_USB_DUMP_MIDI=y
CONFIG_LINE6_USB_DUMP_PCM=y
CONFIG_LINE6_USB_RAW=y
CONFIG_LINE6_USB_IMPULSE_RESPONSE=y
CONFIG_DRM_VMWGFX=m
CONFIG_DRM_NOUVEAU=m
CONFIG_DRM_NOUVEAU_BACKLIGHT=y
CONFIG_DRM_NOUVEAU_DEBUG=y

#
# I2C encoder or helper chips
#
CONFIG_DRM_I2C_CH7006=m
CONFIG_DRM_I2C_SIL164=m
CONFIG_USB_SERIAL_QUATECH2=m
CONFIG_USB_SERIAL_QUATECH_USB2=m
CONFIG_VT6655=m
CONFIG_VT6656=m
# CONFIG_HYPERV is not set
CONFIG_VME_BUS=m

#
# VME Bridge Drivers
#
CONFIG_VME_CA91CX42=m
CONFIG_VME_TSI148=m

#
# VME Device Drivers
#
CONFIG_VME_USER=m

#
# VME Board Drivers
#
CONFIG_VMIVME_7805=m
CONFIG_DX_SEP=m
CONFIG_IIO=m
CONFIG_IIO_RING_BUFFER=y
CONFIG_IIO_SW_RING=m
CONFIG_IIO_KFIFO_BUF=m
CONFIG_IIO_TRIGGER=y

#
# Accelerometers
#
CONFIG_ADIS16201=m
CONFIG_ADIS16203=m
CONFIG_ADIS16204=m
CONFIG_ADIS16209=m
CONFIG_ADIS16220=m
CONFIG_ADIS16240=m
CONFIG_KXSD9=m
CONFIG_LIS3L02DQ=m
CONFIG_LIS3L02DQ_BUF_KFIFO=y
# CONFIG_LIS3L02DQ_BUF_RING_SW is not set
CONFIG_SCA3000=m

#
# Analog to digital convertors
#
CONFIG_MAX1363=m
CONFIG_MAX1363_RING_BUFFER=y
CONFIG_AD7150=m
CONFIG_AD7152=m
CONFIG_AD7291=m
CONFIG_AD7298=m
CONFIG_AD7314=m
CONFIG_AD7606=m
CONFIG_AD7606_IFACE_PARALLEL=m
CONFIG_AD7606_IFACE_SPI=m
CONFIG_AD799X=m
CONFIG_AD799X_RING_BUFFER=y
CONFIG_AD7476=m
CONFIG_AD7887=m
CONFIG_AD7745=m
CONFIG_AD7816=m
CONFIG_ADT75=m
CONFIG_ADT7310=m
CONFIG_ADT7410=m

#
# Analog digital bi-direction convertors
#
CONFIG_ADT7316=m
CONFIG_ADT7316_SPI=m
CONFIG_ADT7316_I2C=m

#
# Digital to analog convertors
#
CONFIG_AD5624R_SPI=m
CONFIG_AD5446=m
CONFIG_MAX517=m

#
# Direct Digital Synthesis
#
CONFIG_AD5930=m
CONFIG_AD9832=m
CONFIG_AD9834=m
CONFIG_AD9850=m
CONFIG_AD9852=m
CONFIG_AD9910=m
CONFIG_AD9951=m

#
# Digital gyroscope sensors
#
CONFIG_ADIS16060=m
CONFIG_ADIS16080=m
CONFIG_ADIS16130=m
CONFIG_ADIS16260=m

#
# Inertial measurement units
#
CONFIG_ADIS16300=m
CONFIG_ADIS16350=m
CONFIG_ADIS16400=m

#
# Light sensors
#
CONFIG_SENSORS_TSL2563=m
CONFIG_SENSORS_ISL29018=m

#
# Magnetometer sensors
#
CONFIG_SENSORS_AK8975=m
CONFIG_SENSORS_HMC5843=m

#
# Active energy metering IC
#
CONFIG_ADE7753=m
CONFIG_ADE7754=m
CONFIG_ADE7758=m
CONFIG_ADE7759=m
CONFIG_ADE7854=m
CONFIG_ADE7854_I2C=m
CONFIG_ADE7854_SPI=m

#
# Resolver to digital converters
#
CONFIG_AD2S90=m
CONFIG_AD2S120X=m
CONFIG_AD2S1210=m
# CONFIG_AD2S1210_GPIO_INPUT is not set
# CONFIG_AD2S1210_GPIO_OUTPUT is not set
CONFIG_AD2S1210_GPIO_NONE=y

#
# Triggers - standalone
#
CONFIG_IIO_PERIODIC_RTC_TRIGGER=m
CONFIG_IIO_GPIO_TRIGGER=m
CONFIG_IIO_SYSFS_TRIGGER=m
CONFIG_CS5535_GPIO=m
CONFIG_XVMALLOC=y
CONFIG_ZRAM=m
# CONFIG_ZRAM_DEBUG is not set
CONFIG_WLAGS49_H2=m
CONFIG_WLAGS49_H25=m
CONFIG_FB_SM7XX=y
CONFIG_VIDEO_DT3155=m
CONFIG_DT3155_CCIR=y
CONFIG_CRYSTALHD=m
CONFIG_CXT1E1=m
CONFIG_SBE_PMCC4_NCOMM=y
CONFIG_FB_XGI=y
CONFIG_LIRC_STAGING=y
CONFIG_LIRC_BT829=m
CONFIG_LIRC_IGORPLUGUSB=m
CONFIG_LIRC_IMON=m
CONFIG_LIRC_PARALLEL=m
CONFIG_LIRC_SASEM=m
CONFIG_LIRC_SERIAL=m
CONFIG_LIRC_SERIAL_TRANSMITTER=y
CONFIG_LIRC_SIR=m
CONFIG_LIRC_TTUSBIR=m
CONFIG_LIRC_ZILOG=m
CONFIG_EASYCAP=m
CONFIG_EASYCAP_SND=y
# CONFIG_EASYCAP_OSS is not set
# CONFIG_EASYCAP_DEBUG is not set
CONFIG_SOLO6X10=m
CONFIG_ACPI_QUICKSTART=y
CONFIG_MACH_NO_WESTBRIDGE=y
CONFIG_SBE_2T3E3=m
CONFIG_ATH6K_LEGACY=m
CONFIG_AR600x_SD31_XXX=y
# CONFIG_AR600x_WB31_XXX is not set
# CONFIG_AR600x_SD32_XXX is not set
# CONFIG_AR600x_CUSTOM_XXX is not set
CONFIG_ATH6KL_ENABLE_COEXISTENCE=y
CONFIG_AR600x_DUAL_ANTENNA=y
# CONFIG_AR600x_SINGLE_ANTENNA is not set
# CONFIG_AR600x_BT_QCOM is not set
# CONFIG_AR600x_BT_CSR is not set
CONFIG_AR600x_BT_AR3001=y
CONFIG_ATH6KL_HCI_BRIDGE=y
CONFIG_ATH6KL_CONFIG_GPIO_BT_RESET=y
CONFIG_AR600x_BT_RESET_PIN=22
CONFIG_ATH6KL_CFG80211=y
CONFIG_ATH6KL_HTC_RAW_INTERFACE=y
CONFIG_ATH6KL_VIRTUAL_SCATTER_GATHER=y
CONFIG_ATH6KL_SKIP_ABI_VERSION_CHECK=y
# CONFIG_ATH6KL_DEBUG is not set
CONFIG_USB_ENESTORAGE=m
CONFIG_BCM_WIMAX=m
CONFIG_FT1000=m
CONFIG_FT1000_USB=m
CONFIG_FT1000_PCMCIA=m

#
# Speakup console speech
#
CONFIG_SPEAKUP=m
CONFIG_SPEAKUP_SYNTH_ACNTSA=m
CONFIG_SPEAKUP_SYNTH_ACNTPC=m
CONFIG_SPEAKUP_SYNTH_APOLLO=m
CONFIG_SPEAKUP_SYNTH_AUDPTR=m
CONFIG_SPEAKUP_SYNTH_BNS=m
CONFIG_SPEAKUP_SYNTH_DECTLK=m
CONFIG_SPEAKUP_SYNTH_DECEXT=m
CONFIG_SPEAKUP_SYNTH_DECPC=m
CONFIG_SPEAKUP_SYNTH_DTLK=m
CONFIG_SPEAKUP_SYNTH_KEYPC=m
CONFIG_SPEAKUP_SYNTH_LTLK=m
CONFIG_SPEAKUP_SYNTH_SOFT=m
CONFIG_SPEAKUP_SYNTH_SPKOUT=m
CONFIG_SPEAKUP_SYNTH_TXPRT=m
CONFIG_SPEAKUP_SYNTH_DUMMY=m
CONFIG_TOUCHSCREEN_CLEARPAD_TM1217=m
CONFIG_TOUCHSCREEN_SYNAPTICS_I2C_RMI4=m
CONFIG_DRM_PSB=m

#
# Altera FPGA firmware download module
#
# CONFIG_ALTERA_STAPL is not set
CONFIG_X86_PLATFORM_DEVICES=y
CONFIG_ACER_WMI=y
CONFIG_ACERHDF=y
CONFIG_DELL_LAPTOP=m
CONFIG_DELL_WMI=y
CONFIG_DELL_WMI_AIO=y
CONFIG_FUJITSU_LAPTOP=y
# CONFIG_FUJITSU_LAPTOP_DEBUG is not set
CONFIG_TC1100_WMI=y
CONFIG_HP_ACCEL=y
CONFIG_HP_WMI=y
CONFIG_MSI_LAPTOP=y
CONFIG_PANASONIC_LAPTOP=y
CONFIG_COMPAL_LAPTOP=y
CONFIG_SONY_LAPTOP=y
CONFIG_SONYPI_COMPAT=y
CONFIG_IDEAPAD_LAPTOP=y
CONFIG_THINKPAD_ACPI=y
# CONFIG_THINKPAD_ACPI_DEBUGFACILITIES is not set
# CONFIG_THINKPAD_ACPI_DEBUG is not set
CONFIG_THINKPAD_ACPI_UNSAFE_LEDS=y
CONFIG_THINKPAD_ACPI_VIDEO=y
CONFIG_THINKPAD_ACPI_HOTKEY_POLL=y
CONFIG_SENSORS_HDAPS=y
CONFIG_INTEL_MENLOW=y
CONFIG_EEEPC_LAPTOP=y
CONFIG_ASUS_WMI=y
CONFIG_ASUS_NB_WMI=y
CONFIG_EEEPC_WMI=y
CONFIG_ACPI_WMI=y
CONFIG_MSI_WMI=y
CONFIG_ACPI_ASUS=y
CONFIG_TOPSTAR_LAPTOP=y
CONFIG_ACPI_TOSHIBA=y
CONFIG_TOSHIBA_BT_RFKILL=y
CONFIG_ACPI_CMPC=y
CONFIG_INTEL_IPS=y
CONFIG_IBM_RTL=y
CONFIG_XO1_RFKILL=y
CONFIG_XO15_EBOOK=y
CONFIG_SAMSUNG_LAPTOP=y

#
# Firmware Drivers
#
CONFIG_EDD=y
# CONFIG_EDD_OFF is not set
CONFIG_FIRMWARE_MEMMAP=y
# CONFIG_EFI_VARS is not set
CONFIG_DELL_RBU=m
CONFIG_DCDBAS=m
CONFIG_DMIID=y
CONFIG_DMI_SYSFS=y
CONFIG_ISCSI_IBFT_FIND=y
CONFIG_ISCSI_IBFT=y
# CONFIG_SIGMA is not set

#
# File systems
#
CONFIG_EXT2_FS=y
CONFIG_EXT2_FS_XATTR=y
CONFIG_EXT2_FS_POSIX_ACL=y
CONFIG_EXT2_FS_SECURITY=y
CONFIG_EXT2_FS_XIP=y
CONFIG_EXT3_FS=y
CONFIG_EXT3_DEFAULTS_TO_ORDERED=y
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
CONFIG_EXT3_FS_SECURITY=y
CONFIG_EXT4_FS=y
CONFIG_EXT4_FS_XATTR=y
CONFIG_EXT4_FS_POSIX_ACL=y
CONFIG_EXT4_FS_SECURITY=y
# CONFIG_EXT4_DEBUG is not set
CONFIG_FS_XIP=y
CONFIG_JBD=y
# CONFIG_JBD_DEBUG is not set
CONFIG_JBD2=y
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=y
CONFIG_REISERFS_FS=y
# CONFIG_REISERFS_CHECK is not set
# CONFIG_REISERFS_PROC_INFO is not set
CONFIG_REISERFS_FS_XATTR=y
CONFIG_REISERFS_FS_POSIX_ACL=y
CONFIG_REISERFS_FS_SECURITY=y
CONFIG_JFS_FS=y
CONFIG_JFS_POSIX_ACL=y
CONFIG_JFS_SECURITY=y
# CONFIG_JFS_DEBUG is not set
# CONFIG_JFS_STATISTICS is not set
CONFIG_XFS_FS=y
CONFIG_XFS_QUOTA=y
CONFIG_XFS_POSIX_ACL=y
CONFIG_XFS_RT=y
# CONFIG_XFS_DEBUG is not set
CONFIG_GFS2_FS=y
CONFIG_GFS2_FS_LOCKING_DLM=y
CONFIG_OCFS2_FS=y
CONFIG_OCFS2_FS_O2CB=y
CONFIG_OCFS2_FS_USERSPACE_CLUSTER=y
# CONFIG_OCFS2_FS_STATS is not set
CONFIG_OCFS2_DEBUG_MASKLOG=y
# CONFIG_OCFS2_DEBUG_FS is not set
CONFIG_BTRFS_FS=y
CONFIG_BTRFS_FS_POSIX_ACL=y
CONFIG_NILFS2_FS=y
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY_USER=y
CONFIG_FANOTIFY=y
# CONFIG_FANOTIFY_ACCESS_PERMISSIONS is not set
CONFIG_QUOTA=y
CONFIG_QUOTA_NETLINK_INTERFACE=y
# CONFIG_PRINT_QUOTA_WARNING is not set
# CONFIG_QUOTA_DEBUG is not set
CONFIG_QUOTA_TREE=y
CONFIG_QFMT_V1=y
CONFIG_QFMT_V2=y
CONFIG_QUOTACTL=y
CONFIG_AUTOFS4_FS=y
CONFIG_FUSE_FS=y
CONFIG_CUSE=y
CONFIG_GENERIC_ACL=y

#
# Caches
#
CONFIG_FSCACHE=y
CONFIG_FSCACHE_STATS=y
CONFIG_FSCACHE_HISTOGRAM=y
# CONFIG_FSCACHE_DEBUG is not set
# CONFIG_FSCACHE_OBJECT_LIST is not set
CONFIG_CACHEFILES=y
# CONFIG_CACHEFILES_DEBUG is not set
CONFIG_CACHEFILES_HISTOGRAM=y

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=y
CONFIG_JOLIET=y
CONFIG_ZISOFS=y
CONFIG_UDF_FS=y
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=y
CONFIG_MSDOS_FS=y
CONFIG_VFAT_FS=y
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
CONFIG_NTFS_FS=y
# CONFIG_NTFS_DEBUG is not set
CONFIG_NTFS_RW=y

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=y
CONFIG_MISC_FILESYSTEMS=y
CONFIG_ADFS_FS=y
CONFIG_ADFS_FS_RW=y
CONFIG_AFFS_FS=y
CONFIG_ECRYPT_FS=y
CONFIG_HFS_FS=y
CONFIG_HFSPLUS_FS=y
CONFIG_BEFS_FS=y
# CONFIG_BEFS_DEBUG is not set
CONFIG_BFS_FS=y
CONFIG_EFS_FS=y
# CONFIG_LOGFS is not set
CONFIG_CRAMFS=y
CONFIG_SQUASHFS=y
CONFIG_SQUASHFS_XATTR=y
# CONFIG_SQUASHFS_LZO is not set
# CONFIG_SQUASHFS_XZ is not set
CONFIG_SQUASHFS_EMBEDDED=y
CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3
CONFIG_VXFS_FS=y
CONFIG_MINIX_FS=y
CONFIG_OMFS_FS=y
CONFIG_HPFS_FS=y
CONFIG_QNX4FS_FS=y
CONFIG_ROMFS_FS=y
CONFIG_ROMFS_BACKED_BY_BLOCK=y
CONFIG_ROMFS_ON_BLOCK=y
CONFIG_PSTORE=y
CONFIG_SYSV_FS=y
CONFIG_UFS_FS=y
# CONFIG_UFS_FS_WRITE is not set
# CONFIG_UFS_DEBUG is not set
CONFIG_EXOFS_FS=y
# CONFIG_EXOFS_DEBUG is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=y
CONFIG_NFS_V3=y
CONFIG_NFS_V3_ACL=y
CONFIG_NFS_V4=y
CONFIG_NFS_V4_1=y
CONFIG_PNFS_FILE_LAYOUT=y
# CONFIG_ROOT_NFS is not set
CONFIG_NFS_FSCACHE=y
CONFIG_NFS_USE_LEGACY_DNS=y
CONFIG_NFS_USE_NEW_IDMAPPER=y
CONFIG_NFSD=y
CONFIG_NFSD_DEPRECATED=y
CONFIG_NFSD_V2_ACL=y
CONFIG_NFSD_V3=y
CONFIG_NFSD_V3_ACL=y
CONFIG_NFSD_V4=y
CONFIG_LOCKD=y
CONFIG_LOCKD_V4=y
CONFIG_NFS_ACL_SUPPORT=y
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=y
CONFIG_SUNRPC_GSS=y
CONFIG_SUNRPC_XPRT_RDMA=m
CONFIG_RPCSEC_GSS_KRB5=m
CONFIG_CEPH_FS=y
CONFIG_CIFS=y
CONFIG_CIFS_STATS=y
CONFIG_CIFS_STATS2=y
CONFIG_CIFS_WEAK_PW_HASH=y
CONFIG_CIFS_UPCALL=y
CONFIG_CIFS_XATTR=y
CONFIG_CIFS_POSIX=y
# CONFIG_CIFS_DEBUG2 is not set
CONFIG_CIFS_DFS_UPCALL=y
CONFIG_CIFS_FSCACHE=y
CONFIG_CIFS_ACL=y
CONFIG_CIFS_EXPERIMENTAL=y
CONFIG_NCP_FS=y
CONFIG_NCPFS_PACKET_SIGNING=y
CONFIG_NCPFS_IOCTL_LOCKING=y
CONFIG_NCPFS_STRONG=y
CONFIG_NCPFS_NFS_NS=y
CONFIG_NCPFS_OS2_NS=y
CONFIG_NCPFS_SMALLDOS=y
CONFIG_NCPFS_NLS=y
CONFIG_NCPFS_EXTRAS=y
CONFIG_CODA_FS=y
CONFIG_AFS_FS=y
# CONFIG_AFS_DEBUG is not set
CONFIG_AFS_FSCACHE=y
CONFIG_9P_FS=m
CONFIG_9P_FSCACHE=y
CONFIG_9P_FS_POSIX_ACL=y

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
CONFIG_ACORN_PARTITION=y
CONFIG_ACORN_PARTITION_CUMANA=y
CONFIG_ACORN_PARTITION_EESOX=y
CONFIG_ACORN_PARTITION_ICS=y
CONFIG_ACORN_PARTITION_ADFS=y
CONFIG_ACORN_PARTITION_POWERTEC=y
CONFIG_ACORN_PARTITION_RISCIX=y
CONFIG_OSF_PARTITION=y
CONFIG_AMIGA_PARTITION=y
CONFIG_ATARI_PARTITION=y
CONFIG_MAC_PARTITION=y
CONFIG_MSDOS_PARTITION=y
CONFIG_BSD_DISKLABEL=y
CONFIG_MINIX_SUBPARTITION=y
CONFIG_SOLARIS_X86_PARTITION=y
CONFIG_UNIXWARE_DISKLABEL=y
CONFIG_LDM_PARTITION=y
CONFIG_LDM_DEBUG=y
CONFIG_SGI_PARTITION=y
CONFIG_ULTRIX_PARTITION=y
CONFIG_SUN_PARTITION=y
CONFIG_KARMA_PARTITION=y
CONFIG_EFI_PARTITION=y
CONFIG_SYSV68_PARTITION=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="utf8"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_CODEPAGE_737=m
CONFIG_NLS_CODEPAGE_775=m
CONFIG_NLS_CODEPAGE_850=y
CONFIG_NLS_CODEPAGE_852=y
CONFIG_NLS_CODEPAGE_855=m
CONFIG_NLS_CODEPAGE_857=m
CONFIG_NLS_CODEPAGE_860=y
CONFIG_NLS_CODEPAGE_861=m
# CONFIG_NLS_CODEPAGE_862 is not set
CONFIG_NLS_CODEPAGE_863=m
CONFIG_NLS_CODEPAGE_864=y
CONFIG_NLS_CODEPAGE_865=m
CONFIG_NLS_CODEPAGE_866=y
CONFIG_NLS_CODEPAGE_869=m
CONFIG_NLS_CODEPAGE_936=y
CONFIG_NLS_CODEPAGE_950=m
CONFIG_NLS_CODEPAGE_932=y
CONFIG_NLS_CODEPAGE_949=m
CONFIG_NLS_CODEPAGE_874=m
# CONFIG_NLS_ISO8859_8 is not set
CONFIG_NLS_CODEPAGE_1250=m
CONFIG_NLS_CODEPAGE_1251=m
CONFIG_NLS_ASCII=m
CONFIG_NLS_ISO8859_1=y
CONFIG_NLS_ISO8859_2=m
CONFIG_NLS_ISO8859_3=m
CONFIG_NLS_ISO8859_4=m
CONFIG_NLS_ISO8859_5=y
CONFIG_NLS_ISO8859_6=y
CONFIG_NLS_ISO8859_7=m
CONFIG_NLS_ISO8859_9=m
CONFIG_NLS_ISO8859_13=m
CONFIG_NLS_ISO8859_14=m
CONFIG_NLS_ISO8859_15=y
CONFIG_NLS_KOI8_R=y
CONFIG_NLS_KOI8_U=m
CONFIG_NLS_UTF8=y
CONFIG_DLM=y
# CONFIG_DLM_DEBUG is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
# CONFIG_PRINTK_TIME is not set
CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
CONFIG_ENABLE_WARN_DEPRECATED=y
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=0
CONFIG_MAGIC_SYSRQ=y
# CONFIG_STRIP_ASM_SYMS is not set
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
# CONFIG_DEBUG_SECTION_MISMATCH is not set
# CONFIG_DEBUG_KERNEL is not set
# CONFIG_HARDLOCKUP_DETECTOR is not set
# CONFIG_SLUB_DEBUG_ON is not set
# CONFIG_SLUB_STATS is not set
# CONFIG_SPARSE_RCU_POINTER is not set
CONFIG_STACKTRACE=y
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_RCU_CPU_STALL_DETECTOR is not set
# CONFIG_LKDTM is not set
CONFIG_SYSCTL_SYSCALL_CHECK=y
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_NOP_TRACER=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_RING_BUFFER=y
CONFIG_EVENT_TRACING=y
CONFIG_EVENT_POWER_TRACING_DEPRECATED=y
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_RING_BUFFER_ALLOW_SWAP=y
CONFIG_TRACING=y
CONFIG_GENERIC_TRACER=y
CONFIG_TRACING_SUPPORT=y
CONFIG_FTRACE=y
CONFIG_FUNCTION_TRACER=y
# CONFIG_IRQSOFF_TRACER is not set
# CONFIG_SCHED_TRACER is not set
# CONFIG_FTRACE_SYSCALLS is not set
CONFIG_BRANCH_PROFILE_NONE=y
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
# CONFIG_PROFILE_ALL_BRANCHES is not set
# CONFIG_STACK_TRACER is not set
# CONFIG_BLK_DEV_IO_TRACE is not set
# CONFIG_DYNAMIC_FTRACE is not set
# CONFIG_FUNCTION_PROFILER is not set
# CONFIG_FTRACE_STARTUP_TEST is not set
# CONFIG_MMIOTRACE is not set
# CONFIG_RING_BUFFER_BENCHMARK is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_FIREWIRE_OHCI_REMOTE_DMA is not set
# CONFIG_DYNAMIC_DEBUG is not set
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_ATOMIC64_SELFTEST is not set
CONFIG_ASYNC_RAID6_TEST=y
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_TEST_KSTRTOX is not set
CONFIG_STRICT_DEVMEM=y
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
# CONFIG_DEBUG_SET_MODULE_RONX is not set
CONFIG_DOUBLEFAULT=y
# CONFIG_IOMMU_STRESS is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
CONFIG_IO_DELAY_0X80=y
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=0
# CONFIG_OPTIMIZE_INLINING is not set

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_TRUSTED_KEYS is not set
CONFIG_KEYS_DEBUG_PROC_KEYS=y
# CONFIG_SECURITY_DMESG_RESTRICT is not set
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
CONFIG_SECURITY_NETWORK=y
CONFIG_SECURITY_NETWORK_XFRM=y
# CONFIG_SECURITY_PATH is not set
# CONFIG_INTEL_TXT is not set
# CONFIG_SECURITY_SELINUX is not set
# CONFIG_SECURITY_SMACK is not set
# CONFIG_SECURITY_TOMOYO is not set
# CONFIG_SECURITY_APPARMOR is not set
# CONFIG_IMA is not set
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
CONFIG_XOR_BLOCKS=y
CONFIG_ASYNC_CORE=y
CONFIG_ASYNC_MEMCPY=y
CONFIG_ASYNC_XOR=y
CONFIG_ASYNC_PQ=y
CONFIG_ASYNC_RAID6_RECOV=y
CONFIG_ASYNC_TX_DISABLE_PQ_VAL_DMA=y
CONFIG_ASYNC_TX_DISABLE_XOR_VAL_DMA=y
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD=y
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_BLKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG=m
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_PCOMP=m
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_PCRYPT=m
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=m
CONFIG_CRYPTO_AUTHENC=y
CONFIG_CRYPTO_TEST=m

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=m
CONFIG_CRYPTO_GCM=m
CONFIG_CRYPTO_SEQIV=m

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CTR=m
CONFIG_CRYPTO_CTS=m
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=y
CONFIG_CRYPTO_PCBC=y
CONFIG_CRYPTO_XTS=y
CONFIG_CRYPTO_FPU=m

#
# Hash modes
#
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=y
CONFIG_CRYPTO_VMAC=m

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=m
CONFIG_CRYPTO_GHASH=m
CONFIG_CRYPTO_MD4=y
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=y
CONFIG_CRYPTO_RMD128=m
CONFIG_CRYPTO_RMD160=m
CONFIG_CRYPTO_RMD256=m
CONFIG_CRYPTO_RMD320=m
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
CONFIG_CRYPTO_TGR192=y
CONFIG_CRYPTO_WP512=y

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_586=y
CONFIG_CRYPTO_AES_NI_INTEL=m
CONFIG_CRYPTO_ANUBIS=y
CONFIG_CRYPTO_ARC4=y
CONFIG_CRYPTO_BLOWFISH=y
CONFIG_CRYPTO_CAMELLIA=y
CONFIG_CRYPTO_CAST5=y
CONFIG_CRYPTO_CAST6=y
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_FCRYPT=y
CONFIG_CRYPTO_KHAZAD=y
CONFIG_CRYPTO_SALSA20=m
CONFIG_CRYPTO_SALSA20_586=m
CONFIG_CRYPTO_SEED=y
CONFIG_CRYPTO_SERPENT=y
CONFIG_CRYPTO_TEA=y
CONFIG_CRYPTO_TWOFISH=y
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_586=y

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
CONFIG_CRYPTO_ZLIB=m
CONFIG_CRYPTO_LZO=y

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=m
CONFIG_CRYPTO_USER_API=m
CONFIG_CRYPTO_USER_API_HASH=m
CONFIG_CRYPTO_USER_API_SKCIPHER=m
CONFIG_CRYPTO_HW=y
CONFIG_CRYPTO_DEV_PADLOCK=m
CONFIG_CRYPTO_DEV_PADLOCK_AES=m
CONFIG_CRYPTO_DEV_PADLOCK_SHA=m
CONFIG_CRYPTO_DEV_GEODE=m
CONFIG_CRYPTO_DEV_HIFN_795X=m
CONFIG_CRYPTO_DEV_HIFN_795X_RNG=y
CONFIG_HAVE_KVM=y
CONFIG_HAVE_KVM_IRQCHIP=y
CONFIG_HAVE_KVM_EVENTFD=y
CONFIG_KVM_APIC_ARCHITECTURE=y
CONFIG_KVM_MMIO=y
CONFIG_KVM_ASYNC_PF=y
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=m
CONFIG_KVM_INTEL=m
CONFIG_KVM_AMD=m
# CONFIG_KVM_MMU_AUDIT is not set
CONFIG_VHOST_NET=m
# CONFIG_LGUEST is not set
CONFIG_VIRTIO=y
CONFIG_VIRTIO_RING=y
CONFIG_VIRTIO_PCI=m
CONFIG_VIRTIO_BALLOON=m
CONFIG_BINARY_PRINTF=y

#
# Library routines
#
CONFIG_RAID6_PQ=y
CONFIG_BITREVERSE=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_FIND_NEXT_BIT=y
CONFIG_GENERIC_FIND_LAST_BIT=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
CONFIG_CRC7=y
CONFIG_LIBCRC32C=y
CONFIG_AUDIT_GENERIC=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
CONFIG_XZ_DEC_POWERPC=y
CONFIG_XZ_DEC_IA64=y
CONFIG_XZ_DEC_ARM=y
CONFIG_XZ_DEC_ARMTHUMB=y
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_BCJ=y
# CONFIG_XZ_DEC_TEST is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_TEXTSEARCH=y
CONFIG_TEXTSEARCH_KMP=m
CONFIG_TEXTSEARCH_BM=m
CONFIG_TEXTSEARCH_FSM=m
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_CPU_RMAP=y
CONFIG_NLATTR=y
CONFIG_LRU_CACHE=y
CONFIG_AVERAGE=y

--ftEhullJWpWg/VHq
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="crash.log"
Content-Transfer-Encoding: 8bit

Decompressing Linux... Parsing ELF... done.
Booting the kernel.
Initializing cgroup subsys cpu
Linux version 2.6.39-rc5-i486-1sys+ (mingo@sirius) (gcc version 4.6.0 20110419 (Red Hat 4.6.0-5) (GCC) ) #122580 SMP Wed May 4 11:13:48 CEST 2011
KERNEL supported cpus:
  Intel GenuineIntel
  AMD AuthenticAMD
  NSC Geode by NSC
  Cyrix CyrixInstead
  Centaur CentaurHauls
  Transmeta GenuineTMx86
  Transmeta TransmetaCPU
  UMC UMC UMC UMC
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
 BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000003fff0000 (usable)
 BIOS-e820: 000000003fff0000 - 000000003fff3000 (ACPI NVS)
 BIOS-e820: 000000003fff3000 - 0000000040000000 (ACPI data)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
bootconsole [earlyser0] enabled
debug: ignoring loglevel setting.
Notice: NX (Execute Disable) protection cannot be enabled: non-PAE kernel!
DMI 2.3 present.
DMI: System manufacturer System Product Name/A8N-E, BIOS ASUS A8N-E ACPI BIOS Revision 1008 08/22/2005
e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
last_pfn = 0x3fff0 max_arch_pfn = 0x100000
MTRR default type: uncachable
MTRR fixed ranges enabled:
  00000-9FFFF write-back
  A0000-BFFFF uncachable
  C0000-C7FFF write-protect
  C8000-FFFFF uncachable
MTRR variable ranges enabled:
  0 base 0000000000 mask FFC0000000 write-back
  1 disabled
  2 disabled
  3 disabled
  4 disabled
  5 disabled
  6 disabled
  7 disabled
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
Scan SMP from c0000000 for 1024 bytes.
Scan SMP from c009fc00 for 1024 bytes.
Scan SMP from c00f0000 for 65536 bytes.
found SMP MP-table at [c00f5680] f5680
  mpc: f1400-f152c
initial memory mapped : 0 - 02c00000
Base memory trampoline at [c009b000] 9b000 size 16384
init_memory_mapping: 0000000000000000-00000000377fe000
 0000000000 - 0000400000 page 4k
 0000400000 - 0037400000 page 2M
 0037400000 - 00377fe000 page 4k
kernel direct mapping tables up to 377fe000 @ 2bfb000-2c00000
ACPI: RSDP 000f76f0 00014 (v00 Nvidia)
ACPI: RSDT 3fff3040 00034 (v01 Nvidia AWRDACPI 42302E31 AWRD 00000000)
ACPI: FACP 3fff30c0 00074 (v01 Nvidia AWRDACPI 42302E31 AWRD 00000000)
ACPI: DSDT 3fff3180 06264 (v01 NVIDIA AWRDACPI 00001000 MSFT 0100000E)
ACPI: FACS 3fff0000 00040
ACPI: SRAT 3fff9500 000A0 (v01 AMD    HAMMER   00000001 AMD  00000001)
ACPI: MCFG 3fff9600 0003C (v01 Nvidia AWRDACPI 42302E31 AWRD 00000000)
ACPI: APIC 3fff9440 0007C (v01 Nvidia AWRDACPI 42302E31 AWRD 00000000)
ACPI: Local APIC address 0xfee00000
mapped APIC to         ffffb000 (        fee00000)
135MB HIGHMEM available.
887MB LOWMEM available.
  mapped low ram: 0 - 377fe000
  low ram: 0 - 377fe000
Zone PFN ranges:
  DMA      0x00000010 -> 0x00001000
  Normal   0x00001000 -> 0x000377fe
  HighMem  0x000377fe -> 0x0003fff0
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0: 0x00000010 -> 0x0000009f
    0: 0x00000100 -> 0x0003fff0
On node 0 totalpages: 262015
free_area_init_node: node 0, pgdat c2297440, node_mem_map f6ffd200
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 3951 pages, LIFO batch:0
  Normal zone: 1744 pages used for memmap
  Normal zone: 221486 pages, LIFO batch:31
  HighMem zone: 272 pages used for memmap
  HighMem zone: 34530 pages, LIFO batch:7
Using APIC driver default
Nvidia board detected. Ignoring ACPI timer override.
If you got timer trouble try acpi_use_timer_override
ACPI: PM-Timer IO Port: 0x4008
ACPI: Local APIC address 0xfee00000
mapped APIC to         ffffb000 (        fee00000)
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: BIOS IRQ0 pin2 override ignored.
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 2, APIC INT 09
ACPI: INT_SRC_OVR (bus 0 bus_irq 14 global_irq 14 high edge)
Int: type 0, pol 1, trig 1, bus 00, IRQ 0e, APIC ID 2, APIC INT 0e
ACPI: INT_SRC_OVR (bus 0 bus_irq 15 global_irq 15 high edge)
Int: type 0, pol 1, trig 1, bus 00, IRQ 0f, APIC ID 2, APIC INT 0f
Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 2, APIC INT 00
Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 2, APIC INT 01
Int: type 0, pol 0, trig 0, bus 00, IRQ 02, APIC ID 2, APIC INT 02
Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 2, APIC INT 03
Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 2, APIC INT 04
Int: type 0, pol 0, trig 0, bus 00, IRQ 05, APIC ID 2, APIC INT 05
Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 2, APIC INT 06
Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 2, APIC INT 07
Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 2, APIC INT 08
ACPI: IRQ9 used by override.
Int: type 0, pol 0, trig 0, bus 00, IRQ 0a, APIC ID 2, APIC INT 0a
Int: type 0, pol 0, trig 0, bus 00, IRQ 0b, APIC ID 2, APIC INT 0b
Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 2, APIC INT 0c
Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 2, APIC INT 0d
ACPI: IRQ14 used by override.
ACPI: IRQ15 used by override.
Using ACPI (MADT) for SMP configuration information
SMP: Allowing 2 CPUs, 0 hotplug CPUs
mapped IOAPIC to ffffa000 (fec00000)
nr_irqs_gsi: 40
PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
Allocating PCI resources starting at 40000000 (gap: 40000000:a0000000)
Booting paravirtualized kernel on bare hardware
setup_percpu: NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:2 nr_node_ids:1
PERCPU: Embedded 12 pages/cpu @f6800000 s27648 r0 d21504 u2097152
pcpu-alloc: s27648 r0 d21504 u2097152 alloc=1*4194304
pcpu-alloc: [0] 0 1 
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 259967
Kernel command line: root=/dev/sda1 earlyprintk=ttyS0,115200 console=ttyS0,115200 debug initcall_debug enforcing=0 apic=verbose ignore_loglevel sysrq_always_enabled selinux=0 nmi_watchdog=0 3 panic=1 3
sysrq: sysrq always enabled.
PID hash table entries: 4096 (order: 2, 16384 bytes)
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Initializing CPU#0
Initializing HighMem for node 0 (000377fe:0003fff0)
Memory: 1015968k/1048512k available (13778k kernel code, 32092k reserved, 5325k data, 932k init, 139208k highmem)
virtual kernel memory layout:
    fixmap  : 0xffd36000 - 0xfffff000   (2852 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
    lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
      .init : 0xc22a9000 - 0xc2392000   ( 932 kB)
      .data : 0xc1d74a0c - 0xc22a8070   (5325 kB)
      .text : 0xc1000000 - 0xc1d74a0c   (13778 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
Hierarchical RCU implementation.
	RCU-based detection of stalled CPUs is disabled.
NR_IRQS:1280
CPU 0 irqstacks, hard=f640e000 soft=f6420000
spurious 8259A interrupt: IRQ7.
Console: colour VGA+ 80x25
console [ttyS0] enabled, bootconsole disabled
console [ttyS0] enabled, bootconsole disabled
Fast TSC calibration using PIT
Detected 2010.445 MHz processor.
Marking TSC unstable due to TSCs unsynchronized
Calibrating delay loop (skipped), value calculated using timer frequency.. 4020.89 BogoMIPS (lpj=2010445)
pid_max: default: 32768 minimum: 301
Security Framework initialized
Mount-cache hash table entries: 512
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
mce: CPU supports 5 MCE banks
ACPI: Core revision 20110316
Enabling APIC mode:  Flat.  Using 1 I/O APICs
enabled ExtINT on CPU#0
ENABLING IO-APIC IRQs
init IO_APIC IRQs
IOAPIC[0]: Set routing entry (2-0 -> 0x30 -> IRQ 0 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-3 -> 0x33 -> IRQ 3 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-5 -> 0x35 -> IRQ 5 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-9 -> 0x39 -> IRQ 9 Mode:1 Active:0)
IOAPIC[0]: Set routing entry (2-10 -> 0x3a -> IRQ 10 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-11 -> 0x3b -> IRQ 11 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-13 -> 0x3d -> IRQ 13 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-14 -> 0x3e -> IRQ 14 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-15 -> 0x3f -> IRQ 15 Mode:0 Active:0)
 apic 2 pin 16 not connected
 apic 2 pin 17 not connected
 apic 2 pin 18 not connected
 apic 2 pin 19 not connected
 apic 2 pin 20 not connected
 apic 2 pin 21 not connected
 apic 2 pin 22 not connected
 apic 2 pin 23 not connected
..TIMER: vector=0x30 apic1=0 pin1=0 apic2=-1 pin2=-1
CPU0: AMD Athlon(tm) 64 X2 Dual Core Processor 3800+ stepping 02
Using local APIC timer interrupts.
calibrating APIC timer ...
... lapic delta = 1256244
... PM-Timer delta = 357899
... PM-Timer result ok
..... delta 1256244
..... mult: 53963471
..... calibration result: 200999
..... CPU clock speed is 2009.0990 MHz.
..... host bus clock speed is 200.0999 MHz.
calling  trace_init_flags_sys_exit+0x0/0x11 @ 1
initcall trace_init_flags_sys_exit+0x0/0x11 returned 0 after 0 usecs
calling  trace_init_flags_sys_enter+0x0/0x11 @ 1
initcall trace_init_flags_sys_enter+0x0/0x11 returned 0 after 0 usecs
calling  init_hw_perf_events+0x0/0xdaa @ 1
Performance Events: AMD PMU driver.
... version:                0
... bit width:              48
... generic registers:      4
... value mask:             0000ffffffffffff
... max period:             00007fffffffffff
... fixed-purpose events:   0
... event mask:             000000000000000f
initcall init_hw_perf_events+0x0/0xdaa returned 0 after 8788 usecs
calling  migration_init+0x0/0x59 @ 1
initcall migration_init+0x0/0x59 returned 0 after 0 usecs
calling  spawn_ksoftirqd+0x0/0x41 @ 1
initcall spawn_ksoftirqd+0x0/0x41 returned 0 after 0 usecs
calling  init_workqueues+0x0/0x2ca @ 1
initcall init_workqueues+0x0/0x2ca returned 0 after 0 usecs
calling  init_jump_label_module+0x0/0xf @ 1
initcall init_jump_label_module+0x0/0xf returned 0 after 0 usecs
calling  init_jump_label+0x0/0xde @ 1
initcall init_jump_label+0x0/0xde returned 0 after 976 usecs
calling  init_call_single_data+0x0/0x6b @ 1
initcall init_call_single_data+0x0/0x6b returned 0 after 0 usecs
calling  cpu_stop_init+0x0/0x7f @ 1
initcall cpu_stop_init+0x0/0x7f returned 0 after 0 usecs
calling  relay_init+0x0/0x11 @ 1
initcall relay_init+0x0/0x11 returned 0 after 0 usecs
calling  tracer_alloc_buffers+0x0/0x12b @ 1
initcall tracer_alloc_buffers+0x0/0x12b returned 0 after 976 usecs
calling  init_trace_printk+0x0/0xf @ 1
initcall init_trace_printk+0x0/0xf returned 0 after 0 usecs
calling  mce_amd_init+0x0/0x14d @ 1
MCE: In-kernel MCE decoding enabled.
initcall mce_amd_init+0x0/0x14d returned 0 after 976 usecs
CPU 1 irqstacks, hard=f64ca000 soft=f64cc000
Booting Node   0, Processors  #1 Ok.
smpboot cpu 1: start_ip = 9b000
Initializing CPU#1
masked ExtINT on CPU#1
Brought up 2 CPUs
Total of 2 processors activated (8040.79 BogoMIPS).
devtmpfs: initialized
calling  init_mmap_min_addr+0x0/0x11 @ 1
initcall init_mmap_min_addr+0x0/0x11 returned 0 after 0 usecs
calling  init_cpufreq_transition_notifier_list+0x0/0x18 @ 1
initcall init_cpufreq_transition_notifier_list+0x0/0x18 returned 0 after 0 usecs
calling  net_ns_init+0x0/0xda @ 1
initcall net_ns_init+0x0/0xda returned 0 after 0 usecs
calling  e820_mark_nvs_memory+0x0/0x2f @ 1
PM: Registering ACPI NVS region at 3fff0000 (12288 bytes)
initcall e820_mark_nvs_memory+0x0/0x2f returned 0 after 976 usecs
calling  cpufreq_tsc+0x0/0x26 @ 1
initcall cpufreq_tsc+0x0/0x26 returned 0 after 0 usecs
calling  pci_reboot_init+0x0/0x11 @ 1
initcall pci_reboot_init+0x0/0x11 returned 0 after 0 usecs
calling  reboot_init+0x0/0x11 @ 1
initcall reboot_init+0x0/0x11 returned 0 after 0 usecs
calling  init_lapic_sysfs+0x0/0x1b @ 1
initcall init_lapic_sysfs+0x0/0x1b returned 0 after 0 usecs
calling  init_smp_flush+0x0/0x31 @ 1
initcall init_smp_flush+0x0/0x31 returned 0 after 0 usecs
calling  alloc_frozen_cpus+0x0/0xc @ 1
initcall alloc_frozen_cpus+0x0/0xc returned 0 after 0 usecs
calling  sysctl_init+0x0/0x29 @ 1
initcall sysctl_init+0x0/0x29 returned 0 after 0 usecs
calling  ksysfs_init+0x0/0x74 @ 1
initcall ksysfs_init+0x0/0x74 returned 0 after 0 usecs
calling  init_jiffies_clocksource+0x0/0xf @ 1
initcall init_jiffies_clocksource+0x0/0xf returned 0 after 0 usecs
calling  pm_init+0x0/0x62 @ 1
initcall pm_init+0x0/0x62 returned 0 after 0 usecs
calling  pm_disk_init+0x0/0x14 @ 1
initcall pm_disk_init+0x0/0x14 returned 0 after 0 usecs
calling  swsusp_header_init+0x0/0x2e @ 1
initcall swsusp_header_init+0x0/0x2e returned 0 after 0 usecs
calling  init_zero_pfn+0x0/0x14 @ 1
initcall init_zero_pfn+0x0/0x14 returned 0 after 0 usecs
calling  fsnotify_init+0x0/0x22 @ 1
initcall fsnotify_init+0x0/0x22 returned 0 after 0 usecs
calling  filelock_init+0x0/0x2f @ 1
initcall filelock_init+0x0/0x2f returned 0 after 0 usecs
calling  init_aout_binfmt+0x0/0x11 @ 1
initcall init_aout_binfmt+0x0/0x11 returned 0 after 0 usecs
calling  init_misc_binfmt+0x0/0x38 @ 1
initcall init_misc_binfmt+0x0/0x38 returned 0 after 0 usecs
calling  init_script_binfmt+0x0/0x11 @ 1
initcall init_script_binfmt+0x0/0x11 returned 0 after 0 usecs
calling  init_elf_binfmt+0x0/0x11 @ 1
initcall init_elf_binfmt+0x0/0x11 returned 0 after 0 usecs
calling  debugfs_init+0x0/0x4a @ 1
initcall debugfs_init+0x0/0x4a returned 0 after 0 usecs
calling  securityfs_init+0x0/0x41 @ 1
initcall securityfs_init+0x0/0x41 returned 0 after 0 usecs
calling  calibrate_xor_blocks+0x0/0x153 @ 1
xor: automatically using best checksumming function: pIII_sse
   pIII_sse  :  5988.000 MB/sec
xor: using function: pIII_sse (5988.000 MB/sec)
initcall calibrate_xor_blocks+0x0/0x153 returned 0 after 7811 usecs
calling  random32_init+0x0/0xa1 @ 1
initcall random32_init+0x0/0xa1 returned 0 after 0 usecs
calling  sfi_sysfs_init+0x0/0xba @ 1
initcall sfi_sysfs_init+0x0/0xba returned 0 after 0 usecs
calling  virtio_init+0x0/0x27 @ 1
initcall virtio_init+0x0/0x27 returned 0 after 0 usecs
calling  regulator_init+0x0/0x5e @ 1
print_constraints: dummy: 
initcall regulator_init+0x0/0x5e returned 0 after 976 usecs
calling  cpufreq_core_init+0x0/0x7e @ 1
initcall cpufreq_core_init+0x0/0x7e returned 0 after 0 usecs
calling  cpuidle_init+0x0/0x32 @ 1
initcall cpuidle_init+0x0/0x32 returned 0 after 0 usecs
calling  sock_init+0x0/0x78 @ 1
initcall sock_init+0x0/0x78 returned 0 after 0 usecs
calling  net_inuse_init+0x0/0x22 @ 1
initcall net_inuse_init+0x0/0x22 returned 0 after 0 usecs
calling  netpoll_init+0x0/0x2f @ 1
initcall netpoll_init+0x0/0x2f returned 0 after 0 usecs
calling  netlink_proto_init+0x0/0x188 @ 1
NET: Registered protocol family 16
initcall netlink_proto_init+0x0/0x188 returned 0 after 976 usecs
calling  olpc_init+0x0/0x24d @ 1
initcall olpc_init+0x0/0x24d returned 0 after 0 usecs
calling  bdi_class_init+0x0/0x3c @ 1
initcall bdi_class_init+0x0/0x3c returned 0 after 0 usecs
calling  kobject_uevent_init+0x0/0x1e @ 1
initcall kobject_uevent_init+0x0/0x1e returned 0 after 0 usecs
calling  gpiolib_sysfs_init+0x0/0x74 @ 1
initcall gpiolib_sysfs_init+0x0/0x74 returned 0 after 0 usecs
calling  pcibus_class_init+0x0/0x14 @ 1
initcall pcibus_class_init+0x0/0x14 returned 0 after 0 usecs
calling  pci_driver_init+0x0/0xf @ 1
initcall pci_driver_init+0x0/0xf returned 0 after 0 usecs
calling  rio_bus_init+0x0/0x2a @ 1
initcall rio_bus_init+0x0/0x2a returned 0 after 0 usecs
calling  backlight_class_init+0x0/0x53 @ 1
initcall backlight_class_init+0x0/0x53 returned 0 after 0 usecs
calling  video_output_class_init+0x0/0x14 @ 1
initcall video_output_class_init+0x0/0x14 returned 0 after 0 usecs
calling  tty_class_init+0x0/0x2b @ 1
initcall tty_class_init+0x0/0x2b returned 0 after 0 usecs
calling  vtconsole_class_init+0x0/0xc9 @ 1
initcall vtconsole_class_init+0x0/0xc9 returned 0 after 0 usecs
calling  wakeup_sources_debugfs_init+0x0/0x2f @ 1
initcall wakeup_sources_debugfs_init+0x0/0x2f returned 0 after 0 usecs
calling  spi_init+0x0/0x7e @ 1
initcall spi_init+0x0/0x7e returned 0 after 0 usecs
calling  i2c_init+0x0/0x59 @ 1
initcall i2c_init+0x0/0x59 returned 0 after 0 usecs
calling  eisa_init+0x0/0x27 @ 1
EISA bus registered
initcall eisa_init+0x0/0x27 returned 0 after 976 usecs
calling  lguest_devices_init+0x0/0x146 @ 1
initcall lguest_devices_init+0x0/0x146 returned 0 after 0 usecs
calling  amd_postcore_init+0x0/0x13e @ 1
node 0 link 0: io port [1000, fffff]
TOM: 0000000040000000 aka 1024M
node 0 link 0: mmio [e0000000, efffffff]
node 0 link 0: mmio [feb00000, fec0ffff]
node 0 link 0: mmio [a0000, bffff]
node 0 link 0: mmio [40000000, fed3ffff]
bus: [00, ff] on node 0 link 0
bus: 00 index 0 [io  0x0000-0xffff]
bus: 00 index 1 [mem 0x40000000-0xffffffff]
bus: 00 index 2 [mem 0xfeb00000-0xfec0ffff]
bus: 00 index 3 [mem 0x000a0000-0x000bffff]
initcall amd_postcore_init+0x0/0x13e returned 0 after 11716 usecs
calling  arch_kdebugfs_init+0x0/0x1e @ 1
initcall arch_kdebugfs_init+0x0/0x1e returned 0 after 0 usecs
calling  init_pit_clocksource+0x0/0x95 @ 1
initcall init_pit_clocksource+0x0/0x95 returned 0 after 0 usecs
calling  configure_trampolines+0x0/0x1f @ 1
initcall configure_trampolines+0x0/0x1f returned 0 after 0 usecs
calling  mtrr_if_init+0x0/0x56 @ 1
initcall mtrr_if_init+0x0/0x56 returned 0 after 0 usecs
calling  ffh_cstate_init+0x0/0x27 @ 1
initcall ffh_cstate_init+0x0/0x27 returned -1 after 0 usecs
initcall ffh_cstate_init+0x0/0x27 returned with error code -1 
calling  acpi_pci_init+0x0/0x59 @ 1
ACPI: bus type pci registered
initcall acpi_pci_init+0x0/0x59 returned 0 after 976 usecs
calling  dma_bus_init+0x0/0x32 @ 1
initcall dma_bus_init+0x0/0x32 returned 0 after 0 usecs
calling  dma_channel_table_init+0x0/0xe0 @ 1
initcall dma_channel_table_init+0x0/0xe0 returned 0 after 0 usecs
calling  dmi_id_init+0x0/0x28e @ 1
initcall dmi_id_init+0x0/0x28e returned 0 after 0 usecs
calling  dca_init+0x0/0x21 @ 1
dca service started, version 1.12.1
initcall dca_init+0x0/0x21 returned 0 after 976 usecs
calling  pci_arch_init+0x0/0x63 @ 1
PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
PCI: Using MMCONFIG for extended config space
PCI: Using configuration type 1 for base access
initcall pci_arch_init+0x0/0x63 returned 0 after 3905 usecs
calling  topology_init+0x0/0x36 @ 1
initcall topology_init+0x0/0x36 returned 0 after 0 usecs
calling  mtrr_init_finialize+0x0/0x30 @ 1
initcall mtrr_init_finialize+0x0/0x30 returned 0 after 0 usecs
calling  mca_init+0x0/0x31e @ 1
initcall mca_init+0x0/0x31e returned -19 after 0 usecs
calling  param_sysfs_init+0x0/0x159 @ 1
initcall param_sysfs_init+0x0/0x159 returned 0 after 39056 usecs
calling  pm_sysrq_init+0x0/0x1b @ 1
initcall pm_sysrq_init+0x0/0x1b returned 0 after 0 usecs
calling  default_bdi_init+0x0/0xaa @ 1
initcall default_bdi_init+0x0/0xaa returned 0 after 0 usecs
calling  init_bio+0x0/0xfb @ 1
bio: create slab <bio-0> at 0
initcall init_bio+0x0/0xfb returned 0 after 976 usecs
calling  fsnotify_notification_init+0x0/0x9c @ 1
initcall fsnotify_notification_init+0x0/0x9c returned 0 after 0 usecs
calling  cryptomgr_init+0x0/0xf @ 1
initcall cryptomgr_init+0x0/0xf returned 0 after 0 usecs
calling  blk_settings_init+0x0/0x1d @ 1
initcall blk_settings_init+0x0/0x1d returned 0 after 0 usecs
calling  blk_ioc_init+0x0/0x2f @ 1
initcall blk_ioc_init+0x0/0x2f returned 0 after 0 usecs
calling  blk_softirq_init+0x0/0x54 @ 1
initcall blk_softirq_init+0x0/0x54 returned 0 after 0 usecs
calling  blk_iopoll_setup+0x0/0x54 @ 1
initcall blk_iopoll_setup+0x0/0x54 returned 0 after 0 usecs
calling  genhd_device_init+0x0/0x6a @ 1
initcall genhd_device_init+0x0/0x6a returned 0 after 0 usecs
calling  blk_dev_integrity_init+0x0/0x2f @ 1
initcall blk_dev_integrity_init+0x0/0x2f returned 0 after 0 usecs
calling  raid6_select_algo+0x0/0x17a @ 1
raid6: int32x1    539 MB/s
raid6: int32x2    886 MB/s
raid6: int32x4    535 MB/s
raid6: int32x8    488 MB/s
raid6: mmxx1     1656 MB/s
raid6: mmxx2     3078 MB/s
raid6: sse1x1    1515 MB/s
raid6: sse1x2    2558 MB/s
raid6: sse2x1    2585 MB/s
raid6: sse2x2    3339 MB/s
raid6: using algorithm sse2x2 (3339 MB/s)
initcall raid6_select_algo+0x0/0x17a returned 0 after 189424 usecs
calling  gpiolib_debugfs_init+0x0/0x2a @ 1
initcall gpiolib_debugfs_init+0x0/0x2a returned 0 after 0 usecs
calling  stmpe_gpio_init+0x0/0xf @ 1
initcall stmpe_gpio_init+0x0/0xf returned 0 after 0 usecs
calling  tc3589x_gpio_init+0x0/0xf @ 1
initcall tc3589x_gpio_init+0x0/0xf returned 0 after 0 usecs
calling  sx150x_init+0x0/0x11 @ 1
initcall sx150x_init+0x0/0x11 returned 0 after 0 usecs
calling  pci_slot_init+0x0/0x42 @ 1
initcall pci_slot_init+0x0/0x42 returned 0 after 0 usecs
calling  fbmem_init+0x0/0x96 @ 1
initcall fbmem_init+0x0/0x96 returned 0 after 0 usecs
calling  acpi_init+0x0/0x270 @ 1
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
initcall acpi_init+0x0/0x270 returned 0 after 30268 usecs
calling  dock_init+0x0/0xb3 @ 1
ACPI: No dock devices found.
initcall dock_init+0x0/0xb3 returned 0 after 1952 usecs
calling  acpi_pci_root_init+0x0/0x2a @ 1
HEST: Table not found.
PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7] (ignored)
pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff] (ignored)
pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
pci_root PNP0A08:00: host bridge window [mem 0x000c0000-0x000dffff] (ignored)
pci_root PNP0A08:00: host bridge window [mem 0x40000000-0xfebfffff] (ignored)
pci 0000:00:00.0: [10de:005e] type 0 class 0x000580
pci 0000:00:01.0: [10de:0050] type 0 class 0x000601
HPET not enabled in BIOS. You might try hpet=force boot option
pci 0000:00:01.1: [10de:0052] type 0 class 0x000c05
pci 0000:00:01.1: reg 10: [io  0xdc00-0xdc1f]
pci 0000:00:01.1: reg 20: [io  0x4c00-0x4c3f]
pci 0000:00:01.1: reg 24: [io  0x4c40-0x4c7f]
pci 0000:00:01.1: PME# supported from D3hot D3cold
pci 0000:00:01.1: PME# disabled
pci 0000:00:02.0: [10de:005a] type 0 class 0x000c03
pci 0000:00:02.0: reg 10: [mem 0xda102000-0xda102fff]
pci 0000:00:02.0: supports D1 D2
pci 0000:00:02.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:02.0: PME# disabled
pci 0000:00:02.1: [10de:005b] type 0 class 0x000c03
pci 0000:00:02.1: reg 10: [mem 0xfeb00000-0xfeb000ff]
pci 0000:00:02.1: supports D1 D2
pci 0000:00:02.1: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:02.1: PME# disabled
pci 0000:00:04.0: [10de:0059] type 0 class 0x000401
pci 0000:00:04.0: reg 10: [io  0xd400-0xd4ff]
pci 0000:00:04.0: reg 14: [io  0xd800-0xd8ff]
pci 0000:00:04.0: reg 18: [mem 0xda101000-0xda101fff]
pci 0000:00:04.0: supports D1 D2
pci 0000:00:06.0: [10de:0053] type 0 class 0x000101
pci 0000:00:06.0: reg 20: [io  0xf000-0xf00f]
pci 0000:00:09.0: [10de:005c] type 1 class 0x000604
pci 0000:00:0a.0: [10de:0057] type 0 class 0x000680
pci 0000:00:0a.0: reg 10: [mem 0xda100000-0xda100fff]
pci 0000:00:0a.0: reg 14: [io  0xd000-0xd007]
pci 0000:00:0a.0: supports D1 D2
pci 0000:00:0a.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:0a.0: PME# disabled
pci 0000:00:0b.0: [10de:005d] type 1 class 0x000604
pci 0000:00:0b.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:0b.0: PME# disabled
pci 0000:00:0c.0: [10de:005d] type 1 class 0x000604
pci 0000:00:0c.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:0c.0: PME# disabled
pci 0000:00:0d.0: [10de:005d] type 1 class 0x000604
pci 0000:00:0d.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:0d.0: PME# disabled
pci 0000:00:0e.0: [10de:005d] type 1 class 0x000604
pci 0000:00:0e.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:0e.0: PME# disabled
pci 0000:00:18.0: [1022:1100] type 0 class 0x000600
pci 0000:00:18.1: [1022:1101] type 0 class 0x000600
pci 0000:00:18.2: [1022:1102] type 0 class 0x000600
pci 0000:00:18.3: [1022:1103] type 0 class 0x000600
PCI: peer root bus 00 res updated from pci conf
pci 0000:05:07.0: [10ec:8139] type 0 class 0x000200
pci 0000:05:07.0: reg 10: [io  0xc000-0xc0ff]
pci 0000:05:07.0: reg 14: [mem 0xda000000-0xda0000ff]
pci 0000:05:07.0: supports D1 D2
pci 0000:05:07.0: PME# supported from D1 D2 D3hot
pci 0000:05:07.0: PME# disabled
pci 0000:00:09.0: PCI bridge to [bus 05-05] (subtractive decode)
pci 0000:00:09.0:   bridge window [io  0xc000-0xcfff]
pci 0000:00:09.0:   bridge window [mem 0xda000000-0xda0fffff]
pci 0000:00:09.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:00:09.0:   bridge window [io  0x0000-0xffff] (subtractive decode)
pci 0000:00:09.0:   bridge window [mem 0x40000000-0xffffffff] (subtractive decode)
pci 0000:00:09.0:   bridge window [mem 0xfeb00000-0xfec0ffff] (subtractive decode)
pci 0000:00:09.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
pci 0000:00:0b.0: PCI bridge to [bus 04-04]
pci 0000:00:0b.0:   bridge window [io  0xf000-0x0000] (disabled)
pci 0000:00:0b.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
pci 0000:00:0b.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:00:0c.0: PCI bridge to [bus 03-03]
pci 0000:00:0c.0:   bridge window [io  0xf000-0x0000] (disabled)
pci 0000:00:0c.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
pci 0000:00:0c.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:00:0d.0: PCI bridge to [bus 02-02]
pci 0000:00:0d.0:   bridge window [io  0xf000-0x0000] (disabled)
pci 0000:00:0d.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
pci 0000:00:0d.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:01:00.0: [1002:5b60] type 0 class 0x000300
pci 0000:01:00.0: reg 10: [mem 0xd0000000-0xd7ffffff pref]
pci 0000:01:00.0: reg 14: [io  0xb000-0xb0ff]
pci 0000:01:00.0: reg 18: [mem 0xd9000000-0xd900ffff]
pci 0000:01:00.0: reg 30: [mem 0x00000000-0x0001ffff pref]
pci 0000:01:00.0: supports D1 D2
pci 0000:01:00.1: [1002:5b70] type 0 class 0x000380
pci 0000:01:00.1: reg 10: [mem 0xd9010000-0xd901ffff]
pci 0000:01:00.1: supports D1 D2
pci 0000:01:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
pci 0000:00:0e.0: PCI bridge to [bus 01-01]
pci 0000:00:0e.0:   bridge window [io  0xb000-0xbfff]
pci 0000:00:0e.0:   bridge window [mem 0xd8000000-0xd9ffffff]
pci 0000:00:0e.0:   bridge window [mem 0xd0000000-0xd7ffffff 64bit pref]
pci_bus 0000:00: on NUMA node 0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB0._PRT]
 pci0000:00: Requesting ACPI _OSC control (0x1d)
Unable to assume _OSC PCIe control. Disabling ASPM
initcall acpi_pci_root_init+0x0/0x2a returned 0 after 518475 usecs
calling  acpi_pci_link_init+0x0/0x3a @ 1
ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNK2] (IRQs 3 4 5 7 9 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNK3] (IRQs 3 4 *5 7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNK4] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNK5] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LUBA] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LUBB] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LMAC] (IRQs 3 4 5 7 9 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LACI] (IRQs *3 4 5 7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LMCI] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LSMB] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LUB2] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LIDE] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LSID] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LFID] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LPCA] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [APC1] (IRQs 16) *0, disabled.
ACPI: PCI Interrupt Link [APC2] (IRQs 17) *0
ACPI: PCI Interrupt Link [APC3] (IRQs 18) *0
ACPI: PCI Interrupt Link [APC4] (IRQs 19) *0, disabled.
ACPI: PCI Interrupt Link [APC5] (IRQs *16), disabled.
ACPI: PCI Interrupt Link [APCF] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [APCG] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [APCH] (IRQs 20 21 22 23) *0
ACPI: PCI Interrupt Link [APCJ] (IRQs 20 21 22 23) *0
ACPI: PCI Interrupt Link [APCK] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [APCS] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [APCL] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [APCZ] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [APSI] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [APSJ] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [APCP] (IRQs 20 21 22 23) *0, disabled.
initcall acpi_pci_link_init+0x0/0x3a returned 0 after 192353 usecs
calling  pnp_init+0x0/0xf @ 1
initcall pnp_init+0x0/0xf returned 0 after 0 usecs
calling  twlreg_init+0x0/0xf @ 1
initcall twlreg_init+0x0/0xf returned 0 after 0 usecs
calling  pm8607_regulator_init+0x0/0xf @ 1
initcall pm8607_regulator_init+0x0/0xf returned 0 after 0 usecs
calling  ab8500_regulator_init+0x0/0x2e @ 1
initcall ab8500_regulator_init+0x0/0x2e returned 0 after 0 usecs
calling  misc_init+0x0/0xad @ 1
initcall misc_init+0x0/0xad returned 0 after 0 usecs
calling  vga_arb_device_init+0x0/0x82 @ 1
vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
vgaarb: loaded
initcall vga_arb_device_init+0x0/0x82 returned 0 after 1952 usecs
calling  cn_init+0x0/0x9d @ 1
initcall cn_init+0x0/0x9d returned 0 after 0 usecs
calling  tifm_init+0x0/0x78 @ 1
initcall tifm_init+0x0/0x78 returned 0 after 0 usecs
calling  pm860x_i2c_init+0x0/0x30 @ 1
initcall pm860x_i2c_init+0x0/0x30 returned 0 after 0 usecs
calling  stmpe_init+0x0/0x11 @ 1
initcall stmpe_init+0x0/0x11 returned 0 after 0 usecs
calling  tc3589x_init+0x0/0x11 @ 1
initcall tc3589x_init+0x0/0x11 returned 0 after 0 usecs
calling  wm831x_i2c_init+0x0/0x30 @ 1
initcall wm831x_i2c_init+0x0/0x30 returned 0 after 0 usecs
calling  wm831x_spi_init+0x0/0xdc @ 1
initcall wm831x_spi_init+0x0/0xdc returned 0 after 0 usecs
calling  wm8350_i2c_init+0x0/0x11 @ 1
initcall wm8350_i2c_init+0x0/0x11 returned 0 after 0 usecs
calling  twl_init+0x0/0x11 @ 1
initcall twl_init+0x0/0x11 returned 0 after 0 usecs
calling  ezx_pcap_init+0x0/0xf @ 1
initcall ezx_pcap_init+0x0/0xf returned 0 after 0 usecs
calling  da903x_init+0x0/0x11 @ 1
initcall da903x_init+0x0/0x11 returned 0 after 0 usecs
calling  max8925_i2c_init+0x0/0x30 @ 1
initcall max8925_i2c_init+0x0/0x30 returned 0 after 0 usecs
calling  max8997_i2c_init+0x0/0x11 @ 1
initcall max8997_i2c_init+0x0/0x11 returned 0 after 0 usecs
calling  max8998_i2c_init+0x0/0x11 @ 1
initcall max8998_i2c_init+0x0/0x11 returned 0 after 0 usecs
calling  ab3100_i2c_init+0x0/0x11 @ 1
initcall ab3100_i2c_init+0x0/0x11 returned 0 after 0 usecs
calling  ab3550_i2c_init+0x0/0x11 @ 1
initcall ab3550_i2c_init+0x0/0x11 returned 0 after 0 usecs
calling  ab8500_sysctrl_init+0x0/0xf @ 1
initcall ab8500_sysctrl_init+0x0/0xf returned 0 after 0 usecs
calling  ab8500_debug_init+0x0/0xf @ 1
initcall ab8500_debug_init+0x0/0xf returned 0 after 0 usecs
calling  tps6586x_init+0x0/0x11 @ 1
initcall tps6586x_init+0x0/0x11 returned 0 after 0 usecs
calling  init_scsi+0x0/0x90 @ 1
SCSI subsystem initialized
initcall init_scsi+0x0/0x90 returned 0 after 976 usecs
calling  ata_init+0x0/0x29f @ 1
libata version 3.00 loaded.
initcall ata_init+0x0/0x29f returned 0 after 2929 usecs
calling  phy_init+0x0/0x28 @ 1
initcall phy_init+0x0/0x28 returned 0 after 0 usecs
calling  init_pcmcia_cs+0x0/0x2d @ 1
initcall init_pcmcia_cs+0x0/0x2d returned 0 after 0 usecs
calling  usb_init+0x0/0x142 @ 1
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
initcall usb_init+0x0/0x142 returned 0 after 8787 usecs
calling  serio_init+0x0/0x2e @ 1
initcall serio_init+0x0/0x2e returned 0 after 0 usecs
calling  gameport_init+0x0/0x2e @ 1
initcall gameport_init+0x0/0x2e returned 0 after 0 usecs
calling  input_init+0x0/0xfd @ 1
initcall input_init+0x0/0xfd returned 0 after 0 usecs
calling  tca6416_keypad_init+0x0/0x11 @ 1
initcall tca6416_keypad_init+0x0/0x11 returned 0 after 0 usecs
calling  init_dvbdev+0x0/0xc2 @ 1
initcall init_dvbdev+0x0/0xc2 returned 0 after 0 usecs
calling  power_supply_class_init+0x0/0x35 @ 1
initcall power_supply_class_init+0x0/0x35 returned 0 after 0 usecs
calling  hwmon_init+0x0/0xe3 @ 1
initcall hwmon_init+0x0/0xe3 returned 0 after 0 usecs
calling  md_init+0x0/0x152 @ 1
initcall md_init+0x0/0x152 returned 0 after 0 usecs
calling  mmc_init+0x0/0x74 @ 1
initcall mmc_init+0x0/0x74 returned 0 after 976 usecs
calling  leds_init+0x0/0x39 @ 1
initcall leds_init+0x0/0x39 returned 0 after 0 usecs
calling  acpi_wmi_init+0x0/0x62 @ 1
wmi: Mapper loaded
initcall acpi_wmi_init+0x0/0x62 returned 0 after 1952 usecs
calling  pci_subsys_init+0x0/0x44 @ 1
PCI: Using ACPI for IRQ routing
PCI: pci_cache_line_size set to 64 bytes
pci 0000:00:02.1: address space collision: [mem 0xfeb00000-0xfeb000ff] conflicts with PCI Bus #00 [mem 0xfeb00000-0xfec0ffff]
Expanded resource reserved due to conflict with PCI Bus #00
reserve RAM buffer: 000000000009f800 - 000000000009ffff 
reserve RAM buffer: 000000003fff0000 - 000000003fffffff 
initcall pci_subsys_init+0x0/0x44 returned 0 after 32221 usecs
calling  proto_init+0x0/0xf @ 1
initcall proto_init+0x0/0xf returned 0 after 0 usecs
calling  net_dev_init+0x0/0x16b @ 1
initcall net_dev_init+0x0/0x16b returned 0 after 976 usecs
calling  neigh_init+0x0/0x7a @ 1
initcall neigh_init+0x0/0x7a returned 0 after 0 usecs
calling  fib_rules_init+0x0/0xa2 @ 1
initcall fib_rules_init+0x0/0xa2 returned 0 after 0 usecs
calling  pktsched_init+0x0/0xe4 @ 1
initcall pktsched_init+0x0/0xe4 returned 0 after 0 usecs
calling  tc_filter_init+0x0/0x50 @ 1
initcall tc_filter_init+0x0/0x50 returned 0 after 0 usecs
calling  tc_action_init+0x0/0x50 @ 1
initcall tc_action_init+0x0/0x50 returned 0 after 0 usecs
calling  genl_init+0x0/0x7b @ 1
initcall genl_init+0x0/0x7b returned 0 after 0 usecs
calling  cipso_v4_init+0x0/0x59 @ 1
initcall cipso_v4_init+0x0/0x59 returned 0 after 0 usecs
calling  wanrouter_init+0x0/0x5a @ 1
Sangoma WANPIPE Router v1.1 (c) 1995-2000 Sangoma Technologies Inc.
initcall wanrouter_init+0x0/0x5a returned 0 after 976 usecs
calling  atm_init+0x0/0xd0 @ 1
NET: Registered protocol family 8
NET: Registered protocol family 20
initcall atm_init+0x0/0xd0 returned 0 after 1952 usecs
calling  wireless_nlevent_init+0x0/0xf @ 1
initcall wireless_nlevent_init+0x0/0xf returned 0 after 0 usecs
calling  netlbl_init+0x0/0x7d @ 1
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
initcall netlbl_init+0x0/0x7d returned 0 after 3905 usecs
calling  rfkill_init+0x0/0x7f @ 1
initcall rfkill_init+0x0/0x7f returned 0 after 0 usecs
calling  sysctl_init+0x0/0x3b @ 1
initcall sysctl_init+0x0/0x3b returned 0 after 0 usecs
calling  ab8500_gpadc_init+0x0/0xf @ 1
initcall ab8500_gpadc_init+0x0/0xf returned 0 after 0 usecs
calling  print_ICs+0x0/0x491 @ 1

printing PIC contents
... PIC  IMR: ffff
... PIC  IRR: 0829
... PIC  ISR: 0000
... PIC ELCR: 0828
printing local APIC contents on CPU#0/0:
... APIC ID:      00000000 (0)
... APIC VERSION: 00040010
... APIC TASKPRI: 00000000 (00)
... APIC ARBPRI: 000000e0 (e0)
... APIC PROCPRI: 00000000
... APIC LDR: 01000000
... APIC DFR: ffffffff
... APIC SPIV: 000001ff
... APIC ISR field:
0000000000000000000000000000000000000000000000000000000000000000
... APIC TMR field:
0000000000000000000000000000000000000000000000000000000000000000
... APIC IRR field:
0000000000000000000000000000000000000000000000000000000000008000
... APIC ESR: 00000000
... APIC ICR: 000008fd
... APIC ICR2: 02000000
... APIC LVTT: 000200ef
... APIC LVTPC: 00000400
... APIC LVT0: 00010700
... APIC LVT1: 00000400
... APIC LVTERR: 000000fe
... APIC TMICT: 00003112
... APIC TMCCT: 000026f1
... APIC TDCR: 00000003

number of MP IRQ sources: 16.
number of IO-APIC #2 registers: 24.
testing the IO APIC.......................

IO APIC #2......
.... register #00: 00000000
.......    : physical APIC id: 00
.......    : Delivery Type: 0
.......    : LTS          : 0
.... register #01: 00170011
.......     : max redirection entries: 0017
.......     : PRQ implemented: 0
.......     : IO APIC version: 0011
.... register #02: 00000000
.......     : arbitration: 00
.... IRQ redirection table:
 NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:
 00 003 0    0    0   0   0    1    1    30
 01 003 0    0    0   0   0    1    1    31
 02 003 1    0    0   0   0    0    0    32
 03 003 1    0    0   0   0    1    1    33
 04 003 0    0    0   0   0    1    1    34
 05 003 1    0    0   0   0    1    1    35
 06 003 0    0    0   0   0    1    1    36
 07 003 1    0    0   0   0    1    1    37
 08 003 0    0    0   0   0    1    1    38
 09 003 0    1    0   0   0    1    1    39
 0a 003 0    0    0   0   0    1    1    3A
 0b 003 1    0    0   0   0    1    1    3B
 0c 003 0    0    0   0   0    1    1    3C
 0d 003 0    0    0   0   0    1    1    3D
 0e 003 0    0    0   0   0    1    1    3E
 0f 003 0    0    0   0   0    1    1    3F
 10 000 1    0    0   0   0    0    0    00
 11 000 1    0    0   0   0    0    0    00
 12 000 1    0    0   0   0    0    0    00
 13 000 1    0    0   0   0    0    0    00
 14 000 1    0    0   0   0    0    0    00
 15 000 1    0    0   0   0    0    0    00
 16 000 1    0    0   0   0    0    0    00
 17 000 1    0    0   0   0    0    0    00
IRQ to pin mappings:
IRQ0 -> 0:0
IRQ1 -> 0:1
IRQ2 -> 0:2
IRQ3 -> 0:3
IRQ4 -> 0:4
IRQ5 -> 0:5
IRQ6 -> 0:6
IRQ7 -> 0:7
IRQ8 -> 0:8
IRQ9 -> 0:9
IRQ10 -> 0:10
IRQ11 -> 0:11
IRQ12 -> 0:12
IRQ13 -> 0:13
IRQ14 -> 0:14
IRQ15 -> 0:15
.................................... done.
initcall print_ICs+0x0/0x491 returned 0 after 83971 usecs
calling  hpet_late_init+0x0/0xdd @ 1
initcall hpet_late_init+0x0/0xdd returned -19 after 0 usecs
calling  init_amd_nbs+0x0/0xb7 @ 1
initcall init_amd_nbs+0x0/0xb7 returned 0 after 0 usecs
calling  clocksource_done_booting+0x0/0x4f @ 1
initcall clocksource_done_booting+0x0/0x4f returned 0 after 0 usecs
calling  ftrace_init_debugfs+0x0/0x33 @ 1
initcall ftrace_init_debugfs+0x0/0x33 returned 0 after 0 usecs
calling  rb_init_debugfs+0x0/0x2f @ 1
initcall rb_init_debugfs+0x0/0x2f returned 0 after 0 usecs
calling  tracer_init_debugfs+0x0/0x32e @ 1
initcall tracer_init_debugfs+0x0/0x32e returned 0 after 0 usecs
calling  init_trace_printk_function_export+0x0/0x33 @ 1
initcall init_trace_printk_function_export+0x0/0x33 returned 0 after 0 usecs
calling  event_trace_init+0x0/0x269 @ 1
initcall event_trace_init+0x0/0x269 returned 0 after 7811 usecs
calling  init_pipe_fs+0x0/0x3d @ 1
initcall init_pipe_fs+0x0/0x3d returned 0 after 0 usecs
calling  eventpoll_init+0x0/0xef @ 1
initcall eventpoll_init+0x0/0xef returned 0 after 0 usecs
calling  anon_inode_init+0x0/0x102 @ 1
initcall anon_inode_init+0x0/0x102 returned 0 after 0 usecs
calling  fscache_init+0x0/0x1d0 @ 1
FS-Cache: Loaded
initcall fscache_init+0x0/0x1d0 returned 0 after 976 usecs
calling  cachefiles_init+0x0/0x99 @ 1
CacheFiles: Loaded
initcall cachefiles_init+0x0/0x99 returned 0 after 1952 usecs
calling  blk_scsi_ioctl_init+0x0/0x288 @ 1
initcall blk_scsi_ioctl_init+0x0/0x288 returned 0 after 0 usecs
calling  acpi_event_init+0x0/0x76 @ 1
initcall acpi_event_init+0x0/0x76 returned 0 after 0 usecs
calling  pnp_system_init+0x0/0xf @ 1
initcall pnp_system_init+0x0/0xf returned 0 after 0 usecs
calling  pnpacpi_init+0x0/0x88 @ 1
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp 00:00: [bus 00-ff]
pnp 00:00: [io  0x0cf8-0x0cff]
pnp 00:00: [io  0x0000-0x0cf7 window]
pnp 00:00: [io  0x0d00-0xffff window]
pnp 00:00: [mem 0x000a0000-0x000bffff window]
pnp 00:00: [mem 0x000c0000-0x000dffff window]
pnp 00:00: [mem 0x40000000-0xfebfffff window]
pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
pnp 00:01: [io  0x4000-0x407f]
pnp 00:01: [io  0x4080-0x40ff]
pnp 00:01: [io  0x4400-0x447f]
pnp 00:01: [io  0x4480-0x44ff]
pnp 00:01: [io  0x4800-0x487f]
pnp 00:01: [io  0x4880-0x48ff]
system 00:01: [io  0x4000-0x407f] has been reserved
system 00:01: [io  0x4080-0x40ff] has been reserved
system 00:01: [io  0x4400-0x447f] has been reserved
system 00:01: [io  0x4480-0x44ff] has been reserved
system 00:01: [io  0x4800-0x487f] has been reserved
system 00:01: [io  0x4880-0x48ff] has been reserved
system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
pnp 00:02: [io  0x0010-0x001f]
pnp 00:02: [io  0x0022-0x003f]
pnp 00:02: [io  0x0044-0x005f]
pnp 00:02: [io  0x0062-0x0063]
pnp 00:02: [io  0x0065-0x006f]
pnp 00:02: [io  0x0074-0x007f]
pnp 00:02: [io  0x0091-0x0093]
pnp 00:02: [io  0x00a2-0x00bf]
pnp 00:02: [io  0x00e0-0x00ef]
pnp 00:02: [io  0x04d0-0x04d1]
pnp 00:02: [io  0x0800-0x0805]
pnp 00:02: [io  0x0290-0x0297]
system 00:02: [io  0x04d0-0x04d1] has been reserved
system 00:02: [io  0x0800-0x0805] has been reserved
system 00:02: [io  0x0290-0x0297] has been reserved
system 00:02: Plug and Play ACPI device, IDs PNP0c02 (active)
pnp 00:03: [dma 4]
pnp 00:03: [io  0x0000-0x000f]
pnp 00:03: [io  0x0080-0x0090]
pnp 00:03: [io  0x0094-0x009f]
pnp 00:03: [io  0x00c0-0x00df]
pnp 00:03: Plug and Play ACPI device, IDs PNP0200 (active)
pnp 00:04: [io  0x0070-0x0073]
IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0)
pnp 00:04: [irq 8]
pnp 00:04: Plug and Play ACPI device, IDs PNP0b00 (active)
pnp 00:05: [io  0x0061]
pnp 00:05: Plug and Play ACPI device, IDs PNP0800 (active)
pnp 00:06: [io  0x00f0-0x00ff]
IOAPIC[0]: Set routing entry (2-13 -> 0x3d -> IRQ 13 Mode:0 Active:0)
pnp 00:06: [irq 13]
pnp 00:06: Plug and Play ACPI device, IDs PNP0c04 (active)
pnp 00:07: [io  0x03f0-0x03f5]
pnp 00:07: [io  0x03f7]
IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Active:0)
pnp 00:07: [irq 6]
pnp 00:07: [dma 2]
pnp 00:07: Plug and Play ACPI device, IDs PNP0700 (active)
pnp 00:08: [io  0x03f8-0x03ff]
IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0)
pnp 00:08: [irq 4]
pnp 00:08: Plug and Play ACPI device, IDs PNP0501 (active)
pnp 00:09: [io  0x0378-0x037f]
pnp 00:09: [io  0x0778-0x077b]
IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Active:0)
pnp 00:09: [irq 7]
pnp 00:09: [dma 3]
pnp 00:09: Plug and Play ACPI device, IDs PNP0401 (active)
IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 Active:0)
pnp 00:0a: [irq 12]
pnp 00:0a: Plug and Play ACPI device, IDs PNP0f13 (active)
pnp 00:0b: [io  0x0060]
pnp 00:0b: [io  0x0064]
IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0)
pnp 00:0b: [irq 1]
pnp 00:0b: Plug and Play ACPI device, IDs PNP0303 PNP030b (active)
pnp 00:0c: [io  0x0330-0x0331]
IOAPIC[0]: Set routing entry (2-10 -> 0x3a -> IRQ 10 Mode:0 Active:0)
pnp 00:0c: [irq 10]
pnp 00:0c: Plug and Play ACPI device, IDs PNPb006 (active)
pnp 00:0d: [io  0x0201]
pnp 00:0d: Plug and Play ACPI device, IDs PNPb02f (active)
pnp 00:0e: [mem 0xe0000000-0xefffffff]
system 00:0e: [mem 0xe0000000-0xefffffff] has been reserved
system 00:0e: Plug and Play ACPI device, IDs PNP0c02 (active)
pnp 00:0f: [mem 0x000f0000-0x000f3fff]
pnp 00:0f: [mem 0x000f4000-0x000f7fff]
pnp 00:0f: [mem 0x000f8000-0x000fbfff]
pnp 00:0f: [mem 0x000fc000-0x000fffff]
pnp 00:0f: [mem 0x3fff0000-0x3fffffff]
pnp 00:0f: [mem 0xffff0000-0xffffffff]
pnp 00:0f: [mem 0x00000000-0x0009ffff]
pnp 00:0f: [mem 0x00100000-0x3ffeffff]
pnp 00:0f: [mem 0xfec00000-0xfec00fff]
pnp 00:0f: [mem 0xfee00000-0xfeefffff]
pnp 00:0f: [mem 0xfefff000-0xfeffffff]
pnp 00:0f: [mem 0xfff80000-0xfff80fff]
pnp 00:0f: [mem 0xfff90000-0xfffbffff]
pnp 00:0f: [mem 0xfffed000-0xfffeffff]
system 00:0f: [mem 0x000f0000-0x000f3fff] could not be reserved
system 00:0f: [mem 0x000f4000-0x000f7fff] could not be reserved
system 00:0f: [mem 0x000f8000-0x000fbfff] could not be reserved
system 00:0f: [mem 0x000fc000-0x000fffff] could not be reserved
system 00:0f: [mem 0x3fff0000-0x3fffffff] could not be reserved
system 00:0f: [mem 0xffff0000-0xffffffff] has been reserved
system 00:0f: [mem 0x00000000-0x0009ffff] could not be reserved
system 00:0f: [mem 0x00100000-0x3ffeffff] could not be reserved
system 00:0f: [mem 0xfec00000-0xfec00fff] could not be reserved
system 00:0f: [mem 0xfee00000-0xfeefffff] has been reserved
system 00:0f: [mem 0xfefff000-0xfeffffff] has been reserved
system 00:0f: [mem 0xfff80000-0xfff80fff] has been reserved
system 00:0f: [mem 0xfff90000-0xfffbffff] has been reserved
system 00:0f: [mem 0xfffed000-0xfffeffff] has been reserved
system 00:0f: Plug and Play ACPI device, IDs PNP0c01 (active)
pnp: PnP ACPI: found 16 devices
ACPI: ACPI bus type pnp unregistered
initcall pnpacpi_init+0x0/0x88 returned 0 after 203093 usecs
calling  pnpbios_init+0x0/0x35c @ 1
PnPBIOS: Disabled by ACPI PNP
initcall pnpbios_init+0x0/0x35c returned -19 after 976 usecs
calling  chr_dev_init+0x0/0xc3 @ 1
initcall chr_dev_init+0x0/0xc3 returned 0 after 4882 usecs
calling  firmware_class_init+0x0/0x14 @ 1
initcall firmware_class_init+0x0/0x14 returned 0 after 0 usecs
calling  init_pcmcia_bus+0x0/0x5e @ 1
initcall init_pcmcia_bus+0x0/0x5e returned 0 after 0 usecs
calling  thermal_init+0x0/0x5f @ 1
initcall thermal_init+0x0/0x5f returned 0 after 0 usecs
calling  cpufreq_gov_performance_init+0x0/0xf @ 1
initcall cpufreq_gov_performance_init+0x0/0xf returned 0 after 0 usecs
calling  intel_mid_dma_init+0x0/0x16 @ 1
initcall intel_mid_dma_init+0x0/0x16 returned 0 after 0 usecs
calling  init_acpi_pm_clocksource+0x0/0x174 @ 1
Switching to clocksource acpi_pm
initcall init_acpi_pm_clocksource+0x0/0x174 returned 0 after 35155 usecs
calling  pcibios_assign_resources+0x0/0x66 @ 1
pci 0000:00:02.1: BAR 0: assigned [mem 0x40000000-0x400000ff]
pci 0000:00:02.1: BAR 0: set to [mem 0x40000000-0x400000ff] (PCI address [0x40000000-0x400000ff])
pci 0000:00:09.0: PCI bridge to [bus 05-05]
pci 0000:00:09.0:   bridge window [io  0xc000-0xcfff]
pci 0000:00:09.0:   bridge window [mem 0xda000000-0xda0fffff]
pci 0000:00:09.0:   bridge window [mem pref disabled]
pci 0000:00:0b.0: PCI bridge to [bus 04-04]
pci 0000:00:0b.0:   bridge window [io  disabled]
pci 0000:00:0b.0:   bridge window [mem disabled]
pci 0000:00:0b.0:   bridge window [mem pref disabled]
pci 0000:00:0c.0: PCI bridge to [bus 03-03]
pci 0000:00:0c.0:   bridge window [io  disabled]
pci 0000:00:0c.0:   bridge window [mem disabled]
pci 0000:00:0c.0:   bridge window [mem pref disabled]
pci 0000:00:0d.0: PCI bridge to [bus 02-02]
pci 0000:00:0d.0:   bridge window [io  disabled]
pci 0000:00:0d.0:   bridge window [mem disabled]
pci 0000:00:0d.0:   bridge window [mem pref disabled]
pci 0000:01:00.0: BAR 6: assigned [mem 0xd8000000-0xd801ffff pref]
pci 0000:00:0e.0: PCI bridge to [bus 01-01]
pci 0000:00:0e.0:   bridge window [io  0xb000-0xbfff]
pci 0000:00:0e.0:   bridge window [mem 0xd8000000-0xd9ffffff]
pci 0000:00:0e.0:   bridge window [mem 0xd0000000-0xd7ffffff 64bit pref]
pci 0000:00:09.0: setting latency timer to 64
pci 0000:00:0b.0: setting latency timer to 64
pci 0000:00:0c.0: setting latency timer to 64
pci 0000:00:0d.0: setting latency timer to 64
pci 0000:00:0e.0: setting latency timer to 64
pci_bus 0000:00: resource 4 [io  0x0000-0xffff]
pci_bus 0000:00: resource 5 [mem 0x40000000-0xffffffff]
pci_bus 0000:00: resource 6 [mem 0xfeb00000-0xfec0ffff]
pci_bus 0000:00: resource 7 [mem 0x000a0000-0x000bffff]
pci_bus 0000:05: resource 0 [io  0xc000-0xcfff]
pci_bus 0000:05: resource 1 [mem 0xda000000-0xda0fffff]
pci_bus 0000:05: resource 4 [io  0x0000-0xffff]
pci_bus 0000:05: resource 5 [mem 0x40000000-0xffffffff]
pci_bus 0000:05: resource 6 [mem 0xfeb00000-0xfec0ffff]
pci_bus 0000:05: resource 7 [mem 0x000a0000-0x000bffff]
pci_bus 0000:01: resource 0 [io  0xb000-0xbfff]
pci_bus 0000:01: resource 1 [mem 0xd8000000-0xd9ffffff]
pci_bus 0000:01: resource 2 [mem 0xd0000000-0xd7ffffff 64bit pref]
initcall pcibios_assign_resources+0x0/0x66 returned 0 after 190713 usecs
calling  sysctl_core_init+0x0/0x2d @ 1
initcall sysctl_core_init+0x0/0x2d returned 0 after 20 usecs
calling  inet_init+0x0/0x20c @ 1
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
UDP hash table entries: 512 (order: 2, 16384 bytes)
UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
initcall inet_init+0x0/0x20c returned 0 after 38094 usecs
calling  af_unix_init+0x0/0x4d @ 1
NET: Registered protocol family 1
initcall af_unix_init+0x0/0x4d returned 0 after 3002 usecs
calling  init_sunrpc+0x0/0x69 @ 1
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
RPC: Registered tcp NFSv4.1 backchannel transport module.
initcall init_sunrpc+0x0/0x69 returned 0 after 11800 usecs
calling  pci_apply_final_quirks+0x0/0x100 @ 1
pci 0000:00:00.0: Found enabled HT MSI Mapping
pci 0000:00:0b.0: Found disabled HT MSI Mapping
pci 0000:00:00.0: Found enabled HT MSI Mapping
pci 0000:00:0b.0: Linking AER extended capability
pci 0000:00:00.0: Found enabled HT MSI Mapping
pci 0000:00:0c.0: Found disabled HT MSI Mapping
pci 0000:00:00.0: Found enabled HT MSI Mapping
pci 0000:00:0c.0: Linking AER extended capability
pci 0000:00:00.0: Found enabled HT MSI Mapping
pci 0000:00:0d.0: Found disabled HT MSI Mapping
pci 0000:00:00.0: Found enabled HT MSI Mapping
pci 0000:00:0d.0: Linking AER extended capability
pci 0000:00:00.0: Found enabled HT MSI Mapping
pci 0000:00:0e.0: Found disabled HT MSI Mapping
pci 0000:00:00.0: Found enabled HT MSI Mapping
pci 0000:00:0e.0: Linking AER extended capability
pci 0000:01:00.0: Boot video device
PCI: CLS 32 bytes, default 64
initcall pci_apply_final_quirks+0x0/0x100 returned 0 after 85200 usecs
calling  populate_rootfs+0x0/0x215 @ 1
initcall populate_rootfs+0x0/0x215 returned 0 after 59 usecs
calling  pci_iommu_init+0x0/0x34 @ 1
initcall pci_iommu_init+0x0/0x34 returned 0 after 2 usecs
calling  i8259A_init_ops+0x0/0x1d @ 1
initcall i8259A_init_ops+0x0/0x1d returned 0 after 2 usecs
calling  sbf_init+0x0/0xc0 @ 1
initcall sbf_init+0x0/0xc0 returned 0 after 1 usecs
calling  init_tsc_clocksource+0x0/0x58 @ 1
initcall init_tsc_clocksource+0x0/0x58 returned 0 after 4 usecs
calling  add_rtc_cmos+0x0/0x7e @ 1
initcall add_rtc_cmos+0x0/0x7e returned 0 after 5 usecs
calling  i8237A_init_ops+0x0/0x11 @ 1
initcall i8237A_init_ops+0x0/0x11 returned 0 after 10 usecs
calling  cache_sysfs_init+0x0/0x5a @ 1
initcall cache_sysfs_init+0x0/0x5a returned 0 after 400 usecs
calling  mcheck_init_device+0x0/0xe1 @ 1
initcall mcheck_init_device+0x0/0xe1 returned 0 after 224 usecs
calling  threshold_init_device+0x0/0x44 @ 1
initcall threshold_init_device+0x0/0x44 returned 0 after 3 usecs
calling  inject_init+0x0/0x2d @ 1
Machine check injector initialized
initcall inject_init+0x0/0x2d returned 0 after 3071 usecs
calling  thermal_throttle_init_device+0x0/0x77 @ 1
initcall thermal_throttle_init_device+0x0/0x77 returned 0 after 1 usecs
calling  powernow_k6_init+0x0/0x8b @ 1
initcall powernow_k6_init+0x0/0x8b returned -19 after 1 usecs
calling  eps_init+0x0/0x3e @ 1
initcall eps_init+0x0/0x3e returned -19 after 1 usecs
calling  elanfreq_init+0x0/0x3d @ 1
elanfreq: error: no Elan processor found!
initcall elanfreq_init+0x0/0x3d returned -19 after 3665 usecs
calling  sc520_freq_init+0x0/0x6c @ 1
initcall sc520_freq_init+0x0/0x6c returned -19 after 1 usecs
calling  longrun_init+0x0/0x2d @ 1
initcall longrun_init+0x0/0x2d returned -19 after 1 usecs
calling  cpufreq_gx_init+0x0/0x13d @ 1
initcall cpufreq_gx_init+0x0/0x13d returned -19 after 2 usecs
calling  speedstep_init+0x0/0x1a9 @ 1
initcall speedstep_init+0x0/0x1a9 returned -19 after 2 usecs
calling  speedstep_init+0x0/0xb5 @ 1
initcall speedstep_init+0x0/0xb5 returned -19 after 2 usecs
calling  nforce2_init+0x0/0x6f @ 1
cpufreq-nforce2: No nForce2 chipset.
initcall nforce2_init+0x0/0x6f returned -19 after 3257 usecs
calling  msr_init+0x0/0x100 @ 1
initcall msr_init+0x0/0x100 returned 0 after 192 usecs
calling  cpuid_init+0x0/0x100 @ 1
initcall cpuid_init+0x0/0x100 returned 0 after 181 usecs
calling  apm_init+0x0/0x39a @ 1
apm: BIOS version 1.2 Flags 0x07 (Driver version 1.16ac)
apm: disabled - APM is not SMP safe.
initcall apm_init+0x0/0x39a returned -19 after 8209 usecs
calling  ioapic_init_ops+0x0/0x54 @ 1
initcall ioapic_init_ops+0x0/0x54 returned 0 after 3 usecs
calling  add_pcspkr+0x0/0x43 @ 1
initcall add_pcspkr+0x0/0x43 returned 0 after 58 usecs
calling  microcode_init+0x0/0x12a @ 1
microcode: CPU0: family 15 not supported
initcall microcode_init+0x0/0x12a returned -22 after 3696 usecs
initcall microcode_init+0x0/0x12a returned with error code -22 
calling  start_periodic_check_for_corruption+0x0/0x46 @ 1
initcall start_periodic_check_for_corruption+0x0/0x46 returned 0 after 2 usecs
calling  add_bus_probe+0x0/0x1c @ 1
initcall add_bus_probe+0x0/0x1c returned 0 after 1 usecs
calling  aes_init+0x0/0xf @ 1
initcall aes_init+0x0/0xf returned 0 after 34 usecs
calling  init+0x0/0xf @ 1
initcall init+0x0/0xf returned 0 after 34 usecs
calling  iris_init+0x0/0x5f @ 1
The force parameter has not been set to 1 so the Iris poweroff handler will not be installed.
initcall iris_init+0x0/0x5f returned -19 after 8068 usecs
calling  scx200_init+0x0/0x23 @ 1
scx200: NatSemi SCx200 Driver
initcall scx200_init+0x0/0x23 returned 0 after 2725 usecs
calling  proc_execdomains_init+0x0/0x27 @ 1
initcall proc_execdomains_init+0x0/0x27 returned 0 after 6 usecs
calling  ioresources_init+0x0/0x44 @ 1
initcall ioresources_init+0x0/0x44 returned 0 after 4 usecs
calling  uid_cache_init+0x0/0x83 @ 1
initcall uid_cache_init+0x0/0x83 returned 0 after 7 usecs
calling  init_posix_timers+0x0/0x18f @ 1
initcall init_posix_timers+0x0/0x18f returned 0 after 5 usecs
calling  init_posix_cpu_timers+0x0/0x9b @ 1
initcall init_posix_cpu_timers+0x0/0x9b returned 0 after 2 usecs
calling  nsproxy_cache_init+0x0/0x32 @ 1
initcall nsproxy_cache_init+0x0/0x32 returned 0 after 3 usecs
calling  create_proc_profile+0x0/0x1a3 @ 1
initcall create_proc_profile+0x0/0x1a3 returned 0 after 2 usecs
calling  timekeeping_init_ops+0x0/0x11 @ 1
initcall timekeeping_init_ops+0x0/0x11 returned 0 after 2 usecs
calling  init_clocksource_sysfs+0x0/0x43 @ 1
initcall init_clocksource_sysfs+0x0/0x43 returned 0 after 83 usecs
calling  init_timer_list_procfs+0x0/0x30 @ 1
initcall init_timer_list_procfs+0x0/0x30 returned 0 after 3 usecs
calling  futex_init+0x0/0x57 @ 1
initcall futex_init+0x0/0x57 returned 0 after 6 usecs
calling  proc_dma_init+0x0/0x27 @ 1
initcall proc_dma_init+0x0/0x27 returned 0 after 3 usecs
calling  proc_modules_init+0x0/0x27 @ 1
initcall proc_modules_init+0x0/0x27 returned 0 after 3 usecs
calling  kallsyms_init+0x0/0x2a @ 1
initcall kallsyms_init+0x0/0x2a returned 0 after 2 usecs
calling  snapshot_device_init+0x0/0xf @ 1
initcall snapshot_device_init+0x0/0xf returned 0 after 64 usecs
calling  user_namespaces_init+0x0/0x32 @ 1
initcall user_namespaces_init+0x0/0x32 returned 0 after 19 usecs
calling  pid_namespaces_init+0x0/0x32 @ 1
initcall pid_namespaces_init+0x0/0x32 returned 0 after 2 usecs
calling  ikconfig_init+0x0/0x43 @ 1
initcall ikconfig_init+0x0/0x43 returned 0 after 3 usecs
calling  audit_init+0x0/0x130 @ 1
audit: initializing netlink socket (disabled)
type=2000 audit(1304541769.146:1): initialized
initcall audit_init+0x0/0x130 returned 0 after 8099 usecs
calling  audit_watch_init+0x0/0x31 @ 1
initcall audit_watch_init+0x0/0x31 returned 0 after 2 usecs
calling  audit_tree_init+0x0/0x42 @ 1
initcall audit_tree_init+0x0/0x42 returned 0 after 3 usecs
calling  utsname_sysctl_init+0x0/0x11 @ 1
initcall utsname_sysctl_init+0x0/0x11 returned 0 after 18 usecs
calling  init_tracepoints+0x0/0x14 @ 1
initcall init_tracepoints+0x0/0x14 returned 0 after 2 usecs
calling  ftrace_nodyn_init+0x0/0x11 @ 1
initcall ftrace_nodyn_init+0x0/0x11 returned 0 after 1 usecs
calling  init_events+0x0/0x5d @ 1
initcall init_events+0x0/0x5d returned 0 after 7 usecs
calling  init_function_trace+0x0/0xf @ 1
initcall init_function_trace+0x0/0xf returned 0 after 7 usecs
calling  perf_event_sysfs_init+0x0/0x95 @ 1
initcall perf_event_sysfs_init+0x0/0x95 returned 0 after 255 usecs
calling  init_per_zone_wmark_min+0x0/0x65 @ 1
initcall init_per_zone_wmark_min+0x0/0x65 returned 0 after 40 usecs
calling  kswapd_init+0x0/0x1d @ 1
initcall kswapd_init+0x0/0x1d returned 0 after 56 usecs
calling  extfrag_debug_init+0x0/0x78 @ 1
initcall extfrag_debug_init+0x0/0x78 returned 0 after 15 usecs
calling  setup_vmstat+0x0/0xca @ 1
initcall setup_vmstat+0x0/0xca returned 0 after 9 usecs
calling  mm_sysfs_init+0x0/0x22 @ 1
initcall mm_sysfs_init+0x0/0x22 returned 0 after 5 usecs
calling  proc_vmalloc_init+0x0/0x2a @ 1
initcall proc_vmalloc_init+0x0/0x2a returned 0 after 2 usecs
calling  init_emergency_pool+0x0/0x79 @ 1
highmem bounce pool size: 64 pages
initcall init_emergency_pool+0x0/0x79 returned 0 after 3089 usecs
calling  procswaps_init+0x0/0x27 @ 1
initcall procswaps_init+0x0/0x27 returned 0 after 3 usecs
calling  hugetlb_init+0x0/0x2a7 @ 1
HugeTLB registered 4 MB page size, pre-allocated 0 pages
initcall hugetlb_init+0x0/0x2a7 returned 0 after 4948 usecs
calling  ksm_init+0x0/0x15c @ 1
initcall ksm_init+0x0/0x15c returned 0 after 40 usecs
calling  slab_proc_init+0x0/0x2a @ 1
initcall slab_proc_init+0x0/0x2a returned 0 after 6 usecs
calling  slab_sysfs_init+0x0/0xec @ 1
initcall slab_sysfs_init+0x0/0xec returned 0 after 4569 usecs
calling  hugepage_init+0x0/0x122 @ 1
initcall hugepage_init+0x0/0x122 returned 0 after 160 usecs
calling  fcntl_init+0x0/0x2f @ 1
initcall fcntl_init+0x0/0x2f returned 0 after 24 usecs
calling  proc_filesystems_init+0x0/0x27 @ 1
initcall proc_filesystems_init+0x0/0x27 returned 0 after 4 usecs
calling  fsnotify_mark_init+0x0/0x46 @ 1
initcall fsnotify_mark_init+0x0/0x46 returned 0 after 30 usecs
calling  dnotify_init+0x0/0x7c @ 1
initcall dnotify_init+0x0/0x7c returned 0 after 100 usecs
calling  inotify_user_setup+0x0/0x78 @ 1
initcall inotify_user_setup+0x0/0x78 returned 0 after 14 usecs
calling  fanotify_user_setup+0x0/0x5a @ 1
initcall fanotify_user_setup+0x0/0x5a returned 0 after 89 usecs
calling  aio_setup+0x0/0x85 @ 1
initcall aio_setup+0x0/0x85 returned 0 after 28 usecs
calling  proc_locks_init+0x0/0x27 @ 1
initcall proc_locks_init+0x0/0x27 returned 0 after 7 usecs
calling  init_mbcache+0x0/0x11 @ 1
initcall init_mbcache+0x0/0x11 returned 0 after 2 usecs
calling  dquot_init+0x0/0x111 @ 1
VFS: Disk quotas dquot_6.5.2
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
initcall dquot_init+0x0/0x111 returned 0 after 7848 usecs
calling  init_v1_quota_format+0x0/0xf @ 1
initcall init_v1_quota_format+0x0/0xf returned 0 after 1 usecs
calling  init_v2_quota_format+0x0/0x1d @ 1
initcall init_v2_quota_format+0x0/0x1d returned 0 after 1 usecs
calling  quota_init+0x0/0x22 @ 1
initcall quota_init+0x0/0x22 returned 0 after 6 usecs
calling  proc_cmdline_init+0x0/0x27 @ 1
initcall proc_cmdline_init+0x0/0x27 returned 0 after 3 usecs
calling  proc_consoles_init+0x0/0x27 @ 1
initcall proc_consoles_init+0x0/0x27 returned 0 after 3 usecs
calling  proc_cpuinfo_init+0x0/0x27 @ 1
initcall proc_cpuinfo_init+0x0/0x27 returned 0 after 3 usecs
calling  proc_devices_init+0x0/0x27 @ 1
initcall proc_devices_init+0x0/0x27 returned 0 after 3 usecs
calling  proc_interrupts_init+0x0/0x27 @ 1
initcall proc_interrupts_init+0x0/0x27 returned 0 after 3 usecs
calling  proc_loadavg_init+0x0/0x27 @ 1
initcall proc_loadavg_init+0x0/0x27 returned 0 after 2 usecs
calling  proc_meminfo_init+0x0/0x27 @ 1
initcall proc_meminfo_init+0x0/0x27 returned 0 after 2 usecs
calling  proc_stat_init+0x0/0x27 @ 1
initcall proc_stat_init+0x0/0x27 returned 0 after 3 usecs
calling  proc_uptime_init+0x0/0x27 @ 1
initcall proc_uptime_init+0x0/0x27 returned 0 after 3 usecs
calling  proc_version_init+0x0/0x27 @ 1
initcall proc_version_init+0x0/0x27 returned 0 after 3 usecs
calling  proc_softirqs_init+0x0/0x27 @ 1
initcall proc_softirqs_init+0x0/0x27 returned 0 after 2 usecs
calling  proc_kcore_init+0x0/0xb4 @ 1
initcall proc_kcore_init+0x0/0xb4 returned 0 after 4 usecs
calling  proc_kmsg_init+0x0/0x2a @ 1
initcall proc_kmsg_init+0x0/0x2a returned 0 after 2 usecs
calling  proc_page_init+0x0/0x4a @ 1
initcall proc_page_init+0x0/0x4a returned 0 after 4 usecs
calling  configfs_init+0x0/0xa6 @ 1
initcall configfs_init+0x0/0xa6 returned 0 after 121 usecs
calling  init_devpts_fs+0x0/0x3d @ 1
initcall init_devpts_fs+0x0/0x3d returned 0 after 31 usecs
calling  init_dlm+0x0/0x88 @ 1
DLM (built May  4 2011 11:04:28) installed
initcall init_dlm+0x0/0x88 returned 0 after 4073 usecs
calling  init_reiserfs_fs+0x0/0x5a @ 1
initcall init_reiserfs_fs+0x0/0x5a returned 0 after 82 usecs
calling  init_ext3_fs+0x0/0x6c @ 1
initcall init_ext3_fs+0x0/0x6c returned 0 after 163 usecs
calling  init_ext2_fs+0x0/0x6c @ 1
initcall init_ext2_fs+0x0/0x6c returned 0 after 103 usecs
calling  ext4_init_fs+0x0/0x1cd @ 1
initcall ext4_init_fs+0x0/0x1cd returned 0 after 512 usecs
calling  journal_init+0x0/0x97 @ 1
initcall journal_init+0x0/0x97 returned 0 after 252 usecs
calling  journal_init+0x0/0x103 @ 1
initcall journal_init+0x0/0x103 returned 0 after 116 usecs
calling  init_cramfs_fs+0x0/0x28 @ 1
initcall init_cramfs_fs+0x0/0x28 returned 0 after 10 usecs
calling  init_squashfs_fs+0x0/0x64 @ 1
squashfs: version 4.0 (2009/01/31) Phillip Lougher
initcall init_squashfs_fs+0x0/0x64 returned 0 after 4514 usecs
calling  init_ramfs_fs+0x0/0xf @ 1
initcall init_ramfs_fs+0x0/0xf returned 0 after 2 usecs
calling  init_hugetlbfs_fs+0x0/0x8b @ 1
initcall init_hugetlbfs_fs+0x0/0x8b returned 0 after 138 usecs
calling  init_coda+0x0/0x170 @ 1
initcall init_coda+0x0/0x170 returned 0 after 421 usecs
calling  init_minix_fs+0x0/0x5a @ 1
initcall init_minix_fs+0x0/0x5a returned 0 after 83 usecs
calling  init_fat_fs+0x0/0x4c @ 1
initcall init_fat_fs+0x0/0x4c returned 0 after 167 usecs
calling  init_vfat_fs+0x0/0xf @ 1
initcall init_vfat_fs+0x0/0xf returned 0 after 2 usecs
calling  init_msdos_fs+0x0/0xf @ 1
initcall init_msdos_fs+0x0/0xf returned 0 after 2 usecs
calling  init_bfs_fs+0x0/0x5a @ 1
initcall init_bfs_fs+0x0/0x5a returned 0 after 82 usecs
calling  init_iso9660_fs+0x0/0x6a @ 1
initcall init_iso9660_fs+0x0/0x6a returned 0 after 84 usecs
calling  init_hfsplus_fs+0x0/0x56 @ 1
initcall init_hfsplus_fs+0x0/0x56 returned 0 after 80 usecs
calling  init_hfs_fs+0x0/0x56 @ 1
initcall init_hfs_fs+0x0/0x56 returned 0 after 83 usecs
calling  ecryptfs_init+0x0/0x1cc @ 1
initcall ecryptfs_init+0x0/0x1cc returned 0 after 306 usecs
calling  vxfs_init+0x0/0x56 @ 1
initcall vxfs_init+0x0/0x56 returned 0 after 109 usecs
calling  init_nfs_fs+0x0/0x154 @ 1
Registering the id_resolver key type
FS-Cache: Netfs 'nfs' registered for caching
initcall init_nfs_fs+0x0/0x154 returned 0 after 7495 usecs
calling  nfs4filelayout_init+0x0/0x26 @ 1
nfs4filelayout_init: NFSv4 File Layout Driver Registering...
initcall nfs4filelayout_init+0x0/0x26 returned 0 after 5273 usecs
calling  init_nfsd+0x0/0xd4 @ 1
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
initcall init_nfsd+0x0/0xd4 returned 0 after 5160 usecs
calling  init_nlm+0x0/0x1c @ 1
initcall init_nlm+0x0/0x1c returned 0 after 15 usecs
calling  init_nls_cp437+0x0/0xf @ 1
initcall init_nls_cp437+0x0/0xf returned 0 after 1 usecs
calling  init_nls_cp850+0x0/0xf @ 1
initcall init_nls_cp850+0x0/0xf returned 0 after 1 usecs
calling  init_nls_cp852+0x0/0xf @ 1
initcall init_nls_cp852+0x0/0xf returned 0 after 1 usecs
calling  init_nls_cp860+0x0/0xf @ 1
initcall init_nls_cp860+0x0/0xf returned 0 after 1 usecs
calling  init_nls_cp864+0x0/0xf @ 1
initcall init_nls_cp864+0x0/0xf returned 0 after 1 usecs
calling  init_nls_cp866+0x0/0xf @ 1
initcall init_nls_cp866+0x0/0xf returned 0 after 1 usecs
calling  init_nls_cp932+0x0/0xf @ 1
initcall init_nls_cp932+0x0/0xf returned 0 after 1 usecs
calling  init_nls_euc_jp+0x0/0x39 @ 1
initcall init_nls_euc_jp+0x0/0x39 returned 0 after 2 usecs
calling  init_nls_cp936+0x0/0xf @ 1
initcall init_nls_cp936+0x0/0xf returned 0 after 1 usecs
calling  init_nls_iso8859_1+0x0/0xf @ 1
initcall init_nls_iso8859_1+0x0/0xf returned 0 after 1 usecs
calling  init_nls_iso8859_5+0x0/0xf @ 1
initcall init_nls_iso8859_5+0x0/0xf returned 0 after 1 usecs
calling  init_nls_iso8859_6+0x0/0xf @ 1
initcall init_nls_iso8859_6+0x0/0xf returned 0 after 1 usecs
calling  init_nls_iso8859_15+0x0/0xf @ 1
initcall init_nls_iso8859_15+0x0/0xf returned 0 after 1 usecs
calling  init_nls_koi8_r+0x0/0xf @ 1
initcall init_nls_koi8_r+0x0/0xf returned 0 after 1 usecs
calling  init_nls_utf8+0x0/0x1f @ 1
initcall init_nls_utf8+0x0/0x1f returned 0 after 1 usecs
calling  init_sysv_fs+0x0/0x43 @ 1
initcall init_sysv_fs+0x0/0x43 returned 0 after 86 usecs
calling  init_cifs+0x0/0x3ea @ 1
FS-Cache: Netfs 'cifs' registered for caching
initcall init_cifs+0x0/0x3ea returned 0 after 4223 usecs
calling  init_ncp_fs+0x0/0x5a @ 1
initcall init_ncp_fs+0x0/0x5a returned 0 after 85 usecs
calling  init_hpfs_fs+0x0/0x5a @ 1
initcall init_hpfs_fs+0x0/0x5a returned 0 after 83 usecs
calling  init_ntfs_fs+0x0/0x1c9 @ 1
NTFS driver 2.1.30 [Flags: R/W].
initcall init_ntfs_fs+0x0/0x1c9 returned 0 after 3123 usecs
calling  init_ufs_fs+0x0/0x5a @ 1
initcall init_ufs_fs+0x0/0x5a returned 0 after 82 usecs
calling  init_efs_fs+0x0/0x66 @ 1
EFS: 1.0a - http://aeschi.ch.eu.org/efs/
initcall init_efs_fs+0x0/0x66 returned 0 after 3666 usecs
calling  init_affs_fs+0x0/0x5a @ 1
initcall init_affs_fs+0x0/0x5a returned 0 after 86 usecs
calling  init_romfs_fs+0x0/0x7c @ 1
ROMFS MTD (C) 2007 Red Hat, Inc.
initcall init_romfs_fs+0x0/0x7c returned 0 after 2990 usecs
calling  init_qnx4_fs+0x0/0x68 @ 1
QNX4 filesystem 0.2.3 registered.
initcall init_qnx4_fs+0x0/0x68 returned 0 after 3075 usecs
calling  init_autofs4_fs+0x0/0x1e @ 1
initcall init_autofs4_fs+0x0/0x1e returned 0 after 80 usecs
calling  init_adfs_fs+0x0/0x5a @ 1
initcall init_adfs_fs+0x0/0x5a returned 0 after 82 usecs
calling  fuse_init+0x0/0x123 @ 1
fuse init (API version 7.16)
initcall fuse_init+0x0/0x123 returned 0 after 2818 usecs
calling  cuse_init+0x0/0x93 @ 1
initcall cuse_init+0x0/0x93 returned 0 after 127 usecs
calling  init_udf_fs+0x0/0x5a @ 1
initcall init_udf_fs+0x0/0x5a returned 0 after 82 usecs
calling  init_omfs_fs+0x0/0xf @ 1
initcall init_omfs_fs+0x0/0xf returned 0 after 3 usecs
calling  init_jfs_fs+0x0/0x1ad @ 1
JFS: nTxBlock = 7937, nTxLock = 63498
initcall init_jfs_fs+0x0/0x1ad returned 0 after 6557 usecs
calling  init_xfs_fs+0x0/0xce @ 1
SGI XFS with ACLs, security attributes, realtime, large block/inode numbers, no debug enabled
SGI XFS Quota Management subsystem
initcall init_xfs_fs+0x0/0xce returned 0 after 12280 usecs
calling  init_nilfs_fs+0x0/0xe1 @ 1
NILFS version 2 loaded
initcall init_nilfs_fs+0x0/0xe1 returned 0 after 2346 usecs
calling  init_befs_fs+0x0/0x78 @ 1
BeFS version: 0.9.3
initcall init_befs_fs+0x0/0x78 returned 0 after 1887 usecs
calling  ocfs2_init+0x0/0x308 @ 1
OCFS2 1.5.0
initcall ocfs2_init+0x0/0x308 returned 0 after 1371 usecs
calling  ocfs2_stack_glue_init+0x0/0x7d @ 1
initcall ocfs2_stack_glue_init+0x0/0x7d returned 0 after 16 usecs
calling  o2cb_stack_init+0x0/0xf @ 1
ocfs2: Registered cluster interface o2cb
initcall o2cb_stack_init+0x0/0xf returned 0 after 3579 usecs
calling  ocfs2_user_plugin_init+0x0/0x51 @ 1
ocfs2: Registered cluster interface user
initcall ocfs2_user_plugin_init+0x0/0x51 returned 0 after 3656 usecs
calling  init_dlmfs_fs+0x0/0xd8 @ 1
OCFS2 DLMFS 1.5.0
OCFS2 User DLM kernel interface loaded
initcall init_dlmfs_fs+0x0/0xd8 returned 0 after 5218 usecs
calling  init_o2nm+0x0/0x98 @ 1
OCFS2 Node Manager 1.5.0
initcall init_o2nm+0x0/0x98 returned 0 after 2349 usecs
calling  dlm_init+0x0/0x345 @ 1
OCFS2 DLM 1.5.0
initcall dlm_init+0x0/0x345 returned 0 after 1531 usecs
calling  init_btrfs_fs+0x0/0x9d @ 1
Btrfs loaded
initcall init_btrfs_fs+0x0/0x9d returned 0 after 1651 usecs
calling  init_gfs2_fs+0x0/0x29c @ 1
GFS2 (built May  4 2011 11:04:41) installed
initcall init_gfs2_fs+0x0/0x29c returned 0 after 4501 usecs
calling  init_exofs+0x0/0x5a @ 1
initcall init_exofs+0x0/0x5a returned 0 after 113 usecs
calling  init_ceph+0x0/0x119 @ 1
ceph: loaded (mds proto 32)
initcall init_ceph+0x0/0x119 returned 0 after 2617 usecs
calling  init_pstore_fs+0x0/0xf @ 1
initcall init_pstore_fs+0x0/0xf returned 0 after 4 usecs
calling  ipc_init+0x0/0x20 @ 1
msgmni has been set to 1712
initcall ipc_init+0x0/0x20 returned 0 after 2491 usecs
calling  ipc_sysctl_init+0x0/0x11 @ 1
initcall ipc_sysctl_init+0x0/0x11 returned 0 after 21 usecs
calling  init_mqueue_fs+0x0/0x9f @ 1
initcall init_mqueue_fs+0x0/0x9f returned 0 after 134 usecs
calling  key_proc_init+0x0/0x61 @ 1
initcall key_proc_init+0x0/0x61 returned 0 after 6 usecs
calling  crypto_wq_init+0x0/0x38 @ 1
initcall crypto_wq_init+0x0/0x38 returned 0 after 37 usecs
calling  crypto_algapi_init+0x0/0xc @ 1
initcall crypto_algapi_init+0x0/0xc returned 0 after 9 usecs
calling  skcipher_module_init+0x0/0x28 @ 1
initcall skcipher_module_init+0x0/0x28 returned 0 after 1 usecs
calling  chainiv_module_init+0x0/0xf @ 1
initcall chainiv_module_init+0x0/0xf returned 0 after 2 usecs
calling  eseqiv_module_init+0x0/0xf @ 1
initcall eseqiv_module_init+0x0/0xf returned 0 after 1 usecs
calling  hmac_module_init+0x0/0xf @ 1
initcall hmac_module_init+0x0/0xf returned 0 after 2 usecs
calling  crypto_xcbc_module_init+0x0/0xf @ 1
initcall crypto_xcbc_module_init+0x0/0xf returned 0 after 1 usecs
calling  crypto_null_mod_init+0x0/0x67 @ 1
initcall crypto_null_mod_init+0x0/0x67 returned 0 after 119 usecs
calling  md4_mod_init+0x0/0xf @ 1
initcall md4_mod_init+0x0/0xf returned 0 after 31 usecs
calling  md5_mod_init+0x0/0xf @ 1
initcall md5_mod_init+0x0/0xf returned 0 after 32 usecs
calling  sha1_generic_mod_init+0x0/0xf @ 1
initcall sha1_generic_mod_init+0x0/0xf returned 0 after 30 usecs
calling  sha256_generic_mod_init+0x0/0x33 @ 1
initcall sha256_generic_mod_init+0x0/0x33 returned 0 after 58 usecs
calling  sha512_generic_mod_init+0x0/0x33 @ 1
initcall sha512_generic_mod_init+0x0/0x33 returned 0 after 60 usecs
calling  wp512_mod_init+0x0/0x52 @ 1
initcall wp512_mod_init+0x0/0x52 returned 0 after 86 usecs
calling  tgr192_mod_init+0x0/0x52 @ 1
initcall tgr192_mod_init+0x0/0x52 returned 0 after 86 usecs
calling  crypto_ecb_module_init+0x0/0xf @ 1
initcall crypto_ecb_module_init+0x0/0xf returned 0 after 1 usecs
calling  crypto_cbc_module_init+0x0/0xf @ 1
initcall crypto_cbc_module_init+0x0/0xf returned 0 after 2 usecs
calling  crypto_pcbc_module_init+0x0/0xf @ 1
initcall crypto_pcbc_module_init+0x0/0xf returned 0 after 2 usecs
calling  crypto_module_init+0x0/0xf @ 1
initcall crypto_module_init+0x0/0xf returned 0 after 1 usecs
calling  crypto_module_init+0x0/0xf @ 1
initcall crypto_module_init+0x0/0xf returned 0 after 1 usecs
calling  des_generic_mod_init+0x0/0x33 @ 1
initcall des_generic_mod_init+0x0/0x33 returned 0 after 60 usecs
calling  fcrypt_mod_init+0x0/0xf @ 1
initcall fcrypt_mod_init+0x0/0xf returned 0 after 30 usecs
calling  blowfish_mod_init+0x0/0xf @ 1
initcall blowfish_mod_init+0x0/0xf returned 0 after 30 usecs
calling  twofish_mod_init+0x0/0xf @ 1
initcall twofish_mod_init+0x0/0xf returned 0 after 30 usecs
calling  serpent_mod_init+0x0/0x33 @ 1
initcall serpent_mod_init+0x0/0x33 returned 0 after 75 usecs
calling  aes_init+0x0/0xf @ 1
initcall aes_init+0x0/0xf returned 0 after 31 usecs
calling  camellia_init+0x0/0xf @ 1
initcall camellia_init+0x0/0xf returned 0 after 46 usecs
calling  cast5_mod_init+0x0/0xf @ 1
initcall cast5_mod_init+0x0/0xf returned 0 after 31 usecs
calling  cast6_mod_init+0x0/0xf @ 1
initcall cast6_mod_init+0x0/0xf returned 0 after 31 usecs
calling  arc4_init+0x0/0xf @ 1
initcall arc4_init+0x0/0xf returned 0 after 31 usecs
calling  tea_mod_init+0x0/0x52 @ 1
initcall tea_mod_init+0x0/0x52 returned 0 after 87 usecs
calling  khazad_mod_init+0x0/0xf @ 1
initcall khazad_mod_init+0x0/0xf returned 0 after 31 usecs
calling  anubis_mod_init+0x0/0xf @ 1
initcall anubis_mod_init+0x0/0xf returned 0 after 32 usecs
calling  seed_init+0x0/0xf @ 1
initcall seed_init+0x0/0xf returned 0 after 32 usecs
calling  deflate_mod_init+0x0/0xf @ 1
initcall deflate_mod_init+0x0/0xf returned 0 after 31 usecs
calling  michael_mic_init+0x0/0xf @ 1
initcall michael_mic_init+0x0/0xf returned 0 after 31 usecs
calling  crc32c_mod_init+0x0/0xf @ 1
initcall crc32c_mod_init+0x0/0xf returned 0 after 32 usecs
calling  crypto_authenc_module_init+0x0/0xf @ 1
initcall crypto_authenc_module_init+0x0/0xf returned 0 after 2 usecs
calling  crypto_authenc_esn_module_init+0x0/0xf @ 1
initcall crypto_authenc_esn_module_init+0x0/0xf returned 0 after 7 usecs
calling  lzo_mod_init+0x0/0xf @ 1
initcall lzo_mod_init+0x0/0xf returned 0 after 31 usecs
calling  krng_mod_init+0x0/0xf @ 1
initcall krng_mod_init+0x0/0xf returned 0 after 32 usecs
calling  async_tx_init+0x0/0x19 @ 1
async_tx: api initialized (async)
initcall async_tx_init+0x0/0x19 returned 0 after 2998 usecs
calling  async_pq_init+0x0/0x46 @ 1
initcall async_pq_init+0x0/0x46 returned 0 after 2 usecs
calling  proc_genhd_init+0x0/0x44 @ 1
initcall proc_genhd_init+0x0/0x44 returned 0 after 6 usecs
calling  bsg_init+0x0/0x117 @ 1
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
initcall bsg_init+0x0/0x117 returned 0 after 6024 usecs
calling  noop_init+0x0/0x11 @ 1
io scheduler noop registered
initcall noop_init+0x0/0x11 returned 0 after 2566 usecs
calling  deadline_init+0x0/0x11 @ 1
io scheduler deadline registered
initcall deadline_init+0x0/0x11 returned 0 after 2902 usecs
calling  cfq_init+0x0/0xa8 @ 1
io scheduler cfq registered (default)
initcall cfq_init+0x0/0xa8 returned 0 after 3363 usecs
calling  libcrc32c_mod_init+0x0/0x26 @ 1
initcall libcrc32c_mod_init+0x0/0x26 returned 0 after 5 usecs
calling  percpu_counter_startup+0x0/0x16 @ 1
initcall percpu_counter_startup+0x0/0x16 returned 0 after 3 usecs
calling  audit_classes_init+0x0/0x4f @ 1
initcall audit_classes_init+0x0/0x4f returned 0 after 6 usecs
calling  lnw_gpio_init+0x0/0x3a @ 1
initcall lnw_gpio_init+0x0/0x3a returned 0 after 129 usecs
calling  timbgpio_init+0x0/0xf @ 1
initcall timbgpio_init+0x0/0xf returned 0 after 46 usecs
calling  ucb1400_gpio_init+0x0/0xf @ 1
initcall ucb1400_gpio_init+0x0/0xf returned 0 after 48 usecs
calling  pci_proc_init+0x0/0x64 @ 1
initcall pci_proc_init+0x0/0x64 returned 0 after 48 usecs
calling  pcie_portdrv_init+0x0/0x6f @ 1
pcieport 0000:00:0b.0: setting latency timer to 64
pcieport 0000:00:0b.0: irq 40 for MSI/MSI-X
pcieport 0000:00:0c.0: setting latency timer to 64
pcieport 0000:00:0c.0: irq 41 for MSI/MSI-X
pcieport 0000:00:0d.0: setting latency timer to 64
pcieport 0000:00:0d.0: irq 42 for MSI/MSI-X
pcieport 0000:00:0e.0: setting latency timer to 64
pcieport 0000:00:0e.0: irq 43 for MSI/MSI-X
initcall pcie_portdrv_init+0x0/0x6f returned 0 after 33580 usecs
calling  aer_service_init+0x0/0x2c @ 1
initcall aer_service_init+0x0/0x2c returned 0 after 46 usecs
calling  aer_inject_init+0x0/0xf @ 1
initcall aer_inject_init+0x0/0xf returned 0 after 83 usecs
calling  pcie_pme_service_init+0x0/0xf @ 1
initcall pcie_pme_service_init+0x0/0xf returned 0 after 46 usecs
calling  ioapic_init+0x0/0x16 @ 1
initcall ioapic_init+0x0/0x16 returned 0 after 69 usecs
calling  pci_hotplug_init+0x0/0x4d @ 1
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
initcall pci_hotplug_init+0x0/0x4d returned 0 after 4173 usecs
calling  cpqhpc_init+0x0/0x66 @ 1
cpqphp: Compaq Hot Plug PCI Controller Driver version: 0.9.8
initcall cpqhpc_init+0x0/0x66 returned 0 after 5339 usecs
calling  ibmphp_init+0x0/0x611 @ 1
ibmphpd: IBM Hot Plug PCI Controller Driver version: 0.6
initcall ibmphp_init+0x0/0x611 returned -19 after 4983 usecs
calling  pcied_init+0x0/0xf1 @ 1
pciehp: PCI Express Hot Plug Controller Driver version: 0.4
initcall pcied_init+0x0/0xf1 returned 0 after 5343 usecs
calling  zt5550_init+0x0/0x79 @ 1
cpcihp_zt5550: ZT5550 CompactPCI Hot Plug Driver version: 0.2
initcall zt5550_init+0x0/0x79 returned 0 after 5423 usecs
calling  cpcihp_generic_init+0x0/0x41b @ 1
cpcihp_generic: Generic port I/O CompactPCI Hot Plug Driver version: 0.1
cpcihp_generic: not configured, disabling.
initcall cpcihp_generic_init+0x0/0x41b returned -22 after 10038 usecs
initcall cpcihp_generic_init+0x0/0x41b returned with error code -22 
calling  shpcd_init+0x0/0xd8 @ 1
shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
initcall shpcd_init+0x0/0xd8 returned 0 after 5346 usecs
calling  acpiphp_init+0x0/0x5a @ 1
acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
initcall acpiphp_init+0x0/0x5a returned -19 after 5454 usecs
calling  ibm_acpiphp_init+0x0/0x15f @ 1
acpiphp_ibm: ibm_acpiphp_init: acpi_walk_namespace failed
initcall ibm_acpiphp_init+0x0/0x15f returned -19 after 7091 usecs
calling  genericbl_init+0x0/0xf @ 1
initcall genericbl_init+0x0/0xf returned 0 after 51 usecs
calling  display_class_init+0x0/0x6b @ 1
initcall display_class_init+0x0/0x6b returned 0 after 47 usecs
calling  arcfb_init+0x0/0x62 @ 1
initcall arcfb_init+0x0/0x62 returned -6 after 1 usecs
initcall arcfb_init+0x0/0x62 returned with error code -6 
calling  cyber2000fb_init+0x0/0xa9 @ 1
initcall cyber2000fb_init+0x0/0xa9 returned 0 after 73 usecs
calling  pm2fb_init+0x0/0x127 @ 1
initcall pm2fb_init+0x0/0x127 returned 0 after 65 usecs
calling  pm3fb_init+0x0/0xe4 @ 1
initcall pm3fb_init+0x0/0xe4 returned 0 after 65 usecs
calling  matroxfb_init+0x0/0x88d @ 1
initcall matroxfb_init+0x0/0x88d returned 0 after 67 usecs
calling  matroxfb_crtc2_init+0x0/0x2d @ 1
initcall matroxfb_crtc2_init+0x0/0x2d returned 0 after 2 usecs
calling  i2c_matroxfb_init+0x0/0x29 @ 1
initcall i2c_matroxfb_init+0x0/0x29 returned 0 after 1 usecs
calling  matroxfb_maven_init+0x0/0x11 @ 1
initcall matroxfb_maven_init+0x0/0x11 returned 0 after 49 usecs
calling  rivafb_init+0x0/0x17a @ 1
initcall rivafb_init+0x0/0x17a returned 0 after 71 usecs
calling  nvidiafb_init+0x0/0x26e @ 1
initcall nvidiafb_init+0x0/0x26e returned 0 after 66 usecs
calling  atyfb_init+0x0/0x1da @ 1
initcall atyfb_init+0x0/0x1da returned 0 after 70 usecs
calling  aty128fb_init+0x0/0x114 @ 1
initcall aty128fb_init+0x0/0x114 returned 0 after 70 usecs
calling  sisfb_init+0x0/0x71d @ 1
initcall sisfb_init+0x0/0x71d returned 0 after 68 usecs
calling  via_core_init+0x0/0x29 @ 1
VIA Graphics Integration Chipset framebuffer 2.4 initializing
initcall via_core_init+0x0/0x29 returned 0 after 5528 usecs
calling  kyrofb_init+0x0/0xc3 @ 1
initcall kyrofb_init+0x0/0xc3 returned 0 after 66 usecs
calling  savagefb_init+0x0/0x58 @ 1
initcall savagefb_init+0x0/0x58 returned 0 after 68 usecs
calling  gx1fb_init+0x0/0x100 @ 1
initcall gx1fb_init+0x0/0x100 returned 0 after 68 usecs
calling  gxfb_init+0x0/0x64 @ 1
initcall gxfb_init+0x0/0x64 returned 0 after 78 usecs
calling  lxfb_init+0x0/0xc3 @ 1
initcall lxfb_init+0x0/0xc3 returned 0 after 67 usecs
calling  neofb_init+0x0/0x12a @ 1
initcall neofb_init+0x0/0x12a returned 0 after 67 usecs
calling  tdfxfb_init+0x0/0x103 @ 1
initcall tdfxfb_init+0x0/0x103 returned 0 after 66 usecs
calling  imsttfb_init+0x0/0xd5 @ 1
initcall imsttfb_init+0x0/0xd5 returned 0 after 66 usecs
calling  vt8623fb_init+0x0/0x47 @ 1
initcall vt8623fb_init+0x0/0x47 returned 0 after 66 usecs
calling  tridentfb_init+0x0/0x1d6 @ 1
initcall tridentfb_init+0x0/0x1d6 returned 0 after 68 usecs
calling  vmlfb_init+0x0/0x80 @ 1
vmlfb: initializing
initcall vmlfb_init+0x0/0x80 returned 0 after 1858 usecs
calling  cr_pll_init+0x0/0xc9 @ 1
Could not find Carillo Ranch MCH device.
initcall cr_pll_init+0x0/0xc9 returned -19 after 3590 usecs
calling  s3fb_init+0x0/0xbf @ 1
initcall s3fb_init+0x0/0xbf returned 0 after 66 usecs
calling  arkfb_init+0x0/0x47 @ 1
initcall arkfb_init+0x0/0x47 returned 0 after 64 usecs
calling  hecubafb_init+0x0/0xf @ 1
initcall hecubafb_init+0x0/0xf returned 0 after 48 usecs
calling  n411_init+0x0/0x94 @ 1
no IO addresses supplied
initcall n411_init+0x0/0x94 returned -22 after 2226 usecs
initcall n411_init+0x0/0x94 returned with error code -22 
calling  hgafb_init+0x0/0x7d @ 1
hgafb: HGA card not detected.
hgafb: probe of hgafb.0 failed with error -22
initcall hgafb_init+0x0/0x7d returned 0 after 6788 usecs
calling  sstfb_init+0x0/0x18b @ 1
initcall sstfb_init+0x0/0x18b returned 0 after 85 usecs
calling  metronomefb_init+0x0/0xf @ 1
initcall metronomefb_init+0x0/0xf returned 0 after 47 usecs
calling  broadsheetfb_init+0x0/0xf @ 1
initcall broadsheetfb_init+0x0/0xf returned 0 after 49 usecs
calling  s1d13xxxfb_init+0x0/0x26 @ 1
initcall s1d13xxxfb_init+0x0/0x26 returned 0 after 48 usecs
calling  carminefb_init+0x0/0x33 @ 1
initcall carminefb_init+0x0/0x33 returned 0 after 68 usecs
calling  mb862xxfb_init+0x0/0x1b @ 1
initcall mb862xxfb_init+0x0/0x1b returned 0 after 69 usecs
calling  uvesafb_init+0x0/0x35b @ 1
uvesafb: failed to execute /sbin/v86d
uvesafb: make sure that the v86d helper is installed and executable
uvesafb: Getting VBE info block failed (eax=0x4f00, err=-2)
uvesafb: vbe_init() failed with -22
uvesafb: probe of uvesafb.0 failed with error -22
initcall uvesafb_init+0x0/0x35b returned 0 after 22069 usecs
calling  efifb_init+0x0/0x1b2 @ 1
initcall efifb_init+0x0/0x1b2 returned -19 after 18 usecs
calling  intel_idle_init+0x0/0x361 @ 1
initcall intel_idle_init+0x0/0x361 returned -19 after 1 usecs
calling  acpi_reserve_resources+0x0/0xc8 @ 1
initcall acpi_reserve_resources+0x0/0xc8 returned 0 after 6 usecs
calling  irqrouter_init_ops+0x0/0x23 @ 1
initcall irqrouter_init_ops+0x0/0x23 returned 0 after 2 usecs
calling  acpi_ac_init+0x0/0x44 @ 1
initcall acpi_ac_init+0x0/0x44 returned 0 after 82 usecs
calling  acpi_button_init+0x0/0xf @ 1
input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input0
ACPI: Power Button [PWRB]
input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
ACPI: Power Button [PWRF]
initcall acpi_button_init+0x0/0xf returned 0 after 17622 usecs
calling  acpi_fan_init+0x0/0x15 @ 1
ACPI: Fan [FAN] (on)
initcall acpi_fan_init+0x0/0x15 returned 0 after 2018 usecs
calling  acpi_video_init+0x0/0x6b @ 1
initcall acpi_video_init+0x0/0x6b returned 0 after 75 usecs
calling  acpi_pci_slot_init+0x0/0x1b @ 1
initcall acpi_pci_slot_init+0x0/0x1b returned 0 after 288 usecs
calling  acpi_processor_init+0x0/0xd0 @ 1
ACPI: acpi_idle registered with cpuidle
initcall acpi_processor_init+0x0/0xd0 returned 0 after 3733 usecs
calling  acpi_container_init+0x0/0x4d @ 1
initcall acpi_container_init+0x0/0x4d returned 0 after 2437 usecs
calling  acpi_thermal_init+0x0/0x3c @ 1
thermal LNXTHERM:00: registered as thermal_zone0
ACPI: Thermal Zone [THRM] (40 C)
initcall acpi_thermal_init+0x0/0x3c returned 0 after 7664 usecs
calling  acpi_battery_init+0x0/0x13 @ 1
initcall acpi_battery_init+0x0/0x13 returned 0 after 4 usecs
calling  1_acpi_battery_init_async+0x0/0x34 @ 5
initcall 1_acpi_battery_init_async+0x0/0x34 returned 0 after 97 usecs
calling  acpi_smb_hc_init+0x0/0x15 @ 1
initcall acpi_smb_hc_init+0x0/0x15 returned 0 after 67 usecs
calling  acpi_sbs_init+0x0/0x54 @ 1
initcall acpi_sbs_init+0x0/0x54 returned 0 after 55 usecs
calling  acpi_hed_init+0x0/0x23 @ 1
initcall acpi_hed_init+0x0/0x23 returned 0 after 57 usecs
calling  acpi_pad_init+0x0/0xe9 @ 1
initcall acpi_pad_init+0x0/0xe9 returned -22 after 1 usecs
initcall acpi_pad_init+0x0/0xe9 returned with error code -22 
calling  erst_init+0x0/0x27d @ 1
ERST: Table is not found!
initcall erst_init+0x0/0x27d returned 0 after 2309 usecs
calling  pnpbios_thread_init+0x0/0x5e @ 1
initcall pnpbios_thread_init+0x0/0x5e returned 0 after 1 usecs
calling  isapnp_init+0x0/0x5f5 @ 1
isapnp: Scanning for PnP cards...
isapnp: No Plug & Play device found
initcall isapnp_init+0x0/0x5f5 returned 0 after 353213 usecs
calling  pty_init+0x0/0x39d @ 1
initcall pty_init+0x0/0x39d returned 0 after 43144 usecs
calling  sysrq_init+0x0/0x6a @ 1
initcall sysrq_init+0x0/0x6a returned 0 after 15 usecs
calling  serial8250_init+0x0/0x154 @ 1
Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
async_waiting @ 1
async_continuing @ 1 after 2 usec
async_waiting @ 1
async_continuing @ 1 after 1 usec
ÿserial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
initcall serial8250_init+0x0/0x154 returned 0 after 299763 usecs
calling  serial8250_pnp_init+0x0/0xf @ 1
00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
initcall serial8250_pnp_init+0x0/0xf returned 0 after 30870 usecs
calling  serial8250_pci_init+0x0/0x16 @ 1
initcall serial8250_pci_init+0x0/0x16 returned 0 after 100 usecs
calling  rand_initialize+0x0/0x2a @ 1
initcall rand_initialize+0x0/0x2a returned 0 after 48 usecs
calling  ttyprintk_init+0x0/0x128 @ 1
initcall ttyprintk_init+0x0/0x128 returned 0 after 143 usecs
calling  init+0x0/0x9c @ 1
initcall init+0x0/0x9c returned 0 after 109 usecs
calling  lp_init_module+0x0/0x212 @ 1
lp: driver loaded but no devices found
initcall lp_init_module+0x0/0x212 returned 0 after 3529 usecs
calling  hpet_init+0x0/0x57 @ 1
initcall hpet_init+0x0/0x57 returned 0 after 230 usecs
calling  nvram_init+0x0/0x7e @ 1
Non-volatile memory driver v1.3
initcall nvram_init+0x0/0x7e returned 0 after 2913 usecs
calling  i8k_init+0x0/0x1d2 @ 1
initcall i8k_init+0x0/0x1d2 returned -19 after 5 usecs
calling  agp_init+0x0/0x2f @ 1
Linux agpgart interface v0.103
initcall agp_init+0x0/0x2f returned 0 after 2734 usecs
calling  agp_ali_init+0x0/0x24 @ 1
initcall agp_ali_init+0x0/0x24 returned 0 after 81 usecs
calling  agp_ati_init+0x0/0x24 @ 1
initcall agp_ati_init+0x0/0x24 returned 0 after 70 usecs
calling  agp_amdk7_init+0x0/0x24 @ 1
initcall agp_amdk7_init+0x0/0x24 returned 0 after 69 usecs
calling  agp_amd64_mod_init+0x0/0xa @ 1
initcall agp_amd64_mod_init+0x0/0xa returned -19 after 259 usecs
calling  agp_efficeon_init+0x0/0x39 @ 1
initcall agp_efficeon_init+0x0/0x39 returned 0 after 72 usecs
calling  agp_intel_init+0x0/0x24 @ 1
initcall agp_intel_init+0x0/0x24 returned 0 after 72 usecs
calling  agp_nvidia_init+0x0/0x24 @ 1
initcall agp_nvidia_init+0x0/0x24 returned 0 after 69 usecs
calling  agp_sis_init+0x0/0x24 @ 1
initcall agp_sis_init+0x0/0x24 returned 0 after 70 usecs
calling  agp_serverworks_init+0x0/0x24 @ 1
initcall agp_serverworks_init+0x0/0x24 returned 0 after 69 usecs
calling  agp_via_init+0x0/0x24 @ 1
initcall agp_via_init+0x0/0x24 returned 0 after 71 usecs
calling  drm_core_init+0x0/0x12b @ 1
[drm] Initialized drm 1.1.0 20060810
initcall drm_core_init+0x0/0x12b returned 0 after 3313 usecs
calling  ttm_init+0x0/0x64 @ 1
initcall ttm_init+0x0/0x64 returned 0 after 56 usecs
calling  tdfx_init+0x0/0x14 @ 1
initcall tdfx_init+0x0/0x14 returned 0 after 14 usecs
calling  r128_init+0x0/0x1e @ 1
initcall r128_init+0x0/0x1e returned 0 after 70 usecs
calling  radeon_init+0x0/0xdb @ 1
[drm] radeon defaulting to userspace modesetting.
ACPI: PCI Interrupt Link [APC3] enabled at IRQ 18
IOAPIC[0]: Set routing entry (2-18 -> 0x59 -> IRQ 18 Mode:1 Active:1)
pci 0000:01:00.0: PCI INT A -> Link[APC3] -> GSI 18 (level, low) -> IRQ 18
pci 0000:01:00.0: setting latency timer to 64
[drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[drm] No driver support for vblank timestamp query.
[drm] Initialized radeon 1.33.0 20080528 for 0000:01:00.0 on minor 0
initcall radeon_init+0x0/0xdb returned 0 after 42047 usecs
calling  mga_init+0x0/0x1e @ 1
initcall mga_init+0x0/0x1e returned 0 after 8 usecs
calling  i810_init+0x0/0x43 @ 1
drm/i810 does not support SMP
initcall i810_init+0x0/0x43 returned -22 after 2649 usecs
initcall i810_init+0x0/0x43 returned with error code -22 
calling  savage_init+0x0/0x1e @ 1
initcall savage_init+0x0/0x1e returned 0 after 43 usecs
calling  via_init+0x0/0x23 @ 1
initcall via_init+0x0/0x23 returned 0 after 20 usecs
calling  cn_proc_init+0x0/0x31 @ 1
initcall cn_proc_init+0x0/0x31 returned 0 after 3 usecs
calling  i810fb_init+0x0/0x354 @ 1
initcall i810fb_init+0x0/0x354 returned 0 after 77 usecs
calling  parport_default_proc_register+0x0/0x16 @ 1
initcall parport_default_proc_register+0x0/0x16 returned 0 after 13 usecs
calling  parport_pc_init+0x0/0x327 @ 1
IT8712 SuperIO detected.
parport_pc 00:09: reported by Plug and Play ACPI
parport0: PC-style at 0x378 (0x778), irq 7, dma 3 [PCSPP,TRISTATE,COMPAT,ECP,DMA]
lp0: using parport0 (interrupt-driven).
lp0: console ready
initcall parport_pc_init+0x0/0x327 returned 0 after 100307 usecs
calling  parport_serial_init+0x0/0x16 @ 1
initcall parport_serial_init+0x0/0x16 returned 0 after 72 usecs
calling  init_parport_cs+0x0/0xf @ 1
initcall init_parport_cs+0x0/0xf returned 0 after 50 usecs
calling  parport_ax88796_init+0x0/0xf @ 1
initcall parport_ax88796_init+0x0/0xf returned 0 after 49 usecs
calling  isa_bus_init+0x0/0x33 @ 1
initcall isa_bus_init+0x0/0x33 returned 0 after 63 usecs
calling  topology_sysfs_init+0x0/0x56 @ 1
initcall topology_sysfs_init+0x0/0x56 returned 0 after 13 usecs
calling  floppy_init+0x0/0xcd4 @ 1
Floppy drive(s): fd0 is 1.44M
FDC 0 is a post-1991 82077
initcall floppy_init+0x0/0xcd4 returned 0 after 20440 usecs
calling  brd_init+0x0/0x15a @ 1
brd: module loaded
initcall brd_init+0x0/0x15a returned 0 after 4294 usecs
calling  loop_init+0x0/0x172 @ 1
loop: module loaded
initcall loop_init+0x0/0x172 returned 0 after 3115 usecs
calling  xd_init+0x0/0x4b4 @ 1
initcall xd_init+0x0/0x4b4 returned -19 after 82 usecs
calling  cpqarray_init+0x0/0x216 @ 1
Compaq SMART2 Driver (v 2.6.0)
initcall cpqarray_init+0x0/0x216 returned -19 after 2873 usecs
calling  cciss_init+0x0/0x96 @ 1
HP CISS Driver (v 3.6.26)
initcall cciss_init+0x0/0x96 returned 0 after 2479 usecs
calling  DAC960_init_module+0x0/0x47 @ 1
initcall DAC960_init_module+0x0/0x47 returned 0 after 203 usecs
calling  pkt_init+0x0/0x179 @ 1
initcall pkt_init+0x0/0x179 returned 0 after 157 usecs
calling  osdblk_init+0x0/0x84 @ 1
initcall osdblk_init+0x0/0x84 returned 0 after 49 usecs
calling  mm_init+0x0/0x160 @ 1
MM: desc_per_page = 128
initcall mm_init+0x0/0x160 returned 0 after 2224 usecs
calling  nbd_init+0x0/0x250 @ 1
nbd: registered device at major 43
initcall nbd_init+0x0/0x250 returned 0 after 5872 usecs
calling  init_cryptoloop+0x0/0x27 @ 1
initcall init_cryptoloop+0x0/0x27 returned 0 after 2 usecs
calling  init+0x0/0x24 @ 1
initcall init+0x0/0x24 returned 0 after 51 usecs
calling  carm_init+0x0/0x16 @ 1
initcall carm_init+0x0/0x16 returned 0 after 64 usecs
calling  ub_init+0x0/0x82 @ 1
usbcore: registered new interface driver ub
initcall ub_init+0x0/0x82 returned 0 after 3918 usecs
calling  drbd_init+0x0/0x30d @ 1
drbd: initialized. Version: 8.3.10 (api:88/proto:86-96)
drbd: built-in
drbd: registered as block device major 147
drbd: minor_table @ 0xf65b2600
initcall drbd_init+0x0/0x30d returned 0 after 13229 usecs
calling  rbd_init+0x0/0x4b @ 1
rbd: loaded rbd (rados block device)
initcall rbd_init+0x0/0x4b returned 0 after 3325 usecs
calling  ibmasm_init+0x0/0x61 @ 1
ibmasm: IBM ASM Service Processor Driver version 1.0 loaded
initcall ibmasm_init+0x0/0x61 returned 0 after 5286 usecs
calling  ics932s401_init+0x0/0x11 @ 1
initcall ics932s401_init+0x0/0x11 returned 0 after 49 usecs
calling  tifm_7xx1_init+0x0/0x16 @ 1
initcall tifm_7xx1_init+0x0/0x16 returned 0 after 60 usecs
calling  phantom_init+0x0/0xe8 @ 1
Phantom Linux Driver, version n0.9.8, init OK
initcall phantom_init+0x0/0xe8 returned 0 after 4115 usecs
calling  ioc4_init+0x0/0x16 @ 1
initcall ioc4_init+0x0/0x16 returned 0 after 73 usecs
calling  enclosure_init+0x0/0x14 @ 1
initcall enclosure_init+0x0/0x14 returned 0 after 45 usecs
calling  ilo_init+0x0/0x82 @ 1
initcall ilo_init+0x0/0x82 returned 0 after 121 usecs
calling  isl29003_init+0x0/0x11 @ 1
i2c-core: driver [isl29003] using legacy suspend method
i2c-core: driver [isl29003] using legacy resume method
initcall isl29003_init+0x0/0x11 returned 0 after 9674 usecs
calling  sensor_isl29020_init+0x0/0x11 @ 1
initcall sensor_isl29020_init+0x0/0x11 returned 0 after 46 usecs
calling  c2port_init+0x0/0x48 @ 1
Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Giometti
initcall c2port_init+0x0/0x48 returned 0 after 5837 usecs
calling  duramar2150_c2port_init+0x0/0x6a @ 1
c2port c2port0: C2 port uc added
c2port c2port0: uc flash has 30 blocks x 512 bytes (15360 bytes total)
initcall duramar2150_c2port_init+0x0/0x6a returned 0 after 9106 usecs
calling  at24_init+0x0/0x45 @ 1
initcall at24_init+0x0/0x45 returned 0 after 49 usecs
calling  at25_init+0x0/0xf @ 1
initcall at25_init+0x0/0xf returned 0 after 53 usecs
calling  eeprom_init+0x0/0x11 @ 1
initcall eeprom_init+0x0/0x11 returned 0 after 49 usecs
calling  max6875_init+0x0/0x11 @ 1
initcall max6875_init+0x0/0x11 returned 0 after 46 usecs
calling  cb710_init_module+0x0/0x16 @ 1
initcall cb710_init_module+0x0/0x16 returned 0 after 75 usecs
calling  htcpld_core_init+0x0/0x24 @ 1
initcall htcpld_core_init+0x0/0x24 returned -19 after 139 usecs
calling  wm8994_i2c_init+0x0/0x30 @ 1
initcall wm8994_i2c_init+0x0/0x30 returned 0 after 49 usecs
calling  twl4030_codec_init+0x0/0x14 @ 1
initcall twl4030_codec_init+0x0/0x14 returned 0 after 48 usecs
calling  timberdale_init+0x0/0x47 @ 1
Driver for timberdale has been successfully registered.
initcall timberdale_init+0x0/0x47 returned 0 after 4922 usecs
calling  adp5520_init+0x0/0x11 @ 1
initcall adp5520_init+0x0/0x11 returned 0 after 47 usecs
calling  mac_hid_init+0x0/0x1c @ 1
initcall mac_hid_init+0x0/0x1c returned 0 after 19 usecs
calling  scsi_tgt_init+0x0/0x87 @ 1
initcall scsi_tgt_init+0x0/0x87 returned 0 after 288 usecs
calling  raid_init+0x0/0xf @ 1
initcall raid_init+0x0/0xf returned 0 after 51 usecs
calling  spi_transport_init+0x0/0x7c @ 1
initcall spi_transport_init+0x0/0x7c returned 0 after 90 usecs
calling  fc_transport_init+0x0/0x71 @ 1
initcall fc_transport_init+0x0/0x71 returned 0 after 171 usecs
calling  iscsi_transport_init+0x0/0x13a @ 1
Loading iSCSI transport class v2.0-870.
initcall iscsi_transport_init+0x0/0x13a returned 0 after 3755 usecs
calling  sas_transport_init+0x0/0x9f @ 1
initcall sas_transport_init+0x0/0x9f returned 0 after 285 usecs
calling  sas_class_init+0x0/0x35 @ 1
initcall sas_class_init+0x0/0x35 returned 0 after 44 usecs
calling  scsi_dh_init+0x0/0x4a @ 1
initcall scsi_dh_init+0x0/0x4a returned 0 after 3 usecs
calling  rdac_init+0x0/0x69 @ 1
rdac: device handler registered
initcall rdac_init+0x0/0x69 returned 0 after 2864 usecs
calling  hp_sw_init+0x0/0xf @ 1
hp_sw: device handler registered
initcall hp_sw_init+0x0/0xf returned 0 after 2910 usecs
calling  clariion_init+0x0/0x32 @ 1
emc: device handler registered
initcall clariion_init+0x0/0x32 returned 0 after 2734 usecs
calling  alua_init+0x0/0x32 @ 1
alua: device handler registered
initcall alua_init+0x0/0x32 returned 0 after 2827 usecs
calling  libfc_init+0x0/0x37 @ 1
initcall libfc_init+0x0/0x37 returned 0 after 98 usecs
calling  fcoe_init+0x0/0x174 @ 1
initcall fcoe_init+0x0/0x174 returned 0 after 63 usecs
calling  libfcoe_init+0x0/0x11 @ 1
initcall libfcoe_init+0x0/0x11 returned 0 after 4 usecs
calling  fnic_init_module+0x0/0x1c6 @ 1
fnic: Cisco FCoE HBA Driver, ver 1.5.0.1
initcall fnic_init_module+0x0/0x1c6 returned 0 after 3882 usecs
calling  bnx2fc_mod_init+0x0/0x224 @ 1
bnx2fc: Broadcom NetXtreme II FCoE Driver bnx2fc v1.0.1 (Mar 17, 2011)
initcall bnx2fc_mod_init+0x0/0x224 returned 0 after 6202 usecs
calling  iscsi_sw_tcp_init+0x0/0x43 @ 1
iscsi: registered transport (tcp)
initcall iscsi_sw_tcp_init+0x0/0x43 returned 0 after 3055 usecs
calling  NCR_700_init+0x0/0x1c @ 1
initcall NCR_700_init+0x0/0x1c returned 0 after 2 usecs
calling  sim710_init+0x0/0x1b @ 1
initcall sim710_init+0x0/0x1b returned 0 after 47 usecs
calling  advansys_init+0x0/0x78 @ 1
initcall advansys_init+0x0/0x78 returned 0 after 1432 usecs
calling  BusLogic_init+0x0/0x1d21 @ 1
initcall BusLogic_init+0x0/0x1d21 returned 0 after 40 usecs
calling  adpt_init+0x0/0xd93 @ 1
Loading Adaptec I2O RAID: Version 2.4 Build 5go
Detecting Adaptec I2O RAID controllers...
initcall adpt_init+0x0/0xd93 returned -19 after 7845 usecs
calling  init_this_scsi_driver+0x0/0xce @ 1
initcall init_this_scsi_driver+0x0/0xce returned -19 after 12 usecs
calling  arcmsr_module_init+0x0/0x1b @ 1
initcall arcmsr_module_init+0x0/0x1b returned 0 after 62 usecs
calling  init_this_scsi_driver+0x0/0xce @ 1
initcall init_this_scsi_driver+0x0/0xce returned -19 after 32 usecs
calling  aha152x_init+0x0/0x5d5 @ 1
initcall aha152x_init+0x0/0x5d5 returned -19 after 48 usecs
calling  init_this_scsi_driver+0x0/0xce @ 1
initcall init_this_scsi_driver+0x0/0xce returned -19 after 3344351 usecs
calling  aha1740_init+0x0/0xf @ 1
initcall aha1740_init+0x0/0xf returned 0 after 52 usecs
calling  ahc_linux_init+0x0/0x5f @ 1
initcall ahc_linux_init+0x0/0x5f returned 0 after 138 usecs
calling  ahd_linux_init+0x0/0x6c @ 1
initcall ahd_linux_init+0x0/0x6c returned 0 after 71 usecs
calling  aac_init+0x0/0x76 @ 1
Adaptec aacraid driver 1.1-7[28000]-ms
initcall aac_init+0x0/0x76 returned 0 after 3474 usecs
calling  init_this_scsi_driver+0x0/0xce @ 1
initcall init_this_scsi_driver+0x0/0xce returned -19 after 143 usecs
calling  aic94xx_init+0x0/0x126 @ 1
aic94xx: Adaptec aic94xx SAS/SATA driver version 1.0.3 loaded
initcall aic94xx_init+0x0/0x126 returned 0 after 5465 usecs
calling  pm8001_init+0x0/0x81 @ 1
initcall pm8001_init+0x0/0x81 returned 0 after 65 usecs
calling  ips_module_init+0x0/0x158 @ 1
initcall ips_module_init+0x0/0x158 returned -19 after 106 usecs
calling  init_this_scsi_driver+0x0/0xce @ 1
initcall init_this_scsi_driver+0x0/0xce returned -19 after 2 usecs
calling  init_this_scsi_driver+0x0/0xce @ 1
scsi: <fdomain> Detection failed (no card)
initcall init_this_scsi_driver+0x0/0xce returned -19 after 3788 usecs
calling  init_this_scsi_driver+0x0/0xce @ 1
initcall init_this_scsi_driver+0x0/0xce returned -19 after 5 usecs
calling  init_this_scsi_driver+0x0/0xce @ 1
initcall init_this_scsi_driver+0x0/0xce returned -19 after 2 usecs
calling  init_this_scsi_driver+0x0/0xce @ 1
initcall init_this_scsi_driver+0x0/0xce returned -19 after 2 usecs
calling  init_this_scsi_driver+0x0/0xce @ 1
NCR53c406a: no available ports found
initcall init_this_scsi_driver+0x0/0xce returned -19 after 3265 usecs
calling  NCR_D700_init+0x0/0xf @ 1
initcall NCR_D700_init+0x0/0xf returned 0 after 1 usecs
calling  NCR_Q720_init+0x0/0x28 @ 1
initcall NCR_Q720_init+0x0/0x28 returned 0 after 2 usecs
calling  init_this_scsi_driver+0x0/0xce @ 1
sym53c416.c: Version 1.0.0-ac
initcall init_this_scsi_driver+0x0/0xce returned -19 after 2661 usecs
calling  qlogicfas408_init+0x0/0x7 @ 1
initcall qlogicfas408_init+0x0/0x7 returned 0 after 1 usecs
calling  qlogicfas_init+0x0/0x22e @ 1
qlogicfas: no cards were found, please specify I/O address and IRQ using iobase= and irq= options
initcall qlogicfas_init+0x0/0x22e returned -19 after 8236 usecs
calling  qla1280_init+0x0/0x16 @ 1
initcall qla1280_init+0x0/0x16 returned 0 after 63 usecs
calling  qla2x00_module_init+0x0/0x144 @ 1
QLogic Fibre Channel HBA Driver: 8.03.07.00
initcall qla2x00_module_init+0x0/0x144 returned 0 after 3921 usecs
calling  qla4xxx_module_init+0x0/0xcc @ 1
iscsi: registered transport (qla4xxx)
QLogic iSCSI HBA Driver
initcall qla4xxx_module_init+0x0/0xcc returned 0 after 5642 usecs
calling  lpfc_init+0x0/0xaf @ 1
Emulex LightPulse Fibre Channel SCSI driver 8.3.22
Copyright(c) 2004-2009 Emulex.  All rights reserved.
initcall lpfc_init+0x0/0xaf returned 0 after 9090 usecs
calling  bfad_init+0x0/0xa1 @ 1
Brocade BFA FC/FCOE SCSI driver - version: 2.3.2.3
initcall bfad_init+0x0/0xa1 returned 0 after 4490 usecs
calling  init_this_scsi_driver+0x0/0xce @ 1
initcall init_this_scsi_driver+0x0/0xce returned -19 after 9 usecs
calling  init_this_scsi_driver+0x0/0xce @ 1
initcall init_this_scsi_driver+0x0/0xce returned -19 after 4 usecs
calling  dmx3191d_init+0x0/0x16 @ 1
initcall dmx3191d_init+0x0/0x16 returned 0 after 77 usecs
calling  hpsa_init+0x0/0x16 @ 1
initcall hpsa_init+0x0/0x16 returned 0 after 63 usecs
calling  init_this_scsi_driver+0x0/0xce @ 1
initcall init_this_scsi_driver+0x0/0xce returned -19 after 3 usecs
calling  sym2_init+0x0/0xde @ 1
initcall sym2_init+0x0/0xde returned 0 after 63 usecs
calling  init_this_scsi_driver+0x0/0xce @ 1
Failed initialization of WD-7000 SCSI card!
initcall init_this_scsi_driver+0x0/0xce returned -19 after 25126 usecs
calling  ibmmca_init+0x0/0x14 @ 1
initcall ibmmca_init+0x0/0x14 returned 0 after 2 usecs
calling  init_this_scsi_driver+0x0/0xce @ 1
initcall init_this_scsi_driver+0x0/0xce returned -19 after 267369 usecs
calling  dc395x_module_init+0x0/0x16 @ 1
initcall dc395x_module_init+0x0/0x16 returned 0 after 73 usecs
calling  dc390_module_init+0x0/0x8d @ 1
DC390: clustering now enabled by default. If you get problems load
       with "disable_clustering=1" and report to maintainers
initcall dc390_module_init+0x0/0x8d returned 0 after 11125 usecs
calling  megaraid_init+0x0/0xae @ 1
initcall megaraid_init+0x0/0xae returned 0 after 76 usecs
calling  mraid_mm_init+0x0/0x80 @ 1
megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 EST 2006)
initcall mraid_mm_init+0x0/0x80 returned 0 after 6015 usecs
calling  megaraid_init+0x0/0x93 @ 1
megaraid: 2.20.5.1 (Release Date: Thu Nov 16 15:32:35 EST 2006)
initcall megaraid_init+0x0/0x93 returned 0 after 5597 usecs
calling  megasas_init+0x0/0x1a2 @ 1
megasas: 00.00.05.34-rc1 Thu. Feb. 24 17:00:00 PDT 2011
initcall megasas_init+0x0/0x1a2 returned 0 after 4933 usecs
calling  _scsih_init+0x0/0x133 @ 1
mpt2sas version 08.100.00.00 loaded
initcall _scsih_init+0x0/0x133 returned 0 after 3301 usecs
calling  atp870u_init+0x0/0x16 @ 1
initcall atp870u_init+0x0/0x16 returned 0 after 75 usecs
calling  gdth_init+0x0/0xee3 @ 1
GDT-HA: Storage RAID Controller Driver. Version: 3.05
initcall gdth_init+0x0/0xee3 returned 0 after 4755 usecs
calling  initio_init_driver+0x0/0x16 @ 1
initcall initio_init_driver+0x0/0x16 returned 0 after 91 usecs
calling  inia100_init+0x0/0x16 @ 1
initcall inia100_init+0x0/0x16 returned 0 after 73 usecs
calling  tw_init+0x0/0x2d @ 1
3ware Storage Controller device driver for Linux v1.26.02.003.
initcall tw_init+0x0/0x2d returned 0 after 5503 usecs
calling  twa_init+0x0/0x2d @ 1
3ware 9000 Storage Controller device driver for Linux v2.26.02.014.
initcall twa_init+0x0/0x2d returned 0 after 5925 usecs
calling  twl_init+0x0/0x2d @ 1
LSI 3ware SAS/SATA-RAID Controller device driver for Linux v3.26.02.000.
initcall twl_init+0x0/0x2d returned 0 after 6350 usecs
calling  ppa_driver_init+0x0/0x26 @ 1
ppa: Version 2.07 (for Linux 2.4.x)
initcall ppa_driver_init+0x0/0x26 returned 0 after 5198 usecs
calling  imm_driver_init+0x0/0x26 @ 1
imm: Version 2.05 (for Linux 2.4.0)
initcall imm_driver_init+0x0/0x26 returned 0 after 3502 usecs
calling  init_nsp32+0x0/0x3d @ 1
nsp32: loading...
initcall init_nsp32+0x0/0x3d returned 0 after 1707 usecs
calling  ipr_init+0x0/0x3f @ 1
ipr: IBM Power RAID SCSI Device Driver version: 2.5.1 (August 10, 2010)
initcall ipr_init+0x0/0x3f returned 0 after 6268 usecs
calling  hptiop_module_init+0x0/0x35 @ 1
RocketRAID 3xxx/4xxx Controller driver v1.6 (090910)
initcall hptiop_module_init+0x0/0x35 returned 0 after 4670 usecs
calling  stex_init+0x0/0x2d @ 1
stex: Promise SuperTrak EX Driver version: 4.6.0000.4
initcall stex_init+0x0/0x2d returned 0 after 4743 usecs
calling  mvs_init+0x0/0x42 @ 1
initcall mvs_init+0x0/0x42 returned 0 after 66 usecs
calling  libcxgbi_init_module+0x0/0x179 @ 1
libcxgbi:libcxgbi_init_module: tag itt 0x1fff, 13 bits, age 0xf, 4 bits.
libcxgbi:ddp_setup_host_page_size: system PAGE 4096, ddp idx 0.
initcall libcxgbi_init_module+0x0/0x179 returned 0 after 11816 usecs
calling  cxgb3i_init_module+0x0/0x3b @ 1
Chelsio T3 iSCSI Driver cxgb3i v2.0.0 (Jun. 2010)
iscsi: registered transport (cxgb3i)
initcall cxgb3i_init_module+0x0/0x3b returned 0 after 7646 usecs
calling  cxgb4i_init_module+0x0/0x40 @ 1
Chelsio T4 iSCSI Driver cxgb4i v0.9.1 (Aug. 2010)
iscsi: registered transport (cxgb4i)
initcall cxgb4i_init_module+0x0/0x40 returned 0 after 7653 usecs
calling  bnx2i_mod_init+0x0/0xae @ 1
Broadcom NetXtreme II iSCSI Driver bnx2i v2.6.2.3 (Dec 31, 2010)
iscsi: registered transport (bnx2i)
initcall bnx2i_mod_init+0x0/0xae returned 0 after 8825 usecs
calling  beiscsi_module_init+0x0/0x9a @ 1
iscsi: registered transport (be2iscsi)
initcall beiscsi_module_init+0x0/0x9a returned 0 after 3547 usecs
calling  pmcraid_init+0x0/0x124 @ 1
initcall pmcraid_init+0x0/0x124 returned 0 after 142 usecs
calling  pvscsi_init+0x0/0x35 @ 1
VMware PVSCSI driver - version 1.0.1.0-k
initcall pvscsi_init+0x0/0x35 returned 0 after 3643 usecs
calling  init_st+0x0/0x159 @ 1
st: Version 20101219, fixed bufsize 32768, s/g segs 256
initcall init_st+0x0/0x159 returned 0 after 4941 usecs
calling  init_osst+0x0/0x133 @ 1
osst :I: Tape driver with OnStream support version 0.99.4
osst :I: $Id: osst.c,v 1.73 2005/01/01 21:13:34 wriede Exp $
initcall init_osst+0x0/0x133 returned 0 after 10373 usecs
calling  init_sd+0x0/0x113 @ 1
initcall init_sd+0x0/0x113 returned 0 after 131 usecs
calling  init_sr+0x0/0x3d @ 1
initcall init_sr+0x0/0x3d returned 0 after 48 usecs
calling  init_sg+0x0/0x10f @ 1
initcall init_sg+0x0/0x10f returned 0 after 58 usecs
calling  init_ch_module+0x0/0xab @ 1
SCSI Media Changer driver v0.25 
initcall init_ch_module+0x0/0xab returned 0 after 2988 usecs
calling  ses_init+0x0/0x33 @ 1
initcall ses_init+0x0/0x33 returned 0 after 47 usecs
calling  osd_uld_init+0x0/0xb6 @ 1
osd: LOADED open-osd 0.2.0
initcall osd_uld_init+0x0/0xb6 returned 0 after 2491 usecs
calling  ahci_init+0x0/0x16 @ 1
initcall ahci_init+0x0/0x16 returned 0 after 81 usecs
calling  acard_ahci_init+0x0/0x16 @ 1
initcall acard_ahci_init+0x0/0x16 returned 0 after 80 usecs
calling  ahci_init+0x0/0x14 @ 1
initcall ahci_init+0x0/0x14 returned -19 after 94 usecs
calling  inic_init+0x0/0x16 @ 1
initcall inic_init+0x0/0x16 returned 0 after 64 usecs
calling  sil24_init+0x0/0x16 @ 1
initcall sil24_init+0x0/0x16 returned 0 after 79 usecs
calling  adma_ata_init+0x0/0x16 @ 1
initcall adma_ata_init+0x0/0x16 returned 0 after 65 usecs
calling  arasan_cf_init+0x0/0xf @ 1
initcall arasan_cf_init+0x0/0xf returned 0 after 49 usecs
calling  qs_ata_init+0x0/0x16 @ 1
initcall qs_ata_init+0x0/0x16 returned 0 after 82 usecs
calling  pdc_sata_init+0x0/0x16 @ 1
initcall pdc_sata_init+0x0/0x16 returned 0 after 63 usecs
calling  piix_init+0x0/0x24 @ 1
initcall piix_init+0x0/0x24 returned 0 after 68 usecs
calling  mv_init+0x0/0x3a @ 1
initcall mv_init+0x0/0x3a returned 0 after 126 usecs
calling  nv_init+0x0/0x16 @ 1
initcall nv_init+0x0/0x16 returned 0 after 68 usecs
calling  pdc_ata_init+0x0/0x16 @ 1
initcall pdc_ata_init+0x0/0x16 returned 0 after 66 usecs
calling  sil_init+0x0/0x16 @ 1
initcall sil_init+0x0/0x16 returned 0 after 67 usecs
calling  sis_init+0x0/0x16 @ 1
initcall sis_init+0x0/0x16 returned 0 after 65 usecs
calling  k2_sata_init+0x0/0x16 @ 1
initcall k2_sata_init+0x0/0x16 returned 0 after 66 usecs
calling  uli_init+0x0/0x16 @ 1
initcall uli_init+0x0/0x16 returned 0 after 66 usecs
calling  svia_init+0x0/0x16 @ 1
initcall svia_init+0x0/0x16 returned 0 after 66 usecs
calling  vsc_sata_init+0x0/0x16 @ 1
initcall vsc_sata_init+0x0/0x16 returned 0 after 65 usecs
calling  ali_init+0x0/0x40 @ 1
initcall ali_init+0x0/0x40 returned 0 after 67 usecs
calling  amd_init+0x0/0x16 @ 1
pata_amd 0000:00:06.0: version 0.4.1
pata_amd 0000:00:06.0: setting latency timer to 64
scsi2 : pata_amd
scsi3 : pata_amd
ata1: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xf000 irq 14
ata2: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xf008 irq 15
calling  2_async_port_probe+0x0/0x4d @ 5
calling  3_async_port_probe+0x0/0x4d @ 12
async_waiting @ 12
initcall amd_init+0x0/0x16 returned 0 after 32497 usecs
calling  artop_init+0x0/0x16 @ 1
initcall artop_init+0x0/0x16 returned 0 after 79 usecs
calling  atiixp_init+0x0/0x16 @ 1
initcall atiixp_init+0x0/0x16 returned 0 after 65 usecs
calling  atp867x_init+0x0/0x16 @ 1
initcall atp867x_init+0x0/0x16 returned 0 after 65 usecs
calling  cmd64x_init+0x0/0x16 @ 1
initcall cmd64x_init+0x0/0x16 returned 0 after 65 usecs
calling  cs5520_init+0x0/0x16 @ 1
initcall cs5520_init+0x0/0x16 returned 0 after 68 usecs
calling  cs5530_init+0x0/0x16 @ 1
initcall cs5530_init+0x0/0x16 returned 0 after 82 usecs
calling  cs5535_init+0x0/0x16 @ 1
initcall cs5535_init+0x0/0x16 returned 0 after 67 usecs
calling  cs5536_init+0x0/0x16 @ 1
initcall cs5536_init+0x0/0x16 returned 0 after 67 usecs
calling  cy82c693_init+0x0/0x16 @ 1
initcall cy82c693_init+0x0/0x16 returned 0 after 66 usecs
calling  efar_init+0x0/0x16 @ 1
initcall efar_init+0x0/0x16 returned 0 after 65 usecs
calling  hpt36x_init+0x0/0x16 @ 1
initcall hpt36x_init+0x0/0x16 returned 0 after 66 usecs
calling  hpt37x_init+0x0/0x16 @ 1
initcall hpt37x_init+0x0/0x16 returned 0 after 66 usecs
calling  hpt3x2n_init+0x0/0x16 @ 1
initcall hpt3x2n_init+0x0/0x16 returned 0 after 67 usecs
calling  hpt3x3_init+0x0/0x16 @ 1
initcall hpt3x3_init+0x0/0x16 returned 0 after 67 usecs
calling  it8213_init+0x0/0x16 @ 1
initcall it8213_init+0x0/0x16 returned 0 after 70 usecs
calling  it821x_init+0x0/0x16 @ 1
initcall it821x_init+0x0/0x16 returned 0 after 67 usecs
calling  jmicron_init+0x0/0x16 @ 1
initcall jmicron_init+0x0/0x16 returned 0 after 67 usecs
calling  marvell_init+0x0/0x16 @ 1
initcall marvell_init+0x0/0x16 returned 0 after 68 usecs
calling  netcell_init+0x0/0x16 @ 1
initcall netcell_init+0x0/0x16 returned 0 after 68 usecs
calling  ninja32_init+0x0/0x16 @ 1
ata1.00: ATA-6: HDS722525VLAT80, V36OA60A, max UDMA/100
ata1.00: 488397168 sectors, multi 1: LBA48 
ata1: nv_mode_filter: 0x3f39f&0x3f39f->0x3f39f, BIOS=0x3f000 (0xc60000c0) ACPI=0x3f01f (20:600:0x13)
initcall ninja32_init+0x0/0x16 returned 0 after 69 usecs
calling  ns87415_init+0x0/0x16 @ 1
initcall ns87415_init+0x0/0x16 returned 0 after 68 usecs
ata1.00: configured for UDMA/100
async_waiting @ 5
async_continuing @ 5 after 2 usec
scsi 2:0:0:0: Direct-Access     ATA      HDS722525VLAT80  V36O PQ: 0 ANSI: 5
calling  4_sd_probe_async+0x0/0x1a3 @ 1484
sd 2:0:0:0: [sda] 488397168 512-byte logical blocks: (250 GB/232 GiB)
sd 2:0:0:0: [sda] Write Protect is off
sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 2:0:0:0: Attached scsi generic sg0 type 0
initcall 2_async_port_probe+0x0/0x4d returned 0 after 186890 usecs
async_continuing @ 12 after 195838 usec
calling  oldpiix_init+0x0/0x16 @ 1
initcall oldpiix_init+0x0/0x16 returned 0 after 78 usecs
calling  optidma_init+0x0/0x16 @ 1
initcall optidma_init+0x0/0x16 returned 0 after 67 usecs
calling  pdc2027x_init+0x0/0x16 @ 1
initcall pdc2027x_init+0x0/0x16 returned 0 after 70 usecs
calling  pdc202xx_init+0x0/0x16 @ 1
initcall pdc202xx_init+0x0/0x16 returned 0 after 69 usecs
calling  radisys_init+0x0/0x16 @ 1
 sda: sda1 sda2 sda3 < sda5 sda6 sda7 sda8 sda9 sda10 >
initcall radisys_init+0x0/0x16 returned 0 after 101 usecs
sd 2:0:0:0: [sda] Attached SCSI disk
initcall 4_sd_probe_async+0x0/0x1a3 returned 0 after 96346 usecs
calling  rdc_init+0x0/0x16 @ 1
initcall rdc_init+0x0/0x16 returned 0 after 75 usecs
calling  sc1200_init+0x0/0x16 @ 1
initcall sc1200_init+0x0/0x16 returned 0 after 105 usecs
calling  sch_init+0x0/0x16 @ 1
initcall sch_init+0x0/0x16 returned 0 after 84 usecs
calling  serverworks_init+0x0/0x16 @ 1
initcall serverworks_init+0x0/0x16 returned 0 after 69 usecs
calling  sil680_init+0x0/0x16 @ 1
initcall sil680_init+0x0/0x16 returned 0 after 69 usecs
calling  sis_init+0x0/0x16 @ 1
ata2.01: ATAPI: DVDRW IDE 16X, VER A079, max UDMA/66
ata2: nv_mode_filter: 0x1f39f&0x739f->0x739f, BIOS=0x7000 (0xc60000c0) ACPI=0x701f (600:60:0x1c)
initcall sis_init+0x0/0x16 returned 0 after 21442 usecs
calling  ata_tosh_init+0x0/0x16 @ 1
initcall ata_tosh_init+0x0/0x16 returned 0 after 71 usecs
ata2.01: configured for UDMA/33
async_waiting @ 12
async_continuing @ 12 after 2 usec
scsi 3:0:1:0: CD-ROM            DVDRW    IDE 16X          A079 PQ: 0 ANSI: 5
sr0: scsi3-mmc drive: 1x/48x writer cd/rw xa/form2 cdda tray
cdrom: Uniform CD-ROM driver Revision: 3.20
sr 3:0:1:0: Attached scsi CD-ROM sr0
sr 3:0:1:0: Attached scsi generic sg1 type 5
initcall 3_async_port_probe+0x0/0x4d returned 0 after 381345 usecs
calling  triflex_init+0x0/0x16 @ 1
initcall triflex_init+0x0/0x16 returned 0 after 73 usecs
calling  via_init+0x0/0x16 @ 1
initcall via_init+0x0/0x16 returned 0 after 70 usecs
calling  sl82c105_init+0x0/0x16 @ 1
initcall sl82c105_init+0x0/0x16 returned 0 after 68 usecs
calling  cmd640_init+0x0/0x16 @ 1
initcall cmd640_init+0x0/0x16 returned 0 after 69 usecs
calling  isapnp_init+0x0/0xf @ 1
initcall isapnp_init+0x0/0xf returned 0 after 50 usecs
calling  mpiix_init+0x0/0x16 @ 1
initcall mpiix_init+0x0/0x16 returned 0 after 70 usecs
calling  ns87410_init+0x0/0x16 @ 1
initcall ns87410_init+0x0/0x16 returned 0 after 71 usecs
calling  opti_init+0x0/0x16 @ 1
initcall opti_init+0x0/0x16 returned 0 after 70 usecs
calling  pcmcia_init+0x0/0xf @ 1
initcall pcmcia_init+0x0/0xf returned 0 after 58 usecs
calling  pata_platform_init+0x0/0xf @ 1
initcall pata_platform_init+0x0/0xf returned 0 after 66 usecs
calling  qdi_init+0x0/0x1f6 @ 1
initcall qdi_init+0x0/0x1f6 returned -19 after 1 usecs
calling  rz1000_init+0x0/0x16 @ 1
initcall rz1000_init+0x0/0x16 returned 0 after 72 usecs
calling  pacpi_init+0x0/0x16 @ 1
initcall pacpi_init+0x0/0x16 returned 0 after 75 usecs
calling  ata_generic_init+0x0/0x16 @ 1
initcall ata_generic_init+0x0/0x16 returned 0 after 70 usecs
calling  legacy_init+0x0/0x87a @ 1
initcall legacy_init+0x0/0x87a returned -19 after 18 usecs
calling  ce4100_spi_init+0x0/0x16 @ 1
initcall ce4100_spi_init+0x0/0x16 returned 0 after 79 usecs
calling  fixed_mdio_bus_init+0x0/0xf0 @ 1
Fixed MDIO Bus: probed
initcall fixed_mdio_bus_init+0x0/0xf0 returned 0 after 2187 usecs
calling  e1000_init_module+0x0/0x39 @ 1
e1000e: Intel(R) PRO/1000 Network Driver - 1.3.10-k2
e1000e: Copyright(c) 1999 - 2011 Intel Corporation.
initcall e1000_init_module+0x0/0x39 returned 0 after 9187 usecs
calling  cxgb3_init_module+0x0/0x1b @ 1
initcall cxgb3_init_module+0x0/0x1b returned 0 after 73 usecs
calling  cxgb4_init_module+0x0/0x4d @ 1
initcall cxgb4_init_module+0x0/0x4d returned 0 after 78 usecs
calling  atl2_init_module+0x0/0x49 @ 1
Atheros(R) L2 Ethernet Driver - version 2.2.3
Copyright (c) 2007 Atheros Corporation.
initcall atl2_init_module+0x0/0x49 returned 0 after 7577 usecs
calling  plip_init+0x0/0x57 @ 1
NET3 PLIP version 2.4-parport gniibe@mri.co.jp
plip0: Parallel port at 0x378, using IRQ 7.
initcall plip_init+0x0/0x57 returned 0 after 8286 usecs
calling  vortex_init+0x0/0xc0 @ 1
initcall vortex_init+0x0/0xc0 returned 0 after 126 usecs
calling  e100_init_module+0x0/0x5a @ 1
e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
e100: Copyright(c) 1999-2006 Intel Corporation
initcall e100_init_module+0x0/0x5a returned 0 after 8843 usecs
calling  tg3_init+0x0/0x16 @ 1
initcall tg3_init+0x0/0x16 returned 0 after 78 usecs
calling  bnx2_init+0x0/0x16 @ 1
initcall bnx2_init+0x0/0x16 returned 0 after 73 usecs
calling  cnic_init+0x0/0x79 @ 1
cnic: Broadcom NetXtreme II CNIC Driver cnic v2.2.13 (Jan 31, 2011)
initcall cnic_init+0x0/0x79 returned 0 after 5893 usecs
calling  skge_init_module+0x0/0x2e @ 1
initcall skge_init_module+0x0/0x2e returned 0 after 108 usecs
calling  rhine_init+0x0/0x5f @ 1
initcall rhine_init+0x0/0x5f returned 0 after 82 usecs
calling  net_olddevs_init+0x0/0x84 @ 1
D-Link DE-620 pocket adapter io 0x378, which is busy.
initcall net_olddevs_init+0x0/0x84 returned 0 after 4729 usecs
calling  init_nic+0x0/0x16 @ 1
forcedeth: Reverse Engineered nForce ethernet driver. Version 0.64.
ACPI: PCI Interrupt Link [APCH] enabled at IRQ 23
IOAPIC[0]: Set routing entry (2-23 -> 0x61 -> IRQ 23 Mode:1 Active:1)
forcedeth 0000:00:0a.0: PCI INT A -> Link[APCH] -> GSI 23 (level, low) -> IRQ 23
forcedeth 0000:00:0a.0: setting latency timer to 64
forcedeth 0000:00:0a.0: ifname eth0, PHY OUI 0x5043 @ 1, addr 00:13:d4:dc:41:12
forcedeth 0000:00:0a.0: highdma csum gbit lnktim desc-v3
initcall init_nic+0x0/0x16 returned 0 after 549672 usecs
calling  ppp_init+0x0/0xe5 @ 1
PPP generic driver version 2.4.2
initcall ppp_init+0x0/0xe5 returned 0 after 3095 usecs
calling  ppp_async_init+0x0/0x33 @ 1
initcall ppp_async_init+0x0/0x33 returned 0 after 1 usecs
calling  ppp_sync_init+0x0/0x33 @ 1
initcall ppp_sync_init+0x0/0x33 returned 0 after 2 usecs
calling  deflate_init+0x0/0x31 @ 1
PPP Deflate Compression module registered
initcall deflate_init+0x0/0x31 returned 0 after 3666 usecs
calling  bsdcomp_init+0x0/0x27 @ 1
PPP BSD Compression module registered
initcall bsdcomp_init+0x0/0x27 returned 0 after 3327 usecs
calling  ppp_mppe_init+0x0/0xb2 @ 1
PPP MPPE Compression module registered
initcall ppp_mppe_init+0x0/0xb2 returned 0 after 3632 usecs
calling  pppox_init+0x0/0xf @ 1
NET: Registered protocol family 24
initcall pppox_init+0x0/0xf returned 0 after 3073 usecs
calling  pppoe_init+0x0/0x71 @ 1
initcall pppoe_init+0x0/0x71 returned 0 after 16 usecs
calling  slip_init+0x0/0xb4 @ 1
SLIP: version 0.8.4-NET3.019-NEWTTY (dynamic channels, max=256) (6 bit encapsulation enabled).
CSLIP: code copyright 1989 Regents of the University of California.
SLIP linefill/keepalive option.
initcall slip_init+0x0/0xb4 returned 0 after 16842 usecs
calling  de600_init+0x0/0x326 @ 1
DE600: port 0x378 busy
initcall de600_init+0x0/0x326 returned -16 after 2070 usecs
initcall de600_init+0x0/0x326 returned with error code -16 
calling  rtl8139_init_module+0x0/0x16 @ 1
8139too: 8139too Fast Ethernet driver 0.9.28
ACPI: PCI Interrupt Link [APC2] enabled at IRQ 17
IOAPIC[0]: Set routing entry (2-17 -> 0x69 -> IRQ 17 Mode:1 Active:1)
8139too 0000:05:07.0: PCI INT A -> Link[APC2] -> GSI 17 (level, low) -> IRQ 17
8139too 0000:05:07.0: eth1: RealTek RTL8139 at 0xc000, 00:c0:df:03:68:5d, IRQ 17
initcall rtl8139_init_module+0x0/0x16 returned 0 after 28986 usecs
calling  atp_init_module+0x0/0x89 @ 1
atp.c:v1.09=ac 2002/10/01 Donald Becker <becker@scyld.com>
initcall atp_init_module+0x0/0x89 returned -19 after 5134 usecs
calling  rtl8169_init_module+0x0/0x16 @ 1
initcall rtl8169_init_module+0x0/0x16 returned 0 after 75 usecs
calling  hostap_init+0x0/0x3d @ 1
initcall hostap_init+0x0/0x3d returned 0 after 4 usecs
calling  init_netconsole+0x0/0x1cf @ 1
console [netcon0] enabled
netconsole: network logging started
initcall init_netconsole+0x0/0x1cf returned 0 after 5484 usecs
calling  i2o_iop_init+0x0/0x45 @ 1
I2O subsystem v1.325
i2o: max drivers = 8
initcall i2o_iop_init+0x0/0x45 returned 0 after 3988 usecs
calling  i2o_config_init+0x0/0x8b @ 1
I2O Configuration OSM v1.323
initcall i2o_config_init+0x0/0x8b returned 0 after 2760 usecs
calling  i2o_bus_init+0x0/0x3e @ 1
I2O Bus Adapter OSM v1.317
initcall i2o_bus_init+0x0/0x3e returned 0 after 2442 usecs
calling  i2o_block_init+0x0/0x10e @ 1
I2O Block Device OSM v1.325
initcall i2o_block_init+0x0/0x10e returned 0 after 2694 usecs
calling  i2o_scsi_init+0x0/0x3e @ 1
I2O SCSI Peripheral OSM v1.316
initcall i2o_scsi_init+0x0/0x3e returned 0 after 2780 usecs
calling  i2o_proc_init+0x0/0x169 @ 1
I2O ProcFS OSM v1.316
initcall i2o_proc_init+0x0/0x169 returned 0 after 2043 usecs
calling  fusion_init+0x0/0xe9 @ 1
Fusion MPT base driver 3.04.18
Copyright (c) 1999-2008 LSI Corporation
initcall fusion_init+0x0/0xe9 returned 0 after 6233 usecs
calling  mptspi_init+0x0/0xd5 @ 1
Fusion MPT SPI Host driver 3.04.18
initcall mptspi_init+0x0/0xd5 returned 0 after 3151 usecs
calling  mptfc_init+0x0/0xe8 @ 1
Fusion MPT FC Host driver 3.04.18
initcall mptfc_init+0x0/0xe8 returned 0 after 3062 usecs
calling  mptsas_init+0x0/0x111 @ 1
Fusion MPT SAS Host driver 3.04.18
initcall mptsas_init+0x0/0x111 returned 0 after 3164 usecs
calling  mptctl_init+0x0/0x138 @ 1
Fusion MPT misc device (ioctl) driver 3.04.18
mptctl: Registered with Fusion MPT base driver
mptctl: /dev/mptctl @ (major,minor=10,220)
initcall mptctl_init+0x0/0x138 returned 0 after 11976 usecs
calling  mpt_lan_init+0x0/0x7f @ 1
Fusion MPT LAN driver 3.04.18
initcall mpt_lan_init+0x0/0x7f returned 0 after 2648 usecs
calling  fw_core_init+0x0/0x81 @ 1
initcall fw_core_init+0x0/0x81 returned 0 after 57 usecs
calling  fw_ohci_init+0x0/0x16 @ 1
initcall fw_ohci_init+0x0/0x16 returned 0 after 84 usecs
calling  sbp2_init+0x0/0x45 @ 1
initcall sbp2_init+0x0/0x45 returned 0 after 78 usecs
calling  fwnet_init+0x0/0x72 @ 1
initcall fwnet_init+0x0/0x72 returned 0 after 141 usecs
calling  nosy_init+0x0/0x16 @ 1
initcall nosy_init+0x0/0x16 returned 0 after 90 usecs
calling  uio_init+0x0/0xd4 @ 1
initcall uio_init+0x0/0xd4 returned 0 after 55 usecs
calling  cdrom_init+0x0/0x15 @ 1
initcall cdrom_init+0x0/0x15 returned 0 after 1 usecs
calling  nonstatic_sysfs_init+0x0/0xf @ 1
initcall nonstatic_sysfs_init+0x0/0xf returned 0 after 3 usecs
calling  yenta_socket_init+0x0/0x16 @ 1
initcall yenta_socket_init+0x0/0x16 returned 0 after 86 usecs
calling  pd6729_module_init+0x0/0x1b @ 1
initcall pd6729_module_init+0x0/0x1b returned 0 after 82 usecs
calling  init_i82365+0x0/0x45b @ 1
Intel ISA PCIC probe: not found.
initcall init_i82365+0x0/0x45b returned -19 after 3176 usecs
calling  i82092aa_module_init+0x0/0x1b @ 1
initcall i82092aa_module_init+0x0/0x1b returned 0 after 81 usecs
calling  init_tcic+0x0/0x629 @ 1
Databook TCIC-2 PCMCIA probe: not found.
initcall init_tcic+0x0/0x629 returned -19 after 3709 usecs
calling  aoe_init+0x0/0xa2 @ 1
aoe: AoE v47 initialised.
initcall aoe_init+0x0/0xa2 returned 0 after 2816 usecs
calling  uwb_subsys_init+0x0/0x47 @ 1
initcall uwb_subsys_init+0x0/0x47 returned 0 after 50 usecs
calling  umc_bus_init+0x0/0xf @ 1
initcall umc_bus_init+0x0/0xf returned 0 after 49 usecs
calling  whci_init+0x0/0x16 @ 1
initcall whci_init+0x0/0x16 returned 0 after 88 usecs
calling  whcrc_driver_init+0x0/0x16 @ 1
initcall whcrc_driver_init+0x0/0x16 returned 0 after 59 usecs
calling  hwarc_driver_init+0x0/0x16 @ 1
usbcore: registered new interface driver hwa-rc
initcall hwarc_driver_init+0x0/0x16 returned 0 after 4240 usecs
calling  mon_init+0x0/0xe4 @ 1
initcall mon_init+0x0/0xe4 returned 0 after 144 usecs
calling  whci_hc_driver_init+0x0/0x16 @ 1
initcall whci_hc_driver_init+0x0/0x16 returned 0 after 65 usecs
calling  ehci_hcd_init+0x0/0x6f @ 1
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ACPI: PCI Interrupt Link [APCL] enabled at IRQ 22
IOAPIC[0]: Set routing entry (2-22 -> 0x71 -> IRQ 22 Mode:1 Active:1)
ehci_hcd 0000:00:02.1: PCI INT B -> Link[APCL] -> GSI 22 (level, low) -> IRQ 22
ehci_hcd 0000:00:02.1: setting latency timer to 64
ehci_hcd 0000:00:02.1: EHCI Host Controller
ehci_hcd 0000:00:02.1: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:02.1: debug port 1
ehci_hcd 0000:00:02.1: cache line size of 32 is not supported
ehci_hcd 0000:00:02.1: irq 22, io mem 0x40000000
ehci_hcd 0000:00:02.1: USB 2.0 started, EHCI 1.00
usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.39-rc5-i486-1sys+ ehci_hcd
usb usb1: SerialNumber: 0000:00:02.1
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 10 ports detected
initcall ehci_hcd_init+0x0/0x6f returned 0 after 93116 usecs
calling  oxu_module_init+0x0/0xf @ 1
initcall oxu_module_init+0x0/0xf returned 0 after 52 usecs
calling  isp116x_init+0x0/0x3e @ 1
116x: driver isp116x-hcd, 03 Nov 2005
initcall isp116x_init+0x0/0x3e returned 0 after 3370 usecs
calling  isp1362_init+0x0/0x3e @ 1
driver isp1362-hcd, 2005-04-04
initcall isp1362_init+0x0/0x3e returned 0 after 2780 usecs
calling  ohci_hcd_mod_init+0x0/0x51 @ 1
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
ACPI: PCI Interrupt Link [APCF] enabled at IRQ 21
IOAPIC[0]: Set routing entry (2-21 -> 0x79 -> IRQ 21 Mode:1 Active:1)
ohci_hcd 0000:00:02.0: PCI INT A -> Link[APCF] -> GSI 21 (level, low) -> IRQ 21
ohci_hcd 0000:00:02.0: setting latency timer to 64
ohci_hcd 0000:00:02.0: OHCI Host Controller
ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus number 2
ohci_hcd 0000:00:02.0: irq 21, io mem 0xda102000
usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: OHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.39-rc5-i486-1sys+ ohci_hcd
usb usb2: SerialNumber: 0000:00:02.0
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 10 ports detected
initcall ohci_hcd_mod_init+0x0/0x51 returned 0 after 124871 usecs
calling  uhci_hcd_init+0x0/0xb8 @ 1
uhci_hcd: USB Universal Host Controller Interface driver
initcall uhci_hcd_init+0x0/0xb8 returned 0 after 5069 usecs
calling  xhci_hcd_init+0x0/0x26 @ 1
initcall xhci_hcd_init+0x0/0x26 returned 0 after 80 usecs
calling  sl811h_init+0x0/0x3e @ 1
sl811: driver sl811-hcd, 19 May 2005
initcall sl811h_init+0x0/0x3e returned 0 after 3292 usecs
calling  init_sl811_cs+0x0/0xf @ 1
initcall init_sl811_cs+0x0/0xf returned 0 after 47 usecs
calling  r8a66597_init+0x0/0x3e @ 1
r8a66597_hcd: driver r8a66597_hcd, 2009-05-26
initcall r8a66597_init+0x0/0x3e returned 0 after 4051 usecs
calling  isp1760_init+0x0/0x44 @ 1
initcall isp1760_init+0x0/0x44 returned 0 after 157 usecs
calling  hwahc_driver_init+0x0/0x16 @ 1
usbcore: registered new interface driver hwa-hc
initcall hwahc_driver_init+0x0/0x16 returned 0 after 4248 usecs
calling  c67x00_init+0x0/0xf @ 1
initcall c67x00_init+0x0/0xf returned 0 after 48 usecs
calling  wusbcore_init+0x0/0x73 @ 1
initcall wusbcore_init+0x0/0x73 returned 0 after 27 usecs
calling  cbaf_driver_init+0x0/0x16 @ 1
usbcore: registered new interface driver wusb-cbaf
initcall cbaf_driver_init+0x0/0x16 returned 0 after 4512 usecs
calling  acm_init+0x0/0xcd @ 1
usbcore: registered new interface driver cdc_acm
cdc_acm: v0.26:USB Abstract Control Model driver for USB modems and ISDN adapters
initcall acm_init+0x0/0xcd returned 0 after 11392 usecs
calling  usblp_init+0x0/0x16 @ 1
usbcore: registered new interface driver usblp
initcall usblp_init+0x0/0x16 returned 0 after 4159 usecs
calling  wdm_init+0x0/0x16 @ 1
usbcore: registered new interface driver cdc_wdm
initcall wdm_init+0x0/0x16 returned 0 after 4320 usecs
calling  usbtmc_init+0x0/0x2e @ 1
usbcore: registered new interface driver usbtmc
initcall usbtmc_init+0x0/0x2e returned 0 after 4243 usecs
calling  uas_init+0x0/0x1b @ 1
usbcore: registered new interface driver uas
initcall uas_init+0x0/0x1b returned 0 after 3989 usecs
calling  usb_stor_init+0x0/0x44 @ 1
Initializing USB Mass Storage driver...
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
initcall usb_stor_init+0x0/0x44 returned 0 after 11419 usecs
calling  usb_usual_init+0x0/0x30 @ 1
usbcore: registered new interface driver libusual
initcall usb_usual_init+0x0/0x30 returned 0 after 4436 usecs
calling  alauda_init+0x0/0x16 @ 1
usbcore: registered new interface driver ums-alauda
initcall alauda_init+0x0/0x16 returned 0 after 4588 usecs
calling  cypress_init+0x0/0x16 @ 1
usbcore: registered new interface driver ums-cypress
initcall cypress_init+0x0/0x16 returned 0 after 4681 usecs
calling  datafab_init+0x0/0x16 @ 1
usbcore: registered new interface driver ums-datafab
initcall datafab_init+0x0/0x16 returned 0 after 4667 usecs
calling  ene_ub6250_init+0x0/0x16 @ 1
usbcore: registered new interface driver ums_eneub6250
initcall ene_ub6250_init+0x0/0x16 returned 0 after 4835 usecs
calling  freecom_init+0x0/0x16 @ 1
usbcore: registered new interface driver ums-freecom
initcall freecom_init+0x0/0x16 returned 0 after 4669 usecs
calling  isd200_init+0x0/0x16 @ 1
usbcore: registered new interface driver ums-isd200
initcall isd200_init+0x0/0x16 returned 0 after 4585 usecs
calling  jumpshot_init+0x0/0x16 @ 1
usbcore: registered new interface driver ums-jumpshot
initcall jumpshot_init+0x0/0x16 returned 0 after 4754 usecs
calling  karma_init+0x0/0x16 @ 1
usbcore: registered new interface driver ums-karma
initcall karma_init+0x0/0x16 returned 0 after 4498 usecs
calling  onetouch_init+0x0/0x16 @ 1
usbcore: registered new interface driver ums-onetouch
initcall onetouch_init+0x0/0x16 returned 0 after 4754 usecs
calling  realtek_cr_init+0x0/0x16 @ 1
usbcore: registered new interface driver ums-realtek
initcall realtek_cr_init+0x0/0x16 returned 0 after 4674 usecs
calling  sddr09_init+0x0/0x16 @ 1
usbcore: registered new interface driver ums-sddr09
initcall sddr09_init+0x0/0x16 returned 0 after 4581 usecs
calling  sddr55_init+0x0/0x16 @ 1
usbcore: registered new interface driver ums-sddr55
initcall sddr55_init+0x0/0x16 returned 0 after 4584 usecs
calling  usbat_init+0x0/0x16 @ 1
usbcore: registered new interface driver ums-usbat
initcall usbat_init+0x0/0x16 returned 0 after 4491 usecs
calling  i8042_init+0x0/0x3b1 @ 1
i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
initcall i8042_init+0x0/0x3b1 returned 0 after 17592 usecs
calling  parkbd_init+0x0/0x17a @ 1
parport0: cannot grant exclusive access for device parkbd
initcall parkbd_init+0x0/0x17a returned -19 after 5032 usecs
calling  serport_init+0x0/0x2c @ 1
initcall serport_init+0x0/0x2c returned 0 after 2 usecs
calling  ct82c710_init+0x0/0x13c @ 1
initcall ct82c710_init+0x0/0x13c returned -19 after 12 usecs
calling  pcips2_init+0x0/0x16 @ 1
initcall pcips2_init+0x0/0x16 returned 0 after 90 usecs
calling  ps2mult_init+0x0/0x16 @ 1
initcall ps2mult_init+0x0/0x16 returned 0 after 63 usecs
calling  serio_raw_init+0x0/0x16 @ 1
initcall serio_raw_init+0x0/0x16 returned 0 after 62 usecs
calling  altera_ps2_init+0x0/0xf @ 1
initcall altera_ps2_init+0x0/0xf returned 0 after 47 usecs
calling  emu_init+0x0/0x16 @ 1
initcall emu_init+0x0/0x16 returned 0 after 93 usecs
calling  fm801_gp_init+0x0/0x16 @ 1
initcall fm801_gp_init+0x0/0x16 returned 0 after 79 usecs
calling  l4_init+0x0/0x268 @ 1
initcall l4_init+0x0/0x268 returned -19 after 12 usecs
calling  ns558_init+0x0/0x2d9 @ 1
gameport gameport0: NS558 PnP Gameport is pnp00:0d/gameport0, io 0x201, speed 59659kHz
initcall ns558_init+0x0/0x2d9 returned 0 after 30583 usecs
calling  mousedev_init+0x0/0x7f @ 1
mousedev: PS/2 mouse device common for all mice
initcall mousedev_init+0x0/0x7f returned 0 after 4398 usecs
calling  joydev_init+0x0/0xf @ 1
initcall joydev_init+0x0/0xf returned 0 after 3 usecs
calling  evdev_init+0x0/0xf @ 1
initcall evdev_init+0x0/0xf returned 0 after 159 usecs
calling  adp5520_keys_init+0x0/0xf @ 1
initcall adp5520_keys_init+0x0/0xf returned 0 after 49 usecs
calling  adp5588_init+0x0/0x11 @ 1
initcall adp5588_init+0x0/0x11 returned 0 after 52 usecs
calling  atkbd_init+0x0/0x20 @ 1
initcall atkbd_init+0x0/0x20 returned 0 after 74 usecs
calling  gpio_keys_init+0x0/0xf @ 1
initcall gpio_keys_init+0x0/0xf returned 0 after 59 usecs
calling  gpio_keys_polled_init+0x0/0xf @ 1
initcall gpio_keys_polled_init+0x0/0xf returned 0 after 56 usecs
calling  lkkbd_init+0x0/0x16 @ 1
initcall lkkbd_init+0x0/0x16 returned 0 after 70 usecs
calling  lm8323_init+0x0/0x11 @ 1
initcall lm8323_init+0x0/0x11 returned 0 after 54 usecs
calling  matrix_keypad_init+0x0/0xf @ 1
initcall matrix_keypad_init+0x0/0xf returned 0 after 53 usecs
calling  max7359_init+0x0/0x11 @ 1
initcall max7359_init+0x0/0x11 returned 0 after 70 usecs
calling  mcs_touchkey_init+0x0/0x11 @ 1
input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input2
initcall mcs_touchkey_init+0x0/0x11 returned 0 after 7290 usecs
calling  nkbd_init+0x0/0x16 @ 1
initcall nkbd_init+0x0/0x16 returned 0 after 71 usecs
calling  opencores_kbd_init+0x0/0xf @ 1
initcall opencores_kbd_init+0x0/0xf returned 0 after 56 usecs
calling  qt1070_init+0x0/0x11 @ 1
initcall qt1070_init+0x0/0x11 returned 0 after 49 usecs
calling  qt2160_init+0x0/0x11 @ 1
initcall qt2160_init+0x0/0x11 returned 0 after 46 usecs
calling  stmpe_keypad_init+0x0/0xf @ 1
initcall stmpe_keypad_init+0x0/0xf returned 0 after 49 usecs
calling  skbd_init+0x0/0x16 @ 1
initcall skbd_init+0x0/0x16 returned 0 after 66 usecs
calling  sunkbd_init+0x0/0x16 @ 1
initcall sunkbd_init+0x0/0x16 returned 0 after 75 usecs
calling  tc3589x_keypad_init+0x0/0xf @ 1
initcall tc3589x_keypad_init+0x0/0xf returned 0 after 57 usecs
calling  twl4030_kp_init+0x0/0xf @ 1
initcall twl4030_kp_init+0x0/0xf returned 0 after 48 usecs
calling  xtkbd_init+0x0/0x16 @ 1
initcall xtkbd_init+0x0/0x16 returned 0 after 65 usecs
calling  atp_init+0x0/0x16 @ 1
usbcore: registered new interface driver appletouch
initcall atp_init+0x0/0x16 returned 0 after 4593 usecs
calling  bcm5974_init+0x0/0x16 @ 1
usbcore: registered new interface driver bcm5974
initcall bcm5974_init+0x0/0x16 returned 0 after 4329 usecs
calling  gpio_mouse_init+0x0/0xf @ 1
initcall gpio_mouse_init+0x0/0xf returned 0 after 48 usecs
calling  inport_init+0x0/0x131 @ 1
inport.c: Didn't find InPort mouse at 0x23c
initcall inport_init+0x0/0x131 returned -19 after 3844 usecs
calling  logibm_init+0x0/0x139 @ 1
logibm.c: Didn't find Logitech busmouse at 0x23c
initcall logibm_init+0x0/0x139 returned -19 after 4365 usecs
calling  pc110pad_init+0x0/0x1a2 @ 1
initcall pc110pad_init+0x0/0x1a2 returned -19 after 2 usecs
calling  psmouse_init+0x0/0x7d @ 1
initcall psmouse_init+0x0/0x7d returned 0 after 108 usecs
calling  sermouse_init+0x0/0x16 @ 1
initcall sermouse_init+0x0/0x16 returned 0 after 130 usecs
calling  synaptics_i2c_init+0x0/0x11 @ 1
initcall synaptics_i2c_init+0x0/0x11 returned 0 after 111 usecs
calling  vsxxxaa_init+0x0/0x16 @ 1
initcall vsxxxaa_init+0x0/0x16 returned 0 after 123 usecs
calling  analog_init+0x0/0xc9 @ 1
initcall analog_init+0x0/0xc9 returned 0 after 124 usecs
calling  usb_acecad_init+0x0/0x2e @ 1
usbcore: registered new interface driver usb_acecad
acecad: v3.2:USB Acecad Flair tablet driver
initcall usb_acecad_init+0x0/0x2e returned 0 after 8414 usecs
calling  aiptek_init+0x0/0x3a @ 1
usbcore: registered new interface driver aiptek
aiptek: v2.3 (May 2, 2007):Aiptek HyperPen USB Tablet Driver (Linux 2.6.x)
aiptek: Bryan W. Headley/Chris Atenasio/Cedric Brun/Rene van Paassen
initcall aiptek_init+0x0/0x3a returned 0 after 16662 usecs
calling  gtco_init+0x0/0x46 @ 1
usbcore: registered new interface driver gtco
GTCO usb driver version: 2.00.0006
initcall gtco_init+0x0/0x46 returned 0 after 6982 usecs
calling  hanwang_init+0x0/0x16 @ 1
usbcore: registered new interface driver hanwang
initcall hanwang_init+0x0/0x16 returned 0 after 4329 usecs
calling  kbtab_init+0x0/0x2e @ 1
usbcore: registered new interface driver kbtab
kbtab: v0.0.2:USB KB Gear JamStudio Tablet driver
initcall kbtab_init+0x0/0x2e returned 0 after 8516 usecs
calling  wacom_init+0x0/0x2e @ 1
usbcore: registered new interface driver wacom
wacom: v1.52:USB Wacom tablet driver
initcall wacom_init+0x0/0x2e returned 0 after 7403 usecs
calling  pm860x_touch_init+0x0/0xf @ 1
initcall pm860x_touch_init+0x0/0xf returned 0 after 54 usecs
calling  ad7877_init+0x0/0xf @ 1
initcall ad7877_init+0x0/0xf returned 0 after 47 usecs
calling  ad7879_i2c_init+0x0/0x11 @ 1
initcall ad7879_i2c_init+0x0/0x11 returned 0 after 48 usecs
calling  ad7879_spi_init+0x0/0xf @ 1
initcall ad7879_spi_init+0x0/0xf returned 0 after 48 usecs
calling  ads7846_init+0x0/0xf @ 1
initcall ads7846_init+0x0/0xf returned 0 after 47 usecs
calling  mxt_init+0x0/0x11 @ 1
initcall mxt_init+0x0/0x11 returned 0 after 47 usecs
calling  bu21013_init+0x0/0x11 @ 1
initcall bu21013_init+0x0/0x11 returned 0 after 63 usecs
calling  cy8ctmg110_init+0x0/0x11 @ 1
initcall cy8ctmg110_init+0x0/0x11 returned 0 after 46 usecs
calling  da9034_touch_init+0x0/0xf @ 1
initcall da9034_touch_init+0x0/0xf returned 0 after 48 usecs
calling  dynapro_init+0x0/0x16 @ 1
initcall dynapro_init+0x0/0x16 returned 0 after 67 usecs
calling  hampshire_init+0x0/0x16 @ 1
initcall hampshire_init+0x0/0x16 returned 0 after 215 usecs
calling  gunze_init+0x0/0x16 @ 1
initcall gunze_init+0x0/0x16 returned 0 after 75 usecs
calling  eeti_ts_init+0x0/0x11 @ 1
initcall eeti_ts_init+0x0/0x11 returned 0 after 47 usecs
calling  elo_init+0x0/0x16 @ 1
initcall elo_init+0x0/0x16 returned 0 after 64 usecs
calling  fujitsu_init+0x0/0x16 @ 1
initcall fujitsu_init+0x0/0x16 returned 0 after 78 usecs
calling  inexio_init+0x0/0x16 @ 1
initcall inexio_init+0x0/0x16 returned 0 after 70 usecs
psmouse serio1: ID: 00 00 14
calling  mcs5000_ts_init+0x0/0x11 @ 1
initcall mcs5000_ts_init+0x0/0x11 returned 0 after 49 usecs
calling  mtouch_init+0x0/0x16 @ 1
initcall mtouch_init+0x0/0x16 returned 0 after 66 usecs
calling  mk712_init+0x0/0x1bf @ 1
mk712: device not present
initcall mk712_init+0x0/0x1bf returned -19 after 2324 usecs
calling  htcpen_isa_init+0x0/0x29 @ 1
initcall htcpen_isa_init+0x0/0x29 returned -19 after 2 usecs
calling  usbtouch_init+0x0/0x16 @ 1
usbcore: registered new interface driver usbtouchscreen
initcall usbtouch_init+0x0/0x16 returned 0 after 4927 usecs
calling  pcap_ts_init+0x0/0xf @ 1
initcall pcap_ts_init+0x0/0xf returned 0 after 69 usecs
calling  pm_init+0x0/0x16 @ 1
initcall pm_init+0x0/0x16 returned 0 after 66 usecs
calling  st1232_ts_init+0x0/0x11 @ 1
initcall st1232_ts_init+0x0/0x11 returned 0 after 48 usecs
calling  stmpe_ts_init+0x0/0xf @ 1
initcall stmpe_ts_init+0x0/0xf returned 0 after 49 usecs
calling  touchit213_init+0x0/0x16 @ 1
initcall touchit213_init+0x0/0x16 returned 0 after 253 usecs
calling  tr_init+0x0/0x16 @ 1
initcall tr_init+0x0/0x16 returned 0 after 63 usecs
calling  tw_init+0x0/0x16 @ 1
initcall tw_init+0x0/0x16 returned 0 after 68 usecs
calling  tsc2005_init+0x0/0xf @ 1
initcall tsc2005_init+0x0/0xf returned 0 after 45 usecs
calling  tsc2007_init+0x0/0x11 @ 1
initcall tsc2007_init+0x0/0x11 returned 0 after 47 usecs
calling  w8001_init+0x0/0x16 @ 1
initcall w8001_init+0x0/0x16 returned 0 after 63 usecs
calling  wm831x_ts_init+0x0/0xf @ 1
initcall wm831x_ts_init+0x0/0xf returned 0 after 49 usecs
calling  tps6507x_ts_init+0x0/0xf @ 1
initcall tps6507x_ts_init+0x0/0xf returned 0 after 49 usecs
calling  pm860x_onkey_init+0x0/0xf @ 1
initcall pm860x_onkey_init+0x0/0xf returned 0 after 48 usecs
calling  ab8500_ponkey_init+0x0/0xf @ 1
initcall ab8500_ponkey_init+0x0/0xf returned 0 after 48 usecs
calling  ad714x_i2c_init+0x0/0x11 @ 1
initcall ad714x_i2c_init+0x0/0x11 returned 0 after 48 usecs
calling  ad714x_spi_init+0x0/0xf @ 1
initcall ad714x_spi_init+0x0/0xf returned 0 after 45 usecs
calling  adxl34x_i2c_init+0x0/0x11 @ 1
initcall adxl34x_i2c_init+0x0/0x11 returned 0 after 46 usecs
calling  adxl34x_spi_init+0x0/0xf @ 1
initcall adxl34x_spi_init+0x0/0xf returned 0 after 45 usecs
calling  apanel_init+0x0/0x191 @ 1
apanel: Fujitsu BIOS signature 'FJKEYINF' not found...
initcall apanel_init+0x0/0x191 returned -19 after 5061 usecs
calling  ati_remote_init+0x0/0x43 @ 1
usbcore: registered new interface driver ati_remote
ati_remote: 2.2.1:ATI/X10 RF USB Remote Control
initcall ati_remote_init+0x0/0x43 returned 0 after 8769 usecs
calling  ati_remote2_init+0x0/0x43 @ 1
usbcore: registered new interface driver ati_remote2
ati_remote2: ATI/Philips USB RF remote driver 0.3
initcall ati_remote2_init+0x0/0x43 returned 0 after 9005 usecs
calling  atlas_acpi_init+0x0/0x1d @ 1
initcall atlas_acpi_init+0x0/0x1d returned 0 after 74 usecs
calling  cm109_init+0x0/0xea @ 1
cm109: Keymap for Komunikate KIP1000 phone loaded
usbcore: registered new interface driver cm109
cm109: CM109 phone driver: 20080805 (C) Alfred E. Heggestad
initcall cm109_init+0x0/0xea returned 0 after 13701 usecs
calling  cma3000_i2c_init+0x0/0x11 @ 1
initcall cma3000_i2c_init+0x0/0x11 returned 0 after 48 usecs
calling  usb_keyspan_init+0x0/0x35 @ 1
usbcore: registered new interface driver keyspan_remote
initcall usb_keyspan_init+0x0/0x35 returned 0 after 4921 usecs
calling  max8925_onkey_init+0x0/0xf @ 1
initcall max8925_onkey_init+0x0/0xf returned 0 after 49 usecs
calling  pcap_keys_init+0x0/0xf @ 1
initcall pcap_keys_init+0x0/0xf returned 0 after 47 usecs
calling  pcf8574_kp_init+0x0/0x11 @ 1
initcall pcf8574_kp_init+0x0/0x11 returned 0 after 47 usecs
calling  pcspkr_init+0x0/0xf @ 1
input: PC Speaker as /devices/platform/pcspkr/input/input3
initcall pcspkr_init+0x0/0xf returned 0 after 5355 usecs
calling  powermate_init+0x0/0x16 @ 1
usbcore: registered new interface driver powermate
initcall powermate_init+0x0/0x16 returned 0 after 4508 usecs
calling  rotary_encoder_init+0x0/0xf @ 1
initcall rotary_encoder_init+0x0/0xf returned 0 after 51 usecs
calling  twl4030_pwrbutton_init+0x0/0x14 @ 1
initcall twl4030_pwrbutton_init+0x0/0x14 returned -19 after 90 usecs
calling  twl4030_vibra_init+0x0/0xf @ 1
initcall twl4030_vibra_init+0x0/0xf returned 0 after 48 usecs
calling  uinput_init+0x0/0xf @ 1
initcall uinput_init+0x0/0xf returned 0 after 79 usecs
calling  wb_module_init+0x0/0x297 @ 1
wistron_btns: System unknown
initcall wb_module_init+0x0/0x297 returned -19 after 2580 usecs
calling  wm831x_on_init+0x0/0xf @ 1
initcall wm831x_on_init+0x0/0xf returned 0 after 48 usecs
calling  yealink_dev_init+0x0/0x2e @ 1
usbcore: registered new interface driver yealink
yealink: yld-20051230:Yealink phone driver
initcall yealink_dev_init+0x0/0x2e returned 0 after 8083 usecs
calling  i2c_dev_init+0x0/0xb8 @ 1
i2c /dev entries driver
initcall i2c_dev_init+0x0/0xb8 returned 0 after 2194 usecs
calling  ce4100_i2c_init+0x0/0x16 @ 1
initcall ce4100_i2c_init+0x0/0x16 returned 0 after 98 usecs
calling  media_devnode_init+0x0/0x73 @ 1
Linux media interface: v0.10
initcall media_devnode_init+0x0/0x73 returned 0 after 2612 usecs
calling  init_rc_map_adstech_dvb_t_pci+0x0/0xf @ 1
initcall init_rc_map_adstech_dvb_t_pci+0x0/0xf returned 0 after 2 usecs
calling  init_rc_map_alink_dtu_m+0x0/0xf @ 1
initcall init_rc_map_alink_dtu_m+0x0/0xf returned 0 after 1 usecs
calling  init_rc_map_anysee+0x0/0xf @ 1
initcall init_rc_map_anysee+0x0/0xf returned 0 after 1 usecs
calling  init_rc_map_apac_viewcomp+0x0/0xf @ 1
initcall init_rc_map_apac_viewcomp+0x0/0xf returned 0 after 1 usecs
calling  init_rc_map_asus_pc39+0x0/0xf @ 1
initcall init_rc_map_asus_pc39+0x0/0xf returned 0 after 1 usecs
calling  init_rc_map_ati_tv_wonder_hd_600+0x0/0xf @ 1
initcall init_rc_map_ati_tv_wonder_hd_600+0x0/0xf returned 0 after 1 usecs
calling  init_rc_map_avermedia_a16d+0x0/0xf @ 1
initcall init_rc_map_avermedia_a16d+0x0/0xf returned 0 after 2 usecs
calling  init_rc_map_avermedia+0x0/0xf @ 1
initcall init_rc_map_avermedia+0x0/0xf returned 0 after 1 usecs
calling  init_rc_map_avermedia_cardbus+0x0/0xf @ 1
initcall init_rc_map_avermedia_cardbus+0x0/0xf returned 0 after 2 usecs
calling  init_rc_map_avermedia_dvbt+0x0/0xf @ 1
initcall init_rc_map_avermedia_dvbt+0x0/0xf returned 0 after 2 usecs
calling  init_rc_map_avermedia_m135a+0x0/0xf @ 1
initcall init_rc_map_avermedia_m135a+0x0/0xf returned 0 after 2 usecs
calling  init_rc_map_avermedia_m733a_rm_k6+0x0/0xf @ 1
initcall init_rc_map_avermedia_m733a_rm_k6+0x0/0xf returned 0 after 1 usecs
calling  init_rc_map_avermedia_rm_ks+0x0/0xf @ 1
initcall init_rc_map_avermedia_rm_ks+0x0/0xf returned 0 after 2 usecs
calling  init_rc_map_avertv_303+0x0/0xf @ 1
initcall init_rc_map_avertv_303+0x0/0xf returned 0 after 1 usecs
calling  init_rc_map_azurewave_ad_tu700+0x0/0xf @ 1
initcall init_rc_map_azurewave_ad_tu700+0x0/0xf returned 0 after 1 usecs
calling  init_rc_map_behold+0x0/0xf @ 1
initcall init_rc_map_behold+0x0/0xf returned 0 after 1 usecs
calling  init_rc_map_behold_columbus+0x0/0xf @ 1
initcall init_rc_map_behold_columbus+0x0/0xf returned 0 after 1 usecs
calling  init_rc_map_budget_ci_old+0x0/0xf @ 1
initcall init_rc_map_budget_ci_old+0x0/0xf returned 0 after 1 usecs
calling  init_rc_map_cinergy_1400+0x0/0xf @ 1
initcall init_rc_map_cinergy_1400+0x0/0xf returned 0 after 1 usecs
calling  init_rc_map_cinergy+0x0/0xf @ 1
initcall init_rc_map_cinergy+0x0/0xf returned 0 after 1 usecs
calling  init_rc_map+0x0/0xf @ 1
initcall init_rc_map+0x0/0xf returned 0 after 2 usecs
calling  init_rc_map+0x0/0xf @ 1
initcall init_rc_map+0x0/0xf returned 0 after 1 usecs
calling  init_rc_map_digitalnow_tinytwin+0x0/0xf @ 1
initcall init_rc_map_digitalnow_tinytwin+0x0/0xf returned 0 after 1 usecs
calling  init_rc_map_digittrade+0x0/0xf @ 1
initcall init_rc_map_digittrade+0x0/0xf returned 0 after 1 usecs
calling  init_rc_map_dm1105_nec+0x0/0xf @ 1
initcall init_rc_map_dm1105_nec+0x0/0xf returned 0 after 1 usecs
calling  init_rc_map_dntv_live_dvb_t+0x0/0xf @ 1
initcall init_rc_map_dntv_live_dvb_t+0x0/0xf returned 0 after 1 usecs
calling  init_rc_map_dntv_live_dvbt_pro+0x0/0xf @ 1
initcall init_rc_map_dntv_live_dvbt_pro+0x0/0xf returned 0 after 1 usecs
calling  init_rc_map_em_terratec+0x0/0xf @ 1
initcall init_rc_map_em_terratec+0x0/0xf returned 0 after 1 usecs
calling  init_rc_map_encore_enltv2+0x0/0xf @ 1
initcall init_rc_map_encore_enltv2+0x0/0xf returned 0 after 1 usecs
calling  init_rc_map_encore_enltv+0x0/0xf @ 1
initcall init_rc_map_encore_enltv+0x0/0xf returned 0 after 1 usecs
calling  init_rc_map_encore_enltv_fm53+0x0/0xf @ 1
initcall init_rc_map_encore_enltv_fm53+0x0/0xf returned 0 after 1 usecs
calling  init_rc_map_evga_indtube+0x0/0xf @ 1
initcall init_rc_map_evga_indtube+0x0/0xf returned 0 after 1 usecs
calling  init_rc_map_eztv+0x0/0xf @ 1
initcall init_rc_map_eztv+0x0/0xf returned 0 after 1 usecs
calling  init_rc_map_flydvb+0x0/0xf @ 1
initcall init_rc_map_flydvb+0x0/0xf returned 0 after 1 usecs
calling  init_rc_map_flyvideo+0x0/0xf @ 1
initcall init_rc_map_flyvideo+0x0/0xf returned 0 after 2 usecs
calling  init_rc_map_fusionhdtv_mce+0x0/0xf @ 1
initcall init_rc_map_fusionhdtv_mce+0x0/0xf returned 0 after 1 usecs
calling  init_rc_map_gadmei_rm008z+0x0/0xf @ 1
initcall init_rc_map_gadmei_rm008z+0x0/0xf returned 0 after 1 usecs
calling  init_rc_map_genius_tvgo_a11mce+0x0/0xf @ 1
initcall init_rc_map_genius_tvgo_a11mce+0x0/0xf returned 0 after 1 usecs
calling  init_rc_map_gotview7135+0x0/0xf @ 1
initcall init_rc_map_gotview7135+0x0/0xf returned 0 after 2 usecs
calling  init_rc_map_imon_mce+0x0/0xf @ 1
initcall init_rc_map_imon_mce+0x0/0xf returned 0 after 1 usecs
calling  init_rc_map_imon_pad+0x0/0xf @ 1
initcall init_rc_map_imon_pad+0x0/0xf returned 0 after 1 usecs
calling  init_rc_map_iodata_bctv7e+0x0/0xf @ 1
initcall init_rc_map_iodata_bctv7e+0x0/0xf returned 0 after 1 usecs
calling  init_rc_map_kaiomy+0x0/0xf @ 1
initcall init_rc_map_kaiomy+0x0/0xf returned 0 after 1 usecs
calling  init_rc_map_kworld_315u+0x0/0xf @ 1
initcall init_rc_map_kworld_315u+0x0/0xf returned 0 after 1 usecs
calling  init_rc_map_kworld_plus_tv_analog+0x0/0xf @ 1
initcall init_rc_map_kworld_plus_tv_analog+0x0/0xf returned 0 after 1 usecs
calling  init_rc_map_leadtek_y04g0051+0x0/0xf @ 1
initcall init_rc_map_leadtek_y04g0051+0x0/0xf returned 0 after 1 usecs
calling  init_rc_map_lirc+0x0/0xf @ 1
initcall init_rc_map_lirc+0x0/0xf returned 0 after 1 usecs
calling  init_rc_lme2510_map+0x0/0xf @ 1
initcall init_rc_lme2510_map+0x0/0xf returned 0 after 1 usecs
calling  init_rc_map_manli+0x0/0xf @ 1
initcall init_rc_map_manli+0x0/0xf returned 0 after 1 usecs
calling  init_rc_map_msi_digivox_ii+0x0/0xf @ 1
initcall init_rc_map_msi_digivox_ii+0x0/0xf returned 0 after 1 usecs
calling  init_rc_map_msi_digivox_iii+0x0/0xf @ 1
initcall init_rc_map_msi_digivox_iii+0x0/0xf returned 0 after 1 usecs
calling  init_rc_map_msi_tvanywhere+0x0/0xf @ 1
initcall init_rc_map_msi_tvanywhere+0x0/0xf returned 0 after 1 usecs
calling  init_rc_map_msi_tvanywhere_plus+0x0/0xf @ 1
initcall init_rc_map_msi_tvanywhere_plus+0x0/0xf returned 0 after 2 usecs
calling  init_rc_map_nebula+0x0/0xf @ 1
initcall init_rc_map_nebula+0x0/0xf returned 0 after 1 usecs
calling  init_rc_map_nec_terratec_cinergy_xs+0x0/0xf @ 1
initcall init_rc_map_nec_terratec_cinergy_xs+0x0/0xf returned 0 after 1 usecs
calling  init_rc_map_norwood+0x0/0xf @ 1
initcall init_rc_map_norwood+0x0/0xf returned 0 after 1 usecs
calling  init_rc_map_npgtech+0x0/0xf @ 1
initcall init_rc_map_npgtech+0x0/0xf returned 0 after 1 usecs
calling  init_rc_map_pctv_sedna+0x0/0xf @ 1
initcall init_rc_map_pctv_sedna+0x0/0xf returned 0 after 1 usecs
calling  init_rc_map_pinnacle_color+0x0/0xf @ 1
initcall init_rc_map_pinnacle_color+0x0/0xf returned 0 after 2 usecs
calling  init_rc_map_pinnacle_grey+0x0/0xf @ 1
initcall init_rc_map_pinnacle_grey+0x0/0xf returned 0 after 1 usecs
calling  init_rc_map_pinnacle_pctv_hd+0x0/0xf @ 1
initcall init_rc_map_pinnacle_pctv_hd+0x0/0xf returned 0 after 1 usecs
calling  init_rc_map_pixelview+0x0/0xf @ 1
initcall init_rc_map_pixelview+0x0/0xf returned 0 after 1 usecs
calling  init_rc_map_pixelview+0x0/0xf @ 1
initcall init_rc_map_pixelview+0x0/0xf returned 0 after 1 usecs
calling  init_rc_map_pixelview+0x0/0xf @ 1
initcall init_rc_map_pixelview+0x0/0xf returned 0 after 1 usecs
calling  init_rc_map_pixelview_new+0x0/0xf @ 1
initcall init_rc_map_pixelview_new+0x0/0xf returned 0 after 1 usecs
calling  init_rc_map_powercolor_real_angel+0x0/0xf @ 1
initcall init_rc_map_powercolor_real_angel+0x0/0xf returned 0 after 1 usecs
calling  init_rc_map_proteus_2309+0x0/0xf @ 1
initcall init_rc_map_proteus_2309+0x0/0xf returned 0 after 2 usecs
calling  init_rc_map_purpletv+0x0/0xf @ 1
initcall init_rc_map_purpletv+0x0/0xf returned 0 after 2 usecs
calling  init_rc_map_pv951+0x0/0xf @ 1
initcall init_rc_map_pv951+0x0/0xf returned 0 after 1 usecs
calling  init_rc_map_rc5_hauppauge_new+0x0/0xf @ 1
initcall init_rc_map_rc5_hauppauge_new+0x0/0xf returned 0 after 1 usecs
calling  init_rc_map_rc6_mce+0x0/0xf @ 1
initcall init_rc_map_rc6_mce+0x0/0xf returned 0 after 1 usecs
calling  init_rc_map_real_audio_220_32_keys+0x0/0xf @ 1
initcall init_rc_map_real_audio_220_32_keys+0x0/0xf returned 0 after 1 usecs
calling  init_rc_map_streamzap+0x0/0xf @ 1
initcall init_rc_map_streamzap+0x0/0xf returned 0 after 1 usecs
calling  init_rc_map_tbs_nec+0x0/0xf @ 1
initcall init_rc_map_tbs_nec+0x0/0xf returned 0 after 1 usecs
calling  init_rc_map+0x0/0xf @ 1
initcall init_rc_map+0x0/0xf returned 0 after 1 usecs
calling  init_rc_map_terratec_cinergy_xs+0x0/0xf @ 1
initcall init_rc_map_terratec_cinergy_xs+0x0/0xf returned 0 after 1 usecs
calling  init_rc_map_terratec_slim+0x0/0xf @ 1
initcall init_rc_map_terratec_slim+0x0/0xf returned 0 after 2 usecs
calling  init_rc_map_terratec_slim_2+0x0/0xf @ 1
initcall init_rc_map_terratec_slim_2+0x0/0xf returned 0 after 1 usecs
calling  init_rc_map_tevii_nec+0x0/0xf @ 1
initcall init_rc_map_tevii_nec+0x0/0xf returned 0 after 1 usecs
calling  init_rc_map_total_media_in_hand+0x0/0xf @ 1
initcall init_rc_map_total_media_in_hand+0x0/0xf returned 0 after 1 usecs
calling  init_rc_map_trekstor+0x0/0xf @ 1
initcall init_rc_map_trekstor+0x0/0xf returned 0 after 1 usecs
calling  init_rc_map_tt_1500+0x0/0xf @ 1
initcall init_rc_map_tt_1500+0x0/0xf returned 0 after 1 usecs
calling  init_rc_map_twinhan_vp1027+0x0/0xf @ 1
initcall init_rc_map_twinhan_vp1027+0x0/0xf returned 0 after 1 usecs
calling  init_rc_map_videomate_m1f+0x0/0xf @ 1
initcall init_rc_map_videomate_m1f+0x0/0xf returned 0 after 1 usecs
calling  init_rc_map_videomate_s350+0x0/0xf @ 1
initcall init_rc_map_videomate_s350+0x0/0xf returned 0 after 1 usecs
calling  init_rc_map_videomate_tv_pvr+0x0/0xf @ 1
initcall init_rc_map_videomate_tv_pvr+0x0/0xf returned 0 after 1 usecs
input: ImPS/2 Generic Wheel Mouse as /devices/platform/i8042/serio1/input/input4
calling  init_rc_map_winfast+0x0/0xf @ 1
initcall init_rc_map_winfast+0x0/0xf returned 0 after 1 usecs
calling  init_rc_map_winfast_usbii_deluxe+0x0/0xf @ 1
initcall init_rc_map_winfast_usbii_deluxe+0x0/0xf returned 0 after 2 usecs
calling  rc_core_init+0x0/0x3d @ 1
initcall rc_core_init+0x0/0x3d returned 0 after 65 usecs
calling  lirc_dev_init+0x0/0x84 @ 1
lirc_dev: IR Remote Control driver registered, major 241 
initcall lirc_dev_init+0x0/0x84 returned 0 after 5063 usecs
calling  ir_nec_decode_init+0x0/0x1e @ 1
IR NEC protocol handler initialized
initcall ir_nec_decode_init+0x0/0x1e returned 0 after 3156 usecs
calling  ir_rc5_decode_init+0x0/0x1e @ 1
IR RC5(x) protocol handler initialized
initcall ir_rc5_decode_init+0x0/0x1e returned 0 after 3411 usecs
calling  ir_rc6_decode_init+0x0/0x1e @ 1
IR RC6 protocol handler initialized
initcall ir_rc6_decode_init+0x0/0x1e returned 0 after 3157 usecs
calling  ir_jvc_decode_init+0x0/0x1e @ 1
IR JVC protocol handler initialized
initcall ir_jvc_decode_init+0x0/0x1e returned 0 after 3167 usecs
calling  ir_sony_decode_init+0x0/0x1e @ 1
IR Sony protocol handler initialized
initcall ir_sony_decode_init+0x0/0x1e returned 0 after 3245 usecs
calling  ir_rc5_sz_decode_init+0x0/0x1e @ 1
IR RC5 (streamzap) protocol handler initialized
initcall ir_rc5_sz_decode_init+0x0/0x1e returned 0 after 4173 usecs
calling  ir_lirc_codec_init+0x0/0x1e @ 1
IR LIRC bridge handler initialized
initcall ir_lirc_codec_init+0x0/0x1e returned 0 after 3073 usecs
calling  videodev_init+0x0/0x7f @ 1
Linux video capture interface: v2.00
initcall videodev_init+0x0/0x7f returned 0 after 3287 usecs
calling  ir_init+0x0/0x11 @ 1
initcall ir_init+0x0/0x11 returned 0 after 54 usecs
calling  linear_init+0x0/0xf @ 1
md: linear personality registered for level -1
initcall linear_init+0x0/0xf returned 0 after 4086 usecs
calling  raid0_init+0x0/0xf @ 1
md: raid0 personality registered for level 0
initcall raid0_init+0x0/0xf returned 0 after 3919 usecs
calling  raid_init+0x0/0xf @ 1
md: raid1 personality registered for level 1
initcall raid_init+0x0/0xf returned 0 after 3919 usecs
calling  raid_init+0x0/0xf @ 1
md: raid10 personality registered for level 10
initcall raid_init+0x0/0xf returned 0 after 4088 usecs
calling  raid5_init+0x0/0x25 @ 1
md: raid6 personality registered for level 6
md: raid5 personality registered for level 5
md: raid4 personality registered for level 4
initcall raid5_init+0x0/0x25 returned 0 after 11754 usecs
calling  multipath_init+0x0/0xf @ 1
md: multipath personality registered for level -4
initcall multipath_init+0x0/0xf returned 0 after 4343 usecs
calling  raid_init+0x0/0xf @ 1
md: faulty personality registered for level -5
initcall raid_init+0x0/0xf returned 0 after 4088 usecs
calling  dm_init+0x0/0x30 @ 1
device-mapper: uevent: version 1.0.3
device-mapper: ioctl: 4.20.0-ioctl (2011-02-02) initialised: dm-devel@redhat.com
initcall dm_init+0x0/0x30 returned 0 after 10697 usecs
calling  dm_crypt_init+0x0/0x69 @ 1
initcall dm_crypt_init+0x0/0x69 returned 0 after 24 usecs
calling  dm_flakey_init+0x0/0x2e @ 1
initcall dm_flakey_init+0x0/0x2e returned 0 after 2 usecs
calling  dm_multipath_init+0x0/0x133 @ 1
device-mapper: multipath: version 1.3.0 loaded
initcall dm_multipath_init+0x0/0x133 returned 0 after 4167 usecs
calling  dm_rr_init+0x0/0x3a @ 1
device-mapper: multipath round-robin: version 1.0.0 loaded
initcall dm_rr_init+0x0/0x3a returned 0 after 5112 usecs
calling  dm_snapshot_init+0x0/0x1fc @ 1
initcall dm_snapshot_init+0x0/0x1fc returned 0 after 105 usecs
calling  dm_mirror_init+0x0/0x77 @ 1
initcall dm_mirror_init+0x0/0x77 returned 0 after 120 usecs
calling  dm_dirty_log_init+0x0/0x4b @ 1
initcall dm_dirty_log_init+0x0/0x4b returned 0 after 1 usecs
calling  dm_zero_init+0x0/0x2e @ 1
initcall dm_zero_init+0x0/0x2e returned 0 after 1 usecs
calling  edac_init+0x0/0x6c @ 1
EDAC MC: Ver: 2.1.0 May  4 2011
initcall edac_init+0x0/0x6c returned 0 after 2963 usecs
calling  pci_eisa_init_module+0x0/0x16 @ 1
initcall pci_eisa_init_module+0x0/0x16 returned 0 after 105 usecs
calling  virtual_eisa_root_init+0x0/0x4d @ 1
EISA: Probing bus 0 at eisa.0
EISA: Cannot allocate resource for mainboard
Cannot allocate resource for EISA slot 1
Cannot allocate resource for EISA slot 2
Cannot allocate resource for EISA slot 3
Cannot allocate resource for EISA slot 4
Cannot allocate resource for EISA slot 5
Cannot allocate resource for EISA slot 6
Cannot allocate resource for EISA slot 7
Cannot allocate resource for EISA slot 8
EISA: Detected 0 cards.
initcall virtual_eisa_root_init+0x0/0x4d returned 0 after 37460 usecs
calling  cpufreq_stats_init+0x0/0x84 @ 1
initcall cpufreq_stats_init+0x0/0x84 returned 0 after 5 usecs
calling  cpufreq_gov_powersave_init+0x0/0xf @ 1
initcall cpufreq_gov_powersave_init+0x0/0xf returned 0 after 2 usecs
calling  cpufreq_gov_userspace_init+0x0/0xf @ 1
initcall cpufreq_gov_userspace_init+0x0/0xf returned 0 after 1 usecs
calling  cpufreq_gov_dbs_init+0x0/0x20 @ 1
initcall cpufreq_gov_dbs_init+0x0/0x20 returned 0 after 1 usecs
calling  cpufreq_gov_dbs_init+0x0/0xf @ 1
initcall cpufreq_gov_dbs_init+0x0/0xf returned 0 after 2 usecs
calling  init_ladder+0x0/0xf @ 1
cpuidle: using governor ladder
initcall init_ladder+0x0/0xf returned 0 after 2736 usecs
calling  ioat_init_module+0x0/0x7a @ 1
ioatdma: Intel(R) QuickData Technology Driver 4.00
initcall ioat_init_module+0x0/0x7a returned 0 after 4526 usecs
calling  td_init+0x0/0xf @ 1
initcall td_init+0x0/0xf returned 0 after 55 usecs
calling  pch_dma_init+0x0/0x16 @ 1
initcall pch_dma_init+0x0/0x16 returned 0 after 84 usecs
calling  mmc_blk_init+0x0/0x6d @ 1
initcall mmc_blk_init+0x0/0x6d returned 0 after 45 usecs
calling  mmc_test_init+0x0/0xf @ 1
initcall mmc_test_init+0x0/0xf returned 0 after 44 usecs
calling  sdio_uart_init+0x0/0xc3 @ 1
initcall sdio_uart_init+0x0/0xc3 returned 0 after 51 usecs
calling  sdhci_drv_init+0x0/0x20 @ 1
sdhci: Secure Digital Host Controller Interface driver
sdhci: Copyright(c) Pierre Ossman
initcall sdhci_drv_init+0x0/0x20 returned 0 after 7752 usecs
calling  sdhci_drv_init+0x0/0x16 @ 1
initcall sdhci_drv_init+0x0/0x16 returned 0 after 83 usecs
calling  wbsd_drv_init+0x0/0x9d @ 1
wbsd: Winbond W83L51xD SD/MMC card interface driver
wbsd: Copyright(c) Pierre Ossman
initcall wbsd_drv_init+0x0/0x9d returned 0 after 7465 usecs
calling  tifm_sd_init+0x0/0xf @ 1
initcall tifm_sd_init+0x0/0xf returned 0 after 45 usecs
calling  sdricoh_drv_init+0x0/0xf @ 1
initcall sdricoh_drv_init+0x0/0xf returned 0 after 48 usecs
calling  cb710_mmc_init_module+0x0/0xf @ 1
initcall cb710_mmc_init_module+0x0/0xf returned 0 after 48 usecs
calling  via_sd_drv_init+0x0/0x23 @ 1
via_sdmmc: VIA SD/MMC Card Reader driver (C) 2008 VIA Technologies, Inc.
initcall via_sd_drv_init+0x0/0x23 returned 0 after 6370 usecs
calling  ushc_init+0x0/0x16 @ 1
usbcore: registered new interface driver ushc
initcall ushc_init+0x0/0x16 returned 0 after 4094 usecs
calling  sdhci_drv_init+0x0/0xf @ 1
initcall sdhci_drv_init+0x0/0xf returned 0 after 50 usecs
calling  sdhci_of_init+0x0/0xf @ 1
initcall sdhci_of_init+0x0/0xf returned 0 after 49 usecs
calling  memstick_init+0x0/0x78 @ 1
initcall memstick_init+0x0/0x78 returned 0 after 121 usecs
calling  mspro_block_init+0x0/0x6c @ 1
initcall mspro_block_init+0x0/0x6c returned 0 after 47 usecs
calling  tifm_ms_init+0x0/0xf @ 1
initcall tifm_ms_init+0x0/0xf returned 0 after 45 usecs
calling  jmb38x_ms_init+0x0/0x16 @ 1
initcall jmb38x_ms_init+0x0/0x16 returned 0 after 92 usecs
calling  r592_module_init+0x0/0x16 @ 1
initcall r592_module_init+0x0/0x16 returned 0 after 81 usecs
calling  dmi_sysfs_init+0x0/0x7c @ 1
initcall dmi_sysfs_init+0x0/0x7c returned 0 after 482 usecs
calling  ibft_init+0x0/0x2f5 @ 1
No iBFT detected.
initcall ibft_init+0x0/0x2f5 returned 0 after 1632 usecs
calling  init_hrt_clocksource+0x0/0x139 @ 1
initcall init_hrt_clocksource+0x0/0x139 returned -19 after 2 usecs
calling  hid_init+0x0/0x5a @ 1
initcall hid_init+0x0/0x5a returned 0 after 95 usecs
calling  mmm_init+0x0/0x16 @ 1
initcall mmm_init+0x0/0x16 returned 0 after 63 usecs
calling  a4_init+0x0/0x16 @ 1
initcall a4_init+0x0/0x16 returned 0 after 59 usecs
calling  apple_init+0x0/0x2e @ 1
initcall apple_init+0x0/0x2e returned 0 after 61 usecs
calling  belkin_init+0x0/0x16 @ 1
initcall belkin_init+0x0/0x16 returned 0 after 59 usecs
calling  cando_init+0x0/0x16 @ 1
initcall cando_init+0x0/0x16 returned 0 after 60 usecs
calling  ch_init+0x0/0x16 @ 1
initcall ch_init+0x0/0x16 returned 0 after 59 usecs
calling  ch_init+0x0/0x16 @ 1
initcall ch_init+0x0/0x16 returned 0 after 62 usecs
calling  cp_init+0x0/0x16 @ 1
initcall cp_init+0x0/0x16 returned 0 after 76 usecs
calling  dr_init+0x0/0x16 @ 1
initcall dr_init+0x0/0x16 returned 0 after 59 usecs
calling  ez_init+0x0/0x16 @ 1
initcall ez_init+0x0/0x16 returned 0 after 59 usecs
calling  gyration_init+0x0/0x16 @ 1
initcall gyration_init+0x0/0x16 returned 0 after 59 usecs
calling  ks_init+0x0/0x16 @ 1
initcall ks_init+0x0/0x16 returned 0 after 60 usecs
calling  keytouch_init+0x0/0x16 @ 1
initcall keytouch_init+0x0/0x16 returned 0 after 58 usecs
calling  kye_init+0x0/0x16 @ 1
initcall kye_init+0x0/0x16 returned 0 after 60 usecs
calling  ts_init+0x0/0x16 @ 1
initcall ts_init+0x0/0x16 returned 0 after 60 usecs
calling  lg_init+0x0/0x16 @ 1
initcall lg_init+0x0/0x16 returned 0 after 60 usecs
calling  ms_init+0x0/0x16 @ 1
initcall ms_init+0x0/0x16 returned 0 after 60 usecs
calling  mr_init+0x0/0x16 @ 1
initcall mr_init+0x0/0x16 returned 0 after 60 usecs
calling  mosart_init+0x0/0x16 @ 1
initcall mosart_init+0x0/0x16 returned 0 after 60 usecs
calling  mt_init+0x0/0x16 @ 1
initcall mt_init+0x0/0x16 returned 0 after 60 usecs
calling  ntrig_init+0x0/0x16 @ 1
initcall ntrig_init+0x0/0x16 returned 0 after 62 usecs
calling  ortek_init+0x0/0x16 @ 1
initcall ortek_init+0x0/0x16 returned 0 after 60 usecs
calling  quanta_init+0x0/0x16 @ 1
initcall quanta_init+0x0/0x16 returned 0 after 60 usecs
calling  pl_init+0x0/0x16 @ 1
initcall pl_init+0x0/0x16 returned 0 after 64 usecs
calling  pl_init+0x0/0x16 @ 1
initcall pl_init+0x0/0x16 returned 0 after 62 usecs
calling  roccat_init+0x0/0x66 @ 1
initcall roccat_init+0x0/0x66 returned 0 after 3 usecs
calling  arvo_init+0x0/0x57 @ 1
initcall arvo_init+0x0/0x57 returned 0 after 104 usecs
calling  kone_init+0x0/0x57 @ 1
initcall kone_init+0x0/0x57 returned 0 after 107 usecs
calling  koneplus_init+0x0/0x57 @ 1
initcall koneplus_init+0x0/0x57 returned 0 after 103 usecs
calling  kovaplus_init+0x0/0x57 @ 1
initcall kovaplus_init+0x0/0x57 returned 0 after 105 usecs
calling  pyra_init+0x0/0x57 @ 1
initcall pyra_init+0x0/0x57 returned 0 after 103 usecs
calling  samsung_init+0x0/0x16 @ 1
initcall samsung_init+0x0/0x16 returned 0 after 62 usecs
calling  sjoy_init+0x0/0x16 @ 1
initcall sjoy_init+0x0/0x16 returned 0 after 62 usecs
calling  sony_init+0x0/0x16 @ 1
initcall sony_init+0x0/0x16 returned 0 after 74 usecs
calling  stantum_init+0x0/0x16 @ 1
initcall stantum_init+0x0/0x16 returned 0 after 61 usecs
calling  sp_init+0x0/0x16 @ 1
initcall sp_init+0x0/0x16 returned 0 after 60 usecs
calling  ga_init+0x0/0x16 @ 1
initcall ga_init+0x0/0x16 returned 0 after 65 usecs
calling  tm_init+0x0/0x16 @ 1
initcall tm_init+0x0/0x16 returned 0 after 61 usecs
calling  ts_init+0x0/0x16 @ 1
initcall ts_init+0x0/0x16 returned 0 after 62 usecs
calling  twinhan_init+0x0/0x16 @ 1
initcall twinhan_init+0x0/0x16 returned 0 after 76 usecs
calling  uclogic_init+0x0/0x16 @ 1
initcall uclogic_init+0x0/0x16 returned 0 after 69 usecs
calling  zp_init+0x0/0x16 @ 1
initcall zp_init+0x0/0x16 returned 0 after 60 usecs
calling  waltop_init+0x0/0x16 @ 1
initcall waltop_init+0x0/0x16 returned 0 after 61 usecs
calling  hid_init+0x0/0x66 @ 1
usbcore: registered new interface driver usbhid
usbhid: USB HID core driver
initcall hid_init+0x0/0x66 returned 0 after 6796 usecs
calling  staging_init+0x0/0x7 @ 1
initcall staging_init+0x0/0x7 returned 0 after 1 usecs
calling  smtcfb_init+0x0/0x16 @ 1
initcall smtcfb_init+0x0/0x16 returned 0 after 82 usecs
calling  xgifb_init+0x0/0x373 @ 1
XGIfb: Options (null)
initcall xgifb_init+0x0/0x373 returned 0 after 2058 usecs
calling  quickstart_init+0x0/0x18e @ 1
initcall quickstart_init+0x0/0x18e returned -19 after 115 usecs
calling  asus_wmi_init+0x0/0x35 @ 1
asus_wmi: Asus Management GUID not found
initcall asus_wmi_init+0x0/0x35 returned -19 after 3418 usecs
calling  asus_nb_wmi_init+0x0/0xf @ 1
asus_wmi: Management GUID not found
initcall asus_nb_wmi_init+0x0/0xf returned -19 after 3396 usecs
calling  eeepc_laptop_init+0x0/0x4d @ 1
initcall eeepc_laptop_init+0x0/0x4d returned -19 after 190 usecs
calling  eeepc_wmi_init+0x0/0xf @ 1
asus_wmi: Management GUID not found
initcall eeepc_wmi_init+0x0/0xf returned -19 after 3382 usecs
calling  msi_init+0x0/0x422 @ 1
msi_laptop: driver 0.5 successfully loaded.
initcall msi_init+0x0/0x422 returned 0 after 4129 usecs
calling  cmpc_init+0x0/0x6c @ 1
initcall cmpc_init+0x0/0x6c returned 0 after 242 usecs
calling  compal_init+0x0/0x1b8 @ 1
compal-laptop: Motherboard not recognized (You could try the module's force-parameter)
initcall compal_init+0x0/0x1b8 returned -19 after 7312 usecs
calling  dell_wmi_init+0x0/0x183 @ 1
dell-wmi: No known WMI GUID found
initcall dell_wmi_init+0x0/0x183 returned -19 after 2987 usecs
calling  dell_wmi_aio_init+0x0/0xe7 @ 1
dell_wmi_aio: No known WMI GUID found
initcall dell_wmi_aio_init+0x0/0xe7 returned -6 after 3327 usecs
initcall dell_wmi_aio_init+0x0/0xe7 returned with error code -6 
calling  acer_wmi_init+0x0/0x6cf @ 1
acer_wmi: Acer Laptop ACPI-WMI Extras
acer_wmi: No or unsupported WMI interface, unable to load
initcall acer_wmi_init+0x0/0x6cf returned -19 after 8354 usecs
calling  acerhdf_init+0x0/0x268 @ 1
acerhdf: Acer Aspire One Fan driver, v.0.5.24
acerhdf: unknown (unsupported) BIOS version System manufacturer/System Product Name/ASUS A8N-E ACPI BIOS Revision 1008, please report, aborting!
initcall acerhdf_init+0x0/0x268 returned -22 after 16402 usecs
initcall acerhdf_init+0x0/0x268 returned with error code -22 
calling  lis3lv02d_init_module+0x0/0x30 @ 1
hp_accel: driver loaded
initcall lis3lv02d_init_module+0x0/0x30 returned 0 after 2211 usecs
calling  hp_wmi_init+0x0/0x1a6 @ 1
initcall hp_wmi_init+0x0/0x1a6 returned -19 after 3 usecs
calling  tc1100_init+0x0/0x78 @ 1
initcall tc1100_init+0x0/0x78 returned -19 after 1 usecs
calling  sony_laptop_init+0x0/0x79 @ 1
initcall sony_laptop_init+0x0/0x79 returned 0 after 58 usecs
calling  ideapad_acpi_module_init+0x0/0xf @ 1
initcall ideapad_acpi_module_init+0x0/0xf returned 0 after 72 usecs
calling  thinkpad_acpi_module_init+0x0/0xb51 @ 1
initcall thinkpad_acpi_module_init+0x0/0xb51 returned -19 after 7 usecs
calling  hdaps_init+0x0/0x1eb @ 1
hdaps: supported laptop not found!
hdaps: driver init failed (ret=-19)!
initcall hdaps_init+0x0/0x1eb returned -19 after 6331 usecs
calling  fujitsu_init+0x0/0x25d @ 1
fujitsu-laptop: driver 0.6.0 successfully loaded.
initcall fujitsu_init+0x0/0x25d returned 0 after 4644 usecs
calling  acpi_pcc_init+0x0/0x23 @ 1
initcall acpi_pcc_init+0x0/0x23 returned 0 after 61 usecs
calling  intel_menlow_module_init+0x0/0x8f @ 1
initcall intel_menlow_module_init+0x0/0x8f returned -19 after 6 usecs
calling  msi_wmi_init+0x0/0x146 @ 1
This machine doesn't have MSI-hotkeys through WMI
initcall msi_wmi_init+0x0/0x146 returned -19 after 4348 usecs
calling  asus_acpi_init+0x0/0xdc @ 1
initcall asus_acpi_init+0x0/0xdc returned -19 after 103 usecs
calling  topstar_laptop_init+0x0/0x22 @ 1
Topstar Laptop ACPI extras driver loaded
initcall topstar_laptop_init+0x0/0x22 returned 0 after 3644 usecs
calling  toshiba_acpi_init+0x0/0x399 @ 1
initcall toshiba_acpi_init+0x0/0x399 returned -19 after 4 usecs
calling  toshiba_bt_rfkill_init+0x0/0x1a @ 1
initcall toshiba_bt_rfkill_init+0x0/0x1a returned 0 after 58 usecs
calling  ips_init+0x0/0x16 @ 1
initcall ips_init+0x0/0x16 returned 0 after 91 usecs
calling  xo1_rfkill_init+0x0/0xf @ 1
initcall xo1_rfkill_init+0x0/0xf returned 0 after 49 usecs
calling  xo15_ebook_init+0x0/0xf @ 1
initcall xo15_ebook_init+0x0/0xf returned 0 after 59 usecs
calling  ibm_rtl_init+0x0/0x267 @ 1
initcall ibm_rtl_init+0x0/0x267 returned -19 after 2 usecs
calling  samsung_init+0x0/0x5b9 @ 1
initcall samsung_init+0x0/0x5b9 returned -19 after 8 usecs
calling  oprofile_init+0x0/0x3c @ 1
oprofile: using NMI interrupt.
initcall oprofile_init+0x0/0x3c returned 0 after 2755 usecs
calling  flow_cache_init_global+0x0/0x10f @ 1
initcall flow_cache_init_global+0x0/0x10f returned 0 after 56 usecs
calling  llc_init+0x0/0x1b @ 1
initcall llc_init+0x0/0x1b returned 0 after 1 usecs
calling  snap_init+0x0/0x33 @ 1
initcall snap_init+0x0/0x33 returned 0 after 3 usecs
calling  rif_init+0x0/0x6e @ 1
initcall rif_init+0x0/0x6e returned 0 after 22 usecs
calling  blackhole_module_init+0x0/0xf @ 1
initcall blackhole_module_init+0x0/0xf returned 0 after 2 usecs
calling  police_init_module+0x0/0xf @ 1
initcall police_init_module+0x0/0xf returned 0 after 1 usecs
calling  sysctl_ipv4_init+0x0/0x71 @ 1
initcall sysctl_ipv4_init+0x0/0x71 returned 0 after 298 usecs
calling  ipip_init+0x0/0x52 @ 1
IPv4 over IPv4 tunneling driver
initcall ipip_init+0x0/0x52 returned 0 after 3214 usecs
calling  init_syncookies+0x0/0x16 @ 1
initcall init_syncookies+0x0/0x16 returned 0 after 41 usecs
calling  tunnel4_init+0x0/0x5e @ 1
initcall tunnel4_init+0x0/0x5e returned 0 after 2 usecs
calling  ipv4_netfilter_init+0x0/0x14 @ 1
initcall ipv4_netfilter_init+0x0/0x14 returned 0 after 2 usecs
calling  inet_diag_init+0x0/0x7c @ 1
initcall inet_diag_init+0x0/0x7c returned 0 after 15 usecs
calling  tcp_diag_init+0x0/0xf @ 1
initcall tcp_diag_init+0x0/0xf returned 0 after 2 usecs
calling  cubictcp_register+0x0/0x73 @ 1
TCP cubic registered
initcall cubictcp_register+0x0/0x73 returned 0 after 1888 usecs
calling  xfrm_user_init+0x0/0x41 @ 1
Initializing XFRM netlink socket
initcall xfrm_user_init+0x0/0x41 returned 0 after 2906 usecs
calling  inet6_init+0x0/0x293 @ 1
NET: Registered protocol family 10
initcall inet6_init+0x0/0x293 returned 0 after 5456 usecs
calling  packet_init+0x0/0x39 @ 1
NET: Registered protocol family 17
initcall packet_init+0x0/0x39 returned 0 after 3076 usecs
calling  dsa_init_module+0x0/0x11 @ 1
initcall dsa_init_module+0x0/0x11 returned 0 after 2 usecs
calling  edsa_init_module+0x0/0x11 @ 1
initcall edsa_init_module+0x0/0x11 returned 0 after 1 usecs
calling  trailer_init_module+0x0/0x11 @ 1
initcall trailer_init_module+0x0/0x11 returned 0 after 1 usecs
calling  mv88e6060_init+0x0/0x11 @ 1
initcall mv88e6060_init+0x0/0x11 returned 0 after 2 usecs
calling  mv88e6123_61_65_init+0x0/0x11 @ 1
initcall mv88e6123_61_65_init+0x0/0x11 returned 0 after 2 usecs
calling  mv88e6131_init+0x0/0x11 @ 1
initcall mv88e6131_init+0x0/0x11 returned 0 after 1 usecs
calling  dsa_init_module+0x0/0xf @ 1
initcall dsa_init_module+0x0/0xf returned 0 after 64 usecs
calling  init_rpcsec_gss+0x0/0x3f @ 1
initcall init_rpcsec_gss+0x0/0x3f returned 0 after 11 usecs
calling  af_rxrpc_init+0x0/0x181 @ 1
NET: Registered protocol family 33
initcall af_rxrpc_init+0x0/0x181 returned 0 after 3128 usecs
calling  atm_clip_init+0x0/0xa6 @ 1
initcall atm_clip_init+0x0/0xa6 returned 0 after 33 usecs
calling  lane_module_init+0x0/0x6b @ 1
lec:lane_module_init: lec.c: May  4 2011 11:12:46 initialized
initcall lane_module_init+0x0/0x6b returned 0 after 5366 usecs
calling  atm_mpoa_init+0x0/0x45 @ 1
mpoa:atm_mpoa_init: mpc.c: May  4 2011 11:12:45 initialized
initcall atm_mpoa_init+0x0/0x45 returned 0 after 5197 usecs
calling  pppoatm_init+0x0/0x11 @ 1
initcall pppoatm_init+0x0/0x11 returned 0 after 7 usecs
calling  sctp_init+0x0/0x6c2 @ 1
sctp: Hash tables configured (established 65536 bind 65536)
initcall sctp_init+0x0/0x6c2 returned 0 after 6272 usecs
calling  lib80211_init+0x0/0x1c @ 1
lib80211: common routines for IEEE802.11 drivers
lib80211_crypt: registered algorithm 'NULL'
initcall lib80211_init+0x0/0x1c returned 0 after 8092 usecs
calling  lib80211_crypto_wep_init+0x0/0xf @ 1
lib80211_crypt: registered algorithm 'WEP'
initcall lib80211_crypto_wep_init+0x0/0xf returned 0 after 3758 usecs
calling  lib80211_crypto_ccmp_init+0x0/0xf @ 1
lib80211_crypt: registered algorithm 'CCMP'
initcall lib80211_crypto_ccmp_init+0x0/0xf returned 0 after 3842 usecs
calling  lib80211_crypto_tkip_init+0x0/0xf @ 1
lib80211_crypt: registered algorithm 'TKIP'
initcall lib80211_crypto_tkip_init+0x0/0xf returned 0 after 3845 usecs
calling  dcbnl_init+0x0/0x4c @ 1
initcall dcbnl_init+0x0/0x4c returned 0 after 2 usecs
calling  init_dns_resolver+0x0/0x101 @ 1
Registering the dns_resolver key type
initcall init_dns_resolver+0x0/0x101 returned 0 after 3339 usecs
calling  init_ceph_lib+0x0/0x79 @ 1
libceph: loaded (mon/osd proto 15/24, osdmap 5/6 5/6)
initcall init_ceph_lib+0x0/0x79 returned 0 after 4698 usecs
calling  rio_init_mports+0x0/0x57 @ 1
initcall rio_init_mports+0x0/0x57 returned 0 after 2 usecs
calling  mcheck_debugfs_init+0x0/0x40 @ 1
initcall mcheck_debugfs_init+0x0/0x40 returned 0 after 5 usecs
calling  severities_debugfs_init+0x0/0x40 @ 1
initcall severities_debugfs_init+0x0/0x40 returned 0 after 4 usecs
calling  powernowk8_init+0x0/0x180 @ 1
powernow-k8: Found 1 AMD Athlon(tm) 64 X2 Dual Core Processor 3800+ (2 cpu cores) (version 2.20.00)
[Firmware Bug]: powernow-k8: No compatible ACPI _PSS objects found.
[Firmware Bug]: powernow-k8: Try again with latest BIOS.
initcall powernowk8_init+0x0/0x180 returned -19 after 19390 usecs
calling  acpi_cpufreq_init+0x0/0xac @ 1
initcall acpi_cpufreq_init+0x0/0xac returned -5 after 12 usecs
initcall acpi_cpufreq_init+0x0/0xac returned with error code -5 
calling  pcc_cpufreq_init+0x0/0x1ed @ 1
initcall pcc_cpufreq_init+0x0/0x1ed returned -19 after 4 usecs
calling  powernow_init+0x0/0x11d @ 1
initcall powernow_init+0x0/0x11d returned -19 after 2 usecs
calling  longhaul_init+0x0/0x81 @ 1
initcall longhaul_init+0x0/0x81 returned -19 after 1 usecs
calling  centrino_init+0x0/0x27 @ 1
initcall centrino_init+0x0/0x27 returned -19 after 1 usecs
calling  cpufreq_p4_init+0x0/0x52 @ 1
initcall cpufreq_p4_init+0x0/0x52 returned -19 after 1 usecs
calling  hpet_insert_resource+0x0/0x1e @ 1
initcall hpet_insert_resource+0x0/0x1e returned 1 after 1 usecs
initcall hpet_insert_resource+0x0/0x1e returned with error code 1 
calling  update_mp_table+0x0/0x3f2 @ 1
initcall update_mp_table+0x0/0x3f2 returned 0 after 2 usecs
calling  lapic_insert_resource+0x0/0x35 @ 1
initcall lapic_insert_resource+0x0/0x35 returned 0 after 4 usecs
calling  print_ipi_mode+0x0/0x2d @ 1
Using IPI No-Shortcut mode
initcall print_ipi_mode+0x0/0x2d returned 0 after 2394 usecs
calling  io_apic_bug_finalize+0x0/0x1a @ 1
initcall io_apic_bug_finalize+0x0/0x1a returned 0 after 1 usecs
calling  check_early_ioremap_leak+0x0/0x54 @ 1
initcall check_early_ioremap_leak+0x0/0x54 returned 0 after 1 usecs
calling  pat_memtype_list_init+0x0/0x37 @ 1
initcall pat_memtype_list_init+0x0/0x37 returned 0 after 4 usecs
calling  init_oops_id+0x0/0x3f @ 1
initcall init_oops_id+0x0/0x3f returned 0 after 5 usecs
calling  printk_late_init+0x0/0x4d @ 1
initcall printk_late_init+0x0/0x4d returned 0 after 4 usecs
calling  pm_qos_power_init+0x0/0xb3 @ 1
initcall pm_qos_power_init+0x0/0xb3 returned 0 after 359 usecs
calling  software_resume+0x0/0x190 @ 1
async_waiting @ 1
async_continuing @ 1 after 2 usec
initcall software_resume+0x0/0x190 returned -19 after 4648 usecs
calling  clear_boot_tracer+0x0/0x2d @ 1
initcall clear_boot_tracer+0x0/0x2d returned 0 after 1 usecs
calling  max_swapfiles_check+0x0/0x7 @ 1
initcall max_swapfiles_check+0x0/0x7 returned 0 after 1 usecs
calling  set_recommended_min_free_kbytes+0x0/0x6c @ 1
initcall set_recommended_min_free_kbytes+0x0/0x6c returned 0 after 35 usecs
calling  afs_init+0x0/0x16c @ 1
kAFS: Red Hat AFS client v0.1 registering.
FS-Cache: Netfs 'afs' registered for caching
initcall afs_init+0x0/0x16c returned 0 after 7900 usecs
calling  raid6_test+0x0/0xf9 @ 1
raid6test: testing the 4-disk case...
raid6test: test_disks(0, 1): faila=  0(D)  failb=  1(D)  OK
raid6test: test_disks(0, 2): faila=  0(D)  failb=  2(P)  OK
raid6test: test_disks(0, 3): faila=  0(D)  failb=  3(Q)  OK
raid6test: test_disks(1, 2): faila=  1(D)  failb=  2(P)  OK
raid6test: test_disks(1, 3): faila=  1(D)  failb=  3(Q)  OK
raid6test: test_disks(2, 3): faila=  2(P)  failb=  3(Q)  OK
raid6test: testing the 5-disk case...
raid6test: test_disks(0, 1): faila=  0(D)  failb=  1(D)  OK
raid6test: test_disks(0, 2): faila=  0(D)  failb=  2(D)  OK
raid6test: test_disks(0, 3): faila=  0(D)  failb=  3(P)  OK
raid6test: test_disks(0, 4): faila=  0(D)  failb=  4(Q)  OK
raid6test: test_disks(1, 2): faila=  1(D)  failb=  2(D)  OK
raid6test: test_disks(1, 3): faila=  1(D)  failb=  3(P)  OK
raid6test: test_disks(1, 4): faila=  1(D)  failb=  4(Q)  OK
raid6test: test_disks(2, 3): faila=  2(D)  failb=  3(P)  OK
raid6test: test_disks(2, 4): faila=  2(D)  failb=  4(Q)  OK
raid6test: test_disks(3, 4): faila=  3(P)  failb=  4(Q)  OK
raid6test: testing the 11-disk case...
raid6test: test_disks(0, 1): faila=  0(D)  failb=  1(D)  OK
raid6test: test_disks(0, 2): faila=  0(D)  failb=  2(D)  OK
raid6test: test_disks(0, 3): faila=  0(D)  failb=  3(D)  OK
raid6test: test_disks(0, 4): faila=  0(D)  failb=  4(D)  OK
raid6test: test_disks(0, 5): faila=  0(D)  failb=  5(D)  OK
raid6test: test_disks(0, 6): faila=  0(D)  failb=  6(D)  OK
raid6test: test_disks(0, 7): faila=  0(D)  failb=  7(D)  OK
raid6test: test_disks(0, 8): faila=  0(D)  failb=  8(D)  OK
raid6test: test_disks(0, 9): faila=  0(D)  failb=  9(P)  OK
raid6test: test_disks(0, 10): faila=  0(D)  failb= 10(Q)  OK
raid6test: test_disks(1, 2): faila=  1(D)  failb=  2(D)  OK
raid6test: test_disks(1, 3): faila=  1(D)  failb=  3(D)  OK
raid6test: test_disks(1, 4): faila=  1(D)  failb=  4(D)  OK
raid6test: test_disks(1, 5): faila=  1(D)  failb=  5(D)  OK
raid6test: test_disks(1, 6): faila=  1(D)  failb=  6(D)  OK
raid6test: test_disks(1, 7): faila=  1(D)  failb=  7(D)  OK
raid6test: test_disks(1, 8): faila=  1(D)  failb=  8(D)  OK
raid6test: test_disks(1, 9): faila=  1(D)  failb=  9(P)  OK
raid6test: test_disks(1, 10): faila=  1(D)  failb= 10(Q)  OK
raid6test: test_disks(2, 3): faila=  2(D)  failb=  3(D)  OK
raid6test: test_disks(2, 4): faila=  2(D)  failb=  4(D)  OK
raid6test: test_disks(2, 5): faila=  2(D)  failb=  5(D)  OK
raid6test: test_disks(2, 6): faila=  2(D)  failb=  6(D)  OK
raid6test: test_disks(2, 7): faila=  2(D)  failb=  7(D)  OK
raid6test: test_disks(2, 8): faila=  2(D)  failb=  8(D)  OK
raid6test: test_disks(2, 9): faila=  2(D)  failb=  9(P)  OK
raid6test: test_disks(2, 10): faila=  2(D)  failb= 10(Q)  OK
raid6test: test_disks(3, 4): faila=  3(D)  failb=  4(D)  OK
raid6test: test_disks(3, 5): faila=  3(D)  failb=  5(D)  OK
raid6test: test_disks(3, 6): faila=  3(D)  failb=  6(D)  OK
raid6test: test_disks(3, 7): faila=  3(D)  failb=  7(D)  OK
raid6test: test_disks(3, 8): faila=  3(D)  failb=  8(D)  OK
raid6test: test_disks(3, 9): faila=  3(D)  failb=  9(P)  OK
raid6test: test_disks(3, 10): faila=  3(D)  failb= 10(Q)  OK
raid6test: test_disks(4, 5): faila=  4(D)  failb=  5(D)  OK
raid6test: test_disks(4, 6): faila=  4(D)  failb=  6(D)  OK
raid6test: test_disks(4, 7): faila=  4(D)  failb=  7(D)  OK
raid6test: test_disks(4, 8): faila=  4(D)  failb=  8(D)  OK
raid6test: test_disks(4, 9): faila=  4(D)  failb=  9(P)  OK
raid6test: test_disks(4, 10): faila=  4(D)  failb= 10(Q)  OK
raid6test: test_disks(5, 6): faila=  5(D)  failb=  6(D)  OK
raid6test: test_disks(5, 7): faila=  5(D)  failb=  7(D)  OK
raid6test: test_disks(5, 8): faila=  5(D)  failb=  8(D)  OK
raid6test: test_disks(5, 9): faila=  5(D)  failb=  9(P)  OK
raid6test: test_disks(5, 10): faila=  5(D)  failb= 10(Q)  OK
raid6test: test_disks(6, 7): faila=  6(D)  failb=  7(D)  OK
raid6test: test_disks(6, 8): faila=  6(D)  failb=  8(D)  OK
raid6test: test_disks(6, 9): faila=  6(D)  failb=  9(P)  OK
raid6test: test_disks(6, 10): faila=  6(D)  failb= 10(Q)  OK
raid6test: test_disks(7, 8): faila=  7(D)  failb=  8(D)  OK
raid6test: test_disks(7, 9): faila=  7(D)  failb=  9(P)  OK
raid6test: test_disks(7, 10): faila=  7(D)  failb= 10(Q)  OK
raid6test: test_disks(8, 9): faila=  8(D)  failb=  9(P)  OK
raid6test: test_disks(8, 10): faila=  8(D)  failb= 10(Q)  OK
raid6test: test_disks(9, 10): faila=  9(P)  failb= 10(Q)  OK
raid6test: testing the 12-disk case...
raid6test: test_disks(0, 1): faila=  0(D)  failb=  1(D)  OK
raid6test: test_disks(0, 2): faila=  0(D)  failb=  2(D)  OK
raid6test: test_disks(0, 3): faila=  0(D)  failb=  3(D)  OK
raid6test: test_disks(0, 4): faila=  0(D)  failb=  4(D)  OK
raid6test: test_disks(0, 5): faila=  0(D)  failb=  5(D)  OK
raid6test: test_disks(0, 6): faila=  0(D)  failb=  6(D)  OK
raid6test: test_disks(0, 7): faila=  0(D)  failb=  7(D)  OK
raid6test: test_disks(0, 8): faila=  0(D)  failb=  8(D)  OK
raid6test: test_disks(0, 9): faila=  0(D)  failb=  9(D)  OK
raid6test: test_disks(0, 10): faila=  0(D)  failb= 10(P)  OK
raid6test: test_disks(0, 11): faila=  0(D)  failb= 11(Q)  OK
raid6test: test_disks(1, 2): faila=  1(D)  failb=  2(D)  OK
raid6test: test_disks(1, 3): faila=  1(D)  failb=  3(D)  OK
raid6test: test_disks(1, 4): faila=  1(D)  failb=  4(D)  OK
raid6test: test_disks(1, 5): faila=  1(D)  failb=  5(D)  OK
raid6test: test_disks(1, 6): faila=  1(D)  failb=  6(D)  OK
raid6test: test_disks(1, 7): faila=  1(D)  failb=  7(D)  OK
raid6test: test_disks(1, 8): faila=  1(D)  failb=  8(D)  OK
raid6test: test_disks(1, 9): faila=  1(D)  failb=  9(D)  OK
raid6test: test_disks(1, 10): faila=  1(D)  failb= 10(P)  OK
raid6test: test_disks(1, 11): faila=  1(D)  failb= 11(Q)  OK
raid6test: test_disks(2, 3): faila=  2(D)  failb=  3(D)  OK
raid6test: test_disks(2, 4): faila=  2(D)  failb=  4(D)  OK
raid6test: test_disks(2, 5): faila=  2(D)  failb=  5(D)  OK
raid6test: test_disks(2, 6): faila=  2(D)  failb=  6(D)  OK
raid6test: test_disks(2, 7): faila=  2(D)  failb=  7(D)  OK
raid6test: test_disks(2, 8): faila=  2(D)  failb=  8(D)  OK
raid6test: test_disks(2, 9): faila=  2(D)  failb=  9(D)  OK
raid6test: test_disks(2, 10): faila=  2(D)  failb= 10(P)  OK
raid6test: test_disks(2, 11): faila=  2(D)  failb= 11(Q)  OK
raid6test: test_disks(3, 4): faila=  3(D)  failb=  4(D)  OK
raid6test: test_disks(3, 5): faila=  3(D)  failb=  5(D)  OK
raid6test: test_disks(3, 6): faila=  3(D)  failb=  6(D)  OK
raid6test: test_disks(3, 7): faila=  3(D)  failb=  7(D)  OK
raid6test: test_disks(3, 8): faila=  3(D)  failb=  8(D)  OK
raid6test: test_disks(3, 9): faila=  3(D)  failb=  9(D)  OK
raid6test: test_disks(3, 10): faila=  3(D)  failb= 10(P)  OK
raid6test: test_disks(3, 11): faila=  3(D)  failb= 11(Q)  OK
raid6test: test_disks(4, 5): faila=  4(D)  failb=  5(D)  OK
raid6test: test_disks(4, 6): faila=  4(D)  failb=  6(D)  OK
raid6test: test_disks(4, 7): faila=  4(D)  failb=  7(D)  OK
raid6test: test_disks(4, 8): faila=  4(D)  failb=  8(D)  OK
raid6test: test_disks(4, 9): faila=  4(D)  failb=  9(D)  OK
raid6test: test_disks(4, 10): faila=  4(D)  failb= 10(P)  OK
raid6test: test_disks(4, 11): faila=  4(D)  failb= 11(Q)  OK
raid6test: test_disks(5, 6): faila=  5(D)  failb=  6(D)  OK
raid6test: test_disks(5, 7): faila=  5(D)  failb=  7(D)  OK
raid6test: test_disks(5, 8): faila=  5(D)  failb=  8(D)  OK
raid6test: test_disks(5, 9): faila=  5(D)  failb=  9(D)  OK
raid6test: test_disks(5, 10): faila=  5(D)  failb= 10(P)  OK
raid6test: test_disks(5, 11): faila=  5(D)  failb= 11(Q)  OK
raid6test: test_disks(6, 7): faila=  6(D)  failb=  7(D)  OK
raid6test: test_disks(6, 8): faila=  6(D)  failb=  8(D)  OK
raid6test: test_disks(6, 9): faila=  6(D)  failb=  9(D)  OK
raid6test: test_disks(6, 10): faila=  6(D)  failb= 10(P)  OK
raid6test: test_disks(6, 11): faila=  6(D)  failb= 11(Q)  OK
raid6test: test_disks(7, 8): faila=  7(D)  failb=  8(D)  OK
raid6test: test_disks(7, 9): faila=  7(D)  failb=  9(D)  OK
raid6test: test_disks(7, 10): faila=  7(D)  failb= 10(P)  OK
raid6test: test_disks(7, 11): faila=  7(D)  failb= 11(Q)  OK
raid6test: test_disks(8, 9): faila=  8(D)  failb=  9(D)  OK
raid6test: test_disks(8, 10): faila=  8(D)  failb= 10(P)  OK
raid6test: test_disks(8, 11): faila=  8(D)  failb= 11(Q)  OK
raid6test: test_disks(9, 10): faila=  9(D)  failb= 10(P)  OK
raid6test: test_disks(9, 11): faila=  9(D)  failb= 11(Q)  OK
raid6test: test_disks(10, 11): faila= 10(P)  failb= 11(Q)  OK
raid6test: testing the 16-disk case...
raid6test: test_disks(0, 1): faila=  0(D)  failb=  1(D)  OK
raid6test: test_disks(0, 2): faila=  0(D)  failb=  2(D)  OK
raid6test: test_disks(0, 3): faila=  0(D)  failb=  3(D)  OK
raid6test: test_disks(0, 4): faila=  0(D)  failb=  4(D)  OK
raid6test: test_disks(0, 5): faila=  0(D)  failb=  5(D)  OK
raid6test: test_disks(0, 6): faila=  0(D)  failb=  6(D)  OK
raid6test: test_disks(0, 7): faila=  0(D)  failb=  7(D)  OK
raid6test: test_disks(0, 8): faila=  0(D)  failb=  8(D)  OK
raid6test: test_disks(0, 9): faila=  0(D)  failb=  9(D)  OK
raid6test: test_disks(0, 10): faila=  0(D)  failb= 10(D)  OK
raid6test: test_disks(0, 11): faila=  0(D)  failb= 11(D)  OK
raid6test: test_disks(0, 12): faila=  0(D)  failb= 12(D)  OK
raid6test: test_disks(0, 13): faila=  0(D)  failb= 13(D)  OK
raid6test: test_disks(0, 14): faila=  0(D)  failb= 14(P)  OK
raid6test: test_disks(0, 15): faila=  0(D)  failb= 15(Q)  OK
raid6test: test_disks(1, 2): faila=  1(D)  failb=  2(D)  OK
raid6test: test_disks(1, 3): faila=  1(D)  failb=  3(D)  OK
raid6test: test_disks(1, 4): faila=  1(D)  failb=  4(D)  OK
raid6test: test_disks(1, 5): faila=  1(D)  failb=  5(D)  OK
raid6test: test_disks(1, 6): faila=  1(D)  failb=  6(D)  OK
raid6test: test_disks(1, 7): faila=  1(D)  failb=  7(D)  OK
raid6test: test_disks(1, 8): faila=  1(D)  failb=  8(D)  OK
raid6test: test_disks(1, 9): faila=  1(D)  failb=  9(D)  OK
raid6test: test_disks(1, 10): faila=  1(D)  failb= 10(D)  OK
raid6test: test_disks(1, 11): faila=  1(D)  failb= 11(D)  OK
raid6test: test_disks(1, 12): faila=  1(D)  failb= 12(D)  OK
raid6test: test_disks(1, 13): faila=  1(D)  failb= 13(D)  OK
raid6test: test_disks(1, 14): faila=  1(D)  failb= 14(P)  OK
raid6test: test_disks(1, 15): faila=  1(D)  failb= 15(Q)  OK
raid6test: test_disks(2, 3): faila=  2(D)  failb=  3(D)  OK
raid6test: test_disks(2, 4): faila=  2(D)  failb=  4(D)  OK
raid6test: test_disks(2, 5): faila=  2(D)  failb=  5(D)  OK
raid6test: test_disks(2, 6): faila=  2(D)  failb=  6(D)  OK
raid6test: test_disks(2, 7): faila=  2(D)  failb=  7(D)  OK
raid6test: test_disks(2, 8): faila=  2(D)  failb=  8(D)  OK
raid6test: test_disks(2, 9): faila=  2(D)  failb=  9(D)  OK
raid6test: test_disks(2, 10): faila=  2(D)  failb= 10(D)  OK
raid6test: test_disks(2, 11): faila=  2(D)  failb= 11(D)  OK
raid6test: test_disks(2, 12): faila=  2(D)  failb= 12(D)  OK
raid6test: test_disks(2, 13): faila=  2(D)  failb= 13(D)  OK
raid6test: test_disks(2, 14): faila=  2(D)  failb= 14(P)  OK
raid6test: test_disks(2, 15): faila=  2(D)  failb= 15(Q)  OK
raid6test: test_disks(3, 4): faila=  3(D)  failb=  4(D)  OK
raid6test: test_disks(3, 5): faila=  3(D)  failb=  5(D)  OK
raid6test: test_disks(3, 6): faila=  3(D)  failb=  6(D)  OK
raid6test: test_disks(3, 7): faila=  3(D)  failb=  7(D)  OK
raid6test: test_disks(3, 8): faila=  3(D)  failb=  8(D)  OK
raid6test: test_disks(3, 9): faila=  3(D)  failb=  9(D)  OK
raid6test: test_disks(3, 10): faila=  3(D)  failb= 10(D)  OK
raid6test: test_disks(3, 11): faila=  3(D)  failb= 11(D)  OK
raid6test: test_disks(3, 12): faila=  3(D)  failb= 12(D)  OK
raid6test: test_disks(3, 13): faila=  3(D)  failb= 13(D)  OK
raid6test: test_disks(3, 14): faila=  3(D)  failb= 14(P)  OK
raid6test: test_disks(3, 15): faila=  3(D)  failb= 15(Q)  OK
raid6test: test_disks(4, 5): faila=  4(D)  failb=  5(D)  OK
raid6test: test_disks(4, 6): faila=  4(D)  failb=  6(D)  OK
raid6test: test_disks(4, 7): faila=  4(D)  failb=  7(D)  OK
raid6test: test_disks(4, 8): faila=  4(D)  failb=  8(D)  OK
raid6test: test_disks(4, 9): faila=  4(D)  failb=  9(D)  OK
raid6test: test_disks(4, 10): faila=  4(D)  failb= 10(D)  OK
raid6test: test_disks(4, 11): faila=  4(D)  failb= 11(D)  OK
raid6test: test_disks(4, 12): faila=  4(D)  failb= 12(D)  OK
raid6test: test_disks(4, 13): faila=  4(D)  failb= 13(D)  OK
raid6test: test_disks(4, 14): faila=  4(D)  failb= 14(P)  OK
raid6test: test_disks(4, 15): faila=  4(D)  failb= 15(Q)  OK
raid6test: test_disks(5, 6): faila=  5(D)  failb=  6(D)  OK
raid6test: test_disks(5, 7): faila=  5(D)  failb=  7(D)  OK
raid6test: test_disks(5, 8): faila=  5(D)  failb=  8(D)  OK
raid6test: test_disks(5, 9): faila=  5(D)  failb=  9(D)  OK
raid6test: test_disks(5, 10): faila=  5(D)  failb= 10(D)  OK
raid6test: test_disks(5, 11): faila=  5(D)  failb= 11(D)  OK
raid6test: test_disks(5, 12): faila=  5(D)  failb= 12(D)  OK
raid6test: test_disks(5, 13): faila=  5(D)  failb= 13(D)  OK
raid6test: test_disks(5, 14): faila=  5(D)  failb= 14(P)  OK
raid6test: test_disks(5, 15): faila=  5(D)  failb= 15(Q)  OK
raid6test: test_disks(6, 7): faila=  6(D)  failb=  7(D)  OK
raid6test: test_disks(6, 8): faila=  6(D)  failb=  8(D)  OK
raid6test: test_disks(6, 9): faila=  6(D)  failb=  9(D)  OK
raid6test: test_disks(6, 10): faila=  6(D)  failb= 10(D)  OK
raid6test: test_disks(6, 11): faila=  6(D)  failb= 11(D)  OK
raid6test: test_disks(6, 12): faila=  6(D)  failb= 12(D)  OK
raid6test: test_disks(6, 13): faila=  6(D)  failb= 13(D)  OK
raid6test: test_disks(6, 14): faila=  6(D)  failb= 14(P)  OK
raid6test: test_disks(6, 15): faila=  6(D)  failb= 15(Q)  OK
raid6test: test_disks(7, 8): faila=  7(D)  failb=  8(D)  OK
raid6test: test_disks(7, 9): faila=  7(D)  failb=  9(D)  OK
raid6test: test_disks(7, 10): faila=  7(D)  failb= 10(D)  OK
raid6test: test_disks(7, 11): faila=  7(D)  failb= 11(D)  OK
raid6test: test_disks(7, 12): faila=  7(D)  failb= 12(D)  OK
raid6test: test_disks(7, 13): faila=  7(D)  failb= 13(D)  OK
raid6test: test_disks(7, 14): faila=  7(D)  failb= 14(P)  OK
raid6test: test_disks(7, 15): faila=  7(D)  failb= 15(Q)  OK
raid6test: test_disks(8, 9): faila=  8(D)  failb=  9(D)  OK
raid6test: test_disks(8, 10): faila=  8(D)  failb= 10(D)  OK
raid6test: test_disks(8, 11): faila=  8(D)  failb= 11(D)  OK
raid6test: test_disks(8, 12): faila=  8(D)  failb= 12(D)  OK
raid6test: test_disks(8, 13): faila=  8(D)  failb= 13(D)  OK
raid6test: test_disks(8, 14): faila=  8(D)  failb= 14(P)  OK
raid6test: test_disks(8, 15): faila=  8(D)  failb= 15(Q)  OK
raid6test: test_disks(9, 10): faila=  9(D)  failb= 10(D)  OK
raid6test: test_disks(9, 11): faila=  9(D)  failb= 11(D)  OK
raid6test: test_disks(9, 12): faila=  9(D)  failb= 12(D)  OK
raid6test: test_disks(9, 13): faila=  9(D)  failb= 13(D)  OK
raid6test: test_disks(9, 14): faila=  9(D)  failb= 14(P)  OK
raid6test: test_disks(9, 15): faila=  9(D)  failb= 15(Q)  OK
raid6test: test_disks(10, 11): faila= 10(D)  failb= 11(D)  OK
raid6test: test_disks(10, 12): faila= 10(D)  failb= 12(D)  OK
raid6test: test_disks(10, 13): faila= 10(D)  failb= 13(D)  OK
raid6test: test_disks(10, 14): faila= 10(D)  failb= 14(P)  OK
raid6test: test_disks(10, 15): faila= 10(D)  failb= 15(Q)  OK
raid6test: test_disks(11, 12): faila= 11(D)  failb= 12(D)  OK
raid6test: test_disks(11, 13): faila= 11(D)  failb= 13(D)  OK
raid6test: test_disks(11, 14): faila= 11(D)  failb= 14(P)  OK
raid6test: test_disks(11, 15): faila= 11(D)  failb= 15(Q)  OK
raid6test: test_disks(12, 13): faila= 12(D)  failb= 13(D)  OK
raid6test: test_disks(12, 14): faila= 12(D)  failb= 14(P)  OK
raid6test: test_disks(12, 15): faila= 12(D)  failb= 15(Q)  OK
raid6test: test_disks(13, 14): faila= 13(D)  failb= 14(P)  OK
raid6test: test_disks(13, 15): faila= 13(D)  failb= 15(Q)  OK
raid6test: test_disks(14, 15): faila= 14(P)  failb= 15(Q)  OK
raid6test: 
raid6test: complete (257 tests, 0 failures)
initcall raid6_test+0x0/0xf9 returned 0 after 1401532 usecs
calling  random32_reseed+0x0/0x7d @ 1
initcall random32_reseed+0x0/0x7d returned 0 after 16 usecs
calling  pci_resource_alignment_sysfs_init+0x0/0x14 @ 1
initcall pci_resource_alignment_sysfs_init+0x0/0x14 returned 0 after 4 usecs
calling  pci_sysfs_init+0x0/0x44 @ 1
initcall pci_sysfs_init+0x0/0x44 returned 0 after 217 usecs
calling  regulator_init_complete+0x0/0x10d @ 1
initcall regulator_init_complete+0x0/0x10d returned 0 after 2 usecs
calling  seqgen_init+0x0/0xe @ 1
initcall seqgen_init+0x0/0xe returned 0 after 16 usecs
calling  hd_init+0x0/0x2d1 @ 1
hd: no drives specified - use hd=cyl,head,sectors on kernel command line
initcall hd_init+0x0/0x2d1 returned -1 after 6315 usecs
initcall hd_init+0x0/0x2d1 returned with error code -1 
calling  scsi_complete_async_scans+0x0/0xf6 @ 1
initcall scsi_complete_async_scans+0x0/0xf6 returned 0 after 1 usecs
calling  edd_init+0x0/0x2be @ 1
BIOS EDD facility v0.16 2004-Jun-25, 1 devices found
initcall edd_init+0x0/0x2be returned 0 after 4652 usecs
calling  memmap_init+0x0/0x2d @ 1
initcall memmap_init+0x0/0x2d returned 0 after 29 usecs
calling  pci_mmcfg_late_insert_resources+0x0/0x57 @ 1
initcall pci_mmcfg_late_insert_resources+0x0/0x57 returned 0 after 3 usecs
calling  tcp_congestion_default+0x0/0xf @ 1
initcall tcp_congestion_default+0x0/0xf returned 0 after 2 usecs
calling  ip_auto_config+0x0/0xda4 @ 1
initcall ip_auto_config+0x0/0xda4 returned 0 after 11 usecs
calling  initialize_hashrnd+0x0/0x16 @ 1
initcall initialize_hashrnd+0x0/0x16 returned 0 after 5 usecs
async_waiting @ 1
async_continuing @ 1 after 1 usec
md: Waiting for all devices to be available before autodetect
md: If you don't use raid, use raid=noautodetect
async_waiting @ 1
async_continuing @ 1 after 1 usec
md: Autodetecting RAID arrays.
md: Scanned 0 and added 0 devices.
md: autorun ...
md: ... autorun DONE.
EXT3-fs (sda1): recovery required on readonly filesystem
EXT3-fs (sda1): write access will be enabled during recovery
EXT3-fs: barriers not enabled
kjournald starting.  Commit interval 5 seconds
EXT3-fs (sda1): recovery complete
EXT3-fs (sda1): mounted filesystem with ordered data mode
VFS: Mounted root (ext3 filesystem) readonly on device 8:1.
devtmpfs: mounted
async_waiting @ 1
async_continuing @ 1 after 2 usec
Freeing unused kernel memory: 932k freed
modprobe: FATAL: Could not load /lib/modules/2.6.39-rc5-i486-1sys+/modules.dep: No such file or directory

INIT: version 2.86 booting
		Welcome to Fedora Core
		Press 'I' to enter interactive startup.
Setting clock  (utc): Wed May  4 22:43:12 CEST 2011 [  OK  ]
Loading default keymap (us): [  OK  ]
Setting hostname mercury:  [  OK  ]
md: Autodetecting RAID arrays.
md: Scanned 0 and added 0 devices.
md: autorun ...
md: ... autorun DONE.
DM multipath kernel driver version too old
No devices found
Setting up Logical Volume Management:   No volume groups found
[  OK  ]
Checking filesystems
Checking all file systems.
[/sbin/fsck.ext3 (1) -- /] fsck.ext3 -a /dev/sda1 
/: clean, 514801/7685440 files, 5466281/7679062 blocks
[/sbin/fsck.ext3 (1) -- /home] fsck.ext3 -a /dev/sda5 
/home: recovering journal
/home: clean, 145081/6111232 files, 1811574/12209392 blocks
[  OK  ]
Remounting root filesystem in reEXT3-fs (sda1): using internal journal
ad-write mode:  [  OK  ]
Mounting local filesystems:  mount: mount poiEXT3-fs: barriers not enabled
nt /dev/shm doeskjournald starting.  Commit interval 5 seconds
EXT3-fs (sda5): using internal journal
EXT3-fs (sda5): mounted filesystem with ordered data mode
 not exist
[FAILED]
Enabling local filesystem quotas:  [  OK  ]
Enabling /etc/fstab swaps:  [  OK  ]
INIT: Entering runlevel: 3
Entering non-interactive startup
Bringing up loopback interface:  [  OK  ]
Bringing up interface eth0:  [  OK  ]
Starting sshd: [  OK  ]
/etc/rc3.d/S99local: line 9: /proc/sys/kernel/exec-shield: No such file or directory
FATAL: Could not load /lib/modules/2.6.39-rc5-i486-1sys+/modules.dep: No such file or directory
Adding 3911820k swap on /dev/sda2.  Priority:-1 extents:1 across:3911820k 
Starting Distributed Compiler daemon (distccd): distccd[3243] (dcc_setup_real_log) ERROR: failed to open /var/log/distccd.log: Permission denied
[  OK  ]
/etc/rc3.d/S99local: line 32: /sys/kernel/uids/0/cpu_share: No such file or directory
/etc/rc3.d/S99local: line 34: /sys/kernel/uids//cpu_share: No such file or directory
NOT testing CPU hotplug
modprobe: FATAL: Could not load /lib/modules/2.6.39-rc5-i486-1sys+/modules.dep: No such file or directory

modprobe: FATAL: Could not load /lib/modules/2.6.39-rc5-i486-1sys+/modules.dep: No such file or directory

/etc/rc3.d/S99local: line 52: /home/mingo/bin/perf: cannot execute binary file

Fedora Core release 6 (Zod)
Kernel 2.6.39-rc5-i486-1sys+ on an i686

mercury login: ssh: connect to host d port 22: No route to host
ssh: connect to host d port 22: No route to host
eth0: no IPv6 routers present
ssh: connect to host d port 22: No route to host
ssh: connect to host d port 22: No route to host
ssh: connect to host d port 22: No route to host
ssh: connect to host d port 22: No route to host
ssh: connect to host d port 22: No route to host
ssh: connect to host d port 22: No route to host
ssh: connect to host d port 22: No route to host
ssh: connect to host d port 22: No route to host
ssh: connect to host d port 22: No route to host
ssh: connect to host d port 22: No route to host
ssh: connect to host d port 22: No route to host

Fedora Core release 6 (Zod)
Kernel 2.6.39-rc5-i486-1sys+ on an i686

mercury login: 
Fedora Core release 6 (Zod)
Kernel 2.6.39-rc5-i486-1sys+ on an i686

mercury login: ssh: connect to host d port 22: No route to host
ssh: connect to host d port 22: No route to host
ssh: connect to host d port 22: No route to host
ssh: connect to host d port 22: No route to host
ssh: connect to host d port 22: No route to host
ssh: connect to host d port 22: No route to host
ssh: connect to host d port 22: No route to host
ssh: connect to host d port 22: No route to host
ssh: connect to host d port 22: No route to host
ssh: connect to host d port 22: No route to host
ssh: connect to host d port 22: No route to host
ssh: connect to host d port 22: No route to host
ssh: connect to host d port 22: No route to host
ssh: connect to host d port 22: No route to host
ssh: connect to host d port 22: No route to host
ssh: connect to host d port 22: No route to host
ssh: connect to host d port 22: No route to host
BUG: unable to handle kernel NULL pointer dereference at 00000008
IP: [<c14e85c0>] generic_make_request+0x86/0x3f4
*pde = 00000000 
Oops: 0000 [#1] SMP 
last sysfs file: /sys/devices/pci0000:00/0000:00:0a.0/net/eth0/address
Modules linked in:

Pid: 2969, comm: flush-8:0 Not tainted 2.6.39-rc5-i486-1sys+ #122580 System manufacturer System Product Name/A8N-E
EIP: 0060:[<c14e85c0>] EFLAGS: 00010202 CPU: 1
EIP is at generic_make_request+0x86/0x3f4
EAX: 00000000 EBX: f569e280 ECX: f6a00000 EDX: f5528000
ESI: 00000008 EDI: 00000001 EBP: f5fd7c8c ESP: f5fd7c14
 DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
Process flush-8:0 (pid: 2969, ti=f5fd6000 task=f64d0ab0 task.ti=f5fd6000)
Stack:
 f569e280 c10988af f5fd7c84 c1d74030 f6402400 f569e300 00081ddb f569e280
 c10988af f5fd7c84 f64d0ab0 0000007b 0000007b 000000d8 00000008 ffffffc1
 00000000 00000000 00000246 f6a06c80 055c08fe 00000000 c10988af 00000080
Call Trace:
 [<c10988af>] ? mempool_alloc_slab+0x13/0x15
 [<c1d74030>] ? common_interrupt+0x30/0x40
 [<c10988af>] ? mempool_alloc_slab+0x13/0x15
 [<c10988af>] ? mempool_alloc_slab+0x13/0x15
 [<c14e89f9>] submit_bio+0xcb/0xe4
 [<c10a8048>] ? inc_zone_page_state+0xe/0x88
 [<c10ed8b5>] ? bio_init+0x9/0x2e
 [<c10ee05b>] ? bio_alloc_bioset+0x3c/0x9c
 [<c10ea27a>] submit_bh+0xc6/0xe0
 [<c10eb8f3>] __block_write_full_page+0x20a/0x2df
 [<c10ed9d9>] ? bio_put+0x8/0x2c
 [<c10ea9e5>] ? end_buffer_async_read+0xd5/0xd5
 [<c10eba88>] block_write_full_page_endio+0xc0/0xc8
 [<c10ea9e5>] ? end_buffer_async_read+0xd5/0xd5
 [<c10ebaa7>] block_write_full_page+0x17/0x19
 [<c10ea9e5>] ? end_buffer_async_read+0xd5/0xd5
 [<c1156fd0>] ext3_ordered_writepage+0xc8/0x19c
 [<c11566ee>] ? bput_one+0x10/0x10
 [<c109c9ce>] __writepage+0x10/0x28
 [<c109cd96>] write_cache_pages+0x1c9/0x283
 [<c109c9be>] ? bdi_set_max_ratio+0x52/0x52
 [<c109ce86>] generic_writepages+0x36/0x49
 [<c109d994>] do_writepages+0x28/0x2b
 [<c10e5642>] writeback_single_inode+0xa6/0x18d
 [<c10e58ef>] writeback_sb_inodes+0xa6/0x10b
 [<c10e6267>] writeback_inodes_wb+0xd9/0xee
 [<c10e642b>] wb_writeback+0x1af/0x26d
 [<c1045c12>] ? try_to_del_timer_sync+0x81/0x89
 [<c103faca>] ? local_bh_disable+0x8/0x18
 [<c10e655a>] wb_do_writeback+0x71/0x181
 [<c1045dc0>] ? add_timer_on+0x95/0x95
 [<c1045cb1>] ? del_timer+0xc/0x86
 [<c10e66d8>] bdi_writeback_thread+0x6e/0x186
 [<c10e666a>] ? wb_do_writeback+0x181/0x181
 [<c1051f73>] kthread+0x67/0x6c
 [<c1051f0c>] ? kthread_worker_fn+0x114/0x114
 [<c1d74046>] kernel_thread_helper+0x6/0x10
Code: 00 c7 45 c8 00 00 00 00 8d 55 c8 89 90 f4 02 00 00 89 45 b0 8b 53 20 c1 ea 09 89 55 c0 e8 e3 8c 88 00 83 7d c0 00 74 69 8b 43 0c <8b> 40 08 8b 90 84 00 00 00 f6 c2 01 74 04 f3 90 eb f1 8b 70 7c 
EIP: [<c14e85c0>] generic_make_request+0x86/0x3f4 SS:ESP 0068:f5fd7c14
CR2: 0000000000000008
---[ end trace c45e837de578cd2f ]---
------------[ cut here ]------------
WARNING: at kernel/exit.c:911 do_exit+0x6c/0x659()
Hardware name: System Product Name
Modules linked in:
Pid: 2969, comm: flush-8:0 Tainted: G      D     2.6.39-rc5-i486-1sys+ #122580
Call Trace:
 [<c1d59e1f>] ? printk+0x1d/0x1f
 [<c103b353>] warn_slowpath_common+0x7c/0x91
 [<c103dccf>] ? do_exit+0x6c/0x659
 [<c103dccf>] ? do_exit+0x6c/0x659
 [<c103b38a>] warn_slowpath_null+0x22/0x24
 [<c103dccf>] do_exit+0x6c/0x659
 [<c103c6cb>] ? kmsg_dump+0x3a/0xb7
 [<c1d59e1f>] ? printk+0x1d/0x1f
 [<c10058ec>] oops_end+0x85/0x8a
 [<c1d59735>] no_context+0x128/0x130
 [<c1d5986b>] __bad_area_nosemaphore+0x12e/0x136
 [<c1025754>] ? native_load_tls+0xa/0x3d
 [<c102717c>] ? vmalloc_sync_all+0xf0/0xf0
 [<c1d5988a>] bad_area_nosemaphore+0x17/0x19
 [<c10272de>] do_page_fault+0x162/0x35c
 [<c1d71090>] ? schedule+0x643/0x6c4
 [<c10ed251>] ? bio_phys_segments+0x9/0x1c
 [<c14e6e50>] ? drive_stat_acct+0xc/0x104
 [<c102717c>] ? vmalloc_sync_all+0xf0/0xf0
 [<c1d737e7>] error_code+0x67/0x70
 [<c14e85c0>] ? generic_make_request+0x86/0x3f4
 [<c10988af>] ? mempool_alloc_slab+0x13/0x15
 [<c1d74030>] ? common_interrupt+0x30/0x40
 [<c10988af>] ? mempool_alloc_slab+0x13/0x15
 [<c10988af>] ? mempool_alloc_slab+0x13/0x15
 [<c14e89f9>] submit_bio+0xcb/0xe4
 [<c10a8048>] ? inc_zone_page_state+0xe/0x88
 [<c10ed8b5>] ? bio_init+0x9/0x2e
 [<c10ee05b>] ? bio_alloc_bioset+0x3c/0x9c
 [<c10ea27a>] submit_bh+0xc6/0xe0
 [<c10eb8f3>] __block_write_full_page+0x20a/0x2df
 [<c10ed9d9>] ? bio_put+0x8/0x2c
 [<c10ea9e5>] ? end_buffer_async_read+0xd5/0xd5
 [<c10eba88>] block_write_full_page_endio+0xc0/0xc8
 [<c10ea9e5>] ? end_buffer_async_read+0xd5/0xd5
 [<c10ebaa7>] block_write_full_page+0x17/0x19
 [<c10ea9e5>] ? end_buffer_async_read+0xd5/0xd5
 [<c1156fd0>] ext3_ordered_writepage+0xc8/0x19c
 [<c11566ee>] ? bput_one+0x10/0x10
 [<c109c9ce>] __writepage+0x10/0x28
 [<c109cd96>] write_cache_pages+0x1c9/0x283
 [<c109c9be>] ? bdi_set_max_ratio+0x52/0x52
 [<c109ce86>] generic_writepages+0x36/0x49
 [<c109d994>] do_writepages+0x28/0x2b
 [<c10e5642>] writeback_single_inode+0xa6/0x18d
 [<c10e58ef>] writeback_sb_inodes+0xa6/0x10b
 [<c10e6267>] writeback_inodes_wb+0xd9/0xee
 [<c10e642b>] wb_writeback+0x1af/0x26d
 [<c1045c12>] ? try_to_del_timer_sync+0x81/0x89
 [<c103faca>] ? local_bh_disable+0x8/0x18
 [<c10e655a>] wb_do_writeback+0x71/0x181
 [<c1045dc0>] ? add_timer_on+0x95/0x95
 [<c1045cb1>] ? del_timer+0xc/0x86
 [<c10e66d8>] bdi_writeback_thread+0x6e/0x186
 [<c10e666a>] ? wb_do_writeback+0x181/0x181
 [<c1051f73>] kthread+0x67/0x6c
 [<c1051f0c>] ? kthread_worker_fn+0x114/0x114
 [<c1d74046>] kernel_thread_helper+0x6/0x10
---[ end trace c45e837de578cd30 ]---

Fedora Core release 6 (Zod)
Kernel 2.6.39-rc5-i486-1sys+ on an i686

mercury login: 
Fedora Core release 6 (Zod)
Kernel 2.6.39-rc5-i486-1sys+ on an i686

mercury login: 
Fedora Core release 6 (Zod)
Kernel 2.6.39-rc5-i486-1sys+ on an i686

mercury login: 
Fedora Core release 6 (Zod)
Kernel 2.6.39-rc5-i486-1sys+ on an i686

mercury login: 
Fedora Core release 6 (Zod)
Kernel 2.6.39-rc5-i486-1sys+ on an i686

mercury login: SysRq : Resetting

--ftEhullJWpWg/VHq--
