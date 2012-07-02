Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751476Ab2GBLup (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 07:50:45 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:39430 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886Ab2GBLuo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 07:50:44 -0400
Message-ID: <1341229790.2350.1.camel@falcor>
Subject: Re: [PATCH 0/4] Was: deferring __fput()
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        ". James Morris" <jmorris@namei.org>,
        linux-security-module@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        David Howells <dhowells@redhat.com>
Date: Mon, 02 Jul 2012 07:49:50 -0400
In-Reply-To: <20120702051155.GF22927@ZenIV.linux.org.uk>
References: <20120629083311.GX14083@ZenIV.linux.org.uk>
	 <1340974925.2309.13.camel@falcor>
	 <20120629174130.GY14083@ZenIV.linux.org.uk>
	 <1341005929.2194.9.camel@falcor.watson.ibm.com>
	 <1341014197.2342.7.camel@falcor.watson.ibm.com>
	 <20120630050238.GZ14083@ZenIV.linux.org.uk>
	 <1341172202.2556.13.camel@falcor>
	 <20120701205722.GD22927@ZenIV.linux.org.uk>
	 <1341193591.2249.3.camel@falcor>
	 <20120702034310.GE22927@ZenIV.linux.org.uk>
	 <20120702051155.GF22927@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
x-cbid: 12070211-7606-0000-0000-000001A79350
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-07-02 at 06:11 +0100, Al Viro wrote:
> On Mon, Jul 02, 2012 at 04:43:10AM +0100, Al Viro wrote:
> > On Sun, Jul 01, 2012 at 09:46:31PM -0400, Mimi Zohar wrote:
> > > On Sun, 2012-07-01 at 21:57 +0100, Al Viro wrote:
> > > > On Sun, Jul 01, 2012 at 03:50:02PM -0400, Mimi Zohar wrote:
> > > > > Replacing it with a call to __fput(), the system boots.
> > > > 
> > > > "it" being just the part under that if (unlikely(...)))?  Very interesting...  If so, we
> > > > have some kernel thread ending up with delayed __fput() which somehow makes dracut (assuimg
> > > > you are using fedora initramfs to go with fedora config) unhappy.  With your own patch,
> > > > doing async __fput() in a lot of cases when this one doesn't delay past the return to
> > > > userland managing to survive the boot...  I wonder which files end up triggering that fun
> > > > and which kernel thread is responsible...  Could you slap a printk() in there, showing
> > > > file->f_dentry->d_inode->i_mode (octal) and at least file->f_dentry->d_name.name?
> > > > Along with the current->comm[], all under that inner if ().  And see which ones end up
> > > > going that way by the time execve() of /sbin/init fails.
> > > 
> > > pid=1 uid=0 d_name=init comm=swapper/0 dev="rootfs" mode=100775
> > > pid=1 uid=0 d_name=bash comm=swapper/0 dev="rootfs" mode=100755
> > 
> > OK...  Here's what I suspect is going on:
> > 	* populating initramfs writes binaries there.  We open files (for write) from
> > the kernel thread (there's nothing other than kernel threads at that point), write to
> > them, then close().  Final fput() gets delayed.
> > 	* Then we proceed to execve().  Which means mapping the binary with MAP_DENYWRITE.
> > Which fails, since there's a struct file still opened for write on that sucker.
> > 
> > Your patch did not delay those fput() - they were done without ->mmap_sem held.  So
> > it survived.  Booting without initramfs always survives; booting with initramfs may
> > or may not survive, depending on the timings - if that scheduled work manages to
> > run by the time we do those execve(), we win.  Note that async_synchronize_full()
> > done in init_post() might easily affect that, depending on config.
> > 
> > As a quick test, could you try slapping a delay somewhere around the beginning
> > of init_post() and see if it rescues the system?
> 
> Ho-hum...  How about this (modulo missing documentation of the whole sad mess):

Sorry, neither adding the delay or this patch helped.

> diff --git a/fs/file_table.c b/fs/file_table.c
> index 470da0b..00fd849 100644
> --- a/fs/file_table.c
> +++ b/fs/file_table.c
> @@ -284,6 +284,11 @@ static void ____fput(struct callback_head *work)
>  	__fput(container_of(work, struct file, f_u.fu_rcuhead));
>  }
> 
> +void flush_delayed_fput(void)
> +{
> +	delayed_fput(NULL);
> +}
> +
>  static DECLARE_WORK(delayed_fput_work, delayed_fput);
> 
>  void fput(struct file *file)
> diff --git a/include/linux/file.h b/include/linux/file.h
> index 58bf158..d9a4f5a 100644
> --- a/include/linux/file.h
> +++ b/include/linux/file.h
> @@ -39,4 +39,6 @@ extern void put_unused_fd(unsigned int fd);
> 
>  extern void fd_install(unsigned int fd, struct file *file);
> 
> +extern void flush_delayed_fput(void);
> +
>  #endif /* __LINUX_FILE_H */
> diff --git a/init/main.c b/init/main.c
> index b5cc0a7..3f151f6 100644
> --- a/init/main.c
> +++ b/init/main.c
> @@ -68,6 +68,7 @@
>  #include <linux/shmem_fs.h>
>  #include <linux/slab.h>
>  #include <linux/perf_event.h>
> +#include <linux/file.h>
> 
>  #include <asm/io.h>
>  #include <asm/bugs.h>
> @@ -804,8 +805,8 @@ static noinline int init_post(void)
>  	system_state = SYSTEM_RUNNING;
>  	numa_default_policy();
> 
> -
>  	current->signal->flags |= SIGNAL_UNKILLABLE;
> +	flush_delayed_fput();
> 
>  	if (ramdisk_execute_command) {
>  		run_init_process(ramdisk_execute_command);


