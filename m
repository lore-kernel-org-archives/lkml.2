Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755515Ab1C2DHe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 23:07:34 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:62443 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505Ab1C2DHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 23:07:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-url:user-agent;
        b=CqajU5UY/1GdiMzMedhmCho5OUjPDYNgTQAbWmjk4TScCD+wvf0NSYJGuV1j9xqzmy
         P3K9uTAOycLbKgi/8iYeU7SRoO3GCCsNvuOulrnsuZdWUsWad/V4ncd6Su10N1ZFFCpv
         gwOvo8esnHqg82W20KEvBpJwtwXA0eJlHpjBs=
Date: Tue, 29 Mar 2011 00:07:24 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Miller <davem@davemloft.net>
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@elte.hu,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf: Properly align symbol_conf.priv_size
Message-ID: <20110329030723.GC19510@ghostprotocols.net>
References: <20110328.175849.112593455.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110328.175849.112593455.davem@davemloft.net>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Mar 28, 2011 at 05:58:49PM -0700, David Miller escreveu:
> 
> If symbol_conf.priv_size is not a multiple of "sizeof(u64)" we'll bus
> error on sparc64 in symbol__new because the "struct symbol *" pointer
> is computed by adding symbol_conf.priv_size to the memory allocated.
> 
> We cannot isloate the fix to symbol__new and symbol__delete since the
> private area is computed by subtracting the priv_size value from a
> "struct symbol" pointer, so then the private area can still be
> potentially unaligned.

That is a clever area, aka something that needs some sanitization,
container_of use possibilities...
attempt-possible-to-become-some-sort-of-progress. :-\

Rusty willing, vowel-optmz+=blts words to trow at that...
 
> So, simply align the symbol_conf.priv_size value in symbol__init()
> 
> Signed-off-by: David S. Miller <davem@davemloft.net>
> 
> diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
> index 17df793..76c09099 100644
> --- a/tools/perf/util/symbol.c
> +++ b/tools/perf/util/symbol.c
> @@ -2403,6 +2403,8 @@ int symbol__init(void)
>  	if (symbol_conf.initialized)
>  		return 0;
>  
> +	symbol_conf.priv_size = ALIGN(symbol_conf.priv_size, sizeof(u64));
> +
>  	elf_version(EV_CURRENT);
>  	if (symbol_conf.sort_by_name)
>  		symbol_conf.priv_size += (sizeof(struct symbol_name_rb_node) -
