Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753472Ab2E3PDr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 11:03:47 -0400
Received: from db3ehsobe001.messaging.microsoft.com ([213.199.154.139]:28862
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751408Ab2E3PDp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 11:03:45 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -11
X-BigFish: VPS-11(zzbb2dI9371I1432N98dKzz1202hzz8275bh8275dhz2dh668h839h944hd25hd2bhf0ah)
X-WSS-ID: 0M4UCI0-02-0EJ-02
X-M-MSG: 
Date: Wed, 30 May 2012 10:03:34 -0500
From: Jacob Shin <jacob.shin@amd.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Andre Przywara <andre.przywara@amd.com>, Jan Beulich <JBeulich@suse.com>,
        <mingo@elte.hu>, <jeremy@goop.org>, <tglx@linutronix.de>,
        <xen-devel@lists.xensource.com>, <linux-kernel@vger.kernel.org>,
        <hpa@zytor.com>
Subject: Re: [Xen-devel] [PATCH] x86/amd: fix crash as Xen Dom0 on AMD
 Trinity systems
Message-ID: <20120530150334.GA13349@jshin-Toonie>
References: <1338383402-3838-1-git-send-email-andre.przywara@amd.com>
 <4FC63DAF0200007800086DC5@nat28.tlf.novell.com>
 <4FC62888.9010407@amd.com>
 <20120530144851.GA12184@jshin-Toonie>
 <20120530145005.GI3207@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20120530145005.GI3207@phenom.dumpdata.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2012 at 10:50:05AM -0400, Konrad Rzeszutek Wilk wrote:
> On Wed, May 30, 2012 at 09:48:51AM -0500, Jacob Shin wrote:
> > On Wed, May 30, 2012 at 04:02:48PM +0200, Andre Przywara wrote:
> > > On 05/30/2012 03:33 PM, Jan Beulich wrote:
> > > >>>>On 30.05.12 at 15:10, Andre Przywara<andre.przywara@amd.com>  wrote:
> > > >>Because we are behind a family check before tweaking the topology
> > > >>bit, we can use the standard rd/wrmsr variants for the CPUID feature
> > > >>register.
> > > >>This fixes a crash when using the kernel as a Xen Dom0 on affected
> > > >>Trinity systems. The wrmsrl_amd_safe is not properly paravirtualized
> > > >>yet (this will be fixed in another patch).
> > > >
> > > >I'm not following: If the AMD variants (putting a special value into
> > > >%edi) can be freely replaced by the non-AMD variants, why did
> > > >the AMD special ones get used in the first place?
> > > 
> > > Older CPUs (K8) needed the AMD variants, starting with family 10h we
> > > can use the normal versions.
> > > 
> > > >Further, I can't see how checking_wrmsrl() is being paravirtualized
> > > >any better than wrmsrl_amd_safe() - both have nothing but an
> > > >exception handling fixup attached to the wrmsr invocation. Care
> > > >to point out what actual crash it is that was seen?
> > > 
> > > AFAIK, the difference is between the "l" and the regs version for
> > > rd/wrmsr. We have a patch already here to fix this. Will send it out
> > > soon. Jacob, can you comment on this?
> > 
> > Right, the checking_wrmsrl turns into wrmsr_safe which is paravirtualized
> > but the rdmsrl_amd_safe which turns into rdmsr_regs is not paravirtualized
> > by enlighten.
> 
> So would a patch to implements the rdmsr_regs fix this crash?

Yes, the following patch also fixed the crash for us:

Implement rdmsr_regs and wrmsr_regs for Xen pvops.

Signed-off-by: Jacob Shin <jacob.shin@amd.com>
Cc: stable@vger.kernel.org # 3.4+

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 75f33b2..f3ae5ec 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -945,9 +945,12 @@ static void xen_write_cr4(unsigned long cr4)
 	native_write_cr4(cr4);
 }
 
-static int xen_write_msr_safe(unsigned int msr, unsigned low, unsigned high)
+static int xen_wrmsr_safe_regs(u32 regs[8])
 {
 	int ret;
+	unsigned int msr = regs[1];
+	unsigned low = regs[0];
+	unsigned high = regs[2];
 
 	ret = 0;
 
@@ -985,12 +988,23 @@ static int xen_write_msr_safe(unsigned int msr, unsigned low, unsigned high)
 		break;
 
 	default:
-		ret = native_write_msr_safe(msr, low, high);
+		ret = native_wrmsr_safe_regs(regs);
 	}
 
 	return ret;
 }
 
+static int xen_write_msr_safe(unsigned int msr, unsigned low, unsigned high)
+{
+	u32 regs[8] = { 0 };
+
+	regs[0] = low;
+	regs[1] = msr;
+	regs[2] = high;
+
+	return xen_wrmsr_safe_regs(regs);
+}
+
 void xen_setup_shared_info(void)
 {
 	if (!xen_feature(XENFEAT_auto_translated_physmap)) {
@@ -1116,7 +1130,9 @@ static const struct pv_cpu_ops xen_cpu_ops __initconst = {
 	.wbinvd = native_wbinvd,
 
 	.read_msr = native_read_msr_safe,
+	.rdmsr_regs = native_rdmsr_safe_regs,
 	.write_msr = xen_write_msr_safe,
+	.wrmsr_regs = xen_wrmsr_safe_regs,
 	.read_tsc = native_read_tsc,
 	.read_pmc = native_read_pmc,
 


