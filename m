Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756246Ab0LIP0T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 10:26:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36643 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752289Ab0LIP0S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 10:26:18 -0500
From: Lukas Czerner <lczerner@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, tytso@mit.edu, sandeen@redhat.com,
        adilger.kernel@dilger.ca, gregkh@suse.de, hch@infradead.org,
        axboe@kernel.dk, lczerner@redhat.com
Subject: [RFC PATCH 0/2 v1] Ioctl for reading block queue information
Date: Thu,  9 Dec 2010 16:25:35 +0100
Message-Id: <1291908337-18805-1-git-send-email-lczerner@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

For a long time it has been pretty painful to retrieve informations from
/sys/block/*/queue for particular block device. Not only it is painful
to retrieve informations within C tool, parsing strings, etc, but one
have to run into problem even finding the proper path in sysfs.

This patch set adds new block ioctl BLKGETQUEUEINFO, which is designed to
retrieve particular block queue attributes. I have tried to not to
create completely new interface, but since we already have those
information within block queue sysfs kobjects, rather retrieve it from
there.

So it binds enum blkq_info_type in include/linux/fs.h with
default_attrs[] definition within block/blk-sysfs.c for ordering
purposes, so the userspace has reliable way to address specific
block queue attribute.

In order to avoid string parsing (given that 99% of block queue sysfs
attributes are of unsigned long type) I have introduced new sysfs_ops
member *get which may be used to pass pointer to any type of data (unsigned
long in this case). Then this get method is used to withdraw information
through kobject->ktype->sysfs_ops.

Although there are some downsides of this approach I would like to discuss:

 1. In current state BLKGETQUEUEINFO and the whole infrastructure allow to
    retrieve only numeric values (no text), this means we are no able to
    retrieve schedule information.

 2. Adding new *get member into sysfs_ops. I see this as the most painful
    downside, however, when we have more subsystems adding ioctls like this,
    they can easily use this method, the same way I am using it now.

 3. One might say that this is basically promoting sysfs to API, but I would not
    so strict about this. We can always change this to be independent on sysfs,
    but I have choose this approach mainly because this way we are able to
    maintain just one engine with two interfaces.

 4. All this seems a little hackish :)

So, I would like to hear your comments on this, not just "this is entirely
stupid", but also "look, this may be the better way", because obviously we
can not be adding new ioctls for every piece of information (BLKDISCARDZEROES,
etc..) user-space needs.

Thanks!

-Lukas

---
[PATCH 1/2] blk-sysfs: Clean-up attribute definitions
[PATCH 2/2] Add BLKGETQUEUEINFO for reading block queue attributes

 block/blk-sysfs.c     |  370 +++++++++++++++++++------------------------------
 block/ioctl.c         |   32 +++++
 include/linux/fs.h    |   30 ++++
 include/linux/sysfs.h |    1 +
 4 files changed, 207 insertions(+), 226 deletions(-)

