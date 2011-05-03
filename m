Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616Ab1ECL4F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 07:56:05 -0400
Received: from bipbip.grupopie.com ([195.23.16.24]:34034 "EHLO
	bipbip.grupopie.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752053Ab1ECL4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 07:56:04 -0400
Message-ID: <4DBFED50.8080605@grupopie.com>
Date: Tue, 03 May 2011 12:56:00 +0100
From: Paulo Marques <pmarques@grupopie.com>
Organization: Grupo PIE
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Xiaochen Wang <wangxiaochen0@gmail.com>
CC: Jean Sacren <sakiwit@gmail.com>, Michal Marek <mmarek@suse.cz>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scripts/kallsyms.c: fix potential segfault
References: <20110501034141.GA13473@chii>
In-Reply-To: <20110501034141.GA13473@chii>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Xiaochen Wang wrote:
> Description:
> This bug hardly appears during real kernel compiling,
>  because the vmlinux symbols table is huge.
> 
> But we can still catch it under strict condition , as follows.
>    $ echo "c101b97b T do_fork" | ./scripts/kallsyms --all-symbols
>    #include <asm/types.h>
>    ......
>    ......
>    .globl kallsyms_token_table
>            ALGN
>    kallsyms_token_table:
>    Segmentation fault (core dumped)
>    $
> 
> If symbols table is small, all entries in token_profit[0x10000] may
> decrease to 0 after several calls of compress_symbols() in optimize_result().
> In that case, find_best_token() always return 0 and
> best_table[i] is set to "\0\0" and best_table_len[i] is set to 2.
> 
> As a result, expand_symbol(best_table[0]="\0\0", best_table_len[0]=2, buf)
> in write_src() will run in infinite recursion until stack overflows,
> causing segfault.
> 
> This patch checks the find_best_token() return value. If all entries in
> token_profit[0x10000] become 0 according to return value, it breaks the loop
> in optimize_result().
> And expand_symbol() works well when best_table_len[i] is 0.

For this to happen on a real kernel, the list of symbols needs to have
less than 256 single characters + two letter sequences, which is highly
unlikely. From a quick test, a symbol table of a mere 30 symbols was
able to overcome those constraints.

Having said that, the fix is very small, it is not on a hot-path and it
is the right thing to do from a correctness stand point, so you have my ack.

Acked-by: Paulo Marques <pmarques@grupopie.com>

-- 
Paulo Marques - www.grupopie.com

"Conservation of angular momentum makes the world go around" - John Clark
