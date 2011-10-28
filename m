Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754924Ab1J1Fom (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 01:44:42 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:33262 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752872Ab1J1Fol convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 01:44:41 -0400
MIME-Version: 1.0
In-Reply-To: <4EAA2492.3020907@cn.fujitsu.com>
References: <4EAA2492.3020907@cn.fujitsu.com>
Date: Fri, 28 Oct 2011 13:44:40 +0800
Message-ID: <CAA_GA1dr1j-LbO_DmEwzKm8ncypn65He=_AXY0LQk6BW8qKB5g@mail.gmail.com>
Subject: Re: [possible deadlock][3.1.0-g138c4ae] possible circular locking
 dependency detected
From: Bob Liu <lliubbo@gmail.com>
To: gaowanlong@cn.fujitsu.com
Cc: linux-fsdevel@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 28, 2011 at 11:42 AM, Wanlong Gao <gaowanlong@cn.fujitsu.com> wrote:
> Hi folks:
>
> My dmesg said that:
>
> ======================================================
> [ INFO: possible circular locking dependency detected ]
> 3.1.0-138c4ae #2
> -------------------------------------------------------
> hugemmap05/18198 is trying to acquire lock:
>  (&mm->mmap_sem){++++++}, at: [<ffffffff8114d85c>] might_fault+0x5c/0xb0
>
> but task is already holding lock:
>  (&sb->s_type->i_mutex_key#21){+.+.+.}, at: [<ffffffff811a10f6>] vfs_readdir+0x86/0xe0
>
> which lock already depends on the new lock.
>
>
> the existing dependency chain (in reverse order) is:
>
> -> #1 (&sb->s_type->i_mutex_key#21){+.+.+.}:
>       [<ffffffff810afd34>] validate_chain+0x704/0x860
>       [<ffffffff810b018c>] __lock_acquire+0x2fc/0x500
>       [<ffffffff810b0b01>] lock_acquire+0xb1/0x1a0
>       [<ffffffff815464f2>] __mutex_lock_common+0x62/0x420
>       [<ffffffff81546a1a>] mutex_lock_nested+0x4a/0x60
>       [<ffffffff8120b4ba>] hugetlbfs_file_mmap+0xaa/0x160
>       [<ffffffff81158071>] mmap_region+0x3e1/0x590
>       [<ffffffff81158584>] do_mmap_pgoff+0x364/0x3b0
>       [<ffffffff811587d9>] sys_mmap_pgoff+0x209/0x240
>       [<ffffffff8101aac9>] sys_mmap+0x29/0x30
>       [<ffffffff81551542>] system_call_fastpath+0x16/0x1b
>
> -> #0 (&mm->mmap_sem){++++++}:
>       [<ffffffff810af607>] check_prev_add+0x537/0x560
>       [<ffffffff810afd34>] validate_chain+0x704/0x860
>       [<ffffffff810b018c>] __lock_acquire+0x2fc/0x500
>       [<ffffffff810b0b01>] lock_acquire+0xb1/0x1a0
>       [<ffffffff8114d889>] might_fault+0x89/0xb0
>       [<ffffffff811a0f2e>] filldir+0x7e/0xe0
>       [<ffffffff811b445e>] dcache_readdir+0x5e/0x230
>       [<ffffffff811a1130>] vfs_readdir+0xc0/0xe0
>       [<ffffffff811a12c9>] sys_getdents+0x89/0x100
>       [<ffffffff81551542>] system_call_fastpath+0x16/0x1b
>
> other info that might help us debug this:
>
>  Possible unsafe locking scenario:
>
>       CPU0                    CPU1
>       ----                    ----
>  lock(&sb->s_type->i_mutex_key);
>                               lock(&mm->mmap_sem);
>                               lock(&sb->s_type->i_mutex_key);
>  lock(&mm->mmap_sem);
>
>  *** DEADLOCK ***
>
> 1 lock held by hugemmap05/18198:
>  #0:  (&sb->s_type->i_mutex_key#21){+.+.+.}, at: [<ffffffff811a10f6>] vfs_readdir+0x86/0xe0
>
> stack backtrace:
> Pid: 18198, comm: hugemmap05 Not tainted 3.1.0-138c4ae #2
> Call Trace:
>  [<ffffffff810ad469>] print_circular_bug+0x109/0x110
>  [<ffffffff810af607>] check_prev_add+0x537/0x560
>  [<ffffffff8114e112>] ? do_anonymous_page+0xf2/0x2d0
>  [<ffffffff810afd34>] validate_chain+0x704/0x860
>  [<ffffffff810b018c>] __lock_acquire+0x2fc/0x500
>  [<ffffffff810b0b01>] lock_acquire+0xb1/0x1a0
>  [<ffffffff8114d85c>] ? might_fault+0x5c/0xb0
>  [<ffffffff8114d889>] might_fault+0x89/0xb0
>  [<ffffffff8114d85c>] ? might_fault+0x5c/0xb0
>  [<ffffffff81546763>] ? __mutex_lock_common+0x2d3/0x420
>  [<ffffffff811a10f6>] ? vfs_readdir+0x86/0xe0
>  [<ffffffff811a0f2e>] filldir+0x7e/0xe0
>  [<ffffffff811b445e>] dcache_readdir+0x5e/0x230
>  [<ffffffff811a0eb0>] ? filldir64+0xf0/0xf0
>  [<ffffffff811a0eb0>] ? filldir64+0xf0/0xf0
>  [<ffffffff811a0eb0>] ? filldir64+0xf0/0xf0
>  [<ffffffff811a1130>] vfs_readdir+0xc0/0xe0
>  [<ffffffff8118e9be>] ? fget+0xee/0x220
>  [<ffffffff8118e8d0>] ? fget_raw+0x220/0x220
>  [<ffffffff811a12c9>] sys_getdents+0x89/0x100
>  [<ffffffff81551542>] system_call_fastpath+0x16/0x1b
>

Please try this patch "lockdep: Add helper function for dir vs file
i_mutex annotation" by josh.
http://git.kernel.org/?p=linux/kernel/git/next/linux-next.git;a=commitdiff;h=e096d0c7e2e4e5893792db865dd065ac73cf1f00

>
>
> Wile hugemmap05 is a test case from LTP.
> http://ltp.git.sourceforge.net/git/gitweb.cgi?p=ltp/ltp.git;a=blob;f=testcases/kernel/mem/hugetlb/hugemmap/hugemmap05.c;h=50bb8ca23ae9686662740f9ea5d7187affff8b60;hb=HEAD
>
> But I don't know how to reproduce this.
>
>
> Thanks
> -Wanlong Gao
>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
>

-- 
Regards,
--Bob
