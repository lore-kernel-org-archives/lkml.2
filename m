Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760569Ab0FKVGo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 17:06:44 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59712 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753307Ab0FKVGn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 17:06:43 -0400
Message-ID: <4C12A539.1000709@zytor.com>
Date: Fri, 11 Jun 2010 14:06:01 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       linux-kernel@vger.kernel.org
Subject: Re: sequence lock in Linux
References: <20100611194016.GA5213@Krystal> <AANLkTil84IIgzlPcycNWJFRpZIGRqTFL6FGffzqOaSEx@mail.gmail.com> <20100611203607.GH2394@linux.vnet.ibm.com>
In-Reply-To: <20100611203607.GH2394@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/11/2010 01:36 PM, Paul E. McKenney wrote:
> 
> The reason that the C standard permits this is to allow for things like
> 8-bit CPUs, which are simply unable to load or store 32-bit quantities
> except by doing it chunkwise.  But I don't expect the Linux kernel to
> boot on these, and certainly not on any of the ones that I have used!
> 
> I most definitely remember seeing a gcc guarantee that loads and stores
> would be done in one instruction whenever the hardware supported this,
> but I am not finding it today.  :-(
> 

What gcc does not -- and should not -- guarantee is that accessing a
non-volatile member is done exactly once.  As Mathieu pointed out, it
can choose to drop it due to register pressure and load it again.

What is possibly a much bigger risk -- since this is an inline -- is
that the value is cached from a previous piece of code, *or* that since
the structure is const(!) that the second read in the repeat loop is
elided.  Presumably current versions of gcc don't do that across a
memory clobber, but that doesn't seem entirely out of the question.

	-hpa
