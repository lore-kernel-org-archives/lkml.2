Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759328Ab2FHA7l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 20:59:41 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:56192 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755725Ab2FHA7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 20:59:40 -0400
Date: Fri, 8 Jun 2012 01:59:35 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Miklos Szeredi <mszeredi@suse.cz>, Jan Kara <jack@suse.cz>,
        Peter Zijlstra <peterz@infradead.org>, linux-fsdevel@vger.kernel.org,
        "J. Bruce Fields" <bfields@redhat.com>, Sage Weil <sage@newdream.net>
Subject: Re: processes hung after sys_renameat, and 'missing' processes
Message-ID: <20120608005935.GL30000@ZenIV.linux.org.uk>
References: <CA+55aFx_oREEd2XS_aG7PJ7dwzWjgx689V_uRPGWpVS01_++6A@mail.gmail.com>
 <20120606235403.GC30000@ZenIV.linux.org.uk>
 <20120607002914.GB22223@redhat.com>
 <CA+55aFyp2GUbc218eb5BDyAqz+cOPTJMVcb4ptk+f1_RBB+-mg@mail.gmail.com>
 <20120607011915.GA17566@redhat.com>
 <20120607012900.GE30000@ZenIV.linux.org.uk>
 <20120607193607.GI30000@ZenIV.linux.org.uk>
 <873966n2c2.fsf@xmission.com>
 <CA+55aFxxS3+NmZacr76qNmEu9=-=aw61gW1Ebugg8hdMNgKiJA@mail.gmail.com>
 <20120608003604.GK30000@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120608003604.GK30000@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 08, 2012 at 01:36:04AM +0100, Al Viro wrote:
> Eric, how about this - if nothing else, that makes code in there simpler
> and less dependent on details of VFS guts:

Argh.  No, it's not enough.  Why are you using ->d_iput()?  You are not
doing anything unusual with inode; the natural place for that is in
->d_release() and then it will get simpler rules wrt setting ->d_fsdata.
As it is, you need to do that exactly after the point where you know
that it dentry won't be dropped without going through d_add().

OK, I've split that in two commits and put into vfs.git#sysfs; take a look
and comment, please.  Should get to git.kernel.in a few...
