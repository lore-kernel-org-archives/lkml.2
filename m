Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756084Ab2FGX5h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 19:57:37 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:45019 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753822Ab2FGX5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 19:57:35 -0400
MIME-Version: 1.0
In-Reply-To: <873966n2c2.fsf@xmission.com>
References: <20120603232820.GQ30000@ZenIV.linux.org.uk> <20120606194233.GA1537@redhat.com>
 <CA+55aFwxFVLPk4-dp73uccKXepKwjpGFgh0NW1u8d0zYzr=hBA@mail.gmail.com>
 <20120606230040.GA18089@redhat.com> <CA+55aFx_oREEd2XS_aG7PJ7dwzWjgx689V_uRPGWpVS01_++6A@mail.gmail.com>
 <20120606235403.GC30000@ZenIV.linux.org.uk> <20120607002914.GB22223@redhat.com>
 <CA+55aFyp2GUbc218eb5BDyAqz+cOPTJMVcb4ptk+f1_RBB+-mg@mail.gmail.com>
 <20120607011915.GA17566@redhat.com> <20120607012900.GE30000@ZenIV.linux.org.uk>
 <20120607193607.GI30000@ZenIV.linux.org.uk> <873966n2c2.fsf@xmission.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 7 Jun 2012 16:57:13 -0700
X-Google-Sender-Auth: -6ZE8UnMoVxvNp6k4Ila86ubNGw
Message-ID: <CA+55aFxxS3+NmZacr76qNmEu9=-=aw61gW1Ebugg8hdMNgKiJA@mail.gmail.com>
Subject: Re: processes hung after sys_renameat, and 'missing' processes
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Miklos Szeredi <mszeredi@suse.cz>, Jan Kara <jack@suse.cz>,
        Peter Zijlstra <peterz@infradead.org>, linux-fsdevel@vger.kernel.org,
        "J. Bruce Fields" <bfields@redhat.com>, Sage Weil <sage@newdream.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 7, 2012 at 4:12 PM, Eric W. Biederman <ebiederm@xmission.com> wrote:
>
> We take the approprate dentry locks in the approparite order so d_move
> and the dcache should not care in the slightest about the inode
> mutecies.

Part of the problem is that you can't even *determine* the appropriate
order without holding the rename mutex.

Now, it may turn out to be a non-issue for sysfs just because there
are no unconstrained directory renames there, but seriously: even the
d_ancestor() check itself (which is how we determine the dentry lock
order) needs that filesystem to be quiescent wrt directory renames in
order to work.

So it may not actually depend on the inode->i_mutex, but it does need
some serialization outside the dcache subsystem.

Any per-filesystem mutex should do, so if sysfs always holds the
sysfs_mutex - and never allows user-initiated renames - it should be
safe.

          Linus
