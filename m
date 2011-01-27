Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510Ab1A0NQE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 08:16:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1026 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752958Ab1A0NQC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 08:16:02 -0500
Message-ID: <4D417006.4030201@redhat.com>
Date: Thu, 27 Jan 2011 15:15:50 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 1/3] KVM: fix rcu usage warning in kvm_arch_vcpu_ioctl_set_sregs()
References: <4D2D5AA6.9080804@cn.fujitsu.com> <4D3673A7.4090402@cn.fujitsu.com> <20110119181347.GA13142@amt.cnet> <4D37A603.4040602@cn.fujitsu.com> <20110120152736.GA3922@amt.cnet>
In-Reply-To: <20110120152736.GA3922@amt.cnet>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/20/2011 05:27 PM, Marcelo Tosatti wrote:
> >  Before patch:
> >
> >  real    5m6.493s
> >  user    3m57.847s
> >  sys     9m7.115s
> >
> >  real    5m1.750s
> >  user    4m0.109s
> >  sys     9m10.192s
> >
> >
> >  After patch:
> >  real    5m0.140s
> >  user    3m57.956s
> >  sys     8m58.339s
> >
> >  real    4m56.314s
> >  user    4m0.303s
> >  sys     8m55.774s
>
> Nice. One disadvantageous side effect for the kvm_vcpu_kick path
> is that it can race with make_all_cpus_request, which is possibly
> doing unrelated, slower work (IPI'ing other vcpus, waiting for
> response).

I think we're fine here.  The kvm_vcpu_kick() check is

  	me = get_cpu();
  	if (cpu != me&&  (unsigned)cpu<  nr_cpu_ids&&  cpu_online(cpu))
-		if (atomic_xchg(&vcpu->guest_mode, 0))
+		if (kvm_vcpu_exiting_guest_mode(vcpu) == IN_GUEST_MODE)
  			smp_send_reschedule(cpu);
  	put_cpu();


even if it did race, ->mode becomes EXITING_GUEST_MODE and we still 
avoid the IPI.  Note that make_all_cpus_request() cleverly checks for != 
OUTSIDE_GUEST_MODE, so if it loses the race with kvm_vcpu_kick(), it 
still sends the IPI to be sure the vcpu loop sees vcpu->requests in time.

> Looks ok, but lets wait for more careful reviews before applying.

Patches applied.

-- 
error compiling committee.c: too many arguments to function

