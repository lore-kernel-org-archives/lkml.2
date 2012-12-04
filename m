Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753285Ab2LDUOJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 15:14:09 -0500
Received: from mx2.fusionio.com ([66.114.96.31]:35575 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751836Ab2LDUOG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 15:14:06 -0500
X-ASG-Debug-ID: 1354652044-0421b549eb5c340001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <50BE5988.3050501@fusionio.com>
Date: Tue, 4 Dec 2012 21:14:00 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Jeff Moyer <jmoyer@redhat.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>, Zach Brown <zab@redhat.com>
Subject: Re: [patch,v2] bdi: add a user-tunable cpu_list for the bdi flusher
 threads
References: <x49lidfnf0s.fsf@segfault.boston.devel.redhat.com>
X-ASG-Orig-Subj: Re: [patch,v2] bdi: add a user-tunable cpu_list for the bdi flusher
 threads
In-Reply-To: <x49lidfnf0s.fsf@segfault.boston.devel.redhat.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1354652044
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.116098
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-12-03 19:53, Jeff Moyer wrote:
> Hi,
> 
> In realtime environments, it may be desirable to keep the per-bdi
> flusher threads from running on certain cpus.  This patch adds a
> cpu_list file to /sys/class/bdi/* to enable this.  The default is to tie
> the flusher threads to the same numa node as the backing device (though
> I could be convinced to make it a mask of all cpus to avoid a change in
> behaviour).

Looks sane, and I think defaulting to the home node is a sane default.
One comment:

> +	ret = cpulist_parse(buf, newmask);
> +	if (!ret) {
> +		spin_lock(&bdi->wb_lock);
> +		task = wb->task;
> +		if (task)
> +			get_task_struct(task);
> +		spin_unlock(&bdi->wb_lock);

bdi->wb_lock needs to be bh safe. The above should have caused lockdep
warnings for you.

> +		if (task) {
> +			ret = set_cpus_allowed_ptr(task, newmask);
> +			put_task_struct(task);
> +		}
> +		if (ret == 0) {
> +			mutex_lock(&bdi->flusher_cpumask_mutex);
> +			cpumask_copy(bdi->flusher_cpumask, newmask);
> +			mutex_unlock(&bdi->flusher_cpumask_mutex);
> +			ret = count;
> +		}
> +	}

> @@ -437,6 +488,14 @@ static int bdi_forker_thread(void *ptr)
>  				spin_lock_bh(&bdi->wb_lock);
>  				bdi->wb.task = task;
>  				spin_unlock_bh(&bdi->wb_lock);
> +				mutex_lock(&bdi->flusher_cpumask_mutex);
> +				ret = set_cpus_allowed_ptr(task,
> +							bdi->flusher_cpumask);
> +				mutex_unlock(&bdi->flusher_cpumask_mutex);

It'd be very useful if we had a kthread_create_cpu_on_cpumask() instead
of a _node() variant, since the latter could easily be implemented on
top of the former. But not really a show stopper for the patch...

-- 
Jens Axboe

