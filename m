Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932133Ab1BYAsL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 19:48:11 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:61277 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754995Ab1BYAsI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 19:48:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=e6lEm0GXQXrpxEUnp6t1bgNyb8mPIorR+mJxvhmNj4Y9fqBJNjunxxeHAGLAx8XB33
         6ERHGh1/zZQrArFv1ndoJCoKcy7QoJhGyb4HvMmLHVTyoQ05GNGq4VroczyKRuyZuHJq
         mDraQnY54liFhwzyBLU1F1D+pFtbCOS0MViT4=
MIME-Version: 1.0
In-Reply-To: <AANLkTinzse1ZfEvAuWfuZ_8VDypcnD5poU6GwOdYTgWh@mail.gmail.com>
References: <AANLkTi=TTZ57d1wUz1uH3R6igN8O77iDvSLMW=t86g9V@mail.gmail.com>
	<20110222140349.GA20708@kryptos.osrc.amd.com>
	<AANLkTikESHHfjBqoLFOno6qQz-NXEAo-wBY5JEeAW61N@mail.gmail.com>
	<AANLkTinh4pF7iaUGMcv_9gPy+VBD5POsTHbF_2zPJ17r@mail.gmail.com>
	<AANLkTi=Ys4mb4pc28cH4NMdtMgb2KewJbkXEGJmEP4J0@mail.gmail.com>
	<AANLkTinxHVDwSCouTaZEvR3yTJnSPAas9z6JauGDdS7=@mail.gmail.com>
	<AANLkTinD2cC9dGg2eBtZQhWvhSsuH2BcWDj8byLhWWso@mail.gmail.com>
	<AANLkTin8+F003-jFoQ0pd9OjN1oT2iqyNjd58SDJZuMK@mail.gmail.com>
	<AANLkTinzse1ZfEvAuWfuZ_8VDypcnD5poU6GwOdYTgWh@mail.gmail.com>
Date: Fri, 25 Feb 2011 02:48:06 +0200
Message-ID: <AANLkTi=wbtcAOmYE8UF7ynPZ_nR3ZXxVRBcuMVGNK4u0@mail.gmail.com>
Subject: Re: Linux 2.6.38-rc6
From: Anca Emanuel <anca.emanuel@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Airlie <airlied@redhat.com>, linux-fbdev@vger.kernel.org,
        Ben Skeggs <bskeggs@redhat.com>, dri-devel@lists.freedesktop.org,
        Borislav Petkov <bp@amd64.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 24, 2011 at 6:37 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Thu, Feb 24, 2011 at 5:20 AM, Anca Emanuel <anca.emanuel@gmail.com> wrote:
>>>
>>> Every boot?
>>
>> Yes.
>>
>>> And just out of interest, what happens if you don't have the vesafb
>>> driver at all?
>>
>> I used 'e' option from grub, removed the 'set gfxpayload = $linux_gfx_mode'
>> and it works.
>>
>> dmesg: http://pastebin.com/JAZsk4vD
>
> Hmm. So it definitely seems to be the hand-over.
>
> Does this patch make any difference? When we unregister the old
> framebuffer, we still leave it in the registered_fb[] array, which
> looks wrong. But it would also be interesting to hear if setting
> CONFIG_SLUB_DEBUG_ON or CONFIG_DEBUG_PAGEALLOC makes any difference
> (they'd help detect accesses to free'd data structures).
>
>                          Linus
>
 drivers/video/fbmem.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/video/fbmem.c b/drivers/video/fbmem.c
index e2bf953..e8f8925 100644
--- a/drivers/video/fbmem.c
+++ b/drivers/video/fbmem.c
@@ -1511,6 +1511,7 @@ void remove_conflicting_framebuffers(struct
apertures_struct *a,
 			       "%s vs %s - removing generic driver\n",
 			       name, registered_fb[i]->fix.id);
 			unregister_framebuffer(registered_fb[i]);
+			registered_fb[i] = NULL;
 		}
 	}
 }


Tested the patch, and now I get this:
dmesg: http://pastebin.com/ieMNrA7C

[   12.252328] BUG: unable to handle kernel NULL pointer dereference
at 00000000000003b8
[   12.252342] IP: [<ffffffff81311178>] fb_mmap+0x58/0x1d0
[   12.252354] PGD 78e6c067 PUD 78e6d067 PMD 0
[   12.252360] Oops: 0000 [#1] SMP
[   12.252364] last sysfs file: /sys/module/snd/initstate
[   12.252370] CPU 0
[   12.252372] Modules linked in: nouveau(+) snd ttm drm_kms_helper
psmouse serio_raw drm soundcore lp snd_page_alloc i2c_algo_bit video
parport pata_marvell ahci r8169 libahci
[   12.252393]
[   12.252397] Pid: 244, comm: plymouthd Not tainted
2.6.38-rc6-git3-patch-linus+ #2 MICRO-STAR INTERNATIONAL CO.,LTD
MS-7360/MS-7360
[   12.252407] RIP: 0010:[<ffffffff81311178>]  [<ffffffff81311178>]
fb_mmap+0x58/0x1d0
[   12.252414] RSP: 0018:ffff880078e8fd88  EFLAGS: 00010293
[   12.252418] RAX: 00000000ffffffea RBX: ffff88007047d228 RCX: 0000000000000000
[   12.252423] RDX: 000fffffffffffff RSI: ffff88007047d228 RDI: ffff880078f5d840
[   12.252428] RBP: ffff880078e8fdc8 R08: 0000000000000000 R09: ffff88007047d228
[   12.252432] R10: ffff88006f9d9cf0 R11: ffff88006f9d9d28 R12: ffff880037363800
[   12.252437] R13: 0000000000000000 R14: 0000000000000000 R15: ffff88007047d228
[   12.252442] FS:  00007fb5fbaa4720(0000) GS:ffff88007fc00000(0000)
knlGS:0000000000000000
[   12.252448] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   12.252453] CR2: 00000000000003b8 CR3: 0000000078e6b000 CR4: 00000000000006f0
[   12.252458] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   12.252463] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   12.252468] Process plymouthd (pid: 244, threadinfo
ffff880078e8e000, task ffff88003737ad80)
[   12.252473] Stack:
[   12.252476]  ffff880037363800 00000000000000b8 ffff880078e8fdd8
ffffffffffffffea
[   12.252484]  ffff880037363800 00000000000006bb 00000000006bb000
ffff88007047d228
[   12.252491]  ffff880078e8fe98 ffffffff81130543 ffff880078f5d840
0000000000000000
[   12.252499] Call Trace:
[   12.252507]  [<ffffffff81130543>] mmap_region+0x3c3/0x500
[   12.252514]  [<ffffffff81010d7e>] ?
arch_get_unmapped_area_topdown+0x1ce/0x2f0
[   12.252521]  [<ffffffff811309c4>] do_mmap_pgoff+0x344/0x380
[   12.252528]  [<ffffffff810524f1>] ? finish_task_switch+0x41/0xe0
[   12.252535]  [<ffffffff815ac0c3>] ? schedule+0x403/0xa00
[   12.252541]  [<ffffffff81130bfe>] sys_mmap_pgoff+0x1fe/0x230
[   12.252546]  [<ffffffff810108c9>] sys_mmap+0x29/0x30
[   12.252551]  [<ffffffff8100bf02>] system_call_fastpath+0x16/0x1b
[   12.252556] Code: ba ff ff ff ff ff ff 0f 00 48 89 f3 48 8b 40 30
8b 80 b8 00 00 00 25 ff ff 0f 00 49 39 d6 4c 8b 2c c5 c0 cf aa 81 b8
ea ff ff ff <4d> 8b bd b8 03 00 00 76 1f 48 8b 5d d8 4c 8b 65 e0 4c 8b
6d e8
[   12.252603] RIP  [<ffffffff81311178>] fb_mmap+0x58/0x1d0
[   12.252608]  RSP <ffff880078e8fd88>
[   12.252611] CR2: 00000000000003b8
[   12.252616] ---[ end trace 381165bafe65d748 ]---
