Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759440Ab2CVTda (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 15:33:30 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:33267 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754543Ab2CVTd2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 15:33:28 -0400
MIME-Version: 1.0
In-Reply-To: <20120322183845.GA17264@phenom.dumpdata.com>
References: <20120322183845.GA17264@phenom.dumpdata.com>
Date: Thu, 22 Mar 2012 15:33:27 -0400
Message-ID: <CACLa4pt0iQDM14N8AwqBmuZESYaevy6Km8CF_0pEeP+ydH7xjw@mail.gmail.com>
Subject: Re: Regression introduced by bfcfaa77bdf0f775263e906015982a608df01c76
 (vfs: use 'unsigned long' accesses for dcache name comparison and hashing)
From: Eric Paris <eparis@parisplace.org>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No idea if it is related and haven't bisected, but we are seeing
similar ENOENT issues with things in selinuxfs.  And not a single bit
of SELinux code has changed since v3.3.  So it's certainly a VFS
problem.  This sounds likely.

-Eric

On Thu, Mar 22, 2012 at 2:38 PM, Konrad Rzeszutek Wilk
<konrad.wilk@oracle.com> wrote:
> Hey Linus,
>
> I am not sure how to debug this but with v3.3 with just that git commit I can't
> start an user space application called 'xenstored'. A bit of strace showed me:
> [edit, also with todays linus/master I get the same issue, and if I revert
> your patch it works again]
>
> (right is 3.3, left is with your patch)
> write(3, "Checking store complete.\n", 25) = 25                 write(3, "Checking store complete.\n", 25) = 25
> sendto(9, "<11>Mar 22 18:00:27 xenstored: C"..., 55, MSG_NOSI | sendto(9, "<11>Mar 22 18:06:44 xenstored: C"..., 55, MSG_NOSI
> open("/proc/xen/privcmd", O_RDWR)       = 10                    open("/proc/xen/privcmd", O_RDWR)       = 10
> fcntl(10, F_GETFD)                      = 0                     fcntl(10, F_GETFD)                      = 0
> fcntl(10, F_SETFD, FD_CLOEXEC)          = 0                     fcntl(10, F_SETFD, FD_CLOEXEC)          = 0
> open("/dev/xen/evtchn", O_RDWR)         = 11                    open("/dev/xen/evtchn", O_RDWR)         = 11
> open("/proc/xen/xsd_port", O_RDONLY)    = -1 ENOENT (No such  | open("/proc/xen/xsd_port", O_RDONLY)    = 12
> write(2, "FATAL: ", 7FATAL: )                  = 7            | read(12, "25", 20)                      = 2
> write(2, "Failed to initialize dom0 state:"..., 59Failed to i | close(12)                               = 0
> ) = 59                                                        | ioctl(11, EVIOCGVERSION, 0x7fff4e3ffc70) = 41
> close(10)                               = 0                   | write(3, "CREATE connection 0xe2e7b0\n", 27) = 27
> close(5)                                = 0                   | open("/proc/xen/xsd_kva", O_RDWR)       = 12
> close(4)                                = 0                   | mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_SHARED, 12, 0) = 0
> exit_group(1)                           = ?                   | close(12)                               = 0
>                                                              > ioctl(11, EVIOCGKEYCODE or EVIOCSKEYCODE, 0x7fff4e3ffc90) = 0
>                                                              > ioctl(11, 0x44500, 0x7fff4e3ffc90)      = 42
>                                                              > rt_sigaction(SIGHUP, {0x402180, [HUP], SA_RESTORER|SA_RESTART
>                                                              > select(12, [4 5 6 11], [], NULL, NULL)  = 1 (in [11])
>                                                              > read(11, ")\0\0\0", 4)                  = 4
>                                                              > write(11, ")\0\0\0", 4)                 = 4
>                                                              > select(12, [4 5 6 11], [], NULL, NULL <unfinished ...>
>
> and if I ls /proc/xen (v3.3):
>
>> ls -al /proc/xen
> total 0
> drwxr-xr-x   2 root root 0 Mar 22 18:05 .
> dr-xr-xr-x 126 root root 0 Mar 22 18:05 ..
> -r--r--r--   1 root root 0 Mar 22 18:05 capabilities
> -rw-------   1 root root 0 Mar 22 18:05 privcmd
> -rw-------   1 root root 0 Mar 22 18:05 xenbus
> -rw-------   1 root root 0 Mar 22 18:05 xsd_port
>
> while v3.3 with your patch:
>
>
> 8:01:09 # 10 :/proc/xen/
>> ls -al
> ls: cannot access xsd_port: No such file or directory
> total 0
> drwxr-xr-x   2 root root 0 Mar 22 17:57 .
> dr-xr-xr-x 126 root root 0 Mar 22 17:57 ..
> -r--r--r--   1 root root 0 Mar 22 17:57 capabilities
> -rw-------   1 root root 0 Mar 22 17:57 privcmd
> -rw-------   1 root root 0 Mar 22 17:57 xenbus
> -rw-------   1 root root 0 Mar 22 17:57 xsd_kva
> -?????????   ? ?    ?    ?            ? xsd_port
>
>
> Looking at the code that sets up 'xsd_port' it looks pretty innocent
> and similar to other drivers (ibmasm for example).
>
> Also attached is the .config
>
> Note: to actually bootup the latest with Xen there are some fixes required
> to fix the regressions introduced:
> http://git.kernel.org/?p=linux/kernel/git/konrad/xen.git;a=commit;h=106b44388d8f76373149c4ea144f717b6d4d9a6d
> http://git.kernel.org/?p=linux/kernel/git/konrad/xen.git;a=commit;h=a759ceb7d1dfe38f4dda147e233aa53c8f477e2a
> http://git.kernel.org/?p=linux/kernel/git/konrad/xen.git;a=commit;h=1b34ba936c1adff3020eec1e1834ffa4cf89802f
> http://git.kernel.org/?p=linux/kernel/git/konrad/xen.git;a=commit;h=6ac72c4bc49a9afb02b8176b48be019dff0560cd
