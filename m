Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469Ab1FMVCo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 17:02:44 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36278 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752665Ab1FMVCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 17:02:43 -0400
Date: Mon, 13 Jun 2011 14:02:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Eric B Munson <emunson@mgebm.net>
Cc: arnd@arndb.de, paulmck@linux.vnet.ibm.com, mingo@elte.hu,
        randy.dunlap@oracle.com, josh@joshtriplett.org,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        mgorman@suse.de, linux-mm@kvack.org, dave@linux.vnet.ibm.com
Subject: Re: [PATCH V2] Add debugging boundary check to pfn_to_page
Message-Id: <20110613140210.e5863730.akpm@linux-foundation.org>
In-Reply-To: <1307973399-7784-1-git-send-email-emunson@mgebm.net>
References: <1307973399-7784-1-git-send-email-emunson@mgebm.net>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Jun 2011 09:56:39 -0400
Eric B Munson <emunson@mgebm.net> wrote:

> Bugzilla 36192 showed a problem where pages were being accessed outside of
> a node boundary.  It would be helpful in diagnosing this kind of problem to
> have pfn_to_page complain when a page is accessed outside of the node boundary.
> This patch adds a new debug config option which adds a WARN_ON in pfn_to_page
> that will complain when pages are accessed outside of the node boundary.
> 
> Signed-of-by: Eric B Munson <emunson@mgebm.net>
> ---
> Changes from V1:
>  minimize code duplication with a macro that will do the checking when
> configured
> 
>  include/asm-generic/memory_model.h |   25 ++++++++++++++++++++-----
>  lib/Kconfig.debug                  |    9 +++++++++
>  2 files changed, 29 insertions(+), 5 deletions(-)
> 
> diff --git a/include/asm-generic/memory_model.h b/include/asm-generic/memory_model.h
> index fb2d63f..7aa83ce 100644
> --- a/include/asm-generic/memory_model.h
> +++ b/include/asm-generic/memory_model.h
> @@ -22,6 +22,16 @@
>  
>  #endif /* CONFIG_DISCONTIGMEM */
>  
> +#ifdef CONFIG_MEMORY_MODEL

This should have been CONFIG_DEBUG_MEMORY_MODEL.  Better testing, please!

> +/*
> + * The flags for a page will only be zero if this page is being accessed
> + * outside of node boundaries.

mm..  Can this comment be improved?  If some poor sucker gets this
warning then he will end up looking at this comment wondering what he
needs to do to fix the bug.  Does this comment provide him with as much
help as we possibly can?

> + */
> +#define check_page(__page) WARN_ON(__page->flags == 0)

__page should be parenthesized.  Or, better, check_page() should be
implemented in C if possible.

"check_page" is a rather vague-sounding name.  Something more specific
would be better.  Check *what*?

> +#else
> +#define check_page(__page) do{}while(0)

Please use checkpatch.  Always.

> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -777,6 +777,15 @@ config DEBUG_MEMORY_INIT
>  
>  	  If unsure, say Y
>  
> +config DEBUG_MEMORY_MODEL
> +	bool "Debug memory model" if SPARSEMEM || DISCONTIGMEM
> +	help
> +	  Enable this to check that page accesses are done within node
> +	  boundaries.  The check will warn each time a page is requested
> +	  outside node boundaries.
> +
> +	  If unsure, say N
> +

Spose, so, if you think it's useful.  Mabybe this should depend on
CONFIG_DEBUG_VM, dunno.

Please consider updating Documentation/SubmitChecklist, section 12.
