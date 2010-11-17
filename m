Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751851Ab0KQXbm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 18:31:42 -0500
Received: from smtp-out.google.com ([74.125.121.35]:59925 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238Ab0KQXbl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 18:31:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=e65S8XIaqFAHF9CmO/t472G5lIBjuFQRPamsP86EtBbgysaveht/kovj/h8lZ/0onQ
         JL0N6XgD89BhurtHrqcQ==
MIME-Version: 1.0
In-Reply-To: <20101117231143.GQ22876@dastard>
References: <1289996638-21439-1-git-send-email-walken@google.com>
	<1289996638-21439-4-git-send-email-walken@google.com>
	<20101117125756.GA5576@amd>
	<1290007734.2109.941.camel@laptop>
	<AANLkTim4tO_aKzXLXJm-N-iEQ9rNSa0=HGJVDAz33kY6@mail.gmail.com>
	<20101117231143.GQ22876@dastard>
Date: Wed, 17 Nov 2010 15:31:37 -0800
Message-ID: <AANLkTimE1KecXQhcxsKLSLug-7XpmGbmvsfSmG7kWDNn@mail.gmail.com>
Subject: Re: [PATCH 3/3] mlock: avoid dirtying pages and triggering writeback
From: Michel Lespinasse <walken@google.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Nick Piggin <npiggin@kernel.dk>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>,
        Kosaki Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Theodore Tso <tytso@google.com>, Michael Rubin <mrubin@google.com>,
        Suleiman Souhlal <suleiman@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 17, 2010 at 3:11 PM, Dave Chinner <david@fromorbit.com> wrote:
>> Really, my understanding is that not pre-allocating filesystem blocks
>> is just fine. This is, after all, what happens with ext3 and it's
>> never been reported as a bug (that I know of).
>
> It's not ext3 you have to worry about - it's the filesystems that
> need special state set up on their pages/buffers for ->writepage to
> work correctly that are the problem. You need to call
> ->write_begin/->write_end to get the state set up properly.
>
> If this state is not set up properly, silent data loss will occur
> during mmap writes either by ENOSPC or failing to set up writes into
> unwritten extents correctly (i.e. we'll be back to where we were in
> 2.6.15).
>
> I don't think ->page_mkwrite can be worked around - we need that to
> be called on the first write fault of any mmap()d page to ensure it
> is set up correctly for writeback.  If we don't get write faults
> after the page is mlock()d, then we need the ->page_mkwrite() call
> during the mlock() call.

Just to be clear - I'm proposing to skip the entire do_wp_page() call
by doing a read fault rather than a write fault. If the page wasn't
dirty already, it will stay clean and with a non-writable PTE until it
gets actually written to, at which point we'll get a write fault and
do_wp_page will be invoked as usual.

I am not proposing to skip the page_mkwrite() while upgrading the PTE
permissions, which I think is what you were arguing against ?

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
