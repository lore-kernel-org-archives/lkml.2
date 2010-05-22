Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758270Ab0EVUVa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 May 2010 16:21:30 -0400
Received: from lo.gmane.org ([80.91.229.12]:56974 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757978Ab0EVUV2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 May 2010 16:21:28 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
connect(): No such file or directory
From: walt <w41ter@gmail.com>
Subject: Re: [2.6.34-git8][regression] massive polling problems with udevd
 and other processes
Date: Sat, 22 May 2010 13:21:19 -0700
Message-ID: <4BF83CBF.8080300@gmail.com>
References: <201005221535.38939.shawn.starr@rogers.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: adsl-69-234-199-35.dsl.irvnca.pacbell.net
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.3a5pre) Gecko/20100522 Thunderbird/3.2a1pre
In-Reply-To: <201005221535.38939.shawn.starr@rogers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/22/2010 12:35 PM, Shawn Starr wrote:
> Just built today's snapshot from linus's tree and have problems with udev
> using 100% cpu and KDE processes also pegging cpus.
>
> This is with Fedora 13 + snapshot kernel from git.
>
> Anyone else noticing this?

Yes, just bisected it to this:

commit a7cf4145bb86aaf85d4d4d29a69b50b688e2e49d
Author: Eric Paris <eparis@>
Date:   Fri May 14 11:44:10 2010 -0400

     anon_inode: set S_IFREG on the anon_inode

     anon_inode_mkinode() sets inode->i_mode = S_IRUSR | S_IWUSR;  This means
     that (inode->i_mode & S_IFMT) == 0.  This trips up some SELinux code that
     needs to determine if a given inode is a regular file, a directory, etc.
     The easiest solution is to just make sure that the anon_inode also sets
     S_IFREG.

     Signed-off-by: Eric Paris <eparis@>
     Signed-off-by: Al Viro <viro@>

udevd is busy polling anon_inode:

COMMAND PID USER   FD   TYPE             DEVICE SIZE/OFF    NODE NAME
udevd   695 root  txt    REG               8,21   117632 1523956 /sbin/udevd
udevd   695 root  mem    REG               8,21    51528 1234821 /lib64/libnss_files-2.11.1.so
udevd   695 root  mem    REG               8,21    43376 2052251 /lib64/libnss_nis-2.11.1.so
udevd   695 root  mem    REG               8,21    88880 2052264 /lib64/libnsl-2.11.1.so
udevd   695 root  mem    REG               8,21    31432 1234823 /lib64/libnss_compat-2.11.1.so
udevd   695 root  mem    REG               8,21  1399984 1234830 /lib64/libc-2.11.1.so
udevd   695 root  mem    REG               8,21   128424 1234829 /lib64/ld-2.11.1.so
udevd   695 root    0u   CHR                1,3      0t0     147 /dev/null
udevd   695 root    1u   CHR                1,3      0t0     147 /dev/null
udevd   695 root    2u   CHR                1,3      0t0     147 /dev/null
udevd   695 root    3u   REG               0,14     1133    1670 /dev/.udev/queue.bin
udevd   695 root    4u  unix 0xffff88011f2b3c80      0t0     274 socket
udevd   695 root    5u  sock                0,5      0t0     275 can't identify protocol
udevd   695 root    6r   REG                0,8        0      17 anon_inode
udevd   695 root    7u   REG                0,8        0      17 anon_inode
udevd   695 root    8u  unix 0xffff88011f2b3980      0t0     276 socket
udevd   695 root    9u  unix 0xffff88011f2b3680      0t0     277 socket

poll([{fd=4, events=POLLIN}, {fd=5, events=POLLIN}, {fd=6, events=POLLIN}, {fd=7, events=POLLIN}, {fd=8, events=POLLIN}], 5, -1) = 1 ([{fd=6, revents=POLLIN}])

