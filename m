Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755257Ab0EaBJE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 May 2010 21:09:04 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59049 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754171Ab0EaBJA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 May 2010 21:09:00 -0400
Message-ID: <4C030CB8.505@cn.fujitsu.com>
Date: Mon, 31 May 2010 09:11:20 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: "Michael S. Tsirkin" <mst@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
       Sridhar Samudrala <sri@us.ibm.com>, netdev <netdev@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dmitri Vorobiev <dmitri.vorobiev@movial.com>,
       Jiri Kosina <jkosina@suse.cz>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 3/3] vhost: apply cpumask and cgroup to vhost pollers
References: <20100527091426.GA6308@redhat.com> <20100527124448.GA4241@redhat.com> <20100527131254.GB7974@redhat.com> <4BFE9ABA.6030907@kernel.org> <20100527163954.GA21710@redhat.com> <4BFEA434.6080405@kernel.org> <20100527173207.GA21880@redhat.com> <4BFEE216.2070807@kernel.org> <20100528150830.GB21880@redhat.com> <4BFFE742.2060205@kernel.org> <20100530112925.GB27611@redhat.com> <4C02C99D.9070204@kernel.org>
In-Reply-To: <4C02C99D.9070204@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Apply the cpumask and cgroup of the initializing task to the created
> vhost poller.
> 
> Based on Sridhar Samudrala's patch.
> 
> Cc: Michael S. Tsirkin <mst@redhat.com>
> Cc: Sridhar Samudrala <samudrala.sridhar@gmail.com>
> ---
>  drivers/vhost/vhost.c |   36 +++++++++++++++++++++++++++++++-----
>  1 file changed, 31 insertions(+), 5 deletions(-)
> 
> Index: work/drivers/vhost/vhost.c
> ===================================================================
> --- work.orig/drivers/vhost/vhost.c
> +++ work/drivers/vhost/vhost.c
> @@ -23,6 +23,7 @@
>  #include <linux/highmem.h>
>  #include <linux/slab.h>
>  #include <linux/kthread.h>
> +#include <linux/cgroup.h>
> 
>  #include <linux/net.h>
>  #include <linux/if_packet.h>
> @@ -176,12 +177,30 @@ repeat:
>  long vhost_dev_init(struct vhost_dev *dev,
>  		    struct vhost_virtqueue *vqs, int nvqs)
>  {
> -	struct task_struct *poller;
> -	int i;
> +	struct task_struct *poller = NULL;
> +	cpumask_var_t mask;
> +	int i, ret = -ENOMEM;
> +
> +	if (!alloc_cpumask_var(&mask, GFP_KERNEL))
> +		goto out;
> 

If we "goto out", we will end up calling kthread_stop(poller), but
seems kthread_stop() requires the task_struct pointer != NULL.

>  	poller = kthread_create(vhost_poller, dev, "vhost-%d", current->pid);
> -	if (IS_ERR(poller))
> -		return PTR_ERR(poller);
> +	if (IS_ERR(poller)) {
> +		ret = PTR_ERR(poller);
> +		goto out;
> +	}
> +
> +	ret = sched_getaffinity(current->pid, mask);
> +	if (ret)
> +		goto out;
> +
> +	ret = sched_setaffinity(poller->pid, mask);
> +	if (ret)
> +		goto out;
> +
> +	ret = cgroup_attach_task_current_cg(poller);
> +	if (ret)
> +		goto out;
> 
>  	dev->vqs = vqs;
>  	dev->nvqs = nvqs;
> @@ -202,7 +221,14 @@ long vhost_dev_init(struct vhost_dev *de
>  			vhost_poll_init(&dev->vqs[i].poll,
>  					dev->vqs[i].handle_kick, POLLIN, dev);
>  	}
> -	return 0;
> +
> +	wake_up_process(poller);	/* avoid contributing to loadavg */
> +	ret = 0;
> +out:
> +	if (ret)
> +		kthread_stop(poller);
> +	free_cpumask_var(mask);
> +	return ret;
>  }
> 
>  /* Caller should have device mutex */
