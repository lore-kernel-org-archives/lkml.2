Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752828Ab2H0HZZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 03:25:25 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54657 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751610Ab2H0HZX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 03:25:23 -0400
X-IronPort-AV: E=Sophos;i="4.77,833,1336320000"; 
   d="scan'208";a="5730521"
From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org
Cc: Wanlong Gao <gaowanlong@cn.fujitsu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 0/5] drivers: fix up ENOIOCTLCMD error handling
Date: Mon, 27 Aug 2012 15:23:11 +0800
Message-Id: <1346052196-32682-1-git-send-email-gaowanlong@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.12
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/08/27 15:25:14,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/08/27 15:25:14,
	Serialize complete at 2012/08/27 15:25:14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At this commit,

Cc: Linus Torvalds <torvalds@linux-foundation.org>
commit 07d106d0a33d6063d2061305903deb02489eba20
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu Jan 5 15:40:12 2012 -0800

    vfs: fix up ENOIOCTLCMD error handling
    
    We're doing some odd things there, which already messes up various users
    (see the net/socket.c code that this removes), and it was going to add
    yet more crud to the block layer because of the incorrect error code
    translation.
    
    ENOIOCTLCMD is not an error return that should be returned to user mode
    from the "ioctl()" system call, but it should *not* be translated as
    EINVAL ("Invalid argument").  It should be translated as ENOTTY
    ("Inappropriate ioctl for device").
    
    That EINVAL confusion has apparently so permeated some code that the
    block layer actually checks for it, which is sad.  We continue to do so
    for now, but add a big comment about how wrong that is, and we should
    remove it entirely eventually.  In the meantime, this tries to keep the
    changes localized to just the EINVAL -> ENOTTY fix, and removing code
    that makes it harder to do the right thing.
    
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>


Linus pointed out that ENOIOCTLCMD should be translated as ENOTTY to user
mode, and we should fix up the broken drivers then.

Wanlong Gao (5):
  drivers:tty:fix up ENOIOCTLCMD error handling
  net:atm:fix up ENOIOCTLCMD error handling
  media:dvb:fix up ENOIOCTLCMD error handling
  video:omap3isp:fix up ENOIOCTLCMD error handling
  s390:block:fix up ENOIOCTLCMD error handling

 drivers/media/dvb/dvb-core/dvbdev.c     |  2 +-
 drivers/media/video/omap3isp/ispvideo.c | 10 +++++-----
 drivers/s390/block/dasd_ioctl.c         |  2 +-
 drivers/tty/tty_io.c                    |  2 +-
 net/atm/resources.c                     |  2 +-
 5 files changed, 9 insertions(+), 9 deletions(-)

-- 
1.7.12

