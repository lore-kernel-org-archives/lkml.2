Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761456Ab2EQJ23 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 05:28:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12424 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756021Ab2EQJ22 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 05:28:28 -0400
Message-ID: <4FB4C4B6.6000203@redhat.com>
Date: Thu, 17 May 2012 12:28:22 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: x86@kernel.org, kvm@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, gleb@redhat.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv4 3/5] kvm: host side for eoi optimization
References: <cover.1337168687.git.mst@redhat.com> <42ba7beaa25855997e02fea91a11c9224c51720e.1337168687.git.mst@redhat.com>
In-Reply-To: <42ba7beaa25855997e02fea91a11c9224c51720e.1337168687.git.mst@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/16/2012 02:46 PM, Michael S. Tsirkin wrote:
> Implementation of PV EOI using shared memory.
> This reduces the number of exits an interrupt
> causes as much as by half.
>
> The idea is simple: there's a bit, per APIC, in guest memory,
> that tells the guest that it does not need EOI.
> We set it before injecting an interrupt and clear
> before injecting a nested one. Guest tests it using
> a test and clear operation - this is necessary
> so that host can detect interrupt nesting -
> and if set, it can skip the EOI MSR.
>
> There's a new MSR to set the address of said register
> in guest memory. Otherwise not much changed:
> - Guest EOI is not required
> - Register is tested & ISR is automatically cleared on exit
>
> For testing results see description of previous patch
> 'kvm_para: guest side for eoi avoidance'.
>
>  
> +	/*
> +	 * It's legal for guest to ignore the PV EOI optimization
> +	 * and signal EOI by APIC write. If this happens, clear
> +	 * PV EOI on guest's behalf.
> +	 */
> +	if (pv_eoi_enabled(apic->vcpu))
> +		pv_eoi_clr_pending(apic->vcpu);

I'm a little worried about all the clr_pending() calls scattered
around.  What happens if we forget one?  In particular, we might miss
one on nested vmentry.

A safer path is to always clear it, but to enable it again during
reentry if all conditions are satisified.  Might be a little slower though.

-- 
error compiling committee.c: too many arguments to function

