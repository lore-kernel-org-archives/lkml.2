Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754177Ab2CGVU2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 16:20:28 -0500
Received: from mail1.windriver.com ([147.11.146.13]:55585 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887Ab2CGVU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 16:20:26 -0500
Date: Wed, 7 Mar 2012 15:19:51 -0600
From: Peter Seebach <peter.seebach@windriver.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Arnaldo Carvalho de Melo <acme@redhat.com>,
        Anton Blanchard <anton@samba.org>, <paulus@samba.org>,
        <peterz@infradead.org>, <dsahern@gmail.com>, <fweisbec@gmail.com>,
        <yanmin_zhang@linux.intel.com>, <emunson@mgebm.net>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf: Incorrect use of snprintf results in SEGV
Message-ID: <20120307151951.7e84adb6@wrlaptop>
In-Reply-To: <20120307203725.GA4333@elte.hu>
References: <20120307114249.44275ca3@kryten>
	<20120307010904.GE5656@infradead.org>
	<20120306192912.59811e3e@wrlaptop>
	<20120307203725.GA4333@elte.hu>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Mar 2012 21:37:25 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> You are missing two important aspects:
> 
> 1) Dynamic reallocation on snprintf() failure is an utterly rare
>    thing - it is used in less than 1% of snprintf() invocations. 
>    (Yes, I just checked a couple of codebases.)

I would agree that it's very rare.  But then, using the return value at
all isn't especially common in my experience -- the only interesting
part, most of the time, is "we're sure this didn't overrun the buffer".
 
>    We *DONT* want to make APIs more fragile just to accomodate a
>    rare, esoteric usecase!

I would view snprintf as an API which already exists.  If it's the
wrong API, by all means, write a different one -- but I would suggest
not using the same name for it.  If a function is going to be called
snprintf, IMO it should have the semantics of snprintf.  If those are
the wrong semantics (and they may well be), then I would say use a
function which has the right semantics, and isn't named snprintf.
 
> 2) It's not even true that should some code want to
>    dynamically allocate the 'required' number of bytes is not
>    available. Some oddball side API could be added for that 1%:
 
> 	size_needed = snprintf_size(...);

That's where the "can write one in terms of the other" argument comes
into play.

If you have snprintf_needed(), it's easy to write snprintf_written()
in terms of it.  If you have only snprintf_written(), it is unreasonably
ugly and/or inefficient to write snprintf_needed() in terms of it.

> So this API could have been designed right but it was messed up 
> out of concern for an insane 1% case - FAIL.

Well, the thing is.  If there *exists* a reallocation case, those
semantics end up being needed.

I do agree that this is a source of errors in usage (and a quick audit
shows that I have at least one use which falls prey to this, as well as
several which check for it correctly).  In practice, I'd guess that
treating probably-negative sizes as an error would likely resolve
things, although that's also a semantics change -- it's just that it's
a semantics change which only affects single snprintf calls that were
expected to write to half the address space.

-s
-- 
Listen, get this.  Nobody with a good compiler needs to be justified.
