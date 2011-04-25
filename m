Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932383Ab1DYUZI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:25:08 -0400
Received: from 1wt.eu ([62.212.114.60]:34418 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932335Ab1DYUY7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:24:59 -0400
Message-Id: <20110425200239.336658959@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 25 Apr 2011 22:04:58 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: Jason Wessel <jason.wessel@windriver.com>,
        Dongdong Deng <dongdong.deng@windriver.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 146/173] repair gdbstub to match the gdbserial protocol specification
In-Reply-To: <46075c3a3ef08be6d70339617d6afc98@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.59-stable review patch.  If anyone has any objections, please let us know.

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
@@ -1001,10 +1001,8 @@ static void gdb_cmd_query(struct kgdb_st
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
@@ -1045,10 +1043,9 @@ static void gdb_cmd_query(struct kgdb_st
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


