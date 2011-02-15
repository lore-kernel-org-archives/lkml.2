Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756121Ab1BOURQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 15:17:16 -0500
Received: from adelie.canonical.com ([91.189.90.139]:59828 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755154Ab1BOURP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 15:17:15 -0500
Subject: Re: BUG at fs/namei.c:405 (nameidata_drop_rcu)
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: linux-kernel@vger.kernel.org, Nick Piggin <npiggin@kernel.dk>
In-Reply-To: <20110211000247.5e8fbed8@katamari>
References: <20110211000247.5e8fbed8@katamari>
Content-Type: text/plain; charset="UTF-8"
Organization: Canonical
Date: Tue, 15 Feb 2011 18:17:08 -0200
Message-ID: <1297801028.2403.27.camel@herton-IdeaPad-Y430>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sex, 2011-02-11 às 00:02 -0500, Chuck Ebbert escreveu:
> Apparently hit this very early in nameidata_drop_rcu():
> 
>         BUG_ON(!(nd->flags & LOOKUP_RCU));
> 
> The user reports he ran "fuser /var/cache/yum" while logged in to
> an X session with his home directory mounted via NFS4. Home dirs
> are normally automounted, but manually mounting the dir still
> reproduces the problem.

I got a similar report too, and was able to reproduce here with nfs4
too.

We hit it at force_reval_path

>From what I saw force_reval_path is never called with LOOKUP_RCU flag
set. Who calls force_reval_path is __do_follow_link, and
__do_follow_link is called from do_filp_open and do_follow_link. When
do_filp_open calls it, it already dropped LOOKUP_RCU (if path rcu lookup
didn't work). do_follow_link also calls it without LOOKUP_RCU set from
what I'm seeing, as before each do_follow_link call
nameidata_dentry_drop_rcu_maybe is called.

So simply removing again nameidata_drop_rcu from force_reval_path should
do it. I'm running now on this change and didn't experience the same bug
or other problems.

Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>

diff --git a/fs/namei.c b/fs/namei.c
index ec4b2d0..7dcedbc 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -668,9 +668,7 @@ force_reval_path(struct path *path, struct nameidata *nd)
 		return 0;
 
 	if (!status) {
-		/* Don't d_invalidate in rcu-walk mode */
-		if (nameidata_drop_rcu(nd))
-			return -ECHILD;
+		BUG_ON(nd->flags & LOOKUP_RCU);
 		d_invalidate(dentry);
 		status = -ESTALE;
 	}


