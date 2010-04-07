Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751451Ab0DGWTt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 18:19:49 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:57615 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753199Ab0DGWTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 18:19:45 -0400
Date: Wed, 7 Apr 2010 23:19:41 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Network Development <netdev@vger.kernel.org>,
       Linux ACPI <linux-acpi@vger.kernel.org>,
       Linux PM List <linux-pm@lists.linux-foundation.org>,
       Linux SCSI List <linux-scsi@vger.kernel.org>,
       Linux Wireless List <linux-wireless@vger.kernel.org>,
       DRI <dri-devel@lists.sourceforge.net>
Subject: Re: 2.6.34-rc3-git6: Reported regressions from 2.6.33
Message-ID: <20100407221941.GL30031@ZenIV.linux.org.uk>
References: <6Pphclm24fK.A.lSF.qsPvLB@chimera>
 <alpine.LFD.2.00.1004071444440.3586@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1004071444440.3586@i5.linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 07, 2010 at 03:04:46PM -0700, Linus Torvalds wrote:

> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15674
> > Subject		: [2.6.34-rc2 NFS4 oops] open error path failure...
> > Submitter	: Daniel J Blueman <daniel.blueman@gmail.com>
> > Date		: 2010-03-29 18:36 (10 days old)
> > Message-ID	: <6278d2221003291136p6481fe8emfb039403343c082@mail.gmail.com>
> > References	: http://marc.info/?l=linux-kernel&m=126988782722711&w=2
> 
> This smells like the same LOOKUP_DIRECTORY thing as the first entry, but.. 

No, it's not the same thing; the fix is to have nfs ->d_revalidate()
return an error on failing open attempt (in insane codepath that has
->d_revalidate() handling open()).  Confirmed to work by reporter...

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index d79a7b3..fe0cd9e 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -2068,8 +2068,7 @@ nfs4_open_revalidate(struct inode *dir, struct dentry *dentry, int openflags, st
 			case -EDQUOT:
 			case -ENOSPC:
 			case -EROFS:
-				lookup_instantiate_filp(nd, (struct dentry *)state, NULL);
-				return 1;
+				return PTR_ERR(state);
 			default:
 				goto out_drop;
 		}
