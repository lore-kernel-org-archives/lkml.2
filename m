Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755734Ab1FJLVG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 07:21:06 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:36354 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755885Ab1FJLVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 07:21:04 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: John McCutchan <john@johnmccutchan.com>, Robert Love <rlove@rlove.org>,
        Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Race inotify_rm_watch vs umount
Date: Fri, 10 Jun 2011 20:20:55 +0900
Message-ID: <87r572nd9k.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm looking the race inotify_rm_watch() vs umount(). This race become the
cause of Oops. You can see the oops at

https://bugzilla.kernel.org/show_bug.cgi?id=22602

So, what race?

umount                               inotify_rm_watch
  ...                                  fsnotify_destroy_mark()
                                         fsnotify_destroy_inode_mark()
                                           /* removed from i_fsnotify_marks */
    generic_shutdown_super()
      fsnotify_unmount_inodes()
        put_super()
                                           iput()
                                             iput_final()
                                               /* this is after put_super() */

Like above, inotify doesn't guarantee to call final iput() before
put_super(). With this violation, FS driver can oops.

Well, so, what are requested for inotify?  We can't simply take
sb->s_umount in inotify_rm_watch()?

Any ideas?

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
