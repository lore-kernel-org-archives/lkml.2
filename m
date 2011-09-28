Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755132Ab1I1SuU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 14:50:20 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:34795 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753227Ab1I1SuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 14:50:18 -0400
MIME-Version: 1.0
In-Reply-To: <201109282008.17722.stephan.diestelhorst@amd.com>
References: <cover.1315878463.git.jeremy.fitzhardinge@citrix.com>
 <4E835851.7070502@zytor.com> <4E835E50.2020307@goop.org> <201109282008.17722.stephan.diestelhorst@amd.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 28 Sep 2011 11:49:56 -0700
X-Google-Sender-Auth: bHq8L02SAruJtvz77tWX1LPjbZg
Message-ID: <CA+55aFwm7ESNfrHhEHrAKcjcPUq8YxtuEkJd5PzAekYo2dMYNw@mail.gmail.com>
Subject: Re: [Xen-devel] [PATCH 00/10] [PATCH RFC V2] Paravirtualized ticketlocks
To: Stephan Diestelhorst <stephan.diestelhorst@amd.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Jan Beulich <JBeulich@suse.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        Peter Zijlstra <peterz@infradead.org>, Nick Piggin <npiggin@kernel.dk>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        KVM <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 28, 2011 at 11:08 AM, Stephan Diestelhorst
<stephan.diestelhorst@amd.com> wrote:
>
> I must have missed the part when this turned into the propose-the-
> craziest-way-that-this-still-works.contest :)

So doing it just with the "lock addb" probably works fine, but I have
to say that I personally shudder at the "surround the locked addb by
reads from the word, in order to approximate an atomic read of the
upper bits".

Because what you get is not really an "atomic read of the upper bits",
it's a "ok, we'll get the worst case of somebody modifying the upper
bits at the same time".

Which certainly should *work*, but from a conceptual standpoint, isn't
it just *much* nicer to say "we actually know *exactly* what the upper
bits were".

But I don't care all *that* deeply. I do agree that the xaddw trick is
pretty tricky. I just happen to think that it's actually *less* tricky
than "read the upper bits separately and depend on subtle ordering
issues with another writer that happens at the same time on another
CPU".

So I can live with either form - as long as it works. I think it might
be easier to argue that the xaddw is guaranteed to work, because all
values at all points are unarguably atomic (yeah, we read the lower
bits nonatomically, but as the owner of the lock we know that nobody
else can write them).

                                 Linus
