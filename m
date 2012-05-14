Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752808Ab2ENESF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 00:18:05 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47917 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752462Ab2ENESC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 00:18:02 -0400
Date: Sun, 13 May 2012 21:17:57 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Colin Cross <ccross@android.com>
Cc: Anton Vorontsov <anton.vorontsov@linaro.org>,
        Kees Cook <keescook@chromium.org>, Arnd Bergmann <arnd@arndb.de>,
        John Stultz <john.stultz@linaro.org>, arve@android.com,
        Rebecca Schultz Zavin <rebecca@android.com>,
        Jesper Juhl <jj@chaosbits.net>, Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Boyd <sboyd@codeaurora.org>, Thomas Meyer <thomas@m3y3r.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marco Stornelli <marco.stornelli@gmail.com>,
        WANG Cong <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com
Subject: Re: [PATCH 02/11] persistent_ram: Fix buffer size clamping during
 writes
Message-ID: <20120514041757.GB9750@kroah.com>
References: <20120512001506.GA8653@lizard>
 <20120512001717.GB14782@lizard>
 <CAMbhsRTdCyfURjH-NRn6rDK3YbpcKp6qta-56cp1rcTwaOow5w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMbhsRTdCyfURjH-NRn6rDK3YbpcKp6qta-56cp1rcTwaOow5w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 13, 2012 at 08:23:58PM -0700, Colin Cross wrote:
> On Fri, May 11, 2012 at 5:17 PM, Anton Vorontsov
> <anton.vorontsov@linaro.org> wrote:
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
> > Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
> > ---
> >  drivers/staging/android/persistent_ram.c |   19 +------------------
> >  1 file changed, 1 insertion(+), 18 deletions(-)
> >
> > diff --git a/drivers/staging/android/persistent_ram.c b/drivers/staging/android/persistent_ram.c
> > index 12444fd..13a12bc 100644
> > --- a/drivers/staging/android/persistent_ram.c
> > +++ b/drivers/staging/android/persistent_ram.c
> > @@ -79,23 +79,6 @@ static inline void buffer_size_add(struct persistent_ram_zone *prz, size_t a)
> >        } while (atomic_cmpxchg(&prz->buffer->size, old, new) != old);
> >  }
> >
> > -/* increase the size counter, retuning an error if it hits the max size */
> > -static inline ssize_t buffer_size_add_clamp(struct persistent_ram_zone *prz,
> > -       size_t a)
> > -{
> > -       size_t old;
> > -       size_t new;
> > -
> > -       do {
> > -               old = atomic_read(&prz->buffer->size);
> > -               new = old + a;
> > -               if (new > prz->buffer_size)
> > -                       return -ENOMEM;
> > -       } while (atomic_cmpxchg(&prz->buffer->size, old, new) != old);
> > -
> > -       return 0;
> > -}
> > -
> >  static void notrace persistent_ram_encode_rs8(struct persistent_ram_zone *prz,
> >        uint8_t *data, size_t len, uint8_t *ecc)
> >  {
> > @@ -300,7 +283,7 @@ int notrace persistent_ram_write(struct persistent_ram_zone *prz,
> >                c = prz->buffer_size;
> >        }
> >
> > -       buffer_size_add_clamp(prz, c);
> > +       buffer_size_add(prz, c);
> >
> >        start = buffer_start_add(prz, c);
> >
> > --
> > 1.7.9.2
> >
> 
> Acked-by: Colin Cross <ccross@android.com>
> 
> This is a bug fix for a bug introduced in 3.4-rc1, it should go into
> 3.4 if there is another rc.

I'll queue it up for 3.4.1.

thanks,

greg k-h
