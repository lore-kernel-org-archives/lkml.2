Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752148Ab0G0RGU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 13:06:20 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57831 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751733Ab0G0RGS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 13:06:18 -0400
From: Jan Kara <jack@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 0/3] Fix warnings in __mark_inode_dirty
Date: Tue, 27 Jul 2010 19:04:58 +0200
Message-Id: <1280250301-17603-1-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.6.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  Hi,

  patches below fix (some of) warnings in __mark_inode_dirty complaining about
unregistered BDI (https://bugzilla.kernel.org/show_bug.cgi?id=16312).  The
issue is that device inodes describing non-writeable BDI can still get dirty
but they would be filed to writeback lists of these non-writeable BDI's.
Normally, we would just silently throw away the inode modification (bug) but
some unwriteable BDI's (like the one of /dev/zero) aren't marked as such and so
the code in __mark_inode_dirty gets upset that writeback isn't properly setup
although BDI is writeable.
  The solution is slightly hacky but it should be a reasonable short term
solution until we resolve the principial issue that device inode should be
written to a different BDI than inode's data. Christoph wrote he has some
ideas in this direction.

								Honza

PS: There might be another issue in sd.c code triggering this warning --- BDI
is registered from async callback (add_disk() called from sd_probe_async())
which might happen after userspace tries to access the device if I'm right.
At least this is the only explanation I have for some of the warnings.

