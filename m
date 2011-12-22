Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754532Ab1LVAgo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 19:36:44 -0500
Received: from db3ehsobe003.messaging.microsoft.com ([213.199.154.141]:18379
	"EHLO DB3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752477Ab1LVAgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 19:36:41 -0500
X-SpamScore: -11
X-BigFish: VPS-11(zzbb2dI9371I1432N98dKzz1202hzzz2fh668h839h93fh)
X-Forefront-Antispam-Report: CIP:160.33.98.74;KIP:(null);UIP:(null);IPV:NLI;H:mail7.fw-bc.sony.com;RD:mail7.fw-bc.sony.com;EFVD:NLI
X-FB-SS: 13,
Message-ID: <4EF27B85.9080801@am.sony.com>
Date: Wed, 21 Dec 2011 16:36:21 -0800
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: linux-embedded <linux-embedded@vger.kernel.org>,
        linux kernel <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, john stultz <johnstul@us.ibm.com>,
        Brian Swetland <swetland@google.com>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Lennart Poettering <lennart@poettering.net>
Subject: Re: RFC: android logger feedback request
References: <4EF264C3.6000104@am.sony.com> <20111221231956.GB23859@suse.de>
In-Reply-To: <20111221231956.GB23859@suse.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/21/2011 03:19 PM, Greg KH wrote:
> That all describes the current code, but you haven't described what's
> wrong with the existing syslog interface that requires this new driver
> to be written.  And why can't the existing interface be fixed to address
> these (potential) shortcomings?


>> One specific question I have is where is the most appropriate
>> place for this code to live, in the kernel source tree?
>> Other embedded systems might want to use this system (it
>> is simpler than syslog, and superior in some ways), so I don't
>> think it should remain in an android-specific directory.
> 
> What way is it superior?

Here are some ways that this code is superior to syslog:

Speed and overhead
------------------
syslogd requires a separate user-space process to manage
the log area, where this code does not.  The overhead
for any user-space process is at least 16K, and usually much
more than this (not including the size of the log storage
area).  On one of my embedded systems, where syslogd is
provided by busybox, the unique set size for syslogd
is 96K.  This code, built in to the Linux kernel is less
than 4K code and data (again, not including the size of
the log storage area).

To deliver a message to syslog requires a socket operation
and a few context switches.  With the logger code,
the operation is a file operation (writev) to kernel memory,
with only one context switch into and out of the kernel.

The open and write paths through the Linux kernel are
arguably more optimized than the networking paths.
This is a consideration since the log operations should
optimized for the "create-a-log-entry" case (the open/write
path), since logs are mostly written and almost never read
on production devices.

No dependence on persistent storage
-----------------------------------
syslogd requires either persistent storage to store the log,
or a network connection to an outside device.  Being
purely memory-based, the logger requires neither of these.
With logger, persistence of the log data is left to the
implementor.  In Android, the data is delivered over a USB
connection via adb or to the console as ascii text, using
logcat.  In other embedded systems, other mechanisms might
be used if long-term storage of the messages is desired.
With logger, there is no automatic notion of on-device
persistent storage for the log data.

No dependence on networking kernel code
---------------------------------------
The syslog communication mechanism requires sockets.  This
prevents one from configuring the kernel with no networking
support, which is sometimes done in embedded systems to save
size.

Simpler constraint on log size
------------------------------
The busybox syslog daemon uses a log rotation feature to constrain
the size of the log in persistent storage.  This is overly
cumbersome in both speed and complexity compared to the logger's
simple ring buffer.

Licensing
---------
The code implementing library and command line tool support
for this logger (in user space) is available under an Apache license,
rather than a GPL license, which is desirable for some vendors.

> Again, why not extend syslog?  Why not "fix"
> syslog if this really is a superior thing?

"extend" syslog would not really the the right
direction.  This system is simpler than syslog,
while simultaneously having at least one valuable
extra feature (separate log channels).

syslog has a standard set of interfaces in libc
and various syslogd implementations, which are
heavier weight in nature than what is provided here.
It is unclear that an attempt at reducing these attributes
(such as memory overhead, number of context switches,
dependence on persistent storage, and socket utilization) would
yield a system substantially different from the logger.

> How does this tie into Kay
> and Lennard's proposal for work in this area?

It does not tie in at all.

Kay and Lennart's proposal for "the Journal" creates
a more complex system than syslog, and handles a number
of new interesting use cases.  This system is on the
opposite side of the spectrum from the journal, towards
simplicity and reduced footprint and overhead.

 -- Tim

=============================
Tim Bird
Architecture Group Chair, CE Workgroup of the Linux Foundation
Senior Staff Engineer, Sony Network Entertainment
=============================

