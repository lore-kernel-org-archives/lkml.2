Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751553Ab1LHHTG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 02:19:06 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:54643 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751356Ab1LHHTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 02:19:03 -0500
Date: Wed, 7 Dec 2011 23:18:59 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Kautuk Consul <consul.kautuk@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Joe Perches <joe@perches.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        David Vrabel <david.vrabel@citrix.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] vmalloc: purge_fragmented_blocks: Acquire spinlock
 before reading vmap_block
In-Reply-To: <CAFPAmTSJDXD1KNVBUz75yN_CeCT9f_+W9CaRNN467LSyCD+WXg@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1112072314140.28419@chino.kir.corp.google.com>
References: <1323327732-30817-1-git-send-email-consul.kautuk@gmail.com> <alpine.DEB.2.00.1112072304010.28419@chino.kir.corp.google.com> <CAFPAmTSJDXD1KNVBUz75yN_CeCT9f_+W9CaRNN467LSyCD+WXg@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="397155492-1066931067-1323328473=:28419"
Content-ID: <alpine.DEB.2.00.1112072314460.28419@chino.kir.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--397155492-1066931067-1323328473=:28419
Content-Type: TEXT/PLAIN; CHARSET=UTF-8
Content-Transfer-Encoding: 8BIT
Content-ID: <alpine.DEB.2.00.1112072314461.28419@chino.kir.corp.google.com>

On Thu, 8 Dec 2011, Kautuk Consul wrote:

> > In the original code, if the if-clause fails, the lock is only then taken
> > and the exact same test occurs again while protected.  If the test now
> > fails, the lock is immediately dropped.  A branch here is faster than a
> > contented spinlock.
> 
> But, if there is some concurrent change happening to vb->free and
> vb->dirty, dont you think
> that it will continue and then go to the next vmap_block ?
> 
> If yes, then it will not be put into the purge list.
> 

That's intentional as an optimization, we don't care if 
vb->free + vb->dirty == VMAP_BBMAP_BITS && vb->dirty != VMAP_BBMAP_BITS 
would speculatively be true after we grab vb->lock, we'll have to purge it 
next time instead.  We certainly don't want to grab vb->lock for blocks 
that aren't candidates, so this optimization is a singificant speedup.
--397155492-1066931067-1323328473=:28419--
