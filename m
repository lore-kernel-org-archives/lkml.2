Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752757Ab2KIHeN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 02:34:13 -0500
Received: from merlin.infradead.org ([205.233.59.134]:52926 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793Ab2KIHeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 02:34:10 -0500
Message-ID: <509CB1EB.4080408@kernel.dk>
Date: Fri, 09 Nov 2012 08:34:03 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Lukas Czerner <lczerner@redhat.com>, dchinner@redhat.com,
        jmoyer@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] loop: Limit the number of requests in the bio list
References: <1350379305-13858-1-git-send-email-lczerner@redhat.com> <20121108111418.bcaad11d.akpm@linux-foundation.org>
In-Reply-To: <20121108111418.bcaad11d.akpm@linux-foundation.org>
X-Enigmail-Version: 1.4.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-11-08 20:14, Andrew Morton wrote:
> On Tue, 16 Oct 2012 11:21:45 +0200
> Lukas Czerner <lczerner@redhat.com> wrote:
> 
>> Currently there is not limitation of number of requests in the loop bio
>> list. This can lead into some nasty situations when the caller spawns
>> tons of bio requests taking huge amount of memory. This is even more
>> obvious with discard where blkdev_issue_discard() will submit all bios
>> for the range and wait for them to finish afterwards. On really big loop
>> devices and slow backing file system this can lead to OOM situation as
>> reported by Dave Chinner.
>>
>> With this patch we will wait in loop_make_request() if the number of
>> bios in the loop bio list would exceed 'nr_requests' number of requests.
>> We'll wake up the process as we process the bios form the list. Some
>> threshold hysteresis is in place to avoid high frequency oscillation.
>>
> 
> What's happening with this?

Sorry I didn't reply to this yet. My initial thought is that we had
something like this for loop back in the 2.4 days, and it was deadlock
prone. Can't seem to remember all the details on that yet.

v2 is a nice improvement, though. With 1:1 bio and wakeups, you would
get tons of context switches. The batched approach is much better.

Lukas, have you beaten on this with a file backed loop and heavy traffic
on a file system on top?

-- 
Jens Axboe

