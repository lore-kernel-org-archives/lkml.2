Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753824Ab0JDVwb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 17:52:31 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43573 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751591Ab0JDVwa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 17:52:30 -0400
Message-ID: <4CAA4C7D.8040006@zytor.com>
Date: Mon, 04 Oct 2010 14:51:57 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: Jason Baron <jbaron@redhat.com>
CC: Daniel Drake <dsd@laptop.org>, Andres Salomon <dilinger@queued.net>,
        Chris Ball <cjb@laptop.org>, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, mingo@elte.hu
Subject: Re: Dynamic nop selection breaks boot on Geode LX
References: <AANLkTimF2tcksBkww50MhiO0YY=MCt4rcnfDR+tJhTUJ@mail.gmail.com> <20101004154633.GA2900@redhat.com>
In-Reply-To: <20101004154633.GA2900@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/04/2010 08:46 AM, Jason Baron wrote:
> 
> move arch_init_ideal_nop5 later
> 
> arch_init_ideal_nop5() was being called from setup_arch() before
> the exception table was setup. Move it later into
> alternative_instructions().
> 
> Fixes a boot hang on OLPC's XO-1 laptop based on Geode LX
> processor.
> 

This code is fundamentally toxic and needs to be scrapped completely --
it is simply broken beyond repair.

We tried exactly this type of dynamic selection before, and it doesn't
work on broken virtualizers; in particular Microsoft VirtualPC can pass
the exception test and yet fail later.

The end result is very simple: you can always use NOPL on 64 bits, you
can never use NOPL on 32 bits.

66 66 66 66 90 will always *work* (as in, it will never fail) but it's
pretty slow on older CPUs which took a hit on handle prefixes -- but it
might still be faster than a jump on those.  Thus, in your code the JMP
case will never be reached anyway.

There isn't, of course, a classic 5-byte sequence, although the sequence:

	2E 8D 75 26 00

... should work (leal %ds:0(,%esi,1),%esi).  However, 66 ... 90 is
likely to work better on modern processors (although I haven't measured it.)

	-hpa
