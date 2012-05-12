Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761458Ab2ELASr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 20:18:47 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55013 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754894Ab2ELASo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 20:18:44 -0400
Date: Fri, 11 May 2012 17:17:17 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>, Colin Cross <ccross@android.com>
Cc: Arnd Bergmann <arnd@arndb.de>, John Stultz <john.stultz@linaro.org>,
        arve@android.com, Rebecca Schultz Zavin <rebecca@android.com>,
        Jesper Juhl <jj@chaosbits.net>, Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Boyd <sboyd@codeaurora.org>, Thomas Meyer <thomas@m3y3r.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marco Stornelli <marco.stornelli@gmail.com>,
        WANG Cong <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com
Subject: [PATCH 02/11] persistent_ram: Fix buffer size clamping during writes
Message-ID: <20120512001717.GB14782@lizard>
References: <20120512001506.GA8653@lizard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120512001506.GA8653@lizard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
 drivers/staging/android/persistent_ram.c |   19 +------------------
 1 file changed, 1 insertion(+), 18 deletions(-)

diff --git a/drivers/staging/android/persistent_ram.c b/drivers/staging/android/persistent_ram.c
index 12444fd..13a12bc 100644
--- a/drivers/staging/android/persistent_ram.c
+++ b/drivers/staging/android/persistent_ram.c
@@ -79,23 +79,6 @@ static inline void buffer_size_add(struct persistent_ram_zone *prz, size_t a)
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
@@ -300,7 +283,7 @@ int notrace persistent_ram_write(struct persistent_ram_zone *prz,
 		c = prz->buffer_size;
 	}
 
-	buffer_size_add_clamp(prz, c);
+	buffer_size_add(prz, c);
 
 	start = buffer_start_add(prz, c);
 
-- 
1.7.9.2

