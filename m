Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752797Ab2HCJEN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 05:04:13 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:46561 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752557Ab2HCJEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 05:04:10 -0400
X-Authenticated: #28250155
X-Provags-ID: V01U2FsdGVkX18hI40Qh7Eh0zEzywKV8zN80sPEC+CyBppMYmO5Dc
	joikRYXagoeuZC
From: Sven Joachim <svenjoac@gmx.de>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Borislav Petkov <borislav.petkov@amd.com>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [ 33/73] x86, microcode: Sanitize per-cpu microcode reloading interface
References: <20120731044310.013763753@decadent.org.uk>
	<20120731044316.585695559@decadent.org.uk>
Date: Fri, 03 Aug 2012 11:04:06 +0200
In-Reply-To: <20120731044316.585695559@decadent.org.uk> (Ben Hutchings's
	message of "Tue, 31 Jul 2012 05:43:43 +0100")
Message-ID: <87y5lw73eh.fsf@turtle.gmx.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-07-31 06:43 +0200, Ben Hutchings wrote:

> 3.2-stable review patch.  If anyone has any objections, please let me know.

Alas, this does not build if CONFIG_SMP is unset:

,----
| arch/x86/kernel/microcode_core.c: In function 'reload_store':
| arch/x86/kernel/microcode_core.c:304:19: error: 'struct cpuinfo_x86' has no member named 'cpu_index'
`----

Cheers,
       Sven


> From: Borislav Petkov <borislav.petkov@amd.com>
>
> commit c9fc3f778a6a215ace14ee556067c73982b6d40f upstream.
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
> Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
> Link: http://lkml.kernel.org/r/1340280437-7718-2-git-send-email-bp@amd64.org
> Signed-off-by: H. Peter Anvin <hpa@zytor.com>
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> ---
>  arch/x86/kernel/microcode_core.c |   26 +++++++++++++++++++-------
>  1 file changed, 19 insertions(+), 7 deletions(-)
>
> diff --git a/arch/x86/kernel/microcode_core.c b/arch/x86/kernel/microcode_core.c
> index fbdfc69..24b852b 100644
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
