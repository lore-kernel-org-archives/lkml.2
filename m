Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756728Ab1JMR3z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 13:29:55 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:57498 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756446Ab1JMR3x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 13:29:53 -0400
Message-ID: <4E972001.3080204@linux.vnet.ibm.com>
Date: Thu, 13 Oct 2011 22:59:37 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Tejun Heo <tj@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, "pavel@ucw.cz" <pavel@ucw.cz>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "suresh.b.siddha@intel.com" <suresh.b.siddha@intel.com>,
        "lucas.demarchi@profusion.mobi" <lucas.demarchi@profusion.mobi>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        "rdunlap@xenotime.net" <rdunlap@xenotime.net>,
        "vatsa@linux.vnet.ibm.com" <vatsa@linux.vnet.ibm.com>,
        "ashok.raj@intel.com" <ashok.raj@intel.com>,
        "tigran@aivazian.fsnet.co.uk" <tigran@aivazian.fsnet.co.uk>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: Re: [PATCH v2 2/3] Mutually exclude cpu online and suspend/hibernate
References: <20111010123102.15067.23128.stgit@srivatsabhat.in.ibm.com> <201110122131.08811.rjw@sisk.pl> <4E9605C7.5070203@linux.vnet.ibm.com> <201110130009.26552.rjw@sisk.pl> <4E9706D8.5040105@linux.vnet.ibm.com> <20111013160602.GJ6281@google.com> <20111013170153.GB3064@aftab>
In-Reply-To: <20111013170153.GB3064@aftab>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/13/2011 10:31 PM, Borislav Petkov wrote:
> On Thu, Oct 13, 2011 at 12:06:02PM -0400, Tejun Heo wrote:
>> I hate to sound like a broken recorder but the above patch isn't
>> strictly correct for hot-swap cases, right?
> 
> hpa is working on a ucode loading solution which will take care of your
> hotswap case too.
> 

Tejun, I have written a patch below (untested) that does what you said.
So Boris, hpa's work would make such a patch unnecessary is it?

Thanks,
Srivatsa S. Bhat

---

 arch/x86/kernel/microcode_core.c |   33 +++++++++++++++++++++++++++++++++
 1 files changed, 33 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/microcode_core.c b/arch/x86/kernel/microcode_core.c
index f924280..849ae2d 100644
--- a/arch/x86/kernel/microcode_core.c
+++ b/arch/x86/kernel/microcode_core.c
@@ -155,6 +155,27 @@ static int collect_cpu_info(int cpu)
 	return ret;
 }
 
+/*
+ * Compare the microcode revision that the kernel has in memory
+ * for this cpu and the microcode revision that we need to apply
+ * on this cpu. If they match, return 0, else return -1.
+ */
+static int compare_cpu_with_microcode(int cpu)
+{
+	struct ucode_cpu_info *uci_mem = ucode_cpu_info + cpu;
+	struct ucode_cpu_info uci_cpu;
+	int ret;
+
+	ret = collect_cpu_info_on_target(cpu, &uci_cpu->cpu_sig);
+	if(!ret) {
+		if (!(uci_mem->cpu_sig->sig == uci_cpu->cpu_sig->sig &&
+		      uci_mem->cpu_sig->pf == uci_cpu->cpu_sig->pf &&
+		      uci_mem->cpu_sig->rev == uci_cpu->cpu_sig->rev))
+			ret = -1;
+	}
+	return ret;
+}
+
 struct apply_microcode_ctx {
 	int err;
 };
@@ -397,6 +418,18 @@ static enum ucode_state microcode_update_cpu(int cpu)
 	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
 	enum ucode_state ustate;
 
+	/*
+	 * If the CPU on which we are going to update the
+	 * microcode and the microcode which we currently
+	 * have in kernel memory are incompatible, then
+	 * invalidate the microcode that we have (and also
+	 * free its memory), so that we can get the required
+	 * microcode afresh.
+	 */
+	if (compare_cpu_with_microcode(cpu)) {
+		microcode_fini_cpu(cpu);
+	}
+
 	if (uci->valid)
 		ustate = microcode_resume_cpu(cpu);
 	else

