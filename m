Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755085Ab0CVQI4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 12:08:56 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:55781 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754798Ab0CVQIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 12:08:53 -0400
Message-ID: <4BA7960A.4020504@codemonkey.ws>
Date: Mon, 22 Mar 2010 11:08:42 -0500
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
References: <20100321205531.GC30194@elte.hu> <4BA692C3.7010408@redhat.com> <20100321215455.GB13219@elte.hu> <4BA7187E.3050405@redhat.com> <20100322111411.GC3483@elte.hu> <4BA7629B.7020604@redhat.com> <20100322124428.GA12475@elte.hu> <4BA76810.4040609@redhat.com> <20100322143212.GE14201@elte.hu> <4BA7821C.7090900@codemonkey.ws> <20100322155505.GA18796@elte.hu>
In-Reply-To: <20100322155505.GA18796@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/2010 10:55 AM, Ingo Molnar wrote:
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

Two things are needed.  The first thing needed is to be able to 
enumerate running guests and identify a symbolic name.  I have a patch 
for this and it'll be posted this week or so.  perf will need to have a 
QMP client and it will need to look in ${HOME}/.qemu/qmp/ to sockets to 
connect to.

This is too much to expect from a client and we've got a GSoC idea 
posted to make a nice library for tools to use to simplify this.

The sockets are named based on UUID and you'll have to connect to a 
guest and ask it for it's name.  Some guests don't have names so we'll 
have to come up with a clever way to describe a nameless VM.

> I.e.:
>
>   - Easy default reference to guest instances, and a way for tools to
>     reference them symbolically as well in the multi-guest case. Preferably
>     something trustable and kernel-provided - not some indirect information
>     like a PID file created by libvirt-manager or so.
>    

A guest is not a KVM concept.  It's a qemu concept so it needs to be 
something provided by qemu.  The other caveat is that you won't see 
guests created by libvirt because we're implementing this in terms of a 
default QMP device and libvirt will disable defaults.  This is desired 
behaviour.  libvirt wants to be in complete control and doesn't want a 
tool like perf interacting with a guest directly.

>   - Guest-transparent VFS integration into the host, to recover symbols and
>     debug info in binaries, etc.
>    

The way I'd like to see this implemented is a guest userspace daemon.  I 
think having the guest userspace daemon be something that can be updated 
by the host is reasonable.

In terms of exposing that on the host, my preferred approach is QMP.  
I'd be happy with a QMP command that is essentially, 
guest_fs_read(filename) and guest_fd_readdir(path).

If desired, one could implement a fuse filesystem that interacted with 
all local qemu instances to expose this on the host.  There's a lot of 
ugly things about fuse though so I think sticking to QMP is best 
(particularly with respect to root access of a fuse filesystem).

With just those couple things in place, perf should be able to do 
exactly what you want it to do.

Regards,

Anthony Liguroi

> There were a few responses to that but none really addressed those problems -
> they mostly tried to re-define the problem and suggested that i was wrong to
> want such capabilities and suggested various inferior approaches instead. See
> the thread for the details - i think i covered every technical suggestion that
> was made.
>
> So we are still at an impasse as far as i can see. If i overlooked some
> suggestion that addresses these problems then please let me know ...
>
> Thanks,
>
> 	Ingo
>    

