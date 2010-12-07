Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754257Ab0LGPJg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 10:09:36 -0500
Received: from hera.kernel.org ([140.211.167.34]:33532 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753422Ab0LGPJf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 10:09:35 -0500
Message-ID: <4CFE4DDF.7010104@kernel.org>
Date: Tue, 07 Dec 2010 16:08:15 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: akpm@linux-foundation.org, Scott James Remnant <scott@ubuntu.com>,
        Mike Frysinger <vapier@gentoo.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [Use cpuops V1 09/11] Connector: Use this_cpu operations
References: <20101206171618.302060721@linux.com> <20101206171641.471462516@linux.com>
In-Reply-To: <20101206171641.471462516@linux.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 07 Dec 2010 15:08:17 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06/2010 06:16 PM, Christoph Lameter wrote:
> get_seq can benefit from this_cpu_operations. Address calculation is avoided
> and the increment is done using an xadd.
> 
> Cc: Scott James Remnant <scott@ubuntu.com>
> Cc: Mike Frysinger <vapier@gentoo.org>
> Signed-off-by: Christoph Lameter <cl@linux.com>
> 
> ---
>  drivers/connector/cn_proc.c |    5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> Index: linux-2.6/drivers/connector/cn_proc.c
> ===================================================================
> --- linux-2.6.orig/drivers/connector/cn_proc.c	2010-11-30 09:38:33.000000000 -0600
> +++ linux-2.6/drivers/connector/cn_proc.c	2010-11-30 09:39:38.000000000 -0600
> @@ -43,9 +43,10 @@ static DEFINE_PER_CPU(__u32, proc_event_
>  
>  static inline void get_seq(__u32 *ts, int *cpu)
>  {
> -	*ts = get_cpu_var(proc_event_counts)++;
> +	preempt_disable();
> +	*ts = __this_cpu_inc(proc_event_counts);

Eh?  __this_cpu_inc() evaluates to the incremented value?

-- 
tejun
