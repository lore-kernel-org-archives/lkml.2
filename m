Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755098Ab2GJXaj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 19:30:39 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57115 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755038Ab2GJXah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 19:30:37 -0400
MIME-Version: 1.0
In-Reply-To: <1341859315-17759-4-git-send-email-tj@kernel.org>
References: <1341859315-17759-1-git-send-email-tj@kernel.org>
	<1341859315-17759-4-git-send-email-tj@kernel.org>
Date: Tue, 10 Jul 2012 16:30:36 -0700
X-Google-Sender-Auth: AnjJ3hZ4e9ac9gJlZzbCBydDtBE
Message-ID: <CA+8MBbKtCODJxv0zQ2uL_wRE9U6F6tdOVwYSMv9=OQNLGzcVXQ@mail.gmail.com>
Subject: Re: [PATCH 3/6] workqueue: use @pool instead of @gcwq or @cpu where applicable
From: Tony Luck <tony.luck@intel.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        joshhunt00@gmail.com, axboe@kernel.dk, rni@google.com,
        vgoyal@redhat.com, vwadekar@nvidia.com, herbert@gondor.hengli.com.au,
        davem@davemloft.net, linux-crypto@vger.kernel.org, swhiteho@redhat.com,
        bpm@sgi.com, elder@kernel.org, xfs@oss.sgi.com, marcel@holtmann.org,
        gustavo@padovan.org, johan.hedberg@gmail.com,
        linux-bluetooth@vger.kernel.org, martin.petersen@oracle.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 9, 2012 at 11:41 AM, Tejun Heo <tj@kernel.org> wrote:
> @@ -1234,7 +1235,7 @@ static void worker_enter_idle(struct worker *worker)
>          */
>         WARN_ON_ONCE(gcwq->trustee_state == TRUSTEE_DONE &&
>                      pool->nr_workers == pool->nr_idle &&
> -                    atomic_read(get_gcwq_nr_running(gcwq->cpu)));
> +                    atomic_read(get_pool_nr_running(pool)));
>  }

Just had this WARN_ON_ONCE trigger on ia64 booting next-20120710. I
haven't bisected ... just noticed  that two patches in this series tinker
with lines in this check. next-20120706 didn't generate the WARN.

-Tony

Mount-cache hash table entries: 1024
ACPI: Core revision 20120518
Boot processor id 0x0/0x0
------------[ cut here ]------------
WARNING: at kernel/workqueue.c:1217 worker_enter_idle+0x2d0/0x4a0()
Modules linked in:

Call Trace:
 [<a0000001000154e0>] show_stack+0x80/0xa0
                                sp=e0000040600f7c30 bsp=e0000040600f0da8
 [<a000000100d6e870>] dump_stack+0x30/0x50
                                sp=e0000040600f7e00 bsp=e0000040600f0d90
 [<a0000001000730a0>] warn_slowpath_common+0xc0/0x100
                                sp=e0000040600f7e00 bsp=e0000040600f0d50
 [<a000000100073120>] warn_slowpath_null+0x40/0x60
                                sp=e0000040600f7e00 bsp=e0000040600f0d28
 [<a0000001000aaad0>] worker_enter_idle+0x2d0/0x4a0
                                sp=e0000040600f7e00 bsp=e0000040600f0cf0
 [<a0000001000ad020>] worker_thread+0x4a0/0xbe0
                                sp=e0000040600f7e00 bsp=e0000040600f0c28
 [<a0000001000bda70>] kthread+0x110/0x140
                                sp=e0000040600f7e00 bsp=e0000040600f0be8
 [<a000000100013510>] kernel_thread_helper+0x30/0x60
                                sp=e0000040600f7e30 bsp=e0000040600f0bc0
 [<a00000010000a0c0>] start_kernel_thread+0x20/0x40
                                sp=e0000040600f7e30 bsp=e0000040600f0bc0
---[ end trace 9501f2472a75a227 ]---
