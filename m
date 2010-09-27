Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759494Ab0I0Ob7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 10:31:59 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:35369 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755783Ab0I0Ob6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 10:31:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=diHKKLu2sx0jlAkcX36kzTC3akuLNoa/OwCrQXJI36SK23CFQ2/281NqmOnRMA97Ud
         y13zHApcC0GsyPG8jxox9x/XZR6zlodNTIMWiF6kF8+AlZy/RDqQZMU7X0+O89MO85zt
         hcP+hPOUuxnzfvNdojKNHjrvOfIpD1KjZwxB8=
MIME-Version: 1.0
In-Reply-To: <1285120171-3030-1-git-send-email-tom.leiming@gmail.com>
References: <1285120171-3030-1-git-send-email-tom.leiming@gmail.com>
Date: Mon, 27 Sep 2010 22:31:56 +0800
Message-ID: <AANLkTikrhE=3FYtv9d+jzy5sohwpvhWsZPhm9+PCPZVn@mail.gmail.com>
Subject: Re: [PATCH] mfd: speedup twl4030 irq response time and decrease irq
 disable time
From: Ming Lei <tom.leiming@gmail.com>
To: sameo@linux.intel.com
Cc: linux-omap@vger.kernel.org, Ming Lei <tom.leiming@gmail.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Balaji T K <balajitk@ti.com>, Rajendra Nayak <rnayak@ti.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/9/22  <tom.leiming@gmail.com>:
> From: Ming Lei <tom.leiming@gmail.com>
>
> This patch sets scheduler policy of twl4030 irq thread
> (twl4030_irq_thread) as SCHED_FIFO to speedup irq response
> time, just like taken by kernel threaded irq in irq_thread
> (kernel/irq/manage.c). Also higher priority than that of
> threaded irq is taken to avoid preemption from twl4030
> subchips's threaded irq handler, so pih irq disable time may
> be decreased.
>
> The pih irq is disabled in handle_twl4030_pih which may
> wakeup twl4030 irq thread, and the pih irq will be enabled
> again until complete of all sih irqs' handling in twl4030
> irq thread.
>
> Also for each one interrupt line of twl4030 subchip, only
> two irq events can be buffered by twl4030(4.4.2.3 of TPS65950 TRM).

Ping...

> Signed-off-by: Ming Lei <tom.leiming@gmail.com>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
> Cc: Balaji T K <balajitk@ti.com>
> Cc: Rajendra Nayak <rnayak@ti.com>
> Cc: Kevin Hilman <khilman@deeprootsystems.com>
> Cc: linux-kernel@vger.kernel.org
> ---
>  drivers/mfd/twl4030-irq.c |   10 +++++++++-
>  1 files changed, 9 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/mfd/twl4030-irq.c b/drivers/mfd/twl4030-irq.c
> index 097f24d..d1e0d80 100644
> --- a/drivers/mfd/twl4030-irq.c
> +++ b/drivers/mfd/twl4030-irq.c
> @@ -286,8 +286,16 @@ static int twl4030_irq_thread(void *data)
>        long irq = (long)data;
>        static unsigned i2c_errors;
>        static const unsigned max_i2c_errors = 100;
> -
> -
> +       struct sched_param param = {
> +               .sched_priority = MAX_USER_RT_PRIO/2 + 10,
> +       };
> +
> +       /* Take higher priority than threaded irq to make us immune of
> +        * preemption from twl4030 subchips's threaded irq handler, then
> +        * we can complete all SIH irqs' handling and enable PIH irq
> +        * again asap.
> +        * */
> +       sched_setscheduler(current, SCHED_FIFO, &param);
>        current->flags |= PF_NOFREEZE;
>
>        while (!kthread_should_stop()) {
> --
> 1.6.2.5
>
>


thanks,

-- 
Lei Ming
