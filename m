Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755732Ab2JEMvw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 08:51:52 -0400
Received: from ns.iliad.fr ([212.27.33.1]:50583 "EHLO ns.iliad.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754657Ab2JEMvv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 08:51:51 -0400
Message-ID: <1349441509.28867.17.camel@sakura.staff.proxad.net>
Subject: Re: kernel 3.2.27 on arm: WARNING: at mm/page_alloc.c:2109
 __alloc_pages_nodemask+0x1d4/0x68c()
From: Maxime Bizon <mbizon@freebox.fr>
Reply-To: mbizon@freebox.fr
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: David Madore <david+ml@madore.org>, Francois Romieu <romieu@fr.zoreil.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hugh Dickins <hughd@google.com>
Date: Fri, 05 Oct 2012 14:51:49 +0200
In-Reply-To: <1349439732.21172.52.camel@edumazet-glaptop>
References: <20120829002548.GA7063@aldebaran.gro-tsen.net>
	 <alpine.LSU.2.00.1208311900330.1936@eggly.anvils>
	 <1349366521.2532.12.camel@sakura.staff.proxad.net>
	 <1349368171.16011.79.camel@edumazet-glaptop>
	 <1349422868.21172.38.camel@edumazet-glaptop>
	 <1349434194.16710.44.camel@sakura.staff.proxad.net>
	 <1349439732.21172.52.camel@edumazet-glaptop>
Organization: Freebox
Content-Type: text/plain; charset="ANSI_X3.4-1968"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2012-10-05 at 14:22 +0200, Eric Dumazet wrote:

> Yes, but the idea of the patch was to _avoid_ next pskb_expand_head()
> calls...

yes but we cannot be sure of that, the caller may not have a good idea
of the headroom needed for the whole lifetime of the skb

it's better to think we will reduce number of calls, not avoid them

that's why I think doubling the size each time is dangerous, since we
silently request bigger and bigger allocations if an skb takes an
unoptimized path

> Hmm, 
> 
> this changes nothing assuming current_end == skb_end_offset(skb)
> and current_head = skb->head

My idea was to leave skb->end at its last position even if we grow
skb->head.

Since we have a way to know the current allocation size of skb->head,
further pskb_expand_head() calls to request tailroom would just push
skb->tail & skb->end together if that fits in current ksize().

I've not looked at recent changes in mainline, since you changed how
skb->head is managed, that may be totally impossible.

Your proposed changed API change to expand_head will fill this anyway.

> New convention would be : pass number of needed bytes after current
> tail, not after current end.

Fully agree on this

-- 
Maxime


