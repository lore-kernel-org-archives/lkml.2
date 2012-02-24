Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754438Ab2BXCnX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 21:43:23 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58670 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754069Ab2BXCnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 21:43:21 -0500
Date: Thu, 23 Feb 2012 18:42:58 -0800
From: tip-bot for Bobby Powers <bobbypowers@gmail.com>
Message-ID: <tip-f044db4cb4bf16893812d35b5fbeaaf3e30c9215@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, bobbypowers@gmail.com, hpa@zytor.com,
        mingo@redhat.com, dhowells@redhat.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, bobbypowers@gmail.com,
        linux-kernel@vger.kernel.org, dhowells@redhat.com, tglx@linutronix.de
In-Reply-To: <1329888587-3087-1-git-send-email-bobbypowers@gmail.com>
References: <1329888587-3087-1-git-send-email-bobbypowers@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/types] fs: Fix close_on_exec pointer in alloc_fdtable
Git-Commit-ID: f044db4cb4bf16893812d35b5fbeaaf3e30c9215
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 23 Feb 2012 18:43:04 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f044db4cb4bf16893812d35b5fbeaaf3e30c9215
Gitweb:     http://git.kernel.org/tip/f044db4cb4bf16893812d35b5fbeaaf3e30c9215
Author:     Bobby Powers <bobbypowers@gmail.com>
AuthorDate: Wed, 22 Feb 2012 00:29:47 -0500
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Thu, 23 Feb 2012 18:28:52 -0800

fs: Fix close_on_exec pointer in alloc_fdtable

alloc_fdtable allocates space for the open_fds and close_on_exec
bitfields together, as 2 * nr / BITS_PER_BYTE.  close_on_exec needs to
point to open_fds + nr / BITS_PER_BYTE, not open_fds + nr /
BITS_PER_LONG, as introducted in 1fd36adc: Replace the fd_sets in
struct fdtable with an array of unsigned longs.

Signed-off-by: Bobby Powers <bobbypowers@gmail.com>
Link: http://lkml.kernel.org/r/1329888587-3087-1-git-send-email-bobbypowers@gmail.com
Acked-by: David Howells <dhowells@redhat.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 fs/file.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/file.c b/fs/file.c
index 2d479dd..171f6b4 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -179,7 +179,7 @@ static struct fdtable * alloc_fdtable(unsigned int nr)
 	if (!data)
 		goto out_arr;
 	fdt->open_fds = data;
-	data += nr / BITS_PER_LONG;
+	data += nr / BITS_PER_BYTE;
 	fdt->close_on_exec = data;
 	fdt->next = NULL;
 
