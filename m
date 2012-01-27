Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754639Ab2A0A6W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 19:58:22 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:52123 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751353Ab2A0A6U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 19:58:20 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jiri Slaby <jslaby@suse.cz>
Subject: Re: [linux-pm] PM: cannot hibernate -- BUG at kernel/workqueue.c:3659
Date: Fri, 27 Jan 2012 02:01:55 +0100
User-Agent: KMail/1.13.6 (Linux/3.3.0-rc1+; KDE/4.6.0; x86_64; ; )
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Jiri Slaby <jirislaby@gmail.com>, Tejun Heo <tj@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Baohua.Song@csr.com,
        "pavel@ucw.cz" <pavel@ucw.cz>,
        Linux PM mailing list <linux-pm@vger.kernel.org>
References: <4F1EC8D5.5040102@suse.cz> <201201260051.45000.rjw@sisk.pl> <4F213392.2090203@suse.cz>
In-Reply-To: <4F213392.2090203@suse.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201201270201.55771.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, January 26, 2012, Jiri Slaby wrote:
> On 01/26/2012 12:51 AM, Rafael J. Wysocki wrote:
> > IOW, Jiri, does the patch below help?
> 
> Yeah, this fixes the issue as well. Thanks.

Cool, thanks for the confirmation!

> > [BTW, the freeze_tasks()'s kerneldoc seems to be outdated.  Tejun?]
> > 
> > ---
> >  include/linux/freezer.h |    2 ++
> >  kernel/power/process.c  |   19 +++++++++++++++++++
> >  kernel/power/user.c     |    1 +
> >  3 files changed, 22 insertions(+)
> > 
> > Index: linux/include/linux/freezer.h
> > ===================================================================
> > --- linux.orig/include/linux/freezer.h
> > +++ linux/include/linux/freezer.h
> > @@ -39,6 +39,7 @@ extern bool __refrigerator(bool check_kt
> >  extern int freeze_processes(void);
> >  extern int freeze_kernel_threads(void);
> >  extern void thaw_processes(void);
> > +extern void thaw_kernel_threads(void);
> >  
> >  static inline bool try_to_freeze(void)
> >  {
> > @@ -174,6 +175,7 @@ static inline bool __refrigerator(bool c
> >  static inline int freeze_processes(void) { return -ENOSYS; }
> >  static inline int freeze_kernel_threads(void) { return -ENOSYS; }
> >  static inline void thaw_processes(void) {}
> > +static inline void thaw_kernel_threads(void) {}
> >  
> >  static inline bool try_to_freeze(void) { return false; }
> >  
> > Index: linux/kernel/power/process.c
> > ===================================================================
> > --- linux.orig/kernel/power/process.c
> > +++ linux/kernel/power/process.c
> > @@ -188,3 +188,22 @@ void thaw_processes(void)
> >  	printk("done.\n");
> >  }
> >  
> > +void thaw_kernel_threads(void)
> > +{
> > +	struct task_struct *g, *p;
> > +
> > +	pm_nosig_freezing = false;
> > +	printk("Restarting kernel threads ... ");
> > +
> > +	thaw_workqueues();
> > +
> > +	read_lock(&tasklist_lock);
> > +	do_each_thread(g, p) {
> > +		if (p->flags & (PF_KTHREAD | PF_WQ_WORKER))
> > +			__thaw_task(p);
> > +	} while_each_thread(g, p);
> > +	read_unlock(&tasklist_lock);
> > +
> > +	schedule();
> > +	printk("done.\n");
> > +}
> > Index: linux/kernel/power/user.c
> > ===================================================================
> > --- linux.orig/kernel/power/user.c
> > +++ linux/kernel/power/user.c
> > @@ -274,6 +274,7 @@ static long snapshot_ioctl(struct file *
> >  		swsusp_free();
> >  		memset(&data->handle, 0, sizeof(struct snapshot_handle));
> >  		data->ready = 0;
> > +		thaw_kernel_threads();
> >  		break;
> >  
> >  	case SNAPSHOT_PREF_IMAGE_SIZE:
> 
> 
> 

