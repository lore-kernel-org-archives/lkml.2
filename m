Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754096Ab0GMIxQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 04:53:16 -0400
Received: from mail.lang.hm ([64.81.33.126]:50544 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752829Ab0GMIxO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 04:53:14 -0400
Date: Tue, 13 Jul 2010 01:53:00 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
cc: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>, kvm@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        mori.keisuke@oss.ntt.co.jp, Chris Wright <chrisw@redhat.com>,
        Dor Laor <dlaor@redhat.com>, Lon Hohberger <lhh@redhat.com>,
        "Perry N. Myers" <pmyers@redhat.com>,
        Luiz Capitulino <lcapitulino@redhat.com>, berrange@redhat.com
Subject: Re: [RFC] High availability in KVM
In-Reply-To: <20100713165020.5ae64155.yoshikawa.takuya@oss.ntt.co.jp>
Message-ID: <alpine.DEB.2.00.1007130144030.5188@asgard.lang.hm>
References: <4C199348.6050108@oss.ntt.co.jp> <alpine.DEB.2.00.1007101510180.27626@asgard.lang.hm> <4C3AB489.4020700@oss.ntt.co.jp> <alpine.DEB.2.00.1007120236500.5188@asgard.lang.hm> <20100713165020.5ae64155.yoshikawa.takuya@oss.ntt.co.jp>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Jul 2010, Takuya Yoshikawa wrote:

> On Mon, 12 Jul 2010 02:49:55 -0700 (PDT)
> david@lang.hm wrote:
>
>> On Mon, 12 Jul 2010, Takuya Yoshikawa wrote:
>>
>>
>>>   and RA returns the state to Pacemaker as it's already stopped.
>>>
>>>  (*2): Currently we are checking "shut off" answer from domstate command.
>>>   Yes, we should care about both SHUTOFF and CRASHED if possible.
>>>
>>> 4: Pacemaker finally tries to confirm if it can safely start failover by
>>>   sending stop command. After killing Qemu, RA replies to Pacemaker
>>>   "OK" so that Pacemaker can start failover.
>>>
>>> Problems: We lose debuggable information of VM such as the contents of
>>>   guest memory.
>>
>> the OCF interface has start, stop, status (running or not) or an error
>> (plus API info)
>>
>> what I would do in this case is have the script notice that it's in
>> crashed status and return an error if it's told to start it. This will
>> cause pacemaker to start the service on another system.
>
>
> I see.
> So the key point is to how to check target, crashed in this case, status.
>
> In the HA's point of view, we need that qemu guarantees:
> - Guest never start again
> - VM never modify external resources
>
> But I'm not so sure if qemu currently guarantees such conditions in generic
> manner.

you don't have to depend on the return from qemu. there are many OCF 
scripts that maintain state internally (look at the e-mail script as an 
example), if your OCF script thinks that it should be running and it 
isn't, mark it as crashed and don't try to start it again until external 
actions clear the status (and you can have a boot do so in case you have 
an unclean shutdown)

> Generically I agree that we always start the guest in another node for
> failover.  But are there any benefits if we can start the guest in the
> same node?

I don't believe that pacemaker supports this concept.

however, if you wanted to you could have the OCF script know that there is 
a 'crshed' instance and instead of trying to start it, start a fresh copy.

>
>>
>> if it's told to stop it, do whatever you can to save state, but definantly
>> pause/freeze the instance and return 'stopped'
>>
>>
>>
>> no need to define some additional state. As far as pacemaker is concerned
>> it's safe as long as there is no chance of it changing the state of any
>> shared resources that the other system would use, so simply pausing the
>> instance will make it safe. It will be interesting when someone wants to
>> investigate what's going on inside the instance (you need to have it be
>> functional, but not able to use the network or any shared
>> drives/filesystems), but I don't believe that you can get that right in a
>> generic manner, the details of what will cause grief and what won't will
>> vary from site to site.
>
>
> If we cannot say in a generic manner, we usually choose the most conservative
> one: memory and ... perservation only.
>
> What we concern the most is qemu actually guarantees the conditions we are
> talking in this thread.

I'll admit that I'm not familiar with using qemu/KVM, but vmware/virtual 
box/XEN all have an option to freeze all activity and save the ram to a 
disk file for a future restart. the OCF file can trigger such action 
easily.

>>> B. Our proposal: "introduce a new domain state to indicate failover-safe"
>>>
>>>   Pacemaker...(OCF)....RA...(libvirt)...Qemu
>>>       |                 |                 |
>>>       |                 |                 |
>>> 1:     +---- start ----->+---------------->+ state=RUNNING
>>>       |                 |                 |
>>>       +---- monitor --->+---- domstate -->+
>>> 2:     |                 |                 |
>>>       +<---- "OK" ------+<--- "RUNNING" --+
>>>       |                 |                 |
>>>       |                 |                 |
>>>       |                 |                 * Error: state=FROZEN
>>>       |                 |                 |   Qemu releases resources
>>>       |                 |                 |   and VM gets frozen. (*3)
>>>       +---- monitor --->+---- domstate -->+
>>> 3:     |                 |                 |
>>>       +<-- "STOPPED" ---+<--- "FROZEN" ---+
>>>       |                 |                 |
>>>       +---- stop ------>+---- domstate -->+
>>> 4:     |                 |                 |
>>>       +<---- "OK" ------+<--- "FROZEN" ---+
>>>       |                 |                 |
>>>       |                 |                 |
>>>
>>>
>>> 1: Pacemaker starts Qemu.
>>>
>>> 2: Pacemaker checks the state of Qemu via RA.
>>>   RA checks the state of Qemu using virsh(libvirt).
>>>   Qemu replies to RA "RUNNING"(normally executing), (*1)
>>>   and RA returns the state to Pacemaker as it's running correctly.
>>>
>>>   --- SOME ERROR HAPPENS ---
>>>
>>> 3: Pacemaker checks the state of Qemu via RA.
>>>   RA checks the state of Qemu using virsh(libvirt).
>>>   Qemu replies to RA "FROZEN"(VM stopped in a failover-safe state), (*3)
>>>   and RA keeps it in mind, then replies to Pacemaker "STOPPED".
>>>
>>>  (*3): this is what we want to introduce as a new state. Failover-safe means
>>>    that Qemu released the external resources, including some namespaces, to
>>> be
>>>    available from another instance.
>>
>> it doesn't need to release the resources. It just needs to not be able to
>> modify them.
>>
>> pacemaker on the host won't try to start another instance on the same
>> host, it will try to start an instance on another host. so you don't need
>> to worry about releaseing memory, file locks, etc locally. for remote
>> resources you _can't_ release them gracefully if you crash, so your apps
>> already need to be able to handle that situation. there's no difference to
>> the other instances between a machine that gets powered off via STONITH
>> and a virtual system that gets paused.
>
>
> Can't pacemaker start another instance on the same host by configuration?

I don't think so. If you think about it from the pacemaker/heartbeat point 
of view (where they don't know anything about virtual servers, they just 
see them as applications) there are two choices to having a failed 
service.

1. issue a start command to try and bring it back up (as I note above, the 
OCFscript could be written to have this start a new copy instead of 
restarting the old copy)

2. decide that if applications are crashing there may be something 
wrong with the host and migrate services to another server


> Of course I agree that it may not be valuable in most situations.

a combination of this and the fact that this can be done so easily (and 
flexibly) with scripts in the existing tools makes me question the value 
of modifying the kernel.

David Lang
