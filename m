Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758198Ab0FUTuA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 15:50:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50798 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751686Ab0FUTt7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 15:49:59 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] cfq: fixes to bring cfq in line with deadline performance for mid- to high-end storage
Date: Mon, 21 Jun 2010 15:49:47 -0400
Message-Id: <1277149789-4493-1-git-send-email-jmoyer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

In testing iozone using the flag that enforces an fsync before close, we found
that performance for cfq on ext3 and ext4 file systems was very poor for file
sizes 8MB and below (as compared with a 2.6.18 kernel's cfq, or with a recent
kernel with deadline).  The storage involved is middle of the road SAN storage
connected via a single fiber pair.  Investigation showed that the idling logic
of cfq was causing the process issuing the I/O to stall.  iozone, in this case,
was really dependant on the journal commits done by the jbd thread, but cfq
was instead idling waiting for more I/O from iozone.  Setting slice_idle to
0 for cfq will regain this performance.

However, if you introduce a single sequential reader into the mix, even
with slice_idle set to 0, cfq is unable to perform as well as deadline:

          deadline  cfq, defaults    cfq, slice_idle=0
fs_mark:  294.3     36.1             48.0
fio bsr:  153 MB/s  152 MB/s         147 MB/s

I used fs_mark to simulate iozone (it's less verbose) and fio to start
a single Buffered Sequential Reader (bsr).  The fs_mark numbers are in
files/second.  As you can see, cfq doesn't even compete here.

With either of the two patches applied, we get back a subset of the
performance.  With both applied, we are in line with deadline.  I've also
tested these patches against a single SATA disk and observed no performance
degradation for default tuning.

[PATCH 1/2] cfq: always return false from should_idle if slice_idle is set to zero
[PATCH 2/2] cfq: allow dispatching of both sync and async I/O together
