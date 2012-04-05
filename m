Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754399Ab2DEPFZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 11:05:25 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:53035 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754486Ab2DEPFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 11:05:22 -0400
Date: Thu, 5 Apr 2012 17:05:16 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Kay Sievers <kay@vrfy.org>
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartmann <greg@kroah.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] printk: support structured and multi-facility log
 messages
Message-ID: <20120405150516.GA27223@gmail.com>
References: <1333569554.864.3.camel@mop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1333569554.864.3.camel@mop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Kay Sievers <kay@vrfy.org> wrote:

> From: Kay Sievers <kay@vrfy.org>
>
> Subject: printk: support structured and multi-facility log messages
> 
> Kernel log messages are the primary source of information about the overall
> state of the system and connected devices. Traditional kernel messages are
> mostly human language, targeted at a human reading them. This part of the
> picture works very well since a very long time.
> 
> However, most machines run unattended almost all of their time, and
> software, and not humans, need to process the kernel messages. Having
> a machine making sense out of human language messages is inefficient,
> unreliable, and sometimes plain impossible to get right. With human
> language messages all useful information about their context,
> available at the time of creation of the messages, is just thrown
> away. Later, software consumers of the messages will need to apply
> magic to reconstruct what the context might have been, to be able to
> interpret the messages.
> 
> This patch extends printk() to be able to attach arbitrary key/value
> pairs to logged messages, to carry machine-readable data which
> describes the context of the log message at time of its
> creation. Users of the log can retrieve, along with the human-readable
> message, a key/value dictionary to reliably identify specific devices,
> drivers, subsystems, classes and types of messages.
> 
> Various features of this patch:
> 
> - Record-based stream instead of the traditional byte stream
>   buffer. All records carry a 64 bit timestamp, the syslog facility
>   and priority in the record header.
> 
> - Records consume almost the same amount, sometimes less memory than
>   the traditional byte stream buffer (if printk_time is enabled). The record
>   header is 16 bytes long, plus some padding bytes at the end if needed.
>   The byte-stream buffer needed 3 chars for the syslog prefix, 15 char for
>   the timestamp and a newline.
> 
> - Buffer management is based on message sequence numbers. When records
>   need to be discarded, the reading heads move on to the next full
>   record. Unlike the byte-stream buffer, no old logged lines get
>   truncated or partly overwritten by new ones. Sequence numbers also
>   allow consumers of the log stream to get notified if any message in
>   the stream they are about to read gets discarded during the time
>   of reading.
> 
> - Better buffered IO support for KERN_CONT continuation lines, when printk()
>   is called multiple times for a single line. The use of KERN_CONT is now
>   mandatory to use continuation; a few places in the kernel need trivial fixes
>   here. The buffering could possibly be extended to per-cpu variables to allow
>   better thread-safety for multiple printk() invocations for a single line.
> 
> - Full-featured syslog facility value support. Different facilities
>   can tag their messages. All userspace-injected messages enforce a
>   facility value > 0 now, to be able to reliably distinguish them from
>   the kernel-generated messages. Independent subsystems like a
>   baseband processor running its own firmware, or a kernel-related
>   userspace process can use their own unique facility values. Multiple
>   independent log streams can co-exist that way in the same
>   buffer. All share the same global sequence number counter to ensure
>   proper ordering (and interleaving) and to allow the consumers of the
>   log to reliably correlate the events from different facilities.
> 
> - Output of dev_printk() is reliably machine-readable now. In addition
>   to the printed plain text message, it creates a log dictionary with the
>   following properties:
>     SUBSYSTEM=     - the driver-core subsytem name
>     DEVICE=
>       b12:8        - block dev_t
>       c127:3       - char dev_t
>       n8           - netdev ifindex
>       +sound:card0 - subsystem:devname
> 
> - Support for multiple concurrent readers of /dev/kmsg, with read(),
>   seek(), poll() support. Output of message sequence numbers, to allow
>   userspace log consumers to reliably reconnect and reconstruct their
>   state at any given time. After open("/dev/kmsg"), read() always
>   returns *all* buffered records. If only future messages should be
>   read, SEEK_END can be used. In case records get overwritten while
>   /dev/kmsg is held open, or records get faster overwritten than they
>   are read, the next read() will return -EPIPE and the current reading
>   position gets updated to the next available record. The passed
>   sequence numbers allow the log consumer to calculate the amount of
>   lost messages.
> 
>   $ cat /dev/kmsg
>   PRIORITY=5
>   SEQNUM=0
>   TIMESTAMP=0
>   MESSAGE=Linux version 3.4.0-rc1+ (kay@mop) (gcc version 4.7.0 20120315 ...
> 
>   ...
> 
>   PRIORITY=7
>   SEQNUM=268
>   TIMESTAMP=399682
>   MESSAGE=pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7] (ignored)
>   SUBSYSTEM=acpi
>   DEVICE=+acpi:PNP0A03:00
> 
>   ...
> 
>   SYSLOG_FACILITY=3
>   PRIORITY=6
>   SEQNUM=863
>   TIMESTAMP=2479024
>   MESSAGE=udevd[71]: starting version 182
> 
>   ...
> 
>   PRIORITY=6
>   SEQNUM=1012
>   TIMESTAMP=4069447
>   MESSAGE=usb 2-1.4: MAC-Address: 02:80:37:e6:12:00
>   SUBSYSTEM=usb
>   DEVICE=c189:130

Hm, this seems to be a conceptual duplication of the console 
tracepoint that include/trace/events/printk.h already offers.

Have you looked at using that and extending it with a new 
tracepoint and new fields (with log priority level) where 
needed?

If you use it via a perf fd then you'll have structured logging, 
a record formatted ring-buffer, multiple readers support, 
filtering support, etc. - and of course you'll have access to a 
lot more tracepoints as well, should the system logging facility 
decide to log MCE events, etc.

I.e. it will provide (vastly) more capabilities, it would be 
much more extensible - and the patch from you would shrink as 
well, drastically.

IMHO the last thing we need is Yet Another Logging Facility.

Thanks,

	Ingo
