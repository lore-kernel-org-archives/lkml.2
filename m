Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751968Ab0KYHOH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 02:14:07 -0500
Received: from mail.perches.com ([173.55.12.10]:1857 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751516Ab0KYHOG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 02:14:06 -0500
Subject: Re: [PATCH] proc: use seq_puts()/seq_putc() where possible
From: Joe Perches <joe@perches.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <20101124214058.GA21245@core2.telecom.by>
References: <20101124214058.GA21245@core2.telecom.by>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 24 Nov 2010 23:14:03 -0800
Message-ID: <1290669243.11971.256.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-24 at 23:40 +0200, Alexey Dobriyan wrote:
> For string without format specifiers, use seq_puts().
> For seq_printf("\n"), use seq_putc('\n').
> 
>    text	   data	    bss	    dec	    hex	filename
>   61866	    488	    112	  62466	   f402	fs/proc/proc.o
>   61729	    488	    112	  62329	   f379	fs/proc/proc.o
>   ----------------------------------------------------
>   			   -139

If this is really useful, perhaps it should be done treewide.

Here's a script that does that:

grep -rPl --include=*.[ch] "\bseq_printf\b" * | 
xargs perl -p -i \
	-e 's/\bseq_printf\s*\(\s*([^,]+),\s*\"([^\%\"]+)\"\s*\)/seq_puts\($1, \"$2\"\)/g'
grep -rPl --include=*.[ch] "\bseq_puts\b" * | 
xargs perl -p -i \
	-e "s/\bseq_puts\s*\(\s*([^,]+),\s*\"\\\n\"\s*\)/seq_putc\(\$1, '\\\n'\)/g"
grep -rPl --include=*.[ch] "\bseq_puts\b" * | 
xargs perl -p -i \
	-e "s/\bseq_puts\s*\(\s*([^,]+),\s*\"(.)\"\s*\)/seq_putc\(\$1, '\$2'\)/g"

$ git diff --shortstat
 256 files changed, 1119 insertions(+), 1119 deletions(-)


