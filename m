Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755525Ab2ACWgu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 17:36:50 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39617 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752745Ab2ACWgq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 17:36:46 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Jan  3 14:30:32 2012
Message-Id: <20120103223032.764951931@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Tue, 03 Jan 2012 14:29:35 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Michel Lespinasse <walken@google.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>, Eric Paris <eparis@redhat.com>
Subject: [17/67] binary_sysctl(): fix memory leak
In-Reply-To: <20120103223043.GA26738@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michel Lespinasse <walken@google.com>

commit 3d3c8f93a237b64580c5c5e138edeb1377e98230 upstream.

binary_sysctl() calls sysctl_getname() which allocates from names_cache
slab usin __getname()

The matching function to free the name is __putname(), and not putname()
which should be used only to match getname() allocations.

This is because when auditing is enabled, putname() calls audit_putname
*instead* (not in addition) to __putname().  Then, if a syscall is in
progress, audit_putname does not release the name - instead, it expects
the name to get released when the syscall completes, but that will happen
only if audit_getname() was called previously, i.e.  if the name was
allocated with getname() rather than the naked __getname().  So,
__getname() followed by putname() ends up leaking memory.

Signed-off-by: Michel Lespinasse <walken@google.com>
Acked-by: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Eric Paris <eparis@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/sysctl_binary.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/sysctl_binary.c
+++ b/kernel/sysctl_binary.c
@@ -1354,7 +1354,7 @@ static ssize_t binary_sysctl(const int *
 
 	fput(file);
 out_putname:
-	putname(pathname);
+	__putname(pathname);
 out:
 	return result;
 }


