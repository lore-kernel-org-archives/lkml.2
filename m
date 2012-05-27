Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752615Ab2E0OXj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 10:23:39 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38352 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846Ab2E0OXh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 10:23:37 -0400
MIME-Version: 1.0
In-Reply-To: <20120526111143.GA32304@lizard>
References: <1336004953.4240.9.camel@mop> <20120526111143.GA32304@lizard>
From: Kay Sievers <kay@vrfy.org>
Date: Sun, 27 May 2012 16:23:17 +0200
Message-ID: <CAPXgP10--rmzK8joBSrs3Abk7uuamJTDBbvrm6W6w_xODqZVtg@mail.gmail.com>
Subject: Re: [PATCH RESEND 1/3] printk: convert byte-buffer to variable-length
 record buffer
To: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: Greg Kroah-Hartmann <greg@kroah.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Kees Cook <keescook@chromium.org>, Colin Cross <ccross@android.com>,
        Tony Luck <tony.luck@intel.com>, John Stultz <john.stultz@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 26, 2012 at 1:11 PM, Anton Vorontsov
<anton.vorontsov@linaro.org> wrote:

>> Subject: printk: convert byte-buffer to variable-length record buffer
>
> Bad news, this patch breaks all kmsg_dump users.
>
> Per current printk.c:
>
>  * The 'struct log' buffer header must never be directly exported to
>  * userspace, it is a kernel-private implementation detail that might
>  * need to be changed in the future, when the requirements change.
>
> But kmsg_dump users get the raw log, not text. Some users may even
> use strlen() on the buffers, e.g. ramoops module was using it just
> recently, before persistent_ram rework.
>
> So, starting from this patch every kmsg_dump user is getting the
> binary stuff, which is barely usable, and breaks a longstanding
> user-visible ABIs (e.g. mtdoops, oops dumping into nvram on PowerPC,
> and ramoops of course).

These cases export their own format, it's just that the dump routines
could copy the buffer in only two steps (beginning and end of the ring
buffer), while in the future their code would need an update to copy
it record for record now. The exported format in the dump does not
necessarily need to change.

It should be possible to convert them pretty easily to do that, they
operate on their own allocated buffers already. Some of them seem to
mangle the line-buffer already, so they should be able to copy
record-by-record either.

> I'm not sure how we can fix this without allocating a huge buffer
> (and thus wasting memory), or reworking the whole kmsg_dump concept
> and its users.

I think an iterator in the dumper code is nicer and simpler. It will
even provide structured data to the dumper, if the dumper wants to
make use of it in the future. The prefix mangling of the text in the
nvram dumper could surely benefit from that.

The iterator would basically work similar to the printing of the whole
buffer at a newly registered boot console, which was doing a similar
logic as the dumper does.

> p.s. And, btw, during HW bring-up, when there's even no serial
> console usable, I somewhat liked to directly print log_buf memory
> from a JTAG debugger, and thus see the kernel logs. Now that'll
> look ugly. Heh. :-)

Yeah, that probably does not look pretty anymore, but it still all
works, right? Doesn't have he debugger a strings(1)-like output to
print of a memory area?

Kay
