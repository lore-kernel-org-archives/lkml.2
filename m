Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757080Ab1CRPbb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 11:31:31 -0400
Received: from dd12738.kasserver.com ([85.13.134.246]:35645 "EHLO
	dd12738.kasserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756994Ab1CRPbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 11:31:25 -0400
X-Greylist: delayed 1409 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Mar 2011 11:31:25 EDT
Message-ID: <4D83757D.2060904@bluescreen.de>
Date: Fri, 18 Mar 2011 16:08:45 +0100
From: Maximilian Pasternak <max.nospam.q2.2011@bluescreen.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; de; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH] kernel build: issue whith "make tar-pkg" with INSTALL_FW_PATH
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

"make tar-pkg" with set INSTALL_FW_PATH does not work like expected.

Initial situation:
------------------
building a kernel package with
| make tar-pkg INSTALL_FW_PATH=/somewhere


Expected result:
----------------
* tar-archive including the firmware in folder /somehere


Result:
-------
* tar-archive without firmware
* firmware on hd in folder /somewhere


Reason:
-------
Makefile:
| # Firmware install
| INSTALL_FW_PATH=$(INSTALL_MOD_PATH)/lib/firmware
| export INSTALL FW PATH
...
| firmware_install: FORCE
|      @mkdir -p $(objtree)/firmware
|      $(Q)$(MAKE) -f $(srctree)/scripts/Makefile.fwinst obj=firmware
__fw_install

Here INSTALL_MOD_PATH is not considered but is needed for packageing.


Potential fix:
--------------

--- BEGIN PATCH -------------------------------------------------------
diff -ur linux-2.6.38_orig/Makefile linux-2.6.38/Makefile
--- linux-2.6.38_orig/Makefile    2011-03-13 18:24:19.000000000 +0200
+++ linux-2.6.38/Makefile    2011-03-13 18:31:05.000000000 +0200
@@ -1028,8 +1028,9 @@
 
 #
---------------------------------------------------------------------------
 # Firmware install
-INSTALL_FW_PATH=$(INSTALL_MOD_PATH)/lib/firmware
-export INSTALL_FW_PATH
+INSTALL_FW_PATH=/lib/firmware
+INSTALL_FW_TO_PATH=$(INSTALL_MOD_PATH)$(INSTALL_FW_PATH)
+export INSTALL_FW_TO_PATH
 
 PHONY += firmware_install
 firmware_install: FORCE
diff -ur linux-2.6.38_orig/scripts/Makefile.fwinst
linux-2.6.38/scripts/Makefile.fwinst
--- linux-2.6.38_orig/scripts/Makefile.fwinst    2011-03-13
18:25:47.000000000 +0200
+++ linux-2.6.38/scripts/Makefile.fwinst    2011-03-13
18:29:38.000000000 +0200
@@ -24,14 +24,14 @@
 mod-fw += $(fw-shipped-y)
 endif
 
-installed-mod-fw := $(addprefix $(INSTALL_FW_PATH)/,$(mod-fw))
+installed-mod-fw := $(addprefix $(INSTALL_FW_TO_PATH)/,$(mod-fw))
 
-installed-fw := $(addprefix $(INSTALL_FW_PATH)/,$(fw-shipped-all))
-installed-fw-dirs := $(sort $(dir $(installed-fw))) $(INSTALL_FW_PATH)/.
+installed-fw := $(addprefix $(INSTALL_FW_TO_PATH)/,$(fw-shipped-all))
+installed-fw-dirs := $(sort $(dir $(installed-fw))) $(INSTALL_FW_TO_PATH)/.
 
 # Workaround for make < 3.81, where .SECONDEXPANSION doesn't work.
-PHONY += $(INSTALL_FW_PATH)/$$(%) install-all-dirs
-$(INSTALL_FW_PATH)/$$(%): install-all-dirs
+PHONY += $(INSTALL_FW_TO_PATH)/$$(%) install-all-dirs
+$(INSTALL_FW_TO_PATH)/$$(%): install-all-dirs
     @true
 install-all-dirs: $(installed-fw-dirs)
     @true
@@ -42,7 +42,7 @@
 $(installed-fw-dirs):
     $(call cmd,mkdir)
 
-$(installed-fw): $(INSTALL_FW_PATH)/%: $(obj)/% |
$(INSTALL_FW_PATH)/$$(dir %)
+$(installed-fw): $(INSTALL_FW_TO_PATH)/%: $(obj)/% |
$(INSTALL_FW_TO_PATH)/$$(dir %)
     $(call cmd,install)
 
 PHONY +=  __fw_install __fw_modinst FORCE
--- END PATCH ---------------------------------------------------------


Please send answers CC since i have not subscribed to this list.

Thank you

Max

