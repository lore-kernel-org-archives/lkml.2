Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754563Ab2ACSW6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 13:22:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58216 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751722Ab2ACSWz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 13:22:55 -0500
Date: Tue, 3 Jan 2012 13:22:22 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@hs20-bc2-1.build.redhat.com
To: Al Viro <viro@ZenIV.linux.org.uk>
cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Jan Kara <jack@suse.cz>, dm-devel@redhat.com
Subject: Re: [PATCH] deadlock with suspend and quotas
In-Reply-To: <20120103033005.GZ23916@ZenIV.linux.org.uk>
Message-ID: <Pine.LNX.4.64.1201031318590.10105@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.1111251522230.4118@hs20-bc2-1.build.redhat.com>
 <20120103033005.GZ23916@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 3 Jan 2012, Al Viro wrote:

> On Fri, Nov 25, 2011 at 03:25:16PM -0500, Mikulas Patocka wrote:
> 
> > The following patch fixes the deadlock. When the quota subsystem takes s_umount,
> > it checks if the filesystem is frozen. If it is, we drop s_umount, wait for
> > the filesystem to resume and retry.
> > 
> > Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> > CC: stable@kernel.org
> 
> So basically you want a variant of get_super() that would get you a
> superblock for this bdev, locked and unfrozen?  Fair enough, but
> 	* that should be a proper helper in super.c, rather than
> open-coded in fs/quota/quota.c, of all places
> 	* what about other existing callers get_super() and its friends?

Hi

You can look at that functionality here: I've already made a patch that 
has it: 
https://www.redhat.com/archives/dm-devel/2011-November/msg00151.html

Basically, the patch introduces a function down_read_s_umount, which takes 
s_umount for read, but makes sure that the filesystem is not frozen. Then, 
it adds a boolean parameter to get_super() which tells get_super() that it 
should wait for unfreeze (i.e. call "down_read_s_umount" isntead of 
"down_read(&sb->s_umount)").

Mikulas

> and while we are at it, why in damnation name is it exported?  The only
> caller outside of core VFS is under #if 0...
> 
