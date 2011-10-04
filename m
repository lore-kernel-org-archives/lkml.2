Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756338Ab1JDLKq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 07:10:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55621 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752070Ab1JDLKp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 07:10:45 -0400
Message-ID: <4E8AE9A0.2060706@redhat.com>
Date: Tue, 04 Oct 2011 13:10:24 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, joerg.roedel@amd.com,
        mingo@elte.hu, a.p.zijlstra@chello.nl
Subject: Re: [PATCH 8/9] KVM, VMX: Add support for guest/host-only profiling
References: <1317649795-18259-1-git-send-email-gleb@redhat.com> <1317649795-18259-9-git-send-email-gleb@redhat.com> <4E89CE09.1080808@redhat.com> <20111003153619.GA3225@redhat.com> <4E8AD1D3.9040402@redhat.com> <20111004095654.GE30105@redhat.com>
In-Reply-To: <20111004095654.GE30105@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/04/2011 11:56 AM, Gleb Natapov wrote:
> On Tue, Oct 04, 2011 at 11:28:51AM +0200, Avi Kivity wrote:
> >  On 10/03/2011 05:36 PM, Gleb Natapov wrote:
> >  >On Mon, Oct 03, 2011 at 05:00:25PM +0200, Avi Kivity wrote:
> >  >>   On 10/03/2011 03:49 PM, Gleb Natapov wrote:
> >  >>   >Support guest/host-only profiling by switch perf msrs on
> >  >>   >a guest entry if needed.
> >  >>   >
> >  >>   >@@ -6052,6 +6056,26 @@ static void vmx_cancel_injection(struct kvm_vcpu *vcpu)
> >  >>   >    	vmcs_write32(VM_ENTRY_INTR_INFO_FIELD, 0);
> >  >>   >    }
> >  >>   >
> >  >>   >+static void atomic_switch_perf_msrs(struct vcpu_vmx *vmx)
> >  >>   >+{
> >  >>   >+#ifdef CONFIG_PERF_EVENTS
> >  >>
> >  >>   No need for #ifdef (if you also define perf_guest_get_msrs() when
> >  >>   !CONFIG_PERF_EVENTS).
> >  >>
> >  >Yes, but will compiler be smart enough to remove the code of the
> >  >function completely? It will have to figure that vmx->perf_msrs_cnt is
> >  >always 0 somehow.
> >
> >  It won't, but do we care?
> >
> Dead code, that likely to be inlined, on a hot path.

I mean, CONFIG_KVM && !CONFIG_PERF_EVENTS is an unlikely combination.  
If you're using kvm, you usually want PERF_EVENTS.

> >  >VMWRITE happens only when number of autoloaded MSRs changes (which is
> >  >rare), not on each call to add_atomic_switch_msr(). I thought about
> >  >optimizing this write too by doing
> >  >vmcs_write32(VM_(ENTRY|EXIT)_MSR_LOAD_COUNT, m->nr) only once by
> >  >checking that  m->nr changed during vmentry. Can be done later.
> >
> >  For EFER and PERF_CTRL, it's done unconditionally, no?
> For those yes. We do not cache their value currently. Can be added, but
> this is independent optimization.

Sure.  I note that on most cpus only these will ever be used.

-- 
error compiling committee.c: too many arguments to function

