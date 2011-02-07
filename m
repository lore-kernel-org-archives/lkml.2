Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753658Ab1BGLIm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 06:08:42 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:9832 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753392Ab1BGLIl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 06:08:41 -0500
X-IronPort-AV: E=Sophos;i="4.60,437,1291611600"; 
   d="scan'208";a="134605208"
Subject: Re: [patch 2/4] xen: Switch to new irq_chip functions
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>, Jeremy Fitzhardinge <jeremy@goop.org>
In-Reply-To: <20110205200703.925495018@linutronix.de>
References: <20110205200108.921707839@linutronix.de>
	 <20110205200703.925495018@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Organization: Citrix Systems, Inc.
Date: Mon, 7 Feb 2011 11:08:39 +0000
Message-ID: <1297076919.13091.846.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-02-05 at 20:08 +0000, Thomas Gleixner wrote:
> 
> -static void ack_pirq(unsigned int irq)
> +static void ack_pirq(struct irq_data *data)
>  {
> -       int evtchn = evtchn_from_irq(irq);
> +       int evtchn = evtchn_from_irq(data->irq);
>  
> -       move_native_irq(irq);
> +       irq_move_irq(data); 

I tried to test with Linus latest but with this patch:

/local/scratch/ianc/devel/kernels/linux-2.6/drivers/xen/events.c: In function 'ack_pirq':
/local/scratch/ianc/devel/kernels/linux-2.6/drivers/xen/events.c:568: error: implicit declaration of function 'irq_move_irq'

I can't find irq_move_irq in any of the tip.git branches (incl. master,
auto-latest and .*irq.*), via google or in any of the other conversion
patches you posted for other arches. Am I just looking in the wrong
places or was this a mistake?

For now I went with the following sort-of-reversion to allow me to
continue:

diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 65f05e2..6f5dd38 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -565,7 +565,7 @@ static void ack_pirq(struct irq_data *data)
 {
 	int evtchn = evtchn_from_irq(data->irq);
 
-	irq_move_irq(data);
+	move_native_irq(data->irq);
 
 	if (VALID_EVTCHN(evtchn)) {
 		mask_evtchn(evtchn);

Ian.

