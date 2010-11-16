Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755190Ab0KPQox (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 11:44:53 -0500
Received: from canuck.infradead.org ([134.117.69.58]:38398 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754667Ab0KPQow convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 11:44:52 -0500
Subject: Re: [RFC][PATCH] irq_work: Don't ignore possible cmpxchg failure
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Sergio Aguirre <saaguirre@ti.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Huang Ying <ying.huang@intel.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Kyle McMartin <kyle@mcmartin.ca>
In-Reply-To: <1289925179-17085-1-git-send-email-saaguirre@ti.com>
References: <1289925179-17085-1-git-send-email-saaguirre@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 16 Nov 2010 17:45:01 +0100
Message-ID: <1289925901.2109.629.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-16 at 10:32 -0600, Sergio Aguirre wrote:
> Although is very unlikely, it's better to make sure we're not
> letting this happen.
> 
> This solves this compilation warning:
> 
> kernel/irq_work.c: In function 'irq_work_run':
> kernel/irq_work.c:148: warning: value computed is not used
> 

> @@ -145,7 +145,10 @@ void irq_work_run(void)
>  		 * Clear the BUSY bit and return to the free state if
>  		 * no-one else claimed it meanwhile.
>  		 */
> -		cmpxchg(&entry->next, next_flags(NULL, IRQ_WORK_BUSY), NULL);
> +		xchgres = cmpxchg(&entry->next,
> +				  next_flags(NULL, IRQ_WORK_BUSY),
> +				  NULL);
> +		BUG_ON(unlikely(xchgres != next_flags(NULL, IRQ_WORK_BUSY)));

simply adding (void) in front would be much easier.
