Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753118Ab1IFR0u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 13:26:50 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33893 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752852Ab1IFR0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 13:26:43 -0400
MIME-Version: 1.0
Date: Tue, 6 Sep 2011 22:56:41 +0530
Message-ID: <CADDb1s1pLQMMipe-zoHM6u4C_ZmUm_r4rsYxfft9mFQ56+Wgaw@mail.gmail.com>
Subject: Issue with lazy umount and closing file descriptor in between
From: Amit Sahrawat <amit.sahrawat83@gmail.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have observed below issues in busybox umount:
1. force umount (umount -f): it does not work as expected.
2. lazy umount(umount -l): it detaches the mount point but waits for
current mount point users(processes) to finish.
Corruption happens when we powerdown, while lazy umount is waiting for
a process to finish.
(e.g. #dd if=/dev/zero of=/mnt/test.txt ).
What could be the ideal way so as to avoid file system corruption in
above scenario?
Is it fine to close all open file descriptors on umount system call
before attempting umount? But this results in OOPS in certain
situations like:
1. User app issue a write/read request
2. Write reaches in kernel space but sleeps for some time e.g. it is
not available in dentry cache.
3. In the meanwhile, we issue umount. This will close open file
descriptor, free file/dentry object and then umount.
4. Now write wakes up and finds NULL file/dentry object and triggers oops.
Please offer some advice on this issue.
Thanks & Regards,
Amit Sahrawat
