Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752696Ab2JQXTT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 19:19:19 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:34616 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752272Ab2JQXTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 19:19:15 -0400
From: Stephen Warren <swarren@wwwdotorg.org>
To: Michal Marek <mmarek@suse.cz>
Cc: Rob Herring <robherring2@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Mitch Bradley <wmb@firmworks.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Scott Wood <scottwood@freescale.com>,
        Segher Boessenkool <segher@kernel.crashing.org>,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Stephen Warren <swarren@nvidia.com>
Subject: [PATCH V4 2/2] kbuild: run the pre-processor on *.dts files
Date: Wed, 17 Oct 2012 17:18:59 -0600
Message-Id: <1350515939-31871-2-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1350515939-31871-1-git-send-email-swarren@wwwdotorg.org>
References: <1350515939-31871-1-git-send-email-swarren@wwwdotorg.org>
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

Modify cmd_dtc to run the C pre-processor on the input .dts file before
passing it to dtc for final compilation. This allows the use of #define
and #include within the .dts file.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
v4:
* Use -x assembler-with-cpp so pre-defined macros are set up so that
  #included header files know to only use cpp syntax, not C syntax.
* Define __DTS__ for similar reasons.
* use $(CPP) not $(CC) -E, and use $(cpp_flags).
* Save the pre-processed results so they can be easily inspected when
  debugging build issues.
* The use of -x assembler-with-cpp causes cpp to recognize directives in
  column 1 only. Hence, there's no need to escape property names that
  begin with #. Hence, there's no need for separate skeleton.dtsi and
  skeleton.dtsip. Maintain a separate file extension and build rule so that
  CPP-usage is opt-in. In particular, when using CPP, #include must be used
  rather than /include/ so that dependencies work.
v3: Pass "-x c" not "-xc" to cpp.
v2: Place make %.dtb: %.dtsp rule into Makefile.lib.
---
 scripts/Makefile.lib |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
index 425578e..33432f4 100644
--- a/scripts/Makefile.lib
+++ b/scripts/Makefile.lib
@@ -269,6 +269,15 @@ cmd_dtc = $(objtree)/scripts/dtc/dtc -O dtb -o $@ -b 0 $(DTC_FLAGS) -d $(depfile
 $(obj)/%.dtb: $(src)/dts/%.dts FORCE
 	$(call if_changed_dep,dtc)
 
+dtc-tmp = $(subst $(comma),_,$(dot-target).dts)
+
+quiet_cmd_dtc_cpp = DTC+CPP $@
+cmd_dtc_cpp = $(CPP) $(cpp_flags) -D__DTS__ -x assembler-with-cpp -o $(dtc-tmp) $< ; \
+	$(objtree)/scripts/dtc/dtc -O dtb -o $@ -b 0 $(DTC_FLAGS) $(dtc-tmp)
+
+$(obj)/%.dtb: $(src)/dts/%.dtsp FORCE
+	$(call if_changed_dep,dtc_cpp)
+
 # Bzip2
 # ---------------------------------------------------------------------------
 
-- 
1.7.0.4

