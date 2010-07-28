Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754865Ab0G1K2S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 06:28:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47919 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754741Ab0G1K2M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 06:28:12 -0400
Message-ID: <4C500636.1070708@redhat.com>
Date: Wed, 28 Jul 2010 13:28:06 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Thunderbird/3.1.1
MIME-Version: 1.0
To: "Roedel, Joerg" <Joerg.Roedel@amd.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] KVM: SVM: Emulate next_rip svm feature
References: <1280247261-19115-1-git-send-email-joerg.roedel@amd.com> <1280247261-19115-3-git-send-email-joerg.roedel@amd.com> <4C4F2643.8080507@redhat.com> <20100728093708.GD26098@amd.com>
In-Reply-To: <20100728093708.GD26098@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 07/28/2010 12:37 PM, Roedel, Joerg wrote:
>
>> Can it be really this simple?  Suppose we emulate a nested guest
>> instruction just before vmexit, doesn't that invalidate
>> vmcb->control.next_rip?  Can that happen?
> Good point. I looked again into it. The documentation states:
>
> 	The next sequential instruction pointer (nRIP) is saved in
> 	the guest VMCB control area at location C8h on all #VMEXITs that
> 	are due to instruction intercepts, as defined in Section 15.8 on
> 	page 378, as well as MSR and IOIO intercepts and exceptions
> 	caused by the INT3, INTO, and BOUND instructions. For all other
> 	intercepts, nRIP is reset to zero.
>
> There are a few intercepts that may need injection when running nested
> immediatly after an instruction emulation on the host side:
> 	
> 	INTR, NMI
> 	#PF, #GP, ...
>
> All these instructions do not provide a valid next_rip on #vmexit so we
> should be save here. The other way around, copying back a next_rip
> pointer when there should be none, should also not happen as far as I
> see it. The next_rip is only set for instruction intercepts which are
> either handled on the host side or reinjected directly into the L1
> hypervisor.
> When you don't see a failing case either, I think we are save with this
> simple implementation.

I agree, looks like everything's fine here.

We have a slightly different problem, if the nested guest manages to get 
an instruction to be emulated by the host (if the guest assigned it the 
cirrus framebuffer, for example, so from L1's point of view it is RAM, 
but from L0's point of view it is emulated), then we miss the 
intercept.  L2 could take over L1 this way.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

