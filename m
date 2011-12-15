Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932436Ab1LOIud (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 03:50:33 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:39603 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932268Ab1LOIu3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 03:50:29 -0500
MIME-Version: 1.0
In-Reply-To: <1322208422-12346-1-git-send-email-Barry.Song@csr.com>
References: <1322208422-12346-1-git-send-email-Barry.Song@csr.com>
From: Barry Song <21cnbao@gmail.com>
Date: Thu, 15 Dec 2011 16:50:07 +0800
Message-ID: <CAGsJ_4ziRj1oEhmMYjc6yJvS2FHYn+uRWmSaggnJQQjqi=B6gw@mail.gmail.com>
Subject: Re: [PATCH v2] PM: HIBERNATION: skip the swap size check if the
 snapshot image size is anticipative
To: Barry Song <Barry.Song@csr.com>
Cc: pavel@ucw.cz, rjw@sisk.pl, linux-pm@lists.linux-foundation.org,
        workgroup.linux@csr.com, Xiangzhen Ye <Xiangzhen.Ye@csr.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Barry Song <Baohua.Song@csr.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel ,Rafael, any feedback?
-barry

2011/11/25 Barry Song <Barry.Song@csr.com>:
> From: Barry Song <baohua.song@csr.com>
>
> Current swsusp requires swap partitions even larger than real saved pages
> based on the worst compression ratio:
> but for an embedded system, which has limited storage space, then it might
> can't give the large partition to save snapshot.
> In the another way, some embedded systems can definitely know the most size
> needed for snapshot since they run some specific application lists.
> So this patch provides the possibility for users to tell kernel even
> the system has a little snapshot partition, but it is still enough.
> For example, if the system need to save 120MB memory, origin swsusp will require
> a 130MB partition to save snapshot. but if users know 30MB is enough for them(
> compressed image will be less than 30MB), they just make a 30MB partition by
> echo 0 > /sys/power/check_swap_size
>
> Signed-off-by: Barry Song <Baohua.Song@csr.com>
> Cc: Xiangzhen Ye <Xiangzhen.Ye@csr.com>
> ---
>  -v2:drop swap_enough bootargs and use /sys/power/check_swap_size node
>
>  Documentation/power/interface.txt |    5 +++++
>  kernel/power/hibernate.c          |   22 ++++++++++++++++++++++
>  kernel/power/power.h              |    2 ++
>  kernel/power/swap.c               |    9 +++++++++
>  4 files changed, 38 insertions(+), 0 deletions(-)
>
> diff --git a/Documentation/power/interface.txt b/Documentation/power/interface.txt
> index c537834..5e205f0 100644
> --- a/Documentation/power/interface.txt
> +++ b/Documentation/power/interface.txt
> @@ -47,6 +47,11 @@ Writing to this file will accept one of
>        'testproc'
>        'test'
>
> +/sys/power/check_swap_size controls whether we can skip checking the swap
> +partition size by worst compression ratio. If users know the swap partition
> +is enough for compressed snapshot, write 0 to /sys/power/check_swap_size.
> +It is useful for an embedded system with known running softwares.
> +
>  /sys/power/image_size controls the size of the image created by
>  the suspend-to-disk mechanism.  It can be written a string
>  representing a non-negative integer that will be used as an upper
> diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
> index 1c53f7f..5552473 100644
> --- a/kernel/power/hibernate.c
> +++ b/kernel/power/hibernate.c
> @@ -1024,11 +1024,33 @@ static ssize_t reserved_size_store(struct kobject *kobj,
>
>  power_attr(reserved_size);
>
> +static ssize_t check_swap_size_show(struct kobject *kobj, struct kobj_attribute *attr,
> +                              char *buf)
> +{
> +       return sprintf(buf, "%d\n", check_swap_size);
> +}
> +
> +static ssize_t check_swap_size_store(struct kobject *kobj, struct kobj_attribute *attr,
> +                               const char *buf, size_t n)
> +{
> +       int check_size;
> +
> +       if (sscanf(buf, "%d", &check_size) == 1) {
> +               check_swap_size = check_size;
> +               return n;
> +       }
> +
> +       return -EINVAL;
> +}
> +
> +power_attr(check_swap_size);
> +
>  static struct attribute * g[] = {
>        &disk_attr.attr,
>        &resume_attr.attr,
>        &image_size_attr.attr,
>        &reserved_size_attr.attr,
> +       &check_swap_size_attr.attr,
>        NULL,
>  };
>
> diff --git a/kernel/power/power.h b/kernel/power/power.h
> index 23a2db1..4f0fa78 100644
> --- a/kernel/power/power.h
> +++ b/kernel/power/power.h
> @@ -74,6 +74,8 @@ static struct kobj_attribute _name##_attr = { \
>
>  /* Preferred image size in bytes (default 500 MB) */
>  extern unsigned long image_size;
> +/* If 0, skip checking whether the swap size is enough for compressed snapshot */
> +extern int check_swap_size;
>  /* Size of memory reserved for drivers (default SPARE_PAGES x PAGE_SIZE) */
>  extern unsigned long reserved_size;
>  extern int in_suspend;
> diff --git a/kernel/power/swap.c b/kernel/power/swap.c
> index 11a594c..db90195 100644
> --- a/kernel/power/swap.c
> +++ b/kernel/power/swap.c
> @@ -37,6 +37,12 @@
>  #define HIBERNATE_SIG  "S1SUSPEND"
>
>  /*
> + * if users know swap partitions are enough for compressed snapshots,
> + * echo 0 > /sys/power/check_swap_size
> + */
> +int check_swap_size = 1;
> +
> +/*
>  *     The swap map is a data structure used for keeping track of each page
>  *     written to a swap partition.  It consists of many swap_map_page
>  *     structures that contain each an array of MAP_PAGE_ENTRIES swap entries.
> @@ -772,6 +778,9 @@ static int enough_swap(unsigned int nr_pages, unsigned int flags)
>        unsigned int free_swap = count_swap_pages(root_swap, 1);
>        unsigned int required;
>
> +       if (!check_swap_size)
> +               return 1;
> +
>        pr_debug("PM: Free swap pages: %u\n", free_swap);
>
>        required = PAGES_FOR_IO + ((flags & SF_NOCOMPRESS_MODE) ?
> --
> 1.7.1
