Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756696Ab1DLDt5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 23:49:57 -0400
Received: from ozlabs.org ([203.10.76.45]:34949 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756570Ab1DLDt4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 23:49:56 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Alessio Igor Bogani <abogani@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Tim Bird <tim.bird@am.sony.com>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Tim Abbott <tabbott@ksplice.com>
Subject: Re: [PATCH] module: Use the binary search for symbols resolution
In-Reply-To: <1302024146-2608-2-git-send-email-abogani@kernel.org>
References: <1302024146-2608-1-git-send-email-abogani@kernel.org> <1302024146-2608-2-git-send-email-abogani@kernel.org>
User-Agent: Notmuch/0.3.1 (http://notmuchmail.org) Emacs/23.1.1 (i686-pc-linux-gnu)
Date: Tue, 12 Apr 2011 13:18:54 +0930
Message-ID: <87aafwceop.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  5 Apr 2011 19:22:26 +0200, Alessio Igor Bogani <abogani@kernel.org> wrote:
> Let the linker sort the exported symbols and use the binary search for
> locate them.

OK, but why is this optional?

Also note that each_symbol() has an out-of-tree user in ksplice, so
changing the semantics to always search for a particular name might
break them.

Assuming they need it, we could rename it (so they can easily detect the
change) to search_symbol() and make it take a comparitor fn and a
"found" function.

So we want this as three patches, I think:
1) Change each_symbol() to search_symbol() as detailed above.
2) Change symbol tables to be sorted.
3) Change module code to do binary search.

That means we can tell exactly *what* breaks things in linux-next :)

Also:
>  	for (j = 0; j < arrsize; j++) {
> -		for (i = 0; i < arr[j].stop - arr[j].start; i++)
> -			if (fn(&arr[j], owner, i, data))
> +#ifdef CONFIG_SYMBOLS_BSEARCH
> +		num = arr[j].stop - arr[j].start;
> +		start = 0, end = num - 1, mid, result;
> +		while (start <= end) {
> +			mid = (start + end) / 2;
> +			result = strcmp(fsa->name, arr[j].start[mid].name);
> +			if (result < 0)
> +				end = mid - 1;
> +			else if (result > 0)
> +				start = mid + 1;
> +			else
> +				if (fn(&arr[j], owner, mid, data))
> +					return true;
> +		}
> +#else

This will loop forever if rn() returns false!  You want

     return fn(&arr[j], owner, mid, data)

I think.

But very neat work!
Rusty.
