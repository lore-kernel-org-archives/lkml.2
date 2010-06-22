Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752316Ab0FVWHF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 18:07:05 -0400
Received: from md2.t-2.net ([84.255.209.81]:17949 "EHLO md2.t-2.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751490Ab0FVWHB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 18:07:01 -0400
Subject: Re: [PATCH] detour TTY driver - now ttyprintk
From: Samo Pogacnik <samo_pogacnik@t-2.net>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-embedded <linux-embedded@vger.kernel.org>,
       linux kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20100621153858.444695c0@lxorguk.ukuu.org.uk>
References: <1273918658.2341.17.camel@itpsd6lap>
	 <1275171436.2122.29.camel@itpsd6lap>
	 <20100529235402.296406d9@lxorguk.ukuu.org.uk>
	 <1275175983.2122.42.camel@itpsd6lap> <1276123020.16010.97.camel@itpsd6lap>
	 <20100611134455.3fa7d563@lxorguk.ukuu.org.uk>
	 <1276291932.2154.45.camel@itpsd6lap>
	 <20100621153858.444695c0@lxorguk.ukuu.org.uk>
Content-Type: text/plain
Date: Wed, 23 Jun 2010 00:06:50 +0200
Message-Id: <1277244410.2195.47.camel@itpsd6lap>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
X-Junkmail-Status: score=10/150, host=md2.t-2.net
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A0B0206.4C2133FD.0083,ss=1,fgs=0,
	ip=192.168.1.20,
	so=2010-02-10 22:08:04,
	dmn=5.4.3/2007-10-18,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21.06.2010 (Mon) at 15:38 +0100 Alan Cox wrote:
> > I'm thinking to leave the ratelimit support in for the time being. I had
> > in mind cases, when someone does
> >  "cat /proc/kmsg > dev/ttyprintk" or
> > suppose the console is redirected to ttyprintk (which i would like to be
> > able to do from user program)
> 
> Console as in the printk sense would then loop.
> 
> If you are going to do the flow control you should probably do something
> like
> 
> 
> write_room()
> {
> 	if (!flow_controlled)
> 		space = 8192;
> 	return space;
> }
> 
> write()
> {
> 	space -= len;
> }
> 
> then your flow control will behave properly and slow down users rather
> than losing data (except stuff sent without blocking)
> 
For correct flow control, i suppose current empty space of the real
(final) printk buffer is needed. On the other hand my intermediate
pre-formatting buffer is only "one line" long, but serialized on access
in a way that it is always completely available (except for the time of
tpk_printk() function running). As such intermediate buffer only defines
maximum write_room space.

Now there are two ideas. The first one is to dig out current real printk
buffer space (smells like hacking?) and adapt write_room to that space
in some logical manner. And the other would be to use ratelimit support
to switch between max and zero in write_room answer and remove other
retelimit response?

What do you suggest, do i miss something?

regards, Samo

