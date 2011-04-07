Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756049Ab1DGMNw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 08:13:52 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:48909 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755832Ab1DGMNv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 08:13:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=s/BCeg8Ebb3mQrB2ur1gUUNQuv8+7C1pC72hkw4kN26RmDgU0/Rg8nJ/278zIZBA3r
         Tvwp1d61jv1fmKcNFBfm40J3A8WFTxnkpx65/tmY0WMNbornTI6XHQF+HNLp7Kr0lTZp
         gxYCLhze7ZrpP8InVKgF+ZqE/mXvGoIHTqb/w=
Subject: Re: Regression from 2.6.36
From: Eric Dumazet <eric.dumazet@gmail.com>
To: =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: Jiri Slaby <jslaby@suse.cz>, azurIt <azurit@pobox.sk>,
        linux-kernel@vger.kernel.org, Changli Gao <xiaosuo@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>
In-Reply-To: <1302177428.3357.25.camel@edumazet-laptop>
References: <20110315132527.130FB80018F1@mail1005.cent>
	 <20110317001519.GB18911@kroah.com> <20110407120112.E08DCA03@pobox.sk>
	 <4D9D8FAA.9080405@suse.cz>
	 <BANLkTinnTnjZvQ9S1AmudZcZBokMy8-93w@mail.gmail.com>
	 <1302177428.3357.25.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 07 Apr 2011 14:13:46 +0200
Message-ID: <1302178426.3357.34.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 07 avril 2011 à 13:57 +0200, Eric Dumazet a écrit :

> We had a similar memory problem in fib_trie in the past  : We force a
> synchronize_rcu() every XXX Mbytes allocated to make sure we dont have
> too much ram waiting to be freed in rcu queues.

This was done in commit c3059477fce2d956
(ipv4: Use synchronize_rcu() during trie_rebalance())

It was possible in fib_trie because we hold RTNL lock, so managing
a counter was free.

In fs case, we might use a percpu_counter if we really want to limit the
amount of space.

Now, I am not even sure we should care that much and could just forget
about this high order pages use.


diff --git a/fs/file.c b/fs/file.c
index 0be3447..7ba26fe 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -41,12 +41,6 @@ static DEFINE_PER_CPU(struct fdtable_defer,
fdtable_defer_list);
 
 static inline void *alloc_fdmem(unsigned int size)
 {
-	void *data;
-
-	data = kmalloc(size, GFP_KERNEL|__GFP_NOWARN);
-	if (data != NULL)
-	return data;
-
 	return vmalloc(size);
 }


