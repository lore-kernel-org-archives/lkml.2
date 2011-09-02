Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753043Ab1IBPjY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 11:39:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33160 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752853Ab1IBPjW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 11:39:22 -0400
MIME-Version: 1.0
In-Reply-To: <cover.1314922370.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1314922370.git.jeremy.fitzhardinge@citrix.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 2 Sep 2011 08:38:22 -0700
Message-ID: <CA+55aFxpz+1bXVsg7kMeozePa=j_2-OaOuidQ4Y9Bg063=HMfg@mail.gmail.com>
Subject: Re: [PATCH 00/13] [PATCH RFC] Paravirtualized ticketlocks
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, KVM <kvm@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 1, 2011 at 5:54 PM, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>
> The inner part of ticket lock code becomes:
>        inc = xadd(&lock->tickets, inc);
>        inc.tail &= ~TICKET_SLOWPATH_FLAG;
>
>        for (;;) {
>                unsigned count = SPIN_THRESHOLD;
>
>                do {
>                        if (inc.head == inc.tail)
>                                goto out;
>                        cpu_relax();
>                        inc.head = ACCESS_ONCE(lock->tickets.head);
>                } while (--count);
>                __ticket_lock_spinning(lock, inc.tail);
>        }

Hmm. It strikes me that I don't think you should touch the
TICKET_SLOWPATH_FLAG in the fastpath at all.

Can't you just do this:

   inc = xadd(&lock->tickets, inc);
   if (likely(inc.head == inc.tail))
     goto out;

   ### SLOWPATH ###
   inc.tail &= ~TICKET_SLOWPATH_FLAG;
   for (;;) {
      .. as before ..

which might alleviate the problem with the fastpath being polluted by
all those silly slowpath things.  Hmm?

(This assumes that TICKET_SLOWPATH_FLAG is never set in inc.head, so
if it's set that equality check will fail. I didn't actually check if
that assumption was correct)

                         Linus
