Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753514Ab2KTPB0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 10:01:26 -0500
Received: from mail.skyhub.de ([78.46.96.112]:43558 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753425Ab2KTPBY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 10:01:24 -0500
Date: Tue, 20 Nov 2012 16:01:18 +0100
From: Borislav Petkov <bp@alien8.de>
To: Daniel J Blueman <daniel@numascale-asia.com>
Cc: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        H Peter Anvin <hpa@zytor.com>, Steffen Persvold <sp@numascale.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3, v3] AMD64 EDAC: Support >255 memory controllers
Message-ID: <20121120150117.GD28594@x1.alien8.de>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Daniel J Blueman <daniel@numascale-asia.com>,
	Ingo Molnar <mingo@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>, H Peter Anvin <hpa@zytor.com>,
	Steffen Persvold <sp@numascale.com>, x86@kernel.org,
	linux-kernel@vger.kernel.org
References: <1353319368-9179-1-git-send-email-daniel@numascale-asia.com>
 <1353319368-9179-2-git-send-email-daniel@numascale-asia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1353319368-9179-2-git-send-email-daniel@numascale-asia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 19, 2012 at 06:02:47PM +0800, Daniel J Blueman wrote:
> As the AMD64 last-level-cache ID is 16-bits and federated systems
> eg using Numascale's NumaConnect/NumaChip can have more than 255 memory
> controllers, use 16-bits to store the ID.
> 
> v2: Avoid change to intlv_en variable
> v3: Drop unneeded change to index
> 
> Signed-off-by: Daniel J Blueman <daniel@numascale-asia.com>
> ---
>  drivers/edac/amd64_edac.c |   17 +++++++++--------
>  1 file changed, 9 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
> index 8de8873..6e3f002 100644
> --- a/drivers/edac/amd64_edac.c
> +++ b/drivers/edac/amd64_edac.c
> @@ -942,7 +942,8 @@ static u64 get_error_address(struct mce *m)
>  		struct amd64_pvt *pvt;
>  		u64 cc6_base, tmp_addr;
>  		u32 tmp;
> -		u8 mce_nid, intlv_en;
> +		u16 mce_nid;

Same here: this change needs to go together with the patch doing:

-extern int amd_get_nb_id(int cpu);
+extern u16 amd_get_nb_id(int cpu);

Please make sure you have all changes belonging semantically and
logically together in one patch.

> +		u8 intlv_en;
>  
>  		if ((addr & GENMASK(24, 47)) >> 24 != 0x00fdf7)
>  			return addr;
> @@ -2298,7 +2299,7 @@ out:
>  	return ret;
>  }
>  
> -static int toggle_ecc_err_reporting(struct ecc_settings *s, u8 nid, bool on)
> +static int toggle_ecc_err_reporting(struct ecc_settings *s, u16 nid, bool on)

So this u16 nid is being passed as arg to get_cpus_on_this_dct_cpumask()
which does amd_get_nb_id but it's arg is still "unsigned".

So here's how your patchset should look like:

patch 1: add amd_get_node_id() and change all its callsites
patch 2: change amd_get_nb_id() to return u16 and change all its callsites
patch 3: other required changes
patch 4: maybe other unrelated stuff

This way you it is easier to review and to follow 1,2,3,5 years from now
why the changes were done.

>  {
>  	cpumask_var_t cmask;
>  	int cpu;
> @@ -2336,7 +2337,7 @@ static int toggle_ecc_err_reporting(struct ecc_settings *s, u8 nid, bool on)
>  	return 0;
>  }
>  
> -static bool enable_ecc_error_reporting(struct ecc_settings *s, u8 nid,
> +static bool enable_ecc_error_reporting(struct ecc_settings *s, u16 nid,
>  				       struct pci_dev *F3)
>  {
>  	bool ret = true;
> @@ -2388,7 +2389,7 @@ static bool enable_ecc_error_reporting(struct ecc_settings *s, u8 nid,
>  	return ret;
>  }
>  
> -static void restore_ecc_error_reporting(struct ecc_settings *s, u8 nid,
> +static void restore_ecc_error_reporting(struct ecc_settings *s, u16 nid,
>  					struct pci_dev *F3)
>  {
>  	u32 value, mask = 0x3;		/* UECC/CECC enable */
> @@ -2427,7 +2428,7 @@ static const char *ecc_msg =
>  	"'ecc_enable_override'.\n"
>  	" (Note that use of the override may cause unknown side effects.)\n";
>  
> -static bool ecc_enabled(struct pci_dev *F3, u8 nid)
> +static bool ecc_enabled(struct pci_dev *F3, u16 nid)
>  {
>  	u32 value;
>  	u8 ecc_en = 0;
> @@ -2548,7 +2549,7 @@ static int amd64_init_one_instance(struct pci_dev *F2)
>  	struct mem_ctl_info *mci = NULL;
>  	struct edac_mc_layer layers[2];
>  	int err = 0, ret;
> -	u8 nid = amd_get_node_id(F2);
> +	u16 nid = amd_get_node_id(F2);

This change should conceptually belong with the patch adding amd_get_node_id.

>  
>  	ret = -ENOMEM;
>  	pvt = kzalloc(sizeof(struct amd64_pvt), GFP_KERNEL);
> @@ -2639,7 +2640,7 @@ err_ret:
>  static int __devinit amd64_probe_one_instance(struct pci_dev *pdev,
>  					     const struct pci_device_id *mc_type)
>  {
> -	u8 nid = amd_get_node_id(pdev);
> +	u16 nid = amd_get_node_id(pdev);

ditto.

>  	struct pci_dev *F3 = node_to_amd_nb(nid)->misc;
>  	struct ecc_settings *s;
>  	int ret = 0;
> @@ -2689,7 +2690,7 @@ static void __devexit amd64_remove_one_instance(struct pci_dev *pdev)
>  {
>  	struct mem_ctl_info *mci;
>  	struct amd64_pvt *pvt;
> -	u8 nid = amd_get_node_id(pdev);
> +	u16 nid = amd_get_node_id(pdev);

ditto.

>  	struct pci_dev *F3 = node_to_amd_nb(nid)->misc;
>  	struct ecc_settings *s = ecc_stngs[nid];

Thanks.

-- 
Regards/Gruss,
Boris.
