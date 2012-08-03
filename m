Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388Ab2HCIlx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 04:41:53 -0400
Received: from merlin.infradead.org ([205.233.59.134]:33999 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753238Ab2HCIlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 04:41:46 -0400
Message-ID: <501B8EBE.5040006@kernel.dk>
Date: Fri, 03 Aug 2012 10:41:34 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: majianpeng <majianpeng@gmail.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] block: Don't use static to define "void *p" in show_partition_start().
References: <201208031307389214790@gmail.com>
In-Reply-To: <201208031307389214790@gmail.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03/2012 07:07 AM, majianpeng wrote:
> I met a odd prblem:read /proc/partitions may return zero.
> 
> I wrote a file test.c:
> int main()
> {
> 	char buff[4096];
> 	int ret;
> 	int fd;
> 	printf("pid=%d\n",getpid());
> 	while (1) {
> 		fd = open("/proc/partitions", O_RDONLY);
> 		if (fd < 0) {
> 			printf("open error %s\n", strerror(errno));
> 			return 0;
> 		}
> 		ret = read(fd, buff, 4096);
> 		if (ret <= 0)
> 			printf("ret=%d, %s, %ld\n", ret,
> 				strerror(errno), lseek(fd,0,SEEK_CUR));
> 		close(fd);
> 	}
> 	exit(0);
> }
> 
> You can reproduce by:
> 1:while true;do cat /proc/partitions > /dev/null ;done
> 2:./test
> 
> I reviewed the code and found:
>>> static void *show_partition_start(struct seq_file *seqf, loff_t *pos)
>>> {
>>> 	static void *p;
> 
>>> 	p = disk_seqf_start(seqf, pos);
>>> 	if (!IS_ERR_OR_NULL(p) && !*pos)
>>> 		seq_puts(seqf, "major minor  #blocks  name\n\n");
>>> 	return p;
>>> }
> 		test								cat /proc/partitions
> 	p = disk_seqf_start()(Not NULL)
> 									p = disk_seqf_start()(NULL because pos)
> 	if (!IS_ERR_OR_NULL(p) && !*pos)
> 
> Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
> ---
>  block/genhd.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/block/genhd.c b/block/genhd.c
> index cac7366..d839723 100644
> --- a/block/genhd.c
> +++ b/block/genhd.c
> @@ -835,7 +835,7 @@ static void disk_seqf_stop(struct seq_file *seqf, void *v)
>  
>  static void *show_partition_start(struct seq_file *seqf, loff_t *pos)
>  {
> -	static void *p;
> +	void *p;
>  
>  	p = disk_seqf_start(seqf, pos);
>  	if (!IS_ERR_OR_NULL(p) && !*pos)

Huh, that looks like a clear bug. I've applied it, thanks.

-- 
Jens Axboe

