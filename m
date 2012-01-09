Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754639Ab2AII1w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 03:27:52 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:51631 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751467Ab2AII1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 03:27:51 -0500
Date: Mon, 9 Jan 2012 00:27:45 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Che-Liang Chiou <clchiou@chromium.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Input: serio_raw - return error code instead of
 written on error
Message-ID: <20120109082745.GD4049@core.coreip.homeip.net>
References: <1325847795-30486-1-git-send-email-clchiou@chromium.org>
 <1325847795-30486-2-git-send-email-clchiou@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1325847795-30486-2-git-send-email-clchiou@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Che-Liang,

On Fri, Jan 06, 2012 at 07:03:15PM +0800, Che-Liang Chiou wrote:
> Even if an error occurs and error code is set, serio_raw_write() returns
> the amount of bytes written anyway.
> 
> If this behavior is actually desirable, serio_raw_write() should not
> even bother to set the error code because it is not intended to be
> returned to the caller.

Thank you for letting me know. The proper behavior is to return number of
bytes successfully written in case of short (or full) transfer, and
return appropriate error in case when we fail to transmit the very first
byte.

I will be applying the patch below.

Thanks.

-- 
Dmitry

Input: serio-raw - return proper result when serio_raw_write fails

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

If serio_raw_write was always returning number of bytes successfully
sent to serio port and never signalled error condition to the caller.
Change it so that for completely failed transfers appropriate error
code returned to the caller (partially successful writes still return
number of bytes transferred).

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/input/serio/serio_raw.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/drivers/input/serio/serio_raw.c b/drivers/input/serio/serio_raw.c
index c2c6ad8..5d9f9b1 100644
--- a/drivers/input/serio/serio_raw.c
+++ b/drivers/input/serio/serio_raw.c
@@ -224,7 +224,7 @@ static ssize_t serio_raw_write(struct file *file, const char __user *buffer,
 
 out:
 	mutex_unlock(&serio_raw_mutex);
-	return written;
+	return written ?: retval;
 }
 
 static unsigned int serio_raw_poll(struct file *file, poll_table *wait)
