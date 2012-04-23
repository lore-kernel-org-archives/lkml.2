Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753446Ab2DWCEy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2012 22:04:54 -0400
Received: from mailq2.tnnet.fi ([217.112.254.233]:37337 "EHLO mailq2.tnnet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753062Ab2DWCEu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2012 22:04:50 -0400
X-Greylist: delayed 512 seconds by postgrey-1.27 at vger.kernel.org; Sun, 22 Apr 2012 22:04:50 EDT
Date: Mon, 23 Apr 2012 04:55:31 +0300 (EEST)
From: Szabolcs Szakacsits <szaka@tuxera.com>
X-X-Sender: szaka@ax228.axxion.fi
To: Zheng Liu <gnehzuil.liu@gmail.com>
cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org
Subject: Re: [RFC][PATCH 0/3] add FALLOC_FL_NO_HIDE_STALE flag in fallocate
Message-ID: <alpine.DEB.1.10.1204230431510.11748@ax228.axxion.fi>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 4/17/12 11:53 AM, Zheng Liu wrote:

> fallocate is a useful system call because it can preallocate some disk 
> blocks for a file and keep blocks contiguous.  However, it has a defect 
> that file system will convert an uninitialized extent to be an 
> initialized when the user wants to write some data to this file, because 
> file system create an unititalized extent while it preallocates some 
> blocks in fallocate (e.g. ext4). Especially, it causes a severe 
> degradation when the user tries to do some random write operations, which 
> frequently modifies the metadata of this file. We meet this problem in 
> our product system at Taobao.  Last month, in ext4 workshop, we discussed 
> this problem and the Google faces the same problem.  So a new flag, 
> FALLOC_FL_NO_HIDE_STALE, is added in order to solve this problem. 

I think a more explicit name would be better like FALLOC_FL_EXPOSE_DATA, 
FALLOC_FL_EXPOSE_STALE_DATA, FALLOC_FL_EXPOSE_UNINITIALIZED_DATA, etc.

> When this flag is set, file system will create an inititalized extent for 
> this file.  So it avoids the conversion from uninitialized to 
> initialized.  If users want to use this flag, they must guarantee that 
> file has been initialized by themselves before it is read at the same 
> offset.  This flag is added in vfs so that other file systems can also 
> support this flag to improve the performance.

This flag could be indeed helpful for filesystems which can't fully support 
uninitialized allocated blocks efficiently unlike XFS and ext4. We are 
supporting several such interoperable filesystems (NTFS, exFAT, FAT) where 
changing the specification is unfortunately not possible.

There is real user need despite explaining potential security consequences. 
Typical usage scenarios are using a large file as a container for an 
application which tracks free/used blocks itself. Windows supports this 
feature by SetFileValidData() if extra privilege is granted.

The performance gain can be fairly large on embedded using low-end storage 
and CPU. In one of our cases it took 5 days vs 12 minutes to fully setup a 
large file for use.

Regards,
	   Szaka
