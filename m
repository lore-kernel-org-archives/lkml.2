Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753721Ab1LULt5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 06:49:57 -0500
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:52466 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753690Ab1LULtu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 06:49:50 -0500
Message-ID: <4EF1C7D3.7080301@metafoo.de>
Date: Wed, 21 Dec 2011 12:49:39 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20111110 Icedove/3.0.11
MIME-Version: 1.0
To: Julia Lawall <julia.lawall@lip6.fr>
CC: Julia Lawall <julia@diku.dk>, Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <npalix.work@gmail.com>, linux-kernel@vger.kernel.org,
        cocci@diku.dk, mmarek@suse.cz
Subject: Re: [Cocci] [PATCH 2/2] coccinelle: Add patch for replacing open-coded
 IS_ERR_OR_NULL
References: <1324301063-16117-1-git-send-email-lars@metafoo.de> <1324301063-16117-2-git-send-email-lars@metafoo.de> <alpine.DEB.2.02.1112202321220.1933@hadrien>
In-Reply-To: <alpine.DEB.2.02.1112202321220.1933@hadrien>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20/2011 11:24 PM, Julia Lawall wrote:
> For this one, I made quite a number of changes, some of which required
> fixing a bug in Coccinelle...  I will try to release the bug fix
> shortly. In general, though, I have added ... between the two tests.  I
> also got rid of the focus on ifs in the org and report rules.
> 

Ok, thanks. Was the removing of the ifs in related to the Coccinelle bug? I
always get an error if I start a match with a conditional.

> julia
> 
> virtual context
> virtual patch
> virtual org
> virtual report
> 
> // Since the logical or operator by itself is not commutative we need
> rules for
> // both cases as well as for their De Morgan equivalents.
> 
> @depends on context@
> expression x;
> @@
> * IS_ERR(x)
>   || ... ||
> * x == NULL
> 
> @depends on context@
> expression x;
> @@
> * x == NULL
>   || ... ||
> * IS_ERR(x)
> 
> @depends on context@
> expression x;
> @@
> * !IS_ERR(x)
>   && ... &&
> * x != NULL
> 
> @depends on context@
> expression x;
> @@
> * x != NULL
>   && ... &&
> * !IS_ERR(x)
> 
> @depends on patch@
> expression x;
> @@
> - IS_ERR(x)
> + IS_ERR_OR_NULL(x)
>   || ...
> - || x == NULL
> 
> @depends on patch@
> expression x;
> @@
> - x == NULL
> + IS_ERR_OR_NULL(x)
>   || ...
> - || IS_ERR(x)
> 
> @depends on patch@
> expression x;
> @@
> - !IS_ERR(x)
> + !IS_ERR_OR_NULL(x)
>   && ...
> - && x != NULL
> 
> @depends on patch@
> expression x;
> @@
> - x != NULL
> + !IS_ERR_OR_NULL(x)
>   && ...
> - && !IS_ERR(x)
> 
> @r depends on org || report@
> expression x;
> position p;
> @@
> (
>  IS_ERR@p(x) || ... || x == NULL
> |
>  x == NULL || ... || IS_ERR@p(x)
> |
>  !IS_ERR@p(x) && ... && x != NULL
> |
>  x != NULL && ... && !IS_ERR@p(x)
> )
> 
> @script:python depends on org@
> p << r.p;
> x << r.x;
> @@
> 
> msg="IS_ERR_OR_NULL can be used with %s" % (x)
> msg_safe=msg.replace("[","@(").replace("]",")")
> coccilib.org.print_todo(p[0], msg_safe)
> 
> @script:python depends on report@
> p << r.p;
> x << r.x;
> @@
> 
> msg="IS_ERR_OR_NULL can be used with %s" % (x)
> coccilib.report.print_report(p[0], msg)

