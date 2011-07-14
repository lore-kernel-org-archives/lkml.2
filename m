Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754027Ab1GNI5W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 04:57:22 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:50196 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753326Ab1GNI5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 04:57:19 -0400
Message-ID: <4E1EAEE9.80605@oracle.com>
Date: Thu, 14 Jul 2011 16:55:05 +0800
From: Joe Jin <joe.jin@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Lightning/1.0b3pre OracleBeehiveExtension/1.0.0.2-OracleInternal ObetStats/CATLAF_1292475699435-498544290 Thunderbird/3.1.10
MIME-Version: 1.0
To: Ian Campbell <Ian.Campbell@eu.citrix.com>
CC: Daniel Stodden <Daniel.Stodden@citrix.com>,
        Jens Axboe <jaxboe@fusionio.com>,
        "annie.li@oracle.com" <annie.li@oracle.com>,
        Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Kurt C Hackel <KURT.HACKEL@oracle.com>,
        Greg Marsden <greg.marsden@oracle.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@kernel.org" <stable@kernel.org>
Subject: Re: [PATCH resubmit] xen-blkfront: Don't send closing  notification
 to backend in blkfront_closing()
References: <4E1CEB34.5090907@oracle.com> <1310631209.634.444.camel@zakaz.uk.xensource.com>
In-Reply-To: <1310631209.634.444.camel@zakaz.uk.xensource.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4E1EAF01.00F5:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/14/11 16:13, Ian Campbell wrote:
> On Wed, 2011-07-13 at 01:47 +0100, Joe Jin wrote:
>> When we do block device attach/detach test with below steps, umount hang and the
>> guest unable to shutdown:
>>
>> 1. start guest with the latest kernel.
>> 2. attach new block device by xm block-attach in Dom0
>> 3. mount new disk in guest
>> 4. execute xm block-detach to detach the block device in dom0 until timeout
>> 5. try to unmount the disk in guest, umount hung. at here, any IOs to the 
>>    device will hang.
>>
>> Checking the code found when 'xm block-detach' set backend device's state to
>> 'XenbusStateClosing', frontend received the notification and blkfront_closing()
>> be called, at the moment, the disk still using by guest, so frontend refused
>> to close. In the blkfront_closing(), frontend send a notification to backend
>> said that the its state switched to 'Closing', when backend got the
>> event, it will disconnect from real device, at here any IO request will
>> be stuck, even tried to release the disk by umount.
>>
>> Per our test, below patch fix this issue.
> 
> It's worth mentioning here that the change to xbdev->state is picked up
> in blkif_release() when the device is closed and the disconnect happens
> at that point instead.

This is right, thanks for the suggestions.

> 
> I'm wondering if we might not be better off deferring the disconnect on
> the backend side until the frontend enters XenbusStateClosed instead of
> doing it in closing.

Yes this fix from backend side works too, also this looks reasonable than 
fix in frontend.

Konrad, any advice?

Thanks,
Joe

> 
> Ian
> 
>>
>> Signed-off-by: Joe Jin <joe.jin@oracle.com>
>> Signed-off-by: Annie Li <annie.li@oracle.com>
>> Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
>> Cc: Jens Axboe <jaxboe@fusionio.com>
>> Cc: stable@kernel.org
>>
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
> 
> 


-- 
Oracle <http://www.oracle.com>
Joe Jin | Team Leader, Software Development | +8610.6106.5624
ORACLE | Linux and Virtualization
No. 24 Zhongguancun Software Park, Haidian District | 100193 Beijing 
