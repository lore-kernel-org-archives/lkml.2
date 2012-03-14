Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761637Ab2CNWTP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 18:19:15 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:51275 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761165Ab2CNWTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 18:19:10 -0400
Date: Wed, 14 Mar 2012 22:19:08 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        davej@redhat.com, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] vfs namespace: Don't assume mount namespace has valid
 root
Message-ID: <20120314221908.GM23916@ZenIV.linux.org.uk>
References: <1331758710-16400-1-git-send-email-levinsasha928@gmail.com>
 <20120314201048.GI23916@ZenIV.linux.org.uk>
 <20120314205809.GJ23916@ZenIV.linux.org.uk>
 <CA+1xoqcvXsx1vpAB7Jg-dWGVaadbF4sC3Cr2s5itHfdiPFQerA@mail.gmail.com>
 <20120314213746.GK23916@ZenIV.linux.org.uk>
 <CA+1xoqcP-1rU79ZOD2t+cn8tr77Nxmhv0_MjuLcvp67Zb7FFKQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+1xoqcP-1rU79ZOD2t+cn8tr77Nxmhv0_MjuLcvp67Zb7FFKQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 15, 2012 at 12:00:52AM +0200, Sasha Levin wrote:

> I'm running 3.3.0-rc6-next-20120309-sasha-00002-g8fd19a0.
> 
> I found that if I revert f8b88187 ("brlocks/lglocks: cleanups") it
> seems that the problem is gone.

... along with this piece of offending commit:
@@ -2249,10 +2250,9 @@ static struct mnt_namespace *dup_mnt_ns(struct mnt_namespace *mnt_ns,
                kfree(new_ns);
                return ERR_PTR(-ENOMEM);
        }
-       new_ns->root = new;
-       br_write_lock(vfsmount_lock);
+       br_write_lock(&vfsmount_lock);
        list_add_tail(&new_ns->list, &new->mnt_list);
-       br_write_unlock(vfsmount_lock);
+       br_write_unlock(&vfsmount_lock);

        /*
         * Second pass: switch the tsk->fs->* elements and mark new vfsmounts
@@ -2416,9 +2416,9 @@ bool is_path_reachable(struct mount *mnt, struct dentry *dentry,

IOW, Andi has hit delete one too many times...
