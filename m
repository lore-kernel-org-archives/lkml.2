Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932151Ab2B1OUp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 09:20:45 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41308 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755210Ab2B1OUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 09:20:43 -0500
Date: Tue, 28 Feb 2012 14:20:41 +0000
From: Andy Whitcroft <apw@canonical.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        mszeredi@suse.cz
Subject: overlayfs and inotify
Message-ID: <20120228142041.GI8110@shadowen.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have recently been looking at reports of inotify issues with overlayfs.
As things stand there is essentially no inotify support, as dispite being
able to set watches they will never trigger as IO is always performed
against the underlying inodes and not where the watches are placed.
You can reproduce this trivially using tail -f against a file in an
overlayfs mount.

I have been playing with some ideas how this might be resolved.  I have
some very preliminary patches which turn overlayfs into an fsnotify
consumer.  When watches are placed against the upper overlayfs inode I
simply reflect them as an aggregate fsnotify mark against the underlying
inode in the active layer; moving the mark to the upper inode during any
copy_up operation.

While this works pretty well for a lot of use cases, it does not help
with tail -f.  When the change notification is emitted tail then fstat
its open file descriptor and if the size is changed it emits the new data.
Obviously with overlayfs tail may be connected to the original r/o layer
copy of the file, so any re-stat will indicate the file is unchanged and
emit nothing.

Now clearly we could fix tail in this case to stat the filename instead
which would avoid the issue.  But I am concerned that this might be a
common idiom in other inotify consumers.

I also wonder if we should be hinting to userspace that there is something
unusual going on during copy_up, for example emitting an IN_MOVE_SELF to
allow consumers to follow along more easily.

Before I spend any more time cleaning up these patches I wondered if
this approach even makes sense, can we really produce sensible semantics
for inotify in this case in the face of the direct to the underlying
filesystem semantics.

Thoughts?

-apw
