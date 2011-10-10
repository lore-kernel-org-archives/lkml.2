Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753592Ab1JJLCN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 07:02:13 -0400
Received: from am1ehsobe005.messaging.microsoft.com ([213.199.154.208]:50645
	"EHLO AM1EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753474Ab1JJLCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 07:02:12 -0400
X-SpamScore: -14
X-BigFish: VPS-14(zzbb2dK9371K1432N98dKzz1202hzzz32i668h839h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-FB-SS: 0,
X-WSS-ID: 0LSUJXH-02-382-02
X-M-MSG: 
From: Stephan Diestelhorst <stephan.diestelhorst@amd.com>
To: <xen-devel@lists.xensource.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Nick Piggin <npiggin@kernel.dk>, KVM <kvm@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Andi Kleen <andi@firstfloor.org>, Avi Kivity <avi@redhat.com>,
        Jan Beulich <JBeulich@suse.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [Xen-devel] [PATCH 00/10] [PATCH RFC V2] Paravirtualized ticketlocks
Date: Mon, 10 Oct 2011 13:00:50 +0200
Message-ID: <2523929.AGG4U997NO@d-allen>
Organization: AMD OSRC
User-Agent: KMail/4.7.1 (Linux/3.0.4-030004-generic; KDE/4.7.1; x86_64; ; )
In-Reply-To: <4E8DE7F1.3050108@goop.org>
References: <cover.1315878463.git.jeremy.fitzhardinge@citrix.com> <2707952.s3VYcmPHUN@chlor> <4E8DE7F1.3050108@goop.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 06 October 2011, 13:40:01 Jeremy Fitzhardinge wrote:
> On 10/06/2011 07:04 AM, Stephan Diestelhorst wrote:
> > On Wednesday 28 September 2011, 14:49:56 Linus Torvalds wrote:
> >> Which certainly should *work*, but from a conceptual standpoint, isn't
> >> it just *much* nicer to say "we actually know *exactly* what the upper
> >> bits were".
> > Well, we really do NOT want atomicity here. What we really rather want
> > is sequentiality: free the lock, make the update visible, and THEN
> > check if someone has gone sleeping on it.
> >
> > Atomicity only conveniently enforces that the three do not happen in a
> > different order (with the store becoming visible after the checking
> > load).
> >
> > This does not have to be atomic, since spurious wakeups are not a
> > problem, in particular not with the FIFO-ness of ticket locks.
> >
> > For that the fence, additional atomic etc. would be IMHO much cleaner
> > than the crazy overflow logic.
> 
> All things being equal I'd prefer lock-xadd just because its easier to
> analyze the concurrency for, crazy overflow tests or no.  But if
> add+mfence turned out to be a performance win, then that would obviously
> tip the scales.
> 
> However, it looks like locked xadd is also has better performance:  on
> my Sandybridge laptop (2 cores, 4 threads), the add+mfence is 20% slower
> than locked xadd, so that pretty much settles it unless you think
> there'd be a dramatic difference on an AMD system.

Indeed, the fences are usually slower than locked RMWs, in particular,
if you do not need to add an instruction. I originally missed that
amazing stunt the GCC pulled off with replacing the branch with carry
flag magic. It seems that two twisted minds have found each other
here :)

One of my concerns was adding a branch in here... so that is settled,
and if everybody else feels like this is easier to reason about...
go ahead :) (I'll keep my itch to myself then.)

Stephan
-- 
Stephan Diestelhorst, AMD Operating System Research Center
stephan.diestelhorst@amd.com, Tel. +49 (0)351 448 356 719

Advanced Micro Devices GmbH
Einsteinring 24
85609 Aschheim
Germany

Geschaeftsfuehrer: Alberto Bozzo;
Sitz: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632, WEEE-Reg-Nr: DE 12919551 

