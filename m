Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752951Ab2EZLNT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 07:13:19 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37085 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752680Ab2EZLNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 07:13:18 -0400
Date: Sat, 26 May 2012 04:11:43 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Kay Sievers <kay@vrfy.org>
Cc: Greg Kroah-Hartmann <greg@kroah.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Kees Cook <keescook@chromium.org>, Colin Cross <ccross@android.com>,
        Tony Luck <tony.luck@intel.com>, John Stultz <john.stultz@linaro.org>
Subject: Re: [PATCH RESEND 1/3] printk: convert byte-buffer to
 variable-length record buffer
Message-ID: <20120526111143.GA32304@lizard>
References: <1336004953.4240.9.camel@mop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1336004953.4240.9.camel@mop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Kay,

On Thu, May 03, 2012 at 02:29:13AM +0200, Kay Sievers wrote:
> From: Kay Sievers <kay@vrfy.org>
> Subject: printk: convert byte-buffer to variable-length record buffer

Bad news, this patch breaks all kmsg_dump users.

Per current printk.c:

 * The 'struct log' buffer header must never be directly exported to
 * userspace, it is a kernel-private implementation detail that might
 * need to be changed in the future, when the requirements change.

But kmsg_dump users get the raw log, not text. Some users may even
use strlen() on the buffers, e.g. ramoops module was using it just
recently, before persistent_ram rework.

So, starting from this patch every kmsg_dump user is getting the
binary stuff, which is barely usable, and breaks a longstanding
user-visible ABIs (e.g. mtdoops, oops dumping into nvram on PowerPC,
and ramoops of course).

I'm not sure how we can fix this without allocating a huge buffer
(and thus wasting memory), or reworking the whole kmsg_dump concept
and its users.

Ideas?

p.s. And, btw, during HW bring-up, when there's even no serial
console usable, I somewhat liked to directly print log_buf memory
from a JTAG debugger, and thus see the kernel logs. Now that'll
look ugly. Heh. :-)

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
