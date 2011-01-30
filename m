Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754257Ab1A3NQj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jan 2011 08:16:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50122 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753583Ab1A3NQi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jan 2011 08:16:38 -0500
Message-ID: <4D45649A.4090709@redhat.com>
Date: Sun, 30 Jan 2011 15:16:10 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Glauber Costa <glommer@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, aliguori@us.ibm.com,
        Rik van Riel <riel@redhat.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v2 4/6] KVM-GST: KVM Steal time registration
References: <1296244340-15173-1-git-send-email-glommer@redhat.com> <1296244340-15173-5-git-send-email-glommer@redhat.com>
In-Reply-To: <1296244340-15173-5-git-send-email-glommer@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/28/2011 09:52 PM, Glauber Costa wrote:
> Register steal time within KVM. Everytime we sample the steal time
> information, we update a local variable that tells what was the
> last time read. We then account the difference.
>
>
>
>   static void kvm_guest_cpu_offline(void *dummy)
>   {
>   	kvm_pv_disable_apf(NULL);
> +	native_write_msr(MSR_KVM_STEAL_TIME, 0, 0);
>   	apf_task_wake_all();
>   }

Don't use the native_ versions, they override the pvops implementation.  
It doesn't matter for kvm, but we're not supposed to know this.

> +	/*
> +	 * using nanoseconds introduces noise, which accumulates easily
> +	 * leading to big steal time values. We want, however, to keep the
> +	 * interface nanosecond-based for future-proofness. The hypervisor may
> +	 * adopt a similar strategy, but we can't rely on that.
> +	 */
> +	delta /= NSEC_PER_MSEC;
> +	delta *= NSEC_PER_MSEC;

You're working around this problem both in the guest and host.  So even 
if we fix it in one, it will still be broken in the other.

> +
> +	return delta;
> +}
> +

-- 
error compiling committee.c: too many arguments to function

