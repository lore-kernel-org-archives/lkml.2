Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753084Ab1H3KjF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 06:39:05 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:49321 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751362Ab1H3KjB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 06:39:01 -0400
MIME-Version: 1.0
In-Reply-To: <20110830020100.GK3162@dastard>
References: <CAO+b5-pAY9Qn4OXKnxAHaBSrJi_6nTPOGZ+QgVg9iRdTCmequA@mail.gmail.com>
 <alpine.LFD.2.00.1108291342110.3904@dhcp-27-109.brq.redhat.com>
 <CAO+b5-qBCBuROmqSPHofQ4A4xxpaUVJL8AzGDHfy7k8QcWYzWw@mail.gmail.com> <20110830020100.GK3162@dastard>
From: Bart Van Assche <bvanassche@acm.org>
Date: Tue, 30 Aug 2011 12:38:40 +0200
X-Google-Sender-Auth: xMeli0dRHQzSb3LP6rtIvclNwgs
Message-ID: <CAO+b5-qGospnFZrubHGfBGk9U61xD6hQ4ZaYa6af-GuzTPquUw@mail.gmail.com>
Subject: Re: blkdev_issue_discard() hangs forever if the underlying storage
 device is removed
To: Dave Chinner <david@fromorbit.com>
Cc: Lukas Czerner <lczerner@redhat.com>, Jens Axboe <jaxboe@fusionio.com>,
        Mike Snitzer <snitzer@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 30, 2011 at 4:01 AM, Dave Chinner <david@fromorbit.com> wrote:
> On Mon, Aug 29, 2011 at 07:56:33PM +0200, Bart Van Assche wrote:
>> A key fact here is that the block device to which the discard request
>> was issued is gone, so the discard request will never finish
>> successfully. Do all relevant error paths guarantee that
>> blkdev_issue_discard() will finish in a finite time ?
>
> The underlying block device driver is supposed to handle timing out
> of lost IOs and causcwinge them to be completed with an error.
> blkdev_issue_discard() is simply waiting for that error to be
> delivered.
>
> If the driver has not detected that an outstanding request has not
> completed then that is a driver bug, not a bug in
> blkdev_issue_discard(). IOWs, you should be asking the ib_srp people
> why the in flight bio was not timed out or errored out when the
> block device abort was run....

Sorry, but the above doesn't make sense. This issue has nothing to do
with the ib_srp implementation: blkdev_issue_discard() was invoked by
mkfs after ib_srp had removed the SCSI host associated with the block
device. So none of the code in ib_srp has been invoked while
processing this blkdev_issue_discard() call.

Bart.
