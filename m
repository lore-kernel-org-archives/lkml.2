Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932767Ab1LFA7f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 19:59:35 -0500
Received: from lo.gmane.org ([80.91.229.12]:44682 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932572Ab1LFA7e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 19:59:34 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Namhyung Kim <namhyung@gmail.com>
Subject: Re: [PATCH 1/2] PM / Usermodehelper: Introduce reference counting
 to solve usermodehelper_disabled race
Date: Tue, 06 Dec 2011 09:59:15 +0900
Message-ID: <4EDD68E3.6050100@gmail.com>
References: <20111205212456.27496.35812.stgit@srivatsabhat.in.ibm.com> <20111205212524.27496.58775.stgit@srivatsabhat.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@dough.gmane.org
Cc: gregkh@suse.de, dhowells@redhat.com, eparis@redhat.com, rjw@sisk.pl,
        kay.sievers@vrfy.org, jmorris@namei.org, tj@kernel.org, bp@amd64.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
X-Gmane-NNTP-Posting-Host: 121.50.20.41
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:8.0) Gecko/20111105 Thunderbird/8.0
In-Reply-To: <20111205212524.27496.58775.stgit@srivatsabhat.in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

2011-12-06 오전 6:26, Srivatsa S. Bhat 쓴 글:
> This patch adds the necessary synchronization framework to fix the race
> condition with the 'usermodehelper_disabled' flag, by implementing a
> refcounting solution. Specifically, it introduces the pair get_usermodehelper()
> and put_usermodehelper(), which can be used by the readers (those who want to
> read the value of the usermodehelper_disabled flag, such as _request_firmware()
> in this case). The writers (those who enable/disable usermodehelpers by
> setting/resetting that flag) can use the pair umh_control_begin() and
> umh_control_done().
>
> The reason for using a refcounting solution and not just a plain mutex, is
> that we don't want to unnecessarily serialize all users of request_firmware(),
> which act as readers. But note that we cannot use reader-writer locks here
> because the readers sleep (waiting for the firmware load from user-space),
> and sleeping with spinlocks held is not allowed. So refcounting implemented
> using mutex locks underneath, seems to be the best fit here.
>
> Signed-off-by: Srivatsa S. Bhat<srivatsa.bhat@linux.vnet.ibm.com>
> ---
>
> The refcounting solution implemented here is adapted from the one used in
> the CPU hotplug infrastructure (kernel/cpu.c). If this patchset sounds
> reasonable, I plan to make the refcounting generic (in a later patch) and
> expose it via include/linux/refcount.h or something similar, and then use it
> at these 2 places instead of duplicating code.
>

IMHO it seems that the write path of the cpu_hotplug is protected by 
another mutex (cpu_add_remove_lock) to guarantee that the only one 
writer is active at a time. But I'm not sure this is the case for the 
umhelper too.

If more than 2 tasks call umh_control_begin() at the same time (is it 
possible though?), it will lost tasks except for the winner and 
active_writer AFAICS. Am I missing something?

Thanks.
Namhyung Kim


>   include/linux/kmod.h |    2 ++
>   kernel/kmod.c        |   64 ++++++++++++++++++++++++++++++++++++++++++++++++++
>   2 files changed, 66 insertions(+), 0 deletions(-)
>
> diff --git a/include/linux/kmod.h b/include/linux/kmod.h
> index b16f653..845fe3d 100644
> --- a/include/linux/kmod.h
> +++ b/include/linux/kmod.h
> @@ -117,5 +117,7 @@ extern void usermodehelper_init(void);
>   extern int usermodehelper_disable(void);
>   extern void usermodehelper_enable(void);
>   extern bool usermodehelper_is_disabled(void);
> +extern void get_usermodehelper(void);
> +extern void put_usermodehelper(void);
>
>   #endif /* __LINUX_KMOD_H__ */
> diff --git a/kernel/kmod.c b/kernel/kmod.c
> index 2142687..acb52af 100644
> --- a/kernel/kmod.c
> +++ b/kernel/kmod.c
> @@ -49,6 +49,70 @@ static kernel_cap_t usermodehelper_bset = CAP_FULL_SET;
>   static kernel_cap_t usermodehelper_inheritable = CAP_FULL_SET;
>   static DEFINE_SPINLOCK(umh_sysctl_lock);
>
> +static struct {
> +	struct task_struct *active_writer;
> +	struct mutex lock; /* Synchronizes accesses to refcount, */
> +	/*
> +	 * Also blocks the new readers during an ongoing update to the
> +	 * 'usermodehelper_disabled' flag.
> +	 */
> +	int refcount;
> +} umhelper = {
> +	.active_writer = NULL,
> +	.lock = __MUTEX_INITIALIZER(umhelper.lock),
> +	.refcount = 0,
> +};
> +
> +void get_usermodehelper(void)
> +{
> +	might_sleep();
> +	if (umhelper.active_writer == current)
> +		return;
> +	mutex_lock(&umhelper.lock);
> +	umhelper.refcount++;
> +	mutex_unlock(&umhelper.lock);
> +}
> +EXPORT_SYMBOL_GPL(get_usermodehelper);
> +
> +void put_usermodehelper(void)
> +{
> +	if (umhelper.active_writer == current)
> +		return;
> +	mutex_lock(&umhelper.lock);
> +	if (!--umhelper.refcount&&  unlikely(umhelper.active_writer))
> +		wake_up_process(umhelper.active_writer);
> +	mutex_unlock(&umhelper.lock);
> +}
> +EXPORT_SYMBOL_GPL(put_usermodehelper);
> +
> +/*
> + * This ensures that enabling or disabling usermodehelpers can begin
> + * only when the refcount goes to zero.
> + *
> + * Note that during an ongoing usermodehelper enable/disable operation,
> + * the new readers, if any, will be blocked by umhelper.lock
> + */
> +static void umh_control_begin(void)
> +{
> +	umhelper.active_writer = current;
> +
> +	for (;;) {
> +		mutex_lock(&umhelper.lock);
> +		if (likely(!umhelper.refcount))
> +			break;
> +		__set_current_state(TASK_UNINTERRUPTIBLE);
> +		mutex_unlock(&umhelper.lock);
> +		schedule();
> +	}
> +}
> +
> +static void umh_control_done(void)
> +{
> +	umhelper.active_writer = NULL;
> +	mutex_unlock(&umhelper.lock);
> +}
> +
> +
>   #ifdef CONFIG_MODULES
>
>   /*
>


