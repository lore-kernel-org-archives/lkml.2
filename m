Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030726Ab2HHROu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 13:14:50 -0400
Received: from mail.windriver.com ([147.11.1.11]:34662 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030663Ab2HHROs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 13:14:48 -0400
From: Mark Asselstine <mark.asselstine@windriver.com>
To: <mmarek@suse.cz>
CC: <linux-kernel@vger.kernel.org>, <linux-kbuild@vger.kernel.org>,
        <mark.asselstine@windriver.com>
Subject: [PATCH] firmware: fix directory creation rule matching with make 3.82
Date: Wed, 8 Aug 2012 13:14:36 -0400
Message-ID: <1344446076-9135-1-git-send-email-mark.asselstine@windriver.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [128.224.146.23]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Attempting to run 'firmware_install' with CONFIG_USB_SERIAL_TI=y when
using make 3.82 results in an error

make[2]: *** No rule to make target `/lib/firmware/./', needed by
`/lib/firmware/ti_3410.fw'.  Stop.

It turns out make 3.82 is picky when matching directory names with
trailing slashes as a result, where make 3.81 would handle this
correctly make 3.82 does not find the rule needed to create the
directory.

The './' seen in the error is added by $(dir) for firmware which
resides in the base firmware src directory, such as
ti_3410.fw.ihex. By performing $(dir) after we prepend the
$(INSTALL_FW_PATH) we can ensure we don't end up with a './' in the
middle of the path and the directory will be properly created.

This change works with make 3.81 and should work with previous
versions as well.

Signed-off-by: Mark Asselstine <mark.asselstine@windriver.com>
---
 scripts/Makefile.fwinst |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/Makefile.fwinst b/scripts/Makefile.fwinst
index 6bf8e87..c3f69ae 100644
--- a/scripts/Makefile.fwinst
+++ b/scripts/Makefile.fwinst
@@ -42,7 +42,7 @@ quiet_cmd_install = INSTALL $(subst $(srctree)/,,$@)
 $(installed-fw-dirs):
 	$(call cmd,mkdir)
 
-$(installed-fw): $(INSTALL_FW_PATH)/%: $(obj)/% | $(INSTALL_FW_PATH)/$$(dir %)
+$(installed-fw): $(INSTALL_FW_PATH)/%: $(obj)/% | $$(dir $(INSTALL_FW_PATH)/%)
 	$(call cmd,install)
 
 PHONY +=  __fw_install __fw_modinst FORCE
-- 
1.7.9.5

