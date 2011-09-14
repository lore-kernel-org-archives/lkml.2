Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933063Ab1INT52 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 15:57:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16470 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932905Ab1INT50 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 15:57:26 -0400
Message-ID: <4E710703.1010604@redhat.com>
Date: Wed, 14 Sep 2011 22:56:51 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Don Zickus <dzickus@redhat.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>, Marcelo Tosatti <mtosatti@redhat.com>,
        KVM <kvm@vger.kernel.org>, Xen Devel <xen-devel@lists.xensource.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: Re: [PATCH 08/13] xen/pvticketlock: disable interrupts while blocking
References: <20110907165203.GQ6838@redhat.com> <4E67A551.4000502@redhat.com> <20110913184044.GN5795@redhat.com> <20110913190320.GR7761@one.firstfloor.org> <20110913192152.GO5795@redhat.com> <4E7050F7.3000208@redhat.com> <20110914144926.GU7761@one.firstfloor.org> <4E70C1BE.7060209@redhat.com> <20110914172838.GV7761@one.firstfloor.org> <4E70FFDD.80405@redhat.com> <20110914193437.GX7761@one.firstfloor.org>
In-Reply-To: <20110914193437.GX7761@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/14/2011 10:34 PM, Andi Kleen wrote:
> On Wed, Sep 14, 2011 at 10:26:21PM +0300, Avi Kivity wrote:
> >  On 09/14/2011 08:28 PM, Andi Kleen wrote:
> >  >>   If an NMI hits in an interrupt handler, or in the "after hlt" section
> >  >>   before the write-to-last-nmi-rip, then we'll see that %rip has changed.
> >  >>   If it hits after the write-to-last-nmi-rip instruction (or in the hlt
> >  >>   itself), then we'll also see that %rip has changed, due to the effect of
> >  >>   that instruction.
> >  >
> >  >It won't handle multiple NMIs in halt. I assume that's reasonable common.
> >  >
> >
> >  Why not?
>
> They all have the same original RIPs and there is no way to distingush
> them.
>

That's how we detect multiple NMIs.

1. First NMI is posted
2. NMI handler starts
3. 2nd NMI posted, queued
4. First NMI source handled
5. IRET
6. Queued NMI hits the core
7. back-to-back NMI detected (same rip)
8. Second (and third...) NMI source handled
9. Execution continues.


-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

