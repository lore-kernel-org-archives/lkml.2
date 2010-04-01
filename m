Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752708Ab0DACcP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 22:32:15 -0400
Received: from mga09.intel.com ([134.134.136.24]:47382 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752010Ab0DACcO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 22:32:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.51,345,1267430400"; 
   d="scan'208";a="609359896"
Subject: Re: [PATCH 0/3] perf/core, x86: unify perfctr bitmasks
From: Lin Ming <ming.m.lin@intel.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Robert Richter <robert.richter@amd.com>,
       Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20100331170517.GB15288@lenovo>
References: <bd4cb8901003300311l4178891dvf1e63293a0ac51fe@mail.gmail.com>
	 <20100330134145.GI11907@erda.amd.com>
	 <bd4cb8901003300653lc8e414bp3930b03fee2fffbf@mail.gmail.com>
	 <1269961255.5258.221.camel@laptop> <20100330155949.GJ11907@erda.amd.com>
	 <1269968113.5258.442.camel@laptop> <20100330182906.GD5211@lenovo>
	 <1269975840.5258.609.camel@laptop> <20100331161523.GA9058@lenovo>
	 <20100331162647.GA15288@lenovo>  <20100331170517.GB15288@lenovo>
Content-Type: text/plain
Date: Thu, 01 Apr 2010 10:14:08 +0800
Message-Id: <1270088048.8575.38.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-04-01 at 01:05 +0800, Cyrill Gorcunov wrote:
> On Wed, Mar 31, 2010 at 08:26:47PM +0400, Cyrill Gorcunov wrote:
> > On Wed, Mar 31, 2010 at 08:15:23PM +0400, Cyrill Gorcunov wrote:
> > > On Tue, Mar 30, 2010 at 09:04:00PM +0200, Peter Zijlstra wrote:
> > > > On Tue, 2010-03-30 at 22:29 +0400, Cyrill Gorcunov wrote:
> > > [...]
> > > > > 
> > [...]
> > > +static inline bool p4_is_odd_cpl(u32 escr)
> > > +{
> > > +	unsigned int t0 = (escr & P4_ESCR_T0_ANY) << 0;
> > > +	unsigned int t1 = (escr & P4_ESCR_T1_ANY) << 2;
> > > +
> > > +	if ((t0 ^ t1) != t0)
> > > +		return true;
> > 
> > /me in shame: This is bogus, Peter don't take it yet.
> >
> 
> Updated
>  
> 	-- Cyrill
> ---
> x86, perf: P4 PMU -- check for permission granted on ANY event v2
> 
> In case if a caller (user) asked us to count events with
> some weird mask we should check if this priviledge has been
> granted since this could be a mix of bitmasks we not like
> which but allow if caller insist.
> 
> By ANY event term the combination of USR/OS bits in ESCR
> register is assumed.

I'll test this patch.
Does it need to be applied on top of Robert's patch?

Lin Ming

> 
> CC: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> ---
>  arch/x86/include/asm/perf_event_p4.h |   17 +++++++++++++++++
>  arch/x86/kernel/cpu/perf_event_p4.c  |   24 +++++++++++++++++++++---
>  2 files changed, 38 insertions(+), 3 deletions(-)
> 
> Index: linux-2.6.git/arch/x86/include/asm/perf_event_p4.h
> =====================================================================
> --- linux-2.6.git.orig/arch/x86/include/asm/perf_event_p4.h
> +++ linux-2.6.git/arch/x86/include/asm/perf_event_p4.h
> @@ -33,6 +33,9 @@
>  #define P4_ESCR_T1_OS		0x00000002U
>  #define P4_ESCR_T1_USR		0x00000001U
>  
> +#define P4_ESCR_T0_ANY		(P4_ESCR_T0_OS | P4_ESCR_T0_USR)
> +#define P4_ESCR_T1_ANY		(P4_ESCR_T1_OS | P4_ESCR_T1_USR)
> +
>  #define P4_ESCR_EVENT(v)	((v) << P4_ESCR_EVENT_SHIFT)
>  #define P4_ESCR_EMASK(v)	((v) << P4_ESCR_EVENTMASK_SHIFT)
>  #define P4_ESCR_TAG(v)		((v) << P4_ESCR_TAG_SHIFT)
> @@ -134,6 +137,20 @@
>  #define P4_CONFIG_HT_SHIFT		63
>  #define P4_CONFIG_HT			(1ULL << P4_CONFIG_HT_SHIFT)
>  
> +/*
> + * typically we set USR or/and OS bits for one of the
> + * threads only at once, any other option is treated
> + * as "any"
> + */
> +static inline bool p4_is_any_cpl(u32 escr)
> +{
> +	if ((escr & P4_ESCR_T0_ANY) &&
> +	    (escr & P4_ESCR_T1_ANY))
> +		return true;
> +
> +	return false;
> +}
> +
>  static inline bool p4_is_event_cascaded(u64 config)
>  {
>  	u32 cccr = p4_config_unpack_cccr(config);
> Index: linux-2.6.git/arch/x86/kernel/cpu/perf_event_p4.c
> =====================================================================
> --- linux-2.6.git.orig/arch/x86/kernel/cpu/perf_event_p4.c
> +++ linux-2.6.git/arch/x86/kernel/cpu/perf_event_p4.c
> @@ -443,13 +443,18 @@ static int p4_hw_config(struct perf_even
>  		return 0;
>  
>  	/*
> +	 * a caller may ask for something definitely weird and
> +	 * screwed, sigh...
> +	 */
> +	escr = p4_config_unpack_escr(event->attr.config);
> +	if (p4_is_any_cpl(escr) && perf_paranoid_cpu() && !capable(CAP_SYS_ADMIN))
> +		return -EACCES;
> +
> +	/*
>  	 * We don't control raw events so it's up to the caller
>  	 * to pass sane values (and we don't count the thread number
>  	 * on HT machine but allow HT-compatible specifics to be
>  	 * passed on)
> -	 *
> -	 * XXX: HT wide things should check perf_paranoid_cpu() &&
> -	 *      CAP_SYS_ADMIN
>  	 */
>  	event->hw.config |= event->attr.config &
>  		(p4_config_pack_escr(P4_ESCR_MASK_HT) |
> @@ -630,6 +635,19 @@ static void p4_pmu_swap_config_ts(struct
>  	escr = p4_config_unpack_escr(hwc->config);
>  	cccr = p4_config_unpack_cccr(hwc->config);
>  
> +	/*
> +	 * for non-standart configs we don't clobber cpl
> +	 * related bits so it's preferred the caller don't
> +	 * use this mode
> +	 */
> +	if (unlikely(p4_is_any_cpl(escr))) {
> +		if (p4_ht_thread(cpu))
> +			hwc->config |= P4_CONFIG_HT;
> +		else
> +			hwc->config &= ~P4_CONFIG_HT;
> +		return;
> +	}
> +
>  	if (p4_ht_thread(cpu)) {
>  		cccr &= ~P4_CCCR_OVF_PMI_T0;
>  		cccr |= P4_CCCR_OVF_PMI_T1;

