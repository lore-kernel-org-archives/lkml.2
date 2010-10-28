Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759113Ab0J1Q2P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 12:28:15 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:64935 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752407Ab0J1Q2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 12:28:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=qCS/xHgcT65no+k1CjFeeKNMo27k4dEk65+GcRx4Ood1xpw14A5WaXUQGuYVJM3t/G
         lRoXVFn78+2jAV7y1HsvrUq/ahvfX4yN8KTrFiKxsYhJMrKLy38WJgIX46dpruIJCZfX
         oZrgcYQed6aK/zRi7ELkCQ0rhU6eRgNJKbO2U=
Subject: Re: [PATCH] numa: fix slab_node(MPOL_BIND)
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mel Gorman <mel@csn.ul.ie>, Christoph Lameter <cl@linux.com>,
        Lee Schermerhorn <lee.schermerhorn@hp.com>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Brian Gerst <brgerst@gmail.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org, mingo@elte.hu
In-Reply-To: <AANLkTikmNc7qqDzoff_3i_FRbG=pmOC7TG3eeZnmvaTD@mail.gmail.com>
References: <AANLkTinnc3vBSmewf7ixuOSDYxG+5VNiGaB-vSrDNRiO@mail.gmail.com>
	 <1288158182-1753-1-git-send-email-brgerst@gmail.com>
	 <1288159670.2652.181.camel@edumazet-laptop>
	 <1288173442.15336.1490.camel@twins>
	 <1288186405.2709.117.camel@edumazet-laptop> <4CC82C2F.1020707@kernel.org>
	 <1288187870.2709.128.camel@edumazet-laptop> <4CC83067.5000009@kernel.org>
	 <1288189461.2709.144.camel@edumazet-laptop>
	 <1288190387.2709.147.camel@edumazet-laptop> <4CC83A85.3070608@kernel.org>
	 <1288192868.2709.152.camel@edumazet-laptop> <4CC846D5.50106@kernel.org>
	 <1288195668.2709.167.camel@edumazet-laptop>
	 <1288200823.5619.46.camel@edumazet-laptop>
	 <AANLkTikmNc7qqDzoff_3i_FRbG=pmOC7TG3eeZnmvaTD@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 28 Oct 2010 18:27:57 +0200
Message-ID: <1288283277.11523.18.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 28 octobre 2010 à 08:59 -0700, Linus Torvalds a écrit :
> Hmm. More people added to the discussion..
> 
> This code seems to go back all the way to commit 19770b32609b: "mm:
> filter based on a nodemask as well as a gfp_mask". Which was back in
> April 2008. and got merged into 2.6.26.
> 
> And I'd be happy to commit it (in fact, I was going to), but when
> looking for other uses of first_zones_zonelist(), I found
> local_memory_node() which does the exact same thing: ignore the return
> value, and unconditionally dereference the resulting 'zone' variable.
> 
> And so does - although less obviously - mm/vmscan.c for the
> wait_iff_confgested() thing.
> 
> So are those buggy too, since first_zones_zonelist() can apparently return NULL?
> 
> Please advise...
> 

local_memory_node() is for ia64 only, and it is a bit different :

(void)first_zones_zonelist(node_zonelist(node, GFP_KERNEL),
	gfp_zone(GFP_KERNEL),
	NULL,
	&zone);

Apparently node_zonelist(node, GFP_KERNEL) returns a pointer to
something that must have a zone suitable for GFP_KERNEL

While the code I tried to fix uses :

zonelist = &NODE_DATA(numa_node_id())->node_zonelists[0];
without any guarantee it contains a LOWMEM zone


Also check commit 7eb54824b76793dd86afb54f182ef9aa64b3a45a
for a similar fix in the past.

About do_try_to_free_pages(), I can not comment on this one, sorry.



