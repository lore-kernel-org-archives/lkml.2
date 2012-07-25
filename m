Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932761Ab2GYIQ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 04:16:26 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:35596 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755304Ab2GYIQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 04:16:22 -0400
X-AuditID: b753bd60-954f5ba000004f2e-e8-500fab53866b
X-AuditID: b753bd60-954f5ba000004f2e-e8-500fab53866b
Message-ID: <500FAB33.4060301@hitachi.com>
Date: Wed, 25 Jul 2012 17:15:47 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Blue Swirl <blauwirbel@gmail.com>
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
Subject: Re: Re: [Qemu-devel] [RFC PATCH 0/6] virtio-trace: Support virtio-trace
References: <20120724023657.6600.52706.stgit@ltc189.sdl.hitachi.co.jp> <CAAu8pHsfRBsfSCB5gBFX5pweN2j2PdNrQZyCfjJ3sYYmVjCRfA@mail.gmail.com>
In-Reply-To: <CAAu8pHsfRBsfSCB5gBFX5pweN2j2PdNrQZyCfjJ3sYYmVjCRfA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/07/25 5:26), Blue Swirl wrote:>
>> The following patch set provides a low-overhead system for collecting kernel
>> tracing data of guests by a host in a virtualization environment.
>>
>> A guest OS generally shares some devices with other guests or a host, so
>> reasons of any problems occurring in a guest may be from other guests or a
>> host.
>> Then, to collect some tracing data of a number of guests and a host is needed
>> when some problems occur in a virtualization environment. One of methods to
>> realize that is to collect tracing data of guests in a host. To do this,
>> network
>> is generally used. However, high load will be taken to applications on guests
>> using network I/O because there are many network stack layers. Therefore,
>> a communication method for collecting the data without using network is
>> needed.
>
> I implemented something similar earlier by passing trace data from
> OpenBIOS to QEMU using the firmware configuration device. The data
> format was the same as QEMU used for simpletrace event structure
> instead of ftrace. I didn't commit it because of a few problems.

Sounds interesting :)
I guess you traced BIOS events, right?

> I'm not familiar with ftrace, is it possible to trace two guest
> applications (BIOS and kernel) at the same time?

Since ftrace itself is a tracing feature in the linux kernel, it
can trace two or more applications (processes) if those run on linux
kernel. However, I think OpenBIOS runs *under* the guest kernel.
If so, ftrace currently can't trace OpenBIOS from guest side.

I think it may need another enhancement on both OpenBIOS and linux
kernel to trace BIOS event from linux kernel.

> Or could this be
> handled by opening two different virtio-serial pipes, one for BIOS and
> the other for the kernel?

Of course, virtio-serial itself can open multiple channels, thus, if
OpenBIOS can handle virtio, it can pass trace data via another
channel.

> In my version, the tracepoint ID would have been used to demultiplex
> QEMU tracepoints from BIOS tracepoints, but something like separate ID
> spaces would have been better.

I guess your feature notifies events to QEMU and QEMU records that in
their own buffer. Therefore it must have different tracepoint IDs.
On the other hand, with this feature, QEMU just passes trace-data to
host-side pipe. Since outer tracing tool separately collects trace
data, we don't need to demultiplex the data.

Perhaps, in the analyzing phase (after tracing), we have to mix events
again. At that time, we'll add some guest-ID for each event-ID, but
it can be done offline.

Best Regards,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
