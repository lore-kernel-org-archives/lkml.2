Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754192Ab2GQNZK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 09:25:10 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:54637 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751979Ab2GQNZH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 09:25:07 -0400
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: akpm@linux-foundation.org, "Joonsoo Kim" <js1304@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        "Marek Szyprowski" <m.szyprowski@samsung.com>,
        "Minchan Kim" <minchan@kernel.org>, "Christoph Lameter" <cl@linux.com>
Subject: Re: [PATCH 3/4 v2] mm: fix return value in
 __alloc_contig_migrate_range()
References: <Yes> <1342528415-2291-1-git-send-email-js1304@gmail.com>
 <1342528415-2291-3-git-send-email-js1304@gmail.com>
Date: Tue, 17 Jul 2012 15:25:03 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: "Michal Nazarewicz" <mina86@mina86.com>
Message-ID: <op.whld71os3l0zgt@mpn-glaptop>
In-Reply-To: <1342528415-2291-3-git-send-email-js1304@gmail.com>
User-Agent: Opera Mail/12.00 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jul 2012 14:33:34 +0200, Joonsoo Kim <js1304@gmail.com> wrote:
> migrate_pages() would return positive value in some failure case,
> so 'ret > 0 ? 0 : ret' may be wrong.
> This fix it and remove one dead statement.

How about the following message:

------------------- >8 ---------------------------------------------------
migrate_pages() can return positive value while at the same time emptying
the list of pages it was called with.  Such situation means that it went
through all the pages on the list some of which failed to be migrated.

If that happens, __alloc_contig_migrate_range()'s loop may finish without
"++tries == 5" never being checked.  This in turn means that at the end
of the function, ret may have a positive value, which should be treated
as an error.

This patch changes __alloc_contig_migrate_range() so that the return
statement converts positive ret value into -EBUSY error.
------------------- >8 ---------------------------------------------------

> Signed-off-by: Joonsoo Kim <js1304@gmail.com>
> Cc: Michal Nazarewicz <mina86@mina86.com>

Acked-by: Michal Nazarewicz <mina86@mina86.com>

> Cc: Marek Szyprowski <m.szyprowski@samsung.com>
> Cc: Minchan Kim <minchan@kernel.org>
> Cc: Christoph Lameter <cl@linux.com>
> Acked-by: Christoph Lameter <cl@linux.com>

In fact, now that I look at it, I think that __alloc_contig_migrate_range()
should be changed even further.  I'll take a closer look at it and send
a patch (possibly through Marek ;) ).

> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 4403009..02d4519 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -5673,7 +5673,6 @@ static int __alloc_contig_migrate_range(unsigned long start, unsigned long end)
>  			}
>  			tries = 0;
>  		} else if (++tries == 5) {
> -			ret = ret < 0 ? ret : -EBUSY;
>  			break;
>  		}
>@@ -5683,7 +5682,7 @@ static int __alloc_contig_migrate_range(unsigned long start, unsigned long end)
>  	}
> 	putback_lru_pages(&cc.migratepages);
> -	return ret > 0 ? 0 : ret;
> +	return ret <= 0 ? ret : -EBUSY;
>  }
> /*


-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +----<email/xmpp: mpn@google.com>--------------ooO--(_)--Ooo--
