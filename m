Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755982Ab1BQBx5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 20:53:57 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:55908 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520Ab1BQBxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 20:53:54 -0500
Date: Thu, 17 Feb 2011 01:53:50 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org
Subject: please, remove the abuse of vfs_path_lookup() in ecryptfs
Message-ID: <20110217015350.GH22723@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	commit 21edad32205e97dc7ccb81a85234c77e760364c8 (
ecryptfs: dont call lookup_one_len to avoid NULL nameidata) is badly
misguided.  The last thing we need is extra places where nameidata is
passed around.

	The current code is simply wrong - it's bypassing dcache
lookups in new_lower_dentry().  Besides, abuse of vfs_path_lookup()
here is a Bad Idea(tm).  No, filesystems are *not* allowed to die
if ->d_revalidate()/->lookup()/->create() are called with NULL
nameidata.  Eventually these methods will lose nameidata * anyway -
starting with ->d_revalidate() in the next cycle at the latest
(i.e. if we run into something really stinky in RCU mess, it might
happen before -final).

	Please revert that.
