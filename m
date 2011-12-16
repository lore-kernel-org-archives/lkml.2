Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760630Ab1LPUIO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 15:08:14 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44902 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760650Ab1LPTtB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 14:49:01 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Dec 16 11:45:57 2011
Message-Id: <20111216194557.773954158@clark.kroah.org>
User-Agent: quilt/0.50-24.1
Date: Fri, 16 Dec 2011 11:45:20 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Roland Dreier <roland@purestorage.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [23/53] target: Handle 0 correctly in transport_get_sectors_6()
In-Reply-To: <20111216194613.GA18395@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roland Dreier <roland@purestorage.com>

commit 9b5cd7f37e1e018432111333e2a67f78ba41edfe upstream.

SBC-3 says:

    A TRANSFER LENGTH field set to zero specifies that 256 logical
    blocks shall be written.  Any other value specifies the number
    of logical blocks that shall be written.

The old code was always just returning the value in the TRANSFER LENGTH
byte.  Fix this to return 256 if the byte is 0.

Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/target/target_core_transport.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -2562,10 +2562,15 @@ static inline u32 transport_get_sectors_
 
 	/*
 	 * Everything else assume TYPE_DISK Sector CDB location.
-	 * Use 8-bit sector value.
+	 * Use 8-bit sector value.  SBC-3 says:
+	 *
+	 *   A TRANSFER LENGTH field set to zero specifies that 256
+	 *   logical blocks shall be written.  Any other value
+	 *   specifies the number of logical blocks that shall be
+	 *   written.
 	 */
 type_disk:
-	return (u32)cdb[4];
+	return cdb[4] ? : 256;
 }
 
 static inline u32 transport_get_sectors_10(


