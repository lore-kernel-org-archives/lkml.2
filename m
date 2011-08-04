Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751796Ab1HDG4s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 02:56:48 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:37560 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934Ab1HDG4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 02:56:42 -0400
Message-ID: <4E3A4289.4060403@oracle.com>
Date: Thu, 04 Aug 2011 14:56:09 +0800
From: Joe Jin <joe.jin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Daniel Stodden <daniel.stodden@citrix.com>,
        Jens Axboe <jaxboe@fusionio.com>, Annie Li <annie.li@oracle.com>,
        Ian Campbell <Ian.Campbell@eu.citrix.com>,
        Kurt C Hackel <KURT.HACKEL@oracle.com>,
        Greg Marsden <greg.marsden@oracle.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -v2 0/3] xen-blkback: refactor vbd remove/disconnect.
References: <4E38E4A2.3070003@oracle.com> <20110803214947.GA12168@dumpdata.com>
In-Reply-To: <20110803214947.GA12168@dumpdata.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090203.4E3A42A2.00E6,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011年08月04日 05:49, Konrad Rzeszutek Wilk wrote:
> On Wed, Aug 03, 2011 at 02:03:14PM +0800, Joe Jin wrote:
>> This patchset is a backport and original patch author is Daniel Stodden:
>> http://xenbits.xen.org/hg/XCP/linux-2.6.32.pq.hg/file/tip/CA-7672-blkback-shutdown.patch
>>
>> Initial issue:
>>   When we do block device attach/detach test with below steps, umount hang
>>   in guest and the guest unable to shutdown:
> 
> So the patchset looks good and it fixes the guest hanging.. but
>>   
>>   1. start guest with the latest kernel.
>>   2. attach new block device by xm block-attach in Dom0
> 
> So I think your patch while it fixes this problem it introduces a bug:
> 
> I did this in Dom0:
> 
> 18:10:23 # 5 :~/
>> xm block-attach 1 phy:/dev/sda xvda w
> 
> and did _not_ attach the disk in the guest. Then I did
> 
> 
> 18:10:35 # 6 :~/
>> xm block-list 1
> Vdev  BE handle state evt-ch ring-ref BE-path
> 51712  0    0     4      18     770   /local/domain/0/backend/vbd/1/51712
> 
> 18:10:39 # 7 :~/
>> xm block-detach 1 51712
> 
> 18:10:46 # 8 :~/
>> xm block-list 1
> 
> 
> 
> If I try the same sequence of events with your patch, I get this:
> 
> 1:28:06 # 1 :~/ 
>> xm list
> Name                                        ID   Mem VCPUs      State   Time(s)
> Domain-0                                     0  1500     4     r-----   1246.6
> sda                                          2  2048     2     -b----   1034.7
> sdb                                          6  2048     2     -b----      3.4
> 21:28:09 # 2 :~/ 
>> xm block-list 6
> 
> 21:28:22 # 4 :~/ 
>> xm block-attach 6 phy:/dev/sdb xvda w
> 
> [did not do anything in the guest]
> 21:28:33 # 5 :~/ 
>> xm block-list 6
> Vdev  BE handle state evt-ch ring-ref BE-path
> 51712  0    0     4      18     770   /local/domain/0/backend/vbd/6/51712  
> 
> 21:28:37 # 6 :~/ 
>> xm block-detach 6 51712
> Error: Device 51712 (vbd) could not be disconnected.
> Usage: xm block-detach <Domain> <DevId> [-f|--force]
> 
> Destroy a domain's virtual block device.
> 
> 21:30:30 # 7 :~/
> 
> Any ideas?
Konrad,

Thanks for the finding.

Review the patch looked like it caused by below piece of codes in patch3:
        case XenbusStateClosed:
-               xenbus_switch_state(dev, XenbusStateClosed);
-               if (xenbus_dev_is_online(dev))
-                       break;
-               /* fall through if not online */
+               if (!xenvbd_kthread_remove(be))
+                       xenvbd_signal_shutdown(be);
+               break;
+
        case XenbusStateUnknown:
-               /* implies blkif_disconnect() via blkback_remove() */
+               /* implies xen_blkif_disconnect() via blkback_remove() */
                device_unregister(&dev->dev);
                break;

When device's state switched to XenbusStateClosed, did not unregister the device.
Will send new patches for this.

Regards,
Joe

>>   3. mount new disk in guest
>>   4. execute xm block-detach to detach the block device in dom0 until timeout
>>   5. try to unmount the disk in guest, umount hung. at here, any IOs to the 
>>      device will hang.
>>   
>> Root cause:
>>   This caused by 'xm block-detach' in Dom0 set backend device's state to
>>   'XenbusStateClosing', frontend received the notification and 
>>   blkfront_closing() be called, at the moment, the disk still using by guest,
>>   so frontend refused to close. In the blkfront_closing(), frontend send a
>>   notification to backend said that the its state switched to 'Closing', when
>>   backend got the event, it will disconnect from real device, at here any IO
>>   request will be stuck, even tried to release the disk by umount.
>>
>>   So this may fix either frontend or backend, I have send a fix for frontend:
>>   https://lkml.org/lkml/2011/7/8/159
>>   Ian think we should fix it from backend and he pointed out Daniel Stodden have
>>   submitted a patch(see above link) for xen-blkback, I tried it and it works 
>>   well.
>>
>> Changes:
>>   v2:
>>     - Reformat code style.
>>     - Per Knoard suggestions, change some int defines to bool.
>>
>>  drivers/block/xen-blkback/blkback.c |   10 +--
>>  drivers/block/xen-blkback/common.h  |    5 +
>>  drivers/block/xen-blkback/xenbus.c  |  203 +++++++++++++++++++++++++++++++++++++++++++++++++++++++-------
>>  3 files changed, 192 insertions(+), 26 deletions(-)


-- 
Oracle <http://www.oracle.com>
Joe Jin | Team Leader, Software Development | +8610.6106.5624
ORACLE | Linux and Virtualization
No. 24 Zhongguancun Software Park, Haidian District | 100193 Beijing 
