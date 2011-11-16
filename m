Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755393Ab1KPQCm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 11:02:42 -0500
Received: from casper.infradead.org ([85.118.1.10]:40899 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752528Ab1KPQCl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 11:02:41 -0500
Subject: Re: [PATCH v3 1/2] perf, x86: Implement event scheduler helper
 functions
From: Peter Zijlstra <peterz@infradead.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>
Date: Wed, 16 Nov 2011 17:02:16 +0100
In-Reply-To: <1321293071-8636-2-git-send-email-robert.richter@amd.com>
References: <20111111142935.GI15738@erda.amd.com>
	 <1321293071-8636-1-git-send-email-robert.richter@amd.com>
	 <1321293071-8636-2-git-send-email-robert.richter@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1321459336.27735.8.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-11-14 at 18:51 +0100, Robert Richter wrote:
> @@ -22,8 +22,14 @@ extern unsigned long __sw_hweight64(__u64 w);
>  #include <asm/bitops.h>
>  
>  #define for_each_set_bit(bit, addr, size) \
> -       for ((bit) = find_first_bit((addr), (size)); \
> -            (bit) < (size); \
> +       for ((bit) = find_first_bit((addr), (size));            \
> +            (bit) < (size);                                    \
> +            (bit) = find_next_bit((addr), (size), (bit) + 1))
> +
> +/* same as for_each_set_bit() but use bit as value to start with */
> +#define for_each_set_bit_cont(bit, addr, size) \
> +       for ((bit) = find_next_bit((addr), (size), (bit));      \
> +            (bit) < (size);                                    \
>              (bit) = find_next_bit((addr), (size), (bit) + 1)) 

So my version has the +1 for the first as well, this is from the
assumption that the bit passed in has been dealt with and should not be
the first. ie. cont _after_ @bit instead of cont _at_ @bit.

This seems consistent with the list_*_continue primitives as well, which
will start with the element after (or before for _reverse) the given
position.

Thoughts?
