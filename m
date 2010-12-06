Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753492Ab0LFAcb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 19:32:31 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:20729 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751982Ab0LFAca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 19:32:30 -0500
Date: Mon, 6 Dec 2010 01:25:34 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Alexey Dobriyan <adobriyan@gmail.com>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/45] kstrtox: converting strings to integers done
 (hopefully) right
In-Reply-To: <1291571382-2719-1-git-send-email-adobriyan@gmail.com>
Message-ID: <alpine.LNX.2.00.1012060120590.16078@swampdragon.chaosbits.net>
References: <1291571382-2719-1-git-send-email-adobriyan@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 5 Dec 2010, Alexey Dobriyan wrote:

> 1. simple_strto*() do not contain overflow checks and crufty,
>    libc way to indicate failure.
> 2. strict_strto*() also do not have overflow checks but the name and
>    comments pretend they do.
> 3. Both families have only "long long" and "long" variants,
>    but users want strtou8()
> 4. Both "simple" and "strict" prefixes are wrong:
>    Simple doesn't exactly say what's so simple, strict should not exist
>    because conversion should be strict by default.
> 
> The solution is to use "k" prefix and add convertors for more types.
> Enter
> 	kstrtoull()
> 	kstrtoll()
> 	kstrtoul()
> 	kstrtol()
> 	kstrtouint()
> 	kstrtoint()
> 	kstrtou64()
> 	kstrtos64()
> 	kstrtou32()
> 	kstrtos32()
> 	kstrtou16()
> 	kstrtos16()
> 	kstrtou8()
> 	kstrtos8()
> 
> Include runtime testsuite (somewhat incomplete) as well.
> 
> strict_strto*() become deprecated, stubbed to kstrto*() and
> eventually will be removed altogether.
> 
> Use kstrto*() in code today!
> 
> Note: sizeof and __alignof__ trick is done to save function call
>       where types aren't distinguishable.
> 
> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
> ---
<snip>
> +/* Internal, do not use. */
> +int _kstrtol(const char *s, unsigned int base, long *res)
> +{
> +	long long tmp;
> +	int rv;
> +
> +	rv = kstrtoll(s, base, &tmp);
> +	if (rv < 0)
> +		return rv;
> +	if (tmp != (long long)(long)tmp)
> +		return -EINVAL;
> +	*res = tmp;
> +	return 0;
> +}
> +EXPORT_SYMBOL(_kstrtol);

Ok, probably I'm just being dense, but the "_" prefix tells me I probably 
shouldn't use this function. The comment clearly tells me I shouldn't use 
this function.
So, why is this exported? And if it is not/should not be exported, then 
why is it not static?
(goes for other functions in this patch as well).


/Jesper Juhl

