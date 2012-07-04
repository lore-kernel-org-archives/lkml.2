Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755361Ab2GDQcx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 12:32:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43824 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751369Ab2GDQco (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 12:32:44 -0400
Message-ID: <4FF47023.7080206@redhat.com>
Date: Wed, 04 Jul 2012 18:32:35 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Sasha Levin <levinsasha928@gmail.com>
CC: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, kvm@vger.kernel.org
Subject: Re: [PATCH] virtio-blk: allow toggling host cache between writeback
 and writethrough
References: <1341321577-24435-1-git-send-email-pbonzini@redhat.com> <1341419217.18786.3.camel@lappy>
In-Reply-To: <1341419217.18786.3.camel@lappy>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 04/07/2012 18:26, Sasha Levin ha scritto:
> On Tue, 2012-07-03 at 15:19 +0200, Paolo Bonzini wrote:
>> diff --git a/include/linux/virtio_blk.h b/include/linux/virtio_blk.h
>> index e0edb40..18a1027 100644
>> --- a/include/linux/virtio_blk.h
>> +++ b/include/linux/virtio_blk.h
>> @@ -37,8 +37,9 @@
>>  #define VIRTIO_BLK_F_RO                5       /* Disk is read-only */
>>  #define VIRTIO_BLK_F_BLK_SIZE  6       /* Block size of disk is available*/
>>  #define VIRTIO_BLK_F_SCSI      7       /* Supports scsi command passthru */
>> -#define VIRTIO_BLK_F_FLUSH     9       /* Cache flush command support */
>> +#define VIRTIO_BLK_F_WCE       9       /* Writeback mode enabled after reset */
>>  #define VIRTIO_BLK_F_TOPOLOGY  10      /* Topology information is available */
>> +#define VIRTIO_BLK_F_CONFIG_WCE        11      /* Writeback mode available in config */ 
> 
> Wouldn't this change break any usermode code that implements virtio-blk?

No, the change is really just clarifying the existing spec, and
mandating that virtio-blk implementations follow certain assumptions of
the Linux driver.

In particular, the Linux driver is already assuming that the host
exposes VIRTIO_BLK_F_FLUSH if and only if it exposes a volatile write
cache.  This works because if you have a writeback cache, but provide no
way to flush it, the guest driver really cannot do anything about it
anyway.  Might as well treat it as writethrough, i.e. blk_queue_flush(q, 0).

QEMU in fact has already behaved like that, and even called the flag
VIRTIO_BLK_F_WCACHE instead of VIRRTIO_BLK_F_FLUSH.

Paolo
