Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751283Ab1JJP2g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 11:28:36 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:47735 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577Ab1JJP2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 11:28:34 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        hch@infradead.org, Jan Beulich <JBeulich@novell.com>
Subject: [PATCH] Xen block fixes, secure discard, and barrier support for 3.2 (v1)
Date: Mon, 10 Oct 2011 11:28:11 -0400
Message-Id: <1318260494-27985-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.5.4
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4E930F18.019A:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 [PATCH 1/3] xen/blkback: Support 'feature-barrier' aka old-style

The BARRIER support is done by:
 1) setting the drain value to one and waiting for the 'complete waitqueue' to be
    complete. We also double-check the kthread status in case the interface is being
    disconnected. Waiting means stalling processing of the queue.
 2) By latching on the refcnt value which is incremented every time a 'struct request'
    is used for a particular interface we can figure out outstanding I/Os.
    The refcnt is decremented when all the bio's that were generated for the
    'struct request' have been processed. When we detect that all outstanding
    'struct request' and their bio's have been completed we notify the
    'complete waitqueue' which halted processing of the ring.
 3) When the 'complete waitqueue' is signaled, it submits a WRITE_FLUSH
    operation.

That should take care of emulating the drain behavior properly. When I ran with SLES11
guests using the ext3/reiserfs using the 'fio tiobench-example;fio fsx' they ran fine.
Also killing the guest during runtime and then restarting showed no corruption.
If there are some better tests to check for proper operation of this - please advise.

 [PATCH 2/3] xen/blkback: Fix the inhibition to map pages when

Obvious bugfix in the 'feature-discard' patchset.

 [PATCH 3/3] xen/blk[front|back]: Enhance discard support with secure

We also provide the REQ_SECURE support to allow the user to now issue:
 'blkdev_issue_discard(.., secure)' flag.

[NOTE: My SSD died on my - so I can't test this yet - going through the process
of RMA-ing it, so please consider the 3/3 patch more as an RFC as it has not been tested].

Please review.
