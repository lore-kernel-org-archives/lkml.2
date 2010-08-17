Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758165Ab0HQSRX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 14:17:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7842 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753145Ab0HQSRV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 14:17:21 -0400
Date: Tue, 17 Aug 2010 15:16:54 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Bernd Petrovitsch <bernd@sysprog.at>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Kusanagi Kouichi <slash@ac.auone-net.jp>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf tools: Don't use brace expansion.
Message-ID: <20100817181654.GH13095@ghostprotocols.net>
References: <20100816124101.1829415C039@msa104.auone-net.jp> <1281967761.17267.6.camel@thorin> <1281969043.1926.1469.camel@laptop> <1281970478.17267.12.camel@thorin> <20100816152914.GC13095@ghostprotocols.net> <1281973427.17267.16.camel@thorin> <20100816155022.GD13095@ghostprotocols.net> <1282046280.5822.4.camel@thorin> <20100817154237.GG13095@ghostprotocols.net> <1282061389.5822.22.camel@thorin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282061389.5822.22.camel@thorin>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Aug 17, 2010 at 06:09:49PM +0200, Bernd Petrovitsch escreveu:
> On Die, 2010-08-17 at 12:42 -0300, Arnaldo Carvalho de Melo wrote:
> > +# we compile into subdirectories. if the target directory is not the source directory, they might not exists. So
> > +# we depend the various files onto their directories.
> > +$(LIB_OBJS) $(BUILTIN_OBJS) $(OUTPUT)PERF-VERSION-FILE $(OUTPUT)common-cmds.h: $(sort $(dir $(LIB_OBJS) $(BUILTIN_OBJS)))
 
> Hmm, that adds that $(OUTPUT)PERF-VERSION-FILE and
> $(OUTPUT)common-cmds.h (also) depends on the subdirectories of the other
> objects (and thus it works always because at least one of them is a
> subdirectory of $(OUTPUT)).
> To be 110% anal, it should look like e.g.
> +$(LIB_OBJS) $(BUILTIN_OBJS) $(OUTPUT)PERF-VERSION-FILE $(OUTPUT)common-cmds.h: $(sort $(dir $(LIB_OBJS) $(BUILTIN_OBJS)) $(OUTPUT))

> or actually all targets.

> > +# In the second step, we make a rule to actually create these directories
> > +$(sort $(dir $(LIB_OBJS) $(BUILTIN_OBJS))):
> > +       mkdir -p $@ 2>/dev/null

> BTW there is no automatic variable or other make-construct to refer in
> the dependencies on the own target. Therefore the copy-paste-the-
> variables solution.

> Perhaps an additional variable reduces clutter (and eases maintenance)?

> +# we compile into subdirectories. if the target directory is not the source directory, they might not exists. So
> +# we depend the various files onto their directories.
> +DIRECTORY_DEPS = $(LIB_OBJS) $(BUILTIN_OBJS) $(OUTPUT)PERF-VERSION-FILE $(OUTPUT)common-cmds.h
> +$(DIRECTORY_DEPS): $(sort $(dir $(DIRECTORY_DEPS)))
> +# In the second step, we make a rule to actually create these directories
> +$(sort $(dir $(DIRECTORY_DEPS))):
> +       mkdir -p $@ 2>/dev/null

> That should guarantee that all directories from the targets are created.

> > As it was failing when I did:

> > rm -rf ~/build/perf
> > make -C tools/perf O=~/build/perf

> > With that it retains the existing functionality,

> Ah, I `mkdir`ed the output directory explicitly before the `make` (and
> after the `rm -rf`).

> BTW which is the preferred tree to base patches on (for the "perf"
> subsystem)?

git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip

perf/urgent for 2.6.36
perf/core for 2.6.37

I'm targeting perf/urgent for this fix.

Or git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux-2.6

Sometimes, when Ingo is busy and patches accumulate, perf/{core,urgent}
are where I put things to go to the branches with the same names on his
tree.

Please look if patch is OK with you.

- Arnaldo

commit 033a273f9836b592dd568abd0f655be469d66704
Author: Bernd Petrovitsch <bernd@sysprog.at>
Date:   Tue Aug 17 12:22:08 2010 -0300

    perf tools: Fix build on POSIX shells
    
    POSIX sh does not specify the brace expansion, so fix it by replacing the
    global $(shell ...) lines quite at the top creating the output directories with
    real rules.
    
    Cc: Ingo Molnar <mingo@elte.hu>
    Cc: Kusanagi Kouichi <slash@ac.auone-net.jp>
    Cc: Peter Zijlstra <peterz@infradead.org>
    Cc: Paul Mackerras <paulus@samba.org>
    LKML-Reference: <1282046280.5822.4.camel@thorin>
    Signed-off-by: Bernd Petrovitsch <bernd@sysprog.at>
    Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 41abb90..dcb9700 100644
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
@@ -268,6 +262,7 @@ export prefix bindir sharedir sysconfdir
 CC = $(CROSS_COMPILE)gcc
 AR = $(CROSS_COMPILE)ar
 RM = rm -f
+MKDIR = mkdir
 TAR = tar
 FIND = find
 INSTALL = install
@@ -838,6 +833,7 @@ ifndef V
 	QUIET_CC       = @echo '   ' CC $@;
 	QUIET_AR       = @echo '   ' AR $@;
 	QUIET_LINK     = @echo '   ' LINK $@;
+	QUIET_MKDIR    = @echo '   ' MKDIR $@;
 	QUIET_BUILT_IN = @echo '   ' BUILTIN $@;
 	QUIET_GEN      = @echo '   ' GEN $@;
 	QUIET_SUBDIR0  = +@subdir=
@@ -1012,6 +1008,14 @@ $(LIB_OBJS) $(BUILTIN_OBJS): $(LIB_H)
 $(patsubst perf-%$X,%.o,$(PROGRAMS)): $(LIB_H) $(wildcard */*.h)
 builtin-revert.o wt-status.o: wt-status.h
 
+# we compile into subdirectories. if the target directory is not the source directory, they might not exists. So
+# we depend the various files onto their directories.
+DIRECTORY_DEPS = $(LIB_OBJS) $(BUILTIN_OBJS) $(OUTPUT)PERF-VERSION-FILE $(OUTPUT)common-cmds.h
+$(DIRECTORY_DEPS): $(sort $(dir $(DIRECTORY_DEPS)))
+# In the second step, we make a rule to actually create these directories
+$(sort $(dir $(DIRECTORY_DEPS))):
+	$(QUIET_MKDIR)$(MKDIR) -p $@ 2>/dev/null
+
 $(LIB_FILE): $(LIB_OBJS)
 	$(QUIET_AR)$(RM) $@ && $(AR) rcs $@ $(LIB_OBJS)
 
