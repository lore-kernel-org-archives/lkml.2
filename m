Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751430Ab0CXEpR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 00:45:17 -0400
Received: from gate.crashing.org ([63.228.1.57]:45863 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750854Ab0CXEpO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 00:45:14 -0400
Subject: Re: [PATCH 06/20] early_res: seperate common memmap func from
 e820.c to fw_memmap.cy
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, hpa@zytor.com,
       jbarnes@virtuousgeek.org, ebiederm@xmission.com,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
In-Reply-To: <1269404982.8599.148.camel@pasglop>
References: <alpine.LFD.2.00.1003222233440.3147@localhost.localdomain>
	 <4BA7EE72.7000507@kernel.org>
	 <alpine.LFD.2.00.1003222329050.3147@localhost.localdomain>
	 <4BA80019.5000900@kernel.org>
	 <alpine.LFD.2.00.1003230046050.3147@localhost.localdomain>
	 <4BA813A4.1010704@kernel.org>
	 <alpine.LFD.2.00.1003230213260.3147@localhost.localdomain>
	 <4BA8594F.8090205@kernel.org> <20100323080252.GA4848@elte.hu>
	 <4BA883C0.2070102@kernel.org>  <20100323094834.GB4576@elte.hu>
	 <1269404982.8599.148.camel@pasglop>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 24 Mar 2010 15:44:42 +1100
Message-ID: <1269405882.8599.155.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> I though one possibility would be to have LMB regions become more lists
> than arrays, so that the static storage only needs to cover as much as
> is needed during really early boot (and we could probably still move the
> BSS top point on some archs to dynamically make more ... actually we
> could be smart arses and use LMB to allocate more LMB list heads if we
> are reaching the table limit :-)

Actually what about that:

LMB entries are linked-listed. The array is just storage for those entry
"heads".

The initial static array only needs to be big enough for very very early
platform specific kernel bits and pieces, so it could even be sized by a
Kconfig option. Or it could just use a klimit moving trick to pick up a
page right after the BSS but that may need to be arch specific.

lmb_init() queues all the entries from the initial array in a freelist

lmb_alloc() and lmb_reserve() just pop entries from that freelist to
populate the two main linked lists (memory and reserved).

When something tries to dequeue up the last freelist entry, then under
the hood, LMB uses it instead to allocate a new block of LMB entries
that gets added to the freelist.

We never free blocks of LMB entries.

That way, we can fine tine the static array to be as small as we can
realistically make it be, and we have no boundary limitations on the
amount of entries in either the memory list or the reserved list.

I'm a bit too flat out right now to write code, but if there's no
objection, I might give that a go either later this week or next week,
see if I can replace bootmem on powerpc.

Cheers,
Ben.


