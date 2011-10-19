Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756998Ab1JSRSM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 13:18:12 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:46240 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755669Ab1JSRSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 13:18:10 -0400
Message-ID: <4E9F05F9.7080901@linux.vnet.ibm.com>
Date: Wed, 19 Oct 2011 22:46:41 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Tejun Heo <tj@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "tigran@aivazian.fsnet.co.uk" <tigran@aivazian.fsnet.co.uk>,
        "mingo@elte.hu" <mingo@elte.hu>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] CPU hotplug, x86 microcode: Revalidate microcode before microcode
 update
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 11101917-2674-0000-0000-000000E7EB95
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Boris, you had mentioned that hpa's new ucode loading solution would
take care of hot-swap cases too.
I am referring to:
http://thread.gmane.org/gmane.linux.documentation/3414/focus=3454

However, since I am not aware of what hpa's new ucode loading solution
is, nor how it will handle this case, I thought of posting this patch
(now tested and fine-tuned), so that it can be applied in case this
patch is deemed to be necessary/desirable to avoid breaking hot-swap cases.

Thanks,
Srivatsa S. Bhat

---

This patch is intended to go with the patch posted at
http://thread.gmane.org/gmane.linux.kernel/1200882/focus=1200991

Since that patch optimizes microcode update by keeping the microcode image
in kernel memory and not freeing it up even when the CPU goes offline, it
means we would be applying the same microcode image when the CPU comes back
online.

However, if physically hotplugging of CPUs is supported, then we could
physically hot-unplug CPUs and then hot-plug new (and possibly a different
type of) CPUs. In such a case, it would be wrong to blindly apply the same
old microcode (that the kernel maintained for the old CPU) to this new CPU.

Hence, this patch adds a validation to check whether the microcode revision
we have in kernel memory and the revision that needs to be applied to the
CPU that was just brought online, are the same or not. If they happen to be
different, then it invalidates and frees the kernel's copy of the microcode,
triggering a fresh request to userspace to get the appropriate microcode
image for this CPU.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 arch/x86/kernel/microcode_core.c |   35 +++++++++++++++++++++++++++++++++++
 1 files changed, 35 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/microcode_core.c b/arch/x86/kernel/microcode_core.c
index f924280..1b353a3 100644
--- a/arch/x86/kernel/microcode_core.c
+++ b/arch/x86/kernel/microcode_core.c
@@ -155,6 +155,30 @@ static int collect_cpu_info(int cpu)
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
+	memset(&uci_cpu, 0, sizeof(uci_cpu));
+
+	ret = collect_cpu_info_on_target(cpu, &uci_cpu.cpu_sig);
+	if (!ret) {
+		if (!(uci_mem->cpu_sig.sig == uci_cpu.cpu_sig.sig &&
+		      uci_mem->cpu_sig.pf == uci_cpu.cpu_sig.pf &&
+		      uci_mem->cpu_sig.rev == uci_cpu.cpu_sig.rev))
+			ret = -1;
+	}
+
+	return ret;
+}
+
 struct apply_microcode_ctx {
 	int err;
 };
@@ -397,6 +421,17 @@ static enum ucode_state microcode_update_cpu(int cpu)
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
+	if (compare_cpu_with_microcode(cpu))
+		microcode_fini_cpu(cpu);
+
 	if (uci->valid)
 		ustate = microcode_resume_cpu(cpu);
 	else


