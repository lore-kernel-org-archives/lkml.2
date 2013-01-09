Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934138Ab3AIUtU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 15:49:20 -0500
Received: from mail.kernel.org ([198.145.19.201]:43950 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934081Ab3AIUlV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 15:41:21 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>,
        Alexander Holler <holler@ahsoftware.de>,
        Vincent Palatin <vpalatin@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 115/123] revert "rtc: recycle id when unloading a rtc driver"
Date: Wed,  9 Jan 2013 12:35:54 -0800
Message-Id: <20130109201513.147383741@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130109201458.392601412@linuxfoundation.org>
References: <20130109201458.392601412@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Morton <akpm@linux-foundation.org>

commit 5abe257af8b95857b95fa0ba694530b446ae32d8 upstream.

Revert commit 2830a6d20139df2198d63235df7957712adb28e5.

We already perform the ida_simple_remove() in rtc_device_release(),
which is an appropriate place.  Commit 2830a6d20 ("rtc: recycle id when
unloading a rtc driver") caused the kernel to emit

	ida_remove called for id=0 which is not allocated.

warnings when rtc_device_release() tries to release an alread-released
ID.

Let's restore things to their previous state and then work out why
Vincent's kernel wasn't calling rtc_device_release() - presumably a bug
in a specific sub-driver.

Reported-by: Lothar Waßmann <LW@KARO-electronics.de>
Acked-by: Alexander Holler <holler@ahsoftware.de>
Cc: Vincent Palatin <vpalatin@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/rtc/class.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/rtc/class.c
+++ b/drivers/rtc/class.c
@@ -244,7 +244,6 @@ void rtc_device_unregister(struct rtc_de
 		rtc_proc_del_device(rtc);
 		device_unregister(&rtc->dev);
 		rtc->ops = NULL;
-		ida_simple_remove(&rtc_ida, rtc->id);
 		mutex_unlock(&rtc->ops_lock);
 		put_device(&rtc->dev);
 	}


