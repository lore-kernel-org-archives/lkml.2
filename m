Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755299Ab1B1VIu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 16:08:50 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:37509 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754897Ab1B1VIt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 16:08:49 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Thomas Renninger <trenn@suse.de>, lenb@kernel.org
Subject: Re: [PATCH] pm_qos: Make pm_qos settings readable
Date: Mon, 28 Feb 2011 22:08:42 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc6+; KDE/4.4.4; x86_64; ; )
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, mgross@linux.intel.com
References: <1298842606-55712-1-git-send-email-trenn@suse.de> <1298842606-55712-4-git-send-email-trenn@suse.de>
In-Reply-To: <1298842606-55712-4-git-send-email-trenn@suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201102282208.42637.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, February 27, 2011, Thomas Renninger wrote:
> I have a machine where entering deep C-states broke.
> pm_qos was a hot candidate, but I couldn't find any way to double
> check without the need of recompiling.
> 
> While in this case it was a driver bug (ath9k):
> https://bugzilla.kernel.org/show_bug.cgi?id=27532
> 
> powertop or others may want to read out cpu_dma_latency
> restrictions which could be the cause of preventing a machine
> entering deeper C-states.
> 
> Output with this patch:
> 
> # default value of 2000 * USEC_PER_SEC (0x77359400)
> cat /dev/network_latency |hexdump
> 0000000 9400 7735
> 0000004
> 
> # value of 55 us which is the reason for not entering C2
> cat /dev/cpu_dma_latency |hexdump
> 0000000 0037 0000
> 0000004
> 
> There is no reason to hide this info -> make pm_qos files readable.
> 
> Signed-off-by: Thomas Renninger <trenn@suse.de>
> CC: mgross@linux.intel.com
> CC: mingo@elte.hu

Applied to suspend-2.6/linux-next.

Thanks,
Rafael


> ---
>  kernel/pm_qos_params.c |   24 ++++++++++++++++++++++++
>  1 files changed, 24 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/pm_qos_params.c b/kernel/pm_qos_params.c
> index aeaa7f8..0da058b 100644
> --- a/kernel/pm_qos_params.c
> +++ b/kernel/pm_qos_params.c
> @@ -103,11 +103,14 @@ static struct pm_qos_object *pm_qos_array[] = {
>  
>  static ssize_t pm_qos_power_write(struct file *filp, const char __user *buf,
>  		size_t count, loff_t *f_pos);
> +static ssize_t pm_qos_power_read(struct file *filp, char __user *buf,
> +		size_t count, loff_t *f_pos);
>  static int pm_qos_power_open(struct inode *inode, struct file *filp);
>  static int pm_qos_power_release(struct inode *inode, struct file *filp);
>  
>  static const struct file_operations pm_qos_power_fops = {
>  	.write = pm_qos_power_write,
> +	.read = pm_qos_power_read,
>  	.open = pm_qos_power_open,
>  	.release = pm_qos_power_release,
>  	.llseek = noop_llseek,
> @@ -376,6 +379,27 @@ static int pm_qos_power_release(struct inode *inode, struct file *filp)
>  }
>  
>  
> +static ssize_t pm_qos_power_read(struct file *filp, char __user *buf,
> +		size_t count, loff_t *f_pos)
> +{
> +	s32 value;
> +	unsigned long flags;
> +	struct pm_qos_object *o;
> +	struct pm_qos_request_list *pm_qos_req = filp->private_data;;
> +
> +	if (!pm_qos_req)
> +		return -EINVAL;
> +	if (!pm_qos_request_active(pm_qos_req))
> +		return -EINVAL;
> +
> +	o = pm_qos_array[pm_qos_req->pm_qos_class];
> +	spin_lock_irqsave(&pm_qos_lock, flags);
> +	value = pm_qos_get_value(o);
> +	spin_unlock_irqrestore(&pm_qos_lock, flags);
> +
> +	return simple_read_from_buffer(buf, count, f_pos, &value, sizeof(s32));
> +}
> +
>  static ssize_t pm_qos_power_write(struct file *filp, const char __user *buf,
>  		size_t count, loff_t *f_pos)
>  {
> 

