Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753878Ab1HCJj4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 05:39:56 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56189 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753640Ab1HCJjw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 05:39:52 -0400
Message-ID: <4E3917DC.9040902@cn.fujitsu.com>
Date: Wed, 03 Aug 2011 17:41:48 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 02/12] KVM: x86: tag the instructions which are used
 to write page table
References: <4E37DA49.1040000@cn.fujitsu.com> <4E37DA73.7010908@cn.fujitsu.com> <4E37EB8E.6080207@redhat.com> <4E38E477.2000208@cn.fujitsu.com> <4E39021F.8070508@redhat.com> <4E3913CC.7010907@cn.fujitsu.com> <4E391417.6050503@redhat.com>
In-Reply-To: <4E391417.6050503@redhat.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-08-03 17:38:46,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-08-03 17:38:47
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03/2011 05:25 PM, Avi Kivity wrote:
> On 08/03/2011 12:24 PM, Xiao Guangrong wrote:
>> >  Maybe it's better to emulate if we can't find a fix for that.
>> >
>> >  One way would be to emulate every 20 instructions; this breaks us out of the loop but reduces costly emulations to 5%.
>> >
>>
>> After much thought about this, may be this optimization is not good since:
>> - it is little complex
>> - this optimization is only applied to the instruction emulation caused by #PF
>> - it does not improve too much:
>>    if we emulate the instruction, we need to do:
>>    - decode instruction
>>    - emulate it
>>    - zap shadow pages
>>    And do this, it can return to the guest, the guest can run the next instruction
>>
>>    if we retry the instruction, we need to do:
>>    - decode instruction
>>    - zap shadow pages
>>    then return to the guest and retry the instruction, however, we will get page fault
>>    again(since the mapping is still read-only), so we will get another VM-exit and need
>>    to do:
>>    # trigger page fault
>>    - handle the page fault and change the mapping to writable
>>    - retry the instruction
>>    until now, the guest can run the next instruction
>>
>> So, i do not think the new way is better, your opinion？
> 
> We can change to writeable and zap in the same exit, no?  Basically call page_fault() again after zapping.
> 

OK. :-)

Um, how about cache the last eip when we do this optimization, if we meet the same eip, we
can break out the potential infinite loop?
