Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753688Ab1DFDFy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 23:05:54 -0400
Received: from mx2.fusionio.com ([64.244.102.31]:51040 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752049Ab1DFDFx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 23:05:53 -0400
X-ASG-Debug-ID: 1302059150-01de284cf810ddd0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4D9BD88C.3030807@fusionio.com>
Date: Wed, 6 Apr 2011 05:05:48 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Takuma Umeya <tumeya@redhat.com>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
        Christoph Hellwig <hch@lst.de>, john cooper <john.cooper@redhat.com>,
        Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] virtio_blk: decrement index when blockdevice is removed
References: <1969774563.659835.1301978981017.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com> <4D9AA3BC.6030907@fusionio.com> <87hbacw4fb.fsf@rustcorp.com.au>
X-ASG-Orig-Subj: Re: [PATCH] virtio_blk: decrement index when blockdevice is removed
In-Reply-To: <87hbacw4fb.fsf@rustcorp.com.au>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1302059150
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.60030
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-04-06 03:32, Rusty Russell wrote:
> On Tue, 05 Apr 2011 07:08:12 +0200, Jens Axboe <jaxboe@fusionio.com> wrote:
>> On 2011-04-05 06:49, Takuma Umeya wrote:
>>> When virtio block device is removed, index does not get decremented. When 
>>> another virtio disk is attached it uses the next device letter to the 
>>> one that is suppose to be available. 
>>>
>>> Signed-off-by: Takuma Umeya <tumeya@redhat.com>
>>>
>>> diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
>>> index 6ecf89c..730e7af 100644
>>> --- a/drivers/block/virtio_blk.c
>>> +++ b/drivers/block/virtio_blk.c
>>> @@ -489,6 +489,7 @@ static void __devexit virtblk_remove(struct virtio_device *vdev)
>>>         mempool_destroy(vblk->pool);
>>>         vdev->config->del_vqs(vdev);
>>>         kfree(vblk);
>>> +       index--;
>>>  }
>>>  
>>>  static const struct virtio_device_id id_table[] = {
>>
>> What happens when you delete a device that isn't the last one?
> 
> Obviously we should do something cleverer for assigning drives.
> 
> It might be a cute if genhd gave us a function to get the next free
> index for a given major number, and format it for us, like so:
> 
>       /* Return the next available minor for a given @major, at least
>        * @spacing after the previous and, and append appropriate letters
>        * to @name if it's not NULL.  -ve errno on fail (-ENOSPC?). */
>       int disk_next_minor(int major, unsigned spacing, char *name);
> 
> A trivial optimization would be to remember the last major and max minor
> (resetting that if any disks are removed).
> 
> This could clean up other code, too.

Something like idr would be a good fit for this. But yes, adding some
helpers for this might not hurt...

-- 
Jens Axboe
