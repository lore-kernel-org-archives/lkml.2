Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757282Ab0FURJv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 13:09:51 -0400
Received: from smtp-out.google.com ([74.125.121.35]:50779 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752020Ab0FURJt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 13:09:49 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:from:date:message-id:
	subject:to:cc:content-type:content-transfer-encoding:x-system-of-record;
	b=OH0y6Ro0gzxoc14/+5SZHteblqP2PE7BEB4f5ACY3ZmWEEbZkKk5IUr7HqS+5b9YM
	5KmwA9bp97kbPtqjgmLVg==
MIME-Version: 1.0
In-Reply-To: <20100620231017.GI6590@dastard>
References: <1276907415-504-1-git-send-email-mrubin@google.com> 
	<20100620231017.GI6590@dastard>
From: Michael Rubin <mrubin@google.com>
Date: Mon, 21 Jun 2010 10:09:24 -0700
Message-ID: <AANLkTikem5aW2MChCwmluUveB-F3zv5B9Tj0TtXPcfxm@mail.gmail.com>
Subject: Re: [PATCH 0/3] writeback visibility
To: Dave Chinner <david@fromorbit.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-mm@kvack.org, jack@suse.cz, akpm@linux-foundation.org, hch@lst.de,
       axboe@kernel.dk
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for looking at this.

On Sun, Jun 20, 2010 at 4:10 PM, Dave Chinner <david@fromorbit.com> wrote:
>> Michael Rubin (3):
>>   writeback: Creating /sys/kernel/mm/writeback/writeback
>>   writeback: per bdi monitoring
>>   writeback: tracking subsystems causing writeback
>
> I'm not sure we want to export statistics that represent internal
> implementation details into a fixed userspace API. Who, other than
> developers, are going to understand and be able to make use of this
> information?

I think there are varying degrees of internal exposure on the patches.

>>   writeback: Creating /sys/kernel/mm/writeback/writeback
This one seems to not expose any new internals. We already expose the
concept of "dirty", "writeback" and thresholds in /proc/meminfo.

>>  writeback: per bdi monitoring

Looking at it again. I think this one is somewhat of a mixed bag.
BDIReclaimable, BdiWriteback, and the dirty thresholds seems safe to
export.While I agree the rest should stay in debugfs. Would that be
amenable?

>> writeback: tracking subsystems causing writeback

I definitely agree that this one is too revealing and needs to be
redone. But I think we might want to add the details for concepts
which we already expose.
The idea of a "periodic writeback" is already exposed in /proc/sys/vm/
and I don't see that changing in the kernel as a method to deal with
buffered IO. Neither will sync. The laptop stuff and the names of
"balance_dirty_pages" are bad, but maybe we can come up with something
more high level. Like "writeback due to low memory"

> FWIW, I've got to resend the writeback tracing patches to Jens that I
> have that give better visibility into the writeback behaviour.
> Perhaps those tracing events are a better basis for tracking down
> writeback problems - the bugs I found with the tracing could not
> have been found with these statistics...

Yeah I have been watching the tracing stuff you have posted and I
think it will help. There were some other trace points I wanted to add
to this patch but was waiting to learn from your submission on the
best way to integrate them.

> That's really why I'm asking - if the stats are just there to help
> development and debugging, then I think that improving the writeback
> tracing is a better approach to improving visibility of writeback
> behaviour...

Maybe I should not have put all these patches in one series. The first
one with the /sys/kernel/vm file is very useful for user space
developers. System Administrators who are trying to classify IO
problems often need to know if the disk is bad or if the buffered data
is not even being written to disk over time.. Also at Google we tend
to run our jobs with very little unused RAM. Pushing things close to
their limits results in many surprises and writeback is often one of
them. Knowing the thresholds and rate of dirty and cleaning of pages
can help systems do the right thing.

mrubin
