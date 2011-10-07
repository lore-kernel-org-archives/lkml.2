Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754147Ab1JGTrz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 15:47:55 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39925 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753414Ab1JGTry (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 15:47:54 -0400
Date: Fri, 7 Oct 2011 21:47:50 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>, Michal Marek <mmarek@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] kbuild: let object files depend on recordmcount instead
 of its sources
Message-ID: <20111007194750.GX6949@pengutronix.de>
References: <1317993561-16242-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1317993561-16242-1-git-send-email-u.kleine-koenig@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Oct 07, 2011 at 03:19:21PM +0200, Uwe Kleine-König wrote:
> This has the upside that distributions only have to ship the recordmcount
> binary to allow building modules instead of recordmcount and it's sources.
> 
> Make still notices that the object files need to be rebuilt when
> recordmcount's sources change.
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
I could reproduce the build failure Steve is seeing now (enabling
CONFIG_FUNCTION_TRACER helps, stupid me). I think the problem is that
with my change empty.o depends on recordmcount and in a way that I don't
understand recordmcount depends on empty.o. I wonder if it's possible to
get rid of the latter dependency?!

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
