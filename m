Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386Ab0CPMma (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 08:42:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49682 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751652Ab0CPMm3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 08:42:29 -0400
Message-ID: <4B9F7C6A.3070207@redhat.com>
Date: Tue, 16 Mar 2010 14:41:14 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       oerg Roedel <joro@8bytes.org>, Jes Sorensen <Jes.Sorensen@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
       ziteng.huang@intel.com
Subject: Re: [PATCH] Enhance perf to collect KVM guest os statistics from
 host side
References: <20100316072449.GB11881@elte.hu> <4B9F4D74.4090403@redhat.com> <20100316095336.GI7961@elte.hu> <4B9F59DE.1060008@redhat.com> <20100316102052.GC10069@elte.hu> <4B9F603B.4080004@redhat.com> <20100316105021.GA14344@elte.hu> <4B9F671D.5060001@redhat.com> <20100316112500.GA5337@elte.hu> <4B9F77E7.2060101@redhat.com> <20100316122903.GA8831@elte.hu>
In-Reply-To: <20100316122903.GA8831@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/16/2010 02:29 PM, Ingo Molnar wrote:
> * Avi Kivity<avi@redhat.com>  wrote:
>
>    
>> On 03/16/2010 01:25 PM, Ingo Molnar wrote:
>>      
>>>        
>>>> I haven't followed vmchannel closely, but I think it is.  vmchannel is
>>>> terminated in qemu on the host side, not in the host kernel.  So perf would
>>>> need to connect to qemu.
>>>>          
>>> Hm, that sounds rather messy if we want to use it to basically expose kernel
>>> functionality in a guest/host unified way. Is the qemu process discoverable in
>>> some secure way?
>>>        
>> We know its pid.
>>      
> How do i get a list of all 'guest instance PIDs',

Libvirt manages all qemus, but this should be implemented independently 
of libvirt.

> and what is the way to talk
> to Qemu?
>    

In general qemu exposes communication channels (such as the monitor) as 
tcp connections, unix-domain sockets, stdio, etc.  It's very flexible.

>>> Can we trust it?
>>>        
>> No choice, it contains the guest address space.
>>      
> I mean, i can trust a kernel service and i can trust /proc/kallsyms.
>
> Can perf trust a random process claiming to be Qemu? What's the trust
> mechanism here?
>    

Obviously you can't trust anything you get from a guest, no matter how 
you get it.

How do you trust a userspace program's symbols?  you don't.  How do you 
get them?  they're on a well-known location.

>>> Is there some proper tooling available to do it, or do we have to push it
>>> through 2-3 packages to get such a useful feature done?
>>>        
>> libvirt manages qemu processes, but I don't think this should go through
>> libvirt.  qemu can do this directly by opening a unix domain socket in a
>> well-known place.
>>      
> So Qemu has never run into such problems before?
>
> ( Sounds weird - i think Qemu configuration itself should be done via a
>    unix domain socket driven configuration protocol as well. )
>    

That's exactly what happens.  You invoke qemu with -monitor 
unix:blah,server (or -qmp for a machine-readable format) and have your 
management application connect to that.  You can redirect guest serial 
ports, console, parallel port, etc. to unix-domain or tcp sockets.  
vmchannel is an extension of that mechanism.


>>> ( That is the general thought process how many cross-discipline useful
>>>    desktop/server features hit the bit bucket before having had any chance of
>>>    being vetted by users, and why Linux sucks so much when it comes to feature
>>>    integration and application usability. )
>>>        
>> You can't solve everything in the kernel, even with a well populated tools/.
>>      
> Certainly not, but this is a technical problem in the kernel's domain, so it's
> a fair (and natural) expectation to be able to solve this within the kernel
> project.
>    

Someone writing perf-gui outside the kernel would have the same 
problems, no?

-- 
error compiling committee.c: too many arguments to function

