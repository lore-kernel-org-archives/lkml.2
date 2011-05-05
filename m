Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755811Ab1EESa7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 14:30:59 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:31204 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755670Ab1EESa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 14:30:58 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, jaxboe@fusionio.com
Cc: xen-devel@lists.xensource.com, hch@infradead.org,
        stefano.stabellini@eu.citrix.com, Ian.Campbell@citrix.com,
        pasik@iki.fi
Subject: [PATCH v3.1] xen block backend.
Date: Thu,  5 May 2011 14:11:32 -0400
Message-Id: <1304619093-22354-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.4.1
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A090208.4DC2EB8C.001A:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patch implements the Xen block backend driver for
upstream Linux. This is the host side counterpart to the frontend driver
in drivers/block/xen-blkfront.c. The PV protocol is also implemented by
frontend drivers in other OSes too, such as the BSDs and even Windows.

There is a QEMU version of this PV protocol called 'qdisk'. The performance
of it (after tweaking it to use AIO [1]) is inferior compared to the one
I am posting here: http://thread.gmane.org/gmane.linux.kernel/1129246

Changelog since posting:
[v3: https://lkml.org/lkml/2011/4/20/403]
 - dropped 'feature-barrier' support
 - added 'feature-flush-cache' support
 - tested w/ NetBSD unstable, SLES11, RHEL5, 2.6.36, 2.6.39-rc6 guests to check
   for barrier/flush issues.
 - fixed write performance issues

This driver has a long history as an out of tree driver but I am
submitting it here as a single monolithic patch to aid review. Once it
has been reviewed and is considered suitable for merging can we perhaps
consider merging the equivalent git branch which maintains much of
history?

The patch is based on the driver from the xen.git pvops kernel tree but
has been put through the checkpatch.pl wringer plus several manual
cleanup passes. It has also been moved from drivers/xen/blkback to
drivers/block/xen-blback.

The git tree of the broken out driver is available at:

git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git devel/xen-blkback-v3.1

Note that this driver depends on couple of fixes to the Xen backend
subsystem. Those are available in devel/backend.base.v3 branch and are
intended for the 2.6.40 merge window.

 drivers/block/Kconfig               |    8 +
 drivers/block/Makefile              |    1 +
 drivers/block/xen-blkback/Makefile  |    3 +
 drivers/block/xen-blkback/blkback.c |  812 +++++++++++++++++++++++++++++++++++
 drivers/block/xen-blkback/common.h  |  129 ++++++
 drivers/block/xen-blkback/xenbus.c  |  769 +++++++++++++++++++++++++++++++++
 include/xen/blkif.h                 |  122 ++++++
 include/xen/interface/io/blkif.h    |   13 +
 8 files changed, 1857 insertions(+), 0 deletions(-)

[1]: http://darnok.org/xen/qdisk_vs_blkback_v3.1/qemu-enable-aio.patch
