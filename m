Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756167Ab2GATwE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 15:52:04 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:59002 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754671Ab2GATwC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 15:52:02 -0400
Message-ID: <1341172202.2556.13.camel@falcor>
Subject: Re: [PATCH 0/4] Was: deferring __fput()
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        ". James Morris" <jmorris@namei.org>,
        linux-security-module@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        David Howells <dhowells@redhat.com>
Date: Sun, 01 Jul 2012 15:50:02 -0400
In-Reply-To: <20120630050238.GZ14083@ZenIV.linux.org.uk>
References: <20120625060357.GT14083@ZenIV.linux.org.uk>
	 <20120625151812.GA16062@redhat.com> <20120627183721.GA23086@redhat.com>
	 <20120628043836.GW14083@ZenIV.linux.org.uk>
	 <1340947838.2293.2.camel@falcor>
	 <20120629083311.GX14083@ZenIV.linux.org.uk>
	 <1340974925.2309.13.camel@falcor>
	 <20120629174130.GY14083@ZenIV.linux.org.uk>
	 <1341005929.2194.9.camel@falcor.watson.ibm.com>
	 <1341014197.2342.7.camel@falcor.watson.ibm.com>
	 <20120630050238.GZ14083@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
x-cbid: 12070119-7606-0000-0000-000001A486AB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-06-30 at 06:02 +0100, Al Viro wrote:
> On Fri, Jun 29, 2012 at 07:56:37PM -0400, Mimi Zohar wrote:
> > Looking at /var/log/messages, seems like the ata4 and ata5 "SATA link
> > down (SStatus 0 SControl 300)" messages are normal.
> > 
> > ata5: SATA link down (SStatus 0 SControl 300)
> > Freeing unused kernel memory: 1016k freed
> > Write protecting the kernel read-only data: 12288k
> > Freeing unused kernel memory: 1964k freed
> > Freeing unused kernel memory: 1468k freed
> > Failed to execute /init
> > Kernel panic - not syncing. No init Found.  Try passing init= option ...
> > Pid: 1, comm: swapper/0 not tainted 3.5.0-rc1+
> > Call Trace:
> > 	panic
> > 	init_post
> > 	kernel_init
> > 	?do_early_param
> > 	kernel_thread_helper
> > 	start_kernel
> 
> Just to make sure - you are not getting IMA violations among all that?  

I'm not running with the IMA-appraisal patches, nor does the
Fedora .config enable IMA.  So I'm not getting violations.

> AFAICS,
> the damn thing should behave no worse in that respect than your own patch
> a while ago, and you haven't mentioned them in this thread, but...

I haven't mentioned the "ima: defer calling __fput()" patch, since I've
compiled git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git
#untested with a .config based on config-3.4.2-1.fc16.x86_64 and am
having this problem.  No need to add more confusion.  The "ima: defer
calling __fput()" will be dropped from the patchset, as soon as the
general method works.

I've isolated the problem to the PF_KTHREAD section of fput().

void fput(struct file *file)
{
        if (atomic_long_dec_and_test(&file->f_count)) {
                struct task_struct *task = current;
                file_sb_list_del(file);
                if (unlikely(in_interrupt() || task->flags & PF_KTHREAD)) {
                        unsigned long flags;
                        spin_lock_irqsave(&delayed_fput_lock, flags);
                        list_add(&file->f_u.fu_list, &delayed_fput_list);
                        schedule_work(&delayed_fput_work);
                        spin_unlock_irqrestore(&delayed_fput_lock, flags);
                        return;
                }
                init_task_work(&file->f_u.fu_rcuhead, ____fput);
                task_work_add(task, &file->f_u.fu_rcuhead, true);
        }
}

Replacing it with a call to __fput(), the system boots.

thanks,

Mimi

