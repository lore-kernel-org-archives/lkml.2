Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932715Ab1JNLFa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 07:05:30 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:43177 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754560Ab1JNLF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 07:05:27 -0400
Message-Id: <20111014110416.552685686@openvz.org>
User-Agent: quilt/0.48-1
Date: Fri, 14 Oct 2011 15:04:16 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Vagin <avagin@parallels.com>, Pavel Emelyanov <xemul@parallels.com>,
        James Bottomley <jbottomley@parallels.com>,
        Glauber Costa <glommer@parallels.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Tejun Heo <tj@kernel.org>, Dave Hansen <dave@linux.vnet.ibm.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Daniel Lezcano <dlezcano@fr.ibm.com>,
        Alexey Dobriyan <adobriyan@gmail.com>
Subject: [patch 0/5] [RFC] Checkpoint/restore and Elf extension
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

it's been known that we're working on checkpoint/restore capability
and the initial RFC series might be found at

      http://permalink.gmane.org/gmane.linux.kernel.containers/

so here is a second attempt to bring some pretty raw and early checkpoint
prototype into discussion.

The first general change from the pervious RFC series is that we're switched to
brand new ptrace-seize facility kernel provides, in a sake of dumping task
memory.

There are still known problems with SEIZE not working with frozen tasks, but
we're working on it.

The second one -- the restore procedure looks like a simple exec() call
from user-space view. Of course this requires some help from kernel side
so we implemented an addition/extension to traditional Elf format.

The main purpose of this set is to discuss whether this "execve the image
in ELF format" approach is suitable for the community.

User space 'crtools' tool can be found here (please checkout at lkml tag
since this is a point when this patch series was sent)

      git://github.com/cyrillos/crtools.git

While the testing was done on top of Linux 3.1-rc3, some patches required
are already included into -mm bundle. So I don't send those patches here,
still they all might be found in crtools source code tree under kernel/
directory (see readme there as well). It includes quilt 'series' file and the all patches
needed in 'all-in-one-series' fashion. The patch 'clone-with-pid-support'
was sent separately for review procedure, so I don't include it into this
patchset as well. And finally the patches for /proc/$pid/map_files are not
included into this bundle too since they are already reviewed and I suppose
will be merged after 3.1, still you can find them under crtools/kernel/
directory.

So to test the features one needs to apply all patches from kernel/ directory,
build the kernel, crtools and do

	crtools -d -t $pid

where the $pid is a pid of process. To restore checkpointed process one need
to run

	crtools -r -t $pid

To see sumped contents one need to type

	crtools -s -t $pid

Note the patch series and crtools itself is rather a very early prototype whith
known problems...

I run tests from test/ directory like (under kvm with CentOS 5.5 on a board)

$ make test
$ test/testee &
[2484]
$ ./crtools -d -t 2484
$ killall -9 testee
$ ./crtools -r -t 2484
    ... here some pings from testee should appear ...

So *ANY* comments, complains, ideas are HIGHLY APPRECIATED!

	Cyrill
