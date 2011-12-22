Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754828Ab1LVCeM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 21:34:12 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:35896 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754623Ab1LVCeK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 21:34:10 -0500
MIME-Version: 1.0
In-Reply-To: <20111222122026.3a0fae36@notabene.brown>
References: <4EF264C3.6000104@am.sony.com>
	<20111221231956.GB23859@suse.de>
	<4EF27B85.9080801@am.sony.com>
	<20111222122026.3a0fae36@notabene.brown>
Date: Wed, 21 Dec 2011 18:34:08 -0800
Message-ID: <CANqkERC+mdSGxk4tiU7+dbauSXqqANN+Z+TTb_pVXoPq+k=rJg@mail.gmail.com>
Subject: Re: RFC: android logger feedback request
From: Brian Swetland <swetland@google.com>
To: NeilBrown <neilb@suse.de>
Cc: Tim Bird <tim.bird@am.sony.com>, Greg KH <gregkh@suse.de>,
        linux-embedded <linux-embedded@vger.kernel.org>,
        linux kernel <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, john stultz <johnstul@us.ibm.com>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Lennart Poettering <lennart@poettering.net>
X-System-Of-Record: true
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 21, 2011 at 5:20 PM, NeilBrown <neilb@suse.de> wrote:
> On Wed, 21 Dec 2011 16:36:21 -0800 Tim Bird <tim.bird@am.sony.com> wrote:
>
>> On 12/21/2011 03:19 PM, Greg KH wrote:
>> > That all describes the current code, but you haven't described what's
>> > wrong with the existing syslog interface that requires this new driver
>> > to be written.  And why can't the existing interface be fixed to address
>> > these (potential) shortcomings?
>>
>> >> One specific question I have is where is the most appropriate
>> >> place for this code to live, in the kernel source tree?
>> >> Other embedded systems might want to use this system (it
>> >> is simpler than syslog, and superior in some ways), so I don't
>> >> think it should remain in an android-specific directory.
>> >
>> > What way is it superior?
>>
>> Here are some ways that this code is superior to syslog:
>
> It is certainly nice and simple.  It really looks more like a filesystem than
> a char device though...  though they aren't really files so much as lossy
> pipes.  I don't think that's a problem though, lots of things in filesystems
> don't behave exactly like files.
>
> If you created a 'logbuf' filesystem that used libfs to provide a single
> directory in which privileged processes could create files then you wouldn't
> need the kernel to "know" the allowed logs: radio, events, main, system.
> The size could be set by ftruncate() (by privileged used again) rather than
> being hardcoded.
>
> You would defined 'read' and 'write' much like you currently do to create a list of
> datagrams in a circular buffer and replace the ioctls by more standard
> interfaces:
>
> LOGGER_GET_LOG_BUG_SIZE would use 'stat' and the st_blocks field
> LOGGER_GET_LOG_LEN would use 'stat' and the st_size field
> LOGGER_GET_NEXT_ENTRY_LEN could use the FIONREAD ioctl
> LOGGER_FLUSH_LOG could use ftruncate
>
> The result would be much the same amount of code, but an interface which has
> fewer details hard-coded and is generally more versatile and accessible.

Moving away from hard coding the names/sizes of the logs in the driver
is something that has been on the todo list for a while.  One thing
we'd likely want to accomplish there is avoid creating a vector for
consuming large amounts of memory by creating new logs.

One planned change (likely to happen in the Android J release
timeframe) is to adjust permissions such that any process can write
messages, but unless they belong to the correct group they can only
read back messages written by their own PID.  This is to allow apps to
grab their own log output after a crash or during a user problem
report without needing to grant them the ability to read all log
messages.

Currently the logger driver does not provide a mechanism for allowing
logs to survive a reboot (unlike the ramconsole), but this is
functionality that we've thought about adding.  Generally the kernel
logs are most interesting after an unexpected panic/reboot, but
getting a picture of what userspace has been up to can be useful too.

The goals behind the logger driver have been:
- keep userland and kernel logging separate (so that spammy userland
logging doesn't make us lose critical kernel logs or the other way
round)
- make log writing very inexpensive -- avoid having to pass messages
between processes (more critical on ARM9 platforms where this implied
extra cache flushing), avoid having to make several syscalls to write
a log message (getting time of day, etc), and so on
- make log writing reliable -- don't trust userland to report its
timestamp, PID, or to correctly format the datagrams, etc
- allow a log watching process (logcat) to easily pull data from all
logs at once
- avoid committing a vast amount of memory to logging
- try to prevent clients from spamming each other out of log space
(only successful on a coarse granularity right now with the
main/system/radio/events logs)
- ensure logs are not lost at the moment an app crashes

On one hand, having each app (per PID) be able to create their own
logs up to a specified size limit could be really useful and is
something we've kicked around -- for one it would allow us to avoid
the ever present request from userspace developers to increase the log
size because of too much log spam ("reduce log spam" never seems to be
an answer that makes them happy) -- but we haven't come up with a
reasonable plan for dealing with "well if we allow 16KB of log per app
and the user installs 100 apps, they may be pinning up to 1.6MB of ram
worst case", and so on.

Brian
