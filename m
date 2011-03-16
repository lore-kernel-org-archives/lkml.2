Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753477Ab1CPPrL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 11:47:11 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:49544 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753392Ab1CPPrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 11:47:07 -0400
X-AuditID: b753bd60-a1d49ba0000001d0-12-4d80db77db02
X-AuditID: b753bd60-a1d49ba0000001d0-12-4d80db77db02
Message-ID: <4D80DB75.6060408@hitachi.com>
Date: Thu, 17 Mar 2011 00:47:01 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
        "2nddept-manager@sdl.hitachi.co.jp" 
	<2nddept-manager@sdl.hitachi.co.jp>
Subject: Re: [RFC PATCH 0/4] perf: Custom contexts
References: <1300130283-10466-1-git-send-email-fweisbec@gmail.com> <20110314204341.GC9388@ghostprotocols.net> <20110314205100.GG6139@nowhere> <20110314210315.GC2388@ghostprotocols.net> <20110314212050.GH6139@nowhere> <20110314215603.GD2388@ghostprotocols.net> <20110314224344.GA11443@nowhere> <20110314230211.GG2388@ghostprotocols.net> <20110315185812.GB6605@nowhere> <20110315192422.GF7011@ghostprotocols.net> <20110316010304.GB7760@nowhere>
In-Reply-To: <20110316010304.GB7760@nowhere>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/03/16 10:03), Frederic Weisbecker wrote:
> On Tue, Mar 15, 2011 at 04:24:22PM -0300, Arnaldo Carvalho de Melo wrote:
>> Em Tue, Mar 15, 2011 at 07:58:16PM +0100, Frederic Weisbecker escreveu:
>>> If we want to count everywhere but when we hold B:
>>>
>>> 	-e inst*@(..lock:*acquire(B) && lock:*release(B)..)
>>
>> Makes sense but looks confusing at first sight, how to translate that to
>> events starter/stoppers?
>>
>> its an event: instructions, it starts in what state? Enabled, i.e. the
>> first part of the expression has precedence: ..lock:*acquire(B), then,
>> after it is disabled, because we acquired B, the second part gets armed,
>> i.e. when the release(B) event takes place, the first part gets armed
>> again.
>>
>> That is why I felt '&&' to be confusing, its not that both are in
>> effect, its that one is only armed when the previous was disarmed.
>>
>> Perhaps we could find some other operator that was more natural, or just
>> agree that && in this context works this way, almost like what we do in
>> shell scripting with && and || (the cycle to rearm the first range after
>> the last one is disarmed is the part that doesn't matches the shell
>> use).
> 
> Doh you're right. && would have two meaning.
> No we should probably keep  a && b  has a meaning of we are
> in the range a AND in the range b. Both at the same time, with
> a evaluated first and then b. We also need to ensure than
> a && b  doesn't mean the same than  b && a. You're right, perhaps
> we need another operator to expression inclusion, or we need to
> assume that specific meaning of &&.
> 
> For what I wanted to express in the example above, || seem be the
> right choice: -e inst*@(..lock:*acquire(B) || lock:*release(B)..)
> 
> So || would mean union and && would mean inclusion.

Hmm, would we really need that kind of complex rules?
It seems that we only need union case. If so, I'd suggest
you to use ',' to express that, instead of ||.

-e inst*@(..lock:*acquire(B),lock:*release(B)..)

Thank you,



-- 
Masami HIRAMATSU
2nd Dept. Linux Technology Center
Hitachi, Ltd., Systems Development Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
