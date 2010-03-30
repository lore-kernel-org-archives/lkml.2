Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755658Ab0C3GUQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 02:20:16 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:32918 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755638Ab0C3GUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 02:20:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=AEkBYQYpiLWJi95UNpXYXmbJq8UX+vPYGKW3Jal3EFOGNlGjH7Io1mgn/OCV5j87GK
         OCJu+GbyWUGZ8xiUZFPiiYQCo6D2zEHAXpenWOhOS5EEQjOyDjgM/vp6m22szzslc9yF
         uKZUWxKocYH4VH6ov9pglhpuirdCLT/npLS5s=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Kacur <jkacur@redhat.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Al Viro <viro@ZenIV.linux.org.uk>
Subject: [PATCH 0/6] Kill the bkl in procfs
Date: Tue, 30 Mar 2010 08:20:09 +0200
Message-Id: <1269930015-863-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patchset drops any use of the big kernel lock from procfs.
May be there is still one or two NULL llseek somewhere but I
think we have fixed 99% of those that were in the procfs core.

Users of procfs implementing an ioctl have not been easy to
spot automatically (there are hundreds of procfs users)
as there are many indirect ways to register a procfs, depending
on the subsystem you are.

So for those who want to verify the reliability of this check,
you can look at the script there:

	http://tglx.de/~fweisbec/seek.py

Beware it's very dirty! The hardcoded path are those I had
to check manually (or that I added to the automatic check).
One day I should learn how to use Coccinelle instead.

In the worst case, the remaining ones this script or my eyes
forgot will trigger a warning.

Thanks.


Arnd Bergmann (1):
  procfs: Kill BKL in llseek on proc base

Frederic Weisbecker (5):
  procfs: Use generic_file_llseek in /proc/kcore
  procfs: Use generic_file_llseek in /proc/kmsg
  procfs: Use generic_file_llseek in /proc/vmcore
  procfs: Push down the bkl from ioctl
  procfs: Kill the bkl in ioctl

 drivers/char/i8k.c                  |   53 +++++++++++++++------
 drivers/isdn/divert/divert_procfs.c |   90 ++++++++++++++++++++++-------------
 fs/proc/base.c                      |   10 ++++-
 fs/proc/inode.c                     |    4 +-
 fs/proc/kcore.c                     |    1 +
 fs/proc/kmsg.c                      |    1 +
 fs/proc/vmcore.c                    |    1 +
 net/sunrpc/cache.c                  |   20 ++++++--
 8 files changed, 123 insertions(+), 57 deletions(-)

