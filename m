Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755383Ab2HOBXV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 21:23:21 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:54200 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006Ab2HOBXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 21:23:20 -0400
Date: Wed, 15 Aug 2012 09:23:38 +0800
From: kedacomkernel <kedacomkernel@gmail.com>
To: "Andy Lutomirski" <luto@amacapital.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-raid <linux-raid@vger.kernel.org>
Subject: Re: Re: O_DIRECT to md raid 6 is slow
References: <CALCETrWCu=UPATPdqWP=Gpvswv-RDwaxfr1W1jxYtUMZsqKgSQ@mail.gmail.com> <201208150906343285670@gmail.com>, 
	<CALCETrUnb5jk7GdQnaXki8PVTjNFr7TG8Vfmyd-=0BuSqtii8g@mail.gmail.com>
X-Priority: 3
X-Has-Attach: no
X-Mailer: Foxmail 7.0.1.91[en]
Mime-Version: 1.0
Message-ID: <201208150923354686934@gmail.com>
Content-Type: text/plain;
	charset="gb2312"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q7F1NPWj019127

On 2012-08-15 09:12 Andy Lutomirski <luto@amacapital.net> Wrote:
>Ubuntu's 3.2.0-27-generic.  I can test on a newer kernel tomorrow.
I guess maybe miss the blk_plug function.
Can you add this patch and retest.

Move unplugging for direct I/O from around ->direct_IO() down to
do_blockdev_direct_IO(). This implicitly adds plugging for direct
writes.
 
CC: Li Shaohua <shli@fusionio.com>
Acked-by: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/direct-io.c |    5 +++++
 mm/filemap.c   |    4 ----
 2 files changed, 5 insertions(+), 4 deletions(-)
 
--- linux-next.orig/mm/filemap.c 2012-08-05 16:24:47.859465122 +0800
+++ linux-next/mm/filemap.c 2012-08-05 16:24:48.407465135 +0800
@@ -1412,12 +1412,8 @@ generic_file_aio_read(struct kiocb *iocb
  retval = filemap_write_and_wait_range(mapping, pos,
  pos + iov_length(iov, nr_segs) - 1);
  if (!retval) {
- struct blk_plug plug;
-
- blk_start_plug(&plug);
  retval = mapping->a_ops->direct_IO(READ, iocb,
  iov, pos, nr_segs);
- blk_finish_plug(&plug);
  }
  if (retval > 0) {
  *ppos = pos + retval;
--- linux-next.orig/fs/direct-io.c 2012-07-07 21:46:39.531508198 +0800
+++ linux-next/fs/direct-io.c 2012-08-05 16:24:48.411465136 +0800
@@ -1062,6 +1062,7 @@ do_blockdev_direct_IO(int rw, struct kio
  unsigned long user_addr;
  size_t bytes;
  struct buffer_head map_bh = { 0, };
+ struct blk_plug plug;
 
  if (rw & WRITE)
  rw = WRITE_ODIRECT;
@@ -1177,6 +1178,8 @@ do_blockdev_direct_IO(int rw, struct kio
  PAGE_SIZE - user_addr / PAGE_SIZE);
  }
 
+ blk_start_plug(&plug);
+
  for (seg = 0; seg < nr_segs; seg++) {
  user_addr = (unsigned long)iov[seg].iov_base;
  sdio.size += bytes = iov[seg].iov_len;
@@ -1235,6 +1238,8 @@ do_blockdev_direct_IO(int rw, struct kio
  if (sdio.bio)
  dio_bio_submit(dio, &sdio);
 
+ blk_finish_plug(&plug);
+
  /*
   * It is possible that, we return short IO due to end of file.
   * In that case, we need to release all the pages we got hold on.
 
 
--
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éÝ¶¥Šwÿº{.nÇ+‰·¥Š{±þG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŽŠÝ¢j"ú¶m§ÿÿ¾«þG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
