Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752586Ab2LJHlX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 02:41:23 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:16783 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752185Ab2LJHlW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 02:41:22 -0500
Subject: [PATCH 0/6] fuse: process direct IO asynchronously
To: miklos@szeredi.hu
From: "Maxim V. Patlasov" <MPatlasov@parallels.com>
Cc: dev@parallels.com, xemul@parallels.com, fuse-devel@lists.sourceforge.net,
        bfoster@redhat.com, linux-kernel@vger.kernel.org, devel@openvz.org
Date: Mon, 10 Dec 2012 11:41:17 +0400
Message-ID: <20121210073848.12240.88144.stgit@maximpc.sw.ru>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Existing fuse implementation always processes direct IO synchronously: it
submits next request to userspace fuse only when previous is completed. This
is suboptimal because: 1) libaio DIO works in blocking way; 2) userspace fuse
can't achieve parallelism  processing several requests simultaneously (e.g.
in case of distributed network storage); 3) userspace fuse can't merge
requests before passing it to actual storage.

The idea of the patch-set is to submit fuse requests in non-blocking way
(where it's possible) and either return -EIOCBQUEUED or wait for their
completion synchronously. The patch-set to be applied on top of for-next of
Miklos' git repo.

To estimate performance improvement I used slightly modified fusexmp over
tmpfs (clearing O_DIRECT bit from fi->flags in xmp_open). For synchronous
operations I used 'dd' like this:

dd of=/dev/null if=/fuse/mnt/file bs=2M count=256 iflag=direct
dd if=/dev/zero of=/fuse/mnt/file bs=2M count=256 oflag=direct conv=notrunc

For AIO I used 'aio-stress' like this:

aio-stress -s 512 -a 4 -b 1 -c 1 -O -o 1 /fuse/mnt/file
aio-stress -s 512 -a 4 -b 1 -c 1 -O -o 0 /fuse/mnt/file

The throughput on some commodity (rather feeble) server was (in MB/sec):

             original / patched

dd reads:    ~322     / ~382
dd writes:   ~277     / ~288

aio reads:   ~380     / ~459
aio writes:  ~319     / ~353

Thanks,
Maxim

---

Maxim V. Patlasov (6):
      fuse: move fuse_release_user_pages() up
      fuse: add support of async IO
      fuse: make fuse_direct_io() aware about AIO
      fuse: enable asynchronous processing direct IO
      fuse: truncate file if async dio failed
      fuse: optimize short direct reads


 fs/fuse/cuse.c   |    4 -
 fs/fuse/file.c   |  276 ++++++++++++++++++++++++++++++++++++++++++++++++------
 fs/fuse/fuse_i.h |   17 +++
 3 files changed, 262 insertions(+), 35 deletions(-)

-- 
Signature
