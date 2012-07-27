Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752333Ab2G0S7N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 14:59:13 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:35744 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236Ab2G0S7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 14:59:10 -0400
MIME-Version: 1.0
In-Reply-To: <500FAB33.4060301@hitachi.com>
References: <20120724023657.6600.52706.stgit@ltc189.sdl.hitachi.co.jp>
 <CAAu8pHsfRBsfSCB5gBFX5pweN2j2PdNrQZyCfjJ3sYYmVjCRfA@mail.gmail.com> <500FAB33.4060301@hitachi.com>
From: Blue Swirl <blauwirbel@gmail.com>
Date: Fri, 27 Jul 2012 18:58:48 +0000
Message-ID: <CAAu8pHsUkk8i_KVJNZtQJ8EaeiVWVt80_rV+p-sVstrmQ_j5dw@mail.gmail.com>
Subject: Re: Re: [Qemu-devel] [RFC PATCH 0/6] virtio-trace: Support virtio-trace
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>,
        linux-kernel@vger.kernel.org,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        yrl.pp-manager.tt@hitachi.com, qemu-devel@nongnu.org,
        Borislav Petkov <bp@amd64.org>,
        virtualization@lists.linux-foundation.org,
        "Franch Ch. Eigler" <fche@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Anthony Liguori <anthony@codemonkey.ws>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Amit Shah <amit.shah@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 25, 2012 at 8:15 AM, Masami Hiramatsu
<masami.hiramatsu.pt@hitachi.com> wrote:
> (2012/07/25 5:26), Blue Swirl wrote:>
>>> The following patch set provides a low-overhead system for collecting kernel
>>> tracing data of guests by a host in a virtualization environment.
>>>
>>> A guest OS generally shares some devices with other guests or a host, so
>>> reasons of any problems occurring in a guest may be from other guests or a
>>> host.
>>> Then, to collect some tracing data of a number of guests and a host is needed
>>> when some problems occur in a virtualization environment. One of methods to
>>> realize that is to collect tracing data of guests in a host. To do this,
>>> network
>>> is generally used. However, high load will be taken to applications on guests
>>> using network I/O because there are many network stack layers. Therefore,
>>> a communication method for collecting the data without using network is
>>> needed.
>>
>> I implemented something similar earlier by passing trace data from
>> OpenBIOS to QEMU using the firmware configuration device. The data
>> format was the same as QEMU used for simpletrace event structure
>> instead of ftrace. I didn't commit it because of a few problems.
>
> Sounds interesting :)
> I guess you traced BIOS events, right?

Yes, I converted a few DPRINTFs to tracepoints as a proof of concept.

>
>> I'm not familiar with ftrace, is it possible to trace two guest
>> applications (BIOS and kernel) at the same time?
>
> Since ftrace itself is a tracing feature in the linux kernel, it
> can trace two or more applications (processes) if those run on linux
> kernel. However, I think OpenBIOS runs *under* the guest kernel.
> If so, ftrace currently can't trace OpenBIOS from guest side.

No, OpenBIOS boots the machine and then passes control to boot loader
and that to kernel. The kernel will make a few calls to OpenBIOS at
start but not later. OpenBIOS is used by QEMU as Sparc and PowerPC
BIOS.

>
> I think it may need another enhancement on both OpenBIOS and linux
> kernel to trace BIOS event from linux kernel.
>

Ideally both OpenBIOS and Linux should be able to feed trace events
back to QEMU independently.

>> Or could this be
>> handled by opening two different virtio-serial pipes, one for BIOS and
>> the other for the kernel?
>
> Of course, virtio-serial itself can open multiple channels, thus, if
> OpenBIOS can handle virtio, it can pass trace data via another
> channel.

Currently OpenBIOS probes the PCI bus and identifies virtio devices
but ignores them, adding virtio-serial support shouldn't be too hard.
There's a time window between CPU boot and PCI probe when the the
device will not be available though.

>
>> In my version, the tracepoint ID would have been used to demultiplex
>> QEMU tracepoints from BIOS tracepoints, but something like separate ID
>> spaces would have been better.
>
> I guess your feature notifies events to QEMU and QEMU records that in
> their own buffer. Therefore it must have different tracepoint IDs.
> On the other hand, with this feature, QEMU just passes trace-data to
> host-side pipe. Since outer tracing tool separately collects trace
> data, we don't need to demultiplex the data.
>
> Perhaps, in the analyzing phase (after tracing), we have to mix events
> again. At that time, we'll add some guest-ID for each event-ID, but
> it can be done offline.

Yes, the multiplexing/demultiplexing is only needed in my version
because the feeds are not independent.

>
> Best Regards,
>
> --
> Masami HIRAMATSU
> Software Platform Research Dept. Linux Technology Center
> Hitachi, Ltd., Yokohama Research Laboratory
> E-mail: masami.hiramatsu.pt@hitachi.com
