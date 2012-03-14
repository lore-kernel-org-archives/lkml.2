Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755819Ab2CND6v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 23:58:51 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:48027 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752224Ab2CND6t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 23:58:49 -0400
MIME-Version: 1.0
In-Reply-To: <20120313131616.f66dbdad.akpm@linux-foundation.org>
References: <4F57A3EC.7070101@gmail.com>
	<1331660076-32766-1-git-send-email-siddhesh.poyarekar@gmail.com>
	<20120313131616.f66dbdad.akpm@linux-foundation.org>
Date: Wed, 14 Mar 2012 09:28:47 +0530
Message-ID: <CAAHN_R2y6_y7ukzHAGmLxarmY_f=S3TBpt2VDRb=wbmb4TE63w@mail.gmail.com>
Subject: Re: [PATCH] -mm/linux-next: procfs: Mark thread stack correctly in proc/<pid>/maps
From: Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-next <linux-next@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Jamie Lokier <jamie@shareable.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Matt Mackall <mpm@selenic.com>, Mike Frysinger <vapier@gentoo.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Mark Salter <msalter@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 14, 2012 at 1:46 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> Boy, that's a lot of changes (below).  What does it all do?
>
> Why did the sched.h inclusions get taken out again?
>

Most of it is code shuffling in addition to the feature change I
mentioned earlier. I've elaborated on the changes inline.

> diff -puN Documentation/filesystems/proc.txt~procfs-mark-thread-stack-correctly-in-proc-pid-maps-v3 Documentation/filesystems/proc.txt
> --- a/Documentation/filesystems/proc.txt~procfs-mark-thread-stack-correctly-in-proc-pid-maps-v3
> +++ a/Documentation/filesystems/proc.txt
<snip>
>
>  The /proc/PID/task/TID/maps is a view of the virtual memory from the viewpoint
>  of the individual tasks of a process. In this file you will see a mapping marked
> -as [stack:TID] only if that task sees it as a stack. This is a key difference
> -from the content of /proc/PID/maps, where you will see all mappings that are
> -being used as stack by all of those tasks.
> +as [stack] if that task sees it as a stack. This is a key difference from the
> +content of /proc/PID/maps, where you will see all mappings that are being used
> +as stack by all of those tasks. Hence, for the example above, the task-level
> +map, i.e. /proc/PID/task/TID/maps for thread 1001 will look like this:
> +
> +08048000-08049000 r-xp 00000000 03:00 8312       /opt/test
> +08049000-0804a000 rw-p 00001000 03:00 8312       /opt/test
> +0804a000-0806b000 rw-p 00000000 00:00 0          [heap]
> +a7cb1000-a7cb2000 ---p 00000000 00:00 0
> +a7cb2000-a7eb2000 rw-p 00000000 00:00 0
> +a7eb2000-a7eb3000 ---p 00000000 00:00 0
> +a7eb3000-a7ed5000 rw-p 00000000 00:00 0          [stack]
> +a7ed5000-a8008000 r-xp 00000000 03:00 4222       /lib/libc.so.6
> +a8008000-a800a000 r--p 00133000 03:00 4222       /lib/libc.so.6
> +a800a000-a800b000 rw-p 00135000 03:00 4222       /lib/libc.so.6
> +a800b000-a800e000 rw-p 00000000 00:00 0
> +a800e000-a8022000 r-xp 00000000 03:00 14462      /lib/libpthread.so.0
> +a8022000-a8023000 r--p 00013000 03:00 14462      /lib/libpthread.so.0
> +a8023000-a8024000 rw-p 00014000 03:00 14462      /lib/libpthread.so.0
> +a8024000-a8027000 rw-p 00000000 00:00 0
> +a8027000-a8043000 r-xp 00000000 03:00 8317       /lib/ld-linux.so.2
> +a8043000-a8044000 r--p 0001b000 03:00 8317       /lib/ld-linux.so.2
> +a8044000-a8045000 rw-p 0001c000 03:00 8317       /lib/ld-linux.so.2
> +aff35000-aff4a000 rw-p 00000000 00:00 0
> +ffffe000-fffff000 r-xp 00000000 00:00 0          [vdso]

I extended the documentation a bit to give an example of how
/proc/PID/task/TID/maps would look like. This reflects the feature
change that KOSAKI-san requested (keeping process stack as [stack] in
/proc/PID/maps).

> --- a/fs/proc/task_mmu.c~procfs-mark-thread-stack-correctly-in-proc-pid-maps-v3
> +++ a/fs/proc/task_mmu.c
> @@ -222,7 +222,7 @@ show_map_vma(struct seq_file *m, struct
>        unsigned long start, end;
>        dev_t dev = 0;
>        int len;
> -       const char *name;
> +       const char *name = NULL;
>
>        if (file) {
>                struct inode *inode = vma->vm_file->f_path.dentry->d_inode;
> @@ -256,33 +256,47 @@ show_map_vma(struct seq_file *m, struct
>        if (file) {
>                pad_len_spaces(m, len);
>                seq_path(m, &file->f_path, "\n");
> -               goto out;
> +               goto done;
>        }
>
>        name = arch_vma_name(vma);
>        if (!name) {
> -               if (mm) {
> -                       if (vma->vm_start <= mm->brk &&
> -                                       vma->vm_end >= mm->start_brk) {
> -                               name = "[heap]";
> -                       } else {
> -                               pid_t tid;
> +               pid_t tid;
>
> -                               tid = vm_is_stack(task, vma, is_pid);
> -                               if (tid != 0) {
> -                                       pad_len_spaces(m, len);
> -                                       seq_printf(m, "[stack:%d]", tid);
> -                               }
> -                       }
> -               } else {
> +               if (!mm) {
>                        name = "[vdso]";
> +                       goto done;
> +               }
> +
> +               if (vma->vm_start <= mm->brk &&
> +                   vma->vm_end >= mm->start_brk) {
> +                       name = "[heap]";
> +                       goto done;
> +               }
> +
> +               tid = vm_is_stack(task, vma, is_pid);
> +
> +               if (tid !=0) {
> +                       /*
> +                        * Thread stack in /proc/PID/task/TID/maps or
> +                        * the main process stack.
> +                        */
> +                       if (!is_pid || (vma->vm_start <= mm->start_stack &&
> +                           vma->vm_end >= mm->start_stack)) {
> +                               name = "[stack]";
> +                       } else {
> +                               /* Thread stack in /proc/PID/maps */
> +                               pad_len_spaces(m, len);
> +                               seq_printf(m, "[stack:%d]", tid);
> +                       }
>                }
>        }
> +
> +done:
>        if (name) {
>                pad_len_spaces(m, len);
>                seq_puts(m, name);
>        }
> -out:
>        seq_putc(m, '\n');
>  }
>
> @@ -1134,8 +1148,17 @@ static int show_numa_map(struct seq_file
>                seq_printf(m, " heap");
>        } else {
>                pid_t tid = vm_is_stack(proc_priv->task, vma, is_pid);
> -               if (tid != 0)
> -                       seq_printf(m, " stack:%d", tid);
> +               if (tid !=0) {
> +                       /*
> +                        * Thread stack in /proc/PID/task/TID/maps or
> +                        * the main process stack.
> +                        */
> +                       if (!is_pid || (vma->vm_start <= mm->start_stack &&
> +                           vma->vm_end >= mm->start_stack))
> +                               seq_printf(m, " stack");
> +                       else
> +                               seq_printf(m, " stack:%d", tid);
> +               }
>        }

The request to keep process stack marked as [stack] meant an
additional nested condition, so I cleaned up the code like you had
suggested earlier.

> diff -puN mm/util.c~procfs-mark-thread-stack-correctly-in-proc-pid-maps-v3 mm/util.c
> --- a/mm/util.c~procfs-mark-thread-stack-correctly-in-proc-pid-maps-v3
> +++ a/mm/util.c
> @@ -239,6 +239,47 @@ void __vma_link_list(struct mm_struct *m
>                next->vm_prev = vma;
>  }
>
> +/* Check if the vma is being used as a stack by this task */
> +static int vm_is_stack_for_task(struct task_struct *t,
> +                               struct vm_area_struct *vma)
> +{
> +       return (vma->vm_start <= KSTK_ESP(t) && vma->vm_end >= KSTK_ESP(t));
> +}
> +
> +/*
> + * Check if the vma is being used as a stack.
> + * If is_group is non-zero, check in the entire thread group or else
> + * just check in the current task. Returns the pid of the task that
> + * the vma is stack for.
> + */
> +pid_t vm_is_stack(struct task_struct *task,
> +                 struct vm_area_struct *vma, int in_group)
> +{
> +       pid_t ret = 0;
> +
> +       if (vm_is_stack_for_task(task, vma))
> +               return task->pid;
> +
> +       if (in_group) {
> +               struct task_struct *t;
> +               rcu_read_lock();
> +               if (!pid_alive(task))
> +                       goto done;
> +
> +               t = task;
> +               do {
> +                       if (vm_is_stack_for_task(t, vma)) {
> +                               ret = t->pid;
> +                               goto done;
> +                       }
> +               } while_each_thread(task, t);
> +done:
> +               rcu_read_unlock();
> +       }
> +
> +       return ret;
> +}
> +
>  #if defined(CONFIG_MMU) && !defined(HAVE_ARCH_PICK_MMAP_LAYOUT)
>  void arch_pick_mmap_layout(struct mm_struct *mm)
>  {
> _
>

I had duplicated the vm_is_stack functions for mmu and nommu in
memory.c and nommu.c, which I unified and moved to util.c (above),
which is built in both mmu and nommu and also seemed like a good
enough place for it since it is a utility function. util.c already
includes sched.h, which is why the sched.h inclusions are not needed
anymore.

I forgot to mention how I have tested this:

* Build and functionality test on x86_64
* Build test for i386
* Build test for nommu with a bit of a hack; removing mmu code in x86
and building it as if it were nommu.

-- 
Siddhesh Poyarekar
http://siddhesh.in
