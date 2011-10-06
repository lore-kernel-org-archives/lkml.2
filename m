Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964912Ab1JFOFP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 10:05:15 -0400
Received: from db3ehsobe005.messaging.microsoft.com ([213.199.154.143]:37827
	"EHLO DB3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758230Ab1JFOFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 10:05:12 -0400
X-SpamScore: -11
X-BigFish: VPS-11(zz9371K1432N98dKzz1202hzz8275bhz32i668h839h93fh)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-FB-SS: 0,13,
X-WSS-ID: 0LSNDR4-01-65F-02
X-M-MSG: 
From: Stephan Diestelhorst <stephan.diestelhorst@amd.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Jan Beulich <JBeulich@suse.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        Peter Zijlstra <peterz@infradead.org>, Nick Piggin <npiggin@kernel.dk>,
        the arch/x86 maintainers <x86@kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        KVM <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 00/10] [PATCH RFC V2] Paravirtualized ticketlocks
Date: Thu, 6 Oct 2011 16:04:13 +0200
Message-ID: <2707952.s3VYcmPHUN@chlor>
Organization: AMD OSRC
User-Agent: KMail/4.7.0  (Linux/2.6.38-11-generic; KDE/4.7.0; x86_64; ; )
In-Reply-To: <CA+55aFwm7ESNfrHhEHrAKcjcPUq8YxtuEkJd5PzAekYo2dMYNw@mail.gmail.com>
References: <cover.1315878463.git.jeremy.fitzhardinge@citrix.com> <201109282008.17722.stephan.diestelhorst@amd.com> <CA+55aFwm7ESNfrHhEHrAKcjcPUq8YxtuEkJd5PzAekYo2dMYNw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 28 September 2011, 14:49:56 Linus Torvalds wrote:
> On Wed, Sep 28, 2011 at 11:08 AM, Stephan Diestelhorst
> <stephan.diestelhorst@amd.com> wrote:
> >
> > I must have missed the part when this turned into the propose-the-
> > craziest-way-that-this-still-works.contest :)
> 
> So doing it just with the "lock addb" probably works fine, but I have
> to say that I personally shudder at the "surround the locked addb by
> reads from the word, in order to approximate an atomic read of the
> upper bits".
> 
> Because what you get is not really an "atomic read of the upper bits",
> it's a "ok, we'll get the worst case of somebody modifying the upper
> bits at the same time".
> 
> Which certainly should *work*, but from a conceptual standpoint, isn't
> it just *much* nicer to say "we actually know *exactly* what the upper
> bits were".

Well, we really do NOT want atomicity here. What we really rather want
is sequentiality: free the lock, make the update visible, and THEN
check if someone has gone sleeping on it.

Atomicity only conveniently enforces that the three do not happen in a
different order (with the store becoming visible after the checking
load).

This does not have to be atomic, since spurious wakeups are not a
problem, in particular not with the FIFO-ness of ticket locks.

For that the fence, additional atomic etc. would be IMHO much cleaner
than the crazy overflow logic.

> But I don't care all *that* deeply. I do agree that the xaddw trick is
> pretty tricky. I just happen to think that it's actually *less* tricky
> than "read the upper bits separately and depend on subtle ordering
> issues with another writer that happens at the same time on another
> CPU".

Fair enough :)

Stephan
-- 
Stephan Diestelhorst, AMD Operating System Research Center
stephan.diestelhorst@amd.com
Tel. +49 (0)351 448 356 719

Advanced Micro Devices GmbH
Einsteinring 24
85609 Aschheim
Germany

Geschaeftsfuehrer: Alberto Bozzo
Sitz: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632, WEEE-Reg-Nr: DE 12919551


