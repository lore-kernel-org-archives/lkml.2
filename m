Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757568Ab1FGV1O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 17:27:14 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:58299 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433Ab1FGV1M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 17:27:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=EzAN797lPYPPb3TN4TpT81yPdUh5w93w6lBNtLjP2lPcZ9hMEfV6bzLt4j9DMC1k/C
         eiHGgKXI2iu3Hd7Zq9M/nqKQZYI44gXb8Q2qk5mj/2W91MyyEIVBEAt35SPfHOgfQWiO
         Pd9fl2Y1sAfEElgUvxyw1QbvaazhuaM7s9+mM=
MIME-Version: 1.0
In-Reply-To: <1307479931-10424-1-git-send-email-lacombar@gmail.com>
References: <20110607152950.GA4612@sepie.suse.cz>
	<1307479931-10424-1-git-send-email-lacombar@gmail.com>
Date: Tue, 7 Jun 2011 17:27:12 -0400
Message-ID: <BANLkTi=Q_DJ7eg=tQFYNtRDQMd+ZsbwVYA@mail.gmail.com>
Subject: Re: [RFCv4] Kbuild: factor parser rules
From: Arnaud Lacombe <lacombar@gmail.com>
To: linux-kbuild@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Cc: Michal Marek <mmarek@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

[Bringing that on linux-kernel@, to try to get a little more audience,
and eventually a gmake(1) guru. Original motivation about the serie
available at http://marc.info/?l=linux-kbuild&m=130456101131801&w=2.
All diff applies to the v4 of the RFC.]

On Tue, Jun 7, 2011 at 4:52 PM, Arnaud Lacombe <lacombar@gmail.com> wrote:
> [...]
> Changes since v3:
>  - fix the %_shipped implicit rule
>  - attempt to tweak the relation between `$(src)/%.tab.c_shipped' and
>   `$(src)/%.tab.h_shipped' to make it more robust. This is _very_ delicate as
>   gmake has trouble to properly generate `$(obj)/%.tab.h' from
>   `$(src)/%.tab.h_shipped' if it is missing and requires
>   `$(src)/%.tab.c_shipped' to be created. This now survives a full deletion of
>   the %_shipped file.
Just to illustrate the delicacy of this part, forbidding make(1) to
delete the intermediate target, by declaring a .SECONDARY target
without any prerequisite (which would seem a desirable behavior):

diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index a0fd502..801dc84 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -463,3 +463,5 @@ endif
 # information in a variable se we can use it in if_changed and friends.

 .PHONY: $(PHONY)
+
+.SECONDARY:

require to change the order of the .c and .h in the prerequisite:

diff --git a/scripts/dtc/Makefile b/scripts/dtc/Makefile
index a957ab4..87d3374 100644
--- a/scripts/dtc/Makefile
+++ b/scripts/dtc/Makefile
@@ -25,7 +25,7 @@ HOSTCFLAGS_dtc-lexer.lex.o := $(HOSTCFLAGS_DTC)
 HOSTCFLAGS_dtc-parser.tab.o := $(HOSTCFLAGS_DTC)

 # dependencies on generated files need to be listed explicitly
-$(obj)/dtc-parser.tab.o: $(obj)/dtc-parser.tab.c $(obj)/dtc-parser.tab.h
+$(obj)/dtc-parser.tab.o: $(obj)/dtc-parser.tab.h $(obj)/dtc-parser.tab.c

-$(obj)/dtc-lexer.lex.o: $(obj)/dtc-parser.tab.c $(obj)/dtc-parser.tab.h
+$(obj)/dtc-lexer.lex.o: $(obj)/dtc-parser.tab.h $(obj)/dtc-parser.tab.c

diff --git a/scripts/genksyms/Makefile b/scripts/genksyms/Makefile
index 0b883e3..9ce8220 100644
--- a/scripts/genksyms/Makefile
+++ b/scripts/genksyms/Makefile
@@ -7,8 +7,8 @@ genksyms-objs   := genksyms.o parse.tab.o lex.lex.o
 # -I needed for generated C source (shipped source)
 HOSTCFLAGS_parse.tab.o := -Wno-uninitialized -I$(src)

-$(obj)/parse.tab.o: $(obj)/parse.tab.c $(obj)/parse.tab.h
+$(obj)/parse.tab.o: $(obj)/parse.tab.h $(obj)/parse.tab.c

 $(obj)/lex.lex.o: $(obj)/keywords.hash.c
-$(obj)/lex.lex.o: $(obj)/parse.tab.c $(obj)/parse.tab.h
+$(obj)/lex.lex.o: $(obj)/parse.tab.h $(obj)/parse.tab.c

else, the .h is regenerated first. Something we do not want. However,
if we revert the change to the precedent version, that is:

diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
index ad062b7..fc7a8da 100644
--- a/scripts/Makefile.lib
+++ b/scripts/Makefile.lib
@@ -183,9 +183,11 @@ $(src)/%.lex.c_shipped: $(src)/%.l
 quiet_cmd_bison = YACC    $@
       cmd_bison = bison -o$@ -d -t -l -p $(if
$(YACC_PREFIX_${baseprereq}),$(YACC_PREFIX_${baseprereq}),yy) $<

-$(src)/%.tab.c_shipped $(src)/%.tab.h_shipped: $(src)/%.y
+$(src)/%.tab.c_shipped: $(src)/%.y
        $(call cmd,bison)

+$(src)/%.tab.h_shipped: $(src)/%.tab.c_shipped
+

which would seem more "logical", the chaining breaks:

  HOSTCC  scripts/basic/fixdep
  HOSTCC  scripts/dtc/checks.o
  HOSTCC  scripts/dtc/data.o
  LEX     scripts/dtc/dtc-lexer.lex.c_shipped
  SHIPPED scripts/dtc/dtc-lexer.lex.c
gmake[3]: *** No rule to make target `scripts/dtc/dtc-parser.tab.h',
needed by `scripts/dtc/dtc-lexer.lex.o'.  Stop.
gmake[2]: *** [scripts/dtc] Error 2
gmake[1]: *** [scripts] Error 2
gmake: *** [scripts] Error 2

So, make(1) is smart enough to link, in the general case,
`scripts/dtc/dtc-parser.tab.c' to
`scripts/dtc/dtc-parser.tab.c_shipped' then to
`scripts/dtc/dtc-parser.y'. However, it seems to be unable to link
`scripts/dtc/dtc-parser.tab.h' to
`scripts/dtc/dtc-parser.tab.h_shipped', which in turns is be linked
explicitly to `scripts/dtc/dtc-parser.tab.c_shipped' and
`scripts/dtc/dtc-parser.y'.

A possible more robust workaround for this situation would be to
generate the shipped header independently from the parser source. In
which case we would have something ala:

  # YACC
 # ---------------------------------------------------------------------------
 quiet_cmd_bison = YACC    $@
      cmd_bison = bison -o$@ -t -l -p [...]

$(src)/%.tab.c_shipped: $(src)/%.y
        $(call cmd,bison)

quiet_cmd_bison_h = YACC    $@
      cmd_bison_h = bison -o/dev/null --defines=$@ -t -l -p [...]

$(src)/%.tab.h_shipped: $(src)/%.y
       $(call cmd,bison_h)

Regards,
 - Arnaud

ps: this is all with gmake 3.82.
