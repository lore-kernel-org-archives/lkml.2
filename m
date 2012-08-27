Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754451Ab2H0US4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 16:18:56 -0400
Received: from mail.x86-64.org ([217.9.48.20]:33234 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754399Ab2H0USy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 16:18:54 -0400
Date: Mon, 27 Aug 2012 22:18:40 +0200
From: Borislav Petkov <bp@amd64.org>
To: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Cc: Borislav Petkov <bp@amd64.org>, tony.luck@intel.com, andi@firstfloor.org,
        gong.chen@linux.intel.com, ananth@in.ibm.com,
        masbock@linux.vnet.ibm.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, lcm@us.ibm.com, mingo@redhat.com,
        tglx@linutronix.de, linux-edac@vger.kernel.org
Subject: Re: [PATCH 1/2] x86/mce: Pack boolean MCE boot flags into a structure
Message-ID: <20120827201840.GC9539@aftab.osrc.amd.com>
References: <20120827112503.10313.62594.stgit@localhost.localdomain>
 <20120827143619.GE27979@aftab.osrc.amd.com>
 <503B93D2.7090702@linux.vnet.ibm.com>
 <20120827154741.GI27979@aftab.osrc.amd.com>
 <503B99C7.3000503@linux.vnet.ibm.com>
 <20120827163408.GK27979@aftab.osrc.amd.com>
 <503BAB00.1080708@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <503BAB00.1080708@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 27, 2012 at 10:44:40PM +0530, Naveen N. Rao wrote:
> Looks good. Infact, I had actually added mce_ser and mce_disabled
> into the bitfield, but backed off not wanting to overdo.
> 
> We could pull in all the other configuration parameters into this
> structure as long as everyone is ok with this.

Well, if you'd like, you can make one change per patch so that they can
be easily reviewable.

> >diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
> >index a3ac52b29cbf..e5cfd241e508 100644
> >--- a/arch/x86/include/asm/mce.h
> >+++ b/arch/x86/include/asm/mce.h
> >@@ -126,7 +126,6 @@ struct mce_log {
> >  #define K8_MCE_THRESHOLD_BANK_5    (MCE_THRESHOLD_BASE + 5 * 9)
> >  #define K8_MCE_THRESHOLD_DRAM_ECC  (MCE_THRESHOLD_BANK_4 + 0)
> >
> >-
> >  #ifdef __KERNEL__
> >
> >  extern void mce_register_decode_chain(struct notifier_block *nb);
> >@@ -169,8 +168,6 @@ DECLARE_PER_CPU(struct device *, mce_device);
> >  #define MAX_NR_BANKS 32
> >
> >  #ifdef CONFIG_X86_MCE_INTEL
> >-extern int mce_cmci_disabled;
> >-extern int mce_ignore_ce;
> >  void mce_intel_feature_init(struct cpuinfo_x86 *c);
> >  void cmci_clear(void);
> >  void cmci_reenable(void);
> >diff --git a/arch/x86/kernel/cpu/mcheck/mce-internal.h b/arch/x86/kernel/cpu/mcheck/mce-internal.h
> >index 6a05c1d327a9..3b25bcf452d9 100644
> >--- a/arch/x86/kernel/cpu/mcheck/mce-internal.h
> >+++ b/arch/x86/kernel/cpu/mcheck/mce-internal.h
> >@@ -28,6 +28,15 @@ extern int mce_ser;
> >
> >  extern struct mce_bank *mce_banks;
> >
> >+struct mce_cfg {
> >+	__u32	cmci_disabled		: 1,
> >+		ignore_ce		: 1,
> >+		dont_log_ce		: 1,
> >+		__pad			: 29;
> >+};
> >+
> >+extern struct mce_cfg cfg;
> >+
> 
> I'd prefer mce_cfg, rather than just cfg. I think it looks clearer
> to say, for instance, mce_ser.ignore_ce rather than just
> cfg.ignore_ce where the latter looks more like a global thing. But,
> of course, the former is more concise...

Yes,

* it is more consise
* it is private to mce so no ambiguity
* having identical struct name and variable names is very confusing (at least
 to me)

so you can do

extern struct mce_cfg m_cfg;

or

extern struct mce_config mcfg;

or similar but please keep struct name and variable name different.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
