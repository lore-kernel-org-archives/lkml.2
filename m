Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932807Ab0HKIsj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 04:48:39 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:53544 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932745Ab0HKIsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 04:48:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=Hci7y+HoBpBzdwd+YoOolDsQPdRmblorifrEIoTO1daoA9CZf4X+MH4EuQUdfzjFgF
         rmyhWMUFfaDqKdKjGZSjThDFPqNZl/Dwcrtt0yePZN/KewO3T5DeZnX70FOZtRwLZe0B
         xHecKHZoyiN8TdRGrc4KPmwPyBIhqYpexzpuI=
Date: Wed, 11 Aug 2010 10:48:29 +0200
From: Luca Tettamanti <kronos.it@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.sourceforge.net
Subject: [DRM] BUG: sleeping function called from invalid context,
 drm_lastclose
Message-ID: <20100811084828.GA5709@nb-core2.darkstar.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,
this commit:

commit 58374713c9dfb4d231f8c56cac089f6fbdedc2ec
Author: Arnd Bergmann <arnd@arndb.de>
Date:   Sat Jul 10 23:51:39 2010 +0200

    drm: kill BKL from common code


moved the call to (inside drm_release) drm_lastclose inside dev->count_lock
spinlock.
drm_lastclose however takes dev->struct_mutex (now inside an atomic
context):

BUG: sleeping function called from invalid context at /home/kronos/src/linux-2.6.git/kernel/mutex.c:94
in_atomic(): 1, irqs_disabled(): 0, pid: 3331, name: Xorg
Pid: 3331, comm: Xorg Not tainted 2.6.35-06113-gf6cec0a #272
Call Trace:
 [<ffffffff8102770e>] __might_sleep+0xf8/0xfa
 [<ffffffff8127cf18>] mutex_lock+0x1f/0x3e
 [<ffffffffa052d1c1>] drm_lastclose+0x92/0x2ad [drm]
 [<ffffffffa052dbc7>] drm_release+0x5ca/0x60d [drm]
 [<ffffffff810b118f>] fput+0x130/0x1f7
 [<ffffffff810ae77d>] filp_close+0x63/0x6d
 [<ffffffff810ae82f>] sys_close+0xa8/0xe2
 [<ffffffff8100296b>] system_call_fastpath+0x16/0x1b


Luca
