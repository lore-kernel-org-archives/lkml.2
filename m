Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932725Ab0EDOgn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 10:36:43 -0400
Received: from mail-qy0-f189.google.com ([209.85.221.189]:38225 "EHLO
	mail-qy0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932313Ab0EDOgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 10:36:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=WxFTd8678/buH0UfFNOvE/mJKk5H0usmFlbORWgT19cSk3WcF9zxOkILpvC6IPUSjO
         hy1/pKIW8Ygk17JAgqnWFk3Cpqu3pptctNufROYKjIJeaUOw3U2xOjiCOzJcTQSJNvlI
         VB153yz6sxZpoVJ26qNLRwP/kvYSNUqrV0ul8=
Date: Tue, 4 May 2010 11:36:24 -0300
From: "Luis Claudio R. Goncalves" <lclaudio@uudg.org>
To: Nick Piggin <npiggin@suse.de>
Cc: john stultz <johnstul@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
       rt-users <linux-rt-users@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RT] 2.6.33.3-rt19: WARNING: at fs/namespace.c:648
 commit_tree+0xf1/0x10b()
Message-ID: <20100504143624.GG4309@uudg.org>
References: <20100504140443.GF4309@uudg.org>
 <20100504142756.GB5905@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100504142756.GB5905@laptop>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 05, 2010 at 12:27:56AM +1000, Nick Piggin wrote:
| On Tue, May 04, 2010 at 11:04:44AM -0300, Luis Claudio R. Goncalves wrote:
| > John,
| > 
| > As the backtrace seems to be closely related to what has been discussed on
| > the thread "2.6.33.3-rt16: WARNING: at fs/namespace.c:1197", I copied the
| > same people on this message.
| > 
| > As a side note, this time I just see the warning, there is no system freeze
| > involved.
| > 
| > 
| > ------------[ cut here ]------------
| > WARNING: at fs/namespace.c:648 commit_tree+0xf1/0x10b()
| 
| I don't have the -rt tree at hand; can you copy a few lines of code
| around line 648 of fs/namespace.c, please?

Line 648 is the "WARN_ON(mnt->mnt_flags & MNT_MOUNTED);" in this function:


/*
 * the caller must hold vfsmount_lock
 */
static void commit_tree(struct vfsmount *mnt)
{
        struct vfsmount *parent = mnt->mnt_parent;
        struct vfsmount *m;
        LIST_HEAD(head);
        struct mnt_namespace *n = parent->mnt_ns;

        BUG_ON(parent == mnt);

        list_add_tail(&head, &mnt->mnt_list);
        list_for_each_entry(m, &head, mnt_list)
                m->mnt_ns = n;
        list_splice(&head, n->list.prev);

        list_add_tail(&mnt->mnt_hash, mount_hashtable +
                                hash(parent, mnt->mnt_mountpoint));
        list_add_tail(&mnt->mnt_child, &parent->mnt_mounts);
        WARN_ON(mnt->mnt_flags & MNT_MOUNTED);
        mnt->mnt_flags |= MNT_MOUNTED;
        touch_mnt_namespace(n);
}


Luis
-- 
[ Luis Claudio R. Goncalves                    Bass - Gospel - RT ]
[ Fingerprint: 4FDD B8C4 3C59 34BD 8BE9  2696 7203 D980 A448 C8F8 ]

