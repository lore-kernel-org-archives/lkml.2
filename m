Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753082Ab1L1CEh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 21:04:37 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:38215 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752723Ab1L1CEf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 21:04:35 -0500
MIME-Version: 1.0
In-Reply-To: <4EF96406.6080102@jp.fujitsu.com>
References: <4EF2F9EB.7000006@jp.fujitsu.com> <4EF36BDA.5080105@gmail.com> <4EF96406.6080102@jp.fujitsu.com>
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Date: Tue, 27 Dec 2011 21:04:13 -0500
Message-ID: <CAHGf_=rW6_94NbxB1cUbrXo+YntDy7RM26XMcqk_SHXVESaSzg@mail.gmail.com>
Subject: Re: [PATCH] mm: mmap system call does not return EOVERFLOW
To: Naotaka Hamaguchi <n.hamaguchi@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> ----------------------------------------------------------------------
> arch/x86/kernel/syscall_table_32.S:
> ...
>  194         .long sys_mmap_pgoff
> ...
>
> mm/mmap.c:
> 1080 SYSCALL_DEFINE6(mmap_pgoff, unsigned long, addr, unsigned long, len,
> 1081                 unsigned long, prot, unsigned long, flags,
> 1082                 unsigned long, fd, unsigned long, pgoff)
> ...
> 1111         down_write(&current->mm->mmap_sem);
> 1112         retval = do_mmap_pgoff(file, addr, len, prot, flags, pgoff);
> 1113         up_write(&current->mm->mmap_sem);
> ----------------------------------------------------------------------
>
>> value. We have
>> no reason to make artificial limit. Why don't you meke a overflow
>> check in sys_mmap()?
>
> I consider it is better to make an overflow check in do_mmap_pgoff.
> There are two reasons:
>
> 1. If we make an overflow check in the entrance of system call, we
>   have to check in sys_mmap for x86_64 and in sys_mmap_pgoff for
>   x86. It means that we have to check for each architecture
>   individually. Therefore, it is more effective to make an
>   overflow check in do_mmap_pgoff because both sys_mmap and
>   sys_mmap_pgoff call do_mmap_pgoff.

arch/x86/include/asm/posix_types_32.h
---------------------------------------------
typedef long            __kernel_off_t;


So, your patch introduce 2GB limitation to 32bit arch. It makes no sense.



> 2. Because the argument "offset" of sys_mmap is a multiple
>   of the page size(otherwise, EINVAL is returned.), no information
>   is lost after shifting right by PAGE_SHIFT bits. Therefore
>   to make an overflow check in do_mmap_pgoff is equivalent
>   to check in sys_mmap.
