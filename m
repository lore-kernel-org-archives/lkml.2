Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756403Ab2IXP1P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 11:27:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19689 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754276Ab2IXP1N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 11:27:13 -0400
Message-ID: <50607BBE.8070507@redhat.com>
Date: Mon, 24 Sep 2012 17:26:54 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
CC: Peter Zijlstra <peterz@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Rik van Riel <riel@redhat.com>, Srikar <srikar@linux.vnet.ibm.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, Jiannan Ouyang <ouyang@cs.pitt.edu>,
        chegu vinod <chegu_vinod@hp.com>,
        "Andrew M. Theurer" <habanero@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>,
        Gleb Natapov <gleb@redhat.com>
Subject: Re: [PATCH RFC 2/2] kvm: Be courteous to other VMs in overcommitted
 scenario in PLE handler
References: <20120921115942.27611.67488.sendpatchset@codeblue> <20120921120019.27611.66093.sendpatchset@codeblue>
In-Reply-To: <20120921120019.27611.66093.sendpatchset@codeblue>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/21/2012 03:00 PM, Raghavendra K T wrote:
> From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
> 
> When PLE handler fails to find a better candidate to yield_to, it
> goes back and does spin again. This is acceptable when we do not
> have overcommit.
> But in overcommitted scenarios (especially when we have large
> number of small guests), it is better to yield.
> 
> Reviewed-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
> Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
> ---
>  virt/kvm/kvm_main.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 8323685..713b677 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1660,6 +1660,10 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me)
>  			}
>  		}
>  	}
> +	/* In overcommitted cases, yield instead of spinning */
> +	if (!yielded && rq_nr_running() > 1)
> +		schedule();
> +

I think this is a no-op these (CFS) days.  To get schedule() to do
anything, you need to wake up a task, or let time pass, or block.
Otherwise it will see that nothing has changed and as far as it's
concerned you're still the best task to be running (otherwise it
wouldn't have picked you in the first place).


-- 
error compiling committee.c: too many arguments to function
