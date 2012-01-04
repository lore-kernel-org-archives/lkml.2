Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757167Ab2ADWNi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 17:13:38 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:57633 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757079Ab2ADWNh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 17:13:37 -0500
Date: Wed, 4 Jan 2012 22:13:35 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-security-module@vger.kernel.org
Subject: new_inode_smack() bogosities
Message-ID: <20120104221335.GF23916@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1) in smack_sb_kern_mount()
        isp = inode->i_security;
        if (isp == NULL)
                inode->i_security = new_inode_smack(sp->smk_root);
        else   
                isp->smk_inode = sp->smk_root;
looks very fishy.  How in hell had that inode managed to get created
in the first place without going through smack_inode_alloc_security()?
Is that about mounting an fs instance with in-core superblock that
is older than the call of smack_init()?  That shouldn't be possible due
to initcall ordering, but if that's the case, just what would happen when
we step on *other* inodes on the same fs?  There's a bunch of places where
smack assumes that ->i_security is never NULL...  And if that's really
impossible, WTF is that new_inode_smack() doing there?

2) again in smack_sb_kern_mount()
        spin_lock(&sp->smk_sblock);
        if (sp->smk_initialized != 0) {
                spin_unlock(&sp->smk_sblock);
                return 0;
        }
        sp->smk_initialized = 1;
        spin_unlock(&sp->smk_sblock);
For one thing, security_sb_kern_mount() is serialized by sb->s_umount.
For another, if it wouldn't be... this code wouldn't be able to prevent
a race.  Sure, only one of them will proceed to initialize the sucker.
And another may cheerfully return before the work is actually done...
In any case, it *is* serialized on per-superblock basis.

3) in smk_fill_super(), we have
        root_inode = sb->s_root->d_inode;
        root_inode->i_security = new_inode_smack(smack_known_floor.smk_known);
Again, huh?  This should be called after smack_init() had been done; hell, 
you explicitly say so in the comments:
 * Do not register smackfs if Smack wasn't enabled
 * on boot. We can not put this method normally under the
 * smack_init() code path since the security subsystem get
 * initialized before the vfs caches.
Sounds like a misspelled assignment to ->smk_inode to me (and a leak, while
we are at it)...
