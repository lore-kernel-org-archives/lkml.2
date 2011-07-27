Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754513Ab1G0OmU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 10:42:20 -0400
Received: from smtprelay01.ispgateway.de ([80.67.31.35]:41036 "EHLO
	smtprelay01.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753786Ab1G0OmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 10:42:18 -0400
Message-ID: <4E3024A3.7010102@ladisch.de>
Date: Wed, 27 Jul 2011 16:45:55 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Steven Whitehouse <swhiteho@redhat.com>
CC: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
        Don Mullis <don.mullis@gmail.com>, Dave Chinner <david@fromorbit.com>,
        linux-kernel@vger.kernel.org
Subject: Re: list sort
References: <1311773014.2801.23.camel@menhir>
In-Reply-To: <1311773014.2801.23.camel@menhir>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Df-Sender: linux-kernel@cl.domainfactory-kunde.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Whitehouse wrote:
> There seems to be an issue with list_sort trying to compare an object to
> itself. [...]
> While it appears generally harmless, since the list does appear to be
> correctly sorted, it is doing extra work needlessly.

There are sort algorithms where this happens naturally, and adding
an additional check to avoid calling the comparison function when the
pointers are equal would be more work overall than just calling cmp().

This does not happen with list_sort()'s merge sort, but I've noticed
the following hack in merge_and_restore_back_links():

	do {
		/*
		 * In worst cases this loop may run many iterations.
		 * Continue callbacks to the client even though no
		 * element comparison is needed, so the client's cmp()
		 * routine can invoke cond_resched() periodically.
		 */
		(*cmp)(priv, tail->next, tail->next);

		tail->next->prev = tail;
		tail = tail->next;
	} while (tail->next);

When there is no cond_resched() call, this is indeed needless work.

However, if the list is so short that cond_resched() is not needed,
the additional comparisons should not hurt anyway.


Regards,
Clemens
