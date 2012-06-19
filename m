Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645Ab2FSSb4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 14:31:56 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:34154 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752858Ab2FSSbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 14:31:51 -0400
X-Sasl-enc: 70KgiJieHEbwMzvtKMDuYeSenmp977LypxZOvuEVWEhN 1340130330
Date: Tue, 19 Jun 2012 15:25:27 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Borislav Petkov <bp@amd64.org>
Cc: X86-ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Peter Zijlstra <peterz@infradead.org>, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] x86, microcode: Sanitize per-cpu microcode
 reloading interface
Message-ID: <20120619182526.GB18816@khazad-dum.debian.net>
References: <1340121811-4477-1-git-send-email-bp@amd64.org>
 <1340121811-4477-2-git-send-email-bp@amd64.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340121811-4477-2-git-send-email-bp@amd64.org>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Jun 2012, Borislav Petkov wrote:
> From: Borislav Petkov <borislav.petkov@amd.com>
> 
> Microcode reloading in a per-core manner is a very bad idea for both
> major x86 vendors. And the thing is, we have such interface with which
> we can end up with different microcode versions applied on different
> cores of an otherwise homogeneous wrt (family,model,stepping) system.
> 
> So turn off the possibility of doing that per core and allow it only
> system-wide.
> 
> This is a minimal fix which we'd like to see in stable too thus the
> more-or-less arbitrary decision to allow system-wide reloading only on
> the BSP:
> 
> $ echo 1 > /sys/devices/system/cpu/cpu0/microcode/reload
> ...
> 
> and disable the interface on the other cores:
> 
> $ echo 1 > /sys/devices/system/cpu/cpu23/microcode/reload
> -bash: echo: write error: Invalid argument
> 
> Also, allowing the reload only from one CPU (the BSP in
> that case) doesn't allow the reload procedure to degenerate
> into an O(n^2) deal when triggering reloads from all
> /sys/devices/system/cpu/cpuX/microcode/reload sysfs nodes
> simultaneously.
> 
> A more generic fix will follow.
> 
> Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: stable@vger.kernel.org
> Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>

Tested-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>

Tested on Intel Xeon X5550.  Tested as a (trivial) 3.0-stable backport.

> ---
>  arch/x86/kernel/microcode_core.c | 26 +++++++++++++++++++-------
>  1 file changed, 19 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kernel/microcode_core.c b/arch/x86/kernel/microcode_core.c
> index fbdfc6917180..24b852b61be3 100644
> --- a/arch/x86/kernel/microcode_core.c
> +++ b/arch/x86/kernel/microcode_core.c
> @@ -298,19 +298,31 @@ static ssize_t reload_store(struct device *dev,
>  			    const char *buf, size_t size)
>  {
>  	unsigned long val;
> -	int cpu = dev->id;
> -	ssize_t ret = 0;
> +	int cpu;
> +	ssize_t ret = 0, tmp_ret;
> +
> +	/* allow reload only from the BSP */
> +	if (boot_cpu_data.cpu_index != dev->id)
> +		return -EINVAL;
>  
>  	ret = kstrtoul(buf, 0, &val);
>  	if (ret)
>  		return ret;
>  
> -	if (val == 1) {
> -		get_online_cpus();
> -		if (cpu_online(cpu))
> -			ret = reload_for_cpu(cpu);
> -		put_online_cpus();
> +	if (val != 1)
> +		return size;
> +
> +	get_online_cpus();
> +	for_each_online_cpu(cpu) {
> +		tmp_ret = reload_for_cpu(cpu);
> +		if (tmp_ret != 0)
> +			pr_warn("Error reloading microcode on CPU %d\n", cpu);
> +
> +		/* save retval of the first encountered reload error */
> +		if (!ret)
> +			ret = tmp_ret;
>  	}
> +	put_online_cpus();
>  
>  	if (!ret)
>  		ret = size;

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
