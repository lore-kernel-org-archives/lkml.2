Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752750Ab0F1X16 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 19:27:58 -0400
Received: from md2.t-2.net ([84.255.209.81]:28665 "EHLO md2.t-2.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751491Ab0F1X14 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 19:27:56 -0400
Subject: Re: [PATCH] detour TTY driver - now ttyprintk
From: Samo Pogacnik <samo_pogacnik@t-2.net>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-embedded <linux-embedded@vger.kernel.org>,
       linux kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20100627143518.104ef190@lxorguk.ukuu.org.uk>
References: <1273918658.2341.17.camel@itpsd6lap>
	 <1275171436.2122.29.camel@itpsd6lap>
	 <20100529235402.296406d9@lxorguk.ukuu.org.uk>
	 <1275175983.2122.42.camel@itpsd6lap> <1276123020.16010.97.camel@itpsd6lap>
	 <20100611134455.3fa7d563@lxorguk.ukuu.org.uk>
	 <1276291932.2154.45.camel@itpsd6lap>
	 <20100621153858.444695c0@lxorguk.ukuu.org.uk>
	 <1277244410.2195.47.camel@itpsd6lap>
	 <20100622232108.26752ff8@lxorguk.ukuu.org.uk>
	 <1277462596.2143.101.camel@itpsd6lap>
	 <20100625120329.1303aa61@lxorguk.ukuu.org.uk>
	 <1277516912.29797.411.camel@itpsd6lap>
	 <20100627143518.104ef190@lxorguk.ukuu.org.uk>
Content-Type: text/plain
Date: Tue, 29 Jun 2010 01:27:45 +0200
Message-Id: <1277767665.2348.51.camel@itpsd6lap>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
X-Junkmail-Status: score=10/150, host=md2.t-2.net
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A0B0204.4C292FF3.01A1,ss=1,fgs=0,
	ip=192.168.1.20,
	so=2010-02-10 22:08:04,
	dmn=5.4.3/2007-10-18,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne 27.06.2010 (ned) ob 14:35 +0100 je Alan Cox zapisal(a):
> > I thought that this would automatically reduce processor load, which is
> > obviously not the case. Sorry for the delay, but i am trying to figure
> > out how to slow down write method when under pressure.
> 
> Ok I played with this a bit. Much to my surprise until I thought about it
> in detail it all works fine without any of the ratelimiting at all. There
> is a problem if you manage to redirect the console *in kernel* to the
> printk driver, but that needs stopping anyway and rate limit won't fix it
> (you blow the stack before it kicks in)
> 
> In the case where userspace loads it hard and its a graphical console
> then we use a lot of CPU power drawing stuff on screen, but killing the
> process does as is expected.
> 
> With a serial console the printk itself blocks which blocks the line
> discipline which in turn slows stuff down.
> 
> The only two bad things I can see how to cause are
> 
> - Slowing down output by stuffing lots of extra data into the port (which
>   I can do anyway just fine) so isn't worse than before.
> 
> - Filling up the dmesg log easily and hiding important messages. Not
>   really a problem in this case bcause the whole point of this is
>   embedded and capturing those messages as if they were system ones.
> 
> So much to my surprise the flow control is a red herring and best left
> out.
> 
> Alan

If without flow control, do you think it makes sense to very slowly
introduce more and more delay (interruptible) into tty's write operation
when output rate is "too" high? That way non-error conditions would not
suffer (not discarding any messages, only delaying additional 1 msec on
100 writes), when ratelimit would have been exceeded from time to time.
And on the other hand endless high-volume output, which is probably an
error condition, would slowly give away more and more of its processing
time. Maybe this would also help if output is made on behalf of some
high RT-prioritized process?

Of course, i can easily remove ratelimiting as well, if the situation
with flow control isn't clear and this only complicates things.

Samo


