Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755053Ab2DXOXO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 10:23:14 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:58411 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754864Ab2DXOXB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 10:23:01 -0400
MIME-Version: 1.0
In-Reply-To: <CAP145pgsaAN7uvj29Di6Qwtgrr54WvGL6X4rqU-fre8z_zJh4Q@mail.gmail.com>
References: <CAP145pgsaAN7uvj29Di6Qwtgrr54WvGL6X4rqU-fre8z_zJh4Q@mail.gmail.com>
Date: Tue, 24 Apr 2012 16:23:00 +0200
Message-ID: <CAP145pjuQ=Ja6bQLBFdOptzRG29qL2BRvMw=Qz7ub1TOjOn2XQ@mail.gmail.com>
Subject: Re: NULL-ptr deref in mmput via sys_migrate_pages in 3.4-rc4 (proly
 missing mm==NULL check)
From: =?UTF-8?B?Um9iZXJ0IMWad2nEmWNraQ==?= <robert@swiecki.net>
To: linux-kernel@vger.kernel.org
Cc: Christoph Lameter <cl@linux.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 24, 2012 at 12:44 AM, Robert Święcki <robert@swiecki.net> wrote:
> mm/mempolicy.c
> 1362         mm = get_task_mm(task);
> 1363         put_task_struct(task);
> 1364         if (mm)
> 1365                 err = do_migrate_pages(mm, old, new,
> 1366                         capable(CAP_SYS_NICE) ? MPOL_MF_MOVE_ALL
> : MPOL_MF_MOVE);
> 1367         else
> 1368                 err = -EINVAL;
> 1369
> 1370         mmput(mm);
>
> Where mmput doesn't check for mm
>
> kernel/fork.c
> 567 void mmput(struct mm_struct *mm)
> 568 {
> 569         might_sleep();
> 570
> 571         if (atomic_dec_and_test(&mm->mm_users)) {
>
>
> causes NULL-ptr deref
>
> (gdb) target remote /dev/ttyS0
> Remote debugging using /dev/ttyS0
> mmput (mm=0x0) at kernel/fork.c:571
> 571             if (atomic_dec_and_test(&mm->mm_users)) {
>
> (gdb) bt
> #0  mmput (mm=0x0) at kernel/fork.c:571
> #1  0xffffffff8116a1e0 in sys_migrate_pages (pid=<optimized out>,
> maxnode=<optimized out>, old_nodes=<optimized out>,
> new_nodes=<optimized out>) at mm/mempolicy.c:1370
> #2  0xffffffff820726c9 in ?? () at arch/x86/ia32/ia32entry.S:425
>
>
> (gdb) up
> #1  0xffffffff8116a1e0 in sys_migrate_pages (pid=<optimized out>,
> maxnode=<optimized out>, old_nodes=<optimized out>,
> new_nodes=<optimized out>) at mm/mempolicy.c:1370
> 1370            mmput(mm);
> (gdb) p mm
> $1 = (struct mm_struct *) 0x0
> (gdb) p task->mm
> $2 = (struct mm_struct *) 0x0

Most likely caused by this patch:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=3268c63eded4612a3d07b56d1e02ce7731e6608e

-- 
Robert Święcki
