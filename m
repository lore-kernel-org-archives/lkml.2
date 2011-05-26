Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757216Ab1EZLDm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 07:03:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39621 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756788Ab1EZLDk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 07:03:40 -0400
Message-ID: <4DDE333D.6020608@redhat.com>
Date: Thu, 26 May 2011 14:02:21 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: James Morris <jmorris@namei.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kees Cook <kees.cook@canonical.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Will Drewry <wad@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        gnatapov@redhat.com, Chris Wright <chrisw@sous-sol.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH 3/5] v2 seccomp_filters: Enable ftrace-based system call
 filtering
References: <20110524195435.GC27634@elte.hu> <alpine.LFD.2.02.1105242239230.3078@ionos> <20110525150153.GE29179@elte.hu> <alpine.LFD.2.02.1105251836030.3078@ionos> <20110525180100.GY19633@outflux.net> <BANLkTimiLvtyKJe-+Fd+4N_rGLfYdUvSVA@mail.gmail.com> <alpine.LRH.2.00.1105261034200.29690@tundra.namei.org> <20110526082451.GB26775@elte.hu> <4DDE1419.3000708@redhat.com> <20110526093040.GB19536@elte.hu> <20110526094806.GC19536@elte.hu>
In-Reply-To: <20110526094806.GC19536@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/26/2011 12:48 PM, Ingo Molnar wrote:
> * Ingo Molnar<mingo@elte.hu>  wrote:
>
> >  You are missing the geniality of the tools/kvm/ thread pool! :-)
> >
> >  It could be switched to a worker *process* model rather easily.
> >  Guest RAM and (a limited amount of) global resources would be
> >  shared via mmap(SHARED), but otherwise each worker process would
> >  have its own stack, its own subsystem-specific state, etc.
>
> We get VM exit events in the vcpu threads which after minimal
> processing pass much of the work to the thread pool. Most of the
> virtio work (which could be a source of vulnerability - ringbuffers
> are hard) is done in the worker task context.
>
> It would be possible to further increase isolation there by also
> passing the IO/MMIO decoding to the worker thread - but i'm not sure
> that's truly needed. Most of the risk is where most of the code is -
> and the code is in the worker task which interprets on-disk data,
> protocols, etc.

I've suggested in the past to add an "mmiofd" facility to kvm, similar 
to ioeventfd.  This is how it would work:

- userspace configures kvm with an mmio range and a pipe
- guest writes to that range write a packet to the pipe describing the write
- guest reads from that range write a packet to the pipe describing the 
read, then wait for a reply packet with the result

The advantages would be
- avoid heavyweight exit; kvm can simply wake up a thread on another 
core and resume processing
- writes can be pipelined, similar to how PCI writes are posted
- supports process separation

So far no one has posted an implementation but it should be pretty simple.

> So we could not only isolate devices from each other, but we could
> also protect the highly capable vcpu fd from exploits in devices -
> worker threads generally do not need access to the vcpu fd IIRC.

Yes.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

