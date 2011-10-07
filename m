Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760189Ab1JGQbg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 12:31:36 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:55343 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753365Ab1JGQbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 12:31:35 -0400
X-Authority-Analysis: v=1.1 cv=XWD5/VRj2HUJOhsR8cgmvPBlhMACpZXxseY1Kn/ehQI= c=1 sm=0 a=5E__mjtSOyIA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=17wjrS5wAhQaEczCPkpxpQ==:17 a=aAkNUmraqOYxgMmGptwA:9 a=awOwS7Qm2PKECuXWuOsA:7 a=PUjeQqilurYA:10 a=XNN-oNMjSfgA:10 a=17wjrS5wAhQaEczCPkpxpQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.83.30
Subject: Re: [PATCH] kbuild: let object files depend on recordmcount instead
 of its sources
From: Steven Rostedt <rostedt@goodmis.org>
To: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Michal Marek <mmarek@suse.cz>, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Date: Fri, 07 Oct 2011 12:31:33 -0400
In-Reply-To: <1317993561-16242-1-git-send-email-u.kleine-koenig@pengutronix.de>
References: <1317993561-16242-1-git-send-email-u.kleine-koenig@pengutronix.de>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.0.3- 
Content-Transfer-Encoding: 8bit
Message-ID: <1318005094.4729.40.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-10-07 at 15:19 +0200, Uwe Kleine-König wrote:
> This has the upside that distributions only have to ship the recordmcount
> binary to allow building modules instead of recordmcount and it's sources.
> 
> Make still notices that the object files need to be rebuilt when
> recordmcount's sources change.

This doesn't work. Try it on a clean build:

  HOSTCC  scripts/basic/fixdep
  GEN     /home/rostedt/work/git/tmp/Makefile
  HOSTCC  scripts/kconfig/conf.o
  SHIPPED scripts/kconfig/zconf.tab.c
  SHIPPED scripts/kconfig/lex.zconf.c
  SHIPPED scripts/kconfig/zconf.hash.c
  HOSTCC  scripts/kconfig/zconf.tab.o
  HOSTLD  scripts/kconfig/conf
scripts/kconfig/conf --silentoldconfig Kconfig
  Using /home/rostedt/work/git/linux-rt.git as source for kernel
  GEN     /home/rostedt/work/git/tmp/Makefile
  CHK     include/linux/version.h
  UPD     include/linux/version.h
  CHK     include/generated/utsrelease.h
  UPD     include/generated/utsrelease.h
  CC      kernel/bounds.s
  GEN     include/generated/bounds.h
  CC      arch/x86/kernel/asm-offsets.s
  GEN     include/generated/asm-offsets.h
  CALL    /home/rostedt/work/git/linux-rt.git/scripts/checksyscalls.sh
make[3]: *** No rule to make target `scripts/mod/empty.o', needed by `scripts/mod/elfconfig.h'.  Stop.
make[2]: *** [scripts/mod] Error 2
make[1]: *** [scripts] Error 2
make: *** [sub-make] Error 2

-- Steve

> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> ---
>  scripts/Makefile.build |    9 ++++-----
>  1 files changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/scripts/Makefile.build b/scripts/Makefile.build
> index a0fd502..bc83e94 100644
> --- a/scripts/Makefile.build
> +++ b/scripts/Makefile.build
> @@ -271,8 +271,7 @@ sub_cmd_record_mcount =					\
>  	if [ $(@) != "scripts/mod/empty.o" ]; then	\
>  		$(objtree)/scripts/recordmcount $(RECORDMCOUNT_FLAGS) "$(@)";	\
>  	fi;
> -recordmcount_source := $(srctree)/scripts/recordmcount.c \
> -		    $(srctree)/scripts/recordmcount.h
> +recordmcount_exec := $(objtree)/scripts/recordmcount
>  else
>  sub_cmd_record_mcount = set -e ; perl $(srctree)/scripts/recordmcount.pl "$(ARCH)" \
>  	"$(if $(CONFIG_CPU_BIG_ENDIAN),big,little)" \
> @@ -280,7 +279,7 @@ sub_cmd_record_mcount = set -e ; perl $(srctree)/scripts/recordmcount.pl "$(ARCH
>  	"$(OBJDUMP)" "$(OBJCOPY)" "$(CC) $(KBUILD_CFLAGS)" \
>  	"$(LD)" "$(NM)" "$(RM)" "$(MV)" \
>  	"$(if $(part-of-module),1,0)" "$(@)";
> -recordmcount_source := $(srctree)/scripts/recordmcount.pl
> +recordmcount_exec := $(srctree)/scripts/recordmcount.pl
>  endif
>  cmd_record_mcount = 						\
>  	if [ "$(findstring -pg,$(_c_flags))" = "-pg" ]; then	\
> @@ -301,13 +300,13 @@ define rule_cc_o_c
>  endef
>  
>  # Built-in and composite module parts
> -$(obj)/%.o: $(src)/%.c $(recordmcount_source) FORCE
> +$(obj)/%.o: $(src)/%.c $(recordmcount_exec) FORCE
>  	$(call cmd,force_checksrc)
>  	$(call if_changed_rule,cc_o_c)
>  
>  # Single-part modules are special since we need to mark them in $(MODVERDIR)
>  
> -$(single-used-m): $(obj)/%.o: $(src)/%.c $(recordmcount_source) FORCE
> +$(single-used-m): $(obj)/%.o: $(src)/%.c $(recordmcount_exec) FORCE
>  	$(call cmd,force_checksrc)
>  	$(call if_changed_rule,cc_o_c)
>  	@{ echo $(@:.o=.ko); echo $@; } > $(MODVERDIR)/$(@F:.o=.mod)


