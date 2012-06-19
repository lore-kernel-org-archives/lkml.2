Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753393Ab2FSCm5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 22:42:57 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:45527 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751136Ab2FSCm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 22:42:56 -0400
X-Sasl-enc: zSR83CrUVpANQE8tdxigKt+5LnIC3KEjyQKKrhJoXM7c 1340073774
Date: Mon, 18 Jun 2012 23:42:50 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Borislav Petkov <bp@amd64.org>
Cc: LKML <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Dimitri Sivanich <sivanich@sgi.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        Greg Kroah-Hartman <greg@kroah.com>
Subject: Re: [PATCH] perf/x86: check ucode before disabling PEBS on
 SandyBridge
Message-ID: <20120619024250.GA6186@khazad-dum.debian.net>
References: <20120612171734.GI8404@aftab.osrc.amd.com>
 <1339521493.31548.93.camel@twins>
 <20120612172352.GA4802@aftab.osrc.amd.com>
 <1339521996.31548.95.camel@twins>
 <20120612173506.GB4802@aftab.osrc.amd.com>
 <20120613010413.GA28174@khazad-dum.debian.net>
 <20120613065119.GB15661@aftab.osrc.amd.com>
 <20120613123649.GA26012@khazad-dum.debian.net>
 <20120613161139.GA18450@aftab.osrc.amd.com>
 <20120615123749.GC6083@aftab.osrc.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120615123749.GC6083@aftab.osrc.amd.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Jun 2012, Borislav Petkov wrote:
> From: Borislav Petkov <borislav.petkov@amd.com>
> Date: Fri, 15 Jun 2012 14:19:55 +0200
> Subject: [PATCH] x86, microcode: Sanitize per-cpu microcode reloading
>  interface
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
> A more generic fix will follow.
> 
> Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
> Cc: stable@vger.kernel.org
> Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>

Tested-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>

I've actually backported this to 3.0 (trivial) and tested it there.

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
