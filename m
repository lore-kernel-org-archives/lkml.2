Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757544Ab2E3WeB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 18:34:01 -0400
Received: from andromeda.dapyr.net ([206.212.254.10]:40823 "EHLO
	andromeda.dapyr.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757055Ab2E3WeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 18:34:00 -0400
Date: Wed, 30 May 2012 18:33:34 -0400
From: Konrad Rzeszutek Wilk <konrad@darnok.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Borislav Petkov <bp@alien8.de>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jacob Shin <jacob.shin@amd.com>,
        Andre Przywara <andre.przywara@amd.com>, jeremy@goop.org,
        xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        Jan Beulich <JBeulich@suse.com>, mingo@elte.hu, tglx@linutronix.de
Subject: Re: [Xen-devel] [PATCH] x86/amd: fix crash as Xen Dom0 on AMD Trinity systems
Message-ID: <20120530223334.GB28417@andromeda.dapyr.net>
References: <20120530144851.GA12184@jshin-Toonie> <20120530145005.GI3207@phenom.dumpdata.com> <20120530150334.GA13349@jshin-Toonie> <20120530171754.GA5115@phenom.dumpdata.com> <20120530173247.GC15635@x1.osrc.amd.com> <4FC65D34.1060803@zytor.com> <20120530175150.GE15438@x1.osrc.amd.com> <4FC66037.6020506@zytor.com> <20120530181722.GF15438@x1.osrc.amd.com> <4FC664E1.9050504@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FC664E1.9050504@zytor.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Now, someone probably needs to paravirt the *safe_regs variants in case
> > something else decides to use them. I don't know what to do here, do I
> > want more paravirt code in there? No. I guess if this is done carefully
> > and cleanly, then it should be ok but it can't be done like that - it
> > needs to adhere to the current pv_cpu_ops thing which is already there.

Using the native variant seems the right thing to do.
> > 
> 
> I thought I was being told that Xen would trap and emulate the
> rdmsr/wrmsr instructions.  I guess they don't want to do that for the

It does.
> handful of performance-sensitive MSRs there are, but those don't use the
> *_regs variants.

The underlaying issue (as I understand) was that .rdmsr_regs
(and the corresponding write) was NULL and that caused the crash.
This tiny patch should do it:

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 75f33b2..e74df95 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1116,7 +1116,10 @@ static const struct pv_cpu_ops xen_cpu_ops __initconst = {
 	.wbinvd = native_wbinvd,
 
 	.read_msr = native_read_msr_safe,
+	.rdmsr_regs = native_rdmsr_safe_regs,
 	.write_msr = xen_write_msr_safe,
+	.wrmsr_regs = native_wrmsr_safe_regs,
+
 	.read_tsc = native_read_tsc,
 	.read_pmc = native_read_pmc,
 
