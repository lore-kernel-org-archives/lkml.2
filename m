Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752420Ab1I0UAj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 16:00:39 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39800 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462Ab1I0UAi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 16:00:38 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1109271117200.17876@chino.kir.corp.google.com>
References: <20110927175453.GA3393@albatros>
	<alpine.DEB.2.00.1109271117200.17876@chino.kir.corp.google.com>
Date: Tue, 27 Sep 2011 23:00:37 +0300
X-Google-Sender-Auth: MvVptw9a6XE2PTtR7EEQL8xLGHM
Message-ID: <CAOJsxLH-bh0JrR2qSmf_jKdLj6hpy6bGu5Yc+7iPBZzmRxauRw@mail.gmail.com>
Subject: Re: [PATCH 1/2] mm: restrict access to slab files under procfs and sysfs
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: David Rientjes <rientjes@google.com>
Cc: Vasiliy Kulikov <segoon@openwall.com>, kernel-hardening@lists.openwall.com,
        Christoph Lameter <cl@linux-foundation.org>,
        Matt Mackall <mpm@selenic.com>, linux-mm@kvack.org,
        Kees Cook <kees@ubuntu.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        Valdis.Kletnieks@vt.edu,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Alan Cox <alan@linux.intel.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 27, 2011 at 9:21 PM, David Rientjes <rientjes@google.com> wrote:
> On Tue, 27 Sep 2011, Vasiliy Kulikov wrote:
>
>> Historically /proc/slabinfo and files under /sys/kernel/slab/* have
>> world read permissions and are accessible to the world.  slabinfo
>> contains rather private information related both to the kernel and
>> userspace tasks.  Depending on the situation, it might reveal either
>> private information per se or information useful to make another
>> targeted attack.  Some examples of what can be learned by
>> reading/watching for /proc/slabinfo entries:
>>
>> 1) dentry (and different *inode*) number might reveal other processes fs
>> activity.  The number of dentry "active objects" doesn't strictly show
>> file count opened/touched by a process, however, there is a good
>> correlation between them.  The patch "proc: force dcache drop on
>> unauthorized access" relies on the privacy of dentry count.
>>
>> 2) different inode entries might reveal the same information as (1), but
>> these are more fine granted counters.  If a filesystem is mounted in a
>> private mount point (or even a private namespace) and fs type differs from
>> other mounted fs types, fs activity in this mount point/namespace is
>> revealed.  If there is a single ecryptfs mount point, the whole fs
>> activity of a single user is revealed.  Number of files in ecryptfs
>> mount point is a private information per se.
>>
>> 3) fuse_* reveals number of files / fs activity of a user in a user
>> private mount point.  It is approx. the same severity as ecryptfs
>> infoleak in (2).
>>
>> 4) sysfs_dir_cache similar to (2) reveals devices' addition/removal,
>> which can be otherwise hidden by "chmod 0700 /sys/".  With 0444 slabinfo
>> the precise number of sysfs files is known to the world.
>>
>> 5) buffer_head might reveal some kernel activity.  With other
>> information leaks an attacker might identify what specific kernel
>> routines generate buffer_head activity.
>>
>> 6) *kmalloc* infoleaks are very situational.  Attacker should watch for
>> the specific kmalloc size entry and filter the noise related to the unrelated
>> kernel activity.  If an attacker has relatively silent victim system, he
>> might get rather precise counters.
>>
>> Additional information sources might significantly increase the slabinfo
>> infoleak benefits.  E.g. if an attacker knows that the processes
>> activity on the system is very low (only core daemons like syslog and
>> cron), he may run setxid binaries / trigger local daemon activity /
>> trigger network services activity / await sporadic cron jobs activity
>> / etc. and get rather precise counters for fs and network activity of
>> these privileged tasks, which is unknown otherwise.
>>
>>
>> Also hiding slabinfo and /sys/kernel/slab/* is a one step to complicate
>> exploitation of kernel heap overflows (and possibly, other bugs).  The
>> related discussion:
>>
>> http://thread.gmane.org/gmane.linux.kernel/1108378
>>
>>
>> To keep compatibility with old permission model where non-root
>> monitoring daemon could watch for kernel memleaks though slabinfo one
>> should do:
>>
>>     groupadd slabinfo
>>     usermod -a -G slabinfo $MONITOR_USER
>>
>> And add the following commands to init scripts (to mountall.conf in
>> Ubuntu's upstart case):
>>
>>     chmod g+r /proc/slabinfo /sys/kernel/slab/*/*
>>     chgrp slabinfo /proc/slabinfo /sys/kernel/slab/*/*
>>
>> Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
>> Reviewed-by: Kees Cook <kees@ubuntu.com>
>> Reviewed-by: Dave Hansen <dave@linux.vnet.ibm.com>
>> CC: Christoph Lameter <cl@gentwo.org>
>> CC: Pekka Enberg <penberg@cs.helsinki.fi>
>> CC: Valdis.Kletnieks@vt.edu
>> CC: Linus Torvalds <torvalds@linux-foundation.org>
>> CC: David Rientjes <rientjes@google.com>
>> CC: Alan Cox <alan@linux.intel.com>
>
> Acked-by: David Rientjes <rientjes@google.com>

Applied, thanks!
