Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755200Ab1GNOBi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 10:01:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38396 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755033Ab1GNOBh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 10:01:37 -0400
Message-ID: <4E1EF6BA.4050006@redhat.com>
Date: Thu, 14 Jul 2011 17:01:30 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Joerg Roedel <joro@8bytes.org>
CC: Joerg Roedel <joerg.roedel@amd.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/7] KVM: SVM: Use host_vmcb_pa for vmload and vmsave
References: <1310571145-28930-1-git-send-email-joerg.roedel@amd.com> <1310571145-28930-3-git-send-email-joerg.roedel@amd.com> <4E1ED320.4080600@redhat.com> <20110714131036.GC24072@8bytes.org> <4E1EED03.3050202@redhat.com> <20110714135239.GF24072@8bytes.org>
In-Reply-To: <20110714135239.GF24072@8bytes.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/14/2011 04:52 PM, Joerg Roedel wrote:
> >  What about an L2 guest executing VMLOAD or VMSAVE which isn't
> >  intercepted?  Don't we have to redirect it's reads and writes to
> >  host_vmcb?
>
> Yes, that needs to target the host_vmcb then. This is buggy in the
> patch-set. Thanks for pointing this out :)

For the low price of an additional test to svm.flat.

> >>  Hmm, how about naming them l1_vmcb and l2_vmcb? The comment explaining
> >>  why vmload/vmsave always happens on l1_vmcb is needed anyway then.
> >
> >  In a later patch you introduce n_vmcb.  I think it makes sense to name
> >  that vmcb02?
>
> Just for my understanding, what stands the first '0' for? The '1' and
> '2' make sense, but the '0' seems to be redundant?

The first number is the level running in host mode, the second is the 
level running guest mode.

vmcb01: host running guest
vmcb02: host running nested guest
vmcb12: guest running nested guest (i.e. the virtual vmcb in guest 
physical address space)

> >  Even the exising code would be good to document.  So when a reader sees
> >  some bit, they can compare it to the document and see why it's that way.
>
> I tried to put comments into the code to document the most complicated
> parts. But there is certainly room for improvement. Overall, I think the
> best place is to keep those comments in the code and not open another
> document for it.

Those are good for the details, but not so good for the master plan.  
Like mmu.txt.

> >>  The long-term plan is certainly to merge code with nested-vmx where
> >>  possible and move logic into generic KVM code. The first item that comes
> >>  to mind here is to create a single place where a vmexit is emulated and
> >>  let all other place which do that today just signal that it is required.
> >
> >  I'm not very concerned about reuse with nvmx except for architectural
> >  code like interrupts.  Of course, if it turns out simple I'm all for it,
> >  but if it's hard or uglifies the code, let it be.
>
> Yes, the interrupt code is another part that probably can be made
> generic.

Yes.

> The nested-mmu code is already generic. Nested-VMX should be able to
> make use of it with only minor modifications.

Yup, just need support for parsing the EPT PTE format.

-- 
error compiling committee.c: too many arguments to function

