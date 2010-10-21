Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751929Ab0JUPN5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 11:13:57 -0400
Received: from smtp105.prem.mail.ac4.yahoo.com ([76.13.13.44]:25816 "HELO
	smtp105.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750743Ab0JUPN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 11:13:56 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: vJt2okgVM1nvDjAPBfRkyCqLDttHAWWi01Dp9nkiCIpKxe1
 .TIT.vi5Z4KLGOfhnaiNrS8xDtAdELY6SOTT8.OdJFv8qgg2HYV4HN06XPeq
 JYzbs1fruFtYDzkzsa7Aea8jtXpmMYe_LniteoETn9QO3zpwUwGYN2Ty9f5Z
 2DmTf29DlHa4BkDNIIihTwb1JoUWUwD08CjQlc9vQGTOJDblB2aF8CMs1QTp
 2
X-Yahoo-Newman-Property: ymail-3
Date: Thu, 21 Oct 2010 10:13:51 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Venkatesh Pallipadi <venki@google.com>
cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel@vger.kernel.org, Paul Turner <pjt@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Shaun Ruffell <sruffell@digium.com>,
        Yong Zhang <yong.zhang0@gmail.com>
Subject: Re: [PATCH 1/6] Free up pf flag PF_KSOFTIRQD
In-Reply-To: <1287614941-32325-2-git-send-email-venki@google.com>
Message-ID: <alpine.DEB.2.00.1010211012220.24115@router.home>
References: <1287614941-32325-1-git-send-email-venki@google.com> <1287614941-32325-2-git-send-email-venki@google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Oct 2010, Venkatesh Pallipadi wrote:

> diff --git a/kernel/sched.c b/kernel/sched.c
> index abf8440..5d4afe9 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -1984,9 +1984,9 @@ void account_system_vtime(struct task_struct *curr)
>  	 * in that case, so as not to confuse scheduler with a special task
>  	 * that do not consume any time, but still wants to run.
>  	 */
> -	if (hardirq_count())
> +	if (in_irq())
>  		per_cpu(cpu_hardirq_time, cpu) += delta;

If cpu is always the current cpu then you can optimize the code:

	this_cpu_add(cpu_hardirq_time, delta)

> -	else if (in_serving_softirq() && !(curr->flags & PF_KSOFTIRQD))
> +	else if (in_serving_softirq() && !(is_ksoftirqd_context()))
>  		per_cpu(cpu_softirq_time, cpu) += delta;

Same here.

