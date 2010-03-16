Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753280Ab0CPXEZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 19:04:25 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:36941 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753043Ab0CPXEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 19:04:23 -0400
Message-ID: <4BA00E6A.7080903@linux.vnet.ibm.com>
Date: Tue, 16 Mar 2010 18:04:10 -0500
From: Anthony Liguori <aliguori@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Lightning/1.0pre Thunderbird/3.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "Frank Ch. Eigler" <fche@redhat.com>, Avi Kivity <avi@redhat.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       oerg Roedel <joro@8bytes.org>, Jes Sorensen <Jes.Sorensen@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
       ziteng.huang@intel.com
Subject: Re: [PATCH] Enhance perf to collect KVM guest os statistics from
 host side
References: <20100316122903.GA8831@elte.hu> <4B9F7C6A.3070207@redhat.com> <20100316130840.GA24808@elte.hu> <4B9F84C0.70706@redhat.com> <20100316133114.GB575@elte.hu> <y0mbpeo1f1y.fsf@fche.csb> <20100316155221.GA19699@elte.hu> <4B9FC11A.1070507@linux.vnet.ibm.com> <20100316175243.GC23859@elte.hu> <4B9FC8B2.6070404@linux.vnet.ibm.com> <20100316182809.GA26602@elte.hu>
In-Reply-To: <20100316182809.GA26602@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/16/2010 01:28 PM, Ingo Molnar wrote:
> * Anthony Liguori<aliguori@linux.vnet.ibm.com>  wrote:
>
>    
>> On 03/16/2010 12:52 PM, Ingo Molnar wrote:
>>      
>>> * Anthony Liguori<aliguori@linux.vnet.ibm.com>   wrote:
>>>
>>>        
>>>> On 03/16/2010 10:52 AM, Ingo Molnar wrote:
>>>>          
>>>>> You are quite mistaken: KVM isnt really a 'random unprivileged application' in
>>>>> this context, it is clearly an extension of system/kernel services.
>>>>>
>>>>> ( Which can be seen from the simple fact that what started the discussion was
>>>>>    'how do we get /proc/kallsyms from the guest'. I.e. an extension of the
>>>>>    existing host-space /proc/kallsyms was desired. )
>>>>>            
>>>> Random tools (like perf) should not be able to do what you describe. It's a
>>>> security nightmare.
>>>>          
>>> A security nightmare exactly how? Mind to go into details as i dont understand
>>> your point.
>>>        
>> Assume you're using SELinux to implement mandatory access control.
>> How do you label this file system?
>>
>> Generally speaking, we don't know the difference between /proc/kallsyms vs.
>> /dev/mem if we do generic passthrough.  While it might be safe to have a
>> relaxed label of kallsyms (since it's read only), it's clearly not safe to
>> do that for /dev/mem, /etc/shadow, or any file containing sensitive
>> information.
>>      
> What's your _point_? Please outline a threat model, a vector of attack,
> _anything_ that substantiates your "it's a security nightmare" claim.
>    

You suggested "to have a (read only) mount of all guest filesystems".

As I described earlier, not all of the information within the guest 
filesystem has the same level of sensitivity.  If you exposed a generic 
interface like this, it makes it very difficult to delegate privileges.

Delegating privileges is important because from in a higher security 
environment, you may want to prevent a management tool from accessing 
the VM's disk directly, but still allow it to do basic operations (in 
particular, to view performance statistics).

>> Rather, we ought to expose a higher level interface that we have more
>> confidence in with respect to understanding the ramifications of exposing
>> that guest data.
>>      
> Exactly, we want something that has a flexible namespace and works well with
> Linux tools in general. Preferably that namespace should be human readable,
> and it should be hierarchic, and it should have a well-known permission model.
>
> This concept exists in Linux and is generally called a 'filesystem'.
>    

If you want to use a synthetic filesystem as the management interface 
for qemu, that's one thing.  But you suggested exposing the guest 
filesystem in its entirely and that's what I disagreed with.

> If a user cannot read the image file then the user has no access to its
> contents via other namespaces either. That is, of course, a basic security
> aspect.
>
> ( That is perfectly true with a non-SELinux Unix permission model as well, and
>    is true in the SELinux case as well. )
>    

I don't think that's reasonable at all.  The guest may encrypt it's disk 
image.  It still ought to be possible to run perf against that guest, no?

> Erm. Please explain to me, what exactly is 'not that simple' in a MAC
> environment?
>
> Also, i'd like to note that the 'restrictive SELinux setups' usecases are
> pretty secondary.
>
> To demonstrate that, i'd like every KVM developer on this list who reads this
> mail and who has their home development system where they produce their
> patches set up in a restrictive MAC environment, in that you cannot even read
> the images you are using, to chime in with a "I'm doing that" reply.
>    

My home system doesn't run SELinux but I work daily with systems that 
are using SELinux.

I want to be able to run tools like perf on these systems because 
ultimately, I need to debug these systems on a daily basis.

But that's missing the point.  We want to have an interface that works 
for both cases so that we're not maintaining two separate interfaces.

We've rat holed a bit though.  You want:

1) to run perf kvm list and be able to enumerate KVM guests

2) for this to Just Work with qemu guests launched from the command line

You could achieve (1) by tying perf to libvirt but that won't work for 
(2).  There are a few practical problems with (2).

qemu does not require the user to associate any uniquely identifying 
information with a VM.  We've also optimized the command line use case 
so that if all you want to do is run a disk image, you just execute 
"qemu foo.img".  To satisfy your use case, we would either have to force 
a use to always specify unique information, which would be less 
convenient for our users or we would have to let the name be an optional 
parameter.

As it turns out, we already support "qemu -name Fedora foo.img".  What 
we don't do today, but I've been suggesting we should, is automatically 
create a QMP management socket in a well known location based on the 
-name parameter when it's specified.  That would let a tool like perf 
Just Work provided that a user specified -name.

No one uses -name today though and I'm sure you don't either.

The only way to really address this is to change the interaction.  
Instead of running perf externally to qemu, we should support a perf 
command in the qemu monitor that can then tie directly to the perf 
tooling.  That gives us the best possible user experience.

We can't do that though unless perf is a library or is in some way more 
programmatic.

Regards,

Anthony Liguori

