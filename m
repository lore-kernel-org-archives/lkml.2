Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753821Ab1FMSi6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 14:38:58 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:59799 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750726Ab1FMSi4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 14:38:56 -0400
Date: Mon, 13 Jun 2011 20:38:50 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Greg Dietsche <Gregory.Dietsche@cuw.edu>
Cc: Gilles.Muller@lip6.fr, npalix.work@gmail.com, cocci@diku.dk,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] coccinelle: if (ret) return ret; return ret; semantic
 patch
In-Reply-To: <1307989386-17666-1-git-send-email-Gregory.Dietsche@cuw.edu>
Message-ID: <Pine.LNX.4.64.1106132033460.24125@ask.diku.dk>
References: <Pine.LNX.4.64.1106060656050.7113@ask.diku.dk>
 <1307989386-17666-1-git-send-email-Gregory.Dietsche@cuw.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Jun 2011, Greg Dietsche wrote:

> Semantic patch to find code that matches this pattern:
> 	if (...) return ret;
> 	return ret;
> 
> Version 2:
> 	Incorporate review comments from Julia Lawall
> 	Add matches for a number of other similar patterns.
> 
> Signed-off-by: Greg Dietsche <Gregory.Dietsche@cuw.edu>
> ---
>  scripts/coccinelle/misc/doublereturn.cocci |   34 ++++++++++++++++++++++++++++
>  1 files changed, 34 insertions(+), 0 deletions(-)
>  create mode 100644 scripts/coccinelle/misc/doublereturn.cocci
> 
> diff --git a/scripts/coccinelle/misc/doublereturn.cocci b/scripts/coccinelle/misc/doublereturn.cocci
> new file mode 100644
> index 0000000..b41e6f2
> --- /dev/null
> +++ b/scripts/coccinelle/misc/doublereturn.cocci
> @@ -0,0 +1,34 @@
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
> +expression ret, operand;
> +identifier is_ordinal_table ~= "IS_ORDINAL_TABLE_\(ONE\|TWO\)";
> +@@
> +(
> +//via an isomorphism this also covers ret and unlikely(ret)
> +-if (likely(ret)) return ret;
> +|
> +-if (IS_ZERO(ret)) return ret;
> +|
> +-if (is_ordinal_table(...)) return ret;
> +|
> +-if (!ret) return ret;
> +|
> +-if (ret > operand) return ret;
> +|
> +-if (ret < operand) return ret;
> +|
> +-if (ret != operand) return ret;
> +)
> +-return ret;
> ++return ret;
> -- 
> 1.7.2.5

How about:

@@
identifier f;
expression ret;
identifier x;
@@

(
- if (likely(x)) return ret;
|
- if (\(IS_ERR\|IS_ZERO\|is_ordinal_table\)(x)) return ret;
|
  if (<+...f(...)...+>) return ret;
|
- if (...) return ret;
)
return ret;

I have put the likely case separate from the other function calls to 
benefit from the isomorphism.  I have restricted the argument to these 
functions to be an identifier so that it won't have any side effects.  It 
doesn't have to be the same as ret though.  The third line keeps all other 
ifs that contain function calls.  The fourth line gets rid of everything 
else.

You could see if this finds all of the cases of your proposed rule and if 
it at least doesn't find anything else that you don't want it to find.

julia

