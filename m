Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752445Ab2AYXsO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 18:48:14 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:50457 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751345Ab2AYXsM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 18:48:12 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Jiri Slaby <jirislaby@gmail.com>, Tejun Heo <tj@kernel.org>
Subject: Re: [linux-pm] PM: cannot hibernate -- BUG 
 =?iso-8859-1?q?at=09kernel/workqueue=2Ec=3A3659?=
Date: Thu, 26 Jan 2012 00:51:44 +0100
User-Agent: KMail/1.13.6 (Linux/3.3.0-rc1+; KDE/4.6.0; x86_64; ; )
Cc: Jiri Slaby <jslaby@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        Baohua.Song@csr.com, "pavel@ucw.cz" <pavel@ucw.cz>,
        Linux PM mailing list <linux-pm@vger.kernel.org>
References: <4F1EC8D5.5040102@suse.cz> <4F202721.6050900@linux.vnet.ibm.com> <4F204D90.7010105@linux.vnet.ibm.com>
In-Reply-To: <4F204D90.7010105@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201201260051.45000.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wednesday, January 25, 2012, Srivatsa S. Bhat wrote:
> > 
> 
> > Commit 2aede851 (PM / Hibernate: Freeze kernel threads after preallocating
> > memory) split up the freezing phase and moved the freezing of kernel threads
> > to hibernation_snapshot() function.
> > (This is a pretty old commit btw, I think it came in sometime around 3.2).
> > 
> > And there is a BUG_ON() in freeze_workqueues_begin() which complains if
> > this function is called when the kernel threads are already frozen.
> > 
> > Now, coming to the userspace utility:
> > 
> >> In suspend.c inside the suspend-utils userspace package, I see a loop such
> >> as:
> >>
> >>         error = freeze(snapshot_fd);
> >> 	...
> >>         attempts = 2;
> >>         do {
> >>                 if (set_image_size(snapshot_fd, image_size)) {
> >>                         error = errno;
> >>                         break;
> >>                 }
> >>                 if (atomic_snapshot(snapshot_fd, &in_suspend)) {
> >                         ^^^ 
> >         This ends up in the call to hibernation_snapshot().
> > 
> >>                         error = errno;
> >>                         break;
> >>                 }
> >>                 if (!in_suspend) {
> >>                         /* first unblank the console, see console_codes(4) */
> >>                         printf("\e[13]");
> >>                         printf("%s: returned to userspace\n", my_name);
> >>                         free_snapshot(snapshot_fd);
> >>                         break;
> >>                 }
> >>
> >>                 error = write_image(snapshot_fd, resume_fd, -1);
> >>                 if (error) {
> > 
> >         Since swap space is limited, we come here.
> > 
> >>                         free_swap_pages(snapshot_fd);
> >>                         free_snapshot(snapshot_fd);
> 
> 				^^^
> 	This function makes the ioctl call SNAPSHOT_FREE.
> 
> >>                         image_size = 0;
> >>                         error = -error;
> >>                         if (error != ENOSPC)
> >>                                 break;
> > 
> > 
> > 
> > 
> >         And because of the above 'if' condition, we don't break here.
> >         IOW, we will run the loop a second time.
> > 
> >>                 } else {
> >>                         splash.progress(100);
> >> #ifdef CONFIG_BOTH
> >>                         if (s2ram_kms || s2ram) {
> >>                                 /* If we die (and allow system to continue)
> >>                                  * between now and reset_signature(), very bad
> >>                                  * things will happen. */
> >>                                 error = suspend_to_ram(snapshot_fd);
> >>                                 if (error)
> >>                                         goto Shutdown;
> >>                                 reset_signature(resume_fd);
> >>                                 free_swap_pages(snapshot_fd);
> >>                                 free_snapshot(snapshot_fd);
> >>                                 if (!s2ram_kms)
> >>                                         s2ram_resume();
> >>                                 goto Unfreeze;
> >>                         }
> >> Shutdown:
> >> #endif
> >>                         close(resume_fd);
> >>                         suspend_shutdown(snapshot_fd);
> >>                 }
> >>         } while (--attempts);
> >>
> >> ...
> >> Unfreeze:
> >>         unfreeze(snapshot_fd);
> >>
> >>
> > 
> > 
> > So, since the loop is run a second time if not enough space was available,
> > we end up calling hibernation_snapshot(), IOW freeze_workqueues_begin() a
> > second time - and this is what makes the BUG_ON() to fire!
> > 
> 
> 
> SNAPSHOT_CREATE_IMAGE has a check for data->ready such as:
> 
>         if (data->mode != O_RDONLY || !data->frozen  || data->ready) {
>                 error = -EPERM;
>                 break;
>         }
> 
> data->ready would be set to 1 only under SNAPSHOT_CREATE_IMAGE. However,
> SNAPSHOT_FREE (invoked at the place shown above) will reset the value to 0.
> This makes it possible for hibernation_snapshot() and hence
> freeze_workqueues_begin() to be called a second time, which is unfortunate.

Yes, I obviously forgot about that code path when I was working on the commit
that introduced the problem. :-(

Thanks a lot for the great analysis, it's really helpful!

> And actually, the patch I posted in my previous mail is not really the right
> long-term fix, though it might fix the particular issue that Jiri is facing..
> 
> Because, allowing hibernation_snapshot() to get called a second time while
> kernel threads are still frozen brings us to the same situation that commit
> 2aede851 (PM / Hibernate: Freeze kernel threads after preallocating memory)
> tried to prevent! IOW, a call to hibernate_preallocate_memory() would be
> done inside hibernation_snapshot(), when kernel threads are frozen.. which
> is known to break XFS, to give one example as mentioned in the changelog
> of the above commit.

That's exactly right.

> So, the right way to fix this IMHO, would be to split up thaw_processes()
> just like freezing phase:
> 
> /* freezes or thaws user space processes */
> freeze_processes() - thaw_processes()
> 
> /* freezes or thaws kernel threads */
> freeze_kernel_threads() - thaw_kernel_threads()
> 
> We have to insert this thaw_kernel_threads() at appropriate places in such a
> way as to not require another ioctl if possible... Then things would be
> more symmetric (and hence more easy to understand) and we can avoid getting
> into strange situations as discussed here.
> 
> But before we venture into that, it would be good to know if the patch posted
> in the previous mail fixes the particular problem reported in this thread,
> atleast just to see if there are other problems lurking that we aren't aware
> of yet..

Jiri has already said that the patch works.

I think we could avoid the issue entirely by introducing thaw_kernel_threads
and making SNAPSHOT_FREE call it.  No other changes should be necessary.

IOW, Jiri, does the patch below help?

[BTW, the freeze_tasks()'s kerneldoc seems to be outdated.  Tejun?]

---
 include/linux/freezer.h |    2 ++
 kernel/power/process.c  |   19 +++++++++++++++++++
 kernel/power/user.c     |    1 +
 3 files changed, 22 insertions(+)

Index: linux/include/linux/freezer.h
===================================================================
--- linux.orig/include/linux/freezer.h
+++ linux/include/linux/freezer.h
@@ -39,6 +39,7 @@ extern bool __refrigerator(bool check_kt
 extern int freeze_processes(void);
 extern int freeze_kernel_threads(void);
 extern void thaw_processes(void);
+extern void thaw_kernel_threads(void);
 
 static inline bool try_to_freeze(void)
 {
@@ -174,6 +175,7 @@ static inline bool __refrigerator(bool c
 static inline int freeze_processes(void) { return -ENOSYS; }
 static inline int freeze_kernel_threads(void) { return -ENOSYS; }
 static inline void thaw_processes(void) {}
+static inline void thaw_kernel_threads(void) {}
 
 static inline bool try_to_freeze(void) { return false; }
 
Index: linux/kernel/power/process.c
===================================================================
--- linux.orig/kernel/power/process.c
+++ linux/kernel/power/process.c
@@ -188,3 +188,22 @@ void thaw_processes(void)
 	printk("done.\n");
 }
 
+void thaw_kernel_threads(void)
+{
+	struct task_struct *g, *p;
+
+	pm_nosig_freezing = false;
+	printk("Restarting kernel threads ... ");
+
+	thaw_workqueues();
+
+	read_lock(&tasklist_lock);
+	do_each_thread(g, p) {
+		if (p->flags & (PF_KTHREAD | PF_WQ_WORKER))
+			__thaw_task(p);
+	} while_each_thread(g, p);
+	read_unlock(&tasklist_lock);
+
+	schedule();
+	printk("done.\n");
+}
Index: linux/kernel/power/user.c
===================================================================
--- linux.orig/kernel/power/user.c
+++ linux/kernel/power/user.c
@@ -274,6 +274,7 @@ static long snapshot_ioctl(struct file *
 		swsusp_free();
 		memset(&data->handle, 0, sizeof(struct snapshot_handle));
 		data->ready = 0;
+		thaw_kernel_threads();
 		break;
 
 	case SNAPSHOT_PREF_IMAGE_SIZE:
