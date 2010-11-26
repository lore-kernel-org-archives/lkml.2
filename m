Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755342Ab0KZQgC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 11:36:02 -0500
Received: from hera.kernel.org ([140.211.167.34]:60344 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752030Ab0KZQfw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 11:35:52 -0500
Message-ID: <4CEFE1CB.4050404@kernel.org>
Date: Fri, 26 Nov 2010 17:35:23 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: akpm@linux-foundation.org, Pekka Enberg <penberg@cs.helsinki.fi>,
        linux-kernel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [thiscpuops upgrade 05/10] x86: Use this_cpu_inc_return for nmi
 counter
References: <20101123235139.908255844@linux.com> <20101123235158.826005750@linux.com>
In-Reply-To: <20101123235158.826005750@linux.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 26 Nov 2010 16:35:25 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/24/2010 12:51 AM, Christoph Lameter wrote:
> this_cpu_inc_return() saves us a memory access there.
> 
> Signed-off-by: Christoph Lameter <cl@linux.com>
> 
> ---
>  arch/x86/kernel/apic/nmi.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> Index: linux-2.6/arch/x86/kernel/apic/nmi.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/apic/nmi.c	2010-11-23 16:35:19.000000000 -0600
> +++ linux-2.6/arch/x86/kernel/apic/nmi.c	2010-11-23 16:38:29.000000000 -0600
> @@ -432,8 +432,7 @@ nmi_watchdog_tick(struct pt_regs *regs,
>  		 * Ayiee, looks like this CPU is stuck ...
>  		 * wait a few IRQs (5 seconds) before doing the oops ...
>  		 */
> -		__this_cpu_inc(alert_counter);
> -		if (__this_cpu_read(alert_counter) == 5 * nmi_hz)
> +		if (__this_cpu_inc_return(alert_counter) == 5 * nmi_hz)

Hmmm... one worry I have is that xadd, being not a very popular
operation, might be slower than add and read.  Using it for atomicity
would probably be beneficial in most cases but have you checked this
actually is cheaper?

Thanks.

-- 
tejun
