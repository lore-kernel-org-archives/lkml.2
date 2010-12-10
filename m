Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754424Ab0LJSkD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 13:40:03 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:52955 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753533Ab0LJSkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 13:40:01 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH 2/2] Add BLKGETQUEUEINFO for reading block queue attributes
Date: Fri, 10 Dec 2010 19:39:20 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc1+; KDE/4.5.1; x86_64; ; )
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, tytso@mit.edu,
        sandeen@redhat.com, adilger.kernel@dilger.ca, gregkh@suse.de,
        hch@infradead.org, axboe@kernel.dk
References: <1291908337-18805-1-git-send-email-lczerner@redhat.com> <1291908337-18805-3-git-send-email-lczerner@redhat.com>
In-Reply-To: <1291908337-18805-3-git-send-email-lczerner@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201012101939.20984.arnd@arndb.de>
X-Provags-ID: V02:K0:exr72XLOomJtKe7/DOlr8DVNkWSsHLKZ7EMUWgPaoJQ
 vMpeVb6uiaHGimfTbAUnLCmaTfIUtXPDHZnpHTWNnpALq1XFWN
 Nrn5wwAMV+75IDO51vDAvov8HqViFAzI/c85roFpEU0zyalZGx
 Wbtm0oZGZ194uNKEhzbjwe2P0UFV/f0kL4EeiRdZ0i+iaD3s5o
 WfraRuSNH4swHJVh68p5A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 09 December 2010 16:25:37 Lukas Czerner wrote:
> +enum blkq_info_type {
> +       BLKQ_REQUESTS = 0,
> +       BLKQ_RA,
> +       BLKQ_MAX_HW_SECTORS,
> +       BLKQ_MAX_SECTORS,
> +       BLKQ_MAX_SEGMENTS,
> +       BLKQ_MAX_INTEGRITY_SEGMENTS,
> +       BLKQ_MAX_SEGMENT_SIZE,
> +       BLKQ_IOSCHED,
> +       BLKQ_HW_SECTOR_SIZE,
> +       BLKQ_LOGICAL_BLOCK_SIZE,
> +       BLKQ_PHYSICAL_BLOCK_SIZE,
> +       BLKQ_IO_MIN,
> +       BLKQ_IO_OPT,
> +       BLKQ_DISCARD_GRANULARITY,
> +       BLKQ_DISCARD_MAX,
> +       BLKQ_DISCARD_ZEROES_DATA,
> +       BLKQ_NONROT,
> +       BLKQ_NOMERGES,
> +       BLKQ_RQ_AFFINITY,
> +       BLKQ_IOSTATS,
> +       BLKQ_RANDOM,
> +       BLKQ_END,               /* Last item = quantity of items */
> +};
> +
> +struct blk_queue_info {
> +       enum blkq_info_type type;
> +       unsigned long data;
> +};

You are adding another indirection to an indirect system call
here. Besides the problems that Greg mentioned, this is
also really ugly. If it turns out that we want an ioctl interface
for this after all, better make it either one command per value,
or one data structure that contains all the values (plus some
reserved fields for future extensions).

Furthermore, you should use neither enum nor long data types
in a data structure that is used as an ABI. Use either __u32
or __u64 here, and make sure you have no padding in the middle
or at the end if you mix the two.

> diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
> index 30b8815..71bd06c 100644
> --- a/include/linux/sysfs.h
> +++ b/include/linux/sysfs.h
> @@ -112,6 +112,7 @@ struct bin_attribute {
>  struct sysfs_ops {
>         ssize_t (*show)(struct kobject *, struct attribute *,char *);
>         ssize_t (*store)(struct kobject *,struct attribute *,const char *, size_t);
> +       ssize_t (*get)(struct kobject *, struct attribute *, void *);
>  };
>  

This looks like it can significantly add to the .data size of the kernel.

	Arnd
