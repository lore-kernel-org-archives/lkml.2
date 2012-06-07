Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756578Ab2FGAkF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 20:40:05 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:49980 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752749Ab2FGAkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 20:40:03 -0400
Date: Thu, 7 Jun 2012 01:40:00 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Miklos Szeredi <mszeredi@suse.cz>, Jan Kara <jack@suse.cz>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: processes hung after sys_renameat, and 'missing' processes
Message-ID: <20120607004000.GD30000@ZenIV.linux.org.uk>
References: <20120603223617.GB7707@redhat.com>
 <CA+55aFwCusEdMq3_3TAXSZ=+kbN7H6AbnngVaagAZw=ZpicckQ@mail.gmail.com>
 <20120603231709.GP30000@ZenIV.linux.org.uk>
 <20120603232820.GQ30000@ZenIV.linux.org.uk>
 <20120606194233.GA1537@redhat.com>
 <CA+55aFwxFVLPk4-dp73uccKXepKwjpGFgh0NW1u8d0zYzr=hBA@mail.gmail.com>
 <20120606230040.GA18089@redhat.com>
 <CA+55aFx_oREEd2XS_aG7PJ7dwzWjgx689V_uRPGWpVS01_++6A@mail.gmail.com>
 <20120606235403.GC30000@ZenIV.linux.org.uk>
 <20120607002914.GB22223@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120607002914.GB22223@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2012 at 08:29:14PM -0400, Dave Jones wrote:
>  void d_move(struct dentry *dentry, struct dentry *target)
>  {
>         write_seqlock(&rename_lock);
> +
> +       BUG_ON(!spin_is_locked(&target->d_parent->d_lock));
> +
> +       if (dentry->d_parent != NULL)
> +               BUG_ON(!spin_is_locked(&dentry->d_parent->d_lock));
> +
>         __d_move(dentry, target);
>         write_sequnlock(&rename_lock);
>  }
> 
> 
> To be clear, do you want me to try that with or without the reverts ?

No.  Not ->d_lock; ->d_inode->i_mutex.  _That_ needs to be held for
d_move() to be safe (and on cross-directory move you need ->s_vfs_rename_mutex
as well).  I'd do it with WARN_ON, BTW, and without the reverts - that
way we'll have a clear indication if that code is stepped on.
