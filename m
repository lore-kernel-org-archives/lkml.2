Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754035Ab1LTBmx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 20:42:53 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:51731 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753370Ab1LTBmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 20:42:49 -0500
From: David Daney <ddaney.cavm@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, David Daney <david.daney@cavium.com>
Subject: [PATCH] recordmcount: Fix handling of elf64 big-endian objects.
Date: Mon, 19 Dec 2011 17:42:42 -0800
Message-Id: <1324345362-12230-1-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>

In ELF64, the sh_flags field is 64-bits wide.  recordmcount was
erroneously treating it as a 32-bit wide field.  For little endian
objects this works because the flags of interest (SHF_EXECINSTR)
reside in the lower 32 bits of the word, and you get the same result
with either a 32-bit or 64-bit read.  Big endian objects on the
other hand do not work at all with this error.

The fix:  Correctly treat sh_flags as 64-bits wide in elf64 objects.

The symptom I observed was that my
__start_mcount_loc..__stop_mcount_loc was empty even though ftrace
function tracing was enabled.

Signed-off-by: David Daney <david.daney@cavium.com>
---
 scripts/recordmcount.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/recordmcount.h b/scripts/recordmcount.h
index f40a6af6..54e35c1 100644
--- a/scripts/recordmcount.h
+++ b/scripts/recordmcount.h
@@ -462,7 +462,7 @@ __has_rel_mcount(Elf_Shdr const *const relhdr,  /* is SHT_REL or SHT_RELA */
 		succeed_file();
 	}
 	if (w(txthdr->sh_type) != SHT_PROGBITS ||
-	    !(w(txthdr->sh_flags) & SHF_EXECINSTR))
+	    !(_w(txthdr->sh_flags) & SHF_EXECINSTR))
 		return NULL;
 	return txtname;
 }
-- 
1.7.2.3

