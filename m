Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751852Ab0HUKI0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Aug 2010 06:08:26 -0400
Received: from mgw-sa02.nokia.com ([147.243.1.48]:38372 "EHLO
	mgw-sa02.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751718Ab0HUKIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Aug 2010 06:08:23 -0400
Subject: [PATCH] lib/list_sort: do not pass bad pointers to cmp callback
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Don Mullis <don.mullis@gmail.com>
Cc: linux-kernel@vger.kernel.org, David Airlie <airlied@linux.ie>,
        Dave Chinner <david@fromorbit.com>
In-Reply-To: <AANLkTikEN_RBQeOTKxjLp2sud1qyCjFtWSXVXXMc79zw@mail.gmail.com>
References: <1281168645-18413-1-git-send-email-dedekind1@gmail.com>
	 <1281261789.2384.11.camel@localhost>
	 <AANLkTi=F5andv+K1XRdVrFL6gL22CC++fGJJJ3d3nFyb@mail.gmail.com>
	 <AANLkTikEN_RBQeOTKxjLp2sud1qyCjFtWSXVXXMc79zw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 21 Aug 2010 13:06:22 +0300
Message-ID: <1282385182.2358.41.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 (2.30.2-4.fc13) 
Content-Transfer-Encoding: 8bit
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Don Mullis <don.mullis@gmail.com>

If the original list is a POT in length, the first callback from line 73 will
pass a==b both pointing to the original list_head. This is dangerous because
the 'list_sort()' user can use 'container_of()' and accesses the "containing"
object, which does not necessary exist for the list head. So the user can
access RAM which does not belong to him. If this is a write access, we can end
up with memory corruption. This patch fixes the issue.

Signed-off-by: Don Mullis <don.mullis@gmail.com>
Tested-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Cc: stable@kernel.org
---
 lib/list_sort.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/list_sort.c b/lib/list_sort.c
index 4b5cb79..a7616fa 100644
--- a/lib/list_sort.c
+++ b/lib/list_sort.c
@@ -70,7 +70,7 @@ static void merge_and_restore_back_links(void *priv,
 		 * element comparison is needed, so the client's cmp()
 		 * routine can invoke cond_resched() periodically.
 		 */
-		(*cmp)(priv, tail, tail);
+		(*cmp)(priv, tail->next, tail->next);
 
 		tail->next->prev = tail;
 		tail = tail->next;
-- 
1.7.1.1


-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

