Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751432Ab2HCFGb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 01:06:31 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:46214 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798Ab2HCFGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 01:06:30 -0400
Date: Fri, 3 Aug 2012 13:07:45 +0800
From: majianpeng <majianpeng@gmail.com>
To: axboe <axboe@kernel.dk>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] block: Don't use static to define "void *p" in show_partition_start().
X-Priority: 3
X-Has-Attach: no
X-Mailer: Foxmail 7.0.1.91[en]
Mime-Version: 1.0
Message-ID: <201208031307389214790@gmail.com>
Content-Type: text/plain;
	charset="gb2312"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q7356bp6025506

I met a odd prblem:read /proc/partitions may return zero.

I wrote a file test.c:
int main()
{
	char buff[4096];
	int ret;
	int fd;
	printf("pid=%d\n",getpid());
	while (1) {
		fd = open("/proc/partitions", O_RDONLY);
		if (fd < 0) {
			printf("open error %s\n", strerror(errno));
			return 0;
		}
		ret = read(fd, buff, 4096);
		if (ret <= 0)
			printf("ret=%d, %s, %ld\n", ret,
				strerror(errno), lseek(fd,0,SEEK_CUR));
		close(fd);
	}
	exit(0);
}

You can reproduce by:
1:while true;do cat /proc/partitions > /dev/null ;done
2:./test

I reviewed the code and found:
>>static void *show_partition_start(struct seq_file *seqf, loff_t *pos)
>>{
>>	static void *p;

>>	p = disk_seqf_start(seqf, pos);
>>	if (!IS_ERR_OR_NULL(p) && !*pos)
>>		seq_puts(seqf, "major minor  #blocks  name\n\n");
>>	return p;
>>}
		test								cat /proc/partitions
	p = disk_seqf_start()(Not NULL)
									p = disk_seqf_start()(NULL because pos)
	if (!IS_ERR_OR_NULL(p) && !*pos)

Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
---
 block/genhd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/genhd.c b/block/genhd.c
index cac7366..d839723 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -835,7 +835,7 @@ static void disk_seqf_stop(struct seq_file *seqf, void *v)
 
 static void *show_partition_start(struct seq_file *seqf, loff_t *pos)
 {
-	static void *p;
+	void *p;
 
 	p = disk_seqf_start(seqf, pos);
 	if (!IS_ERR_OR_NULL(p) && !*pos)
-- 
1.7.9.5
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
