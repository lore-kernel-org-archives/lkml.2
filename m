Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756824Ab1FUVV7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 17:21:59 -0400
Received: from smtp-out.google.com ([74.125.121.67]:39910 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751929Ab1FUVV4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 17:21:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=PWO6IdLm62Ihc1HDU+wEo73HqYoSdvd/qd9n2awOX0KeGRMmQFyabfg5/soXJ72aIa
         v0hjNvJzKct6zgrKx2zQ==
MIME-Version: 1.0
In-Reply-To: <m2oc1q3okc.fsf@firstfloor.org>
References: <1308611855-18096-1-git-send-email-dehrenberg@google.com>
	<m2oc1q3okc.fsf@firstfloor.org>
Date: Tue, 21 Jun 2011 14:21:48 -0700
Message-ID: <BANLkTi=GeY+6ZTKkYidFd+J=T7ER1+Lk6kv+uJe6GA6v1HrVaQ@mail.gmail.com>
Subject: Re: [PATCH] dio: Fast-path for page-aligned IOs
From: Daniel Ehrenberg <dehrenberg@google.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 21, 2011 at 1:41 PM, Andi Kleen <andi@firstfloor.org> wrote:
> Dan Ehrenberg <dehrenberg@google.com> writes:
>
>> This code introduces a fast-path variant of __blockdev_direct_IO
>> for the special case where the request size is a multiple of the page
>> size, the inode block size is a page, the user memory is page-aligned,
>> the underlying storage is contiguous on disk and the file location is
>> already initialized. The special case decreases the amount of
>> bookkeeping required, which saves a significant amount of CPU time on
>> a fast device such as a ramdisk or an SSD.  The patch is inspired by
>> earlier code by Ken Chen.
>
> Is it understood why your fast path is that much faster?
> i.e. what's the slow part in the normal path that it avoids?
>
> I am wondering if some of the improvements could be gotten even for less
> rigid pre conditions.

I should start by saying that I really should've submitted this with
an [RFC] tag. I'm eager for feedback on my first Linux kernel patch,
and I'm really glad you responded.

The slowness in the dio code that I have observed is not in any
particular place, but rather a death of a thousand cuts. Lines like
        memset(dio, 0, offsetof(struct dio, pages));
show up as significant in the CPU profile, but so do other random
lines that manipulate the struct dio.

In an earlier version of the patch, I restricted the change to only
page-sized operations. This was criticized for being insufficiently
general. In generalizing to page-multiple operations, I noticed a
minor regression, which seems to be from the IS_ALIGNED calls.

You're right that these preconditions are rather rigid, though. If you
have a suggestion for a more general precondition, I can try it out
and see if it maintains the performance properties I want.
>
>> +             /*
>> +              * The i_alloc_sem will be released at I/O completion,
>> +              * possibly in a different thread.
>> +              */
>> +             down_read_non_owner(&inode->i_alloc_sem);
>
> There's just a patch kit posted from hch which removes that semaphore.
>
> -Andi

Once this patch is finalized and merged, I can make a new version of
the patch based on the new synchronization mechanism.

Dan
