Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754899Ab1LVExi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 23:53:38 -0500
Received: from mail.lang.hm ([64.81.33.126]:42362 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751097Ab1LVExe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 23:53:34 -0500
Date: Wed, 21 Dec 2011 20:42:43 -0800 (PST)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Tim Bird <tim.bird@am.sony.com>
cc: Greg KH <gregkh@suse.de>, linux-embedded <linux-embedded@vger.kernel.org>,
        linux kernel <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, john stultz <johnstul@us.ibm.com>,
        Brian Swetland <swetland@google.com>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Lennart Poettering <lennart@poettering.net>
Subject: Re: RFC: android logger feedback request
In-Reply-To: <4EF27B85.9080801@am.sony.com>
Message-ID: <alpine.DEB.2.02.1112212027540.28597@asgard.lang.hm>
References: <4EF264C3.6000104@am.sony.com> <20111221231956.GB23859@suse.de> <4EF27B85.9080801@am.sony.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Dec 2011, Tim Bird wrote:

> On 12/21/2011 03:19 PM, Greg KH wrote:
>> That all describes the current code, but you haven't described what's
>> wrong with the existing syslog interface that requires this new driver
>> to be written.  And why can't the existing interface be fixed to address
>> these (potential) shortcomings?
>
>
>>> One specific question I have is where is the most appropriate
>>> place for this code to live, in the kernel source tree?
>>> Other embedded systems might want to use this system (it
>>> is simpler than syslog, and superior in some ways), so I don't
>>> think it should remain in an android-specific directory.
>>
>> What way is it superior?
>
> Here are some ways that this code is superior to syslog:
>
> Speed and overhead
> ------------------
> syslogd requires a separate user-space process to manage
> the log area, where this code does not.  The overhead
> for any user-space process is at least 16K, and usually much
> more than this (not including the size of the log storage
> area).  On one of my embedded systems, where syslogd is
> provided by busybox, the unique set size for syslogd
> is 96K.  This code, built in to the Linux kernel is less
> than 4K code and data (again, not including the size of
> the log storage area).
>
> To deliver a message to syslog requires a socket operation
> and a few context switches.  With the logger code,
> the operation is a file operation (writev) to kernel memory,
> with only one context switch into and out of the kernel.
>
> The open and write paths through the Linux kernel are
> arguably more optimized than the networking paths.
> This is a consideration since the log operations should
> optimized for the "create-a-log-entry" case (the open/write
> path), since logs are mostly written and almost never read
> on production devices.

comparing this to a userspace syslog daemon, you are correct that doing 
things in the kernel is slightly faster, but just because putting 
something in the kernel may be faster, doesn't mean that it belongs there 
(the tux webserver anyone??). How much faster, and is this something that 
actually matters? it doens't matter if something is 1000x faster if it's 
only called infrequently. what rate of log messages do you expect to 
support (and note that userspace syslog daemons can handle up to a 
million logs/sec, on the right hardware)

> No dependence on persistent storage
> -----------------------------------
> syslogd requires either persistent storage to store the log,
> or a network connection to an outside device.  Being
> purely memory-based, the logger requires neither of these.
> With logger, persistence of the log data is left to the
> implementor.  In Android, the data is delivered over a USB
> connection via adb or to the console as ascii text, using
> logcat.  In other embedded systems, other mechanisms might
> be used if long-term storage of the messages is desired.
> With logger, there is no automatic notion of on-device
> persistent storage for the log data.
>
> No dependence on networking kernel code
> ---------------------------------------
> The syslog communication mechanism requires sockets.  This
> prevents one from configuring the kernel with no networking
> support, which is sometimes done in embedded systems to save
> size.
>
> Simpler constraint on log size
> ------------------------------
> The busybox syslog daemon uses a log rotation feature to constrain
> the size of the log in persistent storage.  This is overly
> cumbersome in both speed and complexity compared to the logger's
> simple ring buffer.
>
> Licensing
> ---------
> The code implementing library and command line tool support
> for this logger (in user space) is available under an Apache license,
> rather than a GPL license, which is desirable for some vendors.

All of these issues are only true if you consider the existing syslog 
daemones, but it sounds like it would be pretty trivial to write a new 
syslog daemon (or hack up a BSD licensed one) to listen on multiple 
sockets (which most of the existing syslgo daemond can do already), assign 
a priority to each different socket, and then keep the logs in it's own 
buffer, with an api to retrieve them.

it wouldn't be quite as small or as fast as doing it in the kernel, but it 
would not be large, and I have trouble believing that it would be slow 
enough to notice.

>> Again, why not extend syslog?  Why not "fix"
>> syslog if this really is a superior thing?
>
> "extend" syslog would not really the the right
> direction.  This system is simpler than syslog,
> while simultaneously having at least one valuable
> extra feature (separate log channels).
>
> syslog has a standard set of interfaces in libc
> and various syslogd implementations, which are
> heavier weight in nature than what is provided here.
> It is unclear that an attempt at reducing these attributes
> (such as memory overhead, number of context switches,
> dependence on persistent storage, and socket utilization) would
> yield a system substantially different from the logger.

I once saw a company spend 6 months of developer effort optimizing a 
readof a config file (at the start it took 30 seconds to read the config 
100,000 times at the end it to .5 seconds), this was a great speedup, 
until you looked at the numbers and realized that across 50 servers this 
function was called 50,000 times in an hour (configs for cgis), so this 6 
month development effort saved 15 sec of cpu time in a peak hour, spread 
across 50 machines. In other words a waste of time and diversion of 
resources that could have been far better employed fixing bigger issues.

I suspect that logging is in the same category, it just doesn't happen 
enough for the performance difference to really matter.

making this be a 'standard' syslog(3) interface, or even a very close 
cousin to it (if you want apps to be able to dump raw strings to it rather 
than formatted data for example) would not hurt the pure android on a 
low-end phone noticably, but would make it much easier for android on a 
high-end device (tablets, netbooks, etc) to plug in a full blown syslog 
daemon that could save the logs to disk, or to send them over the network, 
etc. these things are very useful to have and much easier to do in 
userspace than in the kernel.

David Lang
