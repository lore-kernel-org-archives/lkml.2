Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751799Ab2LTMaw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 07:30:52 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:16807 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750956Ab2LTMar (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 07:30:47 -0500
Subject: [PATCH 0/5] fuse: close file synchronously
To: miklos@szeredi.hu
From: Maxim Patlasov <mpatlasov@parallels.com>
Cc: dev@parallels.com, xemul@parallels.com, fuse-devel@lists.sourceforge.net,
        bfoster@redhat.com, linux-kernel@vger.kernel.org, devel@openvz.org,
        anand.avati@gmail.com
Date: Thu, 20 Dec 2012 16:30:44 +0400
Message-ID: <20121220122702.4101.80042.stgit@maximpc.sw.ru>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

There is a long-standing demand for syncronous behaviour of fuse_release:

http://sourceforge.net/mailarchive/message.php?msg_id=19343889
http://sourceforge.net/mailarchive/message.php?msg_id=29814693

A few months ago Avati and me explained why such a feature would be useful:

http://sourceforge.net/mailarchive/message.php?msg_id=29889055
http://sourceforge.net/mailarchive/message.php?msg_id=29867423

In short, the problem is that fuse_release (that's called on last user
close(2)) sends FUSE_RELEASE to userspace and returns without waiting for
ACK from userspace. Consequently, there is a gap when user regards the
file released while userspace fuse is still working on it. An attempt to
access the file from another node leads to complicated synchronization
problems because the first node still "holds" the file.

The patch-set resolves the problem by making fuse_release synchronous:
wait for ACK from userspace for FUSE_RELEASE if the feature is ON.

To keep single-threaded userspace implementations happy the patch-set
ensures that by the time fuse_release_common calls fuse_file_put, no
more in-flight I/O exists. Asynchronous fuse callbacks (like
fuse_readpages_end) cannot trigger FUSE_RELEASE anymore. Hence, we'll
never block in contexts other than close().

Thanks,
Maxim

---

Maxim Patlasov (5):
      fuse: add close_wait flag to fuse_conn
      fuse: cosmetic rework of fuse_send_readpages
      fuse: wait for end of IO on release
      fuse: enable close_wait feature
      fuse: fix synchronous case of fuse_file_put()


 fs/fuse/file.c            |   82 ++++++++++++++++++++++++++++++++++++++-------
 fs/fuse/fuse_i.h          |    3 ++
 fs/fuse/inode.c           |    5 ++-
 include/uapi/linux/fuse.h |    7 +++-
 4 files changed, 82 insertions(+), 15 deletions(-)

-- 
Signature
