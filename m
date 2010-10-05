Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754491Ab0JEFVq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 01:21:46 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:36551 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752360Ab0JEFVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 01:21:45 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: Re: Is it legal to return positive value when do_execve() succeeds?
Cc: kosaki.motohiro@jp.fujitsu.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <201010050224.o952Oaso040307@www262.sakura.ne.jp>
References: <20101005102446.28C3.A69D9226@jp.fujitsu.com> <201010050224.o952Oaso040307@www262.sakura.ne.jp>
Message-Id: <20101005121511.28D4.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue,  5 Oct 2010 14:21:42 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> KOSAKI Motohiro wrote:
> > I think you should read do_brk() itself. the spec is
> > 
> > success case:
> > 	return addr argument
> > 
> > error case: 
> > 	return error code
> > 
> > When does it return invalid address?
> 
> If addr argument is bogus.
> 
> 
> 
> load_elf_binary() in fs/binfmt_elf.c
> 758                 if (unlikely (elf_brk > elf_bss)) {
> 759                         unsigned long nbyte;
> 760                     
> 761                         /* There was a PT_LOAD segment with p_memsz > p_filesz
> 762                            before this one. Map anonymous pages, if needed,
> 763                            and clear the area.  */
> 764                         retval = set_brk (elf_bss + load_bias,
> 765                                           elf_brk + load_bias);
> 766                         if (retval) {
> 767                                 send_sig(SIGKILL, current, 0);
> 
> I think this function is using address information from untrusted source
> (executable file). 

True.

> Thus, I think retval could be
> ELF_PAGEALIGN(elf_bss + load_bias) if elf_bss + load_bias is bogus.

What's mean bogus?
do_brk() call get_unmapped_area() and it check an argument is correctly
unmapped and userland address. If elf_bss + load_bias point to invalid
address, set_brk doesn't return elf_bss+load_bias.


> I'm OK with this if it is guaranteed that elf_bss + load_bias is always valid
> and set_brk() never returns ELF_PAGEALIGN(elf_bss + load_bias).

I think elf_bss + load_bias could be invalid (i.e. >TASK_SIZE). 
but set_brk can detect it.

-------------------------------------------------------------------------
unsigned long
get_unmapped_area(struct file *file, unsigned long addr, unsigned long len,
                unsigned long pgoff, unsigned long flags)
{
        unsigned long (*get_area)(struct file *, unsigned long,
                                  unsigned long, unsigned long, unsigned long);

        unsigned long error = arch_mmap_check(addr, len, flags);
        if (error)
                return error;

        /* Careful about overflows.. */
        if (len > TASK_SIZE)
                return -ENOMEM;

        get_area = current->mm->get_unmapped_area;
        if (file && file->f_op && file->f_op->get_unmapped_area)
                get_area = file->f_op->get_unmapped_area;
        addr = get_area(file, addr, len, pgoff, flags);
        if (IS_ERR_VALUE(addr))
                return addr;

        if (addr > TASK_SIZE - len)			// HERE
                return -ENOMEM;
        if (addr & ~PAGE_MASK)
                return -EINVAL;

        return arch_rebalance_pgtables(addr, len);
}
-------------------------------------------------------------------------


> 
> 768                                 goto out_free_dentry;
> 769                         }
> (...snipped...)
> 835                 /*
> 836                  * Check to see if the section's size will overflow the
> 837                  * allowed task size. Note that p_filesz must always be
> 838                  * <= p_memsz so it is only necessary to check p_memsz.
> 839                  */
> 840                 if (BAD_ADDR(k) || elf_ppnt->p_filesz > elf_ppnt->p_memsz ||
> 841                     elf_ppnt->p_memsz > TASK_SIZE ||
> 842                     TASK_SIZE - elf_ppnt->p_memsz < k) {
> 843                         /* set_brk can never work. Avoid overflows. */
> 844                         send_sig(SIGKILL, current, 0);
> 845                         retval = -EINVAL;
> 
> Here setting -EINVAL. So why not to set a valid error code for set_brk() above?

I don't know. perhaps I am missing anything :)
Please double check.


