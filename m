Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756004Ab2HTNro (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 09:47:44 -0400
Received: from mail.x86-64.org ([217.9.48.20]:51863 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755576Ab2HTNrm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 09:47:42 -0400
Date: Mon, 20 Aug 2012 15:47:32 +0200
From: Borislav Petkov <bp@amd64.org>
To: Fenghua Yu <fenghua.yu@intel.com>
Cc: H Peter Anvin <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Asit K Mallick <asit.k.mallick@intel.com>,
        Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>
Subject: Re: [PATCH 03/11] x86/microcode_intel.h: Define functions and macros
 for early load ucode
Message-ID: <20120820134732.GB24149@aftab.osrc.amd.com>
References: <1345277729-8399-1-git-send-email-fenghua.yu@intel.com>
 <1345277729-8399-4-git-send-email-fenghua.yu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1345277729-8399-4-git-send-email-fenghua.yu@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 18, 2012 at 01:15:21AM -0700, Fenghua Yu wrote:
> From: Fenghua Yu <fenghua.yu@intel.com>
> 
> Define some functions and macros that will be used in early load ucode. Some of
> them are moved from microcode_intel.c driver in order to be called in early
> boot phase before module can be called.
> 
> Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
> ---
>  arch/x86/include/asm/microcode_intel.h |  103 ++++++++++++++++++
>  arch/x86/kernel/Makefile               |    3 +
>  arch/x86/kernel/microcode_core.c       |    7 +-
>  arch/x86/kernel/microcode_intel.c      |  185 ++------------------------------
>  4 files changed, 117 insertions(+), 181 deletions(-)

[ … ]

> -static int microcode_sanity_check(void *mc)
> -{
> -	unsigned long total_size, data_size, ext_table_size;
> -	struct microcode_header_intel *mc_header = mc;
> -	struct extended_sigtable *ext_header = NULL;
> -	int sum, orig_sum, ext_sigcount = 0, i;
> -	struct extended_signature *ext_sig;
> -
> -	total_size = get_totalsize(mc_header);
> -	data_size = get_datasize(mc_header);
> -
> -	if (data_size + MC_HEADER_SIZE > total_size) {
> -		pr_err("error! Bad data size in microcode data file\n");
> -		return -EINVAL;
> -	}
> -
> -	if (mc_header->ldrver != 1 || mc_header->hdrver != 1) {
> -		pr_err("error! Unknown microcode update format\n");
> -		return -EINVAL;
> -	}
> -	ext_table_size = total_size - (MC_HEADER_SIZE + data_size);
> -	if (ext_table_size) {
> -		if ((ext_table_size < EXT_HEADER_SIZE)
> -		 || ((ext_table_size - EXT_HEADER_SIZE) % EXT_SIGNATURE_SIZE)) {
> -			pr_err("error! Small exttable size in microcode data file\n");
> -			return -EINVAL;
> -		}
> -		ext_header = mc + MC_HEADER_SIZE + data_size;
> -		if (ext_table_size != exttable_size(ext_header)) {
> -			pr_err("error! Bad exttable size in microcode data file\n");
> -			return -EFAULT;
> -		}
> -		ext_sigcount = ext_header->count;
> -	}
> -
> -	/* check extended table checksum */
> -	if (ext_table_size) {
> -		int ext_table_sum = 0;
> -		int *ext_tablep = (int *)ext_header;
> -
> -		i = ext_table_size / DWSIZE;
> -		while (i--)
> -			ext_table_sum += ext_tablep[i];
> -		if (ext_table_sum) {
> -			pr_warning("aborting, bad extended signature table checksum\n");
> -			return -EINVAL;
> -		}
> -	}
> -
> -	/* calculate the checksum */
> -	orig_sum = 0;
> -	i = (MC_HEADER_SIZE + data_size) / DWSIZE;
> -	while (i--)
> -		orig_sum += ((int *)mc)[i];
> -	if (orig_sum) {
> -		pr_err("aborting, bad checksum\n");
> -		return -EINVAL;
> -	}
> -	if (!ext_table_size)
> -		return 0;
> -	/* check extended signature checksum */
> -	for (i = 0; i < ext_sigcount; i++) {
> -		ext_sig = (void *)ext_header + EXT_HEADER_SIZE +
> -			  EXT_SIGNATURE_SIZE * i;
> -		sum = orig_sum
> -			- (mc_header->sig + mc_header->pf + mc_header->cksum)
> -			+ (ext_sig->sig + ext_sig->pf + ext_sig->cksum);
> -		if (sum) {
> -			pr_err("aborting, bad checksum\n");
> -			return -EINVAL;
> -		}
> -	}
> -	return 0;
> -}

This patch introduces a build error:

In file included from arch/x86/kernel/microcode_intel.c:82:0:
/usr/src/linux/linux-2.6/arch/x86/include/asm/microcode_intel.h:81:14: warning: ‘struct mc_saved_data’ declared inside parameter list [enabled by default]
/usr/src/linux/linux-2.6/arch/x86/include/asm/microcode_intel.h:81:14: warning: its scope is only this definition or declaration, which is probably not what you want [enabled by default]
/usr/src/linux/linux-2.6/arch/x86/include/asm/microcode_intel.h:98:14: warning: ‘struct mc_saved_data’ declared inside parameter list [enabled by default]
ERROR: "get_matching_microcode" [arch/x86/kernel/microcode.ko] undefined!
ERROR: "microcode_sanity_check" [arch/x86/kernel/microcode.ko] undefined!
make[1]: *** [__modpost] Error 1
make: *** [modules] Error 2
make: *** Waiting for unfinished jobs....

due to the removal of the two functions.

> -
> -/*
> - * return 0 - no update found
> - * return 1 - found update
> - */
> -static int
> -get_matching_microcode(struct cpu_signature *cpu_sig, void *mc, int rev)
> -{
> -	struct microcode_header_intel *mc_header = mc;
> -	struct extended_sigtable *ext_header;
> -	unsigned long total_size = get_totalsize(mc_header);
> -	int ext_sigcount, i;
> -	struct extended_signature *ext_sig;
> -
> -	if (!update_match_revision(mc_header, rev))
> -		return 0;
> -
> -	if (update_match_cpu(cpu_sig, mc_header->sig, mc_header->pf))
> -		return 1;
> -
> -	/* Look for ext. headers: */
> -	if (total_size <= get_datasize(mc_header) + MC_HEADER_SIZE)
> -		return 0;
> -
> -	ext_header = mc + get_datasize(mc_header) + MC_HEADER_SIZE;
> -	ext_sigcount = ext_header->count;
> -	ext_sig = (void *)ext_header + EXT_HEADER_SIZE;
> -
> -	for (i = 0; i < ext_sigcount; i++) {
> -		if (update_match_cpu(cpu_sig, ext_sig->sig, ext_sig->pf))
> -			return 1;
> -		ext_sig++;
> -	}
> -	return 0;
> -}
> -
> -static int apply_microcode(int cpu)
> +int apply_microcode(int cpu)
>  {
>  	struct microcode_intel *mc_intel;
>  	struct ucode_cpu_info *uci;
> @@ -338,6 +164,7 @@ static enum ucode_state generic_load_microcode(int cpu, void *data, size_t size,
>  	unsigned int leftover = size;
>  	enum ucode_state state = UCODE_OK;
>  	unsigned int curr_mc_size = 0;
> +	unsigned int csig, cpf;
>  
>  	while (leftover) {
>  		struct microcode_header_intel mc_header;
> @@ -362,11 +189,13 @@ static enum ucode_state generic_load_microcode(int cpu, void *data, size_t size,
>  		}
>  
>  		if (get_ucode_data(mc, ucode_ptr, mc_size) ||
> -		    microcode_sanity_check(mc) < 0) {
> +		    microcode_sanity_check(mc, 1) < 0) {
>  			break;
>  		}
>  
> -		if (get_matching_microcode(&uci->cpu_sig, mc, new_rev)) {
> +		csig = uci->cpu_sig.sig;
> +		cpf = uci->cpu_sig.pf;
> +		if (get_matching_microcode(csig, cpf, mc, new_rev)) {
>  			vfree(new_mc);
>  			new_rev = mc_header.rev;
>  			new_mc  = mc;
> -- 
> 1.7.2
> 
> 

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
