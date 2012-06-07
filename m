Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753047Ab2FGA3Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 20:29:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61150 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750888Ab2FGA3X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 20:29:23 -0400
Date: Wed, 6 Jun 2012 20:29:14 -0400
From: Dave Jones <davej@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Miklos Szeredi <mszeredi@suse.cz>, Jan Kara <jack@suse.cz>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: processes hung after sys_renameat, and 'missing' processes
Message-ID: <20120607002914.GB22223@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Al Viro <viro@ZenIV.linux.org.uk>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Miklos Szeredi <mszeredi@suse.cz>, Jan Kara <jack@suse.cz>,
	Peter Zijlstra <peterz@infradead.org>
References: <20120603223617.GB7707@redhat.com>
 <CA+55aFwCusEdMq3_3TAXSZ=+kbN7H6AbnngVaagAZw=ZpicckQ@mail.gmail.com>
 <20120603231709.GP30000@ZenIV.linux.org.uk>
 <20120603232820.GQ30000@ZenIV.linux.org.uk>
 <20120606194233.GA1537@redhat.com>
 <CA+55aFwxFVLPk4-dp73uccKXepKwjpGFgh0NW1u8d0zYzr=hBA@mail.gmail.com>
 <20120606230040.GA18089@redhat.com>
 <CA+55aFx_oREEd2XS_aG7PJ7dwzWjgx689V_uRPGWpVS01_++6A@mail.gmail.com>
 <20120606235403.GC30000@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120606235403.GC30000@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 07, 2012 at 12:54:04AM +0100, Al Viro wrote:

 > What we need is ->i_mutex on parents.  And I'm much more concerned about
 > this: 7732a557b1342c6e6966efb5f07effcf99f56167 and
 >  3f50fff4dace23d3cfeb195d5cd4ee813cee68b7.
 > 
 > Dave, you seem to be able to reproduce it; could you try with those two
 > commits reverted?  This stuff is *definitely* wrong with the way it
 > treats d_move(); there we might get it with parents not locked at all.
 > 
 > FWIW, I'd suggest adding a check into d_move(); new parent must be
 > locked in all cases and old one whenever dentry has one (i.e. isn't
 > disconnected).  If you can find a violation of that, you very likely
 > have found the cause of that bug.

Like this ?

 void d_move(struct dentry *dentry, struct dentry *target)
 {
        write_seqlock(&rename_lock);
+
+       BUG_ON(!spin_is_locked(&target->d_parent->d_lock));
+
+       if (dentry->d_parent != NULL)
+               BUG_ON(!spin_is_locked(&dentry->d_parent->d_lock));
+
        __d_move(dentry, target);
        write_sequnlock(&rename_lock);
 }


To be clear, do you want me to try that with or without the reverts ?

	Dave

