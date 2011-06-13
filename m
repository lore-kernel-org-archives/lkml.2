Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754652Ab1FMVWr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 17:22:47 -0400
Received: from smtp-out.google.com ([216.239.44.51]:58778 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956Ab1FMVWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 17:22:43 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:subject:cc:date:message-id:user-agent:
	mime-version:content-type;
	b=yDdu7qwT96VhXrbQpNFNRkUdMSOV4omL24YbfDLoiJAndzMiISBw8yCqE/5ZessSC
	MUYXHRj4kq/QQyQGKEV4w==
From: Greg Thelen <gthelen@google.com>
To: Stephen Hemminger <shemminger@linux-foundation.org>
Subject: [PATCH] sky2: avoid using uninitialized variable
cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 13 Jun 2011 14:21:59 -0700
Message-ID: <xr93vcw9s9zc.fsf@gthelen.mtv.corp.google.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am not sure if 0 or ~0 would be a better choice in the gm_phy_read()
error case.  I used 0.  A more complete solution might be to plumb up
error handling to the callers of gm_phy_read().

==
>From 37486219a3d93881f3b2619a4b2bb21be62db7d4 Mon Sep 17 00:00:00 2001
From: Greg Thelen <gthelen@google.com>
Date: Mon, 13 Jun 2011 14:09:07 -0700
Subject: [PATCH] sky2: avoid using uninitialized variable

Prior to this change gm_phy_read() could return an uninitialized
variable if __gm_phy_read() failed.

This change returns zero in the failure case.

Signed-off-by: Greg Thelen <gthelen@google.com>
---
 drivers/net/sky2.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/sky2.c b/drivers/net/sky2.c
index 3ee41da..eba1ac4 100644
--- a/drivers/net/sky2.c
+++ b/drivers/net/sky2.c
@@ -206,7 +206,8 @@ io_error:
 static inline u16 gm_phy_read(struct sky2_hw *hw, unsigned port, u16 reg)
 {
 	u16 v;
-	__gm_phy_read(hw, port, reg, &v);
+	if (__gm_phy_read(hw, port, reg, &v) < 0)
+		return 0;
 	return v;
 }
 
-- 
1.7.3.1

