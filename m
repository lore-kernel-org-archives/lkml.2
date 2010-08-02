Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753177Ab0HBIkg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 04:40:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11132 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751660Ab0HBIkf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 04:40:35 -0400
Message-ID: <4C568477.4000602@redhat.com>
Date: Mon, 02 Aug 2010 11:40:23 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.1
MIME-Version: 1.0
To: vatsa@linux.vnet.ibm.com
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        linux-kernel@vger.kernel.org, npiggin@suse.de, kvm@vger.kernel.org,
        bharata@in.ibm.com, Balbir Singh <balbir@in.ibm.com>,
        Jan Beulich <JBeulich@novell.com>
Subject: Re: [PATCH RFC 2/4] Add yield hypercall for KVM guests
References: <20100726061150.GB21699@linux.vnet.ibm.com> <20100726061445.GB8402@linux.vnet.ibm.com> <4C4DC3AD.7010404@goop.org> <20100728145516.GB27739@linux.vnet.ibm.com>
In-Reply-To: <20100728145516.GB27739@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 07/28/2010 05:55 PM, Srivatsa Vaddagiri wrote:
> On Mon, Jul 26, 2010 at 10:19:41AM -0700, Jeremy Fitzhardinge wrote:
>>   On 07/25/2010 11:14 PM, Srivatsa Vaddagiri wrote:
>>> Add KVM hypercall for yielding vcpu timeslice.
>> Can you do a directed yield?
> We don't have that support yet in Linux scheduler.

If you think it's useful, it would be good to design it into the 
interface, and fall back to ordinary yield if the host doesn't support it.

A big advantage of directed yield vs yield is that you conserve 
resources within a VM; a simple yield will cause the guest to drop its 
share of cpu to other guest.

Made up example:

- 2 vcpu guest with 10% contention
- lock hold time 10us every 100us
- timeslice 1ms

Ideally this guest can consume 190% cpu (sleeping whenever there is 
contention).  But if we yield when we detect contention, then we sleep 
for 1ms, and utilization drops to around 100%-150% (a vcpu will usually 
fall asleep soon within a few 100us periods).

> Also I feel it would be more
> useful when the target vcpu and yielding vcpu are on the same physical cpu,
> rather than when they are on separate cpus. With latter, yielding (or
> donating) timeslice need not ensure that target vcpu runs immediately

Donate at least the amount needed to wake up the other vcpu, we can 
calculate it during wakeup.

> and also I suspect fairness issues needs to be tackled as well (large number of
> waiters shouldn't boot a lock-holders time slice too much that it gets a
> larger share).

I feel ordinary yield suffers from fairness a lot more.

-- 
error compiling committee.c: too many arguments to function

