Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754718Ab2CRSpt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2012 14:45:49 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:43198 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751979Ab2CRSps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2012 14:45:48 -0400
Date: Sun, 18 Mar 2012 18:45:47 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Mike Marciniszyn <infinipath@qlogic.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: races in ipathfs
Message-ID: <20120318184547.GA6814@ZenIV.linux.org.uk>
References: <20120119202003.GZ23916@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120119202003.GZ23916@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 19, 2012 at 08:20:04PM +0000, Al Viro wrote:
> 	Use of qib_super is seriously racy.  qibfs_add() (and worse,
> qibfs_remove()) can happen during qibfs_mount() and qibfs_kill_super().

[snip]

FWIW, I've put a completely untested patchset into
git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git qibfs

It tries to avoid that kind of crap by getting rid of "populate at mount
time" logics - we keep (internal) mount of that sucker for as long as
there are any devices owned by ib_qib, adding them on add_device() and
removing on remove_device().  The only complication is with module
use counts - that fs has to be a separate module, or we'll have ib_qib
impossible to rmmod, because fs keeps its module pinned and any devices
held by ib_qib PCI driver will keep the fs pinned, so we never get
to unregistering said PCI driver.  With skeleton of qibfs (static parts
only) taken to ib_qib_fs.c we avoid that problem - it is what ends up
being pinned down for as long as ib_qib owns any devices, but then it's
pinned down by ib_qib using exports from ib_qib_fs anyway.  And once
ib_qib is removed, all internal references to that vfsmount and superblock
disappear as well...

This stuff is completely untested; I don't have the hardware in question.
It does compile and survive modpost, but that's it.  Please, review and
comment...
