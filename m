Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753805Ab1AUQAU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 11:00:20 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:40594 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752647Ab1AUQAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 11:00:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:subject:date:message-id:x-mailer;
        b=IBgYVaaX9xZMMLDTJTW1V6A3E4WnAbYC/yg+gZ8fqhuicDP0zYTtvKGSsPWM8j3FMw
         N57q9BC0gKk+ggA6gNNRksuQ89tQ7X8ytqmbq+y3Sb1f5+wBs3bYyp5egkBBIrEWV8GP
         TAoZ0beIE5KqO46PNjFfwCwvjzclMP/HQ0nyw=
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, tytso@mit.edu, djwong@us.ibm.com, shli@kernel.org,
        neilb@suse.de, adilger.kernel@dilger.ca, jack@suse.cz,
        snitzer@redhat.com, linux-kernel@vger.kernel.org, kmannth@us.ibm.com,
        cmm@us.ibm.com, linux-ext4@vger.kernel.org, rwheeler@redhat.com,
        hch@lst.de, josef@redhat.com
Subject: [PATCHSET] block: reimplement FLUSH/FUA to support merge
Date: Fri, 21 Jan 2011 16:59:55 +0100
Message-Id: <1295625598-15203-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patchset reimplements (yeah, once more) so that FLUSH/FUA
requests can be merged.  This is inspired by Darrick's patches to
merge multiple zero-data flushes which helps workloads with highly
concurrent fsync requests.

For more information, please read the patch description on the third
patch.

 0001-block-add-REQ_FLUSH_SEQ.patch
 0002-block-improve-flush-bio-completion.patch
 0003-block-reimplement-FLUSH-FUA-to-support-merge.patch

0001-0002 prepare for the reimplementation.  0003 reimplements.

Tested on FLUSH+FUA, FLUSH, and no FLUSH configurations.  Works pretty
solid for me.  Darrick says that preliminary performance test looks
okay.  Darrick, please use this version for further testing as I fixed
a few problems.

This patchset is based on 2.6.38-rc1 (2b1caf6e) and available in the
following git branch,

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git block-flush-merge

and contains the following changes.

 block/blk-core.c          |   56 ++---
 block/blk-flush.c         |  441 +++++++++++++++++++++++++++++++---------------
 block/blk.h               |   12 -
 block/elevator.c          |    7 
 include/linux/blk_types.h |    2 
 include/linux/blkdev.h    |   18 +
 include/linux/elevator.h  |    1 
 7 files changed, 355 insertions(+), 182 deletions(-)

Thanks.

--
tejun
