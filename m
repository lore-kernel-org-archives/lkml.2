Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751814Ab2A0IPk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 03:15:40 -0500
Received: from casper.infradead.org ([85.118.1.10]:56626 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059Ab2A0IPj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 03:15:39 -0500
Message-ID: <1327652120.2446.123.camel@twins>
Subject: Re: Shift by one instruction in the perf annotate output
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: =?ISO-8859-1?Q?L=E9na=EFc?= Huard <lenaic@lhuard.fr.eu.org>
Cc: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
Date: Fri, 27 Jan 2012 09:15:20 +0100
In-Reply-To: <201201270001.27765.lenaic@lhuard.fr.eu.org>
References: <201201270001.27765.lenaic@lhuard.fr.eu.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-01-27 at 00:01 +0100, Lénaïc Huard wrote:
> Using perf and zooming up to the annotated assembler, I noticed a “shift by 
> one” issue between the assembler instructions and the reported consumed cycles 
> in the left margin.
> Each time a given instruction is expensive, the high event count appears on 
> the line right after.
> In order to validate that feeling, I tried to put an expensive instruction 
> (division) inside a block of cheaper instructions (no operation). And here is 
> the output of perf annotate:
> 
>     0,00 :          40041d:       nop
>     0,00 :          40041e:       nop
>     5,31 :          40041f:       nop                                                                                                                                               
>     0,00 :          400420:       divl   (%rsp)
>    84,18 :          400423:       nop                                                                                                                                               
>     0,00 :          400424:       nop
>     0,07 :          400425:       nop
> 
> I would have expected the 84,18 count to be in front of the “divl” instruction 
> and not in front of the “nop” one.

That's how it works on x86 (and a lot of other architectures), the divl
raises the interrupt line but the CPU can only assert the interrupt once
its completed the instruction its working on (sometimes more than one)
and you get a drift between when the interrupt was raised and when it
gets handled, its called skid and is a well known issue.

> I am running Linux and perf 3.2 but I remember that previous versions suffered 
> from the same issue.
> 
> I don’t know if it could be specific to my cpu:
> processor       : 0
> vendor_id       : GenuineIntel
> cpu family      : 6
> model           : 15
> model name      : Intel(R) Core(TM)2 CPU          6600  @ 2.40GHz 

And sadly its the best you'll get on your machine, most Intel chips
after that (including the core2 shrink, but excluding the latest core i7
SNB) can do better using a feature called PEBS.


