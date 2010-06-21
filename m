Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932725Ab0FUOTy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 10:19:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24463 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932388Ab0FUOTx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 10:19:53 -0400
Date: Mon, 21 Jun 2010 11:19:36 -0300
From: Luiz Capitulino <lcapitulino@redhat.com>
To: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
Cc: kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       mori.keisuke@oss.ntt.co.jp,
       Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>,
       Chris Wright <chrisw@redhat.com>, Dor Laor <dlaor@redhat.com>,
       Lon Hohberger <lhh@redhat.com>, "Perry N. Myers" <pmyers@redhat.com>,
       berrange@redhat.com
Subject: Re: [RFC] High availability in KVM
Message-ID: <20100621111936.7b7fafbf@redhat.com>
In-Reply-To: <4C199348.6050108@oss.ntt.co.jp>
References: <4C199348.6050108@oss.ntt.co.jp>
Organization: Red Hat
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jun 2010 12:15:20 +0900
Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp> wrote:

>   * qemu-kvm
> 
>   Currently KVM is only notified about memory errors detected by the
>   MCE subsystem. When running on newer x86 hardware, if MCE detects an
>   error on user-space it signals the corresponding process with
>   SIGBUS. Qemu, upon receiving the signal, checks the problematic
>   address which the kernel stored in siginfo and decides whether to
>   inject the MCE to the virtual machine.
> 
>   An obvious limitation is that we would like to be notified about
>   other types of error too and, as suggested before, a file-based
>   interface that can be sys_poll'ed might be needed for that.  
> 
>   On a different note, in a HA environment the qemu policy described
>   above is not adequate; when a notification of a hardware error that
>   our policy determines to be serious arrives the first thing we want
>   to do is to put the virtual machine in a quiesced state to avoid
>   further wreckage. If we injected the error into the guest we would
>   risk a guest panic that might detectable only by polling or, worse,
>   being killed by the kernel, which means that postmortem analysis of
>   the guest is not possible. Once we had the guests in a quiesced
>   state, where all the buffers have been flushed and the hardware
>   sources released, we would have two modes of operation that can be
>   used together and complement each other.
> 
>     - Proactive: A qmp event describing the error (severity, topology,
>       etc) is emitted. The HA software would have to register to
>       receive hardware error events, possibly using the libvirt
>       bindings. Upon receiving the event the HA software would know
>       that the guest is in a failover-safe quiesced state so it could
>       do without fencing and proceed to the failover stage directly.

This seems to match the BLOCK_IO_ERROR event we have today: when a disk error
happens, an event is emitted and the virtual machine can be automatically
stopped (there's a configuration option for this).

On the other hand, there's a number of ways to do this differently. I think
the first thing to do is to agree on what qemu's behavior is going to be, then
we decide how to expose this info to qmp clients.

>     - Passive: Polling resource agents that need to check the state of
>       the guest generally use libvirt or a wrapper such as virsh. When
>       the state is SHUTOFF or CRASHED the resource agent proceeds to
>       the facing stage, which might be expensive and usually involves
>       killing the qemu process. We propose adding a new state that
>       indicates the failover-safe state described before. In this
>       state the HA software would not need to use fencing techniques
>       and since the qemu process is not killed postmortem analysis of
>       the virtual machine is still possible.

It wouldn't be polling, I guess. We already have events for most state changes.
So, when the machine stops, reboots, etc.. the client would be notified and
then it could inspect the virtual machine by using query commands.

This method would be preferable in case we also want this information available
in the user Monitor and/or if the event gets too messy because of the amount of
information we want to put in it.
