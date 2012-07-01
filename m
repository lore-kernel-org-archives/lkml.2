Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752479Ab2GAU5c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 16:57:32 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:59333 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751327Ab2GAU5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 16:57:31 -0400
Date: Sun, 1 Jul 2012 21:57:22 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        ". James Morris" <jmorris@namei.org>,
        linux-security-module@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 0/4] Was: deferring __fput()
Message-ID: <20120701205722.GD22927@ZenIV.linux.org.uk>
References: <20120627183721.GA23086@redhat.com>
 <20120628043836.GW14083@ZenIV.linux.org.uk>
 <1340947838.2293.2.camel@falcor>
 <20120629083311.GX14083@ZenIV.linux.org.uk>
 <1340974925.2309.13.camel@falcor>
 <20120629174130.GY14083@ZenIV.linux.org.uk>
 <1341005929.2194.9.camel@falcor.watson.ibm.com>
 <1341014197.2342.7.camel@falcor.watson.ibm.com>
 <20120630050238.GZ14083@ZenIV.linux.org.uk>
 <1341172202.2556.13.camel@falcor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341172202.2556.13.camel@falcor>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 01, 2012 at 03:50:02PM -0400, Mimi Zohar wrote:
> 
> I haven't mentioned the "ima: defer calling __fput()" patch, since I've
> compiled git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git
> #untested with a .config based on config-3.4.2-1.fc16.x86_64 and am
> having this problem.  No need to add more confusion.  The "ima: defer
> calling __fput()" will be dropped from the patchset, as soon as the
> general method works.
> 
> I've isolated the problem to the PF_KTHREAD section of fput().
> 
> void fput(struct file *file)
> {
>         if (atomic_long_dec_and_test(&file->f_count)) {
>                 struct task_struct *task = current;
>                 file_sb_list_del(file);
>                 if (unlikely(in_interrupt() || task->flags & PF_KTHREAD)) {
>                         unsigned long flags;
>                         spin_lock_irqsave(&delayed_fput_lock, flags);
>                         list_add(&file->f_u.fu_list, &delayed_fput_list);
>                         schedule_work(&delayed_fput_work);
>                         spin_unlock_irqrestore(&delayed_fput_lock, flags);
>                         return;
>                 }
>                 init_task_work(&file->f_u.fu_rcuhead, ____fput);
>                 task_work_add(task, &file->f_u.fu_rcuhead, true);
>         }
> }
> 
> Replacing it with a call to __fput(), the system boots.

"it" being just the part under that if (unlikely(...)))?  Very interesting...  If so, we
have some kernel thread ending up with delayed __fput() which somehow makes dracut (assuimg
you are using fedora initramfs to go with fedora config) unhappy.  With your own patch,
doing async __fput() in a lot of cases when this one doesn't delay past the return to
userland managing to survive the boot...  I wonder which files end up triggering that fun
and which kernel thread is responsible...  Could you slap a printk() in there, showing
file->f_dentry->d_inode->i_mode (octal) and at least file->f_dentry->d_name.name?
Along with the current->comm[], all under that inner if ().  And see which ones end up
going that way by the time execve() of /sbin/init fails.

It would be nice to see which sys_mount() calls are made and which (if any) fail, BTW.
I wonder if it even gets to mounting the right root...
