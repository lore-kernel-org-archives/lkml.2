Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753490Ab1BYCfI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 21:35:08 -0500
Received: from cantor.suse.de ([195.135.220.2]:39993 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752852Ab1BYCfG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 21:35:06 -0500
Message-ID: <4D671556.80607@suse.com>
Date: Thu, 24 Feb 2011 21:35:02 -0500
From: Jeff Mahoney <jeffm@suse.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101206 SUSE/3.1.7 Thunderbird/3.1.7
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Roman Zippel <zippel@linux-m68k.org>, linux-kbuild@vger.kernel.org
Subject: [PATCH] Add ``cloneconfig'' target
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cloneconfig takes the first configuration it finds which appears
to belong to the running kernel, and configures the kernel sources
to match this configuration as closely as possible.

Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 scripts/kconfig/Makefile |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

--- a/scripts/kconfig/Makefile
+++ b/scripts/kconfig/Makefile
@@ -99,6 +99,23 @@ PHONY += allnoconfig allyesconfig allmod
 
 allnoconfig allyesconfig allmodconfig alldefconfig randconfig: $(obj)/conf
 	$< --$@ $(Kconfig)
+ 
+UNAME_RELEASE := $(shell uname -r)
+CLONECONFIG := $(firstword $(wildcard /proc/config.gz \
+				      /lib/modules/$(UNAME_RELEASE)/.config \
+				      /etc/kernel-config \
+				      /boot/config-$(UNAME_RELEASE)))
+cloneconfig: $(obj)/conf
+	$(Q)case "$(CLONECONFIG)" in				\
+	'')	echo -e "The configuration of the running"	\
+			"kernel could not be determined\n";	\
+		false ;;					\
+	*.gz)	gzip -cd $(CLONECONFIG) > .config.running ;;	\
+	*)	cat $(CLONECONFIG) > .config.running ;;		\
+	esac &&							\
+	echo -e "Cloning configuration file $(CLONECONFIG)\n"
+	$(Q)$< -D .config.running arch/$(SRCARCH)/Kconfig
+
 
 PHONY += listnewconfig oldnoconfig savedefconfig defconfig
 
-- 
Jeff Mahoney
SUSE Labs
