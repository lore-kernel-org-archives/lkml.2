Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753165Ab1LTWZQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 17:25:16 -0500
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:14630 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752216Ab1LTWZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 17:25:14 -0500
X-Greylist: delayed 351 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 Dec 2011 17:25:14 EST
X-IronPort-AV: E=Sophos;i="4.71,384,1320620400"; 
   d="scan'208";a="136241707"
Date: Tue, 20 Dec 2011 23:24:13 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: Lars-Peter Clausen <lars@metafoo.de>
cc: Julia Lawall <julia@diku.dk>, Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <npalix.work@gmail.com>, linux-kernel@vger.kernel.org,
        cocci@diku.dk, mmarek@suse.cz
Subject: Re: [Cocci] [PATCH 2/2] coccinelle: Add patch for replacing open-coded
 IS_ERR_OR_NULL
In-Reply-To: <1324301063-16117-2-git-send-email-lars@metafoo.de>
Message-ID: <alpine.DEB.2.02.1112202321220.1933@hadrien>
References: <1324301063-16117-1-git-send-email-lars@metafoo.de> <1324301063-16117-2-git-send-email-lars@metafoo.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For this one, I made quite a number of changes, some of which required 
fixing a bug in Coccinelle...  I will try to release the bug fix shortly. 
In general, though, I have added ... between the two tests.  I also got 
rid of the focus on ifs in the org and report rules.

julia

virtual context
virtual patch
virtual org
virtual report

// Since the logical or operator by itself is not commutative we need rules for
// both cases as well as for their De Morgan equivalents.

@depends on context@
expression x;
@@
* IS_ERR(x)
   || ... ||
* x == NULL

@depends on context@
expression x;
@@
* x == NULL
   || ... ||
* IS_ERR(x)

@depends on context@
expression x;
@@
* !IS_ERR(x)
   && ... &&
* x != NULL

@depends on context@
expression x;
@@
* x != NULL
   && ... &&
* !IS_ERR(x)

@depends on patch@
expression x;
@@
- IS_ERR(x)
+ IS_ERR_OR_NULL(x)
   || ...
- || x == NULL

@depends on patch@
expression x;
@@
- x == NULL
+ IS_ERR_OR_NULL(x)
   || ...
- || IS_ERR(x)

@depends on patch@
expression x;
@@
- !IS_ERR(x)
+ !IS_ERR_OR_NULL(x)
   && ...
- && x != NULL

@depends on patch@
expression x;
@@
- x != NULL
+ !IS_ERR_OR_NULL(x)
   && ...
- && !IS_ERR(x)

@r depends on org || report@
expression x;
position p;
@@
(
  IS_ERR@p(x) || ... || x == NULL
|
  x == NULL || ... || IS_ERR@p(x)
|
  !IS_ERR@p(x) && ... && x != NULL
|
  x != NULL && ... && !IS_ERR@p(x)
)

@script:python depends on org@
p << r.p;
x << r.x;
@@

msg="IS_ERR_OR_NULL can be used with %s" % (x)
msg_safe=msg.replace("[","@(").replace("]",")")
coccilib.org.print_todo(p[0], msg_safe)

@script:python depends on report@
p << r.p;
x << r.x;
@@

msg="IS_ERR_OR_NULL can be used with %s" % (x)
coccilib.report.print_report(p[0], msg)
