Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757402Ab2E3WYU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 18:24:20 -0400
Received: from andromeda.dapyr.net ([206.212.254.10]:40735 "EHLO
	andromeda.dapyr.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754850Ab2E3WYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 18:24:18 -0400
Date: Wed, 30 May 2012 18:23:56 -0400
From: Konrad Rzeszutek Wilk <konrad@darnok.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andre Przywara <andre.przywara@amd.com>, jeremy@goop.org,
        xen-devel@lists.xensource.com, Jacob Shin <jacob.shin@amd.com>,
        linux-kernel@vger.kernel.org, Jan Beulich <JBeulich@suse.com>,
        mingo@elte.hu, tglx@linutronix.de
Subject: Re: [Xen-devel] [PATCH] x86/amd: fix crash as Xen Dom0 on AMD Trinity systems
Message-ID: <20120530222356.GA28417@andromeda.dapyr.net>
References: <1338383402-3838-1-git-send-email-andre.przywara@amd.com> <4FC63DAF0200007800086DC5@nat28.tlf.novell.com> <4FC62888.9010407@amd.com> <20120530144851.GA12184@jshin-Toonie> <20120530145005.GI3207@phenom.dumpdata.com> <20120530150334.GA13349@jshin-Toonie> <20120530171754.GA5115@phenom.dumpdata.com> <4FC6597D.4060204@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FC6597D.4060204@zytor.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2012 at 10:31:41AM -0700, H. Peter Anvin wrote:
> On 05/30/2012 10:17 AM, Konrad Rzeszutek Wilk wrote:
> >> Yes, the following patch also fixed the crash for us:
> >>
> >> Implement rdmsr_regs and wrmsr_regs for Xen pvops.
> > 
> > That needs more data. Such as the reason for it, the crash
> > tombstone, and an analysis of the bug.
> > 
> > But at this point I am not sure what we are going to do.
> > 
> > I think Peter leans towards ripping the .rdmsr_regs/wdmsr_regs
> > function out altogether (so altering the amd_rdmsr... to use the
> > .rdmsr/.wrdmsr). At which point I think this would all work
> > just fine?
> > 
> 
> No, you can't just do that.  Rip them out as in trap and emulate.

Then this should do it:

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

