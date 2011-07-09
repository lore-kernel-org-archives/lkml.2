Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752175Ab1GIA07 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 20:26:59 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:44755 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098Ab1GIA05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 20:26:57 -0400
X-Greylist: delayed 61917 seconds by postgrey-1.27 at vger.kernel.org; Fri, 08 Jul 2011 20:26:57 EDT
Message-ID: <4E17A01F.8060505@oracle.com>
Date: Sat, 09 Jul 2011 08:26:07 +0800
From: Joe Jin <joe.jin@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Lightning/1.0b3pre OracleBeehiveExtension/1.0.0.2-OracleInternal ObetStats/CATLAF_1292475699435-498544290 Thunderbird/3.1.10
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Daniel Stodden <daniel.stodden@citrix.com>,
        Jens Axboe <jaxboe@fusionio.com>, annie.li@oracle.com,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Kurt C Hackel <KURT.HACKEL@oracle.com>,
        Greg Marsden <greg.marsden@oracle.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: xen-blkfront: Don't send closing  notification to backend in
 blkfront_closing()
References: <4E16AE55.50500@oracle.com> <20110708160414.GA30120@dumpdata.com>
In-Reply-To: <20110708160414.GA30120@dumpdata.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090208.4E17A04B.0030:SCFSTAT5015188,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Konrad,

Thanks for the reply, see comments in lines.

On 07/09/11 00:04, Konrad Rzeszutek Wilk wrote:
> On Fri, Jul 08, 2011 at 03:14:29PM +0800, Joe Jin wrote:
>> When we do block attach detach test with below steps, umount hang and the
>> guest unable to shutdown:
>>
>> 1. start guest with the latest kernel.
>> 2. attach new disk by xm-attach in Dom0
>> 3. mount new disk in guest
>> 4. detach the disk by xm-detach in dom0
> 
> I think you mean xm block-detach and xm-attach?

You are right and sorry for confusing.

> 
> I tried with and without your patch and in both cases I get
> this in my guest:
> 
> sh-4.1# mount /dev/xvda /test
> [  385.949749] EXT3-fs: barriers not enabled
> [  385.960173] kjournald starting.  Commit interval 5 seconds
> [  385.960418] EXT3-fs (xvda): using internal journal
> [  385.960427] EXT3-fs (xvda): mounted filesystem with writeback data mode
> sh-4.1# [  411.176887] vbd vbd-51712: 16 Device in use; refusing to close
> 
> The commands on the other side (Dom0) were:
> 
> [root@tst009 ~]# xm block-list 6
> Vdev  BE handle state evt-ch ring-ref BE-path
> 51712  0    0     4      12     770   /local/domain/0/backend/vbd/6/51712
> [root@tst009 ~]# xm block-detach 6 51712
> Error: Device 51712 (vbd) could not be disconnected. 
> Usage: xm block-detach <Domain> <DevId> [-f|--force]
> 

The error caused by xm block-detach timeout  to waiting the dev's state switch
to Closed.

> Destroy a domain's virtual block device.
> [root@tst009 ~]# xm block-detach 6 51712 -f
> 

With "--force", it always success but frontend did not disconnected if device 
opened by someone.

> 
>> 5. umount the partition/disk in guest, command hung. exactly at here, any
>>    IO request to the partition/disk will hang.
> 
> I get that with the patch and without it:
> 
> sh-4.1#
> sh-4.1# [  519.814048] block xvda: device/vbd/51712 was hot-unplugged, 1 stale handles
> 
> sh-4.1# df -h
> Filesystem            Size  Used Avail Use% Mounted on
> none                  490M  120K  490M   1% /dev
> none                  490M  131M  359M  27% /lib/modules/3.0.0-rc6-00052-g3edce4b-dirty
> shm                    10M     0   10M   0% /dev/shm
> var_tmp                10M     0   10M   0% /var/tmp
> /dev/xvda              20G  173M   19G   1% /test
> sh-4.1# umount /test
> 
> Any ideas?

This caused by backend kthread stopped, any IO request to the real device will hang, that
is the patch intend to resolving.

Thanks,
Joe

>>
>> Checking the code we found when xm-detach command set backend state to 
>> Closing, will trigger blkback_changed() -> blkfront_closing() call.
>> At the moment, the disk still opened by guest, so frontend will refuse the 
>> request, but in the blkfront_closing(), it send a notification to backend 
>> said that the frontend state switched to Closing, when backend got the
>> event, it will disconnect from real device, at here any IO request will
>> be stuck, even tried to release the disk by umount.
>>
>> Per our test, below patch fix this issue.
>>
>> Signed-off-by: Joe Jin <joe.jin@oracle.com>
>> Signed-off-by: Annie Li <annie.li@oracle.com>
>> ---
>>  xen-blkfront.c |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
>> index b536a9c..f6d8ac2 100644
>> --- a/drivers/block/xen-blkfront.c
>> +++ b/drivers/block/xen-blkfront.c
>> @@ -1088,7 +1088,7 @@ blkfront_closing(struct blkfront_info *info)
>>  	if (bdev->bd_openers) {
>>  		xenbus_dev_error(xbdev, -EBUSY,
>>  				 "Device in use; refusing to close");
>> -		xenbus_switch_state(xbdev, XenbusStateClosing);
>> +		xbdev->state = XenbusStateClosing;
>>  	} else {
>>  		xlvbd_release_gendisk(info);
>>  		xenbus_frontend_closed(xbdev);

