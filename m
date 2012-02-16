Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752776Ab2BPNqt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 08:46:49 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34514 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751204Ab2BPNqq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 08:46:46 -0500
From: Jan Kara <jack@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric Sandeen <sandeen@redhat.com>, Dave Chinner <david@fromorbit.com>,
        Jan Kara <jack@suse.cz>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Jaya Kumar <jayalk@intworks.biz>, Sage Weil <sage@newdream.net>,
        ceph-devel@vger.kernel.org, Steve French <sfrench@samba.org>,
        linux-cifs@vger.kernel.org, Eric Van Hensbergen <ericvh@gmail.com>,
        Ron Minnich <rminnich@sandia.gov>, Latchesar Ionkov <lucho@ionkov.net>,
        v9fs-developer@lists.sourceforge.net,
        Miklos Szeredi <miklos@szeredi.hu>, fuse-devel@lists.sourceforge.net,
        Steven Whitehouse <swhiteho@redhat.com>, cluster-devel@redhat.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        linux-nfs@vger.kernel.org
Subject: [PATCH 00/11] Push file_update_time() into .page_mkwrite
Date: Thu, 16 Feb 2012 14:46:08 +0100
Message-Id: <1329399979-3647-1-git-send-email-jack@suse.cz>
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
obviously happen by other means. If you know your filesystem does not need
update of modification times in ->page_mkwrite() handler, please speak up and
I'll drop the patch for your filesystem.

As a side note, an alternative would be to remove call of file_update_time()
from page fault code altogether and require all filesystems needing it to do
that in their ->page_mkwrite() implementation. That is certainly possible
although maybe slightly inefficient and would require auditting 100+
vm_operations_structs *shake*.

If I get acks on these patches, Andrew, would you be willing to take these
patches?

								Honza

CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@elte.hu>
CC: Paul Mackerras <paulus@samba.org>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Jaya Kumar <jayalk@intworks.biz>
CC: Sage Weil <sage@newdream.net>
CC: ceph-devel@vger.kernel.org
CC: Steve French <sfrench@samba.org>
CC: linux-cifs@vger.kernel.org
CC: Eric Van Hensbergen <ericvh@gmail.com>
CC: Ron Minnich <rminnich@sandia.gov>
CC: Latchesar Ionkov <lucho@ionkov.net>
CC: v9fs-developer@lists.sourceforge.net
CC: Miklos Szeredi <miklos@szeredi.hu>
CC: fuse-devel@lists.sourceforge.net
CC: Steven Whitehouse <swhiteho@redhat.com>
CC: cluster-devel@redhat.com
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Trond Myklebust <Trond.Myklebust@netapp.com>
CC: linux-nfs@vger.kernel.org
