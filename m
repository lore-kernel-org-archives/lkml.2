Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754065Ab0LGObM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 09:31:12 -0500
Received: from hera.kernel.org ([140.211.167.34]:56167 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752440Ab0LGObL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 09:31:11 -0500
Message-ID: <4CFE44E2.9050408@kernel.org>
Date: Tue, 07 Dec 2010 15:29:54 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: akpm@linux-foundation.org, Pekka Enberg <penberg@cs.helsinki.fi>,
        Hugh Dickins <hughd@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [Use cpuops V1 05/11] core: Replace __get_cpu_var with __this_cpu_read
 if not used for an address.
References: <20101206171618.302060721@linux.com> <20101206171639.183187260@linux.com>
In-Reply-To: <20101206171639.183187260@linux.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 07 Dec 2010 14:29:56 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 12/06/2010 06:16 PM, Christoph Lameter wrote:
> __get_cpu_var() can be replaced with this_cpu_read and will then use a single
> read instruction with implied address calculation to access the correct per cpu
> instance.
> 
> However, the address of a per cpu variable passed to __this_cpu_read() cannot be
> determed (since its an implied address conversion through segment prefixes).
> Therefore apply this only to uses of __get_cpu_var where the addres of the
> variable is not used.
> 
> Cc: Pekka Enberg <penberg@cs.helsinki.fi>
> Cc: Hugh Dickins <hughd@google.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Christoph Lameter <cl@linux.com>
...
> @@ -802,18 +802,18 @@ static void takeover_tasklets(unsigned i
>  
>  	/* Find end, append list for that CPU. */
>  	if (&per_cpu(tasklet_vec, cpu).head != per_cpu(tasklet_vec, cpu).tail) {
> -		*(__get_cpu_var(tasklet_vec).tail) = per_cpu(tasklet_vec, cpu).head;
> -		__get_cpu_var(tasklet_vec).tail = per_cpu(tasklet_vec, cpu).tail;
> +		*__this_cpu_read(tasklet_vec.tail) = per_cpu(tasklet_vec, cpu).head;
> +		this_cpu_write(tasklet_vec.tail, per_cpu(tasklet_vec, cpu).tail);
>  		per_cpu(tasklet_vec, cpu).head = NULL;
>  		per_cpu(tasklet_vec, cpu).tail = &per_cpu(tasklet_vec, cpu).head;
>  	}
>  	raise_softirq_irqoff(TASKLET_SOFTIRQ);
>  
>  	if (&per_cpu(tasklet_hi_vec, cpu).head != per_cpu(tasklet_hi_vec, cpu).tail) {
> -		*__get_cpu_var(tasklet_hi_vec).tail = per_cpu(tasklet_hi_vec, cpu).head;
> -		__get_cpu_var(tasklet_hi_vec).tail = per_cpu(tasklet_hi_vec, cpu).tail;
> +		*__this_cpuo_read(tasklet_hi_vec.tail) = per_cpu(tasklet_hi_vec, cpu).head;
> +		__this_cpu_write(tasklet_hi_vec.tail, per_cpu(tasklet_hi_vec, cpu).tail;

I don't think __this_cpuo_read() would build.

-- 
tejun
