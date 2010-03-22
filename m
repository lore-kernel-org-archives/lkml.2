Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754816Ab0CVS2v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 14:28:51 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:46189 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754552Ab0CVS2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 14:28:49 -0400
Message-ID: <4BA7B6CB.9050304@codemonkey.ws>
Date: Mon, 22 Mar 2010 13:28:27 -0500
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Lightning/1.0pre Thunderbird/3.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Avi Kivity <avi@redhat.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
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
References: <20100321215455.GB13219@elte.hu> <4BA7187E.3050405@redhat.com> <20100322111411.GC3483@elte.hu> <4BA7629B.7020604@redhat.com> <20100322124428.GA12475@elte.hu> <4BA76810.4040609@redhat.com> <20100322143212.GE14201@elte.hu> <4BA7821C.7090900@codemonkey.ws> <20100322155505.GA18796@elte.hu> <4BA7960A.4020504@codemonkey.ws> <20100322165906.GA12546@elte.hu>
In-Reply-To: <20100322165906.GA12546@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/2010 11:59 AM, Ingo Molnar wrote:
>
> Ok, that sounds interesting! I'd rather see some raw mechanism that 'perf kvm'
> could use instead of having to require yet another library (which generally
> dampens adoption of a tool). So i think we can work from there.
>    

You can access the protocol directly if you don't want a library dependency.

> Btw., have you considered using Qemu's command name (task->comm[]) as the
> symbolic name? That way we could see the guest name in 'top' on the host - a
> nice touch.
>    

qemu-system-x86_64 -name Fedora,process=qemu-Fedora

Does exactly that.  We don't make this default based on the element of 
least surprise.  Many users expect to be able to do killall 
qemu-system-x86 and if we did this by default, that wouldn't work.

>> The sockets are named based on UUID and you'll have to connect to a guest
>> and ask it for it's name.  Some guests don't have names so we'll have to
>> come up with a clever way to describe a nameless VM.
>>      
> I think just exposing the UUID in that lazy case would be adequate? It creates
> pressure for VM launchers to use better symbolic names.
>    

Yup.

>>> I.e.:
>>>
>>>   - Easy default reference to guest instances, and a way for tools to
>>>     reference them symbolically as well in the multi-guest case. Preferably
>>>     something trustable and kernel-provided - not some indirect information
>>>     like a PID file created by libvirt-manager or so.
>>>        
>> A guest is not a KVM concept.  It's a qemu concept so it needs to be
>> something provided by qemu.  The other caveat is that you won't see guests
>> created by libvirt because we're implementing this in terms of a default QMP
>> device and libvirt will disable defaults.  This is desired behaviour.
>> libvirt wants to be in complete control and doesn't want a tool like perf
>> interacting with a guest directly.
>>      
> Hm, this sucks for multiple reasons. Firstly, perf isnt a tool that
> 'interacts', it's an observation tool: just like 'top' is an observation tool.
>
> We want to enable developers to see all activities on the system - regardless
> of who started the VM or who started the process. Imagine if we had a way to
> hide tasks to hide from 'top'. It would be rather awful.
>
> Secondly, it tells us that the concept is fragile if it doesnt automatically
> enumerate all guests, regardless of how they were created.
>    

Perf does interact with a guest though because it queries a guest to 
read it's file system.

I understand the point you're making though.  If instead of doing a pull 
interface where the host queries the guest for files, if the guest 
pushed a small set of files at startup which the host cached, then you 
could potentially unconditionally expose a "read-only" socket that only 
exposed limited information.

> Full system enumeration is generally best left to the kernel, as it can offer
> coherent access.
>    

I don't see why qemu can't offer coherent access.  The limitation today 
is intentional and if it's overly restrictive, we can figure out a means 
to change it.

Regards,

Anthony Liguori


> 	Ingo
>    

