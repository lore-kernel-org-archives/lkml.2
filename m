Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755343Ab1GCJOf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jul 2011 05:14:35 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57024 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754711Ab1GCJOc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jul 2011 05:14:32 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1107021320180.14703-100000@netrider.rowland.org>
References: <1309609482.2554.8.camel@mulgrave>
	<Pine.LNX.4.44L0.1107021320180.14703-100000@netrider.rowland.org>
Date: Sun, 3 Jul 2011 02:14:30 -0700
Message-ID: <CAA9_cmd7KV_CkvbB+nsc7LHui8gECB-0d4oWt+6cA0x21=crDg@mail.gmail.com>
Subject: Re: Linux 3.0 oopses when pulling a USB CDROM
From: Dan Williams <dan.j.williams@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: axboe@kernel.dk, James Bottomley <James.Bottomley@hansenpartnership.com>,
        Andi Kleen <andi@firstfloor.org>, Dave Jones <davej@redhat.com>,
        SCSI development list <linux-scsi@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        USB list <linux-usb@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 2, 2011 at 10:37 AM, Alan Stern <stern@rowland.harvard.edu> wrote:
> The second bug, which hit me but apparently not any of you, is that the
> request_queue's elevator gets deallocated while it is still in use.
> That's because __scsi_remove_device() calls scsi_free_queue(), which
> does blk_cleanup_queue(), which calls elevator_exit(), even though the
> device file is still open and more requests will be submitted when the
> file is closed.
>
> I'm not sure of the right fix for this.  One possibility is to move the
> scsi_free_queue() call to scsi_device_dev_release_usercontext().  Or
> maybe the elevator_exit() call should be moved to blk_release_queue().
>
> Also, I have no idea why this shows up with USB drives but not other
> SCSI transports.  A fluke of timing?
>

Not sure it's related, but it sounds like the hotplug failures being
seen with libsas hotplug.  Have not had a chance yet to track it down
further with isci, but mvsas developer Xiangliang Yu is reporting:

http://marc.info/?l=linux-scsi&m=130707166512002&w=2

He tracked it down to a suspected regression between .39-rc4 and
.39-rc5 but did not finalize the bisect.

The isci driver sees this and other signatures all seemingly related
to early device tear down and only when pulling a drive with in-flight
i/o.

--
Dan
