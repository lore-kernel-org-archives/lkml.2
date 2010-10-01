Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751799Ab0JAFUB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 01:20:01 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:65436 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233Ab0JAFT7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 01:19:59 -0400
X-Nat-Received: from [202.181.97.72]:50893 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1285910397.32243
Message-Id: <201010010519.o915Jv7v026590@www262.sakura.ne.jp>
Subject: Re: Is it legal to return positive value when do_execve() succeeds?
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Fri, 01 Oct 2010 14:19:57 +0900
References: <201009302207.IJB81715.tFSLFHFOVJOOMQ@I-love.SAKURA.ne.jp> <201010010229.o912T3rT089958@www262.sakura.ne.jp>
In-Reply-To: <201010010229.o912T3rT089958@www262.sakura.ne.jp>
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.44/RELEASE, bases: 01102010 #4259328, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> But there are several "struct linux_binfmt"->load_binary() users who return
> positive return code for error paths.
> 
>   load_elf_binary() will return positive return code if set_brk() returned
>   positive return code.
> 
It seems to me that this causes undefined behavior.

arch/x86/include/asm/page_32_types.h:
 16 #define __PAGE_OFFSET           _AC(CONFIG_PAGE_OFFSET, UL)

In my .config , CONFIG_PAGE_OFFSET is 0xC0000000.

arch/x86/include/asm/page_types.h:
 29 #define PAGE_OFFSET             ((unsigned long)__PAGE_OFFSET)

Thus, PAGE_OFFSET == 0xC0000000.

arch/x86/include/asm/processor.h:
882 #ifdef CONFIG_X86_32
883 /*
884  * User space process size: 3GB (default).
885  */
886 #define TASK_SIZE               PAGE_OFFSET

Thus, TASK_SIZE == 0xC0000000.

fs/binfmt_elf.c:
 77 #define BAD_ADDR(x) ((unsigned long)(x) >= TASK_SIZE)
 78 
 79 static int set_brk(unsigned long start, unsigned long end)
 80 {
 81         start = ELF_PAGEALIGN(start);
 82         end = ELF_PAGEALIGN(end);
 83         if (end > start) {
 84                 unsigned long addr;
 85                 down_write(&current->mm->mmap_sem);
 86                 addr = do_brk(start, end - start);
 87                 up_write(&current->mm->mmap_sem);
 88                 if (BAD_ADDR(addr))
 89                         return addr;
 90         }
 91         current->mm->start_brk = current->mm->brk = end;
 92         return 0;
 93 }

Thus, BAD_ADDR(x) is ((unsigned long)(x) >= 0xC0000000).

fs/binfmt_elf.c:
564 static int load_elf_binary(struct linux_binprm *bprm, struct pt_regs *regs)
(...snipped...)
573         int retval, i;
(...snipped...)
875         retval = set_brk(elf_bss, elf_brk);
876         if (retval) {
877                 send_sig(SIGKILL, current, 0);
878                 goto out_free_dentry;
879         }
(...snipped...)
981 out:
982         kfree(loc);
983 out_ret:
984         return retval;
985 
986         /* error cleanup */
987 out_free_dentry:
988         allow_write_access(interpreter);
989         if (interpreter)
990                 fput(interpreter);
991 out_free_interp:
992         kfree(elf_interpreter);
993 out_free_ph:
994         kfree(elf_phdata);
995         goto out;

Here retval can take any integer between -1073741824 and 0.

1255 int search_binary_handler(struct linux_binprm *bprm,struct pt_regs *regs)
1256 {
1257         unsigned int depth = bprm->recursion_depth;
1258         int try,retval;
(...snipped...)
1277                         int (*fn)(struct linux_binprm *, struct pt_regs *) = fmt->load_binary;
1278                         if (!fn)
1279                                 continue;
1280                         if (!try_module_get(fmt->module))
1281                                 continue;
1282                         read_unlock(&binfmt_lock);
1283                         retval = fn(bprm, regs);
1284                         /*
1285                          * Restore the depth counter to its starting value
1286                          * in this call, so we don't have to rely on every
1287                          * load_binary function to restore it on return.
1288                          */
1289                         bprm->recursion_depth = depth;
1290                         if (retval >= 0) {
1291                                 if (depth == 0)
1292                                         tracehook_report_exec(fmt, bprm, regs);
1293                                 put_binfmt(fmt);
1294                                 allow_write_access(bprm->file);
1295                                 if (bprm->file)
1296                                         fput(bprm->file);
1297                                 bprm->file = NULL;
1298                                 current->did_exec = 1;
1299                                 proc_exec_connector(current);
1300                                 return retval;
1301                         }
1302                         read_lock(&binfmt_lock);
1303                         put_binfmt(fmt);
1304                         if (retval != -ENOEXEC || bprm->mm == NULL)
1305                                 break;

load_elf_binary() can return any integer between -1073741824 and 0.
Thus, retval can take between -1073741824 and 0.

If retval == -ENOEXEC, search_binary_handler() would continue loop even after
load_elf_binary() recognized the image.

If retval == -EPERM, search_binary_handler() would return and do_execve()
behaves as if execve() was failed due to -EPERM (although execve() has already
reached "the point of no return" and previous image was already gone).

If retval == (e.g.) -1048576, the caller of do_execve() will get undefined
error code.

If retval > 0 (not true for my case but could be true for architectures where
TASK_SIZE is smaller than INT_MAX), the caller of do_execve() may or may not
assume that do_execve() reached "the point of no return".

In any cases, the current task will be killed by send_sig(SIGKILL, current, 0)
but I'm not sure that resources are correctly handled.



Regards.
