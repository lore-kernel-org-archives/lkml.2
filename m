Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754939Ab2FSXP7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 19:15:59 -0400
Received: from mga14.intel.com ([143.182.124.37]:33494 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751623Ab2FSXP6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 19:15:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="113971180"
From: "Yu, Fenghua" <fenghua.yu@intel.com>
To: X86-ML <x86@kernel.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Peter Zijlstra <peterz@infradead.org>
Subject: RE: [PATCH 1/2] x86, microcode: Sanitize per-cpu microcode
 reloading interface
Thread-Topic: [PATCH 1/2] x86, microcode: Sanitize per-cpu microcode
 reloading interface
Thread-Index: AQHNTnDiqMXd/kEv8ESer2bZVn7a/5cCRPNg
Date: Tue, 19 Jun 2012 23:15:56 +0000
Message-ID: <3E5A0FA7E9CA944F9D5414FEC6C712200773763E@ORSMSX105.amr.corp.intel.com>
References: <1340121811-4477-1-git-send-email-bp@amd64.org>
	<1340121811-4477-2-git-send-email-bp@amd64.org>
 <CANDHA0iu+QtQn=UxjpN34U=Ob4ABkZc4VWpPT5EidAgZm59JJQ@mail.gmail.com>
In-Reply-To: <CANDHA0iu+QtQn=UxjpN34U=Ob4ABkZc4VWpPT5EidAgZm59JJQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Borislav Petkov <bp@amd64.org>
> Date: Tue, 19 Jun 2012 18:03:30 +0200
> Subject: [PATCH 1/2] x86, microcode: Sanitize per-cpu microcode
> reloading interface
> To: X86-ML <x86@kernel.org>
> Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
> Thomas Gleixner <tglx@linutronix.de>, LKML
> <linux-kernel@vger.kernel.org>, Andreas Herrmann
> <andreas.herrmann3@amd.com>, Borislav Petkov
> <borislav.petkov@amd.com>, Henrique de Moraes Holschuh
> <hmh@hmh.eng.br>, Peter Zijlstra <peterz@infradead.org>,
> stable@vger.kernel.org
> 
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
> ---
>  arch/x86/kernel/microcode_core.c | 26 +++++++++++++++++++-------
>  1 file changed, 19 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kernel/microcode_core.c
> b/arch/x86/kernel/microcode_core.c
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

With the /sys/devices/system/cpu/microcode/reload interface in your patch 2/2, this will be broken, right? With the new interface, reload_store() can be executed on any cpu or dev. I think you need to remove this check if working with the patch 2/2.

Thanks.

-Fenghua
