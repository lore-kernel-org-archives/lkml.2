Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756503Ab0GMXtd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 19:49:33 -0400
Received: from claw.goop.org ([74.207.240.146]:60359 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751494Ab0GMXtc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 19:49:32 -0400
Message-ID: <4C3CFB8B.1090804@goop.org>
Date: Tue, 13 Jul 2010 16:49:31 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Lightning/1.0b2pre Thunderbird/3.0.5
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Palfrader <peter@palfrader.org>, Avi Kivity <avi@redhat.com>,
        Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        stable@kernel.org, stable-review@kernel.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Glauber Costa <glommer@redhat.com>,
        Zachary Amsden <zamsden@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [patch 134/149] x86, paravirt: Add a global synchronization point
 	for pvclock
References: <20100707124731.GJ15122@anguilla.noreply.org>	<4C359D5A.1050906@redhat.com>	<20100713102350.GW15122@anguilla.noreply.org>	<4C3C68C8.4060409@redhat.com>	<20100713141902.GB15122@anguilla.noreply.org>	<4C3C8CE5.1080705@redhat.com>	<20100713162207.GC15122@anguilla.noreply.org>	<4C3C9589.4090602@redhat.com>	<4C3C96EC.8060901@redhat.com>	<4C3C9839.4090404@redhat.com>	<20100713172526.GE15122@anguilla.noreply.org>	<AANLkTini61PZO1_icO2jRcBmMvWm24splgjZA1lUgab2@mail.gmail.com> <AANLkTikDo0UsJxGekCdFgDMEHOONLiRe7ZOSf_j0ZKjf@mail.gmail.com> <4C3CAE8F.10900@goop.org> <4C3CE560.5050701@zytor.com>
In-Reply-To: <4C3CE560.5050701@zytor.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/13/2010 03:14 PM, H. Peter Anvin wrote:
> Actually, I believe volatile operations (including asm volatile) are
> strictly ordered *with respect to other volatile operations*. 

The documentation makes no reference to that property; in fact it
suggests it is outright not true:

    Note that even a volatile `asm' instruction can be moved relative to
    other
    code, including across jump instructions.  For example, on many targets
    there is a system register which can be set to control the rounding
    mode of floating point operations.  You might try setting it with a
    volatile `asm', like this PowerPC example:

                asm volatile("mtfsf 255,%0" : : "f" (fpenv));
                sum = x + y;

    This will not work reliably, as the compiler may move the addition
    back before the volatile `asm'.  To make it work you need to add an
    artificial dependency to the `asm' referencing a variable in the
    code you don't want moved, for example:

             asm volatile ("mtfsf 255,%1" : "=X"(sum): "f"(fpenv));
             sum = x + y;

    Similarly, you can't expect a sequence of volatile `asm'
    instructions to remain perfectly consecutive.
    [...]
    An `asm' instruction without any output operands will be treated
    identically to a volatile `asm' instruction.

>  As such I
> would think we'd want to keep the "memory" clobber here, to make it
> strictly ordered with regards to *all* memory operations.
>   

That would keep its overall effect consistent.

    J
