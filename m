Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755371Ab1IGRLZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 13:11:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34788 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754356Ab1IGRLW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 13:11:22 -0400
Message-ID: <4E67A551.4000502@redhat.com>
Date: Wed, 07 Sep 2011 20:09:37 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: Don Zickus <dzickus@redhat.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
        Peter Zijlstra <peterz@infradead.org>,
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
References: <1314996468.8255.0.camel@twins> <4E614FBD.2030509@goop.org> <20110906151408.GA7459@redhat.com> <4E66615E.8070806@goop.org> <20110906182758.GR5795@redhat.com> <4E66EF86.9070200@redhat.com> <20110907134411.GV5795@redhat.com> <4E678992.5050709@redhat.com> <20110907155657.GX5795@redhat.com> <4E679AF4.50209@redhat.com> <20110907165203.GQ6838@redhat.com>
In-Reply-To: <20110907165203.GQ6838@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/07/2011 07:52 PM, Don Zickus wrote:
> >
> >  May I ask how?  Detecting a back-to-back NMI?
>
> Pretty boring actually.  Currently we execute an NMI handler until one of
> them returns handled.  Then we stop.  This may cause us to miss an NMI in
> the case of multiple NMIs at once.  Now we are changing it to execute
> _all_ the handlers to make sure we didn't miss one.

That's going to be pretty bad for kvm - those handlers become a lot more 
expensive since they involve reading MSRs.  Even worse if we start using 
NMIs as a wakeup for pv spinlocks as provided by this patchset.

> But then the downside
> here is we accidentally handle an NMI that was latched.  This would cause
> a 'Dazed on confused' message as that NMI was already handled by the
> previous NMI.
>
> We are working on an algorithm to detect this condition and flag it
> (nothing complicated).  But it may never be perfect.
>
> On the other hand, what else are we going to do with an edge-triggered
> shared interrupt line?
>

How about, during NMI, save %rip to a per-cpu variable.  Handle just one 
cause.  If, on the next NMI, we hit the same %rip, assume back-to-back 
NMI has occured and now handle all causes.

-- 
error compiling committee.c: too many arguments to function

