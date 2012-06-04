Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754293Ab2FDG0H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 02:26:07 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:60913 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219Ab2FDG0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 02:26:06 -0400
Date: Mon, 4 Jun 2012 07:26:04 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Question about do_mmap changes
Message-ID: <20120604062604.GV30000@ZenIV.linux.org.uk>
References: <4FCC47C9.8050904@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FCC47C9.8050904@lwfinger.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 04, 2012 at 12:29:45AM -0500, Larry Finger wrote:
> Al,
> 
> In commit e3fc629d7bb70848fbf479688a66d4e76dff46ac in 3.5-rc1, you
> change do_mmap() to static, and use do_mmap_pgoff() instaed. The
> VirtualBox kernel module calls do_mmap(), and no longer compiles. I
> fixed the compile problem with the patch
[snip]
> I am not quite sure why do_munmap() is undefined as the symbol is
> exported; however, should do_mmap_pgoff() be exported?

a) you'd better make very certain that you are holding ->mmap_sem on
current->mm; I couldn't verify that.

b) as for rtR0MemObjLinuxDoMmap(), I would suggest pulling down_write()/
up_write() on ->mmap_sem into the function, collapsing them down into
do_mmap() turning it into vm_mmap().  Oh, and probably breaking wrists
to whoever had come up with that function name, but that's a matter of
taste.  Some prefer kneecaps.

c) WTF is MY_DO_MUNMAP() and are you guaranteed that you are doing that to
current->mm and not to something else?  If not, you have a big problem;
if yes, convert to vm_munmap().

Again, doing mmap/munmap to some random process' mm is a bloody bad idea;
there's a shitload of races in that area.
