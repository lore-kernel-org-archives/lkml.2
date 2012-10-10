Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933159Ab2JKAXX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 20:23:23 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:41440 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933006Ab2JKAXT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 20:23:19 -0400
X-Sasl-enc: L1gbO/TQT0FET7BnwExQ3uZCZnY4wM2CbtqpsOodhPue 1349914998
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Frediano Ziglio <frediano.ziglio@citrix.com>,
        Jeff Layton <jlayton@redhat.com>, Steve French <smfrench@gmail.com>
Subject: [ 122/122] Convert properly UTF-8 to UTF-16
Date: Thu, 11 Oct 2012 07:54:48 +0900
Message-Id: <20121010225359.910162165@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121010225337.989799482@linuxfoundation.org>
References: <20121010225337.989799482@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frediano Ziglio <frediano.ziglio@citrix.com>

commit fd3ba42c76d3d4b776120c2b24c1791e7bb3deb1 upstream.

wchar_t is currently 16bit so converting a utf8 encoded characters not
in plane 0 (>= 0x10000) to wchar_t (that is calling char2uni) lead to a
-EINVAL return. This patch detect utf8 in cifs_strtoUTF16 and add special
code calling utf8s_to_utf16s.

Signed-off-by: Frediano Ziglio <frediano.ziglio@citrix.com>
Acked-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Steve French <smfrench@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/cifs_unicode.c |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

--- a/fs/cifs/cifs_unicode.c
+++ b/fs/cifs/cifs_unicode.c
@@ -203,6 +203,27 @@ cifs_strtoUTF16(__le16 *to, const char *
 	int i;
 	wchar_t wchar_to; /* needed to quiet sparse */
 
+	/* special case for utf8 to handle no plane0 chars */
+	if (!strcmp(codepage->charset, "utf8")) {
+		/*
+		 * convert utf8 -> utf16, we assume we have enough space
+		 * as caller should have assumed conversion does not overflow
+		 * in destination len is length in wchar_t units (16bits)
+		 */
+		i  = utf8s_to_utf16s(from, len, UTF16_LITTLE_ENDIAN,
+				       (wchar_t *) to, len);
+
+		/* if success terminate and exit */
+		if (i >= 0)
+			goto success;
+		/*
+		 * if fails fall back to UCS encoding as this
+		 * function should not return negative values
+		 * currently can fail only if source contains
+		 * invalid encoded characters
+		 */
+	}
+
 	for (i = 0; len && *from; i++, from += charlen, len -= charlen) {
 		charlen = codepage->char2uni(from, len, &wchar_to);
 		if (charlen < 1) {
@@ -215,6 +236,7 @@ cifs_strtoUTF16(__le16 *to, const char *
 		put_unaligned_le16(wchar_to, &to[i]);
 	}
 
+success:
 	put_unaligned_le16(0, &to[i]);
 	return i;
 }


