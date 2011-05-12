Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755887Ab1ELPYj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 11:24:39 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45218 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753225Ab1ELPYi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 11:24:38 -0400
Date: Thu, 12 May 2011 17:24:37 +0200
From: Michal Marek <mmarek@suse.cz>
To: Xiaochen Wang <wangxiaochen0@gmail.com>
Cc: Jean Sacren <sakiwit@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scripts/kallsyms.c: fix potential segfault
Message-ID: <20110512152437.GL13293@sepie.suse.cz>
References: <20110501034141.GA13473@chii>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110501034141.GA13473@chii>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 01, 2011 at 11:41:41AM +0800, Xiaochen Wang wrote:
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
> 
> 
> Signed-off-by: Xiaochen Wang <wangxiaochen0@gmail.com>
> ---
>  scripts/kallsyms.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)

Pushed to kbuild-2.6.git#kbuild, thanks.

Michal
