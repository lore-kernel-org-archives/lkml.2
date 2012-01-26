Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752917Ab2AZTXN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 14:23:13 -0500
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:43592 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773Ab2AZTXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 14:23:11 -0500
Message-ID: <4F21A80D.6080200@linux.vnet.ibm.com>
Date: Fri, 27 Jan 2012 00:52:53 +0530
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
x-cbid: 12012609-1396-0000-0000-00000096C2C2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/26/2012 05:21 AM, Rafael J. Wysocki wrote:

> Hi,
>>
>> SNAPSHOT_CREATE_IMAGE has a check for data->ready such as:
>>
>>         if (data->mode != O_RDONLY || !data->frozen  || data->ready) {
>>                 error = -EPERM;
>>                 break;
>>         }
>>
>> data->ready would be set to 1 only under SNAPSHOT_CREATE_IMAGE. However,
>> SNAPSHOT_FREE (invoked at the place shown above) will reset the value to 0.
>> This makes it possible for hibernation_snapshot() and hence
>> freeze_workqueues_begin() to be called a second time, which is unfortunate.
> 
> Yes, I obviously forgot about that code path when I was working on the commit
> that introduced the problem. :-(
> 
> Thanks a lot for the great analysis, it's really helpful!
>


Welcome :-) It was fun!

 
>> And actually, the patch I posted in my previous mail is not really the right
>> long-term fix, though it might fix the particular issue that Jiri is facing..
>>
>> Because, allowing hibernation_snapshot() to get called a second time while
>> kernel threads are still frozen brings us to the same situation that commit
>> 2aede851 (PM / Hibernate: Freeze kernel threads after preallocating memory)
>> tried to prevent! IOW, a call to hibernate_preallocate_memory() would be
>> done inside hibernation_snapshot(), when kernel threads are frozen.. which
>> is known to break XFS, to give one example as mentioned in the changelog
>> of the above commit.
> 
> That's exactly right.
> 
>> So, the right way to fix this IMHO, would be to split up thaw_processes()
>> just like freezing phase:
>>
>> /* freezes or thaws user space processes */
>> freeze_processes() - thaw_processes()
>>
>> /* freezes or thaws kernel threads */
>> freeze_kernel_threads() - thaw_kernel_threads()
>>
>> We have to insert this thaw_kernel_threads() at appropriate places in such a
>> way as to not require another ioctl if possible... Then things would be
>> more symmetric (and hence more easy to understand) and we can avoid getting
>> into strange situations as discussed here.
>>
>> But before we venture into that, it would be good to know if the patch posted
>> in the previous mail fixes the particular problem reported in this thread,
>> atleast just to see if there are other problems lurking that we aren't aware
>> of yet..
> 
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


This is exactly the kind of fix I was suggesting.. Thanks Rafael!

I have a small request for a comment. Please see below.
I have a question too, but for that I'll have to reply to my earlier
thread so that I can comment on the userspace code.

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


It would be nice to have a comment here explaining why we call
thaw_kernel_threads() here. (Such a comment would avoid confusion when people
look at SNAPSHOT_CREATE_IMAGE and SNAPSHOT_FREE and wonder why there is
thawing involved, while the corresponding freezing is nowhere in sight..
Of course the freezing is hidden inside hibernation_snapshot(), but that
might not be immediately apparent to everyone.)

> +		thaw_kernel_threads();

>  		break;

> 
>  	case SNAPSHOT_PREF_IMAGE_SIZE:


Regards,
Srivatsa S. Bhat

