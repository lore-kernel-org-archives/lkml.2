Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754510Ab0IEVfR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 17:35:17 -0400
Received: from n3-vm1.bullet.mail.gq1.yahoo.com ([67.195.23.157]:45741 "HELO
	n3-vm1.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754099Ab0IEVfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 17:35:16 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 547405.32199.bm@omp122.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type;
  b=qIxCWtx5pXhlPa/UH01Rj1Rz8bHYWzqwqfXH+Taghq3AGEKNmIAnX5EL347+pWI05WRU0jGU4TmY2ez2a9KuQX2fgwjliRzopnIj2BgEB7K1A1/hwwnZoYF1pVPYQJsABwRO8v23ziqBlDx9FJYls1CS8fwkIE8tFUbu7I+5FCE=;
Message-ID: <436709.64173.qm@web180305.mail.gq1.yahoo.com>
X-YMail-OSG: MdBuZbAVM1lvlQ7rUl1ArDxuh7mlJ6068l2g_Zo5ZNg13f4
 3fevWVnKKNwdXjPp9jPEVdxoSLNRtWruIm.FjCxueudVrRyuYk04q_dFpkAC
 Ik5j9Rjo82TzIVCI0Er3DzdVgmE3eiH5ir6pmjtiP8HanY7GXVpRLziOv5Nf
 eZZUzjOO1lNxIApsgDQqxJyKuGUz7WuzhOLPrNW53HfJ5zQUipw3slOZTBgZ
 8QhNF30r55eMIIV.g4KjN4IjxVdBjxzEdlmho30PPZ7S57E5cev_qzpWmnPC
 W.Wk7O1d6FiEvKiutysXFLBByiVM2z2bySW3ndr6N3eh0N.kTNW0Xs8ZXCHE
 dyjkXDpPXaURNSaA_sZGwXPazLz0ANzqVOkrhpwOrLNHse0XL3J0hHZRY7A-
 -
X-Mailer: YahooMailClassic/11.3.2 YahooMailWebService/0.8.105.279950
Date: Sun, 5 Sep 2010 14:35:15 -0700 (PDT)
From: David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH] usbnet: allow rx_process() to ignore packets
To: Ondrej Zary <linux@rainbow-software.org>
Cc: David Brownell <dbrownell@users.sourceforge.net>, netdev@vger.kernel.org,
        Kernel development list <linux-kernel@vger.kernel.org>
In-Reply-To: <201009051816.12823.linux@rainbow-software.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> > > From: Ondrej Zary <linux@rainbow-software.org>
> > > Subject: [PATCH] usbnet: allow rx_process() to
> ignore packets
> >
> > It already can ... I'm already not
> > liking this patch...

You didn't explain why "ignore".  As a rule, if
the network peer is sending garbage, that needs
to be accounted as an error, not igored.  You seem
to be complaining about accounting garbage as such.

 rx_process() knows only two cases:
> either rx_fixup() 
> returns 0 or a non-zero value. If I return 0,
>  the error counter is  incremented.

So don't return zero, when you're not trying to
indicate an error. ... easy.


> If I return non-zero value, packet is
> processed ("passed up the 
> stack" - usbnet_skb_return() called)
> if the skb has non-zero length,

Exactly -- that's how the minidriver says that
it stripped framing off the packet, so other
code should pass the packet up the stack.


Have you tried emptying the SKB (len zero) to
indicate you've consumed all of its contents?
(Or in your case, "ignored").  That would seem to
be more like what you want to do ...  ISTR that the
network stack cleanly handles empty SKBs; if not,
maybe it should.

There's no way
> to not pass the 
> packet up the stack without incrementing the error
> counter.

   If rx_fixup leaves a single packet in SKB, that
gets passed up the stack. and not treated as any
kind of error.



> 
> > You've not convinced me this is even necessary.
> >


