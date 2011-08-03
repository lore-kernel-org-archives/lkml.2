Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754791Ab1HCQOF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 12:14:05 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36351 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753709Ab1HCQOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 12:14:01 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: Christoph Hellwig <hch@infradead.org>
Cc: viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, jack@suse.cz, akpm@linux-foundation.org,
        toshi.okajima@jp.fujitsu.com
Subject: Re: [PATCH 1/4] vfs: ignore error on forced remount
References: <1312368521-7911-1-git-send-email-miklos@szeredi.hu>
	<1312368521-7911-2-git-send-email-miklos@szeredi.hu>
	<20110803104914.GA32126@infradead.org>
Date: Wed, 03 Aug 2011 18:15:05 +0200
In-Reply-To: <20110803104914.GA32126@infradead.org> (Christoph Hellwig's
	message of "Wed, 3 Aug 2011 06:49:14 -0400")
Message-ID: <87hb5y4gl2.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig <hch@infradead.org> writes:

> On Wed, Aug 03, 2011 at 12:48:38PM +0200, Miklos Szeredi wrote:
>> From: Miklos Szeredi <mszeredi@suse.cz>
>> 
>> On emergency remount we want to force MS_RDONLY on the super block
>> even if ->remount_fs() failed for some reason.
>
> Eww, dangerous territory.  At the very least we should log something
> in the kernel log for thise case.

Like this?

Thanks,
Miklos
----

Subject: vfs: ignore error on forced remount

From: Miklos Szeredi <mszeredi@suse.cz>

On emergency remount we want to force MS_RDONLY on the super block
even if ->remount_fs() failed for some reason.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/super.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

Index: linux-2.6/fs/super.c
===================================================================
--- linux-2.6.orig/fs/super.c	2011-08-03 16:54:26.000000000 +0200
+++ linux-2.6/fs/super.c	2011-08-03 17:11:56.000000000 +0200
@@ -727,8 +727,13 @@ int do_remount_sb(struct super_block *sb
 
 	if (sb->s_op->remount_fs) {
 		retval = sb->s_op->remount_fs(sb, &flags, data);
-		if (retval)
-			return retval;
+		if (retval) {
+			if(!force)
+				return retval;
+			/* If forced remount, go ahead despite any errors */
+			WARN(1, "forced remount of a %s fs returned %i\n",
+			     sb->s_type->name, retval);
+		}
 	}
 	sb->s_flags = (sb->s_flags & ~MS_RMT_MASK) | (flags & MS_RMT_MASK);
 
