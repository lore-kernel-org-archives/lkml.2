Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754339Ab2FMW2j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 18:28:39 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48007 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732Ab2FMW2h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 18:28:37 -0400
Date: Thu, 14 Jun 2012 07:28:31 +0900
From: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
To: Grant Grundler <grantgrundler@gmail.com>
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>,
        akpm@linux-foundation.org, bhutchings@solarflare.com,
        grundler@parisc-linux.org, arnd@arndb.de, benh@kernel.crashing.org,
        avi@redhat.com, mtosatti@redhat.com, linux-net-drivers@solarflare.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 2/5] drivers/net/ethernet/dec/tulip: Use standard
 __set_bit_le() function
Message-Id: <20120614072831.63845f6ddf024ece28e49f5e@gmail.com>
In-Reply-To: <CAP6odji_JvRkJP1dSzGK5ww3y71h4k6pXyj4pOQBpqP-X7Nn-A@mail.gmail.com>
References: <20120613130054.b5695621.yoshikawa.takuya@oss.ntt.co.jp>
	<20120613130304.0186fa9d.yoshikawa.takuya@oss.ntt.co.jp>
	<CAC5umyj582T+9GbOYDzOAanmMcVZ-Fdxr7i-8GWf3gTSmtAKUA@mail.gmail.com>
	<20120613214157.0a5179d5358ec7f1b2646606@gmail.com>
	<CAC5umygutE35hVObuooWj=ADP6PZDy4cqLtxGnRtxRX8uTtGSw@mail.gmail.com>
	<20120613230013.3cc59bf908616e94bb4ccef2@gmail.com>
	<CAP6odji_JvRkJP1dSzGK5ww3y71h4k6pXyj4pOQBpqP-X7Nn-A@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Jun 2012 08:21:18 -0700
Grant Grundler <grantgrundler@gmail.com> wrote:

> >> >> Should this hash_table be converted from u16 hash_table[32] to
> >> >> DECLARE_BITMAP(hash_table, 16 * 32) to ensure that it is aligned
> >> >> on long-word boundary?
> >> >
> >> > I think hash_table is already long-word aligned because it is placed
> >> > right after a pointer.
> >>
> >> I recommend converting to proper bitmap.  Because such an implicit
> >> assumption is easily broken by someone touching this function.
> >
> > Do you mean something like:
> >        DECLARE_BITMAP(__hash_table, 16 * 32);
> >        u16 *hash_table = (u16 *)__hash_table;
> > ?
> >
> > Grant, what do you think about this?
> 
> Hi Takuya,
> two thoughts:
> 1) while I agree with Akinobu and thank him for pointing out a
> _potential_ alignment problem, this is a separate issue and your
> existing patch should go in anyway. There are probably other drivers
> with _potential_ alignment issues. Akinobu could get credit for
> finding them by submitting patches after reviewing calls to set_bit
> and set_bit_le() - similar to what you are doing now.

I prefer approach 1.

hash_table is local in build_setup_frame_hash(), so if further
improvement is also required, we can do that locally there later.

Thanks,
	Takuya


> 2) I generally do not like declaring one type and then using an alias
> of a different type to reference the same memory address. We have a
> simple alternative since hash_table[] is indexed directly only in one
> hunk of code:
>         for (i = 0; i < 32; i++) {
>                 *setup_frm++ = ((u16 *)hash_table)[i];
>                 *setup_frm++ = ((u16 *)hash_table)[i];
>         }
