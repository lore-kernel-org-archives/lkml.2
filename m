Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758714Ab1CCTQc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 14:16:32 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:41389 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751887Ab1CCTQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 14:16:31 -0500
Date: Thu, 3 Mar 2011 19:16:27 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Theodore Tso <tytso@MIT.EDU>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] st_nlink after rmdir() and rename()
Message-ID: <20110303191626.GM22723@ZenIV.linux.org.uk>
References: <20110303032454.GI22723@ZenIV.linux.org.uk>
 <406B4874-D3D8-4C05-9FA5-8A7A18ABF89C@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <406B4874-D3D8-4C05-9FA5-8A7A18ABF89C@mit.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 03, 2011 at 09:34:08AM -0500, Theodore Tso wrote:
> 
> On Mar 2, 2011, at 10:24 PM, Al Viro wrote:
> 
> > We have an interesting problem.  Consider the following sequence
> > of syscalls:
> > 	mkdir("foo", 0777);
> > 	mkdir("bar", 0777);
> > 	fd1 = open("foo", O_DIRECTORY);
> > 	fd2 = open("bar", O_DIRECTORY);
> > 	rename("foo", "bar");	/* kill old bar */
> 
> I must be missing something.  I didn't think you could rename on
> top of a directory and have the directory disappear.  Don't you get
> an error in that case?  What happens if bar contains files?

ENOTEMPTY.  Checked by ->rename() and yes, ext4 does that.

> We don't allow:  mkdir("bar", 0777); unlink("bar");
> 
> Why should this be any different?

Because it worked since 4.2BSD and got into POSIX.  Replacing rename()
works; the only restrictions are
	* you can't replace directory with non-directory
	* you can't replace non-directory with directory
	* directory being replaced shall be empty
	* you can't replace a mountpoint or filesystem root
If the target is not busy, it is required to work.  Whether it returns
-EBUSY for busy target is implementation-dependent and we allow that
for most of the filesystems.
