Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932146Ab1JZFM1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 01:12:27 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:59399 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753425Ab1JZFM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 01:12:26 -0400
MIME-Version: 1.0
Date: Wed, 26 Oct 2011 10:42:26 +0530
Message-ID: <CADAg6uxLj_ePPbcrVcqcE7y+CxGZfqWUA1zYOtm9e-TYShBDsQ@mail.gmail.com>
Subject: Multi-partition block layer behaviour
From: Tiju Jacob <jacobtiju@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

We are trying to run fsstress tests on ext4 filesystem with
linux-3.0.4 on nand flash with our proprietary driver. The test runs
successfully when run on single partition but fails when run on
multiple partitions with the bug "BUG: scheduling while atomic:
fsstress.fork_n/498/0x00000002".

Analysis:

1. When an I/O request is made to the filesystem, process 'A' acquires
a mutex FS lock and a mutex block driver lock.

2. Process 'B' tries to acquire the mutex FS lock, which is not
available. Hence, it goes to sleep. Due to the new plugging mechanism,
before going to sleep, shcedule() is invoked which disables preemption
and the context becomes atomic. In schedule(), the newly added
blk_flush_plug_list() is invoked which unplugs the block driver.

3) During unplug operation the block driver tries to acquire the mutex
lock which fails, because the lock was held by process 'A'. Previous
invocation of scheudle() in step 2 has already made the context as
atomic, hence the error "Schedule while atomic" occured.


Please recommend us on how to handle this situation.


Thanks in advance.
--TJ
