Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753104Ab1GZCXb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 22:23:31 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50115 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752744Ab1GZCXY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 22:23:24 -0400
Message-ID: <4E2E251D.6040108@cn.fujitsu.com>
Date: Tue, 26 Jul 2011 10:23:25 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Wanlong Gao <gaowanlong@cn.fujitsu.com>
CC: menage@google.com, Vivek Goyal <vgoyal@redhat.com>, axboe@kernel.dk,
        linux-kernel@vger.kernel.org, wanlong.gao@gmail.com
Subject: Re: [PATCH v3] blk-cgroup:be able to remove the record of unplugged
 device
References: <1311573834-7140-1-git-send-email-gaowanlong@cn.fujitsu.com> <1311645400-19434-1-git-send-email-gaowanlong@cn.fujitsu.com>
In-Reply-To: <1311645400-19434-1-git-send-email-gaowanlong@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-07-26 10:22:27,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-07-26 10:22:28,
	Serialize complete at 2011-07-26 10:22:28
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

patch looks good to me, just some minor nits below..

09:56, Wanlong Gao wrote:
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
> 8:0	1000
> [root@test cgroup]# echo 8:0 0 > blkio.throttle.read_bps_device
> [root@test cgroup]# cat blkio.throttle.read_bps_device
> [root@test cgroup]# echo 8:0 1000 > blkio.throttle.read_bps_device
> [root@test cgroup]# cat blkio.throttle.read_bps_device
> 8:0	1000
> [root@test cgroup]# ll /dev/sd*
> ls: cannot access /dev/sd*: No such file or directory
> [root@test cgroup]# cat blkio.throttle.read_bps_device
> 8:0	1000
> [root@test cgroup]# echo 8:0 0 > blkio.throttle.read_bps_device
> -bash: echo: write error: No such device
> [root@test cgroup]# cat blkio.throttle.read_bps_device
> 8:0	1000
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
> 8:0	1000
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
> 8:0	2000
> 
> [root@test cgroup]# ll /dev/sd*
> ls: cannot access /dev/sd*: No such file or directory
> [root@test cgroup]# cat blkio.throttle.read_bps_device
> 8:0	2000
> [root@test cgroup]# echo 8:0 0 > blkio.throttle.read_bps_device
> [root@test cgroup]# cat blkio.throttle.read_bps_device
> [root@test cgroup]# echo 8:0 1000 > blkio.throttle.read_bps_device
> -bash: echo: write error: No such device
> [root@test cgroup]# echo 8:0 01100 > blkio.throttle.read_bps_device
> -bash: echo: write error: No such device
> [root@test cgroup]#
> 

The changelog is too verbose. How about:

The bug is we're not able to remove the device from blkio cgroup's
per-device control files if it gets unplugged.

To reproduce the bug:

  # mount -t cgroup -o blkio xxx /cgroup
  # cd /cgroup
  # echo "8:0 1000" > blkio.throttle.read_bps_device
  # unplug the device
  # cat blkio.throttle.read_bps_device
  8:0	1000
  # echo "8:0 0" > blkio.throttle.read_bps_device
  -bash: echo: write error: No such device

After patching, the device removal will succeed.

> Signed-off-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>
> ---
>  block/blk-cgroup.c |   18 +++++++++---------
>  1 files changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
> index bcaf16e..246645c 100644
> --- a/block/blk-cgroup.c
> +++ b/block/blk-cgroup.c
> @@ -785,7 +785,7 @@ static int blkio_policy_parse_and_set(char *buf,
>  {
>  	char *s[4], *p, *major_s = NULL, *minor_s = NULL;
>  	int ret;
> -	unsigned long major, minor, temp;
> +	unsigned long major, minor, weight;
>  	int i = 0;
>  	dev_t dev;
>  	u64 bps, iops;
> @@ -826,25 +826,25 @@ static int blkio_policy_parse_and_set(char *buf,
>  
>  	dev = MKDEV(major, minor);
>  
> -	ret = blkio_check_dev_num(dev);
> +	ret = strict_strtoul(s[1], 10, &weight);
>  	if (ret)
> +		return -EINVAL;
> +
> +	ret = blkio_check_dev_num(dev);
> +	if (ret && (weight != 0))

unnecessary parentheses.

if (ret && weight != 0)

or

if (ret && !weight)

>  		return ret;
>  
>  	newpn->dev = dev;
>  
> -	if (s[1] == NULL)
> -		return -EINVAL;
> -
>  	switch (plid) {
>  	case BLKIO_POLICY_PROP:
> -		ret = strict_strtoul(s[1], 10, &temp);
> -		if (ret || (temp < BLKIO_WEIGHT_MIN && temp > 0) ||
> -			temp > BLKIO_WEIGHT_MAX)
> +		if ((weight < BLKIO_WEIGHT_MIN && weight > 0) ||
> +			weight > BLKIO_WEIGHT_MAX)
>  			return -EINVAL;

Normally we align the above lines this way:

if ((weight < BLKIO_WEIGHT_MIN && weight > 0) ||
    weight > BLKIO_WEIGHT_MAX)
	return -EINVAL;

>  
>  		newpn->plid = plid;
>  		newpn->fileid = fileid;
> -		newpn->val.weight = temp;
> +		newpn->val.weight = weight;
>  		break;
>  	case BLKIO_POLICY_THROTL:
>  		switch(fileid) {
