Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758200Ab1DAQRn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 12:17:43 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:46829 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752839Ab1DAQRm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 12:17:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=ZF7RBWcvwnm+q0Ome241inUMuSWpVAoLsFgJQhBIvK2X3yGja6WKx0uAOtfXbutQWh
         TVGO3PDf5bs6B+3CVI9Ixi5ukysWBp+JY3265b2JWiDtn/E6cwZI3ZZcKfO4BlxZjdKU
         MjalDkBAbWLXTYErtnhvkRiRloik5BOjrsQkw=
Date: Fri, 1 Apr 2011 18:17:35 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, security@kernel.org
Subject: [PATCH] ntp, security: fix non privileged system time shifting
Message-ID: <20110401161735.GA459@riccoc20.at.omicron.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ADJ_SETOFFSET bit added in commit 094aa188 also introduced a way for
any user to change the system time. Sneaky or buggy calls to adjtimex()
could set

    ADJ_OFFSET_SS_READ | ADJ_SETOFFSET

which would result in a successful call to timekeeping_inject_offset().
This patch fixes the issue by adding the capability check.

Signed-off-by: Richard Cochran <richard.cochran@omicron.at>
---
 kernel/time/ntp.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
index 35e68e3..5e65fd5 100644
--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -652,6 +652,8 @@ int do_adjtimex(struct timex *txc)
 		struct timespec delta;
 		delta.tv_sec  = txc->time.tv_sec;
 		delta.tv_nsec = txc->time.tv_usec;
+		if (!capable(CAP_SYS_TIME))
+			return -EPERM;
 		if (!(txc->modes & ADJ_NANO))
 			delta.tv_nsec *= 1000;
 		result = timekeeping_inject_offset(&delta);
-- 
1.7.0.4

