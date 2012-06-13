Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754379Ab2FMP1s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 11:27:48 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:43296 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751698Ab2FMP1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 11:27:46 -0400
From: Namjae Jeon <linkinjeon@gmail.com>
To: James.Bottomley@HansenPartnership.com, gregkh@linuxfoundation.org,
        mdharm-usb@one-eyed-alien.net, stern@rowland.harvard.edu,
        sshtylyov@mvista.com, bvanassche@acm.org
Cc: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>
Subject: [PATCH v4 0/3] scsi: fix internal write cache issue on usb hdd.
Date: Wed, 13 Jun 2012 11:27:27 -0400
Message-Id: <1339601248-3251-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

The numbers of USB HDDs(All USB HDD I checked) does not respond
correctly to scsi mode sense command for retrieving the write cache
page status. Even though write cache is enabled by default, due to
scsi driver assume that cache is not enabled which in turn might lead
to loss of data since data still will be in cache.
This result that all filesystems is not stable on USB HDD when the
device is unplugged abruptly, even though these are having journaling
feature. Our first trying is that scsi driver send ATA command
(ATA Pass through, #58) to USB HDD after failure from normal routine to
know write cache enable.
We have known it is dangerous after testing several USB HDD. some of
HDD is stalled by this command(A-DATA HDD). So we tried to make the
patch James's suggestion(usb quirk) on version 2 that add product ID
and verdor ID of USB HDD to USB quirk list after checking write cache.
All filesystem will be stable on USB HDD registered in quirk list.
And it will be updated continuously.

	scsi: set to WCE if usb cache quirk is present.
	usb: storage: add support for write cache quirk on usb hdd.
	usb: storage: update usb devices for write cache quirk in quirk.

 drivers/scsi/sd.c          |    9 +++++++--
 include/scsi/scsi_device.h |    1 +
 drivers/usb/storage/scsiglue.c |    5 +++++
 drivers/usb/storage/usb.c      |    5 ++++-
 include/linux/usb_usual.h      |    4 +++-
 drivers/usb/storage/unusual_devs.h |   24 ++++++++++++++++++++++++
 Documentation/kernel-parameters.txt |    2 ++
 7 files changed, 46 insertions(+), 4 deletions(-)
-- 
1.7.9.5

