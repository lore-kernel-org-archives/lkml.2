Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754936Ab1I1Pmj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 11:42:39 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54971 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752993Ab1I1Pmh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 11:42:37 -0400
MIME-Version: 1.0
Date: Wed, 28 Sep 2011 21:12:35 +0530
Message-ID: <CADDb1s2Qhy1dNmjk+DhU=rf46A4X6kPdQ2rdpwK9zinY4Yv1mw@mail.gmail.com>
Subject: =?windows-1252?Q?BUG_in_kernel=3A_Wrong_Handling_of_USB_HDD=92s_in_scsi?=
	=?windows-1252?Q?glue=28slave=5Fconfigure=29_and_scsi=2Fsd=28sd=5Fread=5Fcache=5Ftype=29?=
From: Amit Sahrawat <amit.sahrawat83@gmail.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a USB HDD is connected to the device, it invokes slave_configure
to configure the USB HDD. In this function, whenever there is a SCSI
device of type TYPE_DISK, it sets:
	/* A number of devices have problems with MODE SENSE for
		 * page x08, so we will skip it. */
		sdev->skip_ms_page_8 = 1;

Now, as a part of SCSI device probing, in the function
sd_revalidate_disk()-->sd_read_cache_type(), there is a condition
if (sdp->skip_ms_page_8)
		goto defaults;
which becomes always true for all the USB HDD’s – the net result is
that the Write Cache is never considered for USB HDD(WCE = 0) –
“Assuming drive cache: write through”

What’s more – the QUEUE ordering which is marked for WCE=0 is
QUEUE_ORDERED_DRAIN, instead of QUEUE_ORDERED_DRAIN_FLUSH
This means there is no flushing of USB HDD internal cache (although
SYNCHRONIZE_CACHE is implemented as passed as command in
sd_prepare_flush) – queue_flush()(called in function
blk_do_ordered()-->start_ordered()) does not gets called in case of
QUEUE_ORDERED_DRAIN.

This causes a serious impact on USB HDD’s.

Please let me know in case I have missed something in my observations.

Thanks & Regards,
Amit Sahrawat
