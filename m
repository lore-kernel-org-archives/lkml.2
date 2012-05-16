Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760666Ab2EPW3z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 18:29:55 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:36615 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753758Ab2EPW3x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 18:29:53 -0400
Date: Wed, 16 May 2012 15:28:23 -0700
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Kees Cook <keescook@chromium.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Colin Cross <ccross@android.com>, Tony Luck <tony.luck@intel.com>,
        Arnd Bergmann <arnd@arndb.de>, John Stultz <john.stultz@linaro.org>,
        Shuah Khan <shuahkhan@gmail.com>, arve@android.com,
        Rebecca Schultz Zavin <rebecca@android.com>,
        Jesper Juhl <jj@chaosbits.net>, Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Boyd <sboyd@codeaurora.org>, Thomas Meyer <thomas@m3y3r.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marco Stornelli <marco.stornelli@gmail.com>,
        WANG Cong <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com
Subject: Re: [PATCH 2/6] pstore/ram: Add console messages handling
Message-ID: <20120516222823.GA22797@lizard>
References: <20120516125330.GA15460@lizard>
 <20120516125634.GB20475@lizard>
 <CAGXu5jKiq-OhCMjf+PkEgyYi3wC3bTR=0nL-FacXDBnOpFZJ5A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGXu5jKiq-OhCMjf+PkEgyYi3wC3bTR=0nL-FacXDBnOpFZJ5A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2012 at 09:45:35AM -0700, Kees Cook wrote:
> On Wed, May 16, 2012 at 5:56 AM, Anton Vorontsov
> <anton.vorontsov@linaro.org> wrote:
> > This is all straightforward: we just use the last region for
> > console logging. If there's just one region, we fall-back to
> > the old behaviour: just a oops/dumps logging.
> >
> > Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
> > ---
> >  fs/pstore/ram.c |   39 ++++++++++++++++++++++++++++++---------
> >  1 file changed, 30 insertions(+), 9 deletions(-)
> >
> > diff --git a/fs/pstore/ram.c b/fs/pstore/ram.c
> > index 9123cce..54213eb 100644
> > --- a/fs/pstore/ram.c
> > +++ b/fs/pstore/ram.c
> > [...]
> > @@ -142,7 +148,12 @@ static int ramoops_pstore_write(enum pstore_type_id type,
> >        struct persistent_ram_zone *prz = cxt->przs[cxt->count];
> >        size_t hlen;
> >
> > -       /* Currently ramoops is designed to only store dmesg dumps. */
> > +       if (type == PSTORE_TYPE_CONSOLE) {
> > +               if (!cxt->cprz)
> > +                       return -ENOMEM;
> > +               persistent_ram_write(cxt->cprz, cxt->pstore.buf, size);
> > +       }
> > +
> >        if (type != PSTORE_TYPE_DMESG)
> >                return -EINVAL;
> 
> Doesn't this mean that type == PSTORE_TYPE_CONSOLE will write to the
> ram, but then fail with -EINVAL?

Right you are, there should be 'return 0' for TYPE_CONSOLE. It is
harmless tho (and unnoticeable, since we can't check return value of
the ->write() calback and print error, since this would recurse),
but I'll surely amend that.

Thanks!

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
