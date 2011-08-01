Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752839Ab1HAXrw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 19:47:52 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39847 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751783Ab1HAXrs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 19:47:48 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Josef Bacik <josef@redhat.com>
Subject: [Regression] Commit 02c24a82187d5a628c68edfe71ae60dc135cd178 breaks s2disk
Date: Tue, 2 Aug 2011 01:47:00 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201108020147.01136.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Unfortunately s2disk (which is a user space tool for saving hibernate images)
doesn't work any more after your commit 02c24a82187d5a628c68edfe71ae60dc135cd178
(fs: push i_mutex and filemap_write_and_wait down into ->fsync() handlers).
The symptom is that the s2disk's resume counterpart cannot find the image in
the device even though s2disk considers it as successfully saved.

What happens is that s2disk opens a block device (disk partition to be precise)
directly and writes to it eventually calling fsync().  My interpretation of the
failure is that before commit 02c24a82187d5a628c68ed, when s2disk called fsync()
the VFS layer would run filemap_write_and_wait_range() that in turn would cause
the data to go to the disk, but after that commit this doesn't happen any more.

If I'm right, then not only s2disk, but any process writing directly to a block
device will have a problem with fsync().

Thanks,
Rafael

