Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756620Ab2E0BQP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 21:16:15 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43902 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965663Ab2E0BQD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 21:16:03 -0400
Message-Id: <20120527002513.156229815@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Sun, 27 May 2012 09:25:35 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Anton Vorontsov <anton.vorontsov@linaro.org>,
        Colin Cross <ccross@android.com>
Subject: [ 29/91] persistent_ram: Fix buffer size clamping during writes
In-Reply-To: <20120527010903.GA18244@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anton Vorontsov <anton.vorontsov@linaro.org>

commit 484dd30e016eb425b0de871357fff2c9bb93be45 upstream.

This is a longstanding bug, almost unnoticeable when calling
persistent_ram_write() for small buffers.

But when called for large data buffers, the write routine behaves
incorrectly, as the size may never update: instead of clamping
the size to the maximum buffer size, buffer_size_add_clamp() returns
an error (which is never checked by the write routine, btw).

To fix this, we now use buffer_size_add() that actually clamps the
size to the max value.

Also remove buffer_size_add_clamp(), it is no longer needed.

Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
Acked-by: Colin Cross <ccross@android.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/android/persistent_ram.c |   19 +------------------
 1 file changed, 1 insertion(+), 18 deletions(-)

--- a/drivers/staging/android/persistent_ram.c
+++ b/drivers/staging/android/persistent_ram.c
@@ -79,23 +79,6 @@ static inline void buffer_size_add(struc
 	} while (atomic_cmpxchg(&prz->buffer->size, old, new) != old);
 }
 
-/* increase the size counter, retuning an error if it hits the max size */
-static inline ssize_t buffer_size_add_clamp(struct persistent_ram_zone *prz,
-	size_t a)
-{
-	size_t old;
-	size_t new;
-
-	do {
-		old = atomic_read(&prz->buffer->size);
-		new = old + a;
-		if (new > prz->buffer_size)
-			return -ENOMEM;
-	} while (atomic_cmpxchg(&prz->buffer->size, old, new) != old);
-
-	return 0;
-}
-
 static void notrace persistent_ram_encode_rs8(struct persistent_ram_zone *prz,
 	uint8_t *data, size_t len, uint8_t *ecc)
 {
@@ -300,7 +283,7 @@ int notrace persistent_ram_write(struct
 		c = prz->buffer_size;
 	}
 
-	buffer_size_add_clamp(prz, c);
+	buffer_size_add(prz, c);
 
 	start = buffer_start_add(prz, c);
 


