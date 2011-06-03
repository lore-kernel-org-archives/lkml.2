Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756649Ab1FCXMA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 19:12:00 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:39209 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756611Ab1FCXL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 19:11:59 -0400
Date: Sat, 4 Jun 2011 00:11:58 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Dmitry Dmitriev <dimondmm@yandex.ru>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: Corrupting d_count of target dentry, when rename
 directory to the directory which is mount point, or when rename directory
 which is mount point to the existing directory.
Message-ID: <20110603231158.GR11521@ZenIV.linux.org.uk>
References: <254871306829495@web62.yandex.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <254871306829495@web62.yandex.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> When new_dentry exist, i.e. 'target' is not NULL, and a mount point( or old dentry is a mount point ), then function set 'error' variable to -EBUSY( line 2581 ). After that function will call dput function for new_dentry( line 2595 ) without corresponding dget. In this case d_count of dentry become corrupted. In case when old dentry and new dentry are not mount points, dget for new dentry is called in dentry_unhash function.

What do you mean, without corresponding dget()?  It's done in dentry_unhash().

Oh, hell...  We don't call it in that case.  Right.  vfs_rmdir() used to
do dentry_unhash() before the checks for mountpoints, vfs_rename_other() -
only after.

The funny part is, it got accidentally fixed in this merge window.  -stable
still needs fixing - by moving dentry_unhash() down past the checks for
d_mountpoint().  Mainline should be OK now...
