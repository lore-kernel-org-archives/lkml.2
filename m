Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756775Ab1JATdy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 15:33:54 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:58660 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752736Ab1JATds (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 15:33:48 -0400
Message-ID: <1317497626.22613.1.camel@Joe-Laptop>
Subject: Re: [RFCv3][PATCH 1/4] replace string_get_size() arrays
From: Joe Perches <joe@perches.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, rientjes@google.com,
        James.Bottomley@HansenPartnership.com, hpa@zytor.com
Date: Sat, 01 Oct 2011 12:33:46 -0700
In-Reply-To: <20111001000856.DD623081@kernel>
References: <20111001000856.DD623081@kernel>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-09-30 at 17:08 -0700, Dave Hansen wrote:
> Instead of explicitly storing the entire string for each
> possible units, just store the thing that varies: the
> first character.

trivia

> diff -puN lib/string_helpers.c~string_get_size-pow2 lib/string_helpers.c
> --- linux-2.6.git/lib/string_helpers.c~string_get_size-pow2	2011-09-30 16:50:31.628981352 -0700
> +++ linux-2.6.git-dave/lib/string_helpers.c	2011-09-30 17:04:02.211607364 -0700
> @@ -8,6 +8,23 @@
>  #include <linux/module.h>
>  #include <linux/string_helpers.h>
>  
> +static const char byte_units[] = "_KMGTPEZY";

u64 could be up to ~1.8**19 decimal
zetta and yotta are not possible or necessary.
u128 maybe someday, but then other changes
would be necessary too.

> +static char *__units_str(enum string_size_units unit, char *buf, int index)
> +{
> +	int place = 0;
> +
> +	/* index=0 is plain 'B' with no other unit */
> +	if (index) {
> +		buf[place++] = byte_units[index];

index is unbounded (doesn't matter currently, it will for u128)

> @@ -23,26 +40,19 @@
>  int string_get_size(u64 size, const enum string_size_units units,
>  		    char *buf, int len)
[]
>  	const unsigned int divisor[] = {
>  		[STRING_UNITS_10] = 1000,
>  		[STRING_UNITS_2] = 1024,
>  	};

static const or it might be better to use
	unsigned int divisor = (string_size_units == STRING_UNITS_2) ? 1024 : 1000;
as that would make the code clearer in a
couple of uses of divisor[] later.

> @@ -61,7 +71,7 @@ int string_get_size(u64 size, const enum
>  	}
>  
>  	snprintf(buf, len, "%lld%s %s", (unsigned long long)size,

%llu


