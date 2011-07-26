Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753472Ab1GZOom (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 10:44:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39941 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752331Ab1GZOof (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 10:44:35 -0400
Date: Tue, 26 Jul 2011 10:44:27 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Cc: menage@google.com, lizf@cn.fujitsu.com, axboe@kernel.dk,
        linux-kernel@vger.kernel.org, wanlong.gao@gmail.com
Subject: Re: [PATCH v3] blk-cgroup:be able to remove the record of unplugged
 device
Message-ID: <20110726144427.GB13780@redhat.com>
References: <1311573834-7140-1-git-send-email-gaowanlong@cn.fujitsu.com>
 <1311645400-19434-1-git-send-email-gaowanlong@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311645400-19434-1-git-send-email-gaowanlong@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 26, 2011 at 09:56:40AM +0800, Wanlong Gao wrote:
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

Ok, not checking for device presence while deleting a rule makes sense.
Some comments inline.

[..]
> 
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

Do not replace temp with name weight. The place you are parsing it,
it could be weight, bps or iops. So lets keep the generic name in
place.

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
>  		return ret;

Can you simplify above and just put a one comment also. Don't even call
blkio_check_dev_num() if we are removing the rule. 

/* For rule removal, do not check for device presence. */

if (temp != 0)
	ret = blkio_check_dev_num(dev);

Thanks
Vivek
