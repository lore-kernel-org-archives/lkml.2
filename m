Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933615Ab2FHFsp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 01:48:45 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:36765 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933490Ab2FHFso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 01:48:44 -0400
Date: Fri, 8 Jun 2012 06:48:38 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Miklos Szeredi <mszeredi@suse.cz>, Jan Kara <jack@suse.cz>,
        Peter Zijlstra <peterz@infradead.org>, linux-fsdevel@vger.kernel.org,
        "J. Bruce Fields" <bfields@redhat.com>, Sage Weil <sage@newdream.net>
Subject: Re: processes hung after sys_renameat, and 'missing' processes
Message-ID: <20120608054838.GO30000@ZenIV.linux.org.uk>
References: <20120607002914.GB22223@redhat.com>
 <CA+55aFyp2GUbc218eb5BDyAqz+cOPTJMVcb4ptk+f1_RBB+-mg@mail.gmail.com>
 <20120607011915.GA17566@redhat.com>
 <20120607012900.GE30000@ZenIV.linux.org.uk>
 <20120607193607.GI30000@ZenIV.linux.org.uk>
 <873966n2c2.fsf@xmission.com>
 <CA+55aFxxS3+NmZacr76qNmEu9=-=aw61gW1Ebugg8hdMNgKiJA@mail.gmail.com>
 <20120608003604.GK30000@ZenIV.linux.org.uk>
 <20120608005935.GL30000@ZenIV.linux.org.uk>
 <87bokugysl.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87bokugysl.fsf@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 07, 2012 at 10:25:46PM -0700, Eric W. Biederman wrote:

> I am still learly of d_materialise_unique as it allows to create alias's
> on non-directories.  It isn't a functional problem as d_revalidate will
> catch the issue and make it look like we have a unlink/link pair instead
> of a proper rename.  However since it is possible I would like to aim
> for the higher quality of implemntation and use show renames as renames.

???

Please, explain.  link/unlink pair in which sense?  If you are thinking
of inotify and its ilk and tie some of that to dentry eviction, you
have far worse problem.  What stream of events do you expect if you
do
	some action that triggers sysfs_rename()
	stat(2) on old pathname
	stat(2) on new pathname
No matter what we do in lookup at the new pathname, the second step will
be "failed revalidate".  If you tie something (presumably unlink side of
your link/unlink pair) to that event, you'll get a very lousy series of
events, no matter what you do on the third step.

I don't see what kind of *notify hookup do you have in mind.  Anything that
treats "dentry failed revalidation or got evicted by memory pressure" as
"unlink" is completely nuts, IMO.
