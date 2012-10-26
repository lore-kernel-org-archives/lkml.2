Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753406Ab2JZJS1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 05:18:27 -0400
Received: from ofcsgdbm.dwd.de ([141.38.3.245]:58624 "EHLO ofcsgdbm.dwd.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750857Ab2JZJSY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 05:18:24 -0400
Date: Fri, 26 Oct 2012 09:18:22 +0000 (GMT)
From: Holger Kiehl <Holger.Kiehl@dwd.de>
X-X-Sender: kiehl@diagnostix.dwd.de
To: Kees Cook <kees@outflux.net>
cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Enabling hardlink restrictions to the Linux VFS in 3.6 by
 default
In-Reply-To: <20121026003325.GB17208@outflux.net>
Message-ID: <alpine.LRH.2.02.1210260619090.9897@diagnostix.dwd.de>
References: <alpine.LRH.2.02.1210251028470.640@diagnostix.dwd.de> <20121026003325.GB17208@outflux.net>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Kees,

first, many thanks for trying to help!

On Thu, 25 Oct 2012, Kees Cook wrote:

> Hi Holger,
>
> On Thu, Oct 25, 2012 at 12:13:40PM +0000, Holger Kiehl wrote:
>> as of linux 3.6 hardlink restrictions to the Linux VFS have been enabled
>> by default. This breaks the application AFD [1] of which I am the author.
>
> Sorry this created a problem for you!
>
>> Internally it uses hardlink to distribute files. The reason for hardlinks
>> is that AFD can distribute one file to many destinations and for each
>> distributing process it creates a directory with hardlinks to the original
>> file. That way AFD itself never needs to copy the content of a file. Another
>> nice feature about hardlinks was that there is no need to have any logic in
>> the code needing AFD to know where the original file was, each distributing
>> process could delete its hardlink and the last one would delete the real
>> file. This way AFD could distribute files at rates of more then 20000 files
>> per second (in benchmarks). This has worked from the first linux kernel
>> up to 3.5.7 and with solaris, hpux, aix, ftx, irix. As of 3.6 this does
>> not work for files where AFD does not have write permissions. It was always
>> sufficient to just have read permission on a file it wants to distribute.
>
> Just to clarify, not even read access was needed for hardlinks:
>
> $ whoami
> kees
> $ ls -l /etc/shadow
> -r--r----- 1 root shadow 3112 Oct 22 17:02 /etc/shadow
> $ ln /etc/shadow /tmp/ohai
> $ ls -l /tmp/ohai
> -r--r----- 2 root shadow 3112 Oct 22 17:02 ohai
>
Correct, but when AFD wants to distribute the file via for example FTP
it must have read access on the file. Because it needs to read the file
when it wants to send it on a socket.

> You mention "the last one would delete the real file". That would have
> required AFD to have write permission to the directory where the original
> file existed? Maybe there is something in your architecture that could
> take advantage of that? Directory group-write set-gid? I haven't taken
> a look at AFD's code.
>
Right, it must have write permission on the directory that is monitored
by AFD. When it detects a file it moves (rename()) it to an internal
directory where AFD works. So this step still works. But from there it
creates hardlinks for each distributing job. But this no longer works if
AFD does not have write access on the file itself. So even if set-gid
is set, this would still not work if the file does not have write
permission for the group.

>> The fix for the "at" daemon [2] mentioned in the commitdiff [3] cannot
>> be used for AFD since it is not run with root privileges. Is there any
>> other way I can "fix" my application? I currently can see no other way
>> then doing it via: echo 0 > /proc/sys/fs/protected_hardlinks
>
> You said you have read access to these files, so perhaps you can make
> a copy when you have read but not write, and then all the subsequent
> duplication would be able to hardlink?
>
This is exactly what AFD tries to avoid. AFD is used on systems where it
distributes Terabytes of data daily and if it would need to copy the file
first imagine the strain it imposes on those servers.

> If you wanted to turn off the sysctl, you could have AFD could ship
> files in /etc/sysctl.d/ (or your distro equivalent) to turn it off.
>
Yes, that could be done. However, I do not want as a maintainer of one
software package by default disable or enable anything in the kernel.
I do not think the system administrators would like this.

> I'm sure there are plenty of options available.
>
Sorry, I cannot see them. But please if you or others have more ideas
I am certainly open to change AFD if it can be done efficiently.

>> Why is such a fundamentally change to the linux kernel activated by default?
>
> Based on about two years of testing in Ubuntu, the number of problems
> was vanishingly small, so the security benefit is seen to outweigh
> the downside.
>
Ubuntu is known to be very user friendly and mostly used by users on their
laptops/pc's and not so common in the server environment such as Redhat,
SLES, etc. So I question the statement "vanishingly small", when you
enable it in those environments by default.

And I think there is a real benefit in that one can do hardlinks on a
file that one does not own, which I think was not seen by those that
disable this feature now by default.

>> Would it not be better if it is the other way around, that the system
>> administrator or distributions enable this?
>
> Virtually all distributions would have turned this on by default,
> so it seemed better to many people to just make it the default in the
> kernel. Only unusual corner-cases would need it disabled.
>
So you too would say not all distributions would enable it by default.
Would it then not be better for them to first try this and see if the number
of problems is really "vanishingly small". And then if all distributions
enable this by default one can do it in the kernel by default as well.
Has it not always worked that way?

Again many thanks for trying to help!

Regards,
Holger
