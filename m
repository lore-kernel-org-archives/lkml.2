Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932633Ab0CXSAt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 14:00:49 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:34422 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932132Ab0CXSAq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 14:00:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=gZK/nXMJNVEDeseYcvZ8mxv2nYh4mYaRPkQWJq/iA2kGSWJvi45rRz4H97pBmxfSas
         zpvsG2FCQhbw93GpNUQ8UEF3iX3hVj5gJKYzeXDhI7W7Znog5PlnA/TpnHL5tHlwjxZI
         OOkuACYDR/VdirXZCLegxQ5QQapqQUSbLs824=
From: Dmitry Monakhov <dmonakhov@openvz.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, hch@infradead.org, mkp@mkp.net
Subject: Re: [PATCH 0/5] blkdev: discard optimizations v2 RESEND2
References: <1269451988-5270-1-git-send-email-dmonakhov@openvz.org>
	<20100324174350.GH5768@kernel.dk>
Date: Wed, 24 Mar 2010 21:00:40 +0300
In-Reply-To: <20100324174350.GH5768@kernel.dk> (Jens Axboe's message of "Wed,
	24 Mar 2010 18:43:50 +0100")
Message-ID: <87fx3pmwfr.fsf@openvz.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe <jens.axboe@oracle.com> writes:

> On Wed, Mar 24 2010, Dmitry Monakhov wrote:
>> Wow. lkml seem don't like 'XXX' in the subject
>> So post it one more time.
>
> I got it three times :-)
>
>> This is second version of generic discard optimizations
>> first was submitted here: http://lwn.net/Articles/373994
>> 
>> Currently there are many file-systems which has implemented
>> discard support, but SSD discs not widely used yet.
>> This patch-set introduce compat helpers which simulate
>> discard requests with zeroing semantics.
>> 
>> __blkdev_issue_zeroout: explicitly zeroout given range via write request.
>> blkdev_issue_clear: zeroout given range, use discard request if possible.
>> 
>> Later filesystem admin may select which behavior is suitable for his needs
>> discard without zeroing or explicit zeroing even if discard is not supported.
>> 
>> Advantages:
>> - Hope that this helps in real filesystem testing.
>> - People who are crazy about data security would be really happy.
>> - Virtual machine developers also would like this feature.
>> 
>> Other optimization:
>> - Convert all blkdev_issue_xxx function to common set of flags
>> - Optimize generic discard submitting procedure.
>
> I think tihs is pretty odd, to be honest, and a strange way to use a
> discard request. If this is some security concern, have some fs helpers
> to help them explicitly zero blocks. If you really want to be paranoid,
> the single overwrite is likely not enough anyway.
May be, but usually discard is issued for data block, and user may
has zeroout behavior FOR FREE simply by replacing the function.
And if filesystem want to support paranoid mode it will add
corresponding helpers for metadata which require more work.
BTW blkdev_issue_zeroout is pretty generic to be useful for other
places. Currently there are several places which duplicate this logic.
> Secondly, if used on
> an SSD that doesn't have discard, it'll make things worse. Thirdly,
> discard may or may not provide zeroed data on re-read.
Yes for second and third. But i've just add explicit zeroed functions.
And let user define which behavior is sufficient for him.
