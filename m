Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755046Ab2LRRTV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 12:19:21 -0500
Received: from mail.skyhub.de ([78.46.96.112]:42607 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751271Ab2LRRTT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 12:19:19 -0500
Date: Tue, 18 Dec 2012 18:19:15 +0100
From: Borislav Petkov <bp@alien8.de>
To: Jacob Shin <jacob.shin@amd.com>
Cc: Doug Thompson <dougthompson@xmission.com>, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] MCE, AMD: MCE decoding support for AMD Family 16h
Message-ID: <20121218171915.GE31255@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Jacob Shin <jacob.shin@amd.com>,
	Doug Thompson <dougthompson@xmission.com>,
	linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1355773188-5241-1-git-send-email-jacob.shin@amd.com>
 <1355773188-5241-2-git-send-email-jacob.shin@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1355773188-5241-2-git-send-email-jacob.shin@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 17, 2012 at 01:39:48PM -0600, Jacob Shin wrote:
> Add MCE decoding logic for AMD Family 16h processors.
> 
> Signed-off-by: Jacob Shin <jacob.shin@amd.com>
> ---
>  drivers/edac/mce_amd.c |  120 ++++++++++++++++++++++++++++++++++++++++++++++--
>  drivers/edac/mce_amd.h |    6 +++
>  2 files changed, 122 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/edac/mce_amd.c b/drivers/edac/mce_amd.c
> index 84320f9..7d2d037 100644
> --- a/drivers/edac/mce_amd.c
> +++ b/drivers/edac/mce_amd.c
> @@ -64,6 +64,10 @@ EXPORT_SYMBOL_GPL(to_msgs);
>  const char * const ii_msgs[] = { "MEM", "RESV", "IO", "GEN" };
>  EXPORT_SYMBOL_GPL(ii_msgs);
>  
> +/* internal error type */
> +const char * const uu_msgs[] = { "RESV", "RESV", "HWA", "RESV" };
> +EXPORT_SYMBOL_GPL(uu_msgs);

Seems like those aren't used anywhere?

>  static const char * const f15h_mc1_mce_desc[] = {
>  	"UC during a demand linefill from L2",
>  	"Parity error during data load from IC",
> @@ -275,6 +279,23 @@ static bool f15h_mc0_mce(u16 ec, u8 xec)
>  	return ret;
>  }
>  
> +static bool f16h_mc0_mce(u16 ec, u8 xec)
> +{
> +	u8 r4 = R4(ec);
> +
> +	if (MEM_ERROR(ec) && TT(ec) == TT_DATA && LL(ec) == LL_L1 &&
> +	    (r4 == R4_DRD || r4 == R4_DWR)) {
> +
> +		pr_cont("%s parity error due to %s.\n",
> +			(xec == 0x0    ? "Data" : "Tag"),
> +			(r4  == R4_DRD ? "load" : "store"));
> +
> +		return true;
> +	}
> +
> +	return f14h_mc0_mce(ec, xec);

Looks like this could be merged with f14h_mc0_mce no? You can call the
function then cat_mc0_mce (for all the *cat cores) and assign it to
fam_ops->mc0_mce in the f14h and f16h case.

> +}
> +
>  static void decode_mc0_mce(struct mce *m)
>  {
>  	u16 ec = EC(m->status);
> @@ -379,6 +400,36 @@ static bool f15h_mc1_mce(u16 ec, u8 xec)
>  	return ret;
>  }
>  
> +static bool f16h_mc1_mce(u16 ec, u8 xec)
> +{
> +	u8 r4    = R4(ec);
> +	bool ret = true;
> +
> +	if (MEM_ERROR(ec)) {
> +		if (TT(ec) != TT_INSTR)
> +			ret = false;
> +
> +		else if (r4 == R4_IRD)
> +			pr_cont("%s array parity error for a tag hit.\n",
> +				(xec == 0x0 ? "Data" : "Tag"));
> +
> +		else if (r4 == R4_SNOOP)
> +			pr_cont("Tag error during snoop/victimization.\n");
> +
> +		else if (xec == 0x0)
> +			pr_cont("Tag parity error from victim castout.\n");
> +
> +		else if (xec == 0x2)
> +			pr_cont("Microcode patch RAM parity error.\n");

Also no need for a family-special function - just rename f14h_mc1_mce
to cat_mc1_mce() as above and add a special case like this as the last
else-branch of the if conditional there:

+		if (boot_cpu_data.x86 == 0x16) {
+			if (LL(ec) == LL_LG && xec == 2)
+				pr_cont("Microcode patch RAM parity error.\n");
+			else
+				pr_cont("IC Tag parity error from victim castout.\n");
+			return true;
+		}

> +
> +		else
> +			ret = false;
> +	} else
> +		ret = false;
> +
> +	return ret;
> +}
> +
>  static void decode_mc1_mce(struct mce *m)
>  {
>  	u16 ec = EC(m->status);
> @@ -469,6 +520,48 @@ static bool f15h_mc2_mce(u16 ec, u8 xec)
>  	return ret;
>  }
>  
> +static bool f16h_mc2_mce(u16 ec, u8 xec)
> +{
> +	u8 r4    = R4(ec);
> +	bool ret = true;
> +
> +	if (MEM_ERROR(ec) && TT(ec) == TT_GEN && LL(ec) == LL_L2) {

You can exit early here:

	if (!MEM_ERROR(ec))
		return false;

Also, no need to test for TT and LL - we're relying on the hardware here
and if those values are b0rked then we have a more serious problem.

> +		switch (xec) {
> +		case 0x04 ... 0x05:
> +			pr_cont("Parity error in %s.\n",
> +				(r4 == R4_RD ? "IBUFF" : "OBUFF"));

or
			pr_cont("%sBUFF parity error.\n", ((xec == 4) ? "I" : "O"));

> +			break;
> +
> +		case 0x09 ... 0x0b:
> +		case 0x0d ... 0x0f:
> +			pr_cont("ECC error in L2 tag (%s).\n",
> +				(r4 == R4_GEN   ? "BankReq" :
> +				(r4 == R4_SNOOP ? "Probe"   : "Fill")));
> +			break;
> +
> +		case 0x10 ... 0x1b:
> +			pr_cont("ECC error in L2 data array (%s).\n",
> +				(r4 == R4_RD    ? "Hit"  :
> +				(r4 == R4_GEN   ? "Attr" :
> +				(r4 == R4_EVICT ? "Vict" : "Fill"))));
> +			break;
> +
> +		case 0x1c ... 0x1f:
> +			pr_cont("Parity error in L2 attribute bits (%s).\n",
> +				(r4 == R4_RD  ? "Hit"  :
> +				(r4 == R4_GEN ? "Attr" : "Fill")));
> +			break;
> +
> +		default:
> +			ret = false;
> +			break;
> +		}
> +	} else
> +		ret = false;
> +
> +	return ret;
> +}
> +
>  static void decode_mc2_mce(struct mce *m)
>  {
>  	u16 ec = EC(m->status);
> @@ -548,7 +641,7 @@ static void decode_mc4_mce(struct mce *m)
>  		return;
>  
>  	case 0x19:
> -		if (boot_cpu_data.x86 == 0x15)
> +		if (boot_cpu_data.x86 == 0x15 || boot_cpu_data.x86 == 0x16)
>  			pr_cont("Compute Unit Data Error.\n");
>  		else
>  			goto wrong_mc4_mce;
> @@ -634,6 +727,10 @@ static void decode_mc6_mce(struct mce *m)
>  
>  static inline void amd_decode_err_code(u16 ec)
>  {
> +	if (INT_ERROR(ec)) {
> +		pr_emerg(HW_ERR "internal: %s\n", LL_MSG(ec));
> +		return;
> +	}

Is this correct? I'm just confirming because I don't have the internal
info anymore.

Uuh, hold on, maybe those otherwise unused uu_msgs above were meant to
be used here instead of the LL_MSG? IOW,

		pr_emerg(HW_ERR "internal: %s\n", UU_MSG(ec));

Right?

>  
>  	pr_emerg(HW_ERR "cache level: %s", LL_MSG(ec));
>  
> @@ -738,10 +835,18 @@ int amd_decode_mce(struct notifier_block *nb, unsigned long val, void *data)
>  		((m->status & MCI_STATUS_PCC)	? "PCC"	  : "-"),
>  		((m->status & MCI_STATUS_ADDRV)	? "AddrV" : "-"));
>  
> -	if (c->x86 == 0x15)
> -		pr_cont("|%s|%s",
> +	if (c->x86 == 0x15 || c->x86 == 0x16) {
> +		char coreid[16];
> +
> +		if (m->status & MCI_STATUS_COREIDV)
> +			sprintf(coreid, "CoreIdV(Core%d)",
> +				(int)ERR_CORE_ID(m->status));

Uuh, no, this is probably dumping the core which detected the error.. No
need since we're dumping the core reporting the error anyway above. And
if that's mismatched for some reason, we're also dumping full MCi_STATUS
contents so you can decypher CoreId from there if needed.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
