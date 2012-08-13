Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754600Ab2HMWEM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 18:04:12 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:42647 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754562Ab2HMWEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 18:04:10 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "H. Peter Anvin" <hpa@linux.intel.com>, "Theodore Tso" <tytso@mit.edu>
Subject: [ 18/44] random: Adjust the number of loops when initializing
Date: Mon, 13 Aug 2012 15:02:25 -0700
Message-Id: <20120813220143.745266544@linuxfoundation.org>
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

From: "H. Peter Anvin" <hpa@linux.intel.com>

commit 2dac8e54f988ab58525505d7ef982493374433c3 upstream.

When we are initializing using arch_get_random_long() we only need to
loop enough times to touch all the bytes in the buffer; using
poolwords for that does twice the number of operations necessary on a
64-bit machine, since in the random number generator code "word" means
32 bits.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Link: http://lkml.kernel.org/r/1324589281-31931-1-git-send-email-tytso@mit.edu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/char/random.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -975,7 +975,7 @@ static void init_std_data(struct entropy
 
 	now = ktime_get_real();
 	mix_pool_bytes(r, &now, sizeof(now));
-	for (i = r->poolinfo->poolwords; i; i--) {
+	for (i = r->poolinfo->POOLBYTES; i > 0; i -= sizeof flags) {
 		if (!arch_get_random_long(&flags))
 			break;
 		mix_pool_bytes(r, &flags, sizeof(flags));


