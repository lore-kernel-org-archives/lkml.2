Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756542Ab2JQKQh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 06:16:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27071 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756022Ab2JQKQf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 06:16:35 -0400
Message-ID: <507E8575.4040908@redhat.com>
Date: Wed, 17 Oct 2012 12:16:21 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
CC: x86@kernel.org, kexec@lists.infradead.org, linux-doc@vger.kernel.org,
        mtosatti@redhat.com, linux-kernel@vger.kernel.org,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "Nakajima, Jun" <jun.nakajima@intel.com>
Subject: Re: [PATCH 0/3] x86: clear vmcss on all cpus when doing kdump if
 necessary
References: <5077BB7B.4030203@cn.fujitsu.com> <507C2F18.8080904@redhat.com> <507E17C0.9070305@cn.fujitsu.com>
In-Reply-To: <507E17C0.9070305@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/17/2012 04:28 AM, Zhang Yanfei wrote:
> 于 2012年10月15日 23:43, Avi Kivity 写道:
>> On 10/12/2012 08:40 AM, Zhang Yanfei wrote:
>>> Currently, kdump just makes all the logical processors leave VMX operation by
>>> executing VMXOFF instruction, so any VMCSs active on the logical processors may
>>> be corrupted. But, sometimes, we need the VMCSs to debug guest images contained
>>> in the host vmcore. To prevent the corruption, we should VMCLEAR the VMCSs before
>>> executing the VMXOFF instruction.
>> 
>> How have you verified that VMXOFF doesn't flush cached VMCSs already?
>> 
> 
> I tried some tests, for example, I made copies for every vmcs, and in the kdump
> path, I backed up all the loaded vmcs into the copies before vmxoff.
> After generating the vmcore, I retrieve the vmcss and their copies, and compare them,
> no differences.
> 
> Another test is using VMCLEAR to clear all the loaded vmcs before VMXOFF,
> and compare the vmcss and their copies, there are indeed differences between the
> vmcs and its copy.
> 
> I know the tests may be not so convincing, for example, I used memcpy to back up
> the vmcss and it is an ordinary memory operation. But to ensure the non-corruption
> of the vmcss in the vmcore, I think we should VMCLEAR the vmcss before VMXOFF just
> as the Intel spec says.

Sorry, I was unclear -- I was referring to the spec, I wasn't sure
whether VMXOFF is defined to flush VMCSes or whether it just invalidates
on-chip caches so that it won't flush them out in the future, corrupting
memory.  We don't want to depend on actual behaviour as it may change
with future version.

Copying some Intel folk, maybe they can clarify it.

> 
>>>
>>> The patch set provides an alternative way to clear VMCSs related to guests
>>> on all cpus when host is doing kdump.
>>>
>> 
>> I'm not sure the sysctl is really necessary.  The only reason to turn if
>> off is if the corruption is so severe that the loaded vmcs list itself
>> causes a crash.  I think it should be rare enough that we can do it
>> unconditionally.
>> 
> 
> You mean not using sysctl and just let VMCLEAR-VMCSS be a default behaviour? If so,
> I agree with you.

Yes, that's what I meant.


-- 
error compiling committee.c: too many arguments to function
