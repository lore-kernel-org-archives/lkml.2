Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762127Ab2DLShs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 14:37:48 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:40248 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754996Ab2DLShr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 14:37:47 -0400
Date: Thu, 12 Apr 2012 14:37:30 -0400 (EDT)
Message-Id: <20120412.143730.258982831585270742.davem@davemloft.net>
To: linux-kernel@vger.kernel.org
CC: sam@ravnborg.org
Subject: [PATCH] Fix modpost failures in fedora 17
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.4 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 12 Apr 2012 11:37:34 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The symbol table on x86-64 starts to have entries that have names
like:

_GLOBAL__sub_I_65535_0___mod_x86cpu_device_table

They are of type STT_FUNCTION and this one had a length of 18.  This
matched the device ID validation logic and it barfed because the
length did not meet the device type's criteria.

--------------------
FATAL: arch/x86/crypto/aesni-intel: sizeof(struct x86cpu_device_id)=16 is not a modulo of the size of section __mod_x86cpu_device_table=18.
Fix definition of struct x86cpu_device_id in mod_devicetable.h
--------------------

These are some kind of compiler tool internal stuff being emitted and
not something we want to inspect in modpost's device ID table
validation code.

So skip the symbol if it is not of type STT_OBJECT.

Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/scripts/mod/file2alias.c b/scripts/mod/file2alias.c
index 8e730cc..44ddaa5 100644
--- a/scripts/mod/file2alias.c
+++ b/scripts/mod/file2alias.c
@@ -1100,6 +1100,10 @@ void handle_moddevtable(struct module *mod, struct elf_info *info,
 	if (!sym->st_shndx || get_secindex(info, sym) >= info->num_sections)
 		return;
 
+	/* We're looking for an object */
+	if (ELF_ST_TYPE(sym->st_info) != STT_OBJECT)
+		return;
+
 	/* All our symbols are of form <prefix>__mod_XXX_device_table. */
 	name = strstr(symname, "__mod_");
 	if (!name)
