Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760268Ab2JYUKu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 16:10:50 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:53974 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755951Ab2JYUKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 16:10:49 -0400
MIME-Version: 1.0
In-Reply-To: <20121025124832.770994193@chello.nl>
References: <20121025121617.617683848@chello.nl> <20121025124832.770994193@chello.nl>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 25 Oct 2012 13:10:27 -0700
X-Google-Sender-Auth: iJRw739jD7iWqGVlc9lhOg2ZDGA
Message-ID: <CA+55aFxSihF0RHc8npWcMdHOo8LOx+d=aV4G6_577REn=OXsQw@mail.gmail.com>
Subject: Re: [PATCH 04/31] x86/mm: Introduce pte_accessible()
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Rik van Riel <riel@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Johannes Weiner <hannes@cmpxchg.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NAK NAK NAK.

On Thu, Oct 25, 2012 at 5:16 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>
> +#define __HAVE_ARCH_PTE_ACCESSIBLE
> +static inline int pte_accessible(pte_t a)

Stop doing this f*cking crazy ad-hoc "I have some other name
available" #defines.

Use the same name, for chissake! Don't make up new random names.

Just do

   #define pte_accessible pte_accessible

and then you can use

   #ifndef pte_accessible

to define the generic thing. Instead of having this INSANE "two
different names for the same f*cking thing" crap.

Stop it. Really.

Also, this:

> +#ifndef __HAVE_ARCH_PTE_ACCESSIBLE
> +#define pte_accessible(pte)            pte_present(pte)
> +#endif

looks unsafe and like a really bad idea.

You should probably do

  #ifndef pte_accessible
    #define pte_accessible(pte) ((void)(pte),1)
  #endif

because you have no idea if other architectures do

 (a) the same trick as x86 does for PROT_NONE (I can already tell you
from a quick grep that ia64, m32r, m68k and sh do it)
 (b) might not perhaps be caching non-present pte's anyway

So NAK on this whole patch. It's bad. It's ugly, it's wrong, and it's
actively buggy.

                Linus
