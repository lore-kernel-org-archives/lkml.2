Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968082Ab2ERVvM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 17:51:12 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41040 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757993Ab2ERVvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 17:51:10 -0400
Date: Fri, 18 May 2012 14:49:39 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
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
Subject: Re: [PATCH 2/3] pstore/ram: Switch to persistent_ram routines
Message-ID: <20120518214939.GA5412@lizard>
References: <20120517071148.GA16946@lizard>
 <20120517071518.GB19999@lizard>
 <CAGXu5jJY478UM0fnqB5SML0gCc1HxoJyA-d6+rZH6mTWQkGegw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGXu5jJY478UM0fnqB5SML0gCc1HxoJyA-d6+rZH6mTWQkGegw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 17, 2012 at 09:34:19AM -0700, Kees Cook wrote:
[...]
> > -       memcpy(buf, cxt->pstore.buf, size);
> > -       memset(buf + size, '\0', available - size);
> > +       hlen = ramoops_write_kmsg_hdr(prz);
> > +       if (size + hlen > prz->buffer_size)
> > +               size = prz->buffer_size - hlen;
> > +       persistent_ram_write(prz, cxt->pstore.buf, size);
> 
> This still needs to wipe out the remaining bytes in the buffer (the
> second memset above).
[...]
> > -       buf = cxt->virt_addr + (id * cxt->record_size);
> > -       memset(buf, '\0', cxt->record_size);
> > +       persistent_ram_free_old(cxt->przs[id]);
> 
> Same here -- erasing the buffer means wiping it with NULL bytes.

Well, with persistent_ram we don't need to actually erase buffers
(with persistent_ram we might even hold binary data). But yes,
we'd better reset size pointer, otherwise the unlinked buffer
will show up on the next reboot. Thanks for noticing!

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
