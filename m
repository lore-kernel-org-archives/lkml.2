Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751488Ab1AIKPa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jan 2011 05:15:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64678 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750869Ab1AIKP3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jan 2011 05:15:29 -0500
Message-ID: <4D29872A.608@redhat.com>
Date: Sun, 09 Jan 2011 12:00:10 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 2/3] KVM: send IPI to vcpu only when it's in guest
 mode
References: <4D26C4D4.30303@cn.fujitsu.com> <4D26C527.9090403@cn.fujitsu.com> <20110107115527.GA13196@amt.cnet>
In-Reply-To: <20110107115527.GA13196@amt.cnet>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/07/2011 01:55 PM, Marcelo Tosatti wrote:
> On Fri, Jan 07, 2011 at 03:47:51PM +0800, Xiao Guangrong wrote:
> >  We can interrupt the vcpu only when it's running in guest mode
> >  to reduce IPI
> >
> >  It looks like only ia64 and x86 need to send IPI to other vcpus, so
> >  i only add the implementation of 'vcpu->guest_mode' in ia64, but i
> >  don't know ia64 well, please point out the right way for me if the
> >  implementation is incorrect
> >
> >  Also reorganize struct kvm_vcpu to make ->guest_mode and ->requests
> >  in the same cache line explicitly.
> >
> >  Signed-off-by: Xiao Guangrong<xiaoguangrong@cn.fujitsu.com>
> >  ---
> >   arch/ia64/kvm/kvm-ia64.c |    2 ++
> >   arch/x86/kvm/x86.c       |    6 +++++-
> >   include/linux/kvm_host.h |    9 +++++----
> >   virt/kvm/kvm_main.c      |    7 ++++++-
> >   4 files changed, 18 insertions(+), 6 deletions(-)
> >
>
> >  diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> >  index b1b6cbb..a475264 100644
> >  --- a/virt/kvm/kvm_main.c
> >  +++ b/virt/kvm/kvm_main.c
> >  @@ -153,7 +153,12 @@ static bool make_all_cpus_request(struct kvm *kvm, unsigned int req)
> >   		if (kvm_make_check_request(req, vcpu))
> >   			continue;
> >   		cpu = vcpu->cpu;
> >  -		if (cpus != NULL&&  cpu != -1&&  cpu != me)
> >  +
> >  +		/* Set ->requests bit before we read ->guest_mode */
> >  +		smp_mb();
> >  +
> >  +		if (cpus != NULL&&  cpu != -1&&  cpu != me&&
> >  +		      atomic_read(&vcpu->guest_mode))
> >   			cpumask_set_cpu(cpu, cpus);
>
> Don't think this is safe, since guest_mode does not imply that a vcpu
> has received the IPI, only that IPI has been sent (see kvm_vcpu_kick).
>
> And make_all_cpus_request must guarantee all target vcpus are out of
> guest mode before it returns.
>

Good catch.  We could remove the atomic_xchg() in kvm_vcpu_kick(), but 
need to think of any drawbacks to that.

Maybe we could replace guest_mode with a three value variable: in guest, 
outside guest, and transitioning out of guest.    So kvm_vcpu_kick() 
avoids the IPI on the last two, while make_all_cpus_request() only 
avoids an IPI if outside guest mode.

-- 
error compiling committee.c: too many arguments to function

