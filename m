Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756979Ab1JRA4J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 20:56:09 -0400
Received: from smtp-out.google.com ([74.125.121.67]:27345 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751881Ab1JRA4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 20:56:07 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	message-id:user-agent:mime-version:content-type:x-system-of-record;
	b=m42ga7zDRciZFrZCl6YBD9LUnXv47Jo3kcPB+D4+81eXqlEdR227F5eu0iZvc5OyQ
	S98wHWRIetEYDQ7iXe6lw==
Date: Mon, 17 Oct 2011 17:55:58 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Henrik Grindal Bakken <henribak@cisco.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org
Subject: [patch] Avoid using hardcoded values in kernel/sys.c
Message-ID: <alpine.DEB.2.00.1110171752300.19024@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The release field of struct new_utsname may always change, so avoid
hardcoded values when setting up a buffer to copy to it.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 kernel/sys.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/kernel/sys.c b/kernel/sys.c
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1169,10 +1169,11 @@ DECLARE_RWSEM(uts_sem);
  * Work around broken programs that cannot handle "Linux 3.0".
  * Instead we map 3.x to 2.6.40+x, so e.g. 3.0 would be 2.6.40
  */
-static int override_release(char __user *release, int len)
+static int override_release(char __user *release)
 {
+	const int len = sizeof(release);
 	int ret = 0;
-	char buf[65];
+	char buf[len];
 
 	if (current->personality & UNAME26) {
 		char *rest = UTS_RELEASE;
@@ -1202,7 +1203,7 @@ SYSCALL_DEFINE1(newuname, struct new_utsname __user *, name)
 		errno = -EFAULT;
 	up_read(&uts_sem);
 
-	if (!errno && override_release(name->release, sizeof(name->release)))
+	if (!errno && override_release(name->release))
 		errno = -EFAULT;
 	if (!errno && override_architecture(name))
 		errno = -EFAULT;
@@ -1225,7 +1226,7 @@ SYSCALL_DEFINE1(uname, struct old_utsname __user *, name)
 		error = -EFAULT;
 	up_read(&uts_sem);
 
-	if (!error && override_release(name->release, sizeof(name->release)))
+	if (!error && override_release(name->release))
 		error = -EFAULT;
 	if (!error && override_architecture(name))
 		error = -EFAULT;
@@ -1261,7 +1262,7 @@ SYSCALL_DEFINE1(olduname, struct oldold_utsname __user *, name)
 
 	if (!error && override_architecture(name))
 		error = -EFAULT;
-	if (!error && override_release(name->release, sizeof(name->release)))
+	if (!error && override_release(name->release))
 		error = -EFAULT;
 	return error ? -EFAULT : 0;
 }
