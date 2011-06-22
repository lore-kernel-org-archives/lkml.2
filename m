Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759174Ab1FVWbk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 18:31:40 -0400
Received: from smtp-out.google.com ([216.239.44.51]:42635 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759145Ab1FVWbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 18:31:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-operating-system
         :user-agent;
        b=miIGcJvjmAkqoeOloZsS/MmOrUeaO2oYGT/0m0C9JY2YxS2uMut2jejeNmL01mOtw2
         ZVf5chSo/FkwgIVNgM5g==
Date: Wed, 22 Jun 2011 15:30:39 -0700
From: Mandeep Singh Baines <msb@chromium.org>
To: Mandeep Singh Baines <msb@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Huang Ying <ying.huang@intel.com>, Andi Kleen <ak@linux.intel.com>,
        Hugh Dickins <hughd@chromium.org>, Olaf Hering <olaf@aepfle.de>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Dave Airlie <airlied@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] panic, vt: do not force oops output when panic_timeout < 0
Message-ID: <20110622223039.GA13916@google.com>
References: <1308612129-12488-1-git-send-email-msb@chromium.org>
 <1308612129-12488-2-git-send-email-msb@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1308612129-12488-2-git-send-email-msb@chromium.org>
X-Operating-System: Linux/2.6.32-gg426-generic (x86_64)
User-Agent: Mutt/1.5.20 (2009-06-14)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mandeep Singh Baines (msb@chromium.org) wrote:
> Avoid risk (of screen_unblank) and wasted cycles unblanking if
> you intend to reboot immediately.
> 

The original patch doesn't work. It worked fine when I tested with
a serial port. When I disabled the serial out, my machine started to
get wedged on a panic. I guess screen_unblank was in bust_spinlocks
for a reason. It probably bust some spin_locks somewhere.

Below is a replacement for this patch which calls screen_unblank but
does not force output when the panic timeout is negative (no wait).

-- >8 -- (snip)

Don't force output if you intend to reboot immediately.

This patch depends on:

http://lkml.kernel.org/r/1308612129-12488-1-git-send-email-msb@chromium.org

Change-Id: I48f86746ac36d420b1b025197f50d5d56b873e9f
Signed-off-by: Mandeep Singh Baines <msb@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Olaf Hering <olaf@aepfle.de>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Dave Airlie <airlied@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/linux/vt_kern.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/vt_kern.h b/include/linux/vt_kern.h
index 4d05e14..c2164fa 100644
--- a/include/linux/vt_kern.h
+++ b/include/linux/vt_kern.h
@@ -137,7 +137,7 @@ int vty_init(const struct file_operations *console_fops);
 
 static inline bool vt_force_oops_output(struct vc_data *vc)
 {
-	if (oops_in_progress && vc->vc_panic_force_write)
+	if (oops_in_progress && vc->vc_panic_force_write  && panic_timeout >= 0)
 		return true;
 	return false;
 }
-- 
1.7.3.1

