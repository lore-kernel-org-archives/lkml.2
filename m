Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756325Ab0JRTNa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 15:13:30 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:37186 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754457Ab0JRTN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 15:13:28 -0400
X-Authority-Analysis: v=1.1 cv=exbvkCqEOBXDkHq+8n3wanotOBQtbe7qbIajSD+JluU= c=1 sm=0 a=fFCn7IPotaMA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=_gq4xgUj1IwQ4OyMcisA:9 a=GhLQg2cMMuwhWetzGWxsG_m-44sA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: [RFC] better fix? (was: Re: [PATCH][GIT PULL] ftrace: Remove
 recursion between recordmcount and scripts/mod/empty)
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        Sam Ravnborg <sam@ravnborg.org>
In-Reply-To: <1287427989.16971.304.camel@gandalf.stny.rr.com>
References: <1287427989.16971.304.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 18 Oct 2010 15:13:26 -0400
Message-ID: <1287429206.16971.325.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-10-18 at 14:53 -0400, Steven Rostedt wrote:

Just calling attention to this...

> diff --git a/scripts/Makefile.build b/scripts/Makefile.build
> index 4db60b2..9f2d5b4 100644
> --- a/scripts/Makefile.build
> +++ b/scripts/Makefile.build
> @@ -210,7 +210,11 @@ endif
>  
>  ifdef CONFIG_FTRACE_MCOUNT_RECORD
>  ifdef BUILD_C_RECORDMCOUNT
> -cmd_record_mcount = $(objtree)/scripts/recordmcount "$(@)";
> +# Due to recursion, we must skip the empty.o file
> +#  TBD: Find a better way to do this.
> +cmd_record_mcount = if [ $(@) != "scripts/mod/empty.o" ]; then			\
> +			$(objtree)/scripts/recordmcount "$(@)";			\
> +		    fi;
>  else
>  cmd_record_mcount = set -e ; perl $(srctree)/scripts/recordmcount.pl "$(ARCH)" \
>  	"$(if $(CONFIG_CPU_BIG_ENDIAN),big,little)" \
> 

This is pretty much a hack, would adding a patch like the following be a
better idea?

-- Steve

diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index 9f2d5b4..86e360a 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -210,11 +210,7 @@ endif
 
 ifdef CONFIG_FTRACE_MCOUNT_RECORD
 ifdef BUILD_C_RECORDMCOUNT
-# Due to recursion, we must skip the empty.o file
-#  TBD: Find a better way to do this.
-cmd_record_mcount = if [ $(@) != "scripts/mod/empty.o" ]; then			\
-			$(objtree)/scripts/recordmcount "$(@)";			\
-		    fi;
+cmd_record_mcount = $(objtree)/scripts/recordmcount "$(@)";
 else
 cmd_record_mcount = set -e ; perl $(srctree)/scripts/recordmcount.pl "$(ARCH)" \
 	"$(if $(CONFIG_CPU_BIG_ENDIAN),big,little)" \
@@ -236,11 +232,26 @@ define rule_cc_o_c
 	mv -f $(dot-target).tmp $(dot-target).cmd
 endef
 
+define rule_cc_o_c_notrace
+	$(call echo-cmd,checksrc) $(cmd_checksrc)			  \
+	$(call echo-cmd,cc_o_c) $(cmd_cc_o_c);				  \
+	$(cmd_modversions)						  \
+	scripts/basic/fixdep $(depfile) $@ '$(call make-cmd,cc_o_c)' >    \
+	                                              $(dot-target).tmp;  \
+	rm -f $(depfile);						  \
+	mv -f $(dot-target).tmp $(dot-target).cmd
+endef
+
 # Built-in and composite module parts
 $(obj)/%.o: $(src)/%.c FORCE
 	$(call cmd,force_checksrc)
 	$(call if_changed_rule,cc_o_c)
 
+# Due to recursion, recordmcount must not be called on empty.o
+$(objtree)/scripts/mod/empty.o: $(srctree)/scripts/mod/empty.c
+	$(call cmd,force_checksrc)
+	$(call if_changed_rule,cc_o_c_notrace)
+
 # Single-part modules are special since we need to mark them in $(MODVERDIR)
 
 $(single-used-m): $(obj)/%.o: $(src)/%.c FORCE


