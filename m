Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757241Ab0EASsO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 May 2010 14:48:14 -0400
Received: from t21.t-2.net ([84.255.209.100]:35010 "EHLO t21.t-2.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753826Ab0EASsN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 May 2010 14:48:13 -0400
Subject: Re: [PATCH] console logging detour via printk
From: Samo Pogacnik <samo_pogacnik@t-2.net>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-embedded <linux-embedded@vger.kernel.org>,
       linux kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20100501120418.6fca2aad@lxorguk.ukuu.org.uk>
References: <1272664980.10241.77.camel@itpsd6lap>
	 <20100501120418.6fca2aad@lxorguk.ukuu.org.uk>
Content-Type: text/plain
Date: Sat, 01 May 2010 20:48:09 +0200
Message-Id: <1272739689.2147.156.camel@itpsd6lap>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
X-SGG-UMAMSID: 20100501184810Z22686t21.t-2.net 1O8HjX-0005tu-6y
X-SGG-RESULT: 20100501184810Z22686t21.t-2.net C1:OK E1:OK MX1:OK BL:OK SPF:off  CT:Unknown CM: SIP:84.255.254.67 SMF:samo_pogacnik@t-2.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne 01.05.2010 (sob) ob 12:04 +0100 je Alan Cox zapisal(a):
> > while i was searching for effective logging of complete console output
> > produced by the kernel and user phase of the boot process, it turned out
> > that only kernel messages imho get systematically cached and stored into
> > log files (if needed). All userspace processes are on their own to use
> > syslog, which is fine, but there are also many console messages
> > reporting the boot status via init scripts, .... I came across the
> > bootlogd daemo, which handles the job of redirecting console output into
> > a log file, but i find it problematic to use especialy, when using
> > initial ram disk image.
> 
> So you want to patch the kernel because you can't work out how to do this
> in userspace ? The distributions seem to have no problem doing this in
> user space that I can see. It doesn't seem to be a hard user space
> problem, and there are a ton of things you want to do with this sort of
> stuff (like network logging) that you can't do in kernel space.

The distros have no problem logging complete console output into log
files or over the network, because they simply do not do it at least for
the initrd part of the boot process (i'd be glad, if i'm wrong). 
Anyway the proposed mechanism nicely bridges the gap between the kernel
boot start and the system logging daemon start-up. It also solves the
chicken and egg problem of how to log console if user space console
logging facility fails.

> 
> > --- a_linux-2.6.33.3/drivers/char/vt.c
> > +++ b_linux-2.6.33.3/drivers/char/vt.c
> > @@ -2696,6 +2696,16 @@ static int con_write(struct tty_struct *tty, const unsigned char *buf, int count
> >  {
> >  	int	retval;
> >  
> > +#ifdef CONFIG_VT_CONSOLE_DETOUR
> > +	if (console_detour) {
> > +		int idx = vt_console_driver.index - 1;
> > + 
> > +		if ((idx >= 0) && (idx == tty->index)) {
> > +			console_printk_detour(buf, count);
> > +			return count;
> > +		}
> > +	}
> > +#endif
> 
> This requires you go around hacking up each device which is not a good
> idea and becomes rapidly unmaintainable.

Agree, it should have been done within a well defined code volume.

> 
> I suspect what you actually need for such logging might be to write a
> very simple tty driver whose write method is implemented as printk. That
> works in the general case and doesn't require hacking up the code
> everywhere else.

Looks to me that some kernel code is welcome:)?

> 
> However given your init stuff can trivially use openpty to set up a logged
> console I am not sure I see the point in doing this in kernel in the
> first place.
> 

As said above, how to bridge kernel boot start and logging daemon
start-up without kernel help, especially when initrd is in the way? imho
it would be too complicated.

> Alan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-embedded" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

thanks for the reply, with best regards, Samo

