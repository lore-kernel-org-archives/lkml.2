Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932700Ab2AETw6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 14:52:58 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:41547 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932493Ab2AETwz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 14:52:55 -0500
Subject: Re: [PATCH v3 1/1] vfs: iversion truncate bug fix
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>, Greg KH <greg@kroah.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
        linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
        viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org
Date: Thu, 05 Jan 2012 14:49:54 -0500
In-Reply-To: <20120105181401.GA418@infradead.org>
References: <ba9643a815137d64301559f174f6f6bf3a552b16.1324551152.git.dmitry.kasatkin@intel.com>
	 <1324560391.1964.8.camel@falcor>
	 <20120104152801.d8f555ca.akpm@linux-foundation.org>
	 <1325723630.13419.2.camel@falcor>
	 <20120104164638.cc21fc2e.akpm@linux-foundation.org>
	 <20120105020639.GA1161@kroah.com> <1325737033.13419.43.camel@falcor>
	 <20120105045354.GE24466@dastard> <20120105181401.GA418@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1325792995.2062.11.camel@falcor.watson.ibm.com>
Mime-Version: 1.0
x-cbid: 12010519-7182-0000-0000-0000007F5B39
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-01-05 at 13:14 -0500, Christoph Hellwig wrote:
> On Thu, Jan 05, 2012 at 03:53:54PM +1100, Dave Chinner wrote:
> > That's seems like a rather unreliable way of detecting that a file
> > has changed to me.  I mean, only ext4 uses inode_inc_version() when
> > it internally dirties an inode, and only ext4 sets the MS_I_VERSION
> > so that inode_inc_version is only called for ext4 inodes when
> > timestamps change.
> 
> And even ext4 only does it when using the non-default "i_version"
> mount option.
> 
> > Hence just adding an increment to the truncate case doesn't seem to
> > be sufficient to me. e.g. what about the equivalent case of having a
> > hole punched in the file via fallocate? The file has definitely
> > changed, but i_version won't change....
> > 
> > Perhaps bumping i_version in __mark_inode_dirty() might be the best
> > way to capture all changes (other than timestamp updates) to any
> > inode regardless of the filesystem type?
> 
> It has the same problem as the timestamp updates doing that right now -
> the fs can't do locking around it, and it can't return errors.  That's
> something affecting at least btrfs, xfs and IIRC ubifs, and probably
> the cluster filesystems as well.  The right answer is to replace the
> timestmap updates which are the only places doing that with a method
> as Josef had planned to do, and then we can include the i_version
> updates in there.
> 
> That assumes we figure out a coherent way to do it - except for the
> conditional abuse in file_updates_times it's currently entirely under
> fs control.  So the best way to fix it would be to:
> 
>  - move the fs-private use into those filesystems actually using it.
>    Note that a lot less actually check for it rather than just updating
>    it based on some cargo cult, and most only do so for directories.
>  - figure a why what exact change count semantics NFS (and IMA) want
>    and find a way to implement them so that the fs can tell the callers
>    that they don't exist.
> 
> Btw, does IMA care about these beeing persistent?

By 'persistent' I assume you mean across boots.  IMA (and IMA-appraisal)
measure and appraise files the first time they're accessed/executed.  So
no, it does not need to be persistent. IMA/IMA-appraisal just need some
way to detect file change in order to know whether the file needs to be
re-measured/appraised on subsequent access.

Mimi

