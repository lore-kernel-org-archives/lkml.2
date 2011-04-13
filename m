Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933135Ab1DMQTI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 12:19:08 -0400
Received: from kroah.org ([198.145.64.141]:52971 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932928Ab1DMQNX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 12:13:23 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Apr 13 09:10:48 2011
Message-Id: <20110413161047.988965943@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 13 Apr 2011 09:10:15 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jason Wessel <jason.wessel@windriver.com>,
        Dongdong Deng <dongdong.deng@windriver.com>
Subject: [52/71] repair gdbstub to match the gdbserial protocol specification
In-Reply-To: <20110413161106.GA20405@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Jason Wessel <jason.wessel@windriver.com>

commit fb82c0ff27b2c40c6f7a3d1a94cafb154591fa80 upstream.

The gdbserial protocol handler should return an empty packet instead
of an error string when ever it responds to a command it does not
implement.

The problem cases come from a debugger client sending
qTBuffer, qTStatus, qSearch, qSupported.

The incorrect response from the gdbstub leads the debugger clients to
not function correctly.  Recent versions of gdb will not detach correctly as a result of this behavior.

Backport-request-by: Frank Pan <frankpzh@gmail.com>
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
Signed-off-by: Dongdong Deng <dongdong.deng@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 kernel/kgdb.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

--- a/kernel/kgdb.c
+++ b/kernel/kgdb.c
@@ -1017,10 +1017,8 @@ static void gdb_cmd_query(struct kgdb_st
 	switch (remcom_in_buffer[1]) {
 	case 's':
 	case 'f':
-		if (memcmp(remcom_in_buffer + 2, "ThreadInfo", 10)) {
-			error_packet(remcom_out_buffer, -EINVAL);
+		if (memcmp(remcom_in_buffer + 2, "ThreadInfo", 10))
 			break;
-		}
 
 		i = 0;
 		remcom_out_buffer[0] = 'm';
@@ -1061,10 +1059,9 @@ static void gdb_cmd_query(struct kgdb_st
 		pack_threadid(remcom_out_buffer + 2, thref);
 		break;
 	case 'T':
-		if (memcmp(remcom_in_buffer + 1, "ThreadExtraInfo,", 16)) {
-			error_packet(remcom_out_buffer, -EINVAL);
+		if (memcmp(remcom_in_buffer + 1, "ThreadExtraInfo,", 16))
 			break;
-		}
+
 		ks->threadid = 0;
 		ptr = remcom_in_buffer + 17;
 		kgdb_hex2long(&ptr, &ks->threadid);


