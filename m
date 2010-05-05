Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757796Ab0EESdo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 14:33:44 -0400
Received: from mail-va3.bigfish.com ([216.32.180.112]:35748 "EHLO
	mail100-va3-R.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753028Ab0EESdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 14:33:43 -0400
X-Greylist: delayed 1852 seconds by postgrey-1.27 at vger.kernel.org; Wed, 05 May 2010 14:33:43 EDT
X-SpamScore: -15
X-BigFish: VPS-15(zz1102K1432P936eMab9bhzz1202hzz6ff19h6d525hz32i2a8h43h62h)
X-Spam-TCS-SCL: 1:0
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-WSS-ID: 0L1YKSC-02-0IR-02
X-M-MSG: 
Date: Wed, 5 May 2010 20:02:28 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: Jiri Kosina <jkosina@suse.cz>
CC: Greg KH <gregkh@suse.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "stable@kernel.org" <stable@kernel.org>,
       "stable-review@kernel.org" <stable-review@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Renninger <trenn@suse.de>,
       Jiri Benc <jbenc@suse.cz>,
       "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>,
       "Ostrovsky, Boris" <Boris.Ostrovsky@amd.com>
Subject: Re: [113/197] x86, cacheinfo: Calculate L3 indices
Message-ID: <20100505180228.GC15804@aftab>
References: <20100422190917.467545308@kvm.kroah.org>
 <alpine.LNX.2.00.1005051736080.9849@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1005051736080.9849@pobox.suse.cz>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Kosina <jkosina@suse.cz>
Date: Wed, May 05, 2010 at 12:26:19PM -0400

> Please consider applying the patch below, both for 2.6.34 and all the 
> -stable kernels this patch has hit.
> 
> 
> 
> From: Jiri Kosina <jkosina@suse.cz>
> Subject: [PATCH] x86, cacheinfo: fix oops in amd_calc_l3_indices()
> 
> Commit 048a8774ca4348 ("x86, cacheinfo: Calculate L3 indices") introduced
> amd_calc_l3_indices(), but this function doesn't properly handle case
> when node_to_k8_nb_misc() returns NULL, causing immediate oops due to
> NULL pointer dereference in pci_read_config_dword().
> 
> Make amd_calc_l3_indices() return -1 in such cases. This is correct
> lower bound, as it will make store_cache_disable() return EINVAL in
> all such cases.
> 
> Cc: stable@kernel.org
> Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> ---
>  arch/x86/kernel/cpu/intel_cacheinfo.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
> index b3eeb66..b9f8dca 100644
> --- a/arch/x86/kernel/cpu/intel_cacheinfo.c
> +++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
> @@ -314,6 +314,9 @@ static unsigned int __cpuinit amd_calc_l3_indices(void)
>  	unsigned int sc0, sc1, sc2, sc3;
>  	u32 val = 0;
>  
> +	if (!dev)
> +		return -1;
> +

This won't fly since the function returns an unsigned value and the L3
code would still be entered, which is what you don't want actually when
k8_northbridges initialization has somehow failed.

Rather, we have a fix already which should take care of your issue too,
see http://git.kernel.org/tip/f2b20e41407fccfcfacf927ff91ec888832a37af

I was waiting for it to hit mainline before I backport it to stable and
it would be helpful if you could verify that it works for you along with
0e152cd7c16832bd5cadee0c2e41d9959bc9b6f9 you sent earlier.

Thanks.

-- 
Regards/Gruss,
Boris.

--
Advanced Micro Devices, Inc.
Operating Systems Research Center

