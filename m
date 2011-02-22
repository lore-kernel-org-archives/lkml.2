Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755421Ab1BVWZ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 17:25:59 -0500
Received: from kroah.org ([198.145.64.141]:32976 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755056Ab1BVWW0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 17:22:26 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 22 14:18:42 2011
Message-Id: <20110222221842.721525715@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 22 Feb 2011 14:17:36 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        David Howells <dhowells@redhat.com>, Jeff Layton <jlayton@redhat.com>,
        Steve French <sfrench@us.ibm.com>
Subject: [57/70] cifs: fix handling of scopeid in cifs_convert_address
In-Reply-To: <20110222222003.GA15831@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jeff Layton <jlayton@redhat.com>

commit 9616125611ee47693186533d76e403856a36b3c8 upstream.

The code finds, the '%' sign in an ipv6 address and copies that to a
buffer allocated on the stack. It then ignores that buffer, and passes
'pct' to simple_strtoul(), which doesn't work right because we're
comparing 'endp' against a completely different string.

Fix it by passing the correct pointer. While we're at it, this is a
good candidate for conversion to strict_strtoul as well.

Cc: David Howells <dhowells@redhat.com>
Reported-by: BjÃ¶rn JACKE <bj@sernet.de>
Signed-off-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Steve French <sfrench@us.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/cifs/netmisc.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/fs/cifs/netmisc.c
+++ b/fs/cifs/netmisc.c
@@ -170,7 +170,7 @@ cifs_convert_address(struct sockaddr *ds
 {
 	int rc, alen, slen;
 	const char *pct;
-	char *endp, scope_id[13];
+	char scope_id[13];
 	struct sockaddr_in *s4 = (struct sockaddr_in *) dst;
 	struct sockaddr_in6 *s6 = (struct sockaddr_in6 *) dst;
 
@@ -197,9 +197,9 @@ cifs_convert_address(struct sockaddr *ds
 		memcpy(scope_id, pct + 1, slen);
 		scope_id[slen] = '\0';
 
-		s6->sin6_scope_id = (u32) simple_strtoul(pct, &endp, 0);
-		if (endp != scope_id + slen)
-			return 0;
+		rc = strict_strtoul(scope_id, 0,
+					(unsigned long *)&s6->sin6_scope_id);
+		rc = (rc == 0) ? 1 : 0;
 	}
 
 	return rc;


