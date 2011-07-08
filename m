Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754095Ab1GHQEe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 12:04:34 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:21697 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752207Ab1GHQEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 12:04:32 -0400
Date: Fri, 8 Jul 2011 12:04:14 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Joe Jin <joe.jin@oracle.com>
Cc: Daniel Stodden <daniel.stodden@citrix.com>,
        Jens Axboe <jaxboe@fusionio.com>, annie.li@oracle.com,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Kurt C Hackel <KURT.HACKEL@oracle.com>,
        Greg Marsden <greg.marsden@oracle.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: xen-blkfront: Don't send closing  notification to backend in
 blkfront_closing()
Message-ID: <20110708160414.GA30120@dumpdata.com>
References: <4E16AE55.50500@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E16AE55.50500@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4E172A8C.0076:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 08, 2011 at 03:14:29PM +0800, Joe Jin wrote:
> When we do block attach detach test with below steps, umount hang and the
> guest unable to shutdown:
> 
> 1. start guest with the latest kernel.
> 2. attach new disk by xm-attach in Dom0
> 3. mount new disk in guest
> 4. detach the disk by xm-detach in dom0

I think you mean xm block-detach and xm-attach?

I tried with and without your patch and in both cases I get
this in my guest:

sh-4.1# mount /dev/xvda /test
[  385.949749] EXT3-fs: barriers not enabled
[  385.960173] kjournald starting.  Commit interval 5 seconds
[  385.960418] EXT3-fs (xvda): using internal journal
[  385.960427] EXT3-fs (xvda): mounted filesystem with writeback data mode
sh-4.1# [  411.176887] vbd vbd-51712: 16 Device in use; refusing to close

The commands on the other side (Dom0) were:

[root@tst009 ~]# xm block-list 6
Vdev  BE handle state evt-ch ring-ref BE-path
51712  0    0     4      12     770   /local/domain/0/backend/vbd/6/51712
[root@tst009 ~]# xm block-detach 6 51712
Error: Device 51712 (vbd) could not be disconnected. 
Usage: xm block-detach <Domain> <DevId> [-f|--force]

Destroy a domain's virtual block device.
[root@tst009 ~]# xm block-detach 6 51712 -f


> 5. umount the partition/disk in guest, command hung. exactly at here, any
>    IO request to the partition/disk will hang.

I get that with the patch and without it:

sh-4.1#
sh-4.1# [  519.814048] block xvda: device/vbd/51712 was hot-unplugged, 1 stale handles

sh-4.1# df -h
Filesystem            Size  Used Avail Use% Mounted on
none                  490M  120K  490M   1% /dev
none                  490M  131M  359M  27% /lib/modules/3.0.0-rc6-00052-g3edce4b-dirty
shm                    10M     0   10M   0% /dev/shm
var_tmp                10M     0   10M   0% /var/tmp
/dev/xvda              20G  173M   19G   1% /test
sh-4.1# umount /test

Any ideas?
> 
> Checking the code we found when xm-detach command set backend state to 
> Closing, will trigger blkback_changed() -> blkfront_closing() call.
> At the moment, the disk still opened by guest, so frontend will refuse the 
> request, but in the blkfront_closing(), it send a notification to backend 
> said that the frontend state switched to Closing, when backend got the
> event, it will disconnect from real device, at here any IO request will
> be stuck, even tried to release the disk by umount.
> 
> Per our test, below patch fix this issue.
> 
> Signed-off-by: Joe Jin <joe.jin@oracle.com>
> Signed-off-by: Annie Li <annie.li@oracle.com>
> ---
>  xen-blkfront.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
> index b536a9c..f6d8ac2 100644
> --- a/drivers/block/xen-blkfront.c
> +++ b/drivers/block/xen-blkfront.c
> @@ -1088,7 +1088,7 @@ blkfront_closing(struct blkfront_info *info)
>  	if (bdev->bd_openers) {
>  		xenbus_dev_error(xbdev, -EBUSY,
>  				 "Device in use; refusing to close");
> -		xenbus_switch_state(xbdev, XenbusStateClosing);
> +		xbdev->state = XenbusStateClosing;
>  	} else {
>  		xlvbd_release_gendisk(info);
>  		xenbus_frontend_closed(xbdev);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
