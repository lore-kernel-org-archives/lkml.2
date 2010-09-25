Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756281Ab0IYKky (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Sep 2010 06:40:54 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:36982 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755194Ab0IYKkx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Sep 2010 06:40:53 -0400
Message-ID: <4C9DD1B0.9020902@kernel.dk>
Date: Sat, 25 Sep 2010 12:40:48 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Adrian Hunter <adrian.hunter@nokia.com>
CC: linux-kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] block: prevent merges of discard and write requests
References: <1285411002-22924-1-git-send-email-adrian.hunter@nokia.com>
In-Reply-To: <1285411002-22924-1-git-send-email-adrian.hunter@nokia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-09-25 12:36, Adrian Hunter wrote:
> Add logic to prevent two I/O requests being merged if
> only one of them is a discard.  Ditto secure discard.
> 
> Without this fix, it is possible for write requests
> to transform into discard requests.  For example:
> 
>   Submit bio 1 to discard 8 sectors from sector n
>   Submit bio 2 to write 8 sectors from sector n + 16
>   Submit bio 3 to write 8 sectors from sector n + 8
> 
> Bio 1 becomes request 1.  Bio 2 becomes request 2.
> Bio 3 is merged with request 2, and then subsequently
> request 2 is merged with request 1 resulting in just
> one I/O request which discards all 24 sectors.

Wow, that's a disaster. We can now have requests in the
same direction and of the same type (fs), but not mergeable.

I would move the check up above the position calculations.
I will apply this and upstream it right away. Thanks a lot!

-- 
Jens Axboe

