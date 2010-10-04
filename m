Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755798Ab0JDWPV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 18:15:21 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:38185 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755298Ab0JDWPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 18:15:20 -0400
X-Authority-Analysis: v=1.1 cv=iGF3DqghDyT/uy4mV2LvOKNXCATMSjL+tOl9cucoGVk= c=1 sm=0 a=YGL2JzEyuHAA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=RAfyifOLct42CDp3T5kA:9 a=1pWAtavq9qsyLWeYzNUA:7 a=7qCiEFKXTSvcpdedIGh7dZQbk6sA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: Dynamic nop selection breaks boot on Geode LX
From: Steven Rostedt <rostedt@goodmis.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jason Baron <jbaron@redhat.com>, Daniel Drake <dsd@laptop.org>,
        Andres Salomon <dilinger@queued.net>, Chris Ball <cjb@laptop.org>,
        linux-kernel@vger.kernel.org, mingo@elte.hu
In-Reply-To: <4CAA4C7D.8040006@zytor.com>
References: <AANLkTimF2tcksBkww50MhiO0YY=MCt4rcnfDR+tJhTUJ@mail.gmail.com>
	 <20101004154633.GA2900@redhat.com>  <4CAA4C7D.8040006@zytor.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 04 Oct 2010 18:15:18 -0400
Message-ID: <1286230518.6750.76.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-10-04 at 14:51 -0700, H. Peter Anvin wrote:
> On 10/04/2010 08:46 AM, Jason Baron wrote:
> > 
> > move arch_init_ideal_nop5 later
> > 
> > arch_init_ideal_nop5() was being called from setup_arch() before
> > the exception table was setup. Move it later into
> > alternative_instructions().
> > 
> > Fixes a boot hang on OLPC's XO-1 laptop based on Geode LX
> > processor.
> > 
> 
> This code is fundamentally toxic and needs to be scrapped completely --
> it is simply broken beyond repair.
> 
> We tried exactly this type of dynamic selection before, and it doesn't
> work on broken virtualizers; in particular Microsoft VirtualPC can pass
> the exception test and yet fail later.

So the code is broken because of broken virtualizers??

> 
> The end result is very simple: you can always use NOPL on 64 bits, you
> can never use NOPL on 32 bits.
> 
> 66 66 66 66 90 will always *work* (as in, it will never fail) but it's
> pretty slow on older CPUs which took a hit on handle prefixes -- but it
> might still be faster than a jump on those.  Thus, in your code the JMP
> case will never be reached anyway.

The jmp was there because of paranoia, and I never expected it to be
reached.

> 
> There isn't, of course, a classic 5-byte sequence, although the sequence:
> 
> 	2E 8D 75 26 00
> 
> ... should work (leal %ds:0(,%esi,1),%esi).  However, 66 ... 90 is
> likely to work better on modern processors (although I haven't measured it.)

The point is, this nop will be at _every_ function call (it replaces the
mcount call). Not just scattered throughout the kernel. It is imperative
that we have the best nop available.

So what would you recommend?

-- Steve


