Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754036Ab1KXWNT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 17:13:19 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:46579 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753423Ab1KXWNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 17:13:16 -0500
Date: Thu, 24 Nov 2011 22:13:13 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: George Spelvin <linux@horizon.com>
Cc: jack@suse.cz, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: 3.1-rc10 oops in nameidata_to_filp
Message-ID: <20111124221313.GO2203@ZenIV.linux.org.uk>
References: <20111124173829.GL2203@ZenIV.linux.org.uk>
 <20111124214710.13413.qmail@science.horizon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111124214710.13413.qmail@science.horizon.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 24, 2011 at 04:47:10PM -0500, George Spelvin wrote:
> Thanks for the pointer.  I'll write some debug code.
> 
> > Said that, I'm not buying the theory of open assigning to ->f_mapping and
> > screwing it up; all such assignments end up with ->i_mapping of *some*
> > inode, as far as I can see from cursory grep over the tree.  Just in case:
> > do you have CONFIG_FS_POSIX_ACL set?
> 
> No, I always turn that off.  (And TMPFS_POSIX_ACL, too.)

OK, then this 0x18 is very likely to be offset of i_mapping in struct inode
and we have file->f_mapping->host == NULL.  Very odd...  The only struct
address_space on your config besides inode->i_data (which _all_ get non-NULL
->host, pointing straight back to the containing struct inode) is
swapper_space.  And there's no way in hell for it to legitimately end up
in file->f_mapping or inode->i_mapping.

So the possibilities are:
	legitimate ->f_mapping, fucked contents of address_space it points to.
	fucked ->i_mapping, ->f_mapping copied from it.
	legitimate ->i_mapping, open() callback fucking ->f_mapping up.
Try to enable memory poisoning; if it turns those into oopsen on attempt
to access poison + 0x18, we'll know it's some inode getting freed while we
still have references to it...  OTOH, that would make your debugging printks
not fire at all, so it might be better to get the pathname first before
enabling that and seeing how behaviour changes...
