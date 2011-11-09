Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936280Ab1KJEGm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 23:06:42 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44744 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965637Ab1KJDpL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:45:11 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:31:58 2011
Message-Id: <20111109213158.410056663@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:33:28 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jiri Kosina <jkosina@suse.cz>,
        Ingo Molnar <mingo@elte.hu>, Russell King <rmk@arm.linux.org.uk>,
        "H.J. Lu" <hongjiu.lu@intel.com>, <stable@kernel.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>
Subject: [161/264] binfmt_elf: fix PIE execution with randomization disabled
In-Reply-To: <20111109213508.GA3476@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Kosina <jkosina@suse.cz>

commit a3defbe5c337dbc6da911f8cc49ae3cc3b49b453 upstream.

The case of address space randomization being disabled in runtime through
randomize_va_space sysctl is not treated properly in load_elf_binary(),
resulting in SIGKILL coming at exec() time for certain PIE-linked binaries
in case the randomization has been disabled at runtime prior to calling
exec().

Handle the randomize_va_space == 0 case the same way as if we were not
supporting .text randomization at all.

Based on original patch by H.J. Lu and Josh Boyer.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: H.J. Lu <hongjiu.lu@intel.com>
Cc: <stable@kernel.org>
Tested-by: Josh Boyer <jwboyer@redhat.com>
Acked-by: Nicolas Pitre <nicolas.pitre@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/binfmt_elf.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -795,7 +795,16 @@ static int load_elf_binary(struct linux_
 			 * might try to exec.  This is because the brk will
 			 * follow the loader, and is not movable.  */
 #if defined(CONFIG_X86) || defined(CONFIG_ARM)
-			load_bias = 0;
+			/* Memory randomization might have been switched off
+			 * in runtime via sysctl.
+			 * If that is the case, retain the original non-zero
+			 * load_bias value in order to establish proper
+			 * non-randomized mappings.
+			 */
+			if (current->flags & PF_RANDOMIZE)
+				load_bias = 0;
+			else
+				load_bias = ELF_PAGESTART(ELF_ET_DYN_BASE - vaddr);
 #else
 			load_bias = ELF_PAGESTART(ELF_ET_DYN_BASE - vaddr);
 #endif


