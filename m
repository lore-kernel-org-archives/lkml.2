Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755469Ab1HaVA3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 17:00:29 -0400
Received: from smtp-out.google.com ([74.125.121.67]:36756 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752429Ab1HaVA0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 17:00:26 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:date:
	message-id:subject:from:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=GfCV6pTTMRHQgReAoFy9/ZVkgvenqqo6shK+quT+oMyQq/3apD6VU9CKUCdp7sH6A
	pKUoWkfNb1gmVZkxWs5tg==
MIME-Version: 1.0
In-Reply-To: <m2pqjlo6e5.fsf@firstfloor.org>
References: <CAAK6Zt2icmsBxjdqFvDXfnxZHXuKN3hDSTdDmh7Vhj1iJ_5LXQ@mail.gmail.com>
	<20110830053231.GA1627@infradead.org>
	<CAAK6Zt2P3jBPfeCPioK-ehpVAw0iQjikY0BujXfQmfozJ8GNvA@mail.gmail.com>
	<20110831052627.GA5338@infradead.org>
	<m2pqjlo6e5.fsf@firstfloor.org>
Date: Wed, 31 Aug 2011 14:00:22 -0700
Message-ID: <CAAK6Zt1nknjUe+U1yUwQVF_sZ1x1B-p7GtLFUrALCWDLbqvTGw@mail.gmail.com>
Subject: Re: Approaches to making io_submit not block
From: Daniel Ehrenberg <dehrenberg@google.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 31, 2011 at 10:08 AM, Andi Kleen <andi@firstfloor.org> wrote:
> Christoph Hellwig <hch@infradead.org> writes:
>>
>> I'll get it polished up and send it out for RFC once Dave sends out
>> the updated allocation workqueue patch.  With this he moves all
>> allocator calls in XFS into a workqueue.  My direct I/O patch uses that
>> fact to use that workqueue for the allocator call
>
> Is that really a good direction? The problem when you push operations
> from multiple threads all into a single resource (per cpu workqueue)
> is that the CPU scheduler loses control over that because they
> are all mixed up.
>
> So if one guy submits a lot and another very little the "a lot" guy
> can overwhelm the queue for the very little guy.
>
> We also have similar problems with the IO schedulers, which also
> rely on process context to make fairness decisions. If you remove
> the process context they do badly.
>
> -Andi
>
> --
> ak@linux.intel.com -- Speaking for myself only
>

This objection would seem to point to the benefits of doing something
like Suparna's patches, with a wait queue per task, no? This preserves
the current regime where each thread calling io_submit ends up
submitting things in parallel.

Dan
