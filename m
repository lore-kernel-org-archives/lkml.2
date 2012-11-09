Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755024Ab2KIXhh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 18:37:37 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:58253 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004Ab2KIXhe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 18:37:34 -0500
Message-ID: <509D93BA.2090202@redhat.com>
Date: Sat, 10 Nov 2012 00:37:30 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121016 Thunderbird/16.0.1
MIME-Version: 1.0
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
CC: target-devel <target-devel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        James Bottomley <JBottomley@Parallels.com>,
        Christoph Hellwig <hch@lst.de>, stable@vger.kernel.org
Subject: Re: [PATCH] virtio-scsi: Fix incorrect lock release order in virtscsi_kick_cmd
References: <1352442592-2162-1-git-send-email-nab@linux-iscsi.org>  <509CC210.8090908@redhat.com> <1352489476.29589.544.camel@haakon2.linux-iscsi.org>
In-Reply-To: <1352489476.29589.544.camel@haakon2.linux-iscsi.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 09/11/2012 20:31, Nicholas A. Bellinger ha scritto:
>> That's done on purpose.  After you do virtqueue_add_buf, you don't need
>> the sg list anymore, nor the lock that protects it.  The cover letter is
>> at https://lkml.org/lkml/2012/6/13/295 and had this text:
>>
>>   This series reorganizes the locking in virtio-scsi, introducing
>>   separate scatterlists for each target and "pipelining" the locks so
>>   that one command can be queued while the other is prepared.  This
>>   improves performance when there are multiple in-flight operations.
>>
>> In fact, the patch _introduces_ wrong locking because
>> virtqueue_kick_prepare needs the vq_lock.
>>
>> Perhaps what you want is separate local_irq_save/local_irq_restore?
> 
> Ahh, that makes more sense now.
> 
> Just noticed this while reviewing code that using one spinlock flag's to
> release the other looks suspicious, minus the ordering bit..
> 
> Using local_irq_* would probably be cleaner than swapping flags between
> different locks, and a short comment here would be helpful to explain
> the locking order context.

Well, my plan is to improve the virtio API so I can reuse the higher
layer's scatterlist, and get rid of the lock (not just of the funny
order) altogether. :)  Queuing requests is really performance-sensitive,
and it can use any optimization.

But if I can't get to it quick, I'll queue a cleanup using local_irq_*.

Paolo
