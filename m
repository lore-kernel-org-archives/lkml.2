Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754320Ab0EFXAY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 19:00:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55617 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753957Ab0EFXAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 19:00:23 -0400
Date: Thu, 6 May 2010 15:59:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kyle Hubert <khubert@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: race condition between udevd and modprobe (mtrr_add)
Message-Id: <20100506155951.af7b3ded.akpm@linux-foundation.org>
In-Reply-To: <p2n9a158e2e1005032230u2cb21e6do40ae0b58e746b75f@mail.gmail.com>
References: <p2n9a158e2e1005032230u2cb21e6do40ae0b58e746b75f@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 May 2010 22:30:01 -0700
Kyle Hubert <khubert@gmail.com> wrote:

> Hi, while booting an initrd image built off of BusyBox on a thousand
> nodes, we hit a race on a couple of nodes. They hang during the boot
> process with the stack traces listed below. The really simple init
> script in the initrd does a 'udevd --daemon' and then modprobe of a
> device. The device needs to assign an mtrr to the pci resource, and
> instead the whole node hangs. Putting a 'sleep 1' in between these two
> calls prevents any hangs.
> 
> mtrr_add_page and the buddy allocator code don't appear to share any
> semaphores, and there isn't an obvious way in which this can hang.
> Possibly the smp_call_function IPI isn't being handled by the other
> cores... That's the best guess. Can anyone help sort this mess out?
> 
> Also, is there a better way to test that udevd is fully up? A 'sleep
> 1' is not the preferred solution here.
> 
> Thanks for your time,
> 

What kernel version are you using here?  It looks old - pre 2.6.31.

> 
> >> ps
>               ADDR    UID    PID   PPID  STATE     FLAGS CPU  NAME
> ===============================================================================
> ...
> 0xffff88061d26c720      0   1036      1      0  0x400140   -  udevd
> 0xffff88021e05c480      0   1037      1      0  0x400100   -  modprobe
> 0xffff88081d072440      0   1116   1036      0  0x400040   -  udevd
> ===============================================================================
> 135 active task structs found
> >> bt 0xffff88021e05c480
> ================================================================
> STACK TRACE FOR TASK: 0xffff88021e05c480(modprobe)
> 
>  0 <schedule?> [0x0]
>  1 mtrr_add_page+494 [0xffffffff80219d9e]
>  2 <unknown?>+<ERROR> [0xffffffffa0009a08]
> ================================================================
> >> bt 0xffff88061d25f420
> ================================================================
> STACK TRACE FOR TASK: 0xffff88061d25f420(udevd)
> 
>  0 <schedule?> [0x0]
>  1 __alloc_pages_internal+241 [0xffffffff80292731]
>  2 rmqueue_bulk+89 [0xffffffff80291b19]
>  3 get_page_from_freelist+1430 [0xffffffff802922e6]
>  4 __alloc_pages_internal+241 [0xffffffff80292731]
>  5 alloc_pages_current+168 [0xffffffff802b0898]
>  6 pte_alloc_one+49 [0xffffffff80229271]
>  7 __pte_alloc+67 [0xffffffff8029e7d3]
>  8 copy_page_range+1269 [0xffffffff802a11c5]
>  9 alloc_pid+744 [0xffffffff80250a18]
> 10 copy_process+3057 [0xffffffff8023bcf1]
> 11 do_fork+118 [0xffffffff8023c4d6]
> 12 sys_clone+35 [0xffffffff80209c23]
> 13 ptregscall_common+103 [0xffffffff8020bda7]

These traces look odd - the kernel shouldn't be calling schedule() from
below rmqueue_bulk()!

If possible, please try a more recent kernel.  If the problem occurs
there and if we manage to fix it, the fix can be backported into
whatever-kernel-version-you're-using.

Can you get a better trace?  The sysrq-T output would be good.  That's
known to work sufficiently well.  Please avoid wordwrapping it when sending.

