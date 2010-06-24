Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755442Ab0FXOBq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 10:01:46 -0400
Received: from one.firstfloor.org ([213.235.205.2]:56348 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755276Ab0FXOBp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 10:01:45 -0400
Date: Thu, 24 Jun 2010 16:01:43 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>, Borislav Petkov <bp@amd64.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Huang Ying <ying.huang@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Borislav Petkov <petkovbb@googlemail.com>, linux-kernel@vger.kernel.org,
       mauro@elte.hu
Subject: Re: [RFC][PATCH] irq_work
Message-ID: <20100624140143.GO578@basil.fritz.box>
References: <1277377121.1875.948.camel@laptop>
 <20100624110830.GC578@basil.fritz.box>
 <1277377852.1875.950.camel@laptop>
 <20100624112340.GA13502@elte.hu>
 <1277379294.1875.959.camel@laptop>
 <20100624123537.GA28884@elte.hu>
 <20100624130234.GM578@basil.fritz.box>
 <20100624132032.GA4474@kryptos.osrc.amd.com>
 <20100624133323.GN578@basil.fritz.box>
 <20100624134609.GB30323@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100624134609.GB30323@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Please, as Peter and Boris asked you already, quote a concrete, specific 
> example:

It was already in my answer to Peter.

> 
>   'Specific event X occurs, kernel wants/needs to do Y. This cannot be done
>    via the suggested method due to Z.'
> 
> Your generic arguments look wrong (to the extent they are specified) and it 
> makes it much easier and faster to address your points if you dont blur them 
> by vagaries.

It's one of the fundamental properties of recoverable errors.

Error happens.
Machine check or NMI or other exception happens. 
	That exception runs on the exception stack
	The error is not fatal, but recoverable.
For example you want to kill a process or call hwpoison or do some other
	recovery action. These generally have to sleep to do anything
	interesting.
You cannot do the sleeping on the exception stack, so you push it to
another context.

Now just because an error is recoverable doesn't mean it's not critical
(I think that was the mistake Boris made). If you don't do something
(like killing or recovery) you could end up in a loop or consume
corrupted data or something else bad. 

So the error has to have a fail safe path from detection to handling.

That's quite different from logging or performance counting etc.
where dropping events on overload is normal and expected.

Normally it can be only done by using dedicated resources.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
