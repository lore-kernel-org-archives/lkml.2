Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754518Ab1AUQkc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 11:40:32 -0500
Received: from mtagate7.uk.ibm.com ([194.196.100.167]:51065 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754451Ab1AUQka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 11:40:30 -0500
Date: Fri, 21 Jan 2011 16:40:19 +0000
From: "Dr. David Alan Gilbert" <david.gilbert@linaro.org>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        acme@ghostprotocols.net, mingo@elte.hu
Cc: dave.martin@linaro.org
Subject: [PATCH] fix perf Annotation of Thumb code
Message-ID: <20110121163922.GA31398@davesworkthinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
  In ARM's Thumb mode the bottom bit of the symbol address is set to mark
the function as Thumb; the instructions are in reality 2 or 4 byte on 2
byte alignments, and when the +1 address is used in annotate it causes
objdump to disassemble invalid instructions.  

  The patch removes that bottom bit during symbol loading.
  This patch is against current linus's git, (2b1caf.....).
  Many thinks to Dave Martin for comments on an initial version of the patch.
  
 
Dave

(For reference this corresponds to this bug
https://bugs.launchpad.net/linux-linaro/+bug/677547 )

        Signed-off-by: Dr. David Alan Gilbert <david.gilbert@linaro.org>  
---

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 15ccfba..36e76c1 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1161,6 +1161,13 @@ static int dso__load_sym(struct dso *self, struct map *map, const char *name,
 
 		section_name = elf_sec__name(&shdr, secstrs);
 
+		/* On ARM, symbols for thumb functions have 1 added to
+		 * the symbol address as a flag - remove it */
+		if ((ehdr.e_machine == EM_ARM) &&
+			(map->type == MAP__FUNCTION) &&
+			(sym.st_value & 1))
+			sym.st_value-=1;
+
 		if (self->kernel != DSO_TYPE_USER || kmodule) {
 			char dso_name[PATH_MAX];
 
