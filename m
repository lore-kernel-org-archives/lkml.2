Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752390Ab1HPSy0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 14:54:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30202 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751485Ab1HPSyZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 14:54:25 -0400
Date: Tue, 16 Aug 2011 20:50:57 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Florian Schilhabel <florian.c.schilhabel@googlemail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Cc: Matt Fleming <matt@console-pimps.org>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: rtl8712: remove r8712_cmd_thread()->daemonize()
Message-ID: <20110816185057.GA4036@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

daemonize() is only needed when a user-space task does kernel_thread().

r8712_cmd_thread() is kthread_create()'ed and thus it doesn't need
the soon-to-be-deprecated daemonize(). It is the only caller of
thread_enter() which actually does the call.

Note:
	- we are going to remove the sigdelset(blocked) code from
	  allow_signal(), this means that without this patch
	  thread_enter() can't work after that. Not to mention
	  daemonize() should be deprecated.

	- as a side effect, this patch changes ->comm. Hopefully
	  this is fine, and padapter->pnetdev->name probably makes
	  more sense anyway.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 drivers/staging/rtl8712/osdep_service.h |    1 -
 1 file changed, 1 deletion(-)

--- 3.1/drivers/staging/rtl8712/osdep_service.h~2_daemonize_rtl8712	2011-07-28 14:06:57.000000000 +0200
+++ 3.1/drivers/staging/rtl8712/osdep_service.h	2011-08-16 20:36:39.000000000 +0200
@@ -203,7 +203,6 @@ static inline unsigned char _cancel_time
 
 static inline void thread_enter(void *context)
 {
-	daemonize("%s", "RTKTHREAD");
 	allow_signal(SIGTERM);
 }
 

