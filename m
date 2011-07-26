Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753127Ab1GZSj6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 14:39:58 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:50221 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752542Ab1GZSjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 14:39:52 -0400
Date: Tue, 26 Jul 2011 20:39:35 +0200
From: Borislav Petkov <bp@amd64.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Borislav Petkov <bp@amd64.org>, Ray Lee <ray-lk@madrabbit.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        "Przywara, Andre" <Andre.Przywara@amd.com>,
        "Pohlack, Martin" <Martin.Pohlack@amd.com>
Subject: Re: [PATCH] x86, AMD: Correct F15h IC aliasing issue
Message-ID: <20110726183935.GG32536@aftab>
References: <20110724182323.GA13247@aftab>
 <20110724183045.GB29660@elte.hu>
 <20110724190752.GA13647@aftab>
 <20110724204450.GB18546@elte.hu>
 <20110725200014.GA23986@aftab>
 <20110725200645.GC8302@elte.hu>
 <20110725215328.GA25960@aftab>
 <CADU53JV-aKbRU-iixbqcv_kAci7L6z43GYmP6uw8hZdY4PrBbQ@mail.gmail.com>
 <20110726172801.GC32536@aftab>
 <20110726183430.GA501@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110726183430.GA501@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 26, 2011 at 02:34:30PM -0400, Ingo Molnar wrote:
> 
> * Borislav Petkov <bp@amd64.org> wrote:
> 
> > Ok, I went and installed a Debian wheezy with gnome and started 
> > almost everything I could find in the startup menu. Kernel is 3.0 
> > with Linus' simpler fix.
> > 
> > The attached file shows all libraries which would create aliases 
> > (i.e. 2 or more unique values for bits [14:12] along with the 
> > respective count) in the total of:
> > 
> > Total r-xp mappings: 831, aliasing: 240 (0.289%)
> 
> 28.9%, right?

Yessir.

> > For example, libc gets mapped into all possible slots for [14:12]
> > 
> > Library                                 [14:12] count
> > =======                                 ======= =====
> > /lib/libc-2.11.2.so
> >                                         0       12
> >                                         1       12
> >                                         2       11
> >                                         3       12
> >                                         4       13
> >                                         5       16
> >                                         6       13
> >                                         7       9
> > 
> > 
> > and so on.
> 
> Was this done with a stock kernel, or with the simple patch applied?

with the simplest version of Linus' patch:

diff --git a/arch/x86/mm/mmap.c b/arch/x86/mm/mmap.c
index 1dab519..6b1094d 100644
--- a/arch/x86/mm/mmap.c
+++ b/arch/x86/mm/mmap.c
@@ -90,6 +90,8 @@ static unsigned long mmap_rnd(void)
                        rnd = (long)get_random_int() % (1<<8);
                else
                        rnd = (long)(get_random_int() % (1<<28));
+
+               rnd &= ~0x7;
        }
        return rnd << PAGE_SHIFT;
 }

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
