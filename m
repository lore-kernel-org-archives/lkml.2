Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752464Ab2DPInA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 04:43:00 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:42619 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751838Ab2DPIm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 04:42:59 -0400
Message-ID: <4F8BDB58.6070007@linux.vnet.ibm.com>
Date: Mon, 16 Apr 2012 14:12:00 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Borislav Petkov <borislav.petkov@amd.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Kay Sievers <kay.sievers@vrfy.org>, Dave Jones <davej@redhat.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, tigran@aivazian.fsnet.co.uk,
        hpa@zytor.com, x86@kernel.org
Subject: Re: [PATCH 2/2] x86, microcode: Ensure that module is only loaded
 for
References: <20120411163849.GE4794@alberich.amd.com> <20120411200601.GC12288@kroah.com> <20120411201053.GF18114@aftab> <20120412162351.GJ24549@aftab> <20120412163422.GM24549@aftab>
In-Reply-To: <20120412163422.GM24549@aftab>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12041522-0260-0000-0000-000000E01E92
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12/2012 10:04 PM, Borislav Petkov wrote:

> From: Andreas Herrmann <andreas.herrmann3@amd.com>
> Date: Thu, 12 Apr 2012 16:51:57 +0200
> Subject: [PATCH 2/2] x86, microcode: Ensure that module is only loaded for supported AMD CPUs
> 
> Exit early when there's no support for a particular CPU family. Also,
> fixup the "no support for this CPU vendor" to be issued only when the
> driver is attempted to be loaded on an unsupported vendor.
> 
> Cc: stable@vger.kernel.org
> Cc: Tigran Aivazian <tigran@aivazian.fsnet.co.uk>
> Cc: Borislav Petkov <borislav.petkov@amd.com>
> [Boris: added a commit msg because Andreas is lazy]
> Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
> ---


I guess a similar change in intel microcode driver would also be
worthwhile, right? If so, then the below patch might be useful:

----------------->

From: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Subject: x86, microcode: Ensure that module is only loaded on supported Intel CPUs

Exit early when there's no support for a particular CPU family.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 arch/x86/kernel/microcode_intel.c |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/microcode_intel.c b/arch/x86/kernel/microcode_intel.c
index 3ca42d0..0327e2b 100644
--- a/arch/x86/kernel/microcode_intel.c
+++ b/arch/x86/kernel/microcode_intel.c
@@ -147,12 +147,6 @@ static int collect_cpu_info(int cpu_num, struct cpu_signature *csig)
 
 	memset(csig, 0, sizeof(*csig));
 
-	if (c->x86_vendor != X86_VENDOR_INTEL || c->x86 < 6 ||
-	    cpu_has(c, X86_FEATURE_IA64)) {
-		pr_err("CPU%d not a capable Intel processor\n", cpu_num);
-		return -1;
-	}
-
 	csig->sig = cpuid_eax(0x00000001);
 
 	if ((c->x86_model >= 5) || (c->x86 > 6)) {
@@ -463,6 +457,14 @@ static struct microcode_ops microcode_intel_ops = {
 
 struct microcode_ops * __init init_intel_microcode(void)
 {
+	struct cpuinfo_x86 *c = &cpu_data(0);
+
+	if (c->x86_vendor != X86_VENDOR_INTEL || c->x86 < 6 ||
+	    cpu_has(c, X86_FEATURE_IA64)) {
+		pr_err("Intel CPU family 0x%x not supported\n", c->x86);
+		return NULL;
+	}
+
 	return &microcode_intel_ops;
 }
 


