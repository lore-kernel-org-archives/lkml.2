Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754870Ab1GNNUN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 09:20:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40747 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754585Ab1GNNUL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 09:20:11 -0400
Message-ID: <4E1EED03.3050202@redhat.com>
Date: Thu, 14 Jul 2011 16:20:03 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Joerg Roedel <joro@8bytes.org>
CC: Joerg Roedel <joerg.roedel@amd.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/7] KVM: SVM: Use host_vmcb_pa for vmload and vmsave
References: <1310571145-28930-1-git-send-email-joerg.roedel@amd.com> <1310571145-28930-3-git-send-email-joerg.roedel@amd.com> <4E1ED320.4080600@redhat.com> <20110714131036.GC24072@8bytes.org>
In-Reply-To: <20110714131036.GC24072@8bytes.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/14/2011 04:10 PM, Joerg Roedel wrote:
> On Thu, Jul 14, 2011 at 02:29:36PM +0300, Avi Kivity wrote:
> >  On 07/13/2011 06:32 PM, Joerg Roedel wrote:
> >>  This saves copying over the vmload/vmsave switched part from
> >>  the host to the guest vmcb later.
> >>
> >>  Signed-off-by: Joerg Roedel<joerg.roedel@amd.com>
> >>  ---
> >>    arch/x86/kvm/svm.c |    7 ++++++-
> >>    1 files changed, 6 insertions(+), 1 deletions(-)
> >>
> >>  diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> >>  index 3d5990f..dc703ac 100644
> >>  --- a/arch/x86/kvm/svm.c
> >>  +++ b/arch/x86/kvm/svm.c
> >>  @@ -3704,9 +3704,13 @@ static void svm_vcpu_run(struct kvm_vcpu *vcpu)
> >>
> >>    		/* Enter guest mode */
> >>    		"push %%"R"ax \n\t"
> >>  -		"mov %c[vmcb](%[svm]), %%"R"ax \n\t"
> >>  +		"mov %c[host_vmcb](%[svm]), %%"R"ax \n\t"
> >>    		__ex(SVM_VMLOAD) "\n\t"
> >>  +		"mov (%%"R"sp), %%"R"ax\n\t"
> >>  +		"mov %c[vmcb](%[svm]), %%"R"ax \n\t"
> >>    		__ex(SVM_VMRUN) "\n\t"
> >>  +		"mov (%%"R"sp), %%"R"ax\n\t"
> >>  +		"mov %c[host_vmcb](%[svm]), %%"R"ax \n\t"
> >>    		__ex(SVM_VMSAVE) "\n\t"
> >>    		"pop %%"R"ax \n\t"
> >>
> >
> >  Okay, so the plan is to split L2 state between ->vmcb and ->host_vmcb?
>
> Yes, otherwise we need to copy the vmload/vmsave switched state back and
> forth between both VMCBs which is a waste of cycles.

Just to be sure I understand this: the root cause is because VMRUN 
doesn't actually switch this state.  So we have to copy the state.  Okay.

What about an L2 guest executing VMLOAD or VMSAVE which isn't 
intercepted?  Don't we have to redirect it's reads and writes to host_vmcb?

> >  In that case my suggestion for patch 1 doesn't apply.  But the name
> >  still is confusing.  If we don't find a better one, I want a fat comment
> >  explaining how state is split.
>
> Hmm, how about naming them l1_vmcb and l2_vmcb? The comment explaining
> why vmload/vmsave always happens on l1_vmcb is needed anyway then.

In a later patch you introduce n_vmcb.  I think it makes sense to name 
that vmcb02?

> >  (would be good to have documentation for the overall strategy of nsvm,
> >  like we have for nvmx and nmmu).
>
> There is not much to document about future plans for nested-svm. At the
> moment I try to add emulation code for new SVM features when there is
> some time left. Live migration support is also on the list.
>

Even the exising code would be good to document.  So when a reader sees 
some bit, they can compare it to the document and see why it's that way.

> The long-term plan is certainly to merge code with nested-vmx where
> possible and move logic into generic KVM code. The first item that comes
> to mind here is to create a single place where a vmexit is emulated and
> let all other place which do that today just signal that it is required.

I'm not very concerned about reuse with nvmx except for architectural 
code like interrupts.  Of course, if it turns out simple I'm all for it, 
but if it's hard or uglifies the code, let it be.

-- 
error compiling committee.c: too many arguments to function

