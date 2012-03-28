Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758182Ab2C1K6X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 06:58:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1566 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757857Ab2C1K6U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 06:58:20 -0400
Date: Wed, 28 Mar 2012 12:58:21 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Ren Mingxin <renmx@cn.fujitsu.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, LKML <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, jens.axboe@oracle.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] virtio_blk: add helper function to support mass of disks
 naming
Message-ID: <20120328105819.GD6194@redhat.com>
References: <4F72B5B3.6020602@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F72B5B3.6020602@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 28, 2012 at 02:54:43PM +0800, Ren Mingxin wrote:
>  Hi,
> 
> The current virtblk's naming algorithm just supports 26^3
> disks. If there are mass of virtblks(exceeding 26^3), there
> will be disks with the same name.
> 
> According to "sd_format_disk_name()", I add function
> "virtblk_name_format()" for virtblk to support mass of
> disks.
> 
> Signed-off-by: Ren Mingxin <renmx@cn.fujitsu.com>

Nod. This is basically what 3e1a7ff8a0a7b948f2684930166954f9e8e776fe
did. Except, maybe we should move this function into block core
instead of duplicating it? Where would be a good place to put it?
Jens, care to comment?

> ---
>  virtio_blk.c |   37 +++++++++++++++++++++++++------------
>  1 file changed, 25 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
> index c4a60ba..07b8bf9 100644
> --- a/drivers/block/virtio_blk.c
> +++ b/drivers/block/virtio_blk.c
> @@ -374,6 +374,30 @@ static int init_vq(struct virtio_blk *vblk)
>         return err;
>  }
> 
> +static int virtblk_name_format(char *prefix, int index, char *buf,
> int buflen)
> +{
> +       const int base = 'z' - 'a' + 1;
> +       char *begin = buf + strlen(prefix);
> +       char *begin = buf + strlen(prefix);
> +       char *end = buf + buflen;
> +       char *p;
> +       int unit;
> +
> +       p = end - 1;
> +       *p = '\0';
> +       unit = base;
> +       do {
> +               if (p == begin)
> +                       return -EINVAL;
> +               *--p = 'a' + (index % unit);
> +               index = (index / unit) - 1;
> +       } while (index >= 0);
> +
> +       memmove(begin, p, end - p);
> +       memcpy(buf, prefix, strlen(prefix));
> +
> +       return 0;
> +}
> +
>  static int __devinit virtblk_probe(struct virtio_device *vdev)
>  {
>         struct virtio_blk *vblk;
> @@ -442,18 +466,7 @@ static int __devinit virtblk_probe(struct
> virtio_device *vdev)
> 
>         q->queuedata = vblk;
> 
> -       if (index < 26) {
> -               sprintf(vblk->disk->disk_name, "vd%c", 'a' + index % 26);
> -       } else if (index < (26 + 1) * 26) {
> -               sprintf(vblk->disk->disk_name, "vd%c%c",
> -                       'a' + index / 26 - 1, 'a' + index % 26);
> -       } else {
> -               const unsigned int m1 = (index / 26 - 1) / 26 - 1;
> -               const unsigned int m2 = (index / 26 - 1) % 26;
> -               const unsigned int m3 =  index % 26;
> -               sprintf(vblk->disk->disk_name, "vd%c%c%c",
> -                       'a' + m1, 'a' + m2, 'a' + m3);
> -       }
> +       virtblk_name_format("vd", index, vblk->disk->disk_name,
> DISK_NAME_LEN);
> 
>         vblk->disk->major = major;
>         vblk->disk->first_minor = index_to_minor(index);
