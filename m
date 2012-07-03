Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752448Ab2GCEh1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 00:37:27 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:42724 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760Ab2GCEhZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 00:37:25 -0400
Date: Tue, 3 Jul 2012 06:37:17 +0200
From: Borislav Petkov <bp@amd64.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Borislav Petkov <bp@amd64.org>, X86-ML <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH -v2 1/2] x86, microcode: Sanitize per-cpu microcode
 reloading interface
Message-ID: <20120703043717.GB8860@aftab.osrc.amd.com>
References: <1340280437-7718-1-git-send-email-bp@amd64.org>
 <1340280437-7718-2-git-send-email-bp@amd64.org>
 <1340380019.18025.82.camel@twins>
 <20120626194043.GB28495@aftab.osrc.amd.com>
 <1340747178.21991.105.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340747178.21991.105.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 26, 2012 at 11:46:18PM +0200, Peter Zijlstra wrote:
> --- a/arch/x86/kernel/microcode_core.c
> +++ b/arch/x86/kernel/microcode_core.c
> @@ -87,6 +87,7 @@
>  #include <asm/microcode.h>
>  #include <asm/processor.h>
>  #include <asm/cpu_device_id.h>
> +#include <asm/perf_event.h>
>  
>  MODULE_DESCRIPTION("Microcode Update Driver");
>  MODULE_AUTHOR("Tigran Aivazian <tigran@aivazian.fsnet.co.uk>");
> @@ -277,7 +278,6 @@ static int reload_for_cpu(int cpu)
>  	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
>  	int err = 0;
>  
> -	mutex_lock(&microcode_mutex);
>  	if (uci->valid) {
>  		enum ucode_state ustate;
>  
> @@ -288,7 +288,6 @@ static int reload_for_cpu(int cpu)
>  			if (ustate == UCODE_ERROR)
>  				err = -EINVAL;
>  	}
> -	mutex_unlock(&microcode_mutex);
>  
>  	return err;
>  }
> @@ -309,6 +308,7 @@ static ssize_t reload_store(struct devic
>  		return size;
>  
>  	get_online_cpus();
> +	mutex_lock(&microcode_mutex);
>  	for_each_online_cpu(cpu) {
>  		tmp_ret = reload_for_cpu(cpu);
>  		if (tmp_ret != 0)
> @@ -318,6 +318,9 @@ static ssize_t reload_store(struct devic
>  		if (!ret)
>  			ret = tmp_ret;
>  	}
> +	if (!ret)
> +		perf_check_microcode();
> +	mutex_unlock(&microcode_mutex);

In thinking about this a bit more, perf callback is only run from the
reload_store interface but we don't run it on module init time.

In the situation where perf is enabled, _then_ the microcode driver
is loaded as a module later, we don't get to run the callback
perf_check_microcode() even when we're loading the module and there's
new ucode on the system.

Maybe this needs to be called additionally in microcode_init() after
subsys_interface_register call which does microcode_init_cpu down its
path and should have updated the microcode when it is done registering
all the cpus...

Hmm.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
