Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754034Ab0IFJGP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 05:06:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46334 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753884Ab0IFJGH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 05:06:07 -0400
Message-ID: <4C84AEF5.2070309@redhat.com>
Date: Mon, 06 Sep 2010 12:05:57 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.2
MIME-Version: 1.0
To: Alexander Graf <agraf@suse.de>
CC: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH] KVM: don't sent IPI if the vcpu is not online
References: <4C807593.1050903@cn.fujitsu.com> <4C83445B.4020103@redhat.com> <4C844887.9090802@cn.fujitsu.com> <4C84801F.9060803@redhat.com> <DCCDD62D-CE92-453A-BB3C-DF878D893C3F@suse.de> <4C84AC6B.4090306@redhat.com> <633F01D5-D6AD-40F3-8864-C3AE4D314E30@suse.de>
In-Reply-To: <633F01D5-D6AD-40F3-8864-C3AE4D314E30@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 09/06/2010 11:59 AM, Alexander Graf wrote:
> On 06.09.2010, at 10:55, Avi Kivity wrote:
>
>> On 09/06/2010 11:51 AM, Alexander Graf wrote:
>>>> I think guest_mode makes sense for the other archs for reducing IPIs, so let's leave it common and recommend that they implement it.  Alex, if you're ever bored.
>>> What does the bit do? Do we have documentation on it ;)? No seriously, what's the intent of the field?
>>>
>> It indicates that the vcpu is currently executing guest code.  Which in turn is important if you need to force it out of guest mode in order to inject an interrupt or flush the tlb.
> Well, a vcpu is either offline in halt state or in guest mode, no? So we can conclude that guest_mode == !offline&&  !halt_state.

It can also be running host kernel or user code.

> When in halt state, we are active on the wakeup waitqueue:
>
> static void kvmppc_decrementer_func(unsigned long data)
> {
>          struct kvm_vcpu *vcpu = (struct kvm_vcpu *)data;
>
>          kvmppc_core_queue_dec(vcpu);
>
>          if (waitqueue_active(&vcpu->wq)) {
>                  wake_up_interruptible(&vcpu->wq);
>                  vcpu->stat.halt_wakeup++;
>          }
> }
>
> Shouldn't that be enough information already?

It's sufficient for correctness.  It's not optimal since you miss the 
cases where you're not running guest code.

Not sure how important it is.  Xiao, any numbers?

-- 
error compiling committee.c: too many arguments to function

