Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758130Ab2BXUzW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 15:55:22 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53736 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756350Ab2BXUzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 15:55:21 -0500
Date: Fri, 24 Feb 2012 12:55:19 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Dan Smith <danms@us.ibm.com>
Cc: David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, dave@linux.vnet.ibm.com
Subject: Re: [PATCH] Ensure that walk_page_range()'s start and end are
 page-aligned
Message-Id: <20120224125519.89120828.akpm@linux-foundation.org>
In-Reply-To: <87obsoxcn6.fsf@danplanet.com>
References: <1328902796-30389-1-git-send-email-danms@us.ibm.com>
	<alpine.DEB.2.00.1202130211400.4324@chino.kir.corp.google.com>
	<87zkcm23az.fsf@caffeine.danplanet.com>
	<alpine.DEB.2.00.1202131350500.17296@chino.kir.corp.google.com>
	<87obsoxcn6.fsf@danplanet.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Feb 2012 11:19:25 -0800
Dan Smith <danms@us.ibm.com> wrote:

>
> ...
>
>     The inner function walk_pte_range() increments "addr" by PAGE_SIZE after
>     each pte is processed, and only exits the loop if the result is equal to
>     "end". Current, if either (or both of) the starting or ending addresses
>     passed to walk_page_range() are not page-aligned, then we will never
>     satisfy that exit condition and begin calling the pte_entry handler with
>     bad data.
>     
>     To be sure that we will land in the right spot, this patch checks that
>     both "addr" and "end" are page-aligned in walk_page_range() before starting
>     the traversal.
>     
> ...
>
> --- a/mm/pagewalk.c
> +++ b/mm/pagewalk.c
> @@ -196,6 +196,11 @@ int walk_page_range(unsigned long addr, unsigned long end,
>  	if (addr >= end)
>  		return err;
>  
> +	if (WARN_ONCE((addr & ~PAGE_MASK) || (end & ~PAGE_MASK),
> +		      "address range is not page-aligned")) {
> +		return -EINVAL;
> +	}
> +
>  	if (!walk->mm)
>  		return -EINVAL;

Well...  why should we apply the patch?  Is there some buggy code which
is triggering the problem?  Do you intend to write some buggy code to
trigger the problem?  ;) 

IOW, what benefit is there to this change?

Also, as it's a developer-only thing we should arrange for the overhead
to vanish when CONFIG_DEBUG_VM=n?
