Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754786Ab2HMWEt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 18:04:49 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:56083 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754722Ab2HMWEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 18:04:38 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "Theodore Tso" <tytso@mit.edu>, "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [ 17/44] random: Use arch-specific RNG to initialize the entropy store
Date: Mon, 13 Aug 2012 15:02:24 -0700
Message-Id: <20120813220143.656808815@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120813220142.113186818@linuxfoundation.org>
References: <20120813220142.113186818@linuxfoundation.org>
User-Agent: quilt/0.60-20.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Theodore Ts'o <tytso@mit.edu>

commit 3e88bdff1c65145f7ba297ccec69c774afe4c785 upstream.

If there is an architecture-specific random number generator (such as
RDRAND for Intel architectures), use it to initialize /dev/random's
entropy stores.  Even in the worst case, if RDRAND is something like
AES(NSA_KEY, counter++), it won't hurt, and it will definitely help
against any other adversaries.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Link: http://lkml.kernel.org/r/1324589281-31931-1-git-send-email-tytso@mit.edu
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/char/random.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -965,6 +965,7 @@ EXPORT_SYMBOL(get_random_bytes);
  */
 static void init_std_data(struct entropy_store *r)
 {
+	int i;
 	ktime_t now;
 	unsigned long flags;
 
@@ -974,6 +975,11 @@ static void init_std_data(struct entropy
 
 	now = ktime_get_real();
 	mix_pool_bytes(r, &now, sizeof(now));
+	for (i = r->poolinfo->poolwords; i; i--) {
+		if (!arch_get_random_long(&flags))
+			break;
+		mix_pool_bytes(r, &flags, sizeof(flags));
+	}
 	mix_pool_bytes(r, utsname(), sizeof(*(utsname())));
 }
 


