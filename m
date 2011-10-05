Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755999Ab1JEG6f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 02:58:35 -0400
Received: from smtp-out.google.com ([74.125.121.67]:58453 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752969Ab1JEG6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 02:58:34 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=A8ghgVxxc+dOEVBtUyqPo/SOqOjL/KzT9yCHdJSf+FTR1mDYJgW7zsKXswsckATcw
	bfykp89BsEBSAxx6vuqsA==
Date: Tue, 4 Oct 2011 23:58:28 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Dave Hansen <dave@linux.vnet.ibm.com>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        James.Bottomley@hansenpartnership.com, hpa@zytor.com
Subject: Re: [RFCv3][PATCH 1/4] replace string_get_size() arrays
In-Reply-To: <20111001000856.DD623081@kernel>
Message-ID: <alpine.DEB.2.00.1110042352410.16359@chino.kir.corp.google.com>
References: <20111001000856.DD623081@kernel>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Sep 2011, Dave Hansen wrote:

> 
> Instead of explicitly storing the entire string for each
> possible units, just store the thing that varies: the
> first character.
> 
> We have to special-case the 'B' unit (index==0).
> 
> This shaves about 100 bytes off of my .o file.
> 

It shaved more than that from my .o file, but should we really be 
optimizing this for text size?  __unit_str() would be replacing what used 
to be a read of stack-allocated memory and make string_get_size() more 
expensive of a function and more complex code.

> Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
> ---
> 
>  linux-2.6.git-dave/lib/string_helpers.c |   30 ++++++++++++++++++++----------
>  1 file changed, 20 insertions(+), 10 deletions(-)
> 
> diff -puN lib/string_helpers.c~string_get_size-pow2 lib/string_helpers.c
> --- linux-2.6.git/lib/string_helpers.c~string_get_size-pow2	2011-09-30 16:50:31.628981352 -0700
> +++ linux-2.6.git-dave/lib/string_helpers.c	2011-09-30 17:04:02.211607364 -0700
> @@ -8,6 +8,23 @@
>  #include <linux/module.h>
>  #include <linux/string_helpers.h>
>  
> +static const char byte_units[] = "_KMGTPEZY";
> +
> +static char *__units_str(enum string_size_units unit, char *buf, int index)
> +{
> +	int place = 0;
> +
> +	/* index=0 is plain 'B' with no other unit */
> +	if (index) {
> +		buf[place++] = byte_units[index];
> +		if (unit == STRING_UNITS_2)
> +			buf[place++] = 'i';
> +	}
> +	buf[place++] = 'B';
> +	buf[place++] = '\0';
> +	return buf;
> +}
> +
>  /**
>   * string_get_size - get the size in the specified units
>   * @size:	The size to be converted
> @@ -23,26 +40,19 @@
>  int string_get_size(u64 size, const enum string_size_units units,
>  		    char *buf, int len)
>  {
> -	const char *units_10[] = { "B", "kB", "MB", "GB", "TB", "PB",
> -				   "EB", "ZB", "YB", NULL};
> -	const char *units_2[] = {"B", "KiB", "MiB", "GiB", "TiB", "PiB",
> -				 "EiB", "ZiB", "YiB", NULL };
> -	const char **units_str[] = {
> -		[STRING_UNITS_10] =  units_10,
> -		[STRING_UNITS_2] = units_2,
> -	};
>  	const unsigned int divisor[] = {
>  		[STRING_UNITS_10] = 1000,
>  		[STRING_UNITS_2] = 1024,
>  	};
>  	int i, j;
>  	u64 remainder = 0, sf_cap;
> +	char unit_buf[4];
>  	char tmp[8];
>  
>  	tmp[0] = '\0';
>  	i = 0;
>  	if (size >= divisor[units]) {
> -		while (size >= divisor[units] && units_str[units][i]) {
> +		while (size >= divisor[units] && (i < strlen(byte_units))) {
>  			remainder = do_div(size, divisor[units]);
>  			i++;
>  		}
> @@ -61,7 +71,7 @@ int string_get_size(u64 size, const enum
>  	}
>  
>  	snprintf(buf, len, "%lld%s %s", (unsigned long long)size,
> -		 tmp, units_str[units][i]);
> +		 tmp, __units_str(units, unit_buf, i));
>  
>  	return 0;
>  }
