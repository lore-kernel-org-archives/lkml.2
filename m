Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751893Ab2LOSMO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2012 13:12:14 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:56426 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324Ab2LOSMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2012 13:12:13 -0500
Date: Sat, 15 Dec 2012 18:12:11 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: linux-kernel@vger.kernel.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: oopsable race in xen-gntdev (unsafe vma access)
Message-ID: <20121215181211.GV4939@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	1) find_vma() is *not* safe without ->mmap_sem and its result may
very well be freed just as it's returned to caller.  IOW,
gntdev_ioctl_get_offset_for_vaddr() is racy and may end up with
dereferencing freed memory.

	2) gntdev_vma_close() is putting NULL into map->vma with only
->mmap_sem held by caller.  Things like
                if (!map->vma)
                        continue;
                if (map->vma->vm_start >= end)
                        continue;
                if (map->vma->vm_end <= start)
done with just priv->lock held are racy.

	I'm not familiar with the code, but it looks like we need to
protect gntdev_vma_close() guts with the same spinlock and probably
hold ->mmap_sem shared around the "find_vma()+get to map->{index,count}"
in the ioctl.  Or replace the logics in ioctl with search through the
list of grant_map under the same spinlock...

	Comments?
