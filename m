Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754928Ab2FVSNN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 14:13:13 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:45395 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752345Ab2FVSNL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 14:13:11 -0400
Subject: Re: Bug in net/ipv6/ip6_fib.c:fib6_dump_table()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Josh Hunt <johunt@akamai.com>
Cc: "davem@davemloft.net" <davem@davemloft.net>,
        "kaber@trash.net" <kaber@trash.net>,
        Debabrata Banerjee <dbavatar@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "yoshfuji@linux-ipv6.org" <yoshfuji@linux-ipv6.org>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "pekkas@netcore.fi" <pekkas@netcore.fi>,
        "kuznet@ms2.inr.ac.ru" <kuznet@ms2.inr.ac.ru>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <4FE476A6.1050209@akamai.com>
References: <CAATkVEzTxT6d5nzt_qwCuFWM-WcN8hdhjGxFRPXJ4=L35wKbGw@mail.gmail.com>
	 <4FE37783.9000409@akamai.com> <1340310469.4604.6702.camel@edumazet-glaptop>
	 <4FE41570.4090803@akamai.com> <1340353746.4604.9502.camel@edumazet-glaptop>
	 <4FE476A6.1050209@akamai.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 22 Jun 2012 20:13:05 +0200
Message-ID: <1340388785.4604.11442.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-06-22 at 08:44 -0500, Josh Hunt wrote:

> Ahh. That makes sense and is what Alexey said before I just didn't put
> it all together. So we are OK reverting this patch? I cannot find a path
> where the walker's pointers are updated without the tb6_lock write_lock.
> 

There was a bug somewhere, not sure we want to NULL dereference again.

Following fix should at least avoid a never ending dump

diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
index 74c21b9..6083276 100644
--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -1349,8 +1349,8 @@ static int fib6_walk_continue(struct fib6_walker_t *w)
 			if (w->leaf && fn->fn_flags & RTN_RTINFO) {
 				int err;
 
-				if (w->count < w->skip) {
-					w->count++;
+				if (w->skip) {
+					w->skip--;
 					continue;
 				}
 


