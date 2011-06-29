Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753121Ab1F2B4u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 21:56:50 -0400
Received: from smtp-out.google.com ([74.125.121.67]:55915 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751645Ab1F2B4p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 21:56:45 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:date:
	message-id:subject:from:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=F5fdTLEoZwqjEg0oROtUDm+fR34CmIxNgydyPrNGYgCoy65rpyh8KUBdSJzDexJ/I
	IAACtrPCqqFQGOK3ioGDg==
MIME-Version: 1.0
In-Reply-To: <20110629005422.GQ32466@dastard>
References: <1309304616-8657-1-git-send-email-curtw@google.com>
	<20110629005422.GQ32466@dastard>
Date: Tue, 28 Jun 2011 18:56:41 -0700
Message-ID: <BANLkTimKtwVZo3D+w9AB2-C83d08YROcMw@mail.gmail.com>
Subject: Re: [PATCH] writeback: Don't wait for completion in writeback_inodes_sb_nr
From: Curt Wohlgemuth <curtw@google.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave:

Thanks for the response.

On Tue, Jun 28, 2011 at 5:54 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Tue, Jun 28, 2011 at 04:43:35PM -0700, Curt Wohlgemuth wrote:
>> Contrary to the comment block atop writeback_inodes_sb_nr(),
>> we *were* calling
>>
>>         wait_for_completion(&done);
>>
>> which should not be done, as this is not called for data
>> integrity sync.
>>
>> Signed-off-by: Curt Wohlgemuth <curtw@google.com>
>
> The comment says it does not wait for IO to be -completed-.
>
> The function as implemented waits for IO to be *submitted*.
>
> This provides the callers with same blocking semantics (i.e. request
> queue full) as if the caller submitted the IO themselves. The code
> that uses this function rely on this blocking to delay the next set
> of operations they do until after IO has been started, so removing
> the completion will change their behaviour significantly.

I don't quite understand this.  It's true that all IO done as a result
of calling wb_writeback() on this work item won't finish before the
completion takes place, but sending all those pages in flight *will*
take place.  And that's a lot of time.  To wait on this before we then
call sync_inodes_sb(), and do it all over again, seems odd at best.

Pre-2.6.35 kernels would start non-integrity sync writeback and
immediately return, which would seem like a reasonable "prefetch-y"
thing to do, considering it's going to be immediately followed by a
data integrity sync writeback operation.

The post 2.6.35 semantics are fine; but then I don't understand why we
do both a __sync_filesystem(0) followed by a __sync_filesystem(1) (in
the case of sync(2)).  It doesn't seem to be any safer or more correct
to me; why not just do the data integrity sync writeback and call it a
day?

Thanks,
Curt

>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com
>
