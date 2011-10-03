Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753328Ab1JCD72 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 23:59:28 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58170 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751804Ab1JCD7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 23:59:21 -0400
Date: Sun, 2 Oct 2011 22:59:07 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: LKML <linux-kernel@vger.kernel.org>, git@vger.kernel.org
Subject: unable to resolve reference refs/tags/v3.1-rc8: Success (Re: git
 problem)
Message-ID: <20111003035907.GA17134@elie>
References: <4E892483.7070605@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E892483.7070605@lwfinger.net>
User-Agent: Mutt/1.5.21+46 (b01d63af6fea) (2011-07-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Larry Finger wrote:

> I had my system freeze when doing a pull from Linus's repo. Since then,
> every pull results in the following errors:
>
> ~> git pull
> error: unable to resolve reference refs/tags/v3.1-rc8: Success
> From git://github.com/torvalds/linux
>  ! [new tag]         v3.1-rc8   -> v3.1-rc8  (unable to update local ref)

Could you try pulling again with
"/path/to/git/sources/bin-wrappers/git pull" after applying this
patch?

Thanks,

diff --git i/refs.c w/refs.c
index a615043b..b15f78a4 100644
--- i/refs.c
+++ w/refs.c
@@ -493,12 +493,15 @@ const char *resolve_ref(const char *ref, unsigned char *sha1, int reading, int *
 		char *buf;
 		int fd;
 
-		if (--depth < 0)
+		if (--depth < 0) {
+			errno = ELOOP;
 			return NULL;
+		}
 
 		git_snpath(path, sizeof(path), "%s", ref);
 		/* Special case: non-existing file. */
 		if (lstat(path, &st) < 0) {
+			int saved_errno = errno;
 			struct ref_list *list = get_packed_refs(NULL);
 			while (list) {
 				if (!strcmp(ref, list->name)) {
@@ -509,6 +512,7 @@ const char *resolve_ref(const char *ref, unsigned char *sha1, int reading, int *
 				}
 				list = list->next;
 			}
+			errno = saved_errno;
 			if (reading || errno != ENOENT)
 				return NULL;
 			hashclr(sha1);
@@ -562,7 +566,8 @@ const char *resolve_ref(const char *ref, unsigned char *sha1, int reading, int *
 			*flag |= REF_ISSYMREF;
 	}
 	if (len < 40 || get_sha1_hex(buffer, sha1))
-		return NULL;
+		die("ref %s is corrupt: length=%d, content=%.*s", ref,
+		    (int) len, (int) len, buffer);
 	return ref;
 }
 
