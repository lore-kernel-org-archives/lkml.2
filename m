Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932316Ab2HHHwQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 03:52:16 -0400
Received: from mailrelay1.diasemi.com ([82.210.246.133]:7503 "EHLO
	mailrelay1.diasemi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959Ab2HHHwO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 03:52:14 -0400
From: "Opensource [Anthony Olech]" <anthony.olech.opensource@diasemi.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "Opensource [Anthony Olech]" <anthony.olech.opensource@diasemi.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: RE: [NEW DRIVER V1 5/7] DA9058 GPIO driver
Thread-Topic: [NEW DRIVER V1 5/7] DA9058 GPIO driver
Thread-Index: AQHNcIvHmHLW+D1Fqk6Ahcg5llq5SJdGPtkAgAapOBCAAaZTAIABAayA
Date: Wed, 8 Aug 2012 07:52:10 +0000
Message-ID: <24DF37198A1E704D9811D8F72B87EB51032C3D9B@NB-EX-MBX02.diasemi.com>
References: <201208020849.q728nhU3007824@latitude.olech.com>
 <20120802101952.GG29157@opensource.wolfsonmicro.com>
 <24DF37198A1E704D9811D8F72B87EB51032C39DE@NB-EX-MBX02.diasemi.com>
 <20120807171437.GC16861@opensource.wolfsonmicro.com>
In-Reply-To: <20120807171437.GC16861@opensource.wolfsonmicro.com>
Accept-Language: en-GB, de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.20.21.86]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Mark Brown [mailto:broonie@opensource.wolfsonmicro.com]
> Sent: 07 August 2012 18:15
> To: Opensource [Anthony Olech]
> Cc: LKML
> Subject: Re: [NEW DRIVER V1 5/7] DA9058 GPIO driver
> On Mon, Aug 06, 2012 at 03:15:17PM +0000, Opensource [Anthony Olech]
> wrote:
> > I do realize that REGMAP does locking on individual register accesses,
> > however, the each GPIO line is controlled by 4-bits in a register,
> > with the meaning of the most significant bit depending on the GPIO
> > direction, so it is essential that the register be read first before
> > do an update, thus two sequential register accesses must be protected
> > by a mutex to prevent another process changing the register (and hence
> > the meaning of the most-significant bit) in the middle of the two accesses.
> > I hope this explains to your satisfaction why a driver mutex is
> > required in addition to the regmap's register access mutex
> This seems a bit excessive and complicated - I'd be inclined to either just say
> that the caller is responsible for avoiding confusion here (obviously if you're
> changing the direction there's a race anyway) or store the data in a variable
> locally rather than having to do I/O on the device under lock every time it's
> interacted with.

By using a semaphore (mutex/critical region) as I do in the DA9058 GPIO
component driver, there is absolutely no set-direction-race-condition in
the driver. The driver will always be consistent, either INP or OUT for each
GPIO line. There may, indeed, be confusion between multiple users of the
GPIO lines, but that is, quite properly, their problem. Even though in practice
there will usually be only one GPIO consumer/user, it still seems to me to be
better to code for the worst case. If indeed there is only one GPIO consumer/
user then the mutex access will be fast and non-blocking.

The GPIO control register (as opposed to the status register) is marked as
non-volitile so there should be no i2c access overhead when reading it.

Tony
