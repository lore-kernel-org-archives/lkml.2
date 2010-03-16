Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937891Ab0CPNRJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 09:17:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24156 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937687Ab0CPNRG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 09:17:06 -0400
Message-ID: <4B9F84C0.70706@redhat.com>
Date: Tue, 16 Mar 2010 15:16:48 +0200
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
References: <20100316095336.GI7961@elte.hu> <4B9F59DE.1060008@redhat.com> <20100316102052.GC10069@elte.hu> <4B9F603B.4080004@redhat.com> <20100316105021.GA14344@elte.hu> <4B9F671D.5060001@redhat.com> <20100316112500.GA5337@elte.hu> <4B9F77E7.2060101@redhat.com> <20100316122903.GA8831@elte.hu> <4B9F7C6A.3070207@redhat.com> <20100316130840.GA24808@elte.hu>
In-Reply-To: <20100316130840.GA24808@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/16/2010 03:08 PM, Ingo Molnar wrote:
>
>>> I mean, i can trust a kernel service and i can trust /proc/kallsyms.
>>>
>>> Can perf trust a random process claiming to be Qemu? What's the trust
>>> mechanism here?
>>>        
>> Obviously you can't trust anything you get from a guest, no matter how you
>> get it.
>>      
> I'm not talking about the symbol strings and addresses, and the object
> contents for allocation (or debuginfo). I'm talking about the basic protocol
> of establishing which guest is which.
>    

There is none.  So far, qemu only dealt with managing just its own 
guest, and left all multiple guest management to higher levels up the 
stack (like libvirt).

> I.e. we really want to be able users to:
>
>   1) have it all working with a single guest, without having to specify 'which'
>      guest (qemu PID) to work with. That is the dominant usecase both for
>      developers and for a fair portion of testers.
>    

That's reasonable if we can get it working simply.

>   2) Have some reasonable symbolic identification for guests. For example a
>      usable approach would be to have 'perf kvm list', which would list all
>      currently active guests:
>
>       $ perf kvm list
>         [1] Fedora
>         [2] OpenSuse
>         [3] Windows-XP
>         [4] Windows-7
>
>      And from that point on 'perf kvm -g OpenSuse record' would do the obvious
>      thing. Users will be able to just use the 'OpenSuse' symbolic name for
>      that guest, even if the guest got restarted and switched its main PID.
>
> Any such facility needs trusted enumeration and a protocol where i can trust
> that the information i got is authorative. (I.e. 'OpenSuse' truly matches to
> the OpenSuse session - not to some local user starting up a Qemu instance that
> claims to be 'OpenSuse'.)
>
> Is such a scheme possible/available? I suspect all the KVM configuration tools
> (i havent used them in some time - gui and command-line tools alike) use
> similar methods to ease guest management?
>    

You can do that through libvirt, but that only works for guests started 
through libvirt.  libvirt provides command-line tools to list and manage 
guests (for example autostarting them on startup), and tools built on 
top of libvirt can manage guests graphically.

Looks like we have a layer inversion here.  Maybe we need a plugin 
system - libvirt drops a .so into perf that teaches it how to list 
guests and get their symbols.

-- 
error compiling committee.c: too many arguments to function

