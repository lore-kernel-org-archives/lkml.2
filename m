Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751507Ab2D1FK0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2012 01:10:26 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:47532 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750847Ab2D1FKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2012 01:10:24 -0400
Message-ID: <4F9B7BBA.7030504@openvz.org>
Date: Sat, 28 Apr 2012 09:10:18 +0400
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120217 Firefox/10.0.2 Iceape/2.7.2
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 4/4] bug: mark disabled BUG() as unreachable() code
References: <20120425112623.26927.43229.stgit@zurg> <20120425112636.26927.27124.stgit@zurg>
In-Reply-To: <20120425112636.26927.27124.stgit@zurg>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Konstantin Khlebnikov wrote:
> This patch suppress some compiler warnings (if CONFIG_BUG=n)
> "warning: control reaches end of non-void function"

With this patch gcc throw out loop at the end of do_exit():

	schedule();
	BUG();
	/* Avoid "noreturn function does return".  */
	for (;;)
		cpu_relax();	/* For when BUG is null */

Is this ok? Probably not, and we need here some BUG_NORETURN() which
really never returns even if CONFIG_BUG=n.

>
> Plus now gcc can throw out some dead code.
> bloat-o-meter: add/remove: 1/1 grow/shrink: 68/173 up/down: 1569/-5607 (-4038)
>
> Signed-off-by: Konstantin Khlebnikov<khlebnikov@openvz.org>
> ---
>   include/asm-generic/bug.h |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/include/asm-generic/bug.h b/include/asm-generic/bug.h
> index aadb6fc..0b08199 100644
> --- a/include/asm-generic/bug.h
> +++ b/include/asm-generic/bug.h
> @@ -108,7 +108,7 @@ extern void warn_slowpath_null(const char *file, const int line);
>
>   #else /* !CONFIG_BUG */
>   #ifndef HAVE_ARCH_BUG
> -#define BUG() do {} while(0)
> +#define BUG() unreachable()
>   #endif
>
>   #ifndef HAVE_ARCH_BUG_ON
>

