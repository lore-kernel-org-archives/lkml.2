Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752468Ab1GaQVo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 12:21:44 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:45507 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752208Ab1GaQVi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 12:21:38 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1107311134490.30666@linux>
References: <alpine.LNX.2.00.1107311134490.30666@linux>
Date: Sun, 31 Jul 2011 12:21:37 -0400
Message-ID: <CACqU3MX7f2oNpDf6W124tfROfKq4PFsyvxiq=VtPJfv-gqUrww@mail.gmail.com>
Subject: Re: kbuild: prevent make from deleting _shipped files
From: Arnaud Lacombe <lacombar@gmail.com>
To: Peter Foley <pefoley2@verizon.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Kbuild Mailing List <linux-kbuild@vger.kernel.org>,
        mmarek@suse.cz
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, Jul 31, 2011 at 11:37 AM, Peter Foley <pefoley2@verizon.net> wrote:
> commit 7373f4f (kbuild: add implicit rules for parser generation)
> created a implicit rule chain (%.c: %.c_shipped: %.y). This causes make to delete the _shipped files
> because it considers them intermediate files. Mark the _shipped files PRECIOUS
> to prevent make from deleting them.
>
> Signed-off-by: Peter Foley <pefoley2@verizon.net>
What make are you using, and what command triggers the issue ?

Those rules should only be visible on parser regeneration (ie.
REGENERATE_PARSERS defined). make 3.82 does not seem to trigger the
issue:

% make -v
GNU Make 3.82

% make REGENERATE_PARSERS=y defconfig
  HOSTCC  scripts/basic/fixdep
  HOSTCC  scripts/kconfig/conf.o
  SHIPPED scripts/kconfig/zconf.tab.c
  SHIPPED scripts/kconfig/zconf.lex.c
  SHIPPED scripts/kconfig/zconf.hash.c
  HOSTCC  scripts/kconfig/zconf.tab.o
  HOSTLD  scripts/kconfig/conf
*** Default configuration is based on 'x86_64_defconfig'
[...]

The shipped file are still there:

% ls scripts/kconfig/*_shipped
scripts/kconfig/zconf.hash.c_shipped
scripts/kconfig/zconf.lex.c_shipped
scripts/kconfig/zconf.tab.c_shipped

Thanks,
 - Arnaud

> ---
>
> diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
> index aeea84a..5d986d9 100644
> --- a/scripts/Makefile.lib
> +++ b/scripts/Makefile.lib
> @@ -167,6 +167,7 @@ ifdef REGENERATE_PARSERS
>  quiet_cmd_gperf = GPERF $@
>       cmd_gperf = gperf -t --output-file $@ -a -C -E -g -k 1,3,$$ -p -t $<
>
> +.PRECIOUS: $(src)/%.hash.c_shipped
>  $(src)/%.hash.c_shipped: $(src)/%.gperf
>        $(call cmd,gperf)
>
> @@ -177,6 +178,7 @@ LEX_PREFIX = $(if $(LEX_PREFIX_${baseprereq}),$(LEX_PREFIX_${baseprereq}),yy)
>  quiet_cmd_flex = LEX     $@
>       cmd_flex = flex -o$@ -L -P $(LEX_PREFIX) $<
>
> +.PRECIOUS: $(src)/%.lex.c_shipped
>  $(src)/%.lex.c_shipped: $(src)/%.l
>        $(call cmd,flex)
>
> @@ -187,12 +189,14 @@ YACC_PREFIX = $(if $(YACC_PREFIX_${baseprereq}),$(YACC_PREFIX_${baseprereq}),yy)
>  quiet_cmd_bison = YACC    $@
>       cmd_bison = bison -o$@ -t -l -p $(YACC_PREFIX) $<
>
> +.PRECIOUS: $(src)/%.tab.c_shipped
>  $(src)/%.tab.c_shipped: $(src)/%.y
>        $(call cmd,bison)
>
>  quiet_cmd_bison_h = YACC    $@
>       cmd_bison_h = bison -o/dev/null --defines=$@ -t -l -p $(YACC_PREFIX) $<
>
> +.PRECIOUS: $(src)/%.tab.h_shipped
>  $(src)/%.tab.h_shipped: $(src)/%.y
>        $(call cmd,bison_h)
>
>
