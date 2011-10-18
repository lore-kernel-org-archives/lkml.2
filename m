Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752568Ab1JRSon (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 14:44:43 -0400
Received: from mail.windriver.com ([147.11.1.11]:37207 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752198Ab1JRSom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 14:44:42 -0400
Message-ID: <4E9DC902.4000204@windriver.com>
Date: Tue, 18 Oct 2011 14:44:18 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110922 Thunderbird/3.1.15
MIME-Version: 1.0
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
CC: <tglx@linutronix.de>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] irq: don't put module.h into irq.h for tracking irqgen
 modules.
References: <1317434037-15343-1-git-send-email-paul.gortmaker@windriver.com> <20111018174353.GB16894@breakpoint.cc>
In-Reply-To: <20111018174353.GB16894@breakpoint.cc>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.146.65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-10-18 01:43 PM, Sebastian Andrzej Siewior wrote:
> On Fri, Sep 30, 2011 at 09:53:57PM -0400, Paul Gortmaker wrote:
>> Recent commit "irq: Track the owner of irq descriptor" in
>> commit ID b6873807a7143b7 placed module.h into linux/irq.h
>> but we are trying to limit module.h inclusion to just C files
>> that really need it, due to its size and number of children
>> includes.  This targets just reversing that include.
> 
> Sorry for that. This is for "not to re-compile the whole tree once a tiny
> header file has changes" right?

Correct.

> 
>> Add in the basic "struct module" since that is all we really need
>> to ensure things compile.  In theory, b687380 should have added the
>> module.h include to the irqdesc.h header as well, but the implicit
>> module.h everywhere presence masked this from showing up.  So give
>> it the "struct module" as well.
>>
>> As for the C files, irqdesc.c is only using THIS_MODULE, so it
>> does not need module.h - give it export.h instead.  The C file
> 
> just tried to compile this ontop of the tip tree and it ended with:
> |kernel/irq/irqdesc.c:12:26: fatal error: linux/export.h: No such file or directory
> 
> I guess your tree provides that file.

Correct.  You need my tree, or the most recent linux-next tree (which
is better, since we are really interested in how my tree interacts
with all the other pending trees.)

> 
>> irq/manage.c is now (as of b687380) using try_module_get and
>> module_put and so it needs module.h (which it already has).
>>
>> Also convert the irq_alloc_descs variants to macros, since all
>> they really do is is call the __irq_alloc_descs primitive.
>> This avoids including export.h and no debug info is lost.
> 
> macros, I see. THIS_MODULE is quite simple. What about moving this part from
> module.h which is hidden behind ifdef MODULE and make it avaiable as a separate
> headerfile with no children?

Already done.  THIS_MODULE, because of its presence everywhere
in non modular code is also in the export.h file.

Paul.

> 
> Sebastian
