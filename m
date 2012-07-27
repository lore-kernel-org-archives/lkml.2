Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751979Ab2G0IzJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 04:55:09 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:49291 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751200Ab2G0IzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 04:55:06 -0400
X-AuditID: b753bd60-a1c87ba000000655-5b-501257636ec0
X-AuditID: b753bd60-a1c87ba000000655-5b-501257636ec0
Message-ID: <5012576F.7040500@hitachi.com>
Date: Fri, 27 Jul 2012 17:55:11 +0900
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120604 Thunderbird/13.0
MIME-Version: 1.0
To: Amit Shah <amit.shah@redhat.com>
Cc: linux-kernel@vger.kernel.org, Herbert Xu <herbert@gondor.hengli.com.au>,
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
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: Re: Re: [RFC PATCH 0/6] virtio-trace: Support virtio-trace
References: <20120724023657.6600.52706.stgit@ltc189.sdl.hitachi.co.jp> <20120726113537.GH9473@amit.redhat.com>
In-Reply-To: <20120726113537.GH9473@amit.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Amit,

Thank you for commenting on our work.

(2012/07/26 20:35), Amit Shah wrote:
> On (Tue) 24 Jul 2012 [11:36:57], Yoshihiro YUNOMAE wrote:

[...]

>>
>> Therefore, we propose a new system "virtio-trace", which uses enhanced
>> virtio-serial and existing ring-buffer of ftrace, for collecting guest kernel
>> tracing data. In this system, there are 5 main components:
>>   (1) Ring-buffer of ftrace in a guest
>>       - When trace agent reads ring-buffer, a page is removed from ring-buffer.
>>   (2) Trace agent in the guest
>>       - Splice the page of ring-buffer to read_pipe using splice() without
>>         memory copying. Then, the page is spliced from write_pipe to virtio
>>         without memory copying.
>
> I really like the splicing idea.

Thanks. We will improve this patch set.

>>   (3) Virtio-console driver in the guest
>>       - Pass the page to virtio-ring
>>   (4) Virtio-serial bus in QEMU
>>       - Copy the page to kernel pipe
>>   (5) Reader in the host
>>       - Read guest tracing data via FIFO(named pipe)
>
> So will this be useful only if guest and host run the same kernel?
>
> I'd like to see the host kernel not being used at all -- collect all
> relevant info from the guest and send it out to qemu, where it can be
> consumed directly by apps driving the tracing.

No, this patch set is used only for guest kernels, so guest and host
don't need to run the same kernel.

>> ***Evaluation***
>> When a host collects tracing data of a guest, the performance of using
>> virtio-trace is compared with that of using native(just running ftrace),
>> IVRing, and virtio-serial(normal method of read/write).
>
> Why is tracing performance-sensitive?  i.e. why try to optimise this
> at all?

To minimize effects for applications on guests when a host collects
tracing data of guests.
For example, we assume the situation where guests A and B are running
on a host sharing I/O device. An I/O delay problem occur in guest A,
but it doesn't for the requirement in guest B. In this case, we need to
collect tracing data of guests A and B, but a usual method using
network takes high load for applications of guest B even if guest B is
normally running. Therefore, we try to decrease the load on guests.
We also use this feature for performance analysis on production
virtualization systems.

[...]

>>
>> ***Just enhancement ideas***
>>   - Support for trace-cmd
>>   - Support for 9pfs protocol
>>   - Support for non-blocking mode in QEMU
>
> There were patches long back (by me) to make chardevs non-blocking but
> they didn't make it upstream.  Fedora carries them, if you want to try
> out.  Though we want to converge on a reasonable solution that's
> acceptable upstream as well.  Just that no one's working on it
> currently.  Any help here will be appreciated.

Thanks! In this case, since a guest will stop to run when host reads
trace data of the guest, char device is needed to add a non-blocking
mode. I'll read your patch series. Is the latest version 8?
http://lists.gnu.org/archive/html/qemu-devel/2010-12/msg00035.html

>>   - Make "vhost-serial"
>
> I need to understand a) why it's perf-critical, and b) why should the
> host be involved at all, to comment on these.

a) To make collecting overhead decrease for application on a guest.
    (see above)
b) Trace data of host kernel is not involved even if we introduce this
    patch set.

Thank you,

-- 
Yoshihiro YUNOMAE
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: yoshihiro.yunomae.ez@hitachi.com


