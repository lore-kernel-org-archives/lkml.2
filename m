Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932532Ab1KGOC7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 09:02:59 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48717 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755578Ab1KGOC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 09:02:57 -0500
Date: Mon, 7 Nov 2011 06:03:14 -0800
From: Tejun Heo <tj@kernel.org>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        sergey.senozhatsky@gmail.com, bp@alien8.de,
        Ingo Molnar <mingo@elte.hu>, David Rientjes <rientjes@google.com>,
        casteyde.christian@free.fr, Vegard Nossum <vegardno@ifi.uio.no>,
        Pekka Enberg <penberg@kernel.org>
Subject: Re: [PATCH 1/4] lockdep: lock_set_subclass() fix
Message-ID: <20111107140314.GA18257@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1320398790-21663-1-git-send-email-yong.zhang0@gmail.com>
 <1320398790-21663-2-git-send-email-yong.zhang0@gmail.com>
 <1320669279.18053.29.camel@twins>
 <20111107133131.GB2783@zhy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111107133131.GB2783@zhy>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc'ing the bug reporter and kmemcheck ppl)

Hello,

On Mon, Nov 07, 2011 at 09:31:31PM +0800, Yong Zhang wrote:
> I prefer reverting that commit, but bugzilla is down and I don't know
> what the real problem behind that commit.

So, this was the kmemcheck which triggers.

  PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and
  report a bug
  WARNING: kmemcheck: Caught 64-bit read from uninitialized memory
  (ffff8801c6783c58)
  0000000000000000ee0caa81ffffffff00000000000000000000000000000000
   i i i i i i i i i i i i i i i i i i i i u u u u u u u u u u u u
						  ^

  Pid: 1, comm: swapper Not tainted 3.0.0-rc2 #8 Acer Aspire 7750G/JE70_HR
  RIP: 0010:[<ffffffff8108f3b3>]  [<ffffffff8108f3b3>]
  process_one_work+0x83/0x450
  RSP: 0018:ffff8801c6507d80  EFLAGS: 00010002
  RAX: 0000000000000000 RBX: ffff8801c7418300 RCX: 0000000000000000
  RDX: ffff8801c79d5800 RSI: ffff8801c6783c10 RDI: ffff8801c7418300
  RBP: ffff8801c6507e10 R08: ffff8801c64f8058 R09: 0000000000000001
  R10: 0000000000000000 R11: 0000000000000000 R12: ffff8801c6783c10
  R13: ffff8801c79d5800 R14: ffff8801c780ca00 R15: 000000000000003b
  FS:  0000000000000000(0000) GS:ffff8801c7800000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
  CR2: ffff8801c7430364 CR3: 0000000001c03000 CR4: 00000000000406f0
  DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
  DR3: 0000000000000000 DR6: 00000000ffff4ff0 DR7: 0000000000000400
   [<ffffffff810927cc>] worker_thread+0x15c/0x330
   [<ffffffff81097396>] kthread+0xa6/0xb0
   [<ffffffff817b3c54>] kernel_thread_helper+0x4/0x10
   [<ffffffffffffffff>] 0xffffffffffffffff
  \_SB_.PCI0:_OSC invalid UUID
  _OSC request data:1 8 1f

kmemcheck is complaining that memory area which hasn't been
initialized before is being read.  The offending code line is "struct
lockdep_map = work->lockdep_map" in process_one_work(), which caches
lockdep_map because work item can be destroyed once it starts
execution.

I don't have problem with reverting the patch but it would be much
better if it can play nice with kmemcheck.  It seems lockdep_map init
requirements are rather weird.  Maybe just avoiding clearing ->name is
better?

Thanks.

-- 
tejun
