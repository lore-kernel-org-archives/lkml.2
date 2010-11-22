Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752330Ab0KVIp7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 03:45:59 -0500
Received: from mail4.comsite.net ([205.238.176.238]:24918 "EHLO
	mail4.comsite.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751541Ab0KVIp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 03:45:58 -0500
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=71.22.127.106;
From: Milton Miller <miltonm@bga.com>
To: Christopher Yeoh <cyeoh@au1.ibm.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-mm@vger.kernel.org>
Subject: Re: [RFC][PATCH] Cross Memory Attach v2 (resend)
In-Reply-To: <20101122122847.3585b447@lilo>
References: <20101122122847.3585b447@lilo>
Message-Id: <xmemattach@mdm.bga.com>
Date: Mon, 22 Nov 2010 02:45:44 -0600
X-Originating-IP: 71.22.127.106
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-11-22 about 1:59:02, Chris Yeoh wrote:
> Resending just in case the previous mail was missed rather than ignored :-)
> I'd appreciate any comments....

sometimes starting a review leads to lots of comments :-)

I'm not subscribed so I guessed a cc list.

> 
> The basic idea behind cross memory attach is to allow MPI programs doing
> intra-node communication to do a single copy of the message rather than
> a double copy of the message via shared memory.
> 
> The following patch attempts to achieve this by allowing a
> destination process, given an address and size from a source process, to
> copy memory directly from the source process into its own address space
> via a system call. There is also a symmetrical ability to copy from 
> the current process's address space into a destination process's
> address space.
> 
> This is an updated version of the patch I posted a while ago. Changes since
> the last version:
> 
> - Implementation is a bit more complicated now, but the syscall interface 
>   has been modified to provide an iovec one for 
>   both the source and destination. This allows for scattered read 
>   -> scattered write.
> 
> - Rename of syscalls to process_vm_readv/process_vm_writev
> 
> - Use of /proc/pid/mem has been considered, but there are issues with 
>   using it:
>   - Does not allow for specifying iovecs for both src and dest, assuming
>     preadv or pwritev was implemented either the area read from or written 
>     to would need to be contiguous. 
>   - Currently mem_read allows only processes who are currently ptrace'ing
>     the target and are still able to ptrace the target to read from the
>     target. This check could possibly be moved to the open call, but its not
>     clear exactly what race this restriction is stopping (reason appears to
>     have been lost)
>   - Having to send the fd of /proc/self/mem via SCM_RIGHTS on unix domain
>     socket is a bit ugly from a userspace point of view, especially when
>     you may have hundreds if not (eventually) thousands of processes that
>     all need to do this with each other
>   - Doesn't allow for some future use of the interface we would like to consider
>     adding in the future (see below)
>   - Interestingly reading from /proc/pid/mem currently actually involves two copies! (But
>     this could be fixed pretty easily)
> 
> - Fixed bug around using mm without correct locking
> 
> - call set_page_dirty_lock only on pages we may have written to
> 
> - Replaces custom security check with call to __ptrace_may_access
> 
> As mentioned previously use of vmsplice instead was considered, 
> but has problems. Since you need the reader and writer working co-operatively
>  if the pipe is not drained then you block. Which requires some wrapping to do non blocking
> on the send side or polling on the receive. In all to all communication
> it requires ordering otherwise you can deadlock. And in the example of
> many MPI tasks writing to one MPI task vmsplice serialises the
> copying.
> 
> There are some cases of MPI collectives where even a single copy interface does
> not get us the performance gain we could. For example in an MPI_Reduce rather than
> copy the data from the source we would like to instead use it directly in a mathops
> (say the reduce is doing a sum) as this would save us doing a copy. 
.. [benchmarks ]

> 
> Chris
> -- 
> cyeoh@au1.ibm.com
> 
> Signed-off-by: Chris Yeoh <cyeoh@au1.ibm.com>
> diff --git a/arch/powerpc/include/asm/systbl.h b/arch/powerpc/include/asm/systbl.h
> index aa0f1eb..f55dbc7 100644
> --- a/arch/powerpc/include/asm/systbl.h
> +++ b/arch/powerpc/include/asm/systbl.h
> @@ -348,3 +348,5 @@ COMPAT_SYS_SPU(sendmsg)
>  COMPAT_SYS_SPU(recvmsg)
>  COMPAT_SYS_SPU(recvmmsg)
>  SYSCALL_SPU(accept4)
> +SYSCALL(process_vm_readv)
> +SYSCALL(process_vm_writev)
> diff --git a/arch/powerpc/include/asm/unistd.h b/arch/powerpc/include/asm/unistd.h
> index 6151937..9ce27ec 100644
> --- a/arch/powerpc/include/asm/unistd.h
> +++ b/arch/powerpc/include/asm/unistd.h
> @@ -367,10 +367,12 @@
>  #define __NR_recvmsg		342
>  #define __NR_recvmmsg		343
>  #define __NR_accept4		344
> +#define __NR_process_vm_readv	345
> +#define __NR_process_vm_writev	346
>  
>  #ifdef __KERNEL__
>  
> -#define __NR_syscalls		345
> +#define __NR_syscalls		347
>  
>  #define __NR__exit __NR_exit
>  #define NR_syscalls	__NR_syscalls
> diff --git a/arch/powerpc/kernel/sys_ppc32.c b/arch/powerpc/kernel/sys_ppc32.c
> index b1b6043..7f6ed34 100644
> --- a/arch/powerpc/kernel/sys_ppc32.c
> +++ b/arch/powerpc/kernel/sys_ppc32.c
> @@ -624,3 +624,4 @@ asmlinkage long compat_sys_fanotify_mark(int fanotify_fd, unsigned int flags,
>  	u64 mask = ((u64)mask_hi << 32) | mask_lo;
>  	return sys_fanotify_mark(fanotify_fd, flags, mask, dfd, pathname);
>  }
> +


looks like a leftover fragment

> diff --git a/arch/x86/include/asm/unistd_32.h b/arch/x86/include/asm/unistd_32.h
> index b766a5e..1446daa 100644
> --- a/arch/x86/include/asm/unistd_32.h
> +++ b/arch/x86/include/asm/unistd_32.h
> @@ -346,10 +346,12 @@
>  #define __NR_fanotify_init	338
>  #define __NR_fanotify_mark	339
>  #define __NR_prlimit64		340
> +#define __NR_process_vm_readv	341
> +#define __NR_process_vm_writev	342
>  
>  #ifdef __KERNEL__
>  
> -#define NR_syscalls 341
> +#define NR_syscalls 343
>  
>  #define __ARCH_WANT_IPC_PARSE_VERSION
>  #define __ARCH_WANT_OLD_READDIR
> diff --git a/arch/x86/kernel/syscall_table_32.S b/arch/x86/kernel/syscall_table_32.S
> index b35786d..f1ed82c 100644
> --- a/arch/x86/kernel/syscall_table_32.S
> +++ b/arch/x86/kernel/syscall_table_32.S
> @@ -340,3 +340,5 @@ ENTRY(sys_call_table)
>  	.long sys_fanotify_init
>  	.long sys_fanotify_mark
>  	.long sys_prlimit64		/* 340 */
> +	.long sys_process_vm_readv
> +	.long sys_process_vm_writev
> diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
> index e6319d1..a8b4f32 100644
> --- a/include/linux/syscalls.h
> +++ b/include/linux/syscalls.h
> @@ -831,5 +831,17 @@ asmlinkage long sys_mmap_pgoff(unsigned long addr, unsigned long len,
>  			unsigned long prot, unsigned long flags,
>  			unsigned long fd, unsigned long pgoff);
>  asmlinkage long sys_old_mmap(struct mmap_arg_struct __user *arg);
> +asmlinkage long sys_process_vm_readv(pid_t pid,
> +				     const struct iovec __user *lvec,
> +				     unsigned long liovcnt,
> +				     const struct iovec __user *rvec,
> +				     unsigned long riovcnt,
> +				     unsigned long flags);
> +asmlinkage long sys_process_vm_writev(pid_t pid,
> +				      const struct iovec __user *lvec,
> +				      unsigned long liovcnt,
> +				      const struct iovec __user *rvec,
> +				      unsigned long riovcnt,
> +				      unsigned long flags);


These will obviously need compat code, as both struct iovec and long are
different on 32 and 64 bit.

It looks like fs/compat.c has a helper for copying a compat iovec.

>  
>  #endif
> diff --git a/mm/memory.c b/mm/memory.c
> index 98b58fe..956afbd 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -57,6 +57,8 @@
>  #include <linux/swapops.h>
>  #include <linux/elf.h>
>  #include <linux/gfp.h>
> +#include <linux/syscalls.h>
> +#include <linux/ptrace.h>
>  
>  #include <asm/io.h>
>  #include <asm/pgalloc.h>
> @@ -3566,6 +3568,334 @@ void print_vma_addr(char *prefix, unsigned long ip)
>  	up_read(&current->mm->mmap_sem);
>  }
>  
> +
> +/*
> + * process_vm_rw_pages - read/write pages from task specified
> + * @task: task to read/write from
> + * @process_pages: struct pages area that can store at least
> + *  nr_pages_to_copy struct page pointers
> + * @pa: address of page in task to start copying from/to
> + * @start_offset: offset in page to start copying from/to
> + * @len: number of bytes to copy
> + * @lvec: iovec array specifying where to copy to/from
> + * @lvec_cnt: number of elements in iovec array
> + * @lvec_current: index in iovec array we are up to
> + * @lvec_offset: offset in bytes from current iovec iov_base we are up to
> + * @vm_write: 0 means copy from, 1 means copy to
> + * @nr_pages_to_copy: number of pages to copy
> + */
> +
> +static int process_vm_rw_pages(struct task_struct *task,
> +			       struct page **process_pages,
> +			       unsigned long pa,
> +			       unsigned long start_offset,
> +			       unsigned long len,
> +			       struct iovec *lvec,
> +			       unsigned long lvec_cnt,
> +			       unsigned long *lvec_current,
> +			       size_t *lvec_offset,
> +			       int vm_write,
> +			       unsigned int nr_pages_to_copy)
> +{
> +	int pages_pinned;
> +	void *target_kaddr;
> +	int i = 0;
> +	int j;
> +	int ret;
> +	unsigned long bytes_to_copy;
> +	unsigned long bytes_copied = 0;
> +	int rc = -EFAULT;
> +
> +	/* Get the pages we're interested in */
> +	pages_pinned = get_user_pages(task, task->mm, pa,
> +				      nr_pages_to_copy,
> +				      vm_write, 0, process_pages, NULL);
> +
> +	if (pages_pinned != nr_pages_to_copy)
> +		goto end;


Throughout this code, you are giving priority to errors encountered over
partial progress, like read and write do.

While this is a new syscall and not read or write, is this intentional?

> +
> +	/* Do the copy for each page */
> +	for (i = 0; (i < nr_pages_to_copy) && (*lvec_current < lvec_cnt); i++) {
> +		/* Make sure we have a non zero length iovec */
> +		while (*lvec_current < lvec_cnt
> +		       && lvec[*lvec_current].iov_len == 0)
> +			(*lvec_current)++;
> +		if (*lvec_current == lvec_cnt)
> +			break;
> +
> +		/* Will copy smallest of:
> +		   - bytes remaining in page
> +		   - bytes remaining in destination iovec */

Please use the kernel multi-line comment style (see Documentation/CodingStyle)
(which is used thoughout memory.c)

> +		bytes_to_copy = min(PAGE_SIZE - start_offset,
> +				    len - bytes_copied);
> +		bytes_to_copy = min((size_t)bytes_to_copy,
> +				    lvec[*lvec_current].iov_len - *lvec_offset);
> +

don't cast arguments to min, use min_t instead.

can all be size_t ?

> +
> +		target_kaddr = kmap(process_pages[i]) + start_offset;
> +
> +		if (vm_write)
> +			ret = copy_from_user(target_kaddr,
> +					     lvec[*lvec_current].iov_base
> +					     + *lvec_offset,
> +					     bytes_to_copy);
> +		else
> +			ret = copy_to_user(lvec[*lvec_current].iov_base
> +					   + *lvec_offset,
> +					   target_kaddr, bytes_to_copy);


access_process_vm uses copy_to|from_user_page, which on many architectures
will invalidate the icache when writing the page.  Some archtectures 
(including sparc) also have cache flushes, some before the copy.  The
most non-trivial seems to be arm.

Hmm, I just realized this could create a ABBA deadlock between the
two processes mm semaphore, as this is holding the remote processes
mmap semaphore while doing copy to or from the current process space.

do we need to keep mmap_sem after we get the pages?  maybe that is the
way out of the deadlock part ...

> +		kunmap(process_pages[i]);
> +		if (ret) {
> +			i++;
> +			goto end;
> +		}
> +		bytes_copied += bytes_to_copy;
> +		*lvec_offset += bytes_to_copy;
> +		if (*lvec_offset == lvec[*lvec_current].iov_len) {
> +			/* Need to copy remaining part of page into
> +			   the next iovec if there are any bytes left in page */

comment style
nit: perhaps more on the first line?

> +			(*lvec_current)++;
> +			*lvec_offset = 0;
> +			start_offset = (start_offset + bytes_to_copy)
> +				% PAGE_SIZE;
> +			if (start_offset)
> +				i--;
> +		} else {
> +			if (start_offset)
> +				start_offset = 0;

This should be unconditional -- a store to an argument (local stack) variable
is likely faster than the compare and branch.

> +		}
> +	}
> +
> +	rc = bytes_copied;
> +
> +end:
> +	for (j = 0; j < pages_pinned; j++) {
> +		if (vm_write && j < i)
> +			set_page_dirty_lock(process_pages[j]);
> +		put_page(process_pages[j]);
> +	}
> +
> +	return rc;
> +}
> +
> +
> +
> +static int process_vm_rw(pid_t pid, unsigned long addr,

maybe call this rw_one  to say its one rvec as opossed to later?

> +			 unsigned long len,
> +			 struct iovec *lvec,
> +			 unsigned long lvec_cnt,
> +			 unsigned long *lvec_current,
> +			 size_t *lvec_offset,
> +			 struct page **process_pages,
> +			 struct mm_struct *mm,
> +			 struct task_struct *task,
> +			 unsigned long flags, int vm_write)
> +{
> +	unsigned long pa = addr & PAGE_MASK;
> +	unsigned long start_offset = addr - pa;
> +	int nr_pages;
> +	unsigned long bytes_copied = 0;
> +	int rc;
> +	unsigned int nr_pages_copied = 0;
> +	unsigned int nr_pages_to_copy;
> +	unsigned int max_pages_per_loop = (PAGE_SIZE * 2)
> +		/ sizeof(struct pages *);
> +
> +
> +	/* Work out address and page range required */
> +	if (len == 0)
> +		return 0;
> +	nr_pages = (addr + len - 1) / PAGE_SIZE - addr / PAGE_SIZE + 1;
> +
> +
> +	down_read(&mm->mmap_sem);
> +	while ((nr_pages_copied < nr_pages) && (*lvec_current < lvec_cnt)) {
> +		nr_pages_to_copy = min(nr_pages - nr_pages_copied,
> +				       max_pages_per_loop);
> +
> +		rc = process_vm_rw_pages(task, process_pages, pa,
> +					 start_offset, len,
> +					 lvec, lvec_cnt,
> +					 lvec_current, lvec_offset,
> +					 vm_write, nr_pages_to_copy);
> +		start_offset = 0;
> +
> +		if (rc == -EFAULT)
> +			goto free_mem;
> +		else {
> +			bytes_copied += rc;
> +			len -= rc;
> +			nr_pages_copied += nr_pages_to_copy;
> +			pa += nr_pages_to_copy * PAGE_SIZE;
> +		}
> +	}
> +
> +	rc = bytes_copied;
> +
> +free_mem:
> +	up_read(&mm->mmap_sem);
> +
> +	return rc;
> +}
> +
> +static int process_vm_rw_v(pid_t pid, const struct iovec __user *lvec,

There are several functions with similar names, and _v doesn't mean much.

This one process vector to vector, and the one above without anything
does one remote vec?

> +			   unsigned long liovcnt,
> +			   const struct iovec __user *rvec,
> +			   unsigned long riovcnt,
> +			   unsigned long flags, int vm_write)
> +{
> +	struct task_struct *task;
> +	struct page **process_pages = NULL;
> +	struct mm_struct *mm;
> +	int i;
> +	int rc;
> +	int bytes_copied;
> +	struct iovec iovstack_l[UIO_FASTIOV];
> +	struct iovec iovstack_r[UIO_FASTIOV];
> +	struct iovec *iov_l = iovstack_l;
> +	struct iovec *iov_r = iovstack_r;
> +	unsigned int nr_pages = 0;
> +	unsigned int nr_pages_iov;
> +	unsigned long iov_l_curr_idx = 0;
> +	size_t iov_l_curr_offset = 0;
> +	int iov_len_total = 0;
> +
> +	/* Get process information */
> +	rcu_read_lock();
> +	task = find_task_by_vpid(pid);
> +	if (task)
> +		get_task_struct(task);
> +	rcu_read_unlock();
> +	if (!task)
> +		return -ESRCH;
> +
> +	task_lock(task);
> +	if (__ptrace_may_access(task, PTRACE_MODE_ATTACH)) {
> +		task_unlock(task);
> +		rc = -EPERM;
> +		goto end;
> +	}
> +	mm = task->mm;
> +
> +	if (!mm) {
> +		rc = -EINVAL;

need task_unlock(task) in this path

> +		goto end;
> +	}
> +
> +	atomic_inc(&mm->mm_users);

get_task_mm has additional tests and should probably be used.
that breaks your optimization of getting doing task_lock(task) once.

> +	task_unlock(task);
> +
> +
> +	if ((liovcnt > UIO_MAXIOV) || (riovcnt > UIO_MAXIOV)) {
> +		rc = -EINVAL;
> +		goto release_mm;
> +	}

These checks could be moved before finding the process, allowing a simple
return of the error code.  Unless we need to care if we get -EINVAL
over -ESRCH or -EPERM.

> +
> +	if (liovcnt > UIO_FASTIOV)
> +		iov_l = kmalloc(liovcnt*sizeof(struct iovec), GFP_KERNEL);
> +
> +	if (riovcnt > UIO_FASTIOV)
> +		iov_r = kmalloc(riovcnt*sizeof(struct iovec), GFP_KERNEL);
> +
> +	if (iov_l == NULL || iov_r == NULL) {
> +		rc = -ENOMEM;
> +		goto free_iovecs;
> +	}
> +
> +	rc = copy_from_user(iov_l, lvec, liovcnt*sizeof(*lvec));
> +	if (rc) {
> +		rc = -EFAULT;
> +		goto free_iovecs;
> +	}
> +	rc = copy_from_user(iov_r, rvec, riovcnt*sizeof(*lvec));
> +	if (rc) {
> +		rc = -EFAULT;
> +		goto free_iovecs;
> +	}
> +
> +	/* Work out how many pages of struct pages we're going to need
> +	   when eventually calling get_user_pages */

comment style

> +	for (i = 0; i < riovcnt; i++) {
> +		if (iov_r[i].iov_len > 0) {
> +			nr_pages_iov = ((unsigned long)iov_r[i].iov_base
> +					+ iov_r[i].iov_len) /
> +				PAGE_SIZE - (unsigned long)iov_r[i].iov_base
> +				/ PAGE_SIZE + 1;
> +			nr_pages = max(nr_pages, nr_pages_iov);
> +			iov_len_total += iov_r[i].iov_len;
> +			if (iov_len_total < 0) {
> +				rc = -EINVAL;
> +				goto free_iovecs;
> +			}
> +		}
> +	}
> +
> +	if (nr_pages == 0)
> +		goto free_iovecs;
> +
> +	/* For reliability don't try to kmalloc more than 2 pages worth */
> +	process_pages = kmalloc(min((size_t)PAGE_SIZE * 2,
> +				    sizeof(struct pages *) * nr_pages),

don't cast arguments to min, use min_t instead

PAGE_SIZE * 2 is somewhat magic and used across multiple functions,
plase define a derived constant, or better yet pass the size of the buffer
allocated.


> +				GFP_KERNEL);
> +
> +	if (!process_pages) {
> +		rc = -ENOMEM;
> +		goto free_iovecs;
> +	}


actually i would consider moveing the process and mm lookup to here, after
we validate the copy makes sense.

> +
> +	rc = 0;
> +	for (i = 0; i < riovcnt && iov_l_curr_idx < liovcnt; i++) {


If we require the source and destination vectors to be equal length
then we could replace this check with a simple i < riovcnt.

> +		bytes_copied = process_vm_rw(pid,
> +					     (unsigned long)iov_r[i].iov_base,
> +					     iov_r[i].iov_len,
> +					     iov_l, liovcnt,
> +					     &iov_l_curr_idx,
> +					     &iov_l_curr_offset,
> +					     process_pages, mm,

mm is passed down to lock the mm_sem per iteration ...

while this may help bound the latency, and it documents that the
mm semaphore is locked over the call, it also leads to more lock
activity ... but the final solution needs to deal with the ABBA
issue mentioned above.

> +					     task, flags, vm_write);
> +		if (bytes_copied < 0) {
> +			rc = bytes_copied;
> +			goto free_proc_pages;
> +		} else {
> +			rc += bytes_copied;
> +		}
> +	}
> +
> +
> +free_proc_pages:
> +	kfree(process_pages);
> +
> +free_iovecs:
> +	if (riovcnt > UIO_FASTIOV)
> +		kfree(iov_r);
> +	if (liovcnt > UIO_FASTIOV)
> +		kfree(iov_l);
> +
> +release_mm:
> +	mmput(mm);
> +
> +end:
> +	put_task_struct(task);
> +	return rc;
> +}
> +
> +
> +SYSCALL_DEFINE6(process_vm_readv, pid_t, pid, const struct iovec __user *, lvec,
> +		unsigned long, liovcnt, const struct iovec __user *, rvec,
> +		unsigned long, riovcnt,	unsigned long, flags)
> +{
> +	return process_vm_rw_v(pid, lvec, liovcnt, rvec, riovcnt, flags, 0);
> +}
> +
> +SYSCALL_DEFINE6(process_vm_writev, pid_t, pid,
> +		const struct iovec __user *, lvec,
> +		unsigned long, liovcnt, const struct iovec __user *, rvec,
> +		unsigned long, riovcnt,	unsigned long, flags)
> +{
> +	return process_vm_rw_v(pid, lvec, liovcnt, rvec, riovcnt, flags, 1);
> +}


You have a flags argument but don't check it anywhere.

Please check flags for any unsupported options.

Can we get by with one syscall by making one of the flags the direction?

> +
> +
> +
>  #ifdef CONFIG_PROVE_LOCKING
>  void might_fault(void)
>  {

milton
