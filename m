Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753327Ab1LDKXR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Dec 2011 05:23:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37128 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751979Ab1LDKXP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Dec 2011 05:23:15 -0500
Message-ID: <4EDB4A0D.1000609@redhat.com>
Date: Sun, 04 Dec 2011 12:23:09 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Liu Ping Fan <kernelfans@gmail.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, aliguori@us.ibm.com,
        gleb@redhat.com, jan.kiszka@web.de
Subject: Re: [PATCH] kvm: make vcpu life cycle separated from kvm instance
References: <4ED212A1.3060300@redhat.com> <1322807192-14147-1-git-send-email-kernelfans@gmail.com>
In-Reply-To: <1322807192-14147-1-git-send-email-kernelfans@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/02/2011 08:26 AM, Liu Ping Fan wrote:
> From: Liu Ping Fan <pingfank@linux.vnet.ibm.com>
>
> Currently, vcpu can be destructed only when kvm instance destroyed.
> Change this to vcpu's destruction taken when its refcnt is zero,
> and then vcpu MUST and CAN be destroyed before kvm's destroy.
>
>  
> @@ -315,9 +315,17 @@ static void pit_do_work(struct work_struct *work)
>  		 * LVT0 to NMI delivery. Other PIC interrupts are just sent to
>  		 * VCPU0, and only if its LVT0 is in EXTINT mode.
>  		 */
> -		if (kvm->arch.vapics_in_nmi_mode > 0)
> -			kvm_for_each_vcpu(i, vcpu, kvm)
> +		if (kvm->arch.vapics_in_nmi_mode > 0) {
> +			rcu_read_lock();
> +			kvm_for_each_vcpu(i, cnt, vcpu, kvm) {
> +				vcpu = kvm_get_vcpu(kvm, i);
> +				if (vcpu == NULL)
> +					continue;
> +				cnt++;
>  				kvm_apic_nmi_wd_deliver(vcpu);
> +			}
> +			rcu_read_unlock();
> +		}
>  	}
>  }

This pattern keeps repeating, please fold it into kvm_for_each_vcpu().

-- 
error compiling committee.c: too many arguments to function

