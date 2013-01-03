Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752849Ab3ACBQ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 20:16:59 -0500
Received: from ozlabs.org ([203.10.76.45]:44995 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752739Ab3ACBQ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 20:16:58 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Sasha Levin <sasha.levin@oracle.com>, linux-kernel@vger.kernel.org
Cc: Sasha Levin <sasha.levin@oracle.com>
Subject: Re: [PATCH] module: prevent warning when finit_module a 0 sized file
In-Reply-To: <1356722837-1457-1-git-send-email-sasha.levin@oracle.com>
References: <1356722837-1457-1-git-send-email-sasha.levin@oracle.com>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Thu, 03 Jan 2013 11:11:03 +1030
Message-ID: <877gnv5c9s.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sasha Levin <sasha.levin@oracle.com> writes:

> If we try to finit_module on a file sized 0 bytes vmalloc will
> scream and spit out a warning.
>
> Since modules have to be bigger than 0 bytes anyways we can just
> check that beforehand and avoid the warning.

Applied, but I added the comment you somehow missed :)

Thanks,
Rusty.

diff --git a/kernel/module.c b/kernel/module.c
index 250092c..41bc118 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2527,6 +2527,13 @@ static int copy_module_from_fd(int fd, struct load_info *info)
 		err = -EFBIG;
 		goto out;
 	}
+
+	/* Don't hand 0 to vmalloc, it whines. */
+	if (stat.size == 0) {
+		err = -EINVAL;
+		goto out;
+	}
+
 	info->hdr = vmalloc(stat.size);
 	if (!info->hdr) {
 		err = -ENOMEM;
