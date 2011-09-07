Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755922Ab1IGRmp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 13:42:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48593 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755876Ab1IGRmm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 13:42:42 -0400
Message-ID: <4E67ACB6.40107@redhat.com>
Date: Wed, 07 Sep 2011 20:41:10 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Don Zickus <dzickus@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>, Marcelo Tosatti <mtosatti@redhat.com>,
        KVM <kvm@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: Re: [PATCH 08/13] xen/pvticketlock: disable interrupts while blocking
References: <1314996468.8255.0.camel@twins> <4E614FBD.2030509@goop.org> <20110906151408.GA7459@redhat.com> <4E66615E.8070806@goop.org> <20110906182758.GR5795@redhat.com> <4E66EF86.9070200@redhat.com> <20110907134411.GV5795@redhat.com> <4E678992.5050709@redhat.com> <20110907155657.GX5795@redhat.com> <4E679AF4.50209@redhat.com> <20110907165203.GQ6838@redhat.com> <4E67A551.4000502@redhat.com> <4E67A71A.5070903@goop.org>
In-Reply-To: <4E67A71A.5070903@goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/07/2011 08:17 PM, Jeremy Fitzhardinge wrote:
> On 09/07/2011 10:09 AM, Avi Kivity wrote:
> >  On 09/07/2011 07:52 PM, Don Zickus wrote:
> >>  >
> >>  >   May I ask how?  Detecting a back-to-back NMI?
> >>
> >>  Pretty boring actually.  Currently we execute an NMI handler until
> >>  one of
> >>  them returns handled.  Then we stop.  This may cause us to miss an
> >>  NMI in
> >>  the case of multiple NMIs at once.  Now we are changing it to execute
> >>  _all_ the handlers to make sure we didn't miss one.
> >
> >  That's going to be pretty bad for kvm - those handlers become a lot
> >  more expensive since they involve reading MSRs.
>
> How often are you going to get NMIs in a kvm guest?

We'll soon have the perf-based watchdog firing every 60s worth of 
instructions or so.  But if we implement your new kick pvop using NMI 
then it can be _very_ often.

>
> >    Even worse if we start using NMIs as a wakeup for pv spinlocks as
> >  provided by this patchset.
>
> Hm, I'm interested to know what you're thinking in more detail.  Can you
> leave an NMI pending before you block in the same way you can with
> "sti;halt" with normal interrupts?

Nope.  But you can do

    if (regs->rip in critical section)
            regs->rip = after_halt;

and effectively emulate it.  The critical section is something like

     critical_section_start:
         if (woken_up)
             goto critical_section_end;
         hlt
     critical_section_end:

>
> I was thinking you might want to do something with monitor/mwait to
> implement the blocking/kick ops. (Handwave)
>

monitor/mwait are incredibly expensive to virtualize since they require 
write-protecting a page, IPIs flying everywhere and flushing tlbs, not 
to mention my lovely hugepages being broken up mercilessly.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

