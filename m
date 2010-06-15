Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757677Ab0FOLpO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 07:45:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1222 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752841Ab0FOLpM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 07:45:12 -0400
Message-ID: <4C1767C4.7020506@redhat.com>
Date: Tue, 15 Jun 2010 14:45:08 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH 0/6] KVM: MMU: support pte prefetch when intercepted guest
 #PF
References: <4C16E974.8000304@cn.fujitsu.com>
In-Reply-To: <4C16E974.8000304@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/15/2010 05:46 AM, Xiao Guangrong wrote:
> Hi Avi, Marcelo,
>
> This patchset support pte prefetch when intercepted guest #PF,
> the aim is to reduce guest #PF which can be intercepted by VMM.
>
> If we meet any failure in the prefetch path, we will exit it
> and not try other ptes to avoid become heavy path.
>
> During my performance test, under EPT enabled case, unixbench
> shows the performance improved ~1.2%,

Once the guest has faulted in all memory, we shouldn't see much 
improvement, yes?

> user EPT disable case,
> unixbench shows the performance improved ~3.6%
>    

I'm a little worried about this.  In some workloads, prefetch can often 
fail due to gpte.a=0 so we spend effort doing nothing.  There is also 
the issue of marking pages as accessed or even dirty when in fact the 
guest did not access them.

We should map those pages with pte.a=pte.d=0 so we don't confuse host 
memory management.  On EPT (which lacks a/d bits) we can't enable it 
(but we can on NPT).

-- 
error compiling committee.c: too many arguments to function

