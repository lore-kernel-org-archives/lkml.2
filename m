Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752430Ab2A2ALJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jan 2012 19:11:09 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:54606 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751980Ab2A2ALH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jan 2012 19:11:07 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: Re: [linux-pm] PM: cannot hibernate -- BUG at kernel/workqueue.c:3659
Date: Sun, 29 Jan 2012 01:14:41 +0100
User-Agent: KMail/1.13.6 (Linux/3.3.0-rc1+; KDE/4.6.0; x86_64; ; )
Cc: Jiri Slaby <jirislaby@gmail.com>, Tejun Heo <tj@kernel.org>,
        Jiri Slaby <jslaby@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        Baohua.Song@csr.com, "pavel@ucw.cz" <pavel@ucw.cz>,
        Linux PM mailing list <linux-pm@vger.kernel.org>
References: <4F1EC8D5.5040102@suse.cz> <201201272344.04086.rjw@sisk.pl> <4F241710.9040205@linux.vnet.ibm.com>
In-Reply-To: <4F241710.9040205@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201201290114.42174.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, January 28, 2012, Srivatsa S. Bhat wrote:
> On 01/28/2012 04:14 AM, Rafael J. Wysocki wrote:
> 
> >> Rafael, thanks for the clarification in the other mail.
> >>
> >> Acked-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> >>
> >> I think we need to get this into 3.2-stable as well, as Jiri mentioned.
> > 
> > Yes, we do.
> > 
> > Below it goes again with the missing comment in user.c and a changelog.
> > 
> > Please let me know if there's anything wrong with it, otherwise I'm going
> > to push it to Linus in a couple of days.
> > 
> > Thanks,
> > Rafael
> > 
> > ---
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > Subject: PM / Hibernate: Fix s2disk regression related to freezing workqueues
> > 
> > Commit 2aede851ddf08666f68ffc17be446420e9d2a056
> > 
> >   PM / Hibernate: Freeze kernel threads after preallocating memory
> > 
> > introduced a mechanism by which kernel threads were frozen after
> > the preallocation of hibernate image memory to avoid problems with
> > frozen kernel threads not responding to memory freeing requests.
> > However, it overlooked the s2disk code path in which the
> > SNAPSHOT_CREATE_IMAGE ioctl was run directly after SNAPSHOT_FREE,
> > which caused freeze_workqueues_begin() to BUG(), because it saw
> > that worqueues had been already frozen.
> > 
> > Although in principle this issue might be addressed by removing
> > the relevant BUG_ON() from freeze_workqueues_begin(), that would
> > reintroduce the very problem that commit 2aede851ddf08666f68ffc17be4
> > attempted to avoid into that particular code path.  For this reason,
> > to fix the issue at hand, introduce thaw_kernel_threads() and make
> > the SNAPSHOT_FREE ioctl execute it.
> > 
> > Special thanks to Srivatsa S. Bhat for detailed analysis of the
> > problem.
> > 
> > Reported-and-tested-by: Jiri Slaby <jslaby@suse.cz>
> > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> > Acked-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> 
> 
> Cc: stable@vger.kernel.org ?

That's going to show up in the actual commit.

> Other than that, the patch is perfect!

Cool, thanks!

Rafael


> > ---
> >  include/linux/freezer.h |    2 ++
> >  kernel/power/process.c  |   19 +++++++++++++++++++
> >  kernel/power/user.c     |    9 +++++++++
> >  3 files changed, 30 insertions(+)
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
> > @@ -274,6 +274,15 @@ static long snapshot_ioctl(struct file *
> >  		swsusp_free();
> >  		memset(&data->handle, 0, sizeof(struct snapshot_handle));
> >  		data->ready = 0;
> > +		/*
> > +		 * It is necessary to thaw kernel threads here, because
> > +		 * SNAPSHOT_CREATE_IMAGE may be invoked directly after
> > +		 * SNAPSHOT_FREE.  In that case, if kernel threads were not
> > +		 * thawed, the preallocation of memory carried out by
> > +		 * hibernation_snapshot() might run into problems (i.e. it
> > +		 * might fail or even deadlock).
> > +		 */
> > +		thaw_kernel_threads();
> >  		break;
> > 
> >  	case SNAPSHOT_PREF_IMAGE_SIZE:
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

