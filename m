Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752645Ab2AZLGA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 06:06:00 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:48930 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648Ab2AZLF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 06:05:59 -0500
Message-ID: <4F213392.2090203@suse.cz>
Date: Thu, 26 Jan 2012 12:05:54 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120118 Thunderbird/10.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Jiri Slaby <jirislaby@gmail.com>, Tejun Heo <tj@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Baohua.Song@csr.com,
        "pavel@ucw.cz" <pavel@ucw.cz>,
        Linux PM mailing list <linux-pm@vger.kernel.org>
Subject: Re: [linux-pm] PM: cannot hibernate -- BUG at kernel/workqueue.c:3659
References: <4F1EC8D5.5040102@suse.cz> <4F202721.6050900@linux.vnet.ibm.com> <4F204D90.7010105@linux.vnet.ibm.com> <201201260051.45000.rjw@sisk.pl>
In-Reply-To: <201201260051.45000.rjw@sisk.pl>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/26/2012 12:51 AM, Rafael J. Wysocki wrote:
> IOW, Jiri, does the patch below help?

Yeah, this fixes the issue as well. Thanks.

> [BTW, the freeze_tasks()'s kerneldoc seems to be outdated.  Tejun?]
> 
> ---
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


-- 
js
suse labs
