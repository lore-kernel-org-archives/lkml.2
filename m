Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758726Ab2DJNQ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 09:16:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31714 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754975Ab2DJNQ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 09:16:28 -0400
Message-ID: <4F84329A.60703@redhat.com>
Date: Tue, 10 Apr 2012 16:16:10 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120316 Thunderbird/11.0
MIME-Version: 1.0
To: Ren Mingxin <renmx@cn.fujitsu.com>
CC: mst@redhat.com, rusty@rustcorp.com.au, axboe@kernel.dk, tj@kernel.org,
        James.Bottomley@HansenPartnership.com, asamymuthupa@micron.com,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH] virtio_blk: Add help function to format mass of disks
References: <1334042885-8330-1-git-send-email-renmx@cn.fujitsu.com>
In-Reply-To: <1334042885-8330-1-git-send-email-renmx@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/10/2012 10:28 AM, Ren Mingxin wrote:
> The current virtio block's naming algorithm just supports 18278
> (26^3 + 26^2 + 26) disks. If there are mass of virtio blocks,
> there will be disks with the same name.
>
> Based on commit 3e1a7ff8a0a7b948f2684930166954f9e8e776fe, I add
> function "virtblk_name_format()" for virtio block to support mass
> of disks naming.
>
> Signed-off-by: Ren Mingxin <renmx@cn.fujitsu.com>
> ---
>  drivers/block/virtio_blk.c |   38 ++++++++++++++++++++++++++------------
>  1 files changed, 26 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
> index c4a60ba..86516c8 100644
> --- a/drivers/block/virtio_blk.c
> +++ b/drivers/block/virtio_blk.c
> @@ -374,6 +374,31 @@ static int init_vq(struct virtio_blk *vblk)
>  	return err;
>  }
>  
> +static int virtblk_name_format(char *prefix, int index, char *buf, int buflen)
> +{
> +	const int base = 'z' - 'a' + 1;
> +	char *begin = buf + strlen(prefix);
> +	char *begin = buf + strlen(prefix);

Duplicate line.

> +	char *end = buf + buflen;
> +	char *p;
> +	int unit;
> +
> +	p = end - 1;
> +	*p = '\0';
> +	unit = base;

Why not use 'base' below?  neither unit nor base change.

> +	do {
> +		if (p == begin)
> +			return -EINVAL;
> +		*--p = 'a' + (index % unit);
> +		index = (index / unit) - 1;
> +	} while (index >= 0);
> +
> +	memmove(begin, p, end - p);
> +	memcpy(buf, prefix, strlen(prefix));
> +
> +	return 0;
> +}
> +
>

-- 
error compiling committee.c: too many arguments to function

