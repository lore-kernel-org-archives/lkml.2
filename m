Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753564Ab1HCJZ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 05:25:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46510 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753502Ab1HCJZu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 05:25:50 -0400
Message-ID: <4E391417.6050503@redhat.com>
Date: Wed, 03 Aug 2011 12:25:43 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110621 Fedora/3.1.11-1.fc15 Thunderbird/3.1.11
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 02/12] KVM: x86: tag the instructions which are used
 to write page table
References: <4E37DA49.1040000@cn.fujitsu.com> <4E37DA73.7010908@cn.fujitsu.com> <4E37EB8E.6080207@redhat.com> <4E38E477.2000208@cn.fujitsu.com> <4E39021F.8070508@redhat.com> <4E3913CC.7010907@cn.fujitsu.com>
In-Reply-To: <4E3913CC.7010907@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03/2011 12:24 PM, Xiao Guangrong wrote:
> >  Maybe it's better to emulate if we can't find a fix for that.
> >
> >  One way would be to emulate every 20 instructions; this breaks us out of the loop but reduces costly emulations to 5%.
> >
>
> After much thought about this, may be this optimization is not good since:
> - it is little complex
> - this optimization is only applied to the instruction emulation caused by #PF
> - it does not improve too much:
>    if we emulate the instruction, we need to do:
>    - decode instruction
>    - emulate it
>    - zap shadow pages
>    And do this, it can return to the guest, the guest can run the next instruction
>
>    if we retry the instruction, we need to do:
>    - decode instruction
>    - zap shadow pages
>    then return to the guest and retry the instruction, however, we will get page fault
>    again(since the mapping is still read-only), so we will get another VM-exit and need
>    to do:
>    # trigger page fault
>    - handle the page fault and change the mapping to writable
>    - retry the instruction
>    until now, the guest can run the next instruction
>
> So, i do not think the new way is better, your opinion？

We can change to writeable and zap in the same exit, no?  Basically call 
page_fault() again after zapping.

-- 
error compiling committee.c: too many arguments to function

