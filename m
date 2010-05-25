Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755394Ab0EYMMq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 08:12:46 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:39008 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755010Ab0EYMMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 08:12:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=qWrewTRw63hU1hgHC5DbetkEGXKrTMeXR1GjoQ9bwlyIibY54Jkpy75SmvXf2V5jWF
         gdKPriAlRsqGIzCD3X7Lea6AE0KMlx+F3VubCeOTq7m1Li3bvfa9k8wHKieJsP0NjI54
         VRVv+v50Z3FzmbXKZnO3MbjEEDvv9o4QdFMr8=
Message-ID: <4BFBBEB7.4070107@gmail.com>
Date: Tue, 25 May 2010 14:12:39 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.4) Gecko/20100520 SUSE/3.1rc1-1.1 Thunderbird/3.1
MIME-Version: 1.0
To: Eric Paris <eparis@redhat.com>
CC: Al Viro <viro@zeniv.linux.org.uk>, Kay Sievers <kay.sievers@suse.de>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: udev loops eating 100 % CPU [mmotm 2010-05-21-16-05]
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

>From next/master:
commit a7cf4145bb86aaf85d4d4d29a69b50b688e2e49d
Author: Eric Paris <eparis@redhat.com>
Date:   Fri May 14 11:44:10 2010 -0400

    anon_inode: set S_IFREG on the anon_inode

    anon_inode_mkinode() sets inode->i_mode = S_IRUSR | S_IWUSR;  This means
    that (inode->i_mode & S_IFMT) == 0.  This trips up some SELinux code
that
    needs to determine if a given inode is a regular file, a directory, etc.
    The easiest solution is to just make sure that the anon_inode also sets
    S_IFREG.

    Signed-off-by: Eric Paris <eparis@redhat.com>
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>





causes my udev and psi both eating 100 % CPU. When I revert that on the
top of mmotm 2010-05-21-16-05, the problem disappears.

These are red-numbered lines from perf:
    13.96%    udevd  [kernel.kallsyms]      [k] _raw_spin_unlock_irqrestore
    10.22%    udevd  [kernel.kallsyms]      [k] signalfd_poll
     7.82%    udevd  [kernel.kallsyms]      [k] system_call_after_swapgs
     6.33%    udevd  [kernel.kallsyms]      [k] do_sys_poll
     5.43%    udevd  udevd                  [.] 0x0000000000dc72


It loops with this strace:
ioctl(7, FIONREAD, [0])                 = 0
poll([{fd=4, events=POLLIN}, {fd=6, events=POLLIN}, {fd=7,
events=POLLIN}, {fd=8, events=POLLIN}, {fd=9, events=POLLIN}], 5, 3000)
= 1 ([{fd=7, revents=POLLIN}])

where /proc/.../fd is:
lrwx------ 1 root root 64 May 25 14:06 0 -> /dev/null
lrwx------ 1 root root 64 May 25 14:06 1 -> /dev/null
lrwx------ 1 root root 64 May 25 14:06 10 -> socket:[1676]
lrwx------ 1 root root 64 May 25 14:06 2 -> /dev/null
lrwx------ 1 root root 64 May 25 14:06 3 -> /dev/.udev/queue.bin
lrwx------ 1 root root 64 May 25 14:06 4 -> socket:[1673]
l-wx------ 1 root root 64 May 25 14:06 5 -> /dev/blog
lrwx------ 1 root root 64 May 25 14:06 6 -> socket:[1674]
lr-x------ 1 root root 64 May 25 14:06 7 -> anon_inode:inotify
lrwx------ 1 root root 64 May 25 14:06 8 -> anon_inode:[signalfd]
lrwx------ 1 root root 64 May 25 14:06 9 -> socket:[1675]
