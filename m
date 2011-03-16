Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756397Ab1CPBDO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 21:03:14 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:37276 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753353Ab1CPBDK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 21:03:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=GM7vn/ErzDH1ai1iX5/UN60IS1wU8jhmDwOwnlYYWs81Qw9TiccaU24NZypZETUIUV
         ifEp8Rl+jMFZ+Lz5LENjTxzyle8oaH2j0M1qqfBTmR11LVS/edztvNpIraNmb501De/z
         lDXXqZRX/LqHSapjA7CBm2a/MMfgEZmdofbL4=
Date: Wed, 16 Mar 2011 02:03:06 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Subject: Re: [RFC PATCH 0/4] perf: Custom contexts
Message-ID: <20110316010304.GB7760@nowhere>
References: <1300130283-10466-1-git-send-email-fweisbec@gmail.com>
 <20110314204341.GC9388@ghostprotocols.net>
 <20110314205100.GG6139@nowhere>
 <20110314210315.GC2388@ghostprotocols.net>
 <20110314212050.GH6139@nowhere>
 <20110314215603.GD2388@ghostprotocols.net>
 <20110314224344.GA11443@nowhere>
 <20110314230211.GG2388@ghostprotocols.net>
 <20110315185812.GB6605@nowhere>
 <20110315192422.GF7011@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110315192422.GF7011@ghostprotocols.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 15, 2011 at 04:24:22PM -0300, Arnaldo Carvalho de Melo wrote:
> Em Tue, Mar 15, 2011 at 07:58:16PM +0100, Frederic Weisbecker escreveu:
> > If we want to count everywhere but when we hold B:
> > 
> > 	-e inst*@(..lock:*acquire(B) && lock:*release(B)..)
> 
> Makes sense but looks confusing at first sight, how to translate that to
> events starter/stoppers?
> 
> its an event: instructions, it starts in what state? Enabled, i.e. the
> first part of the expression has precedence: ..lock:*acquire(B), then,
> after it is disabled, because we acquired B, the second part gets armed,
> i.e. when the release(B) event takes place, the first part gets armed
> again.
> 
> That is why I felt '&&' to be confusing, its not that both are in
> effect, its that one is only armed when the previous was disarmed.
> 
> Perhaps we could find some other operator that was more natural, or just
> agree that && in this context works this way, almost like what we do in
> shell scripting with && and || (the cycle to rearm the first range after
> the last one is disarmed is the part that doesn't matches the shell
> use).

Doh you're right. && would have two meaning.
No we should probably keep  a && b  has a meaning of we are
in the range a AND in the range b. Both at the same time, with
a evaluated first and then b. We also need to ensure than
a && b  doesn't mean the same than  b && a. You're right, perhaps
we need another operator to expression inclusion, or we need to
assume that specific meaning of &&.

For what I wanted to express in the example above, || seem be the
right choice: -e inst*@(..lock:*acquire(B) || lock:*release(B)..)

So || would mean union and && would mean inclusion.

> 
> Also:
> 
>  	-e inst*@(lock:*release(B)..lock:*acquire(B))
> 
> Wouldn't be simpler? Not equivalent tho if one is interested in
> everything that happens till the first time the lock is acquired in some
> specific thread that is started from the tool, etc.

Yep, they are not the same.

>  
> > This covers about everything. Now if in the future we want to support having
> > multiple starters or stoppers for a single target, in order to union custom
> > contexts, we can use the ||.
> > 
> > Like only count when we hold B or when we hold A:
> > 
> > 	-e inst*@(lock:*acquire(A)..lock:*release(A) || lock:*acquire(B)..lock:*release(B))
> 
> > Right?
> 
> Yeah, this one is natural at first sight. As is:
> 
>  	-e (inst*,cycles,dTLB*misses)@(lock:*acquire(A)..lock:*release(A) || lock:*acquire(B)..lock:*release(B))
> 
> I.e. we're expressing an evlist (list of event selectors) to be counted
> when the 'at' expression allows.

Indeed, looks nice.
