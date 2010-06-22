Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758788Ab0FVBjK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 21:39:10 -0400
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:53144 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752630Ab0FVBjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 21:39:08 -0400
Message-ID: <4C20153E.7000309@oss.ntt.co.jp>
Date: Tue, 22 Jun 2010 10:43:26 +0900
From: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Luiz Capitulino <lcapitulino@redhat.com>
CC: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>, kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       mori.keisuke@oss.ntt.co.jp, Chris Wright <chrisw@redhat.com>,
       Dor Laor <dlaor@redhat.com>, Lon Hohberger <lhh@redhat.com>,
       "Perry N. Myers" <pmyers@redhat.com>, berrange@redhat.com
Subject: Re: [RFC] High availability in KVM
References: <4C199348.6050108@oss.ntt.co.jp> <20100621111936.7b7fafbf@redhat.com>
In-Reply-To: <20100621111936.7b7fafbf@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2010/06/21 23:19), Luiz Capitulino wrote:
>>    On a different note, in a HA environment the qemu policy described
>>    above is not adequate; when a notification of a hardware error that
>>    our policy determines to be serious arrives the first thing we want
>>    to do is to put the virtual machine in a quiesced state to avoid
>>    further wreckage. If we injected the error into the guest we would
>>    risk a guest panic that might detectable only by polling or, worse,
>>    being killed by the kernel, which means that postmortem analysis of
>>    the guest is not possible. Once we had the guests in a quiesced
>>    state, where all the buffers have been flushed and the hardware
>>    sources released, we would have two modes of operation that can be
>>    used together and complement each other.
>>
>>      - Proactive: A qmp event describing the error (severity, topology,
>>        etc) is emitted. The HA software would have to register to
>>        receive hardware error events, possibly using the libvirt
>>        bindings. Upon receiving the event the HA software would know
>>        that the guest is in a failover-safe quiesced state so it could
>>        do without fencing and proceed to the failover stage directly.
>
> This seems to match the BLOCK_IO_ERROR event we have today: when a disk error
> happens, an event is emitted and the virtual machine can be automatically
> stopped (there's a configuration option for this).
>
> On the other hand, there's a number of ways to do this differently. I think
> the first thing to do is to agree on what qemu's behavior is going to be, then
> we decide how to expose this info to qmp clients.

I would like to support qemu/KVM bugs too in the same framework.

Even though there are some debugging ways, the easiest and most reliable one would
be using the frozen state of the guest at the moment the bug happened.


We've already experienced some qemu crashes which seemed to be caused by a KVM's
emulation failure in our test environment. Although we could guess what happened
by checking some messages like the exit reason, the guest state might have been
more help.

So what I want to get is:

  - new qemu/KVM mode in which guests are automatically stopped in a failover-safe
    state if qemu/KVM becomes impossible to continue,

  - new interface between qemu and HA to handle the failover-safe state,

Although I personally don't mind whether the interface is event based or polling
based, one important problem from the HA's point of view would be:

  * how to treat errors which can be caused in different layers uniformly.

E.g. if the problem is caused by guest side, qemu may normally exit without sending
any events to HA. So an interface for polling may be helpful even when we choose event
driven one.


     Takuya


>
>>      - Passive: Polling resource agents that need to check the state of
>>        the guest generally use libvirt or a wrapper such as virsh. When
>>        the state is SHUTOFF or CRASHED the resource agent proceeds to
>>        the facing stage, which might be expensive and usually involves
>>        killing the qemu process. We propose adding a new state that
>>        indicates the failover-safe state described before. In this
>>        state the HA software would not need to use fencing techniques
>>        and since the qemu process is not killed postmortem analysis of
>>        the virtual machine is still possible.
>
> It wouldn't be polling, I guess. We already have events for most state changes.
> So, when the machine stops, reboots, etc.. the client would be notified and
> then it could inspect the virtual machine by using query commands.
>
> This method would be preferable in case we also want this information available
> in the user Monitor and/or if the event gets too messy because of the amount of
> information we want to put in it.

