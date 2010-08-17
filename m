Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756981Ab0HQL7B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 07:59:01 -0400
Received: from esgaroth.petrovitsch.at ([78.47.184.11]:3927 "EHLO
	esgaroth.petrovitsch.priv.at" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754187Ab0HQL67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 07:58:59 -0400
X-DKIM: Sendmail DKIM Filter v2.8.3 unknown-host o7HBw0FT025457
Subject: Re: [PATCH] perf tools: Don't use brace expansion.
From: Bernd Petrovitsch <bernd@sysprog.at>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Kusanagi Kouichi <slash@ac.auone-net.jp>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20100816155022.GD13095@ghostprotocols.net>
References: <20100816124101.1829415C039@msa104.auone-net.jp>
	 <1281967761.17267.6.camel@thorin> <1281969043.1926.1469.camel@laptop>
	 <1281970478.17267.12.camel@thorin>
	 <20100816152914.GC13095@ghostprotocols.net>
	 <1281973427.17267.16.camel@thorin>
	 <20100816155022.GD13095@ghostprotocols.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 17 Aug 2010 13:58:00 +0200
Message-ID: <1282046280.5822.4.camel@thorin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
X-DCC-HP_X86_64_4CPU-Metrics: esgaroth.petrovitsch.priv.at; whitelist
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-08-16 at 12:50 -0300, Arnaldo Carvalho de Melo wrote:
> Em Mon, Aug 16, 2010 at 05:43:47PM +0200, Bernd Petrovitsch escreveu:
> > On Mon, 2010-08-16 at 12:29 -0300, Arnaldo Carvalho de Melo wrote:
> > > More seriously, so there is a reason for that to be like that and you're
> > > not aware of any other shorter or more convenient way of achieving that
> 
> > One (obvious) alternative is to have rules triggering on the
> > non-existence of these directories.
> 
> Can you provide those please?
[...]
> Right, not enough, what those mkdir calls were added for was exactly for
> a different usecase:
> 
> make -C tools/perf -O=~/build/perf/

Thanks.

The following patch below at the end works for me. Alas, it is against
vanilla main line.
----  snip  ----
Replace the global $(shell ...) lines quite at the top creating the output
directories with real rules.

Signed-of-by: Bernd Petrovitsch <bernd@sysprog.at>
---
 tools/perf/Makefile |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 230a0f7..c039fbc 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -157,10 +157,6 @@ all::
 #
 # Define NO_DWARF if you do not want debug-info analysis feature at all.
 
-$(shell sh -c 'mkdir -p $(OUTPUT)scripts/{perl,python}/Perf-Trace-Util/' 2> /dev/null)
-$(shell sh -c 'mkdir -p $(OUTPUT)util/{ui/browsers,scripting-engines}/' 2> /dev/null)
-$(shell sh -c 'mkdir $(OUTPUT)bench' 2> /dev/null)
-
 $(OUTPUT)PERF-VERSION-FILE: .FORCE-PERF-VERSION-FILE
 	@$(SHELL_PATH) util/PERF-VERSION-GEN $(OUTPUT)
 -include $(OUTPUT)PERF-VERSION-FILE
@@ -186,8 +182,6 @@ ifeq ($(ARCH),x86_64)
         ARCH := x86
 endif
 
-$(shell sh -c 'mkdir -p $(OUTPUT)arch/$(ARCH)/util/' 2> /dev/null)
-
 # CFLAGS and LDFLAGS are for the users to override from the command line.
 
 #
@@ -1012,6 +1006,13 @@ $(LIB_OBJS) $(BUILTIN_OBJS): $(LIB_H)
 $(patsubst perf-%$X,%.o,$(PROGRAMS)): $(LIB_H) $(wildcard */*.h)
 builtin-revert.o wt-status.o: wt-status.h
 
+# we compile into subdirectories. if the target directory is not the source directory, they might not exists. So
+# we depend the various files onto their directories.
+$(LIB_OBJS) $(BUILTIN_OBJS): $(sort $(dir $(LIB_OBJS) $(BUILTIN_OBJS)))
+# In the second step, we make a rule to actually create these directories
+$(sort $(dir $(LIB_OBJS) $(BUILTIN_OBJS))):
+	mkdir -p $@ 2>/dev/null
+
 $(LIB_FILE): $(LIB_OBJS)
 	$(QUIET_AR)$(RM) $@ && $(AR) rcs $@ $(LIB_OBJS)
----  snip  ----

	Bernd
-- 
mobile: +43 664 4416156              http://www.sysprog.at/
    Linux Software Development, Consulting and Services

