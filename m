Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754368Ab2FMPVW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 11:21:22 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:44630 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752743Ab2FMPVU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 11:21:20 -0400
MIME-Version: 1.0
In-Reply-To: <20120613230013.3cc59bf908616e94bb4ccef2@gmail.com>
References: <20120613130054.b5695621.yoshikawa.takuya@oss.ntt.co.jp>
	<20120613130304.0186fa9d.yoshikawa.takuya@oss.ntt.co.jp>
	<CAC5umyj582T+9GbOYDzOAanmMcVZ-Fdxr7i-8GWf3gTSmtAKUA@mail.gmail.com>
	<20120613214157.0a5179d5358ec7f1b2646606@gmail.com>
	<CAC5umygutE35hVObuooWj=ADP6PZDy4cqLtxGnRtxRX8uTtGSw@mail.gmail.com>
	<20120613230013.3cc59bf908616e94bb4ccef2@gmail.com>
Date: Wed, 13 Jun 2012 08:21:18 -0700
Message-ID: <CAP6odji_JvRkJP1dSzGK5ww3y71h4k6pXyj4pOQBpqP-X7Nn-A@mail.gmail.com>
Subject: Re: [PATCH 2/5] drivers/net/ethernet/dec/tulip: Use standard
 __set_bit_le() function
From: Grant Grundler <grantgrundler@gmail.com>
To: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>,
        akpm@linux-foundation.org, bhutchings@solarflare.com,
        grundler@parisc-linux.org, arnd@arndb.de, benh@kernel.crashing.org,
        avi@redhat.com, mtosatti@redhat.com, linux-net-drivers@solarflare.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 13, 2012 at 7:00 AM, Takuya Yoshikawa
<takuya.yoshikawa@gmail.com> wrote:
> On Wed, 13 Jun 2012 22:31:13 +0900
> Akinobu Mita <akinobu.mita@gmail.com> wrote:
>
>> >> Should this hash_table be converted from u16 hash_table[32] to
>> >> DECLARE_BITMAP(hash_table, 16 * 32) to ensure that it is aligned
>> >> on long-word boundary?
>> >
>> > I think hash_table is already long-word aligned because it is placed
>> > right after a pointer.
>>
>> I recommend converting to proper bitmap.  Because such an implicit
>> assumption is easily broken by someone touching this function.
>
> Do you mean something like:
>        DECLARE_BITMAP(__hash_table, 16 * 32);
>        u16 *hash_table = (u16 *)__hash_table;
> ?
>
> Grant, what do you think about this?

Hi Takuya,
two thoughts:
1) while I agree with Akinobu and thank him for pointing out a
_potential_ alignment problem, this is a separate issue and your
existing patch should go in anyway. There are probably other drivers
with _potential_ alignment issues. Akinobu could get credit for
finding them by submitting patches after reviewing calls to set_bit
and set_bit_le() - similar to what you are doing now.

2) I generally do not like declaring one type and then using an alias
of a different type to reference the same memory address. We have a
simple alternative since hash_table[] is indexed directly only in one
hunk of code:
        for (i = 0; i < 32; i++) {
                *setup_frm++ = ((u16 *)hash_table)[i];
                *setup_frm++ = ((u16 *)hash_table)[i];
        }

thanks,
grant

>
>        Takuya
>
>
> ===
> drivers/net/ethernet/dec/tulip/tulip_core.c:
>
> static void build_setup_frame_hash(u16 *setup_frm, struct net_device *dev)
> {
>        struct tulip_private *tp = netdev_priv(dev);
>        u16 hash_table[32];
>        ...
> }
>
> drivers/net/ethernet/dec/tulip/de2104x.c:
>
> static void build_setup_frame_hash(u16 *setup_frm, struct net_device *dev)
> {
>        struct de_private *de = netdev_priv(dev);
>        u16 hash_table[32];
>        ...
> }
