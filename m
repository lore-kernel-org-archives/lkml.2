Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932719Ab2AXCrn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 21:47:43 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50535 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932655Ab2AXCrj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 21:47:39 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Jan 23 18:39:30 2012
Message-Id: <20120124023930.389023610@clark.kroah.org>
User-Agent: quilt/0.50-11.1
Date: Mon, 23 Jan 2012 18:34:53 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, David Daney <david.daney@cavium.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [073/129] recordmcount: Fix handling of elf64 big-endian objects.
In-Reply-To: <20120124024041.GA18422@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------
Content-Length: 1330
Lines: 39

From: David Daney <david.daney@cavium.com>

commit 2e885057b7f75035f0b85e02f737891482815a81 upstream.

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

Link: http://lkml.kernel.org/r/1324345362-12230-1-git-send-email-ddaney.cavm@gmail.com

Signed-off-by: David Daney <david.daney@cavium.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 scripts/recordmcount.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/recordmcount.h
+++ b/scripts/recordmcount.h
@@ -462,7 +462,7 @@ __has_rel_mcount(Elf_Shdr const *const r
 		succeed_file();
 	}
 	if (w(txthdr->sh_type) != SHT_PROGBITS ||
-	    !(w(txthdr->sh_flags) & SHF_EXECINSTR))
+	    !(_w(txthdr->sh_flags) & SHF_EXECINSTR))
 		return NULL;
 	return txtname;
 }


