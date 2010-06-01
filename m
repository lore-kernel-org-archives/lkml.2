Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756093Ab0FAQRb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 12:17:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6153 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755601Ab0FAQRa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 12:17:30 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] AFS: Fix possible null pointer dereference in
	afs_alloc_server()
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org,
       Denis Kirjanov <dkirjanov@kernel.org>,
       David Howells <dhowells@redhat.com>
Date: Tue, 01 Jun 2010 17:15:39 +0100
Message-ID: <20100601161538.2174.57858.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Denis Kirjanov <dkirjanov@hera.kernel.org>

Fix a possible null pointer dereference in afs_alloc_server(): the server
pointer is NULL if there was an allocation failure, and under such a
condition, we can't dereference it in the _leave() statement.

Signed-off-by: Denis Kirjanov <dkirjanov@kernel.org>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/afs/server.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/afs/server.c b/fs/afs/server.c
index f490995..9fdc7fe 100644
--- a/fs/afs/server.c
+++ b/fs/afs/server.c
@@ -91,9 +91,10 @@ static struct afs_server *afs_alloc_server(struct afs_cell *cell,
 
 		memcpy(&server->addr, addr, sizeof(struct in_addr));
 		server->addr.s_addr = addr->s_addr;
+		_leave(" = %p{%d}", server, atomic_read(&server->usage));
+	} else {
+		_leave(" = NULL [nomem]");
 	}
-
-	_leave(" = %p{%d}", server, atomic_read(&server->usage));
 	return server;
 }
 

