Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932276Ab2LRRbJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 12:31:09 -0500
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:13148 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932082Ab2LRRbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 12:31:06 -0500
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VPS-3(zz98dI1432I1447Izz1de0h1202h1e76h1d1ah1d2ahzz8275bhz2dh668h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1155h)
X-WSS-ID: 0MF8LYQ-01-316-02
X-M-MSG: 
Date: Tue, 18 Dec 2012 11:30:24 -0600
From: Jacob Shin <jacob.shin@amd.com>
To: Borislav Petkov <bp@alien8.de>, Doug Thompson <dougthompson@xmission.com>,
        <linux-edac@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] MCE, AMD: MCE decoding support for AMD Family 16h
Message-ID: <20121218173024.GA18732@jshin-Toonie>
References: <1355773188-5241-1-git-send-email-jacob.shin@amd.com>
 <1355773188-5241-2-git-send-email-jacob.shin@amd.com>
 <20121218171915.GE31255@liondog.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20121218171915.GE31255@liondog.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 18, 2012 at 06:19:15PM +0100, Borislav Petkov wrote:
> On Mon, Dec 17, 2012 at 01:39:48PM -0600, Jacob Shin wrote:
> > Add MCE decoding logic for AMD Family 16h processors.
> > 
> > Signed-off-by: Jacob Shin <jacob.shin@amd.com>
> > ---
> >  drivers/edac/mce_amd.c |  120 ++++++++++++++++++++++++++++++++++++++++++++++--
> >  drivers/edac/mce_amd.h |    6 +++
> >  2 files changed, 122 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/edac/mce_amd.c b/drivers/edac/mce_amd.c
> > index 84320f9..7d2d037 100644
> > --- a/drivers/edac/mce_amd.c
> > +++ b/drivers/edac/mce_amd.c
> > @@ -64,6 +64,10 @@ EXPORT_SYMBOL_GPL(to_msgs);
> >  const char * const ii_msgs[] = { "MEM", "RESV", "IO", "GEN" };
> >  EXPORT_SYMBOL_GPL(ii_msgs);
> >  
> > +/* internal error type */
> > +const char * const uu_msgs[] = { "RESV", "RESV", "HWA", "RESV" };
> > +EXPORT_SYMBOL_GPL(uu_msgs);
> 
> Seems like those aren't used anywhere?
> 
> >  static const char * const f15h_mc1_mce_desc[] = {
> >  	"UC during a demand linefill from L2",
> >  	"Parity error during data load from IC",
> > @@ -275,6 +279,23 @@ static bool f15h_mc0_mce(u16 ec, u8 xec)
> >  	return ret;
> >  }
> >  
> > +static bool f16h_mc0_mce(u16 ec, u8 xec)
> > +{
> > +	u8 r4 = R4(ec);
> > +
> > +	if (MEM_ERROR(ec) && TT(ec) == TT_DATA && LL(ec) == LL_L1 &&
> > +	    (r4 == R4_DRD || r4 == R4_DWR)) {
> > +
> > +		pr_cont("%s parity error due to %s.\n",
> > +			(xec == 0x0    ? "Data" : "Tag"),
> > +			(r4  == R4_DRD ? "load" : "store"));
> > +
> > +		return true;
> > +	}
> > +
> > +	return f14h_mc0_mce(ec, xec);
> 
> Looks like this could be merged with f14h_mc0_mce no? You can call the
> function then cat_mc0_mce (for all the *cat cores) and assign it to
> fam_ops->mc0_mce in the f14h and f16h case.

Okay

> 
> > +}
> > +
> >  static void decode_mc0_mce(struct mce *m)
> >  {
> >  	u16 ec = EC(m->status);
> > @@ -379,6 +400,36 @@ static bool f15h_mc1_mce(u16 ec, u8 xec)
> >  	return ret;
> >  }
> >  
> > +static bool f16h_mc1_mce(u16 ec, u8 xec)
> > +{
> > +	u8 r4    = R4(ec);
> > +	bool ret = true;
> > +
> > +	if (MEM_ERROR(ec)) {
> > +		if (TT(ec) != TT_INSTR)
> > +			ret = false;
> > +
> > +		else if (r4 == R4_IRD)
> > +			pr_cont("%s array parity error for a tag hit.\n",
> > +				(xec == 0x0 ? "Data" : "Tag"));
> > +
> > +		else if (r4 == R4_SNOOP)
> > +			pr_cont("Tag error during snoop/victimization.\n");
> > +
> > +		else if (xec == 0x0)
> > +			pr_cont("Tag parity error from victim castout.\n");
> > +
> > +		else if (xec == 0x2)
> > +			pr_cont("Microcode patch RAM parity error.\n");
> 
> Also no need for a family-special function - just rename f14h_mc1_mce
> to cat_mc1_mce() as above and add a special case like this as the last
> else-branch of the if conditional there:

Okay

> 
> +		if (boot_cpu_data.x86 == 0x16) {
> +			if (LL(ec) == LL_LG && xec == 2)
> +				pr_cont("Microcode patch RAM parity error.\n");
> +			else
> +				pr_cont("IC Tag parity error from victim castout.\n");
> +			return true;
> +		}
> 
> > +
> > +		else
> > +			ret = false;
> > +	} else
> > +		ret = false;
> > +
> > +	return ret;
> > +}
> > +
> >  static void decode_mc1_mce(struct mce *m)
> >  {
> >  	u16 ec = EC(m->status);
> > @@ -469,6 +520,48 @@ static bool f15h_mc2_mce(u16 ec, u8 xec)
> >  	return ret;
> >  }
> >  
> > +static bool f16h_mc2_mce(u16 ec, u8 xec)
> > +{
> > +	u8 r4    = R4(ec);
> > +	bool ret = true;
> > +
> > +	if (MEM_ERROR(ec) && TT(ec) == TT_GEN && LL(ec) == LL_L2) {
> 
> You can exit early here:
> 
> 	if (!MEM_ERROR(ec))
> 		return false;
> 
> Also, no need to test for TT and LL - we're relying on the hardware here
> and if those values are b0rked then we have a more serious problem.

Okay

> 
> > +		switch (xec) {
> > +		case 0x04 ... 0x05:
> > +			pr_cont("Parity error in %s.\n",
> > +				(r4 == R4_RD ? "IBUFF" : "OBUFF"));
> 
> or
> 			pr_cont("%sBUFF parity error.\n", ((xec == 4) ? "I" : "O"));
> 
> > +			break;
> > +
> > +		case 0x09 ... 0x0b:
> > +		case 0x0d ... 0x0f:
> > +			pr_cont("ECC error in L2 tag (%s).\n",
> > +				(r4 == R4_GEN   ? "BankReq" :
> > +				(r4 == R4_SNOOP ? "Probe"   : "Fill")));
> > +			break;
> > +
> > +		case 0x10 ... 0x1b:
> > +			pr_cont("ECC error in L2 data array (%s).\n",
> > +				(r4 == R4_RD    ? "Hit"  :
> > +				(r4 == R4_GEN   ? "Attr" :
> > +				(r4 == R4_EVICT ? "Vict" : "Fill"))));
> > +			break;
> > +
> > +		case 0x1c ... 0x1f:
> > +			pr_cont("Parity error in L2 attribute bits (%s).\n",
> > +				(r4 == R4_RD  ? "Hit"  :
> > +				(r4 == R4_GEN ? "Attr" : "Fill")));
> > +			break;
> > +
> > +		default:
> > +			ret = false;
> > +			break;
> > +		}
> > +	} else
> > +		ret = false;
> > +
> > +	return ret;
> > +}
> > +
> >  static void decode_mc2_mce(struct mce *m)
> >  {
> >  	u16 ec = EC(m->status);
> > @@ -548,7 +641,7 @@ static void decode_mc4_mce(struct mce *m)
> >  		return;
> >  
> >  	case 0x19:
> > -		if (boot_cpu_data.x86 == 0x15)
> > +		if (boot_cpu_data.x86 == 0x15 || boot_cpu_data.x86 == 0x16)
> >  			pr_cont("Compute Unit Data Error.\n");
> >  		else
> >  			goto wrong_mc4_mce;
> > @@ -634,6 +727,10 @@ static void decode_mc6_mce(struct mce *m)
> >  
> >  static inline void amd_decode_err_code(u16 ec)
> >  {
> > +	if (INT_ERROR(ec)) {
> > +		pr_emerg(HW_ERR "internal: %s\n", LL_MSG(ec));
> > +		return;
> > +	}
> 
> Is this correct? I'm just confirming because I don't have the internal
> info anymore.
> 
> Uuh, hold on, maybe those otherwise unused uu_msgs above were meant to
> be used here instead of the LL_MSG? IOW,

> 
> 		pr_emerg(HW_ERR "internal: %s\n", UU_MSG(ec));
> 
> Right?

Ah, yes thats right, sorry about the typo. It looks like:

Error Code           Error Code Type        Description
0000 01UU 0000 0000  Internal Unclassified  UU = Internal Error Type

And the UU encoding is as is in the mce_amd.h file

> 
> >  
> >  	pr_emerg(HW_ERR "cache level: %s", LL_MSG(ec));
> >  
> > @@ -738,10 +835,18 @@ int amd_decode_mce(struct notifier_block *nb, unsigned long val, void *data)
> >  		((m->status & MCI_STATUS_PCC)	? "PCC"	  : "-"),
> >  		((m->status & MCI_STATUS_ADDRV)	? "AddrV" : "-"));
> >  
> > -	if (c->x86 == 0x15)
> > -		pr_cont("|%s|%s",
> > +	if (c->x86 == 0x15 || c->x86 == 0x16) {
> > +		char coreid[16];
> > +
> > +		if (m->status & MCI_STATUS_COREIDV)
> > +			sprintf(coreid, "CoreIdV(Core%d)",
> > +				(int)ERR_CORE_ID(m->status));
> 
> Uuh, no, this is probably dumping the core which detected the error.. No
> need since we're dumping the core reporting the error anyway above. And
> if that's mismatched for some reason, we're also dumping full MCi_STATUS
> contents so you can decypher CoreId from there if needed.

Okay, will take this out.

Thanks for the feedback! I'll spin a V2 and send it out later today.

-Jacob

> 
> Thanks.
> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> Sent from a fat crate under my desk. Formatting is fine.
> --
> 

