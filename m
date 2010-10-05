Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752542Ab0JEElC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 00:41:02 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:63973 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751657Ab0JEElA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 00:41:00 -0400
X-Nat-Received: from [202.181.97.72]:61788 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1286253651.27283
Message-Id: <201010050440.o954ep1I069324@www262.sakura.ne.jp>
Subject: Re: Is it legal to return positive value when do_execve() succeeds?
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: kosaki.motohiro@jp.fujitsu.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Tue, 05 Oct 2010 13:40:51 +0900
References: <20101005102446.28C3.A69D9226@jp.fujitsu.com> <20101005113840.28C9.A69D9226@jp.fujitsu.com> <20101005115656.28D1.A69D9226@jp.fujitsu.com>
In-Reply-To: <20101005115656.28D1.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.44/RELEASE, bases: 05102010 #4291359, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro wrote:
> > BAD_ADDR() macro is useless because 1) do_brk() and do_mmap() return
> > only either valid pointer or error code 2) when kernel and userland have
> > perfectly different address space (such as old 4G:4G separation), to
> > compare TASK_SIZE has no good meaning.
> > 
> > Then, this patch change it to use IS_ERR_VALUE instead (as other a lot
> > of places).

Using IS_ERR_VALUE() makes sense for me.

> Ouch, this patch is completely corrupted. please ignore it.

No problem.
I just browsed fs/binfmt_*.c for similar cases.
Line number is as of 2.6.36-rc6 .





fs/binfmt_aout.c
 46 #define BAD_ADDR(x)     ((unsigned long)(x) >= TASK_SIZE)
 47 
 48 static int set_brk(unsigned long start, unsigned long end)
 49 {
 50         start = PAGE_ALIGN(start);
 51         end = PAGE_ALIGN(end);
 52         if (end > start) {
 53                 unsigned long addr;
 54                 down_write(&current->mm->mmap_sem);
 55                 addr = do_brk(start, end - start);
 56                 up_write(&current->mm->mmap_sem);
 57                 if (BAD_ADDR(addr))
 58                         return addr;
 59         }
 60         return 0;
 61 }

Should be "if (IS_ERR_VALUE(error))" as well?


282                 down_write(&current->mm->mmap_sem);
283                 error = do_brk(text_addr & PAGE_MASK, map_size);
284                 up_write(&current->mm->mmap_sem);
285                 if (error != (text_addr & PAGE_MASK)) {

Should be "if (IS_ERR_VALUE(error))" as well?

286                         send_sig(SIGKILL, current, 0);
287                         return error;
288                 }


327                 down_write(&current->mm->mmap_sem);
328                 error = do_mmap(bprm->file, N_TXTADDR(ex), ex.a_text,
329                         PROT_READ | PROT_EXEC,
330                         MAP_FIXED | MAP_PRIVATE | MAP_DENYWRITE | MAP_EXECUTABLE,
331                         fd_offset);
332                 up_write(&current->mm->mmap_sem);
333 
334                 if (error != N_TXTADDR(ex)) {

Should be "if (IS_ERR_VALUE(error))" as well?

335                         send_sig(SIGKILL, current, 0);
336                         return error;
337                 }
338 
339                 down_write(&current->mm->mmap_sem);
340                 error = do_mmap(bprm->file, N_DATADDR(ex), ex.a_data,
341                                 PROT_READ | PROT_WRITE | PROT_EXEC,
342                                 MAP_FIXED | MAP_PRIVATE | MAP_DENYWRITE | MAP_EXECUTABLE,
343                                 fd_offset + ex.a_text);
344                 up_write(&current->mm->mmap_sem);
345                 if (error != N_DATADDR(ex)) {

Should be "if (IS_ERR_VALUE(error))" as well?

346                         send_sig(SIGKILL, current, 0);
347                         return error;
348                 }





fs/binfmt_elf_fdpic.c
416         install_exec_creds(bprm);
417         current->flags &= ~PF_FORKNOEXEC;
418         if (create_elf_fdpic_tables(bprm, current->mm,
419                                     &exec_params, &interp_params) < 0)
420                 goto error_kill;
421 

Why retval == 0 here and retval < 0 elsewhere in this function when
the current process is to be killed?


459 
460         /* unrecoverable error - kill the process */
461 error_kill:
462         send_sig(SIGSEGV, current, 0);

Why not to SIGKILL rather than SIGSEGV?

463         goto error;
464 
465 }





fs/binfmt_flat.c
280         while ((ret = zlib_inflate(&strm, Z_NO_FLUSH)) == Z_OK) {
281                 ret = bprm->file->f_op->read(bprm->file, buf, LBUFSIZE, &fpos);
282                 if (ret <= 0)
283                         break;
284                 len -= ret;
285 
286                 strm.next_in = buf;
287                 strm.avail_in = ret;
288                 strm.total_in = 0;
289         }
290 
291         if (ret < 0) {
292                 DBG_FLT("binfmt_flat: decompression failed (%d), %s\n",
293                         ret, strm.msg);
294                 goto out_zlib;
295         }
296 
297         retval = 0;

zlib_inflate() may return positive return code.
Is it OK to ignore partial inflation?


372 
373 failed:
374         printk(", killing %s!\n", current->comm);
375         send_sig(SIGSEGV, current, 0);

Why not to SIGKILL rather than SIGSEGV?

376 
377         return RELOC_FAILED;
378 }


582 #ifdef CONFIG_BINFMT_ZFLAT
583                 if (flags & FLAT_FLAG_GZDATA) {
584                         result = decompress_exec(bprm, fpos, (char *) datapos, 
585                                                  data_len + (relocs * sizeof(unsigned long)), 0);
586                 } else
587 #endif
588                 {
589                         result = bprm->file->f_op->read(bprm->file, (char *) datapos,
590                                         data_len + (relocs * sizeof(unsigned long)), &fpos);
591                 }
592                 if (IS_ERR_VALUE(result)) {

Is it OK to ignore partial read/inflation?


634                 if (flags & FLAT_FLAG_GZIP) {
635                         result = decompress_exec(bprm, sizeof (struct flat_hdr),
636                                          (((char *) textpos) + sizeof (struct flat_hdr)),
637                                          (text_len + data_len + (relocs * sizeof(unsigned long))
638                                                   - sizeof (struct flat_hdr)),
639                                          0);

Why not to check inflation failure before memmove()?

640                         memmove((void *) datapos, (void *) realdatastart,
641                                         data_len + (relocs * sizeof(unsigned long)));


642                 } else if (flags & FLAT_FLAG_GZDATA) {
643                         fpos = 0;
644                         result = bprm->file->f_op->read(bprm->file,
645                                         (char *) textpos, text_len, &fpos);

Why not to check partial read?

646                         if (!IS_ERR_VALUE(result))
647                                 result = decompress_exec(bprm, text_len, (char *) datapos,
648                                                  data_len + (relocs * sizeof(unsigned long)), 0);
649                 }
650                 else
651 #endif
652                 {
653                         fpos = 0;
654                         result = bprm->file->f_op->read(bprm->file,
655                                         (char *) textpos, text_len, &fpos);

Why not to check partial read?

656                         if (!IS_ERR_VALUE(result)) {
657                                 fpos = ntohl(hdr->data_start);
658                                 result = bprm->file->f_op->read(bprm->file, (char *) datapos,
659                                         data_len + (relocs * sizeof(unsigned long)), &fpos);
660                         }
661                 }

Why not to check partial read/inflation?

662                 if (IS_ERR_VALUE(result)) {
663                         printk("Unable to read code+data+bss, errno %d\n",(int)-result);
664                         do_munmap(current->mm, textpos, text_len + data_len + extra +
665                                 MAX_SHARED_LIBS * sizeof(unsigned long));
666                         ret = result;
667                         goto err;
668                 }





fs/binfmt_som.c
150         down_write(&current->mm->mmap_sem);
151         retval = do_mmap(file, code_start, code_size, prot,
152                         flags, SOM_PAGESTART(hpuxhdr->exec_tfile));
153         up_write(&current->mm->mmap_sem);
154         if (retval < 0 && retval > -1024)
155                 goto out;

What is 1024? Why not to IS_ERR_VALUE()?





By the way, I though it would be nice to have

  do_mmap_current()
  do_brk_current()

because there are a lot of

  down_write(&current->mm->mmap_sem);
  error = do_mmap();
  up_write(&current->mm->mmap_sem);

  down_write(&current->mm->mmap_sem);
  error = do_brk();
  up_write(&current->mm->mmap_sem);

repetition.





Also, it would be nice to have

  bool kill_self_if_error(int error)
  {
  	if (!IS_ERR_VALUE(error))
  		return false;
  	send_sig(SIGKILL, current, 0);
  	return true;
  }

for avoiding

  send_sig(SIGKILL, current, 0);

many times.

Regards.
