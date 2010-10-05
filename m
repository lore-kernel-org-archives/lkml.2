Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757152Ab0JECYj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 22:24:39 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:61515 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753261Ab0JECYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 22:24:38 -0400
X-Nat-Received: from [202.181.97.72]:64332 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1286245476.12235
Message-Id: <201010050224.o952Oaso040307@www262.sakura.ne.jp>
Subject: Re: Is it legal to return positive value when do_execve() succeeds?
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: kosaki.motohiro@jp.fujitsu.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Tue, 05 Oct 2010 11:24:36 +0900
References: <20101004135524.E8A5.A69D9226@jp.fujitsu.com> <201010042231.EEG13079.OFSFtOMJHVFLQO@I-love.SAKURA.ne.jp> <20101005102446.28C3.A69D9226@jp.fujitsu.com>
In-Reply-To: <20101005102446.28C3.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.44/RELEASE, bases: 05102010 #4291359, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro wrote:
> I think you should read do_brk() itself. the spec is
> 
> success case:
> 	return addr argument
> 
> error case: 
> 	return error code
> 
> When does it return invalid address?

If addr argument is bogus.



load_elf_binary() in fs/binfmt_elf.c
758                 if (unlikely (elf_brk > elf_bss)) {
759                         unsigned long nbyte;
760                     
761                         /* There was a PT_LOAD segment with p_memsz > p_filesz
762                            before this one. Map anonymous pages, if needed,
763                            and clear the area.  */
764                         retval = set_brk (elf_bss + load_bias,
765                                           elf_brk + load_bias);
766                         if (retval) {
767                                 send_sig(SIGKILL, current, 0);

I think this function is using address information from untrusted source
(executable file). Thus, I think retval could be
ELF_PAGEALIGN(elf_bss + load_bias) if elf_bss + load_bias is bogus.
I'm OK with this if it is guaranteed that elf_bss + load_bias is always valid
and set_brk() never returns ELF_PAGEALIGN(elf_bss + load_bias).

768                                 goto out_free_dentry;
769                         }
(...snipped...)
835                 /*
836                  * Check to see if the section's size will overflow the
837                  * allowed task size. Note that p_filesz must always be
838                  * <= p_memsz so it is only necessary to check p_memsz.
839                  */
840                 if (BAD_ADDR(k) || elf_ppnt->p_filesz > elf_ppnt->p_memsz ||
841                     elf_ppnt->p_memsz > TASK_SIZE ||
842                     TASK_SIZE - elf_ppnt->p_memsz < k) {
843                         /* set_brk can never work. Avoid overflows. */
844                         send_sig(SIGKILL, current, 0);
845                         retval = -EINVAL;

Here setting -EINVAL. So why not to set a valid error code for set_brk() above?

846                         goto out_free_dentry;
847                 }
848 
849                 k = elf_ppnt->p_vaddr + elf_ppnt->p_filesz;
850 
851                 if (k > elf_bss)
852                         elf_bss = k;
853                 if ((elf_ppnt->p_flags & PF_X) && end_code < k)
854                         end_code = k;
855                 if (end_data < k)
856                         end_data = k;
857                 k = elf_ppnt->p_vaddr + elf_ppnt->p_memsz;
858                 if (k > elf_brk)
859                         elf_brk = k;
