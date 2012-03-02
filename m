Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965491Ab2CBJLT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 04:11:19 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:38848 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756383Ab2CBJLK convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:7:1>);
	Fri, 2 Mar 2012 04:11:10 -0500
Message-Id: <4F509CE30200007800075F84@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Fri, 02 Mar 2012 09:11:47 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Alex Shi" <alex.shi@intel.com>
Cc: <jeremy@goop.org>, "asit.k.mallick@intel.com" <asit.k.mallick@intel.com>,
        "x86@kernel.org" <x86@kernel.org>, <tglx@linutronix.de>,
        "Andi Kleen" <ak@linux.intel.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>
Subject: Re: [RFC patch] cmpxchg_double: remove local variables to get
 better performance
References: <1330677063.21053.1532.camel@debian>
 <4F5098B80200007800075F33@nat28.tlf.novell.com>
 <1330678843.21053.1553.camel@debian>
In-Reply-To: <1330678843.21053.1553.camel@debian>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 02.03.12 at 10:00, Alex Shi <alex.shi@intel.com> wrote:
> Yes, we can use cast for intermediate data. And actually, current kernel
> has live mis-used case on cmpxchg(), that I plan to point out too. 
> 
> -- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -203,12 +203,12 @@ static bool make_all_cpus_request(struct kvm *kvm, 
> unsigned int req)
> 
>  void kvm_flush_remote_tlbs(struct kvm *kvm)
>  {
> -       int dirty_count = kvm->tlbs_dirty;
> +       long dirty_count = kvm->tlbs_dirty;
> 
>         smp_mb();
>         if (make_all_cpus_request(kvm, KVM_REQ_TLB_FLUSH))
>                 ++kvm->stat.remote_tlb_flush;
> -       cmpxchg(&kvm->tlbs_dirty, dirty_count, 0);
> +       cmpxchg(&kvm->tlbs_dirty, dirty_count, 0L);

Indeed - the cmpxchg would fail if the value doesn't fit. But this is not
to say that in certain cases it isn't valid to pass an int for the second
and/or third argument. (And quite likely the issue here is theoretical
only anyway.)

In particular, requiring an L suffix here on literals should be avoided.

Jan

>  }


