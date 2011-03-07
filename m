Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754817Ab1CGOTv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 09:19:51 -0500
Received: from science.horizon.com ([71.41.210.146]:28512 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751413Ab1CGOTu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 09:19:50 -0500
Date: 7 Mar 2011 09:19:48 -0500
Message-ID: <20110307141948.11415.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: penberg@kernel.org
Subject: Re: [PATCH] Make /proc/slabinfo 040
Cc: linux@horizon.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Yeah, maybe. I've attached a proof of concept patch that attempts to
> randomize object layout in individual slabs. I'm don't completely
> understand the attack vector so I don't make any claims if the patch
> helps or not.

+	while (!bitmap_empty(bitmap, page->objects)) {
+		unsigned long idx;
+		void *p;
+
+		idx	= get_random_int() % page->objects;
+
+		idx	= find_next_bit(bitmap, page->objects, idx);
+
+		if (idx >= page->objects)
+			continue;
+
+		clear_bit(idx, bitmap);
+
+		p = start + idx * s->size;
+		setup_object(s, page, last);
+		set_freepointer(s, last, p);
+		last = p;
+	}
+	setup_object(s, page, last);
+	set_freepointer(s, last, NULL);

There's actually a far more efficient way to set up a linked list in
random order.

Start with a 1-element cycle, and repeatedly insert new elements at a
random position in the cycle.  At the end, set the list head to a random
position in the cycle.  It goes like this:

	void *p = start;
	set_freepointer(s, p, p);

	for (n = 1; n < s->size; n++) {
		void *q = start + n * s->size;
		/* p points to a random object in the list; link in after */
		set_freepointer(s, q, get_freepointer(s, p));
		set_freepointer(s, p, q);
		p = start + s->size * (get_random_int() % (n+1));
	}
	page->freelist = get_freepointer(s, p);
	set_freepointer(s, p, NULL);

Hope it helps.
