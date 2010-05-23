Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755003Ab0EWSSm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 May 2010 14:18:42 -0400
Received: from lo.gmane.org ([80.91.229.12]:39061 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754761Ab0EWSSl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 May 2010 14:18:41 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
connect(): No such file or directory
From: walt <w41ter@gmail.com>
Subject: Re: [2.6.34-git8][regression] massive polling problems with udevd
 and  other processes
Date: Sun, 23 May 2010 11:18:22 -0700
Message-ID: <htbrhh$ia7$1@dough.gmane.org>
References: <201005221535.38939.shawn.starr@rogers.com>	 <4BF83CBF.8080300@gmail.com>	 <20100522204426.GO31073@ZenIV.linux.org.uk> <AANLkTimffWnIjHIEW54AoVxiALEoFkJZJJ7u57ZChDuy@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: adsl-69-234-193-222.dsl.irvnca.pacbell.net
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.3a5pre) Gecko/20100522 Thunderbird/3.2a1pre
In-Reply-To: <AANLkTimffWnIjHIEW54AoVxiALEoFkJZJJ7u57ZChDuy@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/22/2010 03:59 PM, Eric Paris wrote:
> On Sat, May 22, 2010 at 4:44 PM, Al Viro<viro@zeniv.linux.org.uk>  wrote:
>> On Sat, May 22, 2010 at 01:21:19PM -0700, walt wrote:
>>> On 05/22/2010 12:35 PM, Shawn Starr wrote:
>>>> Just built today's snapshot from linus's tree and have problems with udev
>>>> using 100% cpu and KDE processes also pegging cpus.
>>>>
>>>> This is with Fedora 13 + snapshot kernel from git.
>>>>
>>>> Anyone else noticing this?
>>>
>>> Yes, just bisected it to this:
>>>
>>> commit a7cf4145bb86aaf85d4d4d29a69b50b688e2e49d
>>> Author: Eric Paris<eparis@>
>>> Date:   Fri May 14 11:44:10 2010 -0400
>>>
>>>      anon_inode: set S_IFREG on the anon_inode
>>
>> Cute...  Frankly, I'd be fine with just reverting that one and teaching
>> selinux to STFU.  However, I wonder what specifically is getting polled.
>> Which anon_inode users?
>
> On my system udev has both inotify and signalfd open.  He's asking for
> more of the strace.  If the ONLY thing that udev is doing is polling
> with no other syscalls at all it's a udev problem (although maybe one
> where we have to maintain bug for bug compatibility.
>
> Can you show us a more lines of strace context and the output of ls -l
> /proc/$PID/fd ?  That should give us a better idea what udev is doing
> and which anon_inode we are dealing with.

strace is just very rapidly printing out thousands of identical lines like
the one I posted earlier.  Here is a new run:

$head /tmp/strace
ioctl(6, FIONREAD, [0])                 = 0
poll([{fd=4, events=POLLIN}, {fd=5, events=POLLIN}, {fd=6, events=POLLIN}, {fd=7, events=POLLIN}, {fd=8, events=POLLIN}], 5, -1) = 1 ([{fd=6, revents=POLLIN}])
ioctl(6, FIONREAD, [0])                 = 0
poll([{fd=4, events=POLLIN}, {fd=5, events=POLLIN}, {fd=6, events=POLLIN}, {fd=7, events=POLLIN}, {fd=8, events=POLLIN}], 5, -1) = 1 ([{fd=6, revents=POLLIN}])
ioctl(6, FIONREAD, [0])                 = 0
poll([{fd=4, events=POLLIN}, {fd=5, events=POLLIN}, {fd=6, events=POLLIN}, {fd=7, events=POLLIN}, {fd=8, events=POLLIN}], 5, -1) = 1 ([{fd=6, revents=POLLIN}])
ioctl(6, FIONREAD, [0])                 = 0
poll([{fd=4, events=POLLIN}, {fd=5, events=POLLIN}, {fd=6, events=POLLIN}, {fd=7, events=POLLIN}, {fd=8, events=POLLIN}], 5, -1) = 1 ([{fd=6, revents=POLLIN}])
ioctl(6, FIONREAD, [0])                 = 0
poll([{fd=4, events=POLLIN}, {fd=5, events=POLLIN}, {fd=6, events=POLLIN}, {fd=7, events=POLLIN}, {fd=8, events=POLLIN}], 5, -1) = 1 ([{fd=6, revents=POLLIN}])

Here is the fd listing for the udevd process:
$cat /tmp/fd
lrwx------ 1 root root 64 2010-05-23 08:38 0 -> /dev/null
lrwx------ 1 root root 64 2010-05-23 08:38 1 -> /dev/null
lrwx------ 1 root root 64 2010-05-23 08:38 2 -> /dev/null
lrwx------ 1 root root 64 2010-05-23 08:38 3 -> /dev/.udev/queue.bin
lrwx------ 1 root root 64 2010-05-23 08:38 4 -> socket:[274]
lrwx------ 1 root root 64 2010-05-23 08:38 5 -> socket:[275]
lr-x------ 1 root root 64 2010-05-23 08:38 6 -> anon_inode:inotify
lrwx------ 1 root root 64 2010-05-23 08:38 7 -> anon_inode:[signalfd]
lrwx------ 1 root root 64 2010-05-23 08:38 8 -> socket:[276]
lrwx------ 1 root root 64 2010-05-23 08:38 9 -> socket:[277]



