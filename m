Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754925Ab2GRQ1X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 12:27:23 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:44134 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754401Ab2GRQ1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 12:27:18 -0400
MIME-Version: 1.0
In-Reply-To: <5006491D.8070004@t-online.de>
References: <5006491D.8070004@t-online.de>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 18 Jul 2012 09:26:57 -0700
X-Google-Sender-Auth: XMzrYDJNmyJV57qnweU1lKiQGkE
Message-ID: <CA+55aFzv5mntf6y9e_r5=v+beG19xBv67EpA=dP0-Zw1CQrGGg@mail.gmail.com>
Subject: Re: [Bug 3.4.5] reiserfs: mutex_destroy called with locked mutex
To: Knut Petersen <Knut_Petersen@t-online.de>,
        Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, reiserfs-devel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 17, 2012 at 10:26 PM, Knut Petersen
<Knut_Petersen@t-online.de> wrote:
> I hit the following problem during a heavy compile job on kernel 3.4.5:

I think it's triggered by the fact that reiserfs does

        d_instantiate(dentry, inode);
        unlock_new_inode(inode);

ie it does the "unlock_new_inode()" *after* it has already made the
inode visible to others in the filesystem. So you can now have a
concurrent lookup of that dentry that finds the (locked) inode before
"unlock_new_inode()" has had the chance to set the lockdep class.
Also, since it's been instantiated, the only *valid* inode pointer is
in the dentry, so the code really really shouldn't use the "inode"
pointer any more because the refcount has been transferred to the
dentry. So maybe memory pressure could turn the dentry negative (and
free the inode) while the unlock_new_inode() code runs.

fs/ext[23]/namei.c has the same pattern, though, and I think it should
be harmless (the inode is marked I_NEW and we get the i_lock for
unlock_new_inode, so the freeing code should know to keep away from
it). So I don't think the freeing code could trigger, but a concurrent
lookup then trying to look up the new directory (and taking the new
directory i_semaphore lock) could happen, afaik.

So I think we should re-order the d_instantiate/unlock_new_inode calls. Al?

                   Linus
