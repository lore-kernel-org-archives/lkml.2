Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756734Ab1I3GBX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 02:01:23 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:40575 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754237Ab1I3GBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 02:01:20 -0400
Date: Thu, 29 Sep 2011 23:02:26 -0700
From: Andrew Morton <akpm00@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Stephen Boyd <sboyd@codeaurora.org>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the akpm tree
Message-Id: <20110929230226.5fed4095.akpm00@gmail.com>
In-Reply-To: <20110930153255.6e3a0d6dc7758b7fb5561fc6@canb.auug.org.au>
References: <20110930153255.6e3a0d6dc7758b7fb5561fc6@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Sep 2011 15:32:55 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Andrew,
> 
> After merging the akpm tree, today's linux-next build (x86_64 allmodconfig)
> failed like this:
> 
> In file included from arch/x86/include/asm/uaccess.h:575:0,
>                  from include/net/checksum.h:25,
>                  from include/linux/skbuff.h:28,
>                  from include/linux/icmpv6.h:82,
>                  from net/compat.c:19:
> In function 'copy_from_user',
>     inlined from 'compat_sys_socketcall' at net/compat.c:793:20:
> arch/x86/include/asm/uaccess_64.h:64:26: error: call to 'copy_from_user_overflow' declared with attribute error: copy_from_user() buffer size is not provably correct
> 
> Caused by commit 15e19cbbbf2a ("x86: implement strict user copy checks
> for x86_64") when built with gcc 4.6.0.  This does not fail when built
> with 4.5.2.

This:

extern void copy_from_user_overflow(void)
#ifdef CONFIG_DEBUG_STRICT_USER_COPY_CHECKS
	__compiletime_error("copy_from_user() buffer size is not provably correct")
#else
	__compiletime_warning("copy_from_user() buffer size is not provably correct")
#endif

presumably CONFIG_DEBUG_STRICT_USER_COPY_CHECKS=y, so it's doing what
we asked it to do.

> The problem here is that the length parameter to copy_from_user() is
> obtained by indexing into an array of sizes.  Making the array const
> does not help (obviously, since the index is not known at compile time
> anyway).
> 
> Maybe I need a newer compiler.  For today I have gone back to my 4.5.2
> compiler.

That patch is a PITA.  I've been waiting for some saviour to come along
and fix all the warnings it emits before proceeding with it.  As I am
apparently saviourless I shall hide that patch from the mm->linux-next
drop, so only I get to suffer its effects.

