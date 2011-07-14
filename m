Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755163Ab1GNNwl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 09:52:41 -0400
Received: from 8bytes.org ([88.198.83.132]:58831 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754662Ab1GNNwk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 09:52:40 -0400
Date: Thu, 14 Jul 2011 15:52:39 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Avi Kivity <avi@redhat.com>
Cc: Joerg Roedel <joerg.roedel@amd.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/7] KVM: SVM: Use host_vmcb_pa for vmload and vmsave
Message-ID: <20110714135239.GF24072@8bytes.org>
References: <1310571145-28930-1-git-send-email-joerg.roedel@amd.com> <1310571145-28930-3-git-send-email-joerg.roedel@amd.com> <4E1ED320.4080600@redhat.com> <20110714131036.GC24072@8bytes.org> <4E1EED03.3050202@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E1EED03.3050202@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 14, 2011 at 04:20:03PM +0300, Avi Kivity wrote:
> On 07/14/2011 04:10 PM, Joerg Roedel wrote:

>> Yes, otherwise we need to copy the vmload/vmsave switched state back and
>> forth between both VMCBs which is a waste of cycles.
>
> Just to be sure I understand this: the root cause is because VMRUN  
> doesn't actually switch this state.  So we have to copy the state.  Okay.

Right.

> What about an L2 guest executing VMLOAD or VMSAVE which isn't  
> intercepted?  Don't we have to redirect it's reads and writes to 
> host_vmcb?

Yes, that needs to target the host_vmcb then. This is buggy in the
patch-set. Thanks for pointing this out :)

>> Hmm, how about naming them l1_vmcb and l2_vmcb? The comment explaining
>> why vmload/vmsave always happens on l1_vmcb is needed anyway then.
>
> In a later patch you introduce n_vmcb.  I think it makes sense to name  
> that vmcb02?

Just for my understanding, what stands the first '0' for? The '1' and
'2' make sense, but the '0' seems to be redundant?

> Even the exising code would be good to document.  So when a reader sees  
> some bit, they can compare it to the document and see why it's that way.

I tried to put comments into the code to document the most complicated
parts. But there is certainly room for improvement. Overall, I think the
best place is to keep those comments in the code and not open another
document for it.

>> The long-term plan is certainly to merge code with nested-vmx where
>> possible and move logic into generic KVM code. The first item that comes
>> to mind here is to create a single place where a vmexit is emulated and
>> let all other place which do that today just signal that it is required.
>
> I'm not very concerned about reuse with nvmx except for architectural  
> code like interrupts.  Of course, if it turns out simple I'm all for it,  
> but if it's hard or uglifies the code, let it be.

Yes, the interrupt code is another part that probably can be made
generic.
The nested-mmu code is already generic. Nested-VMX should be able to
make use of it with only minor modifications.

	Joerg

