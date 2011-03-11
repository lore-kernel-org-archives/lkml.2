Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755273Ab1CKMrQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 07:47:16 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:42528 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755225Ab1CKMrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 07:47:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=RczQ2oYkH/phrfySxrRBJkMRtgGXKI/F/XaFf73bqff3qmegOgd6OvjIntkKum9So7
         ieoyGMvAYmgQag1oWvQcDhgg3yXPe5X0RfoX3vuiQyLBUfQOQJiMv2KvMnJ+80eI34PH
         qW2kC738WuSfjQcNGn2UOa+ez2jHg42Y4mCAM=
Subject: Re: [PATCH n_gsm] GSM Mux in non-transparent mode
From: =?ISO-8859-1?Q?M=E1rio?= Isidoro <marioisidoro@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org
In-Reply-To: <20110310110658.0a46d19d@lxorguk.ukuu.org.uk>
References: <1299724790.1800.135.camel@Paio>
	 <20110310110658.0a46d19d@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 11 Mar 2011 12:47:04 +0000
Message-ID: <1299847624.1645.136.camel@Paio>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Thank you for your comments. I think the biggest problem with what I did
was forget that the driver should also work as a modem end, I'll recheck
my changes using your suggestions and try to submit the new patches
soon.

On Thu, 2011-03-10 at 11:06 +0000, Alan Cox wrote:
> > These alterations allow the usage of the non-transparent mode of the gsm
> > mux, it works well enough to establish a ppp session using pppd. The
> > increased buffer size allows the usage of the default MRU and MTU sizes
> > in pppd.
> 
> In the tty like adaption layers the buffer size and PPP sizes are not
> linked, because stuff is diced and packetised. Ok it's probably a
> performance win. Really it needs network support for best results. There
> is some prototype code for the network type ones but there are some
> *horrid* and quite hard to fix races in it that need fixing before that
> goes upstream

I've retested it with the 512 limits and it sometimes works. I'm not
sure where the problem is as it wasn't me that configured the ppp
server, but I will see if I can track down the real problem. Bigger
limits on the buffer seems to work better but it can be bias on my part.

> > There is a problem that happens if the process that is holding the
> > attached line discipline tries to detach it before a process using a
> > virtual com manages to close it. Both processes end up dealocked. I
> > think this has to do with the tty lock. I don't have the backtrace with
> > me
> 
> That one is a known recent breakage caused by Arnd's big kernel lock
> removal. Needs looking at but it looks 'interesting' to fix.
> 
> >  	gsm->output(gsm, cbuf, len);
> > -	gsm_print_packet("-->", addr, cr, control, NULL, 0);
> > +	gsm_print_packet("->-", addr, cr, control, NULL, 0);
> 
> Why ? It's important not to put in gratuitious changes.

This is just because the string '<--' seems to get eaten by a printk
somewhere, so I changed it to '-<-', that change is just to be
consistent but it's not very important.

> Probably worth checking the standard here. If not your workaround seems
> reasonable but buggy - surely you need to shift the bits here not in the
> modem processing where you otherwise overdo the shifts on the gsm_read_ea
> path. In fact would it be better to simply be more robust and do
> 
> 			if (len == 0)
> 				break;	/* No EA, try what we have*/
> 
I definitely like your solution better.  If I read the standard
correctly EA should be set to 1 if there is no break octet.
However this is what happens:
OUT: F9 03 EF 09 E3 05 07 0D FB F9
IN:  F9 03 EF 09 E1 05 07 0C FB F9
I think it's a bug on the modem, but I can be reading the standard
wrong, have to try with a modem from another manufacturer and check what
happens.

> 
> We need to reply to control messages in all cases as far as I can see
> from the specification ? Is there a reason for this tweak ?
> 
> > +		if (command == CMD_MSC) {
> > +			/* Out of band modem line change indicator for a DLCI */
> > +			gsm_control_modem(gsm, data, clen);
> > +		}
> 
> Ah I see what you are trying to do with that - if we get a modem status
> command we need to reply, if we get a response we need not to - but
> doesn't the modem line handling have to be different in each case anyway ?

I will think a bit more about how to do this. I should have considered
what happens if the driver is behaving as the modem.

> 
> 
> >  	case UA:
> >  	case UA|PF:
> > -		if (cr == 0 || dlci == NULL)
> > +		if (dlci == NULL)
> >  			break;
> 
> A UA without C/R set is not valid, this change seems wrong ?

My mistake, now that I think back I can't find the reason for why I did
this. :)

> 
> > +	/* At least Siemens/Cinterion and Telit modems require that the
> > control
> > +	   channel be open within 5 seconds of starting the cmux mode */
> > +	gsm_dlci_begin_open(dlci);
> 
> Correct - which is easy to do from user space, however if we are being
> run as the modem end (we do both) we cannot start sending SABM(P) messages
> at this point as the user has no ability to specify which way they want
> it.
> 
> The LDISC doesn't really use write so you've got a pass through after
> setting the ldisc if need be, but 5 seconds to set an ldisc, and issue
> two ioctls isn't hard even in perl...
> 
I hadn't noticed that doing a GSMIOC_SETCONF fires a DLCI 0 open
command, oops.

> No - we don't want to do this, there are cases where waiting is bad, the
> current code uses the modem responses of the other end to do open
> completion management. Think about O_NDELAY and a failed modem, or think
> about being the modem end.
> 
My idea was to wait for the acknowledge to the SAMB message before
firing the MSC, but if this is wrong I think its better to leave it out.
At least the GE863-Pro^3 seems to reply to the SAMB with the acknowledge
and an MSC independently if we asked for it or not.



