Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932623Ab2CEOzr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 09:55:47 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56248 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932283Ab2CEOy2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 09:54:28 -0500
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>, Al Viro <viro@ZenIV.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>,
        Jaya Kumar <jayalk@intworks.biz>, Sage Weil <sage@newdream.net>,
        ceph-devel@vger.kernel.org, Eric Van Hensbergen <ericvh@gmail.com>,
        Ron Minnich <rminnich@sandia.gov>, Latchesar Ionkov <lucho@ionkov.net>,
        v9fs-developer@lists.sourceforge.net,
        Steven Whitehouse <swhiteho@redhat.com>, cluster-devel@redhat.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 0/7 v3] Push file_update_time() into .page_mkwrite
Date: Mon,  5 Mar 2012 15:54:11 +0100
Message-Id: <1330959258-23211-1-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hello,

  to provide reliable support for filesystem freezing, filesystems need to have
complete control over when metadata is changed. In particular,
file_update_time() calls from page fault code make it impossible for
filesystems to prevent inodes from being dirtied while the filesystem is
frozen.

To fix the issue, this patch set changes page fault code to call
file_update_time() only when ->page_mkwrite() callback is not provided. If the
callback is provided, it is the responsibility of the filesystem to perform
update of i_mtime / i_ctime if needed. We also push file_update_time() call
to all existing ->page_mkwrite() implementations if the time update does not
obviously happen by other means. This is including __block_page_mkwrite() so
filesystems using it are handled. If you know your filesystem does not need
update of modification times in ->page_mkwrite() handler, please speak up and
I'll drop the patch for your filesystem.

As a side note, an alternative would be to remove calls of file_update_time()
from page fault code altogether and require all filesystems needing it to do
that in their ->page_mkwrite() implementation. That is certainly possible
although maybe slightly inefficient and would require auditting 100+
vm_operations_structs *shiver*.

Changes since v1:
* Dropped patches for filesystems which don't need them
* Added some acks
* Improved sysfs patch by Alex Elder's suggestion

Changes since v2:
* Dropped patches for more filesystems

Andrew, would you be willing to merge these patches via your tree? This seems
to be a final version.

								Honza

CC: Jaya Kumar <jayalk@intworks.biz>
CC: Sage Weil <sage@newdream.net>
CC: ceph-devel@vger.kernel.org
CC: Eric Van Hensbergen <ericvh@gmail.com>
CC: Ron Minnich <rminnich@sandia.gov>
CC: Latchesar Ionkov <lucho@ionkov.net>
CC: v9fs-developer@lists.sourceforge.net
CC: Steven Whitehouse <swhiteho@redhat.com>
CC: cluster-devel@redhat.com
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
