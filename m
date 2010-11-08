Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753477Ab0KHHwB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 02:52:01 -0500
Received: from isrv.corpit.ru ([86.62.121.231]:58719 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751278Ab0KHHwA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 02:52:00 -0500
Message-ID: <4CD7AC1D.4010701@msgid.tls.msk.ru>
Date: Mon, 08 Nov 2010 10:51:57 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.12) Gecko/20100913 Icedove/3.0.7
MIME-Version: 1.0
To: ranjith kumar <ranjithproxy@gmail.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: how to read one udp packet with more than one recvfrom() calls?
References: <AANLkTi=40758wF4Z6GDfm809miA-hnCnSQdwA9bALX0+@mail.gmail.com>
In-Reply-To: <AANLkTi=40758wF4Z6GDfm809miA-hnCnSQdwA9bALX0+@mail.gmail.com>
X-Enigmail-Version: 1.0.1
OpenPGP: id=804465C5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

08.11.2010 10:08, ranjith kumar wrote:
> Hi,
> 
> I  have implemented client and server programs using udp
> protocol(files are attached).
> UDP packet size is 500bytes.
> 
> I want to read these 500bytes in two calls to recvfrom(). First time
> reading 100bytes and second time 400bytes.
> How to do this?

There's no way to do so.  According to the udp(7) manpage:

 All receive operations return only one packet.  When the packet is
 smaller than the passed buffer, only that much data is  returned; when
 it is bigger, the packet is truncated and the MSG_TRUNC flag is set.
 MSG_WAITALL is not supported.

This is intentional, because the kernel does not keep the received
packets, it either delivers them right to the application or drops
them.  There's no sophisticated queue/stream management like for tcp.

For current speeds, one wants to _reduce_ number of system calls
made, not to increase them as you're trying to do, in order to
process as many data in one go as possible.  This is why new
system calls like mrecvfrom are being proposed.

> When I tried to change the third argument of recvfrom(size_t len),
> from 500 to 100, first 100bytes are read correctly.
> But when I call recvfrom() second time with len=400, it is reading the
> first 400bytes of "next udp packet".
> Why? Isn't it possible to read one udp packet in two calls to
> recvfrom()/read()????

This is how UDP is designed to work, and how it works on other
operating systems too.

/mjt
