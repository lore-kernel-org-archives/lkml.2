Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754349Ab1AURN1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 12:13:27 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:63559 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752848Ab1AURN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 12:13:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-url:user-agent;
        b=B3WsGMfLG7nto4BwP4ZrKidkX4J1uEry9igIVKYX67dpx3aIM+HDkXe1dEpZcriScf
         GMmXTExNh8+WZYQZctwzHpsFDdLtw84meUlo4OPLJNi9RurMhYFLfTJ3nsoEFktDiCIA
         i2HJVXM85oU/IvhP0G8p0raGMZ67dy+ebKCLY=
Date: Fri, 21 Jan 2011 15:13:03 -0200
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: "Dr. David Alan Gilbert" <david.gilbert@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        mingo@elte.hu, dave.martin@linaro.org
Subject: Re: [PATCH] fix perf Annotation of Thumb code
Message-ID: <20110121171303.GB15066@ghostprotocols.net>
References: <20110121163922.GA31398@davesworkthinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110121163922.GA31398@davesworkthinkpad>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Jan 21, 2011 at 04:40:19PM +0000, Dr. David Alan Gilbert escreveu:
> Hi,
>   In ARM's Thumb mode the bottom bit of the symbol address is set to mark
> the function as Thumb; the instructions are in reality 2 or 4 byte on 2
> byte alignments, and when the +1 address is used in annotate it causes
> objdump to disassemble invalid instructions.  
> 
>   The patch removes that bottom bit during symbol loading.
>   This patch is against current linus's git, (2b1caf.....).
>   Many thinks to Dave Martin for comments on an initial version of the patch.

Thanks, adding it to perf/urgent.

- Arnaldo
   
>  
> Dave
> 
> (For reference this corresponds to this bug
> https://bugs.launchpad.net/linux-linaro/+bug/677547 )
> 
>         Signed-off-by: Dr. David Alan Gilbert <david.gilbert@linaro.org>  
> ---
> 
> diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
> index 15ccfba..36e76c1 100644
> --- a/tools/perf/util/symbol.c
> +++ b/tools/perf/util/symbol.c
> @@ -1161,6 +1161,13 @@ static int dso__load_sym(struct dso *self, struct map *map, const char *name,
>  
>  		section_name = elf_sec__name(&shdr, secstrs);
>  
> +		/* On ARM, symbols for thumb functions have 1 added to
> +		 * the symbol address as a flag - remove it */
> +		if ((ehdr.e_machine == EM_ARM) &&
> +			(map->type == MAP__FUNCTION) &&
> +			(sym.st_value & 1))
> +			sym.st_value-=1;
> +
>  		if (self->kernel != DSO_TYPE_USER || kmodule) {
>  			char dso_name[PATH_MAX];
>  
