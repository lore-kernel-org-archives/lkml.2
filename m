Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752119Ab0CSRs5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 13:48:57 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:52809 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013Ab0CSRsz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 13:48:55 -0400
MIME-Version: 1.0
In-Reply-To: <1268987934-22690-1-git-send-email-chripell@fsfe.org>
References: <cabda6421003190139h344bc172h3556fca78e4b25cb@mail.gmail.com> 
	<1268987934-22690-1-git-send-email-chripell@fsfe.org>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 19 Mar 2010 11:48:34 -0600
X-Google-Sender-Auth: a5d8953f747e5d35
Message-ID: <fa686aa41003191048s5c4c85ablc4588725a3d615ad@mail.gmail.com>
Subject: Re: [PATCH 1/3] max3100: added raise_threaded_irq
To: Christian Pellegrin <chripell@fsfe.org>
Cc: feng.tang@intel.com, akpm@linux-foundation.org, greg@kroah.com,
       david-b@pacbell.net, alan@lxorguk.ukuu.org.uk,
       spi-devel-general@lists.sourceforge.net, linux-serial@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 19, 2010 at 2:38 AM, Christian Pellegrin <chripell@fsfe.org> wrote:
> raise_threaded_irq schedules the execution of an interrupt thread
>
> Signed-off-by: Christian Pellegrin <chripell@fsfe.org>

You should cc: Thomas and Ingo and lkml (which I just did) on patches
to the threaded interrupt code.

g.

> ---
>  include/linux/interrupt.h |    3 +++
>  kernel/irq/manage.c       |   27 +++++++++++++++++++++++++++
>  2 files changed, 30 insertions(+), 0 deletions(-)
>
> diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
> index 75f3f00..14c0c13 100644
> --- a/include/linux/interrupt.h
> +++ b/include/linux/interrupt.h
> @@ -144,6 +144,9 @@ request_threaded_irq(unsigned int irq, irq_handler_t handler,
>  static inline void exit_irq_thread(void) { }
>  #endif
>
> +extern int raise_threaded_irq(unsigned int irq);
> +
> +
>  extern void free_irq(unsigned int, void *);
>
>  struct device;
> diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
> index eb6078c..a7d21e0 100644
> --- a/kernel/irq/manage.c
> +++ b/kernel/irq/manage.c
> @@ -1088,3 +1088,30 @@ int request_threaded_irq(unsigned int irq, irq_handler_t handler,
>        return retval;
>  }
>  EXPORT_SYMBOL(request_threaded_irq);
> +
> +/**
> + *     raise_threaded_irq - triggers a threded interrupt
> + *     @irq: Interrupt line to trigger
> + */
> +int raise_threaded_irq(unsigned int irq)
> +{
> +       struct irq_desc *desc = irq_to_desc(irq);
> +       struct irqaction *action;
> +
> +       if (!desc)
> +               return -ENOENT;
> +       action = desc->action;
> +       if (!action)
> +               return -ENOENT;
> +       if (unlikely(!action->thread_fn))
> +               return -EINVAL;
> +       if (likely(!test_bit(IRQTF_DIED,
> +                            &action->thread_flags))) {
> +               set_bit(IRQTF_RUNTHREAD, &action->thread_flags);
> +               wake_up_process(action->thread);
> +       } else {
> +               return -ECHILD;
> +       }
> +       return 0;
> +}
> +EXPORT_SYMBOL(raise_threaded_irq);
> --
> 1.5.6.5
>
>



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
