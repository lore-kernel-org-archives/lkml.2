Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755359Ab1AKGzJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 01:55:09 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:39740 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752001Ab1AKGzC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 01:55:02 -0500
Date: Tue, 11 Jan 2011 07:55:40 +0100
From: Borislav Petkov <bp@amd64.org>
To: Mike Waychison <mikew@google.com>
Cc: "mingo@elte.hu" <mingo@elte.hu>,
        "rdunlap@xenotime.net" <rdunlap@xenotime.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH] x86: Add an option to disable decoding of MCE
Message-ID: <20110111065540.GA16036@aftab>
References: <43835.148.87.67.136.1294700112.squirrel@xenotime.net>
 <1294700597-24239-1-git-send-email-mikew@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294700597-24239-1-git-send-email-mikew@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 10, 2011 at 06:03:17PM -0500, Mike Waychison wrote:
> This patch applies to v2.6.37.
> 
> Updated with documentation of the new option.
> ---
> 
> On our systems, we do not want to have any "decoders" called on machine
> check events.  These decoders can easily spam our logs and cause space
> problems on machines that have a lot of correctable error events.  We
> _do_ however want to get the messages delivered via /dev/mcelog for
> userland processing.

Ok, question: how do you guys process DRAM ECCs? And more specifically,
with a large number of machines, how do you do the mapping from the DRAM
ECC error address reported by MCA to a DIMM that's failing in userspace
on a particular machine?

Also, I've worked on trimming down all that decoding output to 3-5
lines. Now it looks like this:

[  521.677316] [Hardware Error]: MC4_STATUS[Over|UE|MiscV|PCC|AddrV|UECC]: 0xfe00200000080a0f
[  521.686467] [Hardware Error]: Northbridge Error (node 0): DRAM ECC error detected on the NB.
[  521.686498] EDAC MC0: UE page 0x0, offset 0x0, grain 0, row 0, labels ":": amd64_edac
[  521.686501] EDAC MC0: UE - no information available: UE bit is set
[  521.686503] [Hardware Error]: cache level: L3/GEN, mem/io: GEN, mem-tx: GEN, part-proc: RES (no timeout)

and the two lines starting with "EDAC MC0" will get trimmed even
more with time. I'm assuming this is not a lot but if you get a lot
of correctable error events, then output like that accumulates over
time. How about an error thresholding scheme in software then which
accumulates the error events and reports only when some configurable
thresholds per DRAM device in error have been reached?

> Introduce an interface "dont_decode" that allows us to skip the
> decoders.  We always call the decoders by default.
> 
> Google-Bug-Id: 3289142
> Signed-off-by: Mike Waychison <mikew@google.com>
> ---
>  Documentation/x86/x86_64/boot-options.txt |    5 +++++
>  Documentation/x86/x86_64/machinecheck     |    6 ++++++
>  arch/x86/kernel/cpu/mcheck/mce.c          |   24 ++++++++++++++++++------
>  3 files changed, 29 insertions(+), 6 deletions(-)
> 
> diff --git a/Documentation/x86/x86_64/boot-options.txt b/Documentation/x86/x86_64/boot-options.txt
> index 7fbbaf8..dd7145a 100644
> --- a/Documentation/x86/x86_64/boot-options.txt
> +++ b/Documentation/x86/x86_64/boot-options.txt
> @@ -22,6 +22,11 @@ Machine check
>  		as corrected are silently cleared by OS.
>  		This option will be useful if you have no interest in any
>  		of corrected errors.
> +   mce=dont_decode
> +		Disable in-kernel decoding of errors.  Setting this boot
> +		option will cause EDAC to be skipped (if enabled) and no
> +		messages to be printed into the logs.  Events will still
> +		be available via /dev/mcelog however.
>     mce=ignore_ce
>  		Disable features for corrected errors, e.g. polling timer
>  		and CMCI.  All events reported as corrected are not cleared
> diff --git a/Documentation/x86/x86_64/machinecheck b/Documentation/x86/x86_64/machinecheck
> index b1fb302..7ef7003 100644
> --- a/Documentation/x86/x86_64/machinecheck
> +++ b/Documentation/x86/x86_64/machinecheck
> @@ -65,6 +65,12 @@ tolerant
>  	Note this only makes a difference if the CPU allows recovery
>  	from a machine check exception. Current x86 CPUs generally do not.
>  
> +dont_decode
> +	Disable in-kernel decoding of any errors.  Setting this boot
> +	option will cause EDAC to be skipped (if enabled) and no
> +	messages to be printed into the logs.  Events will still be
> +	available via /dev/mcelog however.
> +
>  trigger
>  	Program to run when a machine check event is detected.
>  	This is an alternative to running mcelog regularly from cron
> diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
> index 7a35b72..3c30057 100644
> --- a/arch/x86/kernel/cpu/mcheck/mce.c
> +++ b/arch/x86/kernel/cpu/mcheck/mce.c
> @@ -82,6 +82,7 @@ static int			mce_bootlog		__read_mostly = -1;
>  static int			monarch_timeout		__read_mostly = -1;
>  static int			mce_panic_timeout	__read_mostly;
>  static int			mce_dont_log_ce		__read_mostly;
> +static int			mce_dont_decode		__read_mostly;
>  int				mce_cmci_disabled	__read_mostly;
>  int				mce_ignore_ce		__read_mostly;
>  int				mce_ser			__read_mostly;
> @@ -209,6 +210,17 @@ void mce_log(struct mce *mce)
>  	set_bit(0, &mce_need_notify);
>  }
>  
> +static void call_decoders(struct mce *m)

Yeah, let's call this decode_mce().

> +{
> +	if (mce_dont_decode)
> +		return;
> +	/*
> +	 * Print out human-readable details about the MCE error,
> +	 * (if the CPU has an implementation for that)
> +	 */
> +	atomic_notifier_call_chain(&x86_mce_decoder_chain, 0, m);
> +}
> +
>  static void print_mce(struct mce *m)
>  {
>  	pr_emerg(HW_ERR "CPU %d: Machine Check Exception: %Lx Bank %d: %016Lx\n",
> @@ -234,11 +246,7 @@ static void print_mce(struct mce *m)
>  	pr_emerg(HW_ERR "PROCESSOR %u:%x TIME %llu SOCKET %u APIC %x\n",
>  		m->cpuvendor, m->cpuid, m->time, m->socketid, m->apicid);
>  
> -	/*
> -	 * Print out human-readable details about the MCE error,
> -	 * (if the CPU has an implementation for that)
> -	 */
> -	atomic_notifier_call_chain(&x86_mce_decoder_chain, 0, m);
> +	call_decoders(m);
>  }
>  
>  #define PANIC_TIMEOUT 5 /* 5 seconds */
> @@ -588,7 +596,7 @@ void machine_check_poll(enum mcp_flags flags, mce_banks_t *b)
>  		 */
>  		if (!(flags & MCP_DONTLOG) && !mce_dont_log_ce) {
>  			mce_log(&m);

Also, there's another hook in the function above that does
edac_mce_parse(mce) (which shouldnt've been there actually) which is
used by the Nehalem driver i7core_edac which does also decode DRAM ECCs.

@Mauro: how about dropping the whole <drivers/edac/edac_mce.c> and using
a simple notifier which is much smaller in code and does the same thing?

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
