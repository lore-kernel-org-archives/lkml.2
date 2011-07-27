Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753901Ab1G0NWq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 09:22:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31844 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751555Ab1G0NWo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 09:22:44 -0400
Subject: list sort
From: Steven Whitehouse <swhiteho@redhat.com>
To: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
        Don Mullis <don.mullis@gmail.com>, Dave Chinner <david@fromorbit.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Wed, 27 Jul 2011 14:23:34 +0100
Message-ID: <1311773014.2801.23.camel@menhir>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

There seems to be an issue with list_sort trying to compare an object to
itself. I spotted it first in a list for which I knew that I had unique
keys, so had put a BUG() in the cmp function if the keys being compared
were equal. While investigating I discovered that the objects themselves
were equal (and hence the keys, also). The following addition to the
list_sort test also triggers twice during the self test:

diff --git a/lib/list_sort.c b/lib/list_sort.c
index d7325c6..afa4a97 100644
--- a/lib/list_sort.c
+++ b/lib/list_sort.c
@@ -198,6 +198,8 @@ static int __init cmp(void *priv, struct list_head *a, struct list_head *b)
 {
 	struct debug_el *ela, *elb;
 
+	WARN_ON(a == b);
+
 	ela = container_of(a, struct debug_el, list);
 	elb = container_of(b, struct debug_el, list);
 

While it appears generally harmless, since the list does appear to be
correctly sorted, it is doing extra work needlessly.

I couldn't find a listing in the maintainers' file for list_sort, so
I used git to find those who'd worked on it recently,

Steve.



