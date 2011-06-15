Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751691Ab1FOFui (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 01:50:38 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:36710 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750887Ab1FOFuh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 01:50:37 -0400
Date: Wed, 15 Jun 2011 07:50:31 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Greg Dietsche <Gregory.Dietsche@cuw.edu>
Cc: Gilles.Muller@lip6.fr, npalix.work@gmail.com, cocci@diku.dk,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] coccinelle: if (ret) return ret; return ret; semantic
 patch
In-Reply-To: <1308101355-5009-1-git-send-email-Gregory.Dietsche@cuw.edu>
Message-ID: <Pine.LNX.4.64.1106150748300.27735@ask.diku.dk>
References: <Pine.LNX.4.64.1106132033460.24125@ask.diku.dk>
 <1308101355-5009-1-git-send-email-Gregory.Dietsche@cuw.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Jun 2011, Greg Dietsche wrote:

> Semantic patch to find code that matches this pattern:
> 	if (...) return ret;
> 	return ret;
> 
> Version 2:
> 	Incorporate review comments from Julia Lawall
> 	Add matches for a number of other similar patterns.
> 
> Version 3:
> 	Incorporating more review comments from Julia.
> 
> Signed-off-by: Greg Dietsche <Gregory.Dietsche@cuw.edu>
> ---
>  scripts/coccinelle/misc/doublereturn.cocci |   31 ++++++++++++++++++++++++++++
>  1 files changed, 31 insertions(+), 0 deletions(-)
>  create mode 100644 scripts/coccinelle/misc/doublereturn.cocci
> 
> diff --git a/scripts/coccinelle/misc/doublereturn.cocci b/scripts/coccinelle/misc/doublereturn.cocci
> new file mode 100644
> index 0000000..2de8564
> --- /dev/null
> +++ b/scripts/coccinelle/misc/doublereturn.cocci
> @@ -0,0 +1,31 @@
> +// Removing unecessary code that matches this core pattern:
> +//	-if(...) return ret;
> +//	return ret;
> +//
> +// Confidence: High
> +// Copyright: (C) 2011 Greg Dietsche GPLv2.
> +// URL: http://www.gregd.org
> +// Comments:
> +// Options: -no_includes
> +
> +virtual patch
> +
> +@depends on patch@
> +expression ret;
> +identifier x, y;
> +identifier f;
> +identifier is_ordinal_table ~= "IS_ORDINAL_TABLE_\(ONE\|TWO\)";
> +@@
> +(
> +//via an isomorphism this also covers x and unlikely(x)
> +-if (likely(x)) return ret;
> +|
> +-if (\(IS_ERR\|IS_ZERO\)(x)) return ret;
> +|
> +-if (is_ordinal_table(x,y)) return ret;
> +|
> +if(<+...f(...)...+>) return ret;
> +|
> +-if (...) return ret;
> +)
> +return ret;

It doesn't matter in this case, but in general the use of regular 
expressions should be a last resort.  The problem is that when coccinelle 
is searching for relevant files, it doesn't interpret regular expressions, 
and so it would just take all files.  But in this case it doesn't matter, 
because including eg if (...) return ret; will cause it to consider all 
files anyway.

julia
