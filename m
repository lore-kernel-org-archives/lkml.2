Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751670Ab1H3VvJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 17:51:09 -0400
Received: from smtp-out.google.com ([216.239.44.51]:1974 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990Ab1H3VvF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 17:51:05 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:date:
	message-id:subject:from:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=nKB85/PcKc7jRYwTR8Z5sw9qKUwvzCK+qfxoxM6f+UkgxczFrxbE37rdh+Pbgdmzx
	OYSJMOuUIaZFXmvTP22gw==
MIME-Version: 1.0
In-Reply-To: <20110830053231.GA1627@infradead.org>
References: <CAAK6Zt2icmsBxjdqFvDXfnxZHXuKN3hDSTdDmh7Vhj1iJ_5LXQ@mail.gmail.com>
	<20110830053231.GA1627@infradead.org>
Date: Tue, 30 Aug 2011 14:51:01 -0700
Message-ID: <CAAK6Zt2P3jBPfeCPioK-ehpVAw0iQjikY0BujXfQmfozJ8GNvA@mail.gmail.com>
Subject: Re: Approaches to making io_submit not block
From: Daniel Ehrenberg <dehrenberg@google.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for getting back to me.

On Mon, Aug 29, 2011 at 10:32 PM, Christoph Hellwig <hch@infradead.org> wrote:
> On Mon, Aug 29, 2011 at 10:33:24AM -0700, Daniel Ehrenberg wrote:
>> - Blocking due to reading metadata.
>> Proposed solution:
>> Add a per-ioctx work queue to do metadata reads. It will be triggered
>> from the dio code: if in async mode, then get_block will be called
>> with an additional flag, meaning something like O_NONBLOCK on sockets.
>> File systems' get_block functions can implement this flag and return
>> -EAGAIN if a read from the underlying device would be necessary. (If
>> we're worried that EAGAIN might be used for other purposes in the
>> future, we could make a new errno for this purpose.) From a quick
>> glance at the code, it looks like this would not be too difficult to
>> add to ext4 for extent-based files, and support in other file systems
>> could be added gradually. If -EAGAIN is returned, then the struct dio
>> will be put on the work queue together with a description of what kind
>> of processing it was doing. The work queue only serves the metadata
>> request, and the rest of the request is served on the existing path.
>
> Let filesystems handle this.  I've actually prototyped it in XFS,
> based on some pending work from Dave but at this point it's still butt
> ugly.

Great, would you be willing to let me see the draft code?

Are you sure that there wouldn't be any benefit to having the code be
in the aio/dio levels in terms of making it easier for file
systems/reducing code duplication?
>
>> - Blocking for appends and writes to file holes due to the need for a
>> metadata write after the data write
>> Proposed solution:
>> Maintain a work queue for all appends and writes to file holes, which
>> executes the current code.
>
> No way.  I've fixed this for XFS, and it's trivial without the need to
> queue them up.  The only thing preventing appending writes to work is
> a flag to tell the dio layer to just do them, just like it already works
> for holes.  (and more QA).
>
>
Are you saying this is already fixed for XFS? Appends don't block,
only reads to metadata do?

Dan
