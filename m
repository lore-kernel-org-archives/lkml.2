Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755108Ab1HCGEA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 02:04:00 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:17500 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754921Ab1HCGD4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 02:03:56 -0400
Message-ID: <4E38E4A2.3070003@oracle.com>
Date: Wed, 03 Aug 2011 14:03:14 +0800
From: Joe Jin <joe.jin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Daniel Stodden <daniel.stodden@citrix.com>,
        Jens Axboe <jaxboe@fusionio.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Annie Li <annie.li@oracle.com>,
        Ian Campbell <Ian.Campbell@eu.citrix.com>,
        Kurt C Hackel <KURT.HACKEL@oracle.com>
CC: Greg Marsden <greg.marsden@oracle.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Joe Jin <joe.jin@oracle.com>
Subject: [PATCH -v2 0/3] xen-blkback: refactor vbd remove/disconnect.
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A090206.4E38E4BB.003F,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset is a backport and original patch author is Daniel Stodden:
http://xenbits.xen.org/hg/XCP/linux-2.6.32.pq.hg/file/tip/CA-7672-blkback-shutdown.patch

Initial issue:
  When we do block device attach/detach test with below steps, umount hang
  in guest and the guest unable to shutdown:
  
  1. start guest with the latest kernel.
  2. attach new block device by xm block-attach in Dom0
  3. mount new disk in guest
  4. execute xm block-detach to detach the block device in dom0 until timeout
  5. try to unmount the disk in guest, umount hung. at here, any IOs to the 
     device will hang.
  
Root cause:
  This caused by 'xm block-detach' in Dom0 set backend device's state to
  'XenbusStateClosing', frontend received the notification and 
  blkfront_closing() be called, at the moment, the disk still using by guest,
  so frontend refused to close. In the blkfront_closing(), frontend send a
  notification to backend said that the its state switched to 'Closing', when
  backend got the event, it will disconnect from real device, at here any IO
  request will be stuck, even tried to release the disk by umount.

  So this may fix either frontend or backend, I have send a fix for frontend:
  https://lkml.org/lkml/2011/7/8/159
  Ian think we should fix it from backend and he pointed out Daniel Stodden have
  submitted a patch(see above link) for xen-blkback, I tried it and it works 
  well.

Changes:
  v2:
    - Reformat code style.
    - Per Knoard suggestions, change some int defines to bool.

 drivers/block/xen-blkback/blkback.c |   10 +--
 drivers/block/xen-blkback/common.h  |    5 +
 drivers/block/xen-blkback/xenbus.c  |  203 +++++++++++++++++++++++++++++++++++++++++++++++++++++++-------
 3 files changed, 192 insertions(+), 26 deletions(-)

