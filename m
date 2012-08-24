Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759747Ab2HXQIx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 12:08:53 -0400
Received: from mail.x86-64.org ([217.9.48.20]:51871 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755831Ab2HXQIu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 12:08:50 -0400
Date: Fri, 24 Aug 2012 18:08:38 +0200
From: Borislav Petkov <bp@amd64.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        andi@firstfloor.org
Subject: Re: [PATCH] perf/x86: fix microcode revision check for SNB-PEBS
Message-ID: <20120824160838.GC2297@aftab.osrc.amd.com>
References: <20120824133434.GA8014@quad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120824133434.GA8014@quad>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 24, 2012 at 03:34:34PM +0200, Stephane Eranian wrote:
> 
> The following patch, relative to 3.6.0-rc3, makes
> the microcode update code path actually invoke the
> perf_check_microcode() function and thus potentially
> renabling SNB PEBS.
> 
> By default, CONFIG_MICROCODE_OLD_INTERFACE is
> forced to Y in arch/x86/Kconfig. There is no
> way to disable this. That means that the code
> path used in arch/x86/kernel/microcode_core.c
> did not include the call to perf_check_microcode().
> 
> Thus, even though the microcode was updated to a
> version that fixes the SNB PEBS problem, perf_event
> would still return EOPNOTSUPP when enabling precise
> sampling.
> 
> This patch simply adds a call to perf_check_microcode()
> in the call path used when OLD_INTERFACE=y.

Ok, so c93dc84cbe324 added calls to perf_check_microcode but it looks
like you're updating the microcode from /dev/cpu/microcode, correct?

And if so, the old interface got missed.

Oh well, as long as we have to support it, we might as well add that
perf call there - it will go when the interface goes anyway so until
then:

Acked-by: Borislav Petkov <borislav.petkov@amd.com>

>
> Signed-off-by: Stephane Eranian <eranian@google.com>
> ---
> 
> --- a/arch/x86/kernel/microcode_core.c
> +++ b/arch/x86/kernel/microcode_core.c
> @@ -225,6 +225,9 @@ static ssize_t microcode_write(struct file *file, const char __user *buf,
>  	if (do_microcode_update(buf, len) == 0)
>  		ret = (ssize_t)len;
>  
> +	if (ret > 0)
> +		perf_check_microcode();
> +
>  	mutex_unlock(&microcode_mutex);
>  	put_online_cpus();
>  
> 

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
