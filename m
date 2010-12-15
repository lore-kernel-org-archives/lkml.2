Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751822Ab0LOJxM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 04:53:12 -0500
Received: from canuck.infradead.org ([134.117.69.58]:47296 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181Ab0LOJxK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 04:53:10 -0500
Subject: Re: BUG: sleeping function called from invalid context at
 arch/x86/mm/fault.c:1081
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Borislav Petkov <bp@alien8.de>, Alex Deucher <alexdeucher@gmail.com>,
        x86@kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>
In-Reply-To: <AANLkTikj1bUvwAi5deZQ5M7kZN1gnsgTPETbuH4CWiHZ@mail.gmail.com>
References: <20101214094040.GA2790@liondog.tnic>
	 <AANLkTikj1bUvwAi5deZQ5M7kZN1gnsgTPETbuH4CWiHZ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 15 Dec 2010 10:52:24 +0100
Message-ID: <1292406744.6803.2913.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-12-14 at 12:29 -0800, Linus Torvalds wrote:
> which looks like one of the "list_for_each_entry()" uses of that
> hash_head. In fact, building lockdep.lst and matching against that
> 0x2a6 constant (it's a warn_slowpath_null thing and is the line
> number), we can pinpoint exactly which one it seems to be. Afaik, it
> seems to be this code in look_up_lock_class:
> 
>         /*
>          * We can walk the hash lockfree, because the hash only
>          * grows, and we are careful when adding entries to the end:
>          */
>         list_for_each_entry(class, hash_head, hash_entry) {
>                 if (class->key == key) {
>                         WARN_ON_ONCE(class->name != lock->name);
>                         return class;
>                 }
>         }
> 
> Maybe the RCU list use in lockdep isn't entirely safe?
> 
> Added Peter and Ingo to the cc. It does look like some lockdep race.
> 
> Or then it's some general memory corruption, of course. That just
> happened to hit the lockdep data structures. That would explain your
> subsequent radeon GP fault too. 

Typically such crashes in lockdep are indeed indicative of a scribble,
typically a use after free with slab poisoning.

But I'll try and run through that code later today to see if I can spot
anything.
