Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753638Ab2A0KEl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 05:04:41 -0500
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:33432 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752633Ab2A0KEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 05:04:39 -0500
Message-ID: <4F2276AE.7010509@linux.vnet.ibm.com>
Date: Fri, 27 Jan 2012 15:34:30 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Jiri Slaby <jirislaby@gmail.com>, Tejun Heo <tj@kernel.org>,
        Jiri Slaby <jslaby@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        Baohua.Song@csr.com, "pavel@ucw.cz" <pavel@ucw.cz>,
        Linux PM mailing list <linux-pm@vger.kernel.org>
Subject: Re: [linux-pm] PM: cannot hibernate -- BUG at kernel/workqueue.c:3659
References: <4F1EC8D5.5040102@suse.cz> <4F202721.6050900@linux.vnet.ibm.com> <4F204D90.7010105@linux.vnet.ibm.com> <201201260051.45000.rjw@sisk.pl>
In-Reply-To: <201201260051.45000.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12012700-0260-0000-0000-00000073B18D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/26/2012 05:21 AM, Rafael J. Wysocki wrote:

> Jiri has already said that the patch works.
> 
> I think we could avoid the issue entirely by introducing thaw_kernel_threads
> and making SNAPSHOT_FREE call it.  No other changes should be necessary.
> 
> IOW, Jiri, does the patch below help?
> 
> [BTW, the freeze_tasks()'s kerneldoc seems to be outdated.  Tejun?]
> 
> ---


Rafael, thanks for the clarification in the other mail.

Acked-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

I think we need to get this into 3.2-stable as well, as Jiri mentioned.

Regards,
Srivatsa S. Bhat

>  include/linux/freezer.h |    2 ++
>  kernel/power/process.c  |   19 +++++++++++++++++++
>  kernel/power/user.c     |    1 +
>  3 files changed, 22 insertions(+)
> 
> Index: linux/include/linux/freezer.h
> ===================================================================
> --- linux.orig/include/linux/freezer.h
> +++ linux/include/linux/freezer.h
> @@ -39,6 +39,7 @@ extern bool __refrigerator(bool check_kt
>  extern int freeze_processes(void);
>  extern int freeze_kernel_threads(void);
>  extern void thaw_processes(void);
> +extern void thaw_kernel_threads(void);
> 
>  static inline bool try_to_freeze(void)
>  {
> @@ -174,6 +175,7 @@ static inline bool __refrigerator(bool c
>  static inline int freeze_processes(void) { return -ENOSYS; }
>  static inline int freeze_kernel_threads(void) { return -ENOSYS; }
>  static inline void thaw_processes(void) {}
> +static inline void thaw_kernel_threads(void) {}
> 
>  static inline bool try_to_freeze(void) { return false; }
> 
> Index: linux/kernel/power/process.c
> ===================================================================
> --- linux.orig/kernel/power/process.c
> +++ linux/kernel/power/process.c
> @@ -188,3 +188,22 @@ void thaw_processes(void)
>  	printk("done.\n");
>  }
> 
> +void thaw_kernel_threads(void)
> +{
> +	struct task_struct *g, *p;
> +
> +	pm_nosig_freezing = false;
> +	printk("Restarting kernel threads ... ");
> +
> +	thaw_workqueues();
> +
> +	read_lock(&tasklist_lock);
> +	do_each_thread(g, p) {
> +		if (p->flags & (PF_KTHREAD | PF_WQ_WORKER))
> +			__thaw_task(p);
> +	} while_each_thread(g, p);
> +	read_unlock(&tasklist_lock);
> +
> +	schedule();
> +	printk("done.\n");
> +}
> Index: linux/kernel/power/user.c
> ===================================================================
> --- linux.orig/kernel/power/user.c
> +++ linux/kernel/power/user.c
> @@ -274,6 +274,7 @@ static long snapshot_ioctl(struct file *
>  		swsusp_free();
>  		memset(&data->handle, 0, sizeof(struct snapshot_handle));
>  		data->ready = 0;
> +		thaw_kernel_threads();
>  		break;
> 
>  	case SNAPSHOT_PREF_IMAGE_SIZE:
> 

