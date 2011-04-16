Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753847Ab1DPOI4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Apr 2011 10:08:56 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:34212 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751356Ab1DPOIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Apr 2011 10:08:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:reply-to:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=tU1iOybSHRbbH2zwQ7nFs8U49K5rqFUEvw2nAS7HbSRkk9WVciyPa9p6ZZl8QrYvhN
         Ub52VW+R+jfS+Tpy2yJfal+qw58IrY1TkItmh82Y2AHn19KkeZTS4h/9phQ6dO8Gh9ct
         bMG1nnGmdKFnJrNgHhU3LswmutlYc7oz6PLfE=
MIME-Version: 1.0
Reply-To: wanlong.gao@gmail.com
In-Reply-To: <1302960373-5309-5-git-send-email-abogani@kernel.org>
References: <1302960373-5309-1-git-send-email-abogani@kernel.org>
	<1302960373-5309-5-git-send-email-abogani@kernel.org>
Date: Sat, 16 Apr 2011 22:08:48 +0800
X-Google-Sender-Auth: yljp_3v0j494gK3NrOSnrf5DwEc
Message-ID: <BANLkTikVMv_3vjypP=+ZCmn5BwEazRZ36w@mail.gmail.com>
Subject: Re: [PATCH 4/4] module: Use the binary search for symbols resolution
From: Wanlong Gao <wanlong.gao@gmail.com>
To: Alessio Igor Bogani <abogani@kernel.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Tim Abbott <tabbott@ksplice.com>,
        Anders Kaseorg <andersk@ksplice.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        Tim Bird <tim.bird@am.sony.com>, LKML <linux-kernel@vger.kernel.org>,
        Linux Embedded <linux-embedded@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/16/11, Alessio Igor Bogani <abogani@kernel.org> wrote:
> Takes advantage of the order and locates symbols using binary search.
>
> This work was supported by a hardware donation from the CE Linux Forum.
>
> Signed-off-by: Alessio Igor Bogani <abogani@kernel.org>
> ---
>  kernel/module.c |   23 ++++++++++++++++-------
>  1 files changed, 16 insertions(+), 7 deletions(-)
>
> diff --git a/kernel/module.c b/kernel/module.c
> index b438b25..74a57c1 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -57,6 +57,7 @@
>  #include <linux/kmemleak.h>
>  #include <linux/jump_label.h>
>  #include <linux/pfn.h>
> +#include <linux/bsearch.h>
>
>  #define CREATE_TRACE_POINTS
>  #include <trace/events/module.h>
> @@ -351,22 +352,30 @@ struct find_symbol_arg {
>  	const struct kernel_symbol *sym;
>  };
>
> +static int cmp_name(const void *va, const void *vb)
> +{
> +	const char *a;
> +	const struct kernel_symbol *b;
> +	a = va; b = vb;
> +	return strcmp(a, b->name);
> +}
> +
>  static bool find_symbol_in_symsearch(const struct symsearch *syms,
>  				     struct module *owner,
>  				     void *data)
>  {
>  	struct find_symbol_arg *fsa = data;
> +	struct kernel_symbol *sym;
>  	unsigned int symnum;
> -	int result;
>
> -	for (symnum = 0; symnum < syms->stop - syms->start; symnum++) {
> -		result = strcmp(fsa->name, syms->start[symnum].name);
> -		if (result == 0)
> -			break;
> -	}
> -	if (symnum >= syms->stop - syms->start)
> +	sym = bsearch(fsa->name, syms->start, syms->stop - syms->start,
> +		sizeof(struct kernel_symbol), cmp_name);
> +
> +	if (sym == NULL)
>  		return false;
>
> +	symnum = sym - syms->start;
> +
>  	if (!fsa->gplok) {
>  		if (syms->licence == GPL_ONLY)
>  			return false;
> --
> 1.7.4.1
>
> --
It seems like a great work .
Thanks
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
