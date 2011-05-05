Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752136Ab1EELoE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 07:44:04 -0400
Received: from cantor.suse.de ([195.135.220.2]:46116 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751156Ab1EELoC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 07:44:02 -0400
Date: Thu, 5 May 2011 13:44:00 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: =?ISO-8859-15?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [hid-picolcd] Avoid compile warning/error triggered by
 copy_from_user()
In-Reply-To: <20110505120410.28faceda@pluto.restena.lu>
Message-ID: <alpine.LNX.2.00.1105051343240.28291@pobox.suse.cz>
References: <20110504210842.50edc842@neptune.home> <alpine.LNX.2.00.1105051126560.28291@pobox.suse.cz> <20110505120410.28faceda@pluto.restena.lu>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 May 2011, Bruno Prémont wrote:

> > > With CONFIG_DEBUG_STRICT_USER_COPY_CHECKS=y compilation of PicoLCD
> > > driver fails on copy_from_user(), without it a warning is generated:
> > > 
> > >   CC [M]  drivers/hid/hid-picolcd.o
> > > In file included from /usr/src/linux-2.6/arch/x86/include/asm/uaccess.h:571,
> > >                  from /usr/src/linux-2.6/arch/x86/include/asm/sections.h:5,
> > >                  from /usr/src/linux-2.6/arch/x86/include/asm/hw_irq.h:26,
> > >                  from /usr/src/linux-2.6/include/linux/irq.h:359,
> > >                  from /usr/src/linux-2.6/arch/x86/include/asm/hardirq.h:5,
> > >                  from /usr/src/linux-2.6/include/linux/hardirq.h:7,
> > >                  from /usr/src/linux-2.6/include/linux/interrupt.h:12,
> > >                  from /usr/src/linux-2.6/include/linux/usb.h:15,
> > >                  from /usr/src/linux-2.6/drivers/hid/hid-picolcd.c:25:
> > > In function 'copy_from_user',
> > >     inlined from 'picolcd_debug_eeprom_write' at drivers/hid/hid-picolcd.c:1592:
> > > arch/x86/include/asm/uaccess_32.h:212: error: call to 'copy_from_user_overflow' declared with attribute error: copy_from_user() buffer size is not provably correct
> > > 
> > > gcc-4.4.5 is not able to track size calculation when it is stored into
> > > a variable, thus tell copy_from_user() maximum size via
> > > min(*max-size*, *effective-size*) explicitly and inline how much to copy
> > > at most.
> > > 
> > > Signed-off-by: Bruno Prémont <bonbons@linux-vserver.org>
> > > --
> > > 
> > > diff --git a/drivers/hid/hid-picolcd.c b/drivers/hid/hid-picolcd.c
> > > index b2f56a1..9d8710f 100644
> > > --- a/drivers/hid/hid-picolcd.c
> > > +++ b/drivers/hid/hid-picolcd.c
> > > @@ -1585,11 +1585,11 @@ static ssize_t picolcd_debug_eeprom_write(struct file *f, const char __user *u,
> > >  	memset(raw_data, 0, sizeof(raw_data));
> > >  	raw_data[0] = *off & 0xff;
> > >  	raw_data[1] = (*off >> 8) & 0xff;
> > > -	raw_data[2] = s < 20 ? s : 20;
> > > +	raw_data[2] = min((size_t)20, s);
> > >  	if (*off + raw_data[2] > 0xff)
> > >  		raw_data[2] = 0x100 - *off;
> > >  
> > > -	if (copy_from_user(raw_data+3, u, raw_data[2]))
> > > +	if (copy_from_user(raw_data+3, u, min((u8)20, raw_data[2])))
> > 
> > Hmm ... this is quite an obfuscation just for the sake of making gcc 
> > happy.
> 
> As long as CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set it's just
> making gcc happy, when it is set compilation fails, which is at least
> annoying.
> 
> > Do other versions of gcc get this right? (i.e. is this gcc bug?)
> 
> Hm, don't remember exactly but older gcc versions triggered the same
> error. I didn't check with more recent version.
> 
> I can try with gcc-4.5.1/gcc-4.5.2 or gcc-4.6.0 but it will take
> some time to first compile those versions of gcc and then check how
> they handle this case.
> 
> > Don't we have similar problems all over the place in the kernel?
> 
> I have not seen any similar warnings turning up in my compiles so
> probably only a limited amount of places around the kernel are
> affected, if at all (they might have worked around as well).
> As my configs are rather optimized for the target machines I'm not
> compiling most of the drivers.
> Maybe some of Ingo's/Randy's (and whoever else is building them)
> randconfig/allyesconfig/allmodconfig show other affected code (not
> sure where to find their build logs though).
> 
> I don't think that many users of copy_from_user() have variable counts
> of data to copy (most often a struct the sizeof which is then passed).

Hmm. Not really happy that we have to do such ritual dancing just to 
satisfy gcc, but whatever.

Applied, thanks.

-- 
Jiri Kosina
SUSE Labs
