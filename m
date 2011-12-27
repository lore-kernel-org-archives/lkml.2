Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751590Ab1L0GV4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 01:21:56 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:51969 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993Ab1L0GVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 01:21:48 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.5.1
Message-ID: <4EF96406.6080102@jp.fujitsu.com>
Date: Tue, 27 Dec 2011 15:21:58 +0900
From: Naotaka Hamaguchi <n.hamaguchi@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.25) Gecko/20111213 Thunderbird/3.1.17
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] mm: mmap system call does not return EOVERFLOW
References: <4EF2F9EB.7000006@jp.fujitsu.com> <4EF36BDA.5080105@gmail.com>
In-Reply-To: <4EF36BDA.5080105@gmail.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Kosaki-san

> Which version are you looking at? Current code seems to don't have
> sys_mmap().

This sys_mmap() means the entrance of mmap system call for x86_64.

----------------------------------------------------------------------
arch/x86/kernel/sys_x86_64.c:
  84 SYSCALL_DEFINE6(mmap, unsigned long, addr, unsigned long, len,
  85                 unsigned long, prot, unsigned long, flags,
  86                 unsigned long, fd, unsigned long, off)
  87 {
  88         long error;
  89         error = -EINVAL;
  90         if (off & ~PAGE_MASK)
  91                 goto out;
  92 
  93         error = sys_mmap_pgoff(addr, len, prot, flags, fd, off >> PAGE_SHIFT);
  94 out:
  95         return error;
  96 }
----------------------------------------------------------------------

This function calls sys_mmap_pgoff, which has the argument
"off >> PAGE_SHIFT". It means that sys_mmap_pgoff does not use off,
which is the argument of sys_mmap, with no change, but uses the value
obtained after off is shifted right by PAGE_SHIFT bits.

In mmap system call for x86, the following sys_mmap_pgoff is the
entrance in kernel.

----------------------------------------------------------------------
arch/x86/kernel/syscall_table_32.S:
...
 194         .long sys_mmap_pgoff
...

mm/mmap.c:
1080 SYSCALL_DEFINE6(mmap_pgoff, unsigned long, addr, unsigned long, len,
1081                 unsigned long, prot, unsigned long, flags,
1082                 unsigned long, fd, unsigned long, pgoff)
...
1111         down_write(&current->mm->mmap_sem);
1112         retval = do_mmap_pgoff(file, addr, len, prot, flags, pgoff);
1113         up_write(&current->mm->mmap_sem);
----------------------------------------------------------------------

> value. We have
> no reason to make artificial limit. Why don't you meke a overflow
> check in sys_mmap()?

I consider it is better to make an overflow check in do_mmap_pgoff.
There are two reasons:

1. If we make an overflow check in the entrance of system call, we
   have to check in sys_mmap for x86_64 and in sys_mmap_pgoff for
   x86. It means that we have to check for each architecture
   individually. Therefore, it is more effective to make an
   overflow check in do_mmap_pgoff because both sys_mmap and
   sys_mmap_pgoff call do_mmap_pgoff.

2. Because the argument "offset" of sys_mmap is a multiple
   of the page size(otherwise, EINVAL is returned.), no information
   is lost after shifting right by PAGE_SHIFT bits. Therefore
   to make an overflow check in do_mmap_pgoff is equivalent
   to check in sys_mmap.

Best Regards,
Naotaka Hamaguchi

(2011/12/23 2:41), KOSAKI Motohiro wrote:
>> The argument "offset" is shifted right by PAGE_SHIFT bits
>> in sys_mmap(mmap systemcall).
>>
>> ------------------------------------------------------------------------
>> sys_mmap(unsigned long addr, unsigned long len,
>> 	unsigned long prot, unsigned long flags,
>> 	unsigned long fd, unsigned long off)
>> {
>> 	error = sys_mmap_pgoff(addr, len, prot, flags, fd, off>>   PAGE_SHIFT);
>> }
>> ------------------------------------------------------------------------
> 
> Hm.
> Which version are you looking at? Current code seems to don't have
> sys_mmap().
> 
> 
> 
> 
> 


