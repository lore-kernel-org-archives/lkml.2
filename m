Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754194Ab0KSNmK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 08:42:10 -0500
Received: from smtp-out.google.com ([216.239.44.51]:5213 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753793Ab0KSNmI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 08:42:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=WZyEbyyCvXx1L8eynkzZpJC/a6CKxLDVryCqs6yji8N2q8VSFVGVzBZrzgwRlx0lw5
         WKAWMc1QyB4DEd6rt8/w==
MIME-Version: 1.0
In-Reply-To: <20101119072316.GA14388@google.com>
References: <1289996638-21439-1-git-send-email-walken@google.com>
	<1289996638-21439-4-git-send-email-walken@google.com>
	<20101117125756.GA5576@amd>
	<1290007734.2109.941.camel@laptop>
	<AANLkTim4tO_aKzXLXJm-N-iEQ9rNSa0=HGJVDAz33kY6@mail.gmail.com>
	<20101117231143.GQ22876@dastard>
	<20101118133702.GA18834@infradead.org>
	<alpine.LSU.2.00.1011180934400.3210@tigran.mtv.corp.google.com>
	<20101119072316.GA14388@google.com>
Date: Fri, 19 Nov 2010 08:42:05 -0500
Message-ID: <AANLkTinzhsvx=fx8dPpnJD_P70HKDRK+tWgFyYEN2_Zm@mail.gmail.com>
Subject: Re: [PATCH 3/3] mlock: avoid dirtying pages and triggering writeback
From: Theodore Tso <tytso@google.com>
To: Michel Lespinasse <walken@google.com>
Cc: Hugh Dickins <hughd@google.com>, Christoph Hellwig <hch@infradead.org>,
        Dave Chinner <david@fromorbit.com>,
        Peter Zijlstra <peterz@infradead.org>, Nick Piggin <npiggin@kernel.dk>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>,
        Kosaki Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Michael Rubin <mrubin@google.com>,
        Suleiman Souhlal <suleiman@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 19, 2010 at 2:23 AM, Michel Lespinasse <walken@google.com> wrote:
>
> Approaching the problem the other way - would there be any objection to
> adding code to do an fallocate() equivalent at the start of mlock ?
> This would be a no-op when the file is fully allocated on disk, and would
> allow mlock to return an error if the file can't get fully allocated
> (no idea what errno should be for such case, though).

My vote would be against.   If you if you mmap a sparse file and then
try writing to it willy-nilly, bad things will happen.  This is true without
a mlock().   Where is it written that mlock() has anything to do with
improving this situation?

If userspace wants to call fallocate() before it calls mlock(), it should
do that.  And in fact, in most cases, userspace should probably be
encouraged to do that.   But having mlock() call fallocate() and
then return ENOSPC if there's no room?  Isn't it confusing that mlock()
call ENOSPC?  Doesn't that give you cognitive dissonance?  It should
because fundamentally mlock() has nothing to do with block allocation!!
Read the API spec!

Look, it was an accident / bug of the implementation that mlock()
magically dirtied all these pages.  It might have made some situations
better, but I very much doubt applications depended upon it, and I'd
really rather not perpetuate this particular magic side effect of the
previously buggy implementation of mlock().

-- Ted
