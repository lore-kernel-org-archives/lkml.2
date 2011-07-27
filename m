Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752848Ab1G0PCO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 11:02:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34930 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750861Ab1G0PCM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 11:02:12 -0400
Subject: Re: list sort
From: Steven Whitehouse <swhiteho@redhat.com>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
        Don Mullis <don.mullis@gmail.com>, Dave Chinner <david@fromorbit.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <4E3024A3.7010102@ladisch.de>
References: <1311773014.2801.23.camel@menhir>  <4E3024A3.7010102@ladisch.de>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Wed, 27 Jul 2011 16:04:19 +0100
Message-ID: <1311779059.2801.27.camel@menhir>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, 2011-07-27 at 16:45 +0200, Clemens Ladisch wrote:
> Steven Whitehouse wrote:
> > There seems to be an issue with list_sort trying to compare an object to
> > itself. [...]
> > While it appears generally harmless, since the list does appear to be
> > correctly sorted, it is doing extra work needlessly.
> 
> There are sort algorithms where this happens naturally, and adding
> an additional check to avoid calling the comparison function when the
> pointers are equal would be more work overall than just calling cmp().
> 
> This does not happen with list_sort()'s merge sort, but I've noticed
> the following hack in merge_and_restore_back_links():
> 
> 	do {
> 		/*
> 		 * In worst cases this loop may run many iterations.
> 		 * Continue callbacks to the client even though no
> 		 * element comparison is needed, so the client's cmp()
> 		 * routine can invoke cond_resched() periodically.
> 		 */
> 		(*cmp)(priv, tail->next, tail->next);
> 
> 		tail->next->prev = tail;
> 		tail = tail->next;
> 	} while (tail->next);
> 
> When there is no cond_resched() call, this is indeed needless work.
> 
> However, if the list is so short that cond_resched() is not needed,
> the additional comparisons should not hurt anyway.
> 
> 
> Regards,
> Clemens

Ah, I see now... that makes some kind of sense I think. I didn't expect
the cmp routine to be dual purpose in that way,

Steve.


