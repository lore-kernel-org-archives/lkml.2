Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753591Ab1DST3Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 15:29:24 -0400
Received: from gmmr3.centrum.cz ([90.183.38.155]:45393 "EHLO gmmr3.centrum.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753462Ab1DST3W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 15:29:22 -0400
To: "Andrew Morton" <akpm@linux-foundation.org>,
        "Eric Dumazet" <eric.dumazet@gmail.com>,
        "Changli Gao" <xiaosuo@gmail.com>,
        "=?UTF-8?Q?Am=C3=A9rico=20Wang?=" <xiyou.wangcong@gmail.com>,
        "Jiri Slaby" <jslaby@suse.cz>, <linux-kernel@vger.kernel.org>,
        <linux-mm@kvack.org>, <linux-fsdevel@vger.kernel.org>,
        "Jiri Slaby" <jirislaby@gmail.com>, "Mel Gorman" <mel@csn.ul.ie>
Subject: Re: Regression from 2.6.36
Date: Tue, 19 Apr 2011 21:29:20 +0200
From: "azurIt" <azurit@pobox.sk>
References: <20110315132527.130FB80018F1@mail1005.cent>	<20110317001519.GB18911@kroah.com>	<20110407120112.E08DCA03@pobox.sk>	<4D9D8FAA.9080405@suse.cz>	<BANLkTinnTnjZvQ9S1AmudZcZBokMy8-93w@mail.gmail.com>	<1302177428.3357.25.camel@edumazet-laptop>	<1302178426.3357.34.camel@edumazet-laptop>	<BANLkTikxWy-Pw1PrcAJMHs2R7JKksyQzMQ@mail.gmail.com>	<1302190586.3357.45.camel@edumazet-laptop>	<20110412154906.70829d60.akpm@linux-foundation.org>	<BANLkTincoaxp5Soe6O-eb8LWpgra=k2NsQ@mail.gmail.com>	<20110412183132.a854bffc.akpm@linux-foundation.org>	<1302662256.2811.27.camel@edumazet-laptop>	<20110413141600.28793661.akpm@linux-foundation.org> <20110413142416.507e3ed0.akpm@linux-foundation.org>
In-Reply-To: <20110413142416.507e3ed0.akpm@linux-foundation.org>
X-Mailer: Centrum Email 5.3
X-Priority: 3
MIME-Version: 1.0
Message-Id: <20110419212920.AFE7DD8D@pobox.sk>
X-Maser: brud
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Andrew,

which kernel versions will include this patch ? Thank you.

azur



______________________________________________________________
> Od: "Andrew Morton" <akpm@linux-foundation.org>
> Komu: Eric Dumazet <eric.dumazet@gmail.com>,Changli Gao <xiaosuo@gmail.com>,Américo Wang <xiyou.wangcong@gmail.com>,Jiri Slaby <jslaby@suse.cz>, azurIt <azurit@pobox.sk>,linux-kernel@vger.kernel.org, linux-mm@kvack.org,linux-fsdevel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,Mel Gorman <mel@csn.ul.ie>
> Dátum: 13.04.2011 23:26
> Predmet: Re: Regression from 2.6.36
>
>On Wed, 13 Apr 2011 14:16:00 -0700
>Andrew Morton <akpm@linux-foundation.org> wrote:
>
>>  fs/file.c |   17 ++++++++++-------
>>  1 file changed, 10 insertions(+), 7 deletions(-)
>
>bah, stupid compiler.
>
>
>--- a/fs/file.c~vfs-avoid-large-kmallocs-for-the-fdtable
>+++ a/fs/file.c
>@@ -9,6 +9,7 @@
> #include <linux/module.h>
> #include <linux/fs.h>
> #include <linux/mm.h>
>+#include <linux/mmzone.h>
> #include <linux/time.h>
> #include <linux/sched.h>
> #include <linux/slab.h>
>@@ -39,14 +40,17 @@ int sysctl_nr_open_max = 1024 * 1024; /*
>  */
> static DEFINE_PER_CPU(struct fdtable_defer, fdtable_defer_list);
> 
>-static inline void *alloc_fdmem(unsigned int size)
>+static void *alloc_fdmem(unsigned int size)
> {
>-	void *data;
>-
>-	data = kmalloc(size, GFP_KERNEL|__GFP_NOWARN);
>-	if (data != NULL)
>-		return data;
>-
>+	/*
>+	 * Very large allocations can stress page reclaim, so fall back to
>+	 * vmalloc() if the allocation size will be considered "large" by the VM.
>+	 */
>+	if (size <= (PAGE_SIZE << PAGE_ALLOC_COSTLY_ORDER)) {
>+		void *data = kmalloc(size, GFP_KERNEL|__GFP_NOWARN);
>+		if (data != NULL)
>+			return data;
>+	}
> 	return vmalloc(size);
> }
> 
>_
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/
>
