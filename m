Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757214Ab0FUXQz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 19:16:55 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35020 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751057Ab0FUXQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 19:16:53 -0400
Date: Mon, 21 Jun 2010 16:16:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Henrik Rydberg" <rydberg@euromail.se>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
       Jiri Kosina <jkosina@suse.cz>, Jonathan Cameron <jic23@cam.ac.uk>
Subject: Re: [PATCH] Introduce buflock, a one-to-many circular buffer
 mechanism (rev2)
Message-Id: <20100621161610.fdfe23a6.akpm@linux-foundation.org>
In-Reply-To: <1277060705-3363-1-git-send-email-rydberg@euromail.se>
References: <1277060705-3363-1-git-send-email-rydberg@euromail.se>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 Jun 2010 21:05:05 +0200
"Henrik Rydberg" <rydberg@euromail.se> wrote:

> In spite of the many lock patterns and fifo helpers in the kernel, the
> case of a single writer feeding many readers via a circular event
> buffer seems to be uncovered. This patch adds the buflock, a mechanism
> for handling multiple concurrent read positions in a shared circular
> buffer.  Under normal operation, given adequate buffer size, the
> operation is lock-less. The mechanism is given the name buflock to
> emphasize that the locking depends on the buffer read/write clashes.
> 
> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
> ---
> This is version 2 of the buflock, which was first introduced as a
> patch against the input subsystem. In the reviews, it was suggested
> the file be placed in include/linux/, which is the patch presented
> here. The major changes, taking review comments into account, are:
> 
> * The API has been rewritten to better abstract a lock, which
>   hopefully provides a clearer reason to leave the actual memory
>   handling to the user.
> 
> * The number of memory barriers has been reduced.
> 
> * Overlap detection now takes write interrupts larger than the buffer
>   size into account.
> 
> * All methods are now static inlines.
> 

I don't understand why this has "lock" in its name.

The API itself is a mixture of "bufwrite_foo" and "bufread_foo".

It's all a bit chaotic.  I'd suggest picking a sane name for the whole
subsytem - perhaps "mrbuf" for "multi reader buffer"?  Then
consistently name all interface functions as "mrbuf_foo". 
mrbuf.h, mrbuf_write_lock(), etc.

> +static __always_inline bool __must_check bufread_retry(struct buflock_reader *br, const struct buflock_writer *bw)
> +{
> +	smp_rmb();
> +	if (unlikely(((br->tail - br->last) & bw->page) < bw->next - br->last))
> +		return true;
> +	++br->tail;
> +	if (unlikely(br->head - br->tail > bw->page))
> +		br->tail = br->head;
> +	return false;
> +}

This looks too large to be inlined.

What's the __always_inline for?  Was gcc uninlining this within
separate compilation units?


Dmitry, if/when this code looks suitable to you and if you think it's
all desirable then please merge the
buflock-aka-bufwrite-aka-bufread-aka-mrbuf code via your tree.
