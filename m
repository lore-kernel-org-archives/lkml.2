Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751057Ab1GREEw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 00:04:52 -0400
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:5332 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750766Ab1GREEv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 00:04:51 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjgFACyuI055LCkBgWdsb2JhbABHDJhujn8VAQEWJiXKeYMmgxYEmw6IPw
From: Dave Chinner <david@fromorbit.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: [PATCH 0/2] splice: i_mutex vs splice write deadlock
Date: Mon, 18 Jul 2011 14:04:42 +1000
Message-Id: <1310961884-11634-1-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.7.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

generic_file_splice_write() takes the inode->i_mutex after the
filesystem has taken whatever locks it needs to ensure sanity.
however, this typically violates the locking order of filesystems
with their own locks in that the order is usually i_mutex ->
filesystem lock.

XFS is such a case, and generic_file_splice_write() is generating
lockdep warnings because of lock inversions between the
inode->i_mutex and the XFS_I(inode)->i_iolock. There is also a
reported case of fio causing a deadlock when it mixes IO types
(e.g. splice vs direct IO).

This patch set introduces generic_file_splice_write_unlocked() and
factors the code such that __generic_file_splice_write() will only
lock the i_mutex if called from the locked variant. The second patch
modifies XFS to use the new function.

