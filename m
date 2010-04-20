Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754975Ab0DTTmU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 15:42:20 -0400
Received: from claw.goop.org ([74.207.240.146]:39197 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754264Ab0DTTmT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 15:42:19 -0400
Message-ID: <4BCE0399.2010708@goop.org>
Date: Tue, 20 Apr 2010 12:42:17 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Peter Zijlstra <peterz@infradead.org>, Glauber Costa <glommer@redhat.com>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Marcelo Tosatti <mtosatti@redhat.com>,
       Zachary Amsden <zamsden@redhat.com>
Subject: Re: [PATCH 1/5] Add a global synchronization point for pvclock
References: <1271356648-5108-1-git-send-email-glommer@redhat.com>	 <1271356648-5108-2-git-send-email-glommer@redhat.com>	 <4BC8CA52.4090703@goop.org> <1271673545.1674.743.camel@laptop>	 <4BCC3584.1050501@redhat.com> <1271675100.1674.818.camel@laptop>	 <4BCC3A3E.9070909@redhat.com>	 <20100419142158.GD14158@mothafucka.localdomain>	 <4BCC69D5.3050209@redhat.com> <1271688411.1488.248.camel@laptop> <4BCC8246.9040202@goop.org> <4BCD748E.7080007@redhat.com> <4BCDF12C.1020702@goop.org> <4BCDF85C.3000004@redhat.com>
In-Reply-To: <4BCDF85C.3000004@redhat.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/20/2010 11:54 AM, Avi Kivity wrote:
> On 04/20/2010 09:23 PM, Jeremy Fitzhardinge wrote:
>> On 04/20/2010 02:31 AM, Avi Kivity wrote:
>>   
>>> btw, do you want this code in pvclock.c, or shall we keep it kvmclock
>>> specific?
>>>      
>> I think its a pvclock-level fix.  I'd been hoping to avoid having
>> something like this, but I think its ultimately necessary.
>>    
>
> Did you observe drift on Xen, or is this "ultimately" pointing at the
> future?

People are reporting weirdnesses that "clocksource=jiffies" apparently
resolves.  Xen and KVM are faced with the same hardware constraints, and
it wouldn't surprise me if there were small measurable
non-monotonicities in the PV clock under Xen.  May as well be safe.

Of course, it kills any possibility of being able to usefully export
this interface down to usermode.

My main concern about this kind of simple fix is that if there's a long
term systematic drift between different CPU's tscs, then this will
somewhat mask the problem while giving really awful time measurement on
the "slow" CPU(s).  In that case it really needs to adjust the scaling
factor to correct for the drift (*not* update the offset).  But if we're
definitely only talking about fixed, relatively small time offsets then
it is fine.

    J
