Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756383Ab2ICM6H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 08:58:07 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:62927 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753114Ab2ICM6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 08:58:05 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Stephen Boyd <sboyd@codeaurora.org>
Subject: Re: [PATCH v2] hvc_dcc : add support to armv4 and armv5 core
Date: Mon, 3 Sep 2012 12:57:27 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Matthieu CASTET <castet.matthieu@free.fr>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, gregkh@linuxfoundation.org,
        alan@lxorguk.ukuu.org.uk, Matthieu Castet <matthieu.castet@parrot.com>
References: <1346413645-4593-1-git-send-email-castet.matthieu@free.fr> <5040EAF7.9010003@codeaurora.org>
In-Reply-To: <5040EAF7.9010003@codeaurora.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201209031257.28213.arnd@arndb.de>
X-Provags-ID: V02:K0:wszVk60Teqrt2k2D4/UbrQT4pyDfmVPCBycld+CjR0g
 hhnh8+CGWKHIIuL3k7q54G6/E6Ck7frgHs6PPgHukpFynTP/rv
 rqS9nqRg3wLbGoI0aiNUo/uCrjRaD9rZn7CTDBOK9XFiCfxWE/
 5Lvscv0KtDb5i2CD6EIRK9LVjtmP7/UCecQeOXLT0FxLzSAdFE
 LMJerDxWNOHLG9Wjh9gPVWmbqDqd+xhauiHg5bJqm42makmHXu
 kf+Z8Uf51h0Xpr+/o5SW9vwGBFpwB3Vw2w8+eloHtOd+G/d46L
 awIfe9WsRK9vI6cZrQKm0jE35J6HT7sv58b9NT+iYQRo6wENrx
 8MJxh4heAFlda3P8KtKo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 31 August 2012, Stephen Boyd wrote:
> > +static int hvc_dcc_put_chars_v6(uint32_t vt, const char *buf, int count)
> > +{
> > +     int i;
> > +
> > +     for (i = 0; i < count; i++) {
> > +             while (__dcc_getstatus_v6() & DCC_STATUS_TX_V6)
> > +                     cpu_relax();
> > +
> > +             __dcc_putchar_v6(buf[i]);
> > +     }
> > +
> > +     return count;
> > +}
> 
> It's unfortunate that the main logic is duplicated. I wonder if we could
> push the runtime decision slightly lower into the accessor functions
> instead and make some new functions dcc_tx_busy() and dcc_rx_busy() or
> something. Then these loops stay the same.

Agreed. Ideally, you should be able to get the code to be compiled into
the same binary as before for ARMv6+. If only the inline assembly differs,
you can do something like

static inline char __dcc_getchar(void)
{
        char __c;

        if (__LINUX_ARM_ARCH >= 6)
		asm volatile("mrc p14, 0, %0, c0, c5, 0 @ read comms data reg"
	                : "=r" (__c));
	else
		asm volatile ("mrc p14, 0, %0, c1, c0  @ read comms data reg"
			: "=r" (ret));
        isb();

        return __c;
}

	Arnd
