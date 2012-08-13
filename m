Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753705Ab2HMUo6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 16:44:58 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:51310 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752083Ab2HMUUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 16:20:30 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Al Viro <viro@zeniv.linux.org.uk>, Dave Jones <davej@redhat.com>,
        James Morris <james.l.morris@oracle.com>
Subject: [ 06/82] selinux: fix selinux_inode_setxattr oops
Date: Mon, 13 Aug 2012 13:18:42 -0700
Message-Id: <20120813201747.017934751@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120813201746.448504360@linuxfoundation.org>
References: <20120813201746.448504360@linuxfoundation.org>
User-Agent: quilt/0.60-20.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@ZenIV.linux.org.uk>

commit e3fea3f70fd68af0574a5f24246cdb4ed07f2b74 upstream.

OK, what we have so far is e.g.
	setxattr(path, name, whatever, 0, XATTR_REPLACE)
with name being good enough to get through xattr_permission().
Then we reach security_inode_setxattr() with the desired value and size.
Aha.  name should begin with "security.selinux", or we won't get that
far in selinux_inode_setxattr().  Suppose we got there and have enough
permissions to relabel that sucker.  We call security_context_to_sid()
with value == NULL, size == 0.  OK, we want ss_initialized to be non-zero.
I.e. after everything had been set up and running.  No problem...

We do 1-byte kmalloc(), zero-length memcpy() (which doesn't oops, even
thought the source is NULL) and put a NUL there.  I.e. form an empty
string.  string_to_context_struct() is called and looks for the first
':' in there.  Not found, -EINVAL we get.  OK, security_context_to_sid_core()
has rc == -EINVAL, force == 0, so it silently returns -EINVAL.
All it takes now is not having CAP_MAC_ADMIN and we are fucked.

All right, it might be a different bug (modulo strange code quoted in the
report), but it's real.  Easily fixed, AFAICS:

Deal with size == 0, value == NULL case in selinux_inode_setxattr()

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Tested-by: Dave Jones <davej@redhat.com>
Reported-by: Dave Jones <davej@redhat.com>
Signed-off-by: James Morris <james.l.morris@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 security/selinux/hooks.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -2792,11 +2792,16 @@ static int selinux_inode_setxattr(struct
 
 			/* We strip a nul only if it is at the end, otherwise the
 			 * context contains a nul and we should audit that */
-			str = value;
-			if (str[size - 1] == '\0')
-				audit_size = size - 1;
-			else
-				audit_size = size;
+			if (value) {
+				str = value;
+				if (str[size - 1] == '\0')
+					audit_size = size - 1;
+				else
+					audit_size = size;
+			} else {
+				str = "";
+				audit_size = 0;
+			}
 			ab = audit_log_start(current->audit_context, GFP_ATOMIC, AUDIT_SELINUX_ERR);
 			audit_log_format(ab, "op=setxattr invalid_context=");
 			audit_log_n_untrustedstring(ab, value, audit_size);


