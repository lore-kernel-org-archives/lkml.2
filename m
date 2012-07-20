Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752506Ab2GTLuj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 07:50:39 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:22309 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751559Ab2GTLuh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 07:50:37 -0400
Subject: [PATCH 0/4] fuse: optimize scatter-gather direct IO
To: miklos@szeredi.hu
From: Maxim Patlasov <mpatlasov@parallels.com>
Cc: fuse-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        devel@openvz.org
Date: Fri, 20 Jul 2012 15:50:07 +0400
Message-ID: <20120720114653.15517.74290.stgit@maximpc.sw.ru>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Existing fuse implementation processes scatter-gather direct IO in suboptimal
way: fuse_direct_IO passes iovec[] to fuse_loop_dio and the latter calls
fuse_direct_read/write for each iovec from iovec[] array. Thus we have as many
submitted fuse-requests as the number of elements in iovec[] array. This is
pure waste of resources and affects performance negatively especially for the
case of many small chunks (e.g. page-size) packed in one iovec[] array.

The patch-set amends situation in a natural way: let's simply pack as
many iovec[] segments to every fuse-request as possible.

To estimate performance improvement I used slightly modified fusexmp over
tmpfs (clearing O_DIRECT bit from fi->flags in xmp_open). The test opened
a file with O_DIRECT, then called readv/writev in a loop. An iovec[] for
readv/writev consisted of 32 segments of 4K each. The throughput on some
commodity (rather feeble) server was (in MB/sec):

        original / patched
writev: ~107     / ~480
readv:  ~114     / ~569

We're exploring possiblity to use fuse for our own distributed storage
implementation and big iovec[] arrays of many page-size chunks is typical
use-case for device virtualization thread performing i/o on behalf of
virtual-machine it serves.

Thanks,
Maxim

---

Maxim Patlasov (4):
      fuse: add basic support of iovec[] to fuse_req
      fuse: re-work fuse_get_user_pages() to operate on iovec[]
      fuse: re-work fuse_direct_io() to operate on iovec[]
      fuse: re-work fuse_direct_IO()


 fs/fuse/dev.c    |   52 ++++++++++++++++++-
 fs/fuse/file.c   |  145 ++++++++++++++++++++++++++++++------------------------
 fs/fuse/fuse_i.h |   12 ++++
 3 files changed, 140 insertions(+), 69 deletions(-)
