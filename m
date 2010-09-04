Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754974Ab0IDEaZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Sep 2010 00:30:25 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:60538 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754639Ab0IDEaR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Sep 2010 00:30:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=QCYFTopnNjYOFBosFwv4TcmopBswy/zYEMdjaI6Ldnq1WwPMnB8aMKDvx7eU4tn3Az
         SWmwygb1EkP3XpAMRiuASakMyiyZJ/p/wXdhTrK9HHh1r1vdoXBCAzY+v2gXUG/5fD5K
         VeiMPazWsxPoq6pKNW3gnw2xrdTLkceJn3AlA=
MIME-Version: 1.0
In-Reply-To: <y0md3suzzuj.fsf@fche.csb>
References: <AANLkTimjO7sBzR55XkPB7dmZvxXqc8PS4UDsgptXVt90@mail.gmail.com>
 <1283504768.2100.43.camel@steven> <y0md3suzzuj.fsf@fche.csb>
From: Hui Zhu <teawater@gmail.com>
Date: Sat, 4 Sep 2010 12:29:56 +0800
Message-ID: <AANLkTi=V13SpXeMzmnCWvh-ooAgnVP8kA5UsBsm89YDr@mail.gmail.com>
Subject: Re: Linux Kernel GDB tracepoint module 2010-8-30 release
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Steven <mqyoung@gmail.com>, "gdb@sourceware.org" <gdb@sourceware.org>,
        linux-kernel@vger.kernel.org, Michael Snyder <msnyder@vmware.com>,
        Marc Khouzam <marc.khouzam@ericsson.com>,
        Thiago Jung Bauermann <thiago.bauermann@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Frank,

Looks systemtap are very cool.

Could you talk about how it do call stack dump like following?
(gdb) trace vfs_readdir
Tracepoint 1 at 0xffffffff8113f7fc: file
/home/teawater/kernel/linux-2.6/fs/readdir.c, line 24.
(gdb) actions
Enter actions for tracepoint 1, one per line.
End with a line saying just "end".
>collect *(unsigned char *)$rsp@512
>end
(gdb) tstart
(gdb) shell ls
2      block    firmware  i        ipc     Makefile
modules.order   scripts   source      t~    vmlinux
a.out  crypto   fs        include  kernel  mm
Module.symvers  security  System.map  usr   vmlinux.o
arch   drivers  gdb.txt   init     lib     modules.builtin  net
     sound     t           virt
(gdb) tstop
(gdb) tfind
Found trace frame 0, tracepoint 1
#0  0xffffffff8113f7fd in vfs_readdir (file=0xffff880075f00780,
filler=0xffffffff8113f630 <filldir>, buf=0xffff880005785f38)
    at /home/teawater/kernel/linux-2.6/fs/readdir.c:24
24      {
(gdb) bt
#0  0xffffffff8113f7fd in vfs_readdir (file=0xffff880075f00780,
filler=0xffffffff8113f630 <filldir>, buf=0xffff880005785f38)
    at /home/teawater/kernel/linux-2.6/fs/readdir.c:24
#1  0xffffffff8113fa14 in sys_getdents (fd=<value optimized out>,
dirent=0x801108, count=32768)
    at /home/teawater/kernel/linux-2.6/fs/readdir.c:214
#2  0xffffffff8100af42 in ?? () at
/home/teawater/kernel/linux-2.6/arch/x86/kernel/entry_64.S:487

BTW, I was not find out which ARCH of the systemtap support in its
website?  It support all the arch that kprobe support?

Thanks,
Hui

On Fri, Sep 3, 2010 at 22:05, Frank Ch. Eigler <fche@redhat.com> wrote:
>
> Steven <mqyoung@gmail.com> writes:
>
>> [...]
>>         (gdb) trace vfs_readdir
>>         Tracepoint 3 at 0xc1175690: file fs/readdir.c, line 23.
>>         (gdb) actions
>>         Enter actions for tracepoint 3, one per line.
>>         End with a line saying just "end".
>>         > collect jiffies_64
>>         > collect *file
>>         > end
>
> By the way, the systemtap equivalent would be:
>
> #! /usr/bin/stap -g
> probe kernel.function("vfs_readdir") {
>      println(%{ jiffies_64 %})
>      println($file$)
> }
>
>
>> 2) I can not collect local variable, despite I rebuild the kernel with
>> -O0 optimization option. what is the problem? Many thanks
>>         -------------------------------------------------------------------
>>         (gdb) trace fs/readdir.c:29
>>         Tracepoint 2 at 0xc11756ca: file fs/readdir.c, line 29.
>>         (gdb) actions
>>         Enter actions for tracepoint 2, one per line.
>>         End with a line saying just "end".
>>         > collect res
>>         > end
>
>
> #! /usr/bin/stap
> probe kernel.statement("*@fs/readdir.c:29") {
>      println($res)
> }
>
>
> - FChE
>
