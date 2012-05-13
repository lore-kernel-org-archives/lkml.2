Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753421Ab2EMUkI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 16:40:08 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:56450 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258Ab2EMUkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 16:40:06 -0400
Date: Sun, 13 May 2012 13:38:36 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>, Colin Cross <ccross@android.com>,
        devel@driverdev.osuosl.org, linaro-kernel@lists.linaro.org,
        Arnd Bergmann <arnd@arndb.de>, patches@linaro.org,
        Marco Stornelli <marco.stornelli@gmail.com>,
        Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        arve@android.com, Jesper Juhl <jj@chaosbits.net>,
        John Stultz <john.stultz@linaro.org>,
        Rebecca Schultz Zavin <rebecca@android.com>,
        WANG Cong <xiyou.wangcong@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, kernel-team@android.com,
        Thomas Meyer <thomas@m3y3r.de>
Subject: Re: [PATCH 02/11] persistent_ram: Fix buffer size clamping during
 writes
Message-ID: <20120513203835.GA30082@lizard>
References: <20120512001506.GA8653@lizard>
 <20120512001717.GB14782@lizard>
 <20120513165601.GC16984@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120513165601.GC16984@mwanda>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 13, 2012 at 07:56:01PM +0300, Dan Carpenter wrote:
> On Fri, May 11, 2012 at 05:17:17PM -0700, Anton Vorontsov wrote:
> > This is a longstanding bug, almost unnoticeable when calling
> > persistent_ram_write() for small buffers.
> > 
> > But when called for large data buffers, the write routine behaves
> > incorrectly, as the size may never update: instead of clamping
> > the size to the maximum buffer size, buffer_size_add_clamp() returns
> > an error (which is never checked by the write routine, btw).
> > 
> > To fix this, we now use buffer_size_add() that actually clamps the
> > size to the max value.
> > 
> > Also remove buffer_size_add_clamp(), it is no longer needed.
> > 
> 
> Say if you did notice it, what would that look like?  It's just that
> something gets lost instead of written to the screen right?

Yep. Suppose the ring buffer size is 4096 bytes, when somebody tries to
write a data in a 2000 bytes chunk, the first write will succeed (buffer
size will be 2000), but the second now 3000-bytes write will left the
size equal to 2000, instead of clamping it to 4096.

When we had a large buffer but a small writes (e.g. ram_console usage
scenario), this is almost unnoticeable. But when we started using large
writes the bug showed up.

Thanks,

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
