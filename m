Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758656Ab2JKNUV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 09:20:21 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:53183 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758503Ab2JKNUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 09:20:15 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH v2] vfs: bogus warnings in fs/namei.c
Date: Thu, 11 Oct 2012 13:20:00 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Jan Kara <jack@suse.cz>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, arm@kernel.org,
        linux-fsdevel@vger.kernel.org
References: <1349448930-23976-1-git-send-email-arnd@arndb.de> <201210091307.19225.arnd@arndb.de> <20121011043734.GE2616@ZenIV.linux.org.uk>
In-Reply-To: <20121011043734.GE2616@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201210111320.01047.arnd@arndb.de>
X-Provags-ID: V02:K0:vLFwG6SVYnmFvRGFlhwGxIM2UOzYY/UVCu6ipTQwa5z
 N26GqWNNLRQdshrd1Yr2L85LR0/YjECBv2RAKuzeYw3Y+1NfzR
 kTbeR4uL+iCYx9W3N1yVm56twmZo3iSCi5lMGSp/9tIzN3S6UZ
 f7Co9orCiR1YkUBH8ePeFjMZKSs+RHtAA+H6pcOweVl3fhC9CN
 kP2zWfOptY44cdmqrYO/sWv9RN1rof2S2xBLR39jqrMtfIg07p
 pbO8ujXm9STgIsIxmf6lSZwRkZg9s9OkGhjC3uIvHuzoZZrfGp
 cbLOTURllZISOg/vIpDu02YK0LY8AhZ8bAuu3sll25gaMKFI5C
 UuEwsKzCKnozrvYLVBJA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The follow_link() function always initializes its *p argument,
or returns an error, but when building with 'gcc -s', the compiler
gets confused by the __always_inline attribute to the function
and can no longer detect where the cookie was initialized.

The solution is to always initialize the pointer from follow_link,
even in the error path. When building with -O2, this has zero impact
on generated code and adds a single instruction in the error path
for a -Os build on ARM.

Without this patch, building with gcc-4.6 through gcc-4.8 and
CONFIG_CC_OPTIMIZE_FOR_SIZE results in:

fs/namei.c: In function 'link_path_walk':
fs/namei.c:649:24: warning: 'cookie' may be used uninitialized in this function [-Wuninitialized]
fs/namei.c:1544:9: note: 'cookie' was declared here
fs/namei.c: In function 'path_lookupat':
fs/namei.c:649:24: warning: 'cookie' may be used uninitialized in this function [-Wuninitialized]
fs/namei.c:1934:10: note: 'cookie' was declared here
fs/namei.c: In function 'path_openat':
fs/namei.c:649:24: warning: 'cookie' may be used uninitialized in this function [-Wuninitialized]
fs/namei.c:2899:9: note: 'cookie' was declared here

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

diff --git a/fs/namei.c b/fs/namei.c
index 6d47fac..c1f18e4 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -810,6 +810,7 @@ follow_link(struct path *link, struct nameidata *nd, void **p)
 	return error;
 
 out_put_nd_path:
+	*p = NULL;
 	path_put(&nd->path);
 	path_put(link);
 	return error;
