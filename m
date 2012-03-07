Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031774Ab2CGBaL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 20:30:11 -0500
Received: from mail.windriver.com ([147.11.1.11]:33344 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756654Ab2CGBaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 20:30:08 -0500
Date: Tue, 6 Mar 2012 19:29:12 -0600
From: Peter Seebach <peter.seebach@windriver.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
CC: Anton Blanchard <anton@samba.org>, <paulus@samba.org>,
        <peterz@infradead.org>, <mingo@elte.hu>, <dsahern@gmail.com>,
        <fweisbec@gmail.com>, <yanmin_zhang@linux.intel.com>,
        <emunson@mgebm.net>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf: Incorrect use of snprintf results in SEGV
Message-ID: <20120306192912.59811e3e@wrlaptop>
In-Reply-To: <20120307010904.GE5656@infradead.org>
References: <20120307114249.44275ca3@kryten>
	<20120307010904.GE5656@infradead.org>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Mar 2012 22:09:04 -0300
Arnaldo Carvalho de Melo <acme@redhat.com> wrote:

> Or what kind of such pipe the people who designed snprintf were using
> :-(

I wasn't there for the original 4.4BSD implementation, but I was on the
ISO committee when we adopted it, and I regret to say, while the food
was lovely, the hosting organization didn't offer us any drugs at all.
But I can explain the rationale of the choice.

If snprintf returns the size it needed, and you know the size you gave
it, you have a choice of what to do, and you have all the information
you need to make an informed choice.

If it returns the amount it wrote, or possibly an error indicator (such
as -1) when out of space, you *don't* have the information you need to
make an informed choice, and one possible choice ("reallocate with the
right amount") is not available to you. We had also seen other functions
which made that implementation choice, and consistently, people
disliked them more.

To frame it another way:  Imagine an alternative function, called
slenprintf(), which is just like snprintf except that it returns the
number of bytes written instead of the number it would have liked to
write in the event that the buffer isn't big enough.  And also
vslenprintf(), analogous to vsnprintf().

Now consider what happens if you have one and want the semantics of the
other:

size_t
myslenprintf(char *buffer, size_t len, char *fmt, ...) {
    size_t ret;
    va_list ap;
    va_start(ap, fmt)
    ret = vsnprintf(buffer, len, fmt, ap);
    /* easy to check for this possibility */
    if (ret >= size)
        return size - 1;
    return ret;
}

size_t
mysnprintf(char *buffer, size_t len, char *fmt, ...) {
    size_t ret;
    va_list ap;
    va_start(ap, fmt)
    ret = vslenprintf(buffer, len, fmt, ap);
    /* now what? */
    ...
}

-s
-- 
Listen, get this.  Nobody with a good compiler needs to be justified.
