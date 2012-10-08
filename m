Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754539Ab2JHVLK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 17:11:10 -0400
Received: from mail-yh0-f46.google.com ([209.85.213.46]:37912 "EHLO
	mail-yh0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751286Ab2JHVLI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 17:11:08 -0400
Date: Mon, 8 Oct 2012 14:11:03 -0700
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Irina Tirdea <irina.tirdea@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
        David Ahern <dsahern@gmail.com>, Namhyung Kim <namhyung@kernel.org>,
        Pekka Enberg <penberg@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Irina Tirdea <irina.tirdea@intel.com>
Subject: Re: [PATCH v3 8/8] perf stat: implement --big-num grouping
Message-ID: <20121008211103.GK2631@ghostprotocols.net>
References: <1349678613-7045-1-git-send-email-irina.tirdea@gmail.com>
 <1349678613-7045-9-git-send-email-irina.tirdea@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349678613-7045-9-git-send-email-irina.tirdea@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Oct 08, 2012 at 09:43:33AM +0300, Irina Tirdea escreveu:
>  
> +/* Group the digits according to the grouping rules of the current locale.
> +   The interpretation of GROUPING is as in `struct lconv' from <locale.h>.  */
> +static int group_number_locale(char *number, char **gnumber)
> +{
> +	const char *thousands_sep = NULL, *grouping = NULL;
> +	int glen, tlen, dest_alloc_size, src_size, ret = 0, cnt;

Please set ret to -ENOMEM; and...

> +	char *dest_alloc_ptr, *dest_end, *src_start, *src_end;
> +

When we have else clauses, I think its better to use

#ifdef LOCALE_SUPPORT
	struct lconv *lc = localeconv();
	if (lc != NULL) {
		thousands_sep = lc->thousands_sep;
		grouping = lc->grouping;
	}
#else
	thousands_sep = ",";
	grouping = "\x3";
#endif


> +#ifndef LOCALE_SUPPORT
> +	thousands_sep = ",";
> +	grouping = "\x3";
> +#else
> +	struct lconv *lc = localeconv();
> +	if (lc != NULL) {
> +		thousands_sep = lc->thousands_sep;
> +		grouping = lc->grouping;
> +	}
> +#endif
> +
> +	*gnumber = NULL;
> +	/* No grouping */
> +	if (thousands_sep == NULL || grouping == NULL ||
> +	    *thousands_sep == '\0' || *grouping == CHAR_MAX || *grouping <= 0) {
> +		*gnumber = strdup(number);
> +		if (*gnumber == NULL)
> +			ret = -ENOMEM;
> +		goto out;

Humm, so we bail out unconditionally? :-)

	this should be:

		if (*gnumber == NULL)
			goto out;
> +	}
> +
> +	glen = *grouping++;
> +	tlen = strlen(thousands_sep);
> +
> +	src_size = strlen(number);
> +	/* Worst case scenario we have 1-character grouping */
> +	dest_alloc_size = (src_size + src_size * tlen) * sizeof(char);
> +	dest_alloc_ptr = zalloc(dest_alloc_size);
> +	if (dest_alloc_ptr == NULL) {
> +		ret = -ENOMEM;

remove the above

> +		goto out;
> +	}
> +	/* -1 for '\0' */
> +	dest_end = dest_alloc_ptr + dest_alloc_size - 1;
> +
> +	src_start = number;
> +	src_end = number + src_size;
> +
> +	while (src_end > src_start) {
> +		*--dest_end = *--src_end;
> +		if (--glen == 0 && src_end > src_start) {
> +			/* A new group */
> +			cnt = tlen;
> +			do
> +				*--dest_end = thousands_sep[--cnt];
> +			while (cnt > 0);
> +
> +			if (*grouping == CHAR_MAX || *grouping < 0) {
> +				/* No further grouping to be done.
> +				   Copy the rest of the number. */
> +				do
> +					*--dest_end = *--src_end;
> +				while (src_end > src_start);
> +				break;
> +			} else if (*grouping != '\0') {
> +				glen = *grouping++;
> +			} else {
> +				/* The previous grouping repeats ad infinitum */
> +				glen = grouping[-1];
> +			}
> +		}
> +	}
> +
> +	/* Make a copy with the exact needed size of the grouped number */
> +	*gnumber = strdup(dest_end);
> +	if (*gnumber == NULL) {
> +		ret = -ENOMEM;

	ditto
> +		goto out_free_dest;
> +	}
> +
> +	/* fall through */

Why the "fall through" comment? This is a common construct and this
comment mostly applies where one would expect a break in a switch
statement :-)

Ah, here you do:

	ret = 0;

Since all went well.

> +out_free_dest:
> +	free(dest_alloc_ptr);
> +out:
> +	return ret;
> +}
