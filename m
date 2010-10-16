Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751850Ab0JPAPL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 20:15:11 -0400
Received: from claw.goop.org ([74.207.240.146]:40857 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750826Ab0JPAPK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 20:15:10 -0400
Message-ID: <4CB8EE8A.5020900@goop.org>
Date: Fri, 15 Oct 2010 17:15:06 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.4
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@elte.hu" <mingo@elte.hu>
CC: "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>,
        "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        Ian Campbell <Ian.Campbell@citrix.com>
Subject: Re: [tip:irq/core] x86: xen: Sanitise sparse_irq handling
References: <tip-77dff1c755c3218691e95e7e38ee14323b35dbdb@git.kernel.org>
In-Reply-To: <tip-77dff1c755c3218691e95e7e38ee14323b35dbdb@git.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 On 10/12/2010 01:29 PM, tip-bot for Thomas Gleixner wrote:
> Commit-ID:  77dff1c755c3218691e95e7e38ee14323b35dbdb
> Gitweb:     http://git.kernel.org/tip/77dff1c755c3218691e95e7e38ee14323b35dbdb
> Author:     Thomas Gleixner <tglx@linutronix.de>
> AuthorDate: Wed, 29 Sep 2010 17:37:10 +0200
> Committer:  Thomas Gleixner <tglx@linutronix.de>
> CommitDate: Tue, 12 Oct 2010 16:53:44 +0200
>
> x86: xen: Sanitise sparse_irq handling
>
> There seems to be more cleanups possible, but that's left to the xen
> experts :)

This causes the kernel to fail to boot under Xen.  The WARN_ON(res !=
irq) triggers and nobody is very happy about the results.

It looks like the patch below might be sufficient, but then the system
fails due to block IO errors (not sure if that's related).

    J

diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 7d24b0d..a11fabb 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -338,31 +338,7 @@ static void unmask_evtchn(int port)
 
 static int find_unbound_irq(void)
 {
-	struct irq_data *data;
-	int irq, res;
-
-	for (irq = 0; irq < nr_irqs; irq++) {
-		data = irq_get_irq_data(irq);
-		/* only 0->15 have init'd desc; handle irq > 16 */
-		if (!data)
-			break;
-		if (data->chip == &no_irq_chip)
-			break;
-		if (data->chip != &xen_dynamic_chip)
-			continue;
-		if (irq_info[irq].type == IRQT_UNBOUND)
-			return irq;
-	}
-
-	if (irq == nr_irqs)
-		panic("No available IRQ to bind to: increase nr_irqs!\n");
-
-	res = irq_alloc_desc_at(irq, 0);
-
-	if (WARN_ON(res != irq))
-		return -1;
-
-	return irq;
+	return irq_alloc_descs(-1, 0, 1, 0);
 }
 
 int bind_evtchn_to_irq(unsigned int evtchn)




> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Reviewed-by: Ingo Molnar <mingo@elte.hu>
> Cc: Jeremy Fitzhardinge <jeremy@xensource.com>
> ---
>  drivers/xen/events.c |   23 +++++++++++------------
>  1 files changed, 11 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/xen/events.c b/drivers/xen/events.c
> index 13365ba..7d24b0d 100644
> --- a/drivers/xen/events.c
> +++ b/drivers/xen/events.c
> @@ -338,30 +338,29 @@ static void unmask_evtchn(int port)
>  
>  static int find_unbound_irq(void)
>  {
> -	int irq;
> -	struct irq_desc *desc;
> +	struct irq_data *data;
> +	int irq, res;
>  
>  	for (irq = 0; irq < nr_irqs; irq++) {
> -		desc = irq_to_desc(irq);
> +		data = irq_get_irq_data(irq);
>  		/* only 0->15 have init'd desc; handle irq > 16 */
> -		if (desc == NULL)
> +		if (!data)
>  			break;
> -		if (desc->chip == &no_irq_chip)
> +		if (data->chip == &no_irq_chip)
>  			break;
> -		if (desc->chip != &xen_dynamic_chip)
> +		if (data->chip != &xen_dynamic_chip)
>  			continue;
>  		if (irq_info[irq].type == IRQT_UNBOUND)
> -			break;
> +			return irq;
>  	}
>  
>  	if (irq == nr_irqs)
>  		panic("No available IRQ to bind to: increase nr_irqs!\n");
>  
> -	desc = irq_to_desc_alloc_node(irq, 0);
> -	if (WARN_ON(desc == NULL))
> -		return -1;
> +	res = irq_alloc_desc_at(irq, 0);
>  
> -	dynamic_irq_init_keep_chip_data(irq);
> +	if (WARN_ON(res != irq))
> +		return -1;
>  
>  	return irq;
>  }
> @@ -495,7 +494,7 @@ static void unbind_from_irq(unsigned int irq)
>  	if (irq_info[irq].type != IRQT_UNBOUND) {
>  		irq_info[irq] = mk_unbound_info();
>  
> -		dynamic_irq_cleanup(irq);
> +		irq_free_desc(irq);
>  	}
>  
>  	spin_unlock(&irq_mapping_update_lock);

