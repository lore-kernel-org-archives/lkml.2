Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754338Ab0CXJAt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 05:00:49 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56365 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753327Ab0CXJAq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 05:00:46 -0400
Date: Wed, 24 Mar 2010 10:00:31 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, hpa@zytor.com,
       jbarnes@virtuousgeek.org, ebiederm@xmission.com,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH 06/20] early_res: seperate common memmap func from e820.c
 to fw_memmap.cy
Message-ID: <20100324090031.GA23804@elte.hu>
References: <4BA80019.5000900@kernel.org>
 <alpine.LFD.2.00.1003230046050.3147@localhost.localdomain>
 <4BA813A4.1010704@kernel.org>
 <alpine.LFD.2.00.1003230213260.3147@localhost.localdomain>
 <4BA8594F.8090205@kernel.org>
 <20100323080252.GA4848@elte.hu>
 <4BA883C0.2070102@kernel.org>
 <20100323094834.GB4576@elte.hu>
 <1269404982.8599.148.camel@pasglop>
 <1269405882.8599.155.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269405882.8599.155.camel@pasglop>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:

> 
> > I though one possibility would be to have LMB regions become more lists
> > than arrays, so that the static storage only needs to cover as much as
> > is needed during really early boot (and we could probably still move the
> > BSS top point on some archs to dynamically make more ... actually we
> > could be smart arses and use LMB to allocate more LMB list heads if we
> > are reaching the table limit :-)
> 
> Actually what about that:
> 
> LMB entries are linked-listed. The array is just storage for those entry
> "heads".
> 
> The initial static array only needs to be big enough for very very early
> platform specific kernel bits and pieces, so it could even be sized by a
> Kconfig option. Or it could just use a klimit moving trick to pick up a
> page right after the BSS but that may need to be arch specific.
> 
> lmb_init() queues all the entries from the initial array in a freelist
> 
> lmb_alloc() and lmb_reserve() just pop entries from that freelist to
> populate the two main linked lists (memory and reserved).
> 
> When something tries to dequeue up the last freelist entry, then under
> the hood, LMB uses it instead to allocate a new block of LMB entries
> that gets added to the freelist.
> 
> We never free blocks of LMB entries.
> 
> That way, we can fine tine the static array to be as small as we can
> realistically make it be, and we have no boundary limitations on the
> amount of entries in either the memory list or the reserved list.
> 
> I'm a bit too flat out right now to write code, but if there's no objection, 
> I might give that a go either later this week or next week, see if I can 
> replace bootmem on powerpc.

That would be fantastic! PowerPC and x86 both doing it would give it enough of 
a critical mass to make the removal of bootmem realistic.

Thanks,

	Ingo
