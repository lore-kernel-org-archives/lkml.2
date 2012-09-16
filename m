Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752055Ab2IPQQI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 12:16:08 -0400
Received: from 50-56-35-84.static.cloud-ips.com ([50.56.35.84]:44947 "EHLO
	mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393Ab2IPQQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 12:16:06 -0400
Message-ID: <5055FB2A.1020103@hallyn.com>
Date: Sun, 16 Sep 2012 11:15:38 -0500
From: Serge Hallyn <serge@hallyn.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Aristeu Rozanski <aris@ruivo.org>,
        Neil Horman <nhorman@tuxdriver.com>,
        "Serge E. Hallyn" <serue@us.ibm.com>,
        containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Michal Hocko <mhocko@suse.cz>, Thomas Graf <tgraf@suug.ch>,
        Paul Mackerras <paulus@samba.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>,
        cgroups@vger.kernel.org, Paul Turner <pjt@google.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: Controlling devices and device namespaces
References: <20120913205827.GO7677@google.com> <20120914183641.GA2191@cathedrallabs.org> <20120915022037.GA6438@mail.hallyn.com> <87wqzv7i08.fsf_-_@xmission.com> <20120915220520.GA11364@mail.hallyn.com> <87y5kazuez.fsf@xmission.com> <20120916122112.3f16178d@pyramind.ukuu.org.uk> <87sjaiuqp5.fsf@xmission.com> <87d31mupp3.fsf@xmission.com> <5055D4D1.3070407@hallyn.com> <87k3vuqc5l.fsf@xmission.com>
In-Reply-To: <87k3vuqc5l.fsf@xmission.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/16/2012 09:23 AM, Eric W. Biederman wrote:
> Serge Hallyn <serge@hallyn.com> writes:
>
>> On 09/16/2012 07:17 AM, Eric W. Biederman wrote:
>>> ebiederm@xmission.com (Eric W. Biederman) writes:
>>>
>>>> Alan Cox <alan@lxorguk.ukuu.org.uk> writes:
>>>>
>>>>>> One piece of the puzzle is that we should be able to allow unprivileged
>>>>>> device node creation and access for any device on any filesystem
>>>>>> for which it unprivileged access is safe.
>>>>>
>>>>> Which devices are "safe" is policy for all interesting and useful cases,
>>>>> as are file permissions, security tags, chroot considerations and the
>>>>> like.
>>>>>
>>>>> It's a complete non starter.
>>>
>>> Come to think of it mknod is completely unnecessary.
>>>
>>> Without mknod.  Without being able to mount filesystems containing
>>> device nodes.
>>
>> Hm?  That sounds like it will really upset init/udev/upgrades in the
>> container.
>
> udev does not create device nodes.  For an older udev the worst
> I can see it doing is having mknod failing with EEXIST because
> the device node already exists.
>
> We should be able to make it look to init like a ramdisk mounted the
> filesystems.
>
> Why should upgrades care?  Package installation shouldn't be calling
> mknod.
>
> At least with a recent modern distro I can't imagine this to be an
> issue.  I expect we could have a kernel build option that removed the
> mknod system call and a modern distro wouldn't notice.
>
>> Are you saying all filesystems containing device nodes will need to be
>> mounted in advance by the process setting up the container?
>
> As a general rule.
>
> I think in practice there is wiggle room for special cases
> like mounting a fresh devpts.  devpts at least in always create a new
> instance on mount mode seems safe, as it can not give you access to
> any existing devices.
>
> You can also do a lot of what would normally be done with mknod
> with bind mounts to the original devices location.
>
>>> The mount namespace is sufficient to prevent all of the
>>> cases that the device control group prevents (open and mknod on device
>>> nodes).
>>>
>>> So I honestly think the device control group is superflous, and it is
>>> probably wise to deprecate it and move to a model where it does not
>>> exist.
>>>
>>> Eric
>>>
>>
>> That's what I said a few emails ago :)  The device cgroup was meant as
>> a short-term workaround for lack of user (and device) namespaces.
>
> I am saying something stronger.  The device cgroup doesn't seem to have
> a practical function now.

"Now" is wrong.  The user namespace is not complete and not yet usable 
for a full system container.  We still need the device control group.

I'd like us to have a sprint (either a day at UDS in person, or a few 
days with a virtual sprint) with the focus of getting a full system 
container working the way you envision it, as cleanly as possible.  I 
can take two or three consecutave days sometime in the next 2-3 weeks, 
we can sit on irc and share a few instances on which to experiment?

>  That for the general case we don't need any
> kernel support.  That all of this should be a matter of some user space
> glue code, and just the tiniest bit of sorting out how hotplug events are
> sent.
>
> The only thing I can think we would need a device namespace for is
> for migration.
 >
> For migration with direct access to real hardware devices we must treat
> it as hardware hotunplug.  There is nothing else we can do.
>
> If there is any other case where we need to preserve device numbers
> etc we have the example of devpts.
>
> So at this point I really don't think we need a device namespace or a
> device control group.  (Just emulate devtmpfs, sysfs and uevents).
>
> Eric
>

