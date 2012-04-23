Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753857Ab2DWMFG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 08:05:06 -0400
Received: from mail.windriver.com ([147.11.1.11]:40366 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752335Ab2DWMFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 08:05:04 -0400
Message-ID: <4F95455F.2040602@windriver.com>
Date: Mon, 23 Apr 2012 07:04:47 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
CC: <linux-kernel@vger.kernel.org>, <mingo@redhat.com>,
        <rusty@rustcorp.com.au>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        <yrl.pp-manager.tt@hitachi.com>
Subject: Re: [RFC PATCH 0/8] backtrace/oops with source/line information
References: <1334957394-12086-1-git-send-email-jason.wessel@windriver.com> <4F9540A0.6090805@hitachi.com>
In-Reply-To: <4F9540A0.6090805@hitachi.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/2012 06:44 AM, Masami Hiramatsu wrote:
> (2012/04/21 6:29), Jason Wessel wrote:
>> Call to panic() with the patch set
>> ----------------------------------
>> Call Trace:
>> [<ffffffff815f3003>] panic+0xbd/0x14 panic.c:111
>> [<ffffffff815f31f4>] ? printk+0x68/0xd printk.c:765
>> [<ffffffffa0000175>] panic_write+0x25/0x30 [test_panic] test_panic.c:189
>> [<ffffffff8118aa96>] proc_file_write+0x76/0x21 generic.c:226
>> [<ffffffff8118aa20>] ? __proc_create+0x130/0x21 generic.c:211
>> [<ffffffff81185678>] proc_reg_write+0x88/0x21 inode.c:218
>> [<ffffffff81125718>] vfs_write+0xc8/0x20 read_write.c:435
>> [<ffffffff811258d1>] sys_write+0x51/0x19 read_write.c:457
>> [<ffffffff815f84d9>] ia32_do_call+0x13/0xc ia32entry.S:427
>
>
> This can be also useful for kprobes, users can put new events on the
> specified lines not address! Ofcourse, I'd like to use this interface
> for the disassembler patch too. ;)

The eventual goal would be to use this for kdb and kprobes as well.
Really it is nothing more than a few more functions to access the data
tables. I thought the first logical step would be to use this in
backtrace and oops because that affects the widest scope of users of
this feature.

>
>> The key difference here is that you get the source line information in
>> any kind of oops/panic/backtrace, including inside kernel modules. Of
>> course this comes at the expense of some memory you do not get to use
>> because these tables have to get stored in a place that is accessible
>> after a crash. On a system with 4 gigs of ram however, the cost is
>> nearly insignificant when you have to give up a few megs for the
>> capability. The idea is to make it a bit easier to just jump into a
>> source tree without having to use any tools to decode the dump (which
>> I know every kernel developer out there already has anwyay :-)
>
> By the way, it seems that source file doesn't include directries,
> is that possible to expand it? Since there are many files which have
> same name but in different directries, it would be better to
> print those path informations too.


For now I didn't want to increase the kernel size any further, and it
was not directly needed by the backtrace due to screen size
constraints. It will not be hard to add the directories into the
database tables. At the moment, the readelf code is just trowing the
information away.

I also had noticed from my random sampling of functions / line
locations that you end up with unique values if you use the function
name + file name + line number. Obviously that is not the same thing
as simply knowing the line number and file location, but if the
memory footprint becomes too great a problem this is a possible
compromise.


>
>>
>> Using this patch is fairly straight forward. From a developer / end
>> user perspective here are the steps:
>> * set CONFIG_KALLSYMS_LINE_LOCATIONS=y
>
> I've found this config under Kallsyms resources, but I think
> it is better to put it under CONFIG_DEBUG_INFO, because you
> may need to enable CONFIG_DEBUG_INFO for build kernel with
> .debug_* stuffs, and that will increase on-memory kernel
> footprint.

At the moment the line locations feature is tied to the kallsyms code.
I thought I had made it depend on the debug info, but it depends only
on DEBUG_KERNEL at the moment so that will need to get fixed.

>>
>> Finally the symbol lookup used by printk was changed to request the
>> lines for location data when it exists.
>
> Ah, that's really what I want! :)
> I think ftrace also can use this for pretty printing ip address.
>

Because the address printing was generically changed, if the ftrace ip
address print is using a sym_address lookup it should automatically
appear.

>>
>> If you are wondering why I pulled in an modified readelf? It is
>> because most of the pre-built versions of readelf I tried were not
>> working properly on 32 or 64 bit combinations of machines.
>
> Maybe you can report it to the readelf upstream.

It is entirely possible this has been fixed a long time ago. I used
readelf 2.14 for all the work for the kernel because I needed a
version with a GPL v2 license. All I had to go on was just trying the
pre-built binaries from binutils from several host OS systems and
cross compilers I had laying around. It was enough to tell me that we
would need our own readelf in the tree if we wanted this feature to
work reliably.


>> git://git.kernel.org/pub/scm/linux/kernel/git/jwessel/linux-2.6-kgdb.git
> lines_for_locations
>
> BTW, correct git url is here, isn't it? :)
> git://git.kernel.org/pub/scm/linux/kernel/git/jwessel/kgdb.git
>


Thanks for pointing this out. It will also be corrected should this
series get posted again. :-)

Cheers,
Jason.
