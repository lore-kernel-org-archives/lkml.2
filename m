Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752191Ab1GaQjq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 12:39:46 -0400
Received: from vms173005pub.verizon.net ([206.46.173.5]:55184 "EHLO
	vms173005pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299Ab1GaQjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 12:39:39 -0400
X-Greylist: delayed 3601 seconds by postgrey-1.27 at vger.kernel.org; Sun, 31 Jul 2011 12:39:39 EDT
Date: Sun, 31 Jul 2011 11:37:08 -0400 (EDT)
From: Peter Foley <pefoley2@verizon.net>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Kbuild Mailing List <linux-kbuild@vger.kernel.org>,
        mmarek@suse.cz, lacombar@gmail.com
Subject: kbuild: prevent make from deleting _shipped files
Message-id: <alpine.LNX.2.00.1107311134490.30666@linux>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 7373f4f (kbuild: add implicit rules for parser generation)
created a implicit rule chain (%.c: %.c_shipped: %.y). This causes make to delete the _shipped files
because it considers them intermediate files. Mark the _shipped files PRECIOUS
to prevent make from deleting them.

Signed-off-by: Peter Foley <pefoley2@verizon.net>
---

diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
index aeea84a..5d986d9 100644
--- a/scripts/Makefile.lib
+++ b/scripts/Makefile.lib
@@ -167,6 +167,7 @@ ifdef REGENERATE_PARSERS
 quiet_cmd_gperf = GPERF $@
       cmd_gperf = gperf -t --output-file $@ -a -C -E -g -k 1,3,$$ -p -t $<
 
+.PRECIOUS: $(src)/%.hash.c_shipped
 $(src)/%.hash.c_shipped: $(src)/%.gperf
 	$(call cmd,gperf)
 
@@ -177,6 +178,7 @@ LEX_PREFIX = $(if $(LEX_PREFIX_${baseprereq}),$(LEX_PREFIX_${baseprereq}),yy)
 quiet_cmd_flex = LEX     $@
       cmd_flex = flex -o$@ -L -P $(LEX_PREFIX) $<
 
+.PRECIOUS: $(src)/%.lex.c_shipped
 $(src)/%.lex.c_shipped: $(src)/%.l
 	$(call cmd,flex)
 
@@ -187,12 +189,14 @@ YACC_PREFIX = $(if $(YACC_PREFIX_${baseprereq}),$(YACC_PREFIX_${baseprereq}),yy)
 quiet_cmd_bison = YACC    $@
       cmd_bison = bison -o$@ -t -l -p $(YACC_PREFIX) $<
 
+.PRECIOUS: $(src)/%.tab.c_shipped
 $(src)/%.tab.c_shipped: $(src)/%.y
 	$(call cmd,bison)
 
 quiet_cmd_bison_h = YACC    $@
       cmd_bison_h = bison -o/dev/null --defines=$@ -t -l -p $(YACC_PREFIX) $<
 
+.PRECIOUS: $(src)/%.tab.h_shipped
 $(src)/%.tab.h_shipped: $(src)/%.y
 	$(call cmd,bison_h)
 
