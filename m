Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751594Ab2KVS0z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 13:26:55 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:39285 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750Ab2KVS0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:26:49 -0500
MIME-Version: 1.0
In-Reply-To: <1353541455.20173.10.camel@jlt4.sipsolutions.net>
References: <1353541455.20173.10.camel@jlt4.sipsolutions.net>
Date: Thu, 22 Nov 2012 20:40:31 +0900
Message-ID: <CAC5umyibe0tb+HLxx3dbT7gF_nVAAHso1Y0Qb4Q_+y0KNrnvFg@mail.gmail.com>
Subject: Re: [POC] recoverable fault injection
From: Akinobu Mita <akinobu.mita@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/11/22 Johannes Berg <johannes@sipsolutions.net>:
> This idea has been floating around in my head for a long time now ...
>
> I was thinking: what if we could do fault injection during regular
> testing, at least on those code paths that are not supposed to have side
> effects when they fail? Now obviously this isn't all code paths, and
> many probably erroneously *do* have side effects even if they're not
> supposed to, but it does apply to a number of code paths.

It sounds interesting. I have never thought of this idea.

> So I decided to play with this, and the result it the patch below. It
> adds a new knob "recoverable-only" to the slab and page_alloc fault
> attributes. If enabled, then a single fault can be injected if the task
> executing it is in a "recoverable section", this is implemented by some
> new fields in struct task_struct and the (very ugly!) macro
> FAULT_INJECT_CALL_RECOVERABLE_FUNCTION.

I suggest introducing a pair of function like:

void fault_recoverable_enable(unsigned long fault_ids);
void fault_recoverable_disable();

fault_recoverable_enable() sets current task's recoverable state to the
value specified with the argument.  fault_recoverable_disable() resets
the recoverable state.

I think this can be more readable than FAULT_INJECT_CALL_RECOVERABLE_FUNCTION
macro.  In case of nl80211_remain_on_channel(), you can just put
them in exit and entrance:

fault_recoverable_enable(FAULT_ATTR_SLAB | FAULT_ATTR_PAGE_ALLOC);
...
fault_recoverable_disable();

return err;
