Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755562Ab0CVR5n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 13:57:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53262 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755387Ab0CVR5l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 13:57:41 -0400
Message-ID: <4BA7AF2D.7060306@redhat.com>
Date: Mon, 22 Mar 2010 19:55:57 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Anthony Liguori <anthony@codemonkey.ws>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       oerg Roedel <joro@8bytes.org>, Jes Sorensen <Jes.Sorensen@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
       ziteng.huang@intel.com, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>,
       Gregory Haskins <ghaskins@novell.com>
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single
 project
References: <20100322111411.GC3483@elte.hu> <4BA7629B.7020604@redhat.com> <20100322124428.GA12475@elte.hu> <4BA76810.4040609@redhat.com> <20100322143212.GE14201@elte.hu> <4BA7821C.7090900@codemonkey.ws> <20100322155505.GA18796@elte.hu> <4BA796DF.7090005@redhat.com> <20100322165107.GD18796@elte.hu> <4BA7A406.9050203@redhat.com> <20100322173400.GB15795@elte.hu>
In-Reply-To: <20100322173400.GB15795@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/2010 07:34 PM, Ingo Molnar wrote:
>
>> The 'something trustable and kernel-provided'.  The kernel knows nothing
>> about guest names.
>>      
> The kernel certainly knows about other resources such as task names or network
> interface names or tracepoint names. This is kernel design 101.
>    

But it doesn't know about guest names.  You can't trust task names since 
any user can create a task with any name.  Network interfaces are root 
only so you can trust their names.

There are dozens or even hundreds of object classes the kernel does not 
know about and cannot enumerate.  User names, for instance. X sessions.  
Windows (the screen artifact, not the OS).  CIFS shares exported by this 
machine.  Currently running applications (not processes).

btw, network interfaces would have been much better of using 
/dev/netif/name rather than having their own namespace, IMO, like disks.


>>>> [...]  I don't like using the term, because sometimes the layers are
>>>> incorrect and need to be violated.  But it should be done explicitly, not
>>>> as a shortcut for a minor feature (and profiling is a minor feature, most
>>>> users will never use it, especially guest-from-host).
>>>>
>>>> The fact is we have well defined layers today, kvm virtualizes the cpu
>>>> and memory, qemu emulates devices for a single guest, libvirt manages
>>>> guests. We break this sometimes but there has to be a good reason.  So
>>>> perf needs to talk to libvirt if it wants names.  Could be done via
>>>> linking, or can be done using a pluging libvirt drops into perf.
>>>>          
> This is really just the much-discredited microkernel approach for keeping
> global enumeration data that should be kept by the kernel ...
>    

I disagree it should be kept in the kernel.  Why introduce a new 
namespace, with APIs to query it, manage it, rules regarding conflicts, 
then virtualize it for containers.

> Lets look at the ${HOME}/.qemu/qmp/ enumeration method suggested by Anthony.
> There's numerous ways that this can break:
>    

I don't like it either.  We have libvirt for enumerating guests.

>   - Those special files can get corrupted, mis-setup, get out of sync, or can
>     be hard to discover.
>
>   - The ${HOME}/.qemu/qmp/ solution suggested by Anthony has a very obvious
>     design flaw: it is per user. When i'm root i'd like to query _all_ current
>     guest images, not just the ones started by root. A system might not even
>     have a notion of '${HOME}'.
>
>   - Apps might start KVM vcpu instances without adhering to the
>     ${HOME}/.qemu/qmp/ access method.
>    

- it doesn't work with nfs.

>   - There is no guarantee for the Qemu process to reply to a request - while
>     the kernel can always guarantee an enumeration result. I dont want 'perf
>     kvm' to hang or misbehave just because Qemu has hung.
>    

If qemu doesn't reply, your guest is dead anyway.

> Really, for such reasons user-space is pretty poor at doing system-wide
> enumeration and resource management. Microkernels lost for a reason.
>    

Take a look at your desktop, userspace is doing all of that everywhere, 
from enumerating users and groups, to deciding how your disks are 
named.  The kernel only provides the bare facilities.

> You are committing several grave design mistakes here.
>    

I am committing on the shoulders of giants.

-- 
error compiling committee.c: too many arguments to function

