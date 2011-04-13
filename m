Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756600Ab1DMOSv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 10:18:51 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:44941 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756471Ab1DMOSu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 10:18:50 -0400
Date: Wed, 13 Apr 2011 16:18:29 +0200
From: Borislav Petkov <bp@amd64.org>
To: Prarit Bhargava <prarit@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russ Anderson <rja@sgi.com>, "Luck, Tony" <tony.luck@intel.com>,
        "dzickus@redhat.com" <dzickus@redhat.com>,
        "mstowe@redhat.com" <mstowe@redhat.com>,
        "dnelson@redhat.com" <dnelson@redhat.com>,
        "rja@americas.sgi.com" <rja@americas.sgi.com>
Subject: Re: [PATCH 2/3] x86, MCE: Drop default decoding notifier
Message-ID: <20110413141829.GE1987@aftab>
References: <20110413132409.GB1900@gere.osrc.amd.com>
 <1302701810-2471-2-git-send-email-bp@amd64.org>
 <4DA5ACB2.1070505@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DA5ACB2.1070505@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 13, 2011 at 10:01:22AM -0400, Prarit Bhargava wrote:
> On 04/13/2011 09:36 AM, Borislav Petkov wrote:
> > From: Borislav Petkov <borislav.petkov@amd.com>
> > 
> > The default notifier doesn't make a lot of sense to call in the
> > correctable errors case. Drop it and emit the mcelog decoding hint only
> > in the uncorrectable errors case and when no notifier is registered.
> > 
> > Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
> > ---
> >  arch/x86/include/asm/mce.h       |    4 ++--
> >  arch/x86/kernel/cpu/mcheck/mce.c |   26 +++++++++-----------------
> >  2 files changed, 11 insertions(+), 19 deletions(-)
> > 
>   
> > +extern atomic_t mce_decoders;
> > +
> 
> Boris,
> 
> I don't think we need to do this.  I think we can use the existing notifier chain tools to do this check for us ... *untested and uncompiled* patch below.
> 
>   	 * Print out human-readable details about the MCE error,
> >  	 * (if the CPU has an implementation for that)
> >  	 */
> > -	atomic_notifier_call_chain(&x86_mce_decoder_chain, 0, m);
> > +	if (!atomic_read(&mce_decoders)) {
> > +		pr_emerg(HW_ERR "No human readable MCE decoding support on this CPU type.\n");
> > +		pr_emerg(HW_ERR "Run the above through 'mcelog --ascii' to decode.\n");
> 
> I thought we didn't want these lines at all for CE errors?

This is the UC only case - we call print_mce() before we panic.

> 
> > +	} else
> > +		atomic_notifier_call_chain(&x86_mce_decoder_chain, 0, m);
> >  }
> >  
> >  #define PANIC_TIMEOUT 5 /* 5 seconds */
> > @@ -589,7 +582,8 @@ void machine_check_poll(enum mcp_flags flags, mce_banks_t *b)
> >  		 */
> >  		if (!(flags & MCP_DONTLOG) && !mce_dont_log_ce) {
> >  			mce_log(&m);
> > -			atomic_notifier_call_chain(&x86_mce_decoder_chain, 0, &m);
> > +			if (atomic_read(&mce_decoders))
> > +				atomic_notifier_call_chain(&x86_mce_decoder_chain, 0, &m);
> >  		}
> >  
> >  		/*
> > @@ -1721,8 +1715,6 @@ __setup("mce", mcheck_enable);
> >  
> >  int __init mcheck_init(void)
> >  {
> > -	atomic_notifier_chain_register(&x86_mce_decoder_chain, &mce_dec_nb);
> > -
> >  	mcheck_intel_therm_init();
> >  
> >  	return 0;
> 
> Again, this patch has not been tested or compiled against latest upstream.  I
> have quickly tested it against RHEL6 (2.6.32,33,34,35,36,38,39 based) and
> confirmed that I don't see the messages for CEs.  I have NOT fully tested to see what happens when I add in a "dummy" notifier to see if the messages are not printed.
> 
> diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
> index 3385ea2..b10a1f4 100644
> --- a/arch/x86/kernel/cpu/mcheck/mce.c
> +++ b/arch/x86/kernel/cpu/mcheck/mce.c
> @@ -100,25 +100,12 @@ static int			cpu_missing;
>  
>  /*
>   * CPU/chipset specific EDAC code can register a notifier call here to print
> - * MCE errors in a human-readable form.
> + * MCE errors in a human-readable form.  Notifiers must return NOTIFY_STOP
> + * upon completion.
>   */
>  ATOMIC_NOTIFIER_HEAD(x86_mce_decoder_chain);
>  EXPORT_SYMBOL_GPL(x86_mce_decoder_chain);
>  
> -static int default_decode_mce(struct notifier_block *nb, unsigned long val,
> -			       void *data)
> -{
> -	pr_emerg(HW_ERR "No human readable MCE decoding support on this CPU type.\n");
> -	pr_emerg(HW_ERR "Run the message through 'mcelog --ascii' to decode.\n");
> -
> -	return NOTIFY_STOP;
> -}
> -
> -static struct notifier_block mce_dec_nb = {
> -	.notifier_call = default_decode_mce,
> -	.priority      = -1,
> -};
> -
>  /* MCA banks polled by the period polling timer for corrected events */
>  DEFINE_PER_CPU(mce_banks_t, mce_poll_banks) = {
>  	[0 ... BITS_TO_LONGS(MAX_NR_BANKS)-1] = ~0UL
> @@ -212,6 +199,8 @@ void mce_log(struct mce *mce)
>  
>  static void print_mce(struct mce *m)
>  {
> +	int ret;
> +
>  	pr_emerg(HW_ERR "CPU %d: Machine Check Exception: %Lx Bank %d: %016Lx\n",
>  	       m->extcpu, m->mcgstatus, m->bank, m->status);
>  
> @@ -236,10 +225,13 @@ static void print_mce(struct mce *m)
>  		m->cpuvendor, m->cpuid, m->time, m->socketid, m->apicid);
>  
>  	/*
> -	 * Print out human-readable details about the MCE error,
> -	 * (if the CPU has an implementation for that)
> +	 * Output a message if the CPU has human-readable information for
> +	 * unhandled UC errors
>  	 */
> -	atomic_notifier_call_chain(&x86_mce_decoder_chain, 0, m);
> +	ret = atomic_notifier_call_chain(&x86_mce_decoder_chain, 0, &m);
> +	if ((ret != NOTIFY_STOP) && (m->status & MCI_STATUS_UC))
> +		pr_emerg(HW_ERR "Run the message through 'mcelog --ascii' "
> +			 "to decode.\n");

Yep, yours is actually nicer - the notifier returns NOTIFY_DONE if it
doesn't call any notifier calls on the chain so the first test should
suffice.

Let me update the patch add your S-O-B so you could give it a run.

Thanks.


-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
