Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754732Ab1HNQKR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 12:10:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36914 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754654Ab1HNQKJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 12:10:09 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug 12 14:05:59 2011
Message-Id: <20110812210559.045366181@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 12 Aug 2011 14:05:04 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [79/90] powerpc/pseries: Fix kexec on recent firmware versions
In-Reply-To: <20110812210626.GA4725@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Anton Blanchard <anton@samba.org>

commit b1301797f30370c430244979671978fc232f4533 upstream.

Recent versions of firmware will fail to unmap the virtual processor
area if we have a dispatch trace log registered. This causes kexec
to fail.

If a trace log is registered this patch unregisters it before the
SLB shadow and virtual processor areas, fixing the problem.

The address argument is ignored by firmware on unregister so we
may as well remove it.

Signed-off-by: Anton Blanchard <anton@samba.org>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/powerpc/platforms/pseries/dtl.c            |    2 +-
 arch/powerpc/platforms/pseries/kexec.c          |   11 +++++++++++
 arch/powerpc/platforms/pseries/plpar_wrappers.h |    4 ++--
 3 files changed, 14 insertions(+), 3 deletions(-)

--- a/arch/powerpc/platforms/pseries/dtl.c
+++ b/arch/powerpc/platforms/pseries/dtl.c
@@ -181,7 +181,7 @@ static void dtl_stop(struct dtl *dtl)
 
 	lppaca_of(dtl->cpu).dtl_enable_mask = 0x0;
 
-	unregister_dtl(hwcpu, __pa(dtl->buf));
+	unregister_dtl(hwcpu);
 }
 
 static u64 dtl_current_index(struct dtl *dtl)
--- a/arch/powerpc/platforms/pseries/kexec.c
+++ b/arch/powerpc/platforms/pseries/kexec.c
@@ -26,6 +26,17 @@ static void pseries_kexec_cpu_down(int c
 	/* Don't risk a hypervisor call if we're crashing */
 	if (firmware_has_feature(FW_FEATURE_SPLPAR) && !crash_shutdown) {
 		unsigned long addr;
+		int ret;
+
+		if (get_lppaca()->dtl_enable_mask) {
+			ret = unregister_dtl(hard_smp_processor_id());
+			if (ret) {
+				pr_err("WARNING: DTL deregistration for cpu "
+				       "%d (hw %d) failed with %d\n",
+				       smp_processor_id(),
+				       hard_smp_processor_id(), ret);
+			}
+		}
 
 		addr = __pa(get_slb_shadow());
 		if (unregister_slb_shadow(hard_smp_processor_id(), addr))
--- a/arch/powerpc/platforms/pseries/plpar_wrappers.h
+++ b/arch/powerpc/platforms/pseries/plpar_wrappers.h
@@ -73,9 +73,9 @@ static inline long register_slb_shadow(u
 	return vpa_call(0x3, cpu, vpa);
 }
 
-static inline long unregister_dtl(unsigned long cpu, unsigned long vpa)
+static inline long unregister_dtl(unsigned long cpu)
 {
-	return vpa_call(0x6, cpu, vpa);
+	return vpa_call(0x6, cpu, 0);
 }
 
 static inline long register_dtl(unsigned long cpu, unsigned long vpa)


