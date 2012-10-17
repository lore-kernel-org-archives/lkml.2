Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756931Ab2JQNQE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 09:16:04 -0400
Received: from mail.x86-64.org ([217.9.48.20]:50541 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756056Ab2JQNQB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 09:16:01 -0400
Date: Wed, 17 Oct 2012 15:15:59 +0200
From: Borislav Petkov <bp@amd64.org>
To: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Cc: Tony Luck <tony.luck@intel.com>, Greg Kroah-Hartman <greg@kroah.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/5] x86, MCA: Convert dont_log_ce, banks and tolerant
Message-ID: <20121017131559.GE25507@aftab.osrc.amd.com>
References: <1350472435-29307-1-git-send-email-bp@amd64.org>
 <1350472435-29307-3-git-send-email-bp@amd64.org>
 <507E9F9A.4090706@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <507E9F9A.4090706@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 17, 2012 at 05:37:54PM +0530, Naveen N. Rao wrote:
> Nit: no need for the above? Only 2 references below and I think we
> can simply continue to use mca_cfg for uniformity. Ditto for the use
> of cfg further below.
> 
> >
> >-	mce_banks = kzalloc(banks * sizeof(struct mce_bank), GFP_KERNEL);
> >+	mce_banks = kzalloc(num_banks * sizeof(struct mce_bank), GFP_KERNEL);
> >  	if (!mce_banks)
> >  		return -ENOMEM;

For the simple reason that this line violates the 80 columns and I
didn't want to bring any uglification to the code by breaking the line
in two.

For the generated asm it doesn't matter - it is simply done for keeping
the code as readable as possible.

> >-	for (i = 0; i < banks; i++) {
> >+
> >+	for (i = 0; i < num_banks; i++) {
> >  		struct mce_bank *b = &mce_banks[i];
> >
> >  		b->ctl = -1ULL;
> >@@ -1401,7 +1405,7 @@ static int __cpuinit __mcheck_cpu_cap_init(void)
> >  	rdmsrl(MSR_IA32_MCG_CAP, cap);
> >
> >  	b = cap & MCG_BANKCNT_MASK;
> >-	if (!banks)
> >+	if (!mca_cfg.banks)
> >  		pr_info("CPU supports %d MCE banks\n", b);
> >
> >  	if (b > MAX_NR_BANKS) {
> >@@ -1411,8 +1415,9 @@ static int __cpuinit __mcheck_cpu_cap_init(void)
> >  	}
> >
> >  	/* Don't support asymmetric configurations today */
> >-	WARN_ON(banks != 0 && b != banks);
> >-	banks = b;
> >+	WARN_ON(mca_cfg.banks != 0 && b != mca_cfg.banks);
> >+	mca_cfg.banks = b;
> >+
> >  	if (!mce_banks) {
> >  		int err = __mcheck_cpu_mce_banks_init();
> >
> >@@ -1448,7 +1453,7 @@ static void __mcheck_cpu_init_generic(void)
> >  	if (cap & MCG_CTL_P)
> >  		wrmsr(MSR_IA32_MCG_CTL, 0xffffffff, 0xffffffff);
> >
> >-	for (i = 0; i < banks; i++) {
> >+	for (i = 0; i < mca_cfg.banks; i++) {
> >  		struct mce_bank *b = &mce_banks[i];
> >
> >  		if (!b->init)
> >@@ -1489,6 +1494,8 @@ static void quirk_sandybridge_ifu(int bank, struct mce *m, struct pt_regs *regs)
> >  /* Add per CPU specific workarounds here */
> >  static int __cpuinit __mcheck_cpu_apply_quirks(struct cpuinfo_x86 *c)
> >  {
> >+	struct mca_config *cfg = &mca_cfg;
> >+
> 
> Same as above. We could probably continue using mca_cfg for uniformity.

There are 13 mca_cfg references total in that function so having it
shorter with a declaration at the beginning of the function of what cfg
is, is better IMO.

[ … ]

> > __init mcheck_enable(char *str)
> >  {
> >+	struct mca_config *cfg = &mca_cfg;
> >+
> 
> Same as above.

Ditto, 8 refs here.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
