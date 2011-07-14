Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754807Ab1GNNMa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 09:12:30 -0400
Received: from 8bytes.org ([88.198.83.132]:51083 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754564Ab1GNNM2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 09:12:28 -0400
Date: Thu, 14 Jul 2011 15:12:28 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Avi Kivity <avi@redhat.com>
Cc: Joerg Roedel <joerg.roedel@amd.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/7] KVM: SVM: Use seperate VMCB for L2 guests
Message-ID: <20110714131228.GD24072@8bytes.org>
References: <1310571145-28930-1-git-send-email-joerg.roedel@amd.com> <1310571145-28930-5-git-send-email-joerg.roedel@amd.com> <4E1ED53F.7030903@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E1ED53F.7030903@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 14, 2011 at 02:38:39PM +0300, Avi Kivity wrote:
> On 07/13/2011 06:32 PM, Joerg Roedel wrote:
>> +static bool init_nested_vmcb(struct vcpu_svm *svm)
>> +{
>> +	struct vmcb_control_area *hc, *nc;
>> +
>> +	svm->nested.n_vmcb = (void *)get_zeroed_page(GFP_KERNEL);
>> +	if (svm->nested.n_vmcb == NULL)
>> +		return false;
>> +
>> +	nc =&svm->nested.n_vmcb->control;
>> +	hc =&svm->host_vmcb->control;
>> +
>> +	nc->iopm_base_pa		= hc->iopm_base_pa;
>> +	nc->msrpm_base_pa		= hc->msrpm_base_pa;
>> +	nc->nested_ctl			= hc->nested_ctl;
>> +	nc->pause_filter_count		= hc->pause_filter_count;
>> +	svm->nested.n_vmcb->save.g_pat	= svm->host_vmcb->save.g_pat;
>> +
>> +	return true;
>> +}
>> +
>
> Instead of initializing the non-nested vmcb and then copying it,  
> separate out the bits you're copying here into a separate function (i.e.  
> init_vmcb_host_state()) and call it for both vmcbs.
>
> I had practically the same comment for nvmx (see  
> vmx_set_constant_host_state()).

Makes sense. I'll probably remove the lazy allocation and initialize
both VMCBs at vcpu-creation time. The memory foodprint is the same as
before because the hsave area was also allocated at the beginning.

	Joerg

