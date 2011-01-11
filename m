Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755965Ab1AKVHw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 16:07:52 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:43534 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754289Ab1AKVHs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 16:07:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=CzF6+raF0UXZztkzHL7r7V/GcyOQEpWlbgFMplQCXyHcW1YFKnHTJQd+swLzf71Wrl
         R8XFWiXOLa784Fc6h7huNfsH/fv32M8SdJzpYqdNP1ycm4sYVu2HZq90QAPXTT74/RwE
         xDe+mZuugfjtHhJ/sZ6DbaQcWavY5woqcLBBo=
MIME-Version: 1.0
In-Reply-To: <1294735916.1949.637.camel@sli10-conroe>
References: <1294735916.1949.637.camel@sli10-conroe>
Date: Tue, 11 Jan 2011 22:07:47 +0100
Message-ID: <AANLkTim72yNM1svGbFTKW8pSnFP9W+YgvGs4moXq+pyo@mail.gmail.com>
Subject: Re: [PATCH 1/2]block cfq: make queue preempt work for queues from
 different workload
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Jens Axboe <jaxboe@fusionio.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        "jmoyer@redhat.com" <jmoyer@redhat.com>,
        Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Shaohua,
On Tue, Jan 11, 2011 at 9:51 AM, Shaohua Li <shaohua.li@intel.com> wrote:
> I got this:
>             fio-874   [007]  2157.724514:   8,32   m   N cfq874 preempt
>             fio-874   [007]  2157.724519:   8,32   m   N cfq830 slice expired t=1
>             fio-874   [007]  2157.724520:   8,32   m   N cfq830 sl_used=1 disp=0 charge=1 iops=0 sect=0
>             fio-874   [007]  2157.724521:   8,32   m   N cfq830 set_active wl_prio:0 wl_type:0
>             fio-874   [007]  2157.724522:   8,32   m   N cfq830 Not idling. st->count:1
> cfq830 is an async queue, and preempted by a sync queue cfq874. But since we
> have cfqg->saved_workload_slice mechanism, the preempt is a nop.
> Looks currently our preempt is totally broken if the two queues are not from
> the same workload type.
> Below patch fixes it. This will might make async queue starvation, but it's
> what our old code does before cgroup is added.
have you measured latency improvements by un-breaking preemption?
AFAIK, preemption behaviour changed since 2.6.33, before cgroups were
added, and the latency before the changes that weakened preemption in
2.6.33 was far worse.

Thanks,
Corrado
>
> Signed-off-by: Shaohua Li <shaohua.li@intel.com>
>
> ---
>  block/cfq-iosched.c |    9 +++++++++
>  1 file changed, 9 insertions(+)
>
> Index: linux/block/cfq-iosched.c
> ===================================================================
> --- linux.orig/block/cfq-iosched.c      2011-01-11 16:24:56.000000000 +0800
> +++ linux/block/cfq-iosched.c   2011-01-11 16:41:49.000000000 +0800
> @@ -3284,10 +3284,19 @@ cfq_should_preempt(struct cfq_data *cfqd
>  */
>  static void cfq_preempt_queue(struct cfq_data *cfqd, struct cfq_queue *cfqq)
>  {
> +       struct cfq_queue *old_cfqq = cfqd->active_queue;
> +
>        cfq_log_cfqq(cfqd, cfqq, "preempt");
>        cfq_slice_expired(cfqd, 1);
>
>        /*
> +        * workload type is changed, don't save slice, otherwise preempt
> +        * doesn't happen
> +        */
> +       if (cfqq_type(old_cfqq) != cfqq_type(cfqq))
> +               cfqq->cfqg->saved_workload_slice = 0;
> +
> +       /*
>         * Put the new queue at the front of the of the current list,
>         * so we know that it will be selected next.
>         */
>
>
>
