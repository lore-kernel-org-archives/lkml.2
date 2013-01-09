Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934034Ab3AIUyL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 15:54:11 -0500
Received: from mail.kernel.org ([198.145.19.201]:43795 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934002Ab3AIUlE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 15:41:04 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Tim Perry <tdparmor-sambabugs@yahoo.com>,
        Jeff Layton <jlayton@redhat.com>, Steve French <smfrench@gmail.com>
Subject: [ 102/123] cifs: adjust sequence number downward after signing NT_CANCEL request
Date: Wed,  9 Jan 2013 12:35:41 -0800
Message-Id: <20130109201511.635053640@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130109201458.392601412@linuxfoundation.org>
References: <20130109201458.392601412@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@redhat.com>

commit 31efee60f489c759c341454d755a9fd13de8c03d upstream.

When a call goes out, the signing code adjusts the sequence number
upward by two to account for the request and the response. An NT_CANCEL
however doesn't get a response of its own, it just hurries the server
along to get it to respond to the original request more quickly.
Therefore, we must adjust the sequence number back down by one after
signing a NT_CANCEL request.

Reported-by: Tim Perry <tdparmor-sambabugs@yahoo.com>
Signed-off-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Steve French <smfrench@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/smb1ops.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -53,6 +53,13 @@ send_nt_cancel(struct TCP_Server_Info *s
 		mutex_unlock(&server->srv_mutex);
 		return rc;
 	}
+
+	/*
+	 * The response to this call was already factored into the sequence
+	 * number when the call went out, so we must adjust it back downward
+	 * after signing here.
+	 */
+	--server->sequence_number;
 	rc = smb_send(server, in_buf, be32_to_cpu(in_buf->smb_buf_length));
 	mutex_unlock(&server->srv_mutex);
 


