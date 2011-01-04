Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751109Ab1ADAyO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 19:54:14 -0500
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:53608 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750803Ab1ADAyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 19:54:13 -0500
Subject: Re: [PATCH 11/32] v4l/cx18: update workqueue usage
From: Andy Walls <awalls@md.metrocast.net>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
In-Reply-To: <1294062595-30097-12-git-send-email-tj@kernel.org>
References: <1294062595-30097-1-git-send-email-tj@kernel.org>
	 <1294062595-30097-12-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 03 Jan 2011 19:54:56 -0500
Message-ID: <1294102496.10094.152.camel@morgan.silverblock.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.2.15,1.0.148,0.0.0000
 definitions=2011-01-03_13:2011-01-03,2011-01-03,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 ipscore=0 suspectscore=2
 phishscore=0 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 engine=5.0.0-1010190000 definitions=main-1101030134
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-01-03 at 14:49 +0100, Tejun Heo wrote:
> With cmwq, there's no reason to use separate out_work_queue.  Drop it
> and use system_wq instead.  The in_work_queue needs to be ordered so
> can't use one of the system wqs; however, as it isn't used to reclaim
> memory, allocate the workqueue with alloc_ordered_workqueue() without
> WQ_MEM_RECLAIM.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Andy Walls <awalls@md.metrocast.net>
> Cc: linux-media@vger.kernel.org

Tejun,

I have a question about cmwq, but to ask it, I need to give the context.

The non-system out_work_queue in cx18 had two purposes:

1. To prevent a userspace video rendering application from sleeping in
read(), when it had emptied a cx18 driver DMA buffer and the cx18 driver
had to sleep to notify the CX2318 engine that the buffer was available
again.

Your change has no adverse effect on this.


2. To prevent work items being handled by keventd/n from being delayed
too long, as the deferred work in question can involve a bit of sleeping
due to contention, the workload of the CX23418's MPEG encoding engine,
and the number of CX23418 devices in the system.

Will all the sleeping that can happen, is the move to a system wq, under
cmwq, going to have adverse affects on processing other work items in
the system?

I get the feeling it won't be a problem with cmwq, but I haven't paid
enough attention to be sure. 

Here are some gory details, if it helps:

A single CX23418 has *one* cx18 driver to CX23418 Capture Processing
Unit (epu2cpu_mb) mailbox though which the cx18 driver sends all normal
commands along with a notification interrupt to the CX23418.

The CX23418 will acknowledge all commands with ack back in the mailbox
and an interrupt for the cx18 driver.  Sometimes the ack happens right
away.  Sometimes the cx18 driver has to wait(), if the CX23418 is
busy.  

The cx18 driver uses a mutex (epu2cpu_mb_lock) to protect cx18 driver
access to the one epu2cpu_mb mailbox.  The mutex is grabbed and released
on a per epu2cpu_mb mailbox command basis

To tell the CX23418 about a usable empty buffer for DMA, one epu2cpu
mailbox command (CX18_CPU_DE_SET_MDL) must be performed for each usable
empty buffer.

A CX23418 can support multiple, simultaneous logical capture streams at
once.  The streams for a DVB TS, analog video converted to MPEG, VBI
data, and the MPEG Index data are common to have active simultaneously.

The CX23418 can keep track of 63 empty buffers for each active stream
and the cx18 driver tries to ensure the CX23418 always has as close to
63 as possible available at any time.

The out_work_handler, when triggered for a capture stream type, will try
to perform, as needed, from 1 to 63 CX18_CPU_DE_SET_MDL mailbox commands
for that stream.  At steady state, the number of CX18_CPU_DE_SET_MDL
mailbox commands executed one after the other in a batch will likely be
from 1 to 3.

It is not unusual for a non-commercial end user to have 2 or 3 CX23418
based capture cards in one machine.  I am aware of at least one
commercial user that had 5 CX23418 based cards in a modest machine.

It is not unusual for scheduled TV recording software to start nearly
simultaneous DTV TS, MPEG, and VBI or MPEG Index streams on multiple
cards.  So 3 CX23418 cards with 3 streams each.   Let's nominally
estimate the timing of the CX18_CPU_DE_SET_MDL commands per stream at
the PAL frame rate of 25 Hz; or 1 CX18_CPU_DE_SET_MDL mailbox command
per stream per 40 milliseconds.

Regards,
Andy

> ---
> Only compile tested.  Please feel free to take it into the subsystem
> tree or simply ack - I'll route it through the wq tree.
> 
> Thanks.
> 
>  drivers/media/video/cx18/cx18-driver.c  |   24 ++----------------------
>  drivers/media/video/cx18/cx18-driver.h  |    3 ---
>  drivers/media/video/cx18/cx18-streams.h |    3 +--
>  3 files changed, 3 insertions(+), 27 deletions(-)
> 
> diff --git a/drivers/media/video/cx18/cx18-driver.c b/drivers/media/video/cx18/cx18-driver.c
> index df60f27..41c0822 100644
> --- a/drivers/media/video/cx18/cx18-driver.c
> +++ b/drivers/media/video/cx18/cx18-driver.c
> @@ -656,7 +656,7 @@ static int __devinit cx18_create_in_workq(struct cx18 *cx)
>  {
>  	snprintf(cx->in_workq_name, sizeof(cx->in_workq_name), "%s-in",
>  		 cx->v4l2_dev.name);
> -	cx->in_work_queue = create_singlethread_workqueue(cx->in_workq_name);
> +	cx->in_work_queue = alloc_ordered_workqueue(cx->in_workq_name, 0);
>  	if (cx->in_work_queue == NULL) {
>  		CX18_ERR("Unable to create incoming mailbox handler thread\n");
>  		return -ENOMEM;
> @@ -664,18 +664,6 @@ static int __devinit cx18_create_in_workq(struct cx18 *cx)
>  	return 0;
>  }
>  
> -static int __devinit cx18_create_out_workq(struct cx18 *cx)
> -{
> -	snprintf(cx->out_workq_name, sizeof(cx->out_workq_name), "%s-out",
> -		 cx->v4l2_dev.name);
> -	cx->out_work_queue = create_workqueue(cx->out_workq_name);
> -	if (cx->out_work_queue == NULL) {
> -		CX18_ERR("Unable to create outgoing mailbox handler threads\n");
> -		return -ENOMEM;
> -	}
> -	return 0;
> -}
> -
>  static void __devinit cx18_init_in_work_orders(struct cx18 *cx)
>  {
>  	int i;
> @@ -702,15 +690,9 @@ static int __devinit cx18_init_struct1(struct cx18 *cx)
>  	mutex_init(&cx->epu2apu_mb_lock);
>  	mutex_init(&cx->epu2cpu_mb_lock);
>  
> -	ret = cx18_create_out_workq(cx);
> -	if (ret)
> -		return ret;
> -
>  	ret = cx18_create_in_workq(cx);
> -	if (ret) {
> -		destroy_workqueue(cx->out_work_queue);
> +	if (ret)
>  		return ret;
> -	}
>  
>  	cx18_init_in_work_orders(cx);
>  
> @@ -1094,7 +1076,6 @@ free_mem:
>  	release_mem_region(cx->base_addr, CX18_MEM_SIZE);
>  free_workqueues:
>  	destroy_workqueue(cx->in_work_queue);
> -	destroy_workqueue(cx->out_work_queue);
>  err:
>  	if (retval == 0)
>  		retval = -ENODEV;
> @@ -1244,7 +1225,6 @@ static void cx18_remove(struct pci_dev *pci_dev)
>  	cx18_halt_firmware(cx);
>  
>  	destroy_workqueue(cx->in_work_queue);
> -	destroy_workqueue(cx->out_work_queue);
>  
>  	cx18_streams_cleanup(cx, 1);
>  
> diff --git a/drivers/media/video/cx18/cx18-driver.h b/drivers/media/video/cx18/cx18-driver.h
> index 77be58c..f7f71d1 100644
> --- a/drivers/media/video/cx18/cx18-driver.h
> +++ b/drivers/media/video/cx18/cx18-driver.h
> @@ -614,9 +614,6 @@ struct cx18 {
>  	struct cx18_in_work_order in_work_order[CX18_MAX_IN_WORK_ORDERS];
>  	char epu_debug_str[256]; /* CX18_EPU_DEBUG is rare: use shared space */
>  
> -	struct workqueue_struct *out_work_queue;
> -	char out_workq_name[12]; /* "cx18-NN-out" */
> -
>  	/* i2c */
>  	struct i2c_adapter i2c_adap[2];
>  	struct i2c_algo_bit_data i2c_algo[2];
> diff --git a/drivers/media/video/cx18/cx18-streams.h b/drivers/media/video/cx18/cx18-streams.h
> index 77412be..5837ffb 100644
> --- a/drivers/media/video/cx18/cx18-streams.h
> +++ b/drivers/media/video/cx18/cx18-streams.h
> @@ -41,8 +41,7 @@ static inline bool cx18_stream_enabled(struct cx18_stream *s)
>  /* Related to submission of mdls to firmware */
>  static inline void cx18_stream_load_fw_queue(struct cx18_stream *s)
>  {
> -	struct cx18 *cx = s->cx;
> -	queue_work(cx->out_work_queue, &s->out_work_order);
> +	schedule_work(&s->out_work_order);
>  }
>  
>  static inline void cx18_stream_put_mdl_fw(struct cx18_stream *s,


