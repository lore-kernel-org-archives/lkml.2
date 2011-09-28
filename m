Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754930Ab1I1Pih (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 11:38:37 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:35437 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754887Ab1I1Pig convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 11:38:36 -0400
MIME-Version: 1.0
In-Reply-To: <4E81FD52.50106@goop.org>
References: <cover.1315878463.git.jeremy.fitzhardinge@citrix.com>
 <3300108.XQUp9Wrktc@chlor> <4E81FD52.50106@goop.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 28 Sep 2011 08:38:14 -0700
X-Google-Sender-Auth: ZXzhlRZbYYNMcidK3UXDSMiv5MY
Message-ID: <CA+55aFx7dv4C4ZB_3CFjdJmX_wpoxecpqo1ARYr1=zTVP=CVVA@mail.gmail.com>
Subject: Re: [Xen-devel] [PATCH 00/10] [PATCH RFC V2] Paravirtualized ticketlocks
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Stephan Diestelhorst <stephan.diestelhorst@amd.com>,
        xen-devel@lists.xensource.com, "H. Peter Anvin" <hpa@zytor.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, Nick Piggin <npiggin@kernel.dk>,
        KVM <kvm@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, Avi Kivity <avi@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 27, 2011 at 9:44 AM, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>
> I guess it comes down to throwing myself on the efficiency of some kind
> of fence instruction.  I guess an lfence would be sufficient; is that
> any more efficient than a full mfence?  At least I can make it so that
> its only present when pv ticket locks are actually in use, so it won't
> affect the native case.

Please don't play with fences, just do the final "addb" as a locked instruction.

In fact, don't even use an addb, this whole thing is disgusting:

  movzwl (%rdi),%esi (esi:=0x0400)
  addb   $0x2,(%rdi) (LOCAL copy of lock is now: 0x0402)
  movzwl (%rdi),%eax (local forwarding from previous store: eax := 0x0402)

just use "lock xaddw" there too.

The fact that the PV unlock is going to be much more expensive than a
regular native unlock is just a fact of life. It comes from
fundamentally caring about the old/new value, and has nothing to do
with aliasing. You care about the other bits, and it doesn't matter
where in memory they are.

The native unlock can do a simple "addb" (or incb), but that doesn't
mean the PV unlock can. There are no ordering issues with the final
unlock in the native case, because the native unlock is like the honey
badger: it don't care. It only cares that the store make it out *some*
day, but it doesn't care about what order the upper/lower bits get
updated. You do. So you have to use a locked access.

Good catch by Stephan.

                             Linus
