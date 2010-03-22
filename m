Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755081Ab0CVQMy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 12:12:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49942 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752971Ab0CVQMw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 12:12:52 -0400
Message-ID: <4BA796DF.7090005@redhat.com>
Date: Mon, 22 Mar 2010 18:12:15 +0200
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
References: <20100321205531.GC30194@elte.hu> <4BA692C3.7010408@redhat.com> <20100321215455.GB13219@elte.hu> <4BA7187E.3050405@redhat.com> <20100322111411.GC3483@elte.hu> <4BA7629B.7020604@redhat.com> <20100322124428.GA12475@elte.hu> <4BA76810.4040609@redhat.com> <20100322143212.GE14201@elte.hu> <4BA7821C.7090900@codemonkey.ws> <20100322155505.GA18796@elte.hu>
In-Reply-To: <20100322155505.GA18796@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/2010 05:55 PM, Ingo Molnar wrote:
> * Anthony Liguori<anthony@codemonkey.ws>  wrote:
>
>    
>> [...]
>>
>> I've been trying very hard to turn this into a productive thread attempting
>> to capture your feedback and give clear suggestions about how you can solve
>> achieve your desired functionality.
>>      
> I'm glad that we are at this more productive stage. I'm still trying to
> achieve the very same technological capabilities that i expressed in the first
> few mails when i reviewed the 'perf kvm' patch that was submitted by Yanmin.
>    

No, you're not.  You're trying to fracture the qemu community with your 
tools/kvm proposal, you're explaining to me how I'm working on the wrong 
thing by concentrating on things that my employer needs rather than what 
you think kvm needs, and attaching various unsavoury labels to Anthony 
and myself.  Any wonder we aren't getting anything done?

If you can commit to a reasonable conversation we might be able to make 
progress.  Is this actually possible?

> The crux of the problem is very simple. To quote my earlier mail:
>
>   |
>   | - The inconvenience of having to type:
>   |      perf kvm --host --guest --guestkallsyms=/home/ymzhang/guest/kallsyms \
>   |               --guestmodules=/home/ymzhang/guest/modules top
>   |
>   |
>   |   is very obvious even with a single guest. Now multiply that by more guests ...
>   |
>
> For example we want 'perf kvm top' to do something useful by default: it
> should find the first guest running and it should report its profile.
>
> The tool shouldnt have to guess about where the guests are, what their
> namespaces is and how to talk to them. We also want easy symbolic access to
> guest, for example:
>
>    perf kvm -g OpenSuse-2 record sleep 1
>
> I.e.:
>
>   - Easy default reference to guest instances, and a way for tools to
>     reference them symbolically as well in the multi-guest case. Preferably
>     something trustable and kernel-provided - not some indirect information
>     like a PID file created by libvirt-manager or so.
>    

Usually 'layering violation' is trotted out at such suggestions.  I 
don't like using the term, because sometimes the layers are incorrect 
and need to be violated.  But it should be done explicitly, not as a 
shortcut for a minor feature (and profiling is a minor feature, most 
users will never use it, especially guest-from-host).

The fact is we have well defined layers today, kvm virtualizes the cpu 
and memory, qemu emulates devices for a single guest, libvirt manages 
guests.  We break this sometimes but there has to be a good reason.  So 
perf needs to talk to libvirt if it wants names.  Could be done via 
linking, or can be done using a pluging libvirt drops into perf.

>   - Guest-transparent VFS integration into the host, to recover symbols and
>     debug info in binaries, etc.
>
> There were a few responses to that but none really addressed those problems -
> they mostly tried to re-define the problem and suggested that i was wrong to
> want such capabilities and suggested various inferior approaches instead. See
> the thread for the details - i think i covered every technical suggestion that
> was made.
>    

You simply kept ignoring me when I said that if something can be kept 
out of the kernel without impacting performance, it should be.  I don't 
want emergency patches closing some security hole or oops in a kernel 
symbol server.

The usability argument is a red herring.  True, it takes time for things 
to trickle down to distributions and users.  Those who can't wait can 
download the code and compile, it isn't that difficult.

> So we are still at an impasse as far as i can see. If i overlooked some
> suggestion that addresses these problems then please let me know ...
>    

The impasse is mostly due to you insisting on doing everything your way, 
in the kernel, and disregarding how libvirt/qemu/kvm does things.  Learn 
the kvm ecosystem, you'll find it is quite easy to contribute code.

-- 
error compiling committee.c: too many arguments to function

