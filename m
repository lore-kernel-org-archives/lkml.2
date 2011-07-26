Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752898Ab1GZB3v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 21:29:51 -0400
Received: from smtp-out.google.com ([74.125.121.67]:48026 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062Ab1GZB3p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 21:29:45 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=WrdfOQ02SnwFoqIvDB+pSXgpDzi5nBgZat4+LB06B8+8CJDDW/ernzsK83II612/U
	ohknWhZAxmhVgDQx9UBTQ==
MIME-Version: 1.0
In-Reply-To: <1311640646-12587-1-git-send-email-gaowanlong@cn.fujitsu.com>
References: <1311573834-7140-1-git-send-email-gaowanlong@cn.fujitsu.com> <1311640646-12587-1-git-send-email-gaowanlong@cn.fujitsu.com>
From: Paul Menage <menage@google.com>
Date: Mon, 25 Jul 2011 18:29:22 -0700
Message-ID: <CAJniumVKTYcJc6K=X1gGufQLX7dqNvaS-hgkzgz2st37Fyd8iw@mail.gmail.com>
Subject: Re: [PATCH v2] cgroup:be able to remove the record of unplugged device
To: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Cc: lizf@cn.fujitsu.com, axboe@kernel.dk, linux-kernel@vger.kernel.org,
        wanlong.gao@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'd be inclined to call that variable something like 'weight' rather
than 'temp', for clarity.

The change seems to fit the intent, AFAICS. But someone who has a
really good understanding of this file should review it.
blkiocg_file_write() in particular needs a bunch of comments to make
the logic more immediately clear, and to explain why it's OK to do
e.g. blkio_update_policy_rule() outside the lock.

Paul

On Mon, Jul 25, 2011 at 5:37 PM, Wanlong Gao <gaowanlong@cn.fujitsu.com> wrote:
> Hi Paul:
> How about this version?
> Thanks
>
> Write a record like:
> echo 8:0 1000 > blkio.throttle.read_bps_device
> to control the bps of the device.
> And then unplug this device without doing
> "8:0 0 > blkio.throttle.read_bps_device" to remove the record,
> it will not be removed until reboot, because if the device is removed,
> write some record will return "-ENODEV".
>
> With this patch, when the device is removed, then if we want to remove
> the record for this removed device, just write "0" then it'll not check
> if it is a present device, just remove the present record.
>
> Below is my test:
> 1. Test native.
> [root@test ~]# mount -t cgroup -o blkio nodev /cgroup/
> [root@test ~]# cd /cgroup/
> [root@test cgroup]# ll /dev/sd*
> brw-rw---- 1 root disk 8, 0 Jul 25 13:27 /dev/sda
> brw-rw---- 1 root disk 8, 1 Jul 25 13:27 /dev/sda1
> [root@test cgroup]# cat blkio.throttle.read_bps_device
> [root@test cgroup]# echo 8:0 1000 > blkio.throttle.read_bps_device
> [root@test cgroup]# cat blkio.throttle.read_bps_device
> 8:0     1000
> [root@test cgroup]# echo 8:0 0 > blkio.throttle.read_bps_device
> [root@test cgroup]# cat blkio.throttle.read_bps_device
> [root@test cgroup]# echo 8:0 1000 > blkio.throttle.read_bps_device
> [root@test cgroup]# cat blkio.throttle.read_bps_device
> 8:0     1000
> [root@test cgroup]# ll /dev/sd*
> ls: cannot access /dev/sd*: No such file or directory
> [root@test cgroup]# cat blkio.throttle.read_bps_device
> 8:0     1000
> [root@test cgroup]# echo 8:0 0 > blkio.throttle.read_bps_device
> -bash: echo: write error: No such device
> [root@test cgroup]# cat blkio.throttle.read_bps_device
> 8:0     1000
>
> 2.Test with this patch:
>
> [root@test ~]# mount -t cgroup -o blkio nodev /cgroup/
> [root@test ~]# ll /dev/sd*
> brw-rw---- 1 root disk 8, 0 Jul 25 13:11 /dev/sda
> brw-rw---- 1 root disk 8, 1 Jul 25 13:11 /dev/sda1
> [root@test ~]# cd /cgroup/
> [root@test cgroup]# echo 8:0 1000 > blkio.throttle.read_bps_device
> [root@test cgroup]# cat blkio.throttle.read_bps_device
> 8:0     1000
> [root@test cgroup]# ll /dev/sd*
> brw-rw---- 1 root disk 8, 0 Jul 25 13:11 /dev/sda
> brw-rw---- 1 root disk 8, 1 Jul 25 13:11 /dev/sda1
> [root@test cgroup]# echo 8:0 0 > blkio.throttle.read_bps_device
> [root@test cgroup]# cat blkio.throttle.read_bps_device
> [root@test cgroup]# ll /dev/sd*
> brw-rw---- 1 root disk 8, 0 Jul 25 13:11 /dev/sda
> brw-rw---- 1 root disk 8, 1 Jul 25 13:11 /dev/sda1
> [root@test cgroup]# echo 8:0 2000 > blkio.throttle.read_bps_device
> [root@test cgroup]# cat blkio.throttle.read_bps_device
> 8:0     2000
>
> [root@test cgroup]# ll /dev/sd*
> ls: cannot access /dev/sd*: No such file or directory
> [root@test cgroup]# cat blkio.throttle.read_bps_device
> 8:0     2000
> [root@test cgroup]# echo 8:0 0 > blkio.throttle.read_bps_device
> [root@test cgroup]# cat blkio.throttle.read_bps_device
> [root@test cgroup]# echo 8:0 1000 > blkio.throttle.read_bps_device
> -bash: echo: write error: No such device
> [root@test cgroup]# echo 8:0 01100 > blkio.throttle.read_bps_device
> -bash: echo: write error: No such device
> [root@test cgroup]#
>
> Signed-off-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>
> ---
>  block/blk-cgroup.c |   12 ++++++------
>  1 files changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
> index bcaf16e..4e81170 100644
> --- a/block/blk-cgroup.c
> +++ b/block/blk-cgroup.c
> @@ -826,19 +826,19 @@ static int blkio_policy_parse_and_set(char *buf,
>
>        dev = MKDEV(major, minor);
>
> -       ret = blkio_check_dev_num(dev);
> +       ret = strict_strtoul(s[1], 10, &temp);
>        if (ret)
> +               return -EINVAL;
> +
> +       ret = blkio_check_dev_num(dev);
> +       if (ret && (temp != 0))
>                return ret;
>
>        newpn->dev = dev;
>
> -       if (s[1] == NULL)
> -               return -EINVAL;
> -
>        switch (plid) {
>        case BLKIO_POLICY_PROP:
> -               ret = strict_strtoul(s[1], 10, &temp);
> -               if (ret || (temp < BLKIO_WEIGHT_MIN && temp > 0) ||
> +               if ((temp < BLKIO_WEIGHT_MIN && temp > 0) ||
>                        temp > BLKIO_WEIGHT_MAX)
>                        return -EINVAL;
>
> --
> 1.7.6
>
>
