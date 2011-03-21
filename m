Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069Ab1CUSEM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 14:04:12 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:55416 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753909Ab1CUSEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 14:04:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=AAM6kenLwjRkkQWBfIGH2Hz+FY0V3K9ppOaXTOA2cbaLz3fhFN7j9YazqjoUoZmPeL
         YowApUjP+igJURAALJf6Vofx5fWd7lLbLy2fbHeWmzAS14X/c9VMZXmgw2znjH31MO7T
         FE03XvxvY0re8ntiAalIqgQlBO9prl6ncviJM=
Message-ID: <4D879238.1010502@gmail.com>
Date: Mon, 21 Mar 2011 21:00:24 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: Don Zickus <dzickus@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, Jack Steiner <steiner@sgi.com>,
        tglx@linutronix.de, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jason Wessel <jason.wessel@windriver.com>
Subject: Re: [PATCH] x86, UV: Fix NMI handler for UV platforms
References: <20110321160135.GA31562@sgi.com> <20110321161425.GC23614@elte.hu> <4D877C4B.9090602@gmail.com> <20110321175110.GL1239@redhat.com>
In-Reply-To: <20110321175110.GL1239@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21/2011 08:51 PM, Don Zickus wrote:
> On Mon, Mar 21, 2011 at 07:26:51PM +0300, Cyrill Gorcunov wrote:
>> On 03/21/2011 07:14 PM, Ingo Molnar wrote:
>>>
>>> * Jack Steiner <steiner@sgi.com> wrote:
>>>
>>>> This fixes a problem seen on UV systems handling NMIs from the node controller.
>>>> The original code used the DIE notifier as the hook to get to the UV NMI
>>>> handler. This does not work if performance counters are active - the hw_perf
>>>> code consumes the NMI and the UV handler is not called.
> 
> Well that is a bug in the perf code.  We have been dealing with 'perf'
> swallowing NMIs for a couple of releases now.  I think we got rid of most
> of the cases (p4 and acme's core2 quad are the only cases I know that are
> still an issue).

p4 has the issue if only smp-kgdb case happens as far as i know, which in turn
'cause of IPI called inside nmi handler and other cpus are waiting for such nmi
arrival and if perf is enabled same time we might end up that ipi nmi sent by kgdb
will be eaten by perf subsystem (if my analysis is correct, Jason?). So for this
case we might need pre-regular nmi notifier call chain I guess or platform ops
as Jack proposed but still all become incredibly messy for me :(

> 
> I would much prefer to investigate the reason why this is happening
> because the perf nmi handler is supposed to check the global interrupt bit
> to determine if the perf counters caused the nmi or not otherwise fall
> through to other handler like SGI's nmi button in this case.
> 
> My first impression is the skip nmi logic in the perf handler is probably
> accidentally thinking the SGI external nmi is the perf's 'extra' nmi it is
> supposed to skip and thus swallows it.  At least that is the impression I
> get from the RedHat bugzilla which says SGI is running 'perf top', getting
> a hang, then pressing their nmi button to see the stack traces.
> 
> Jack,
> 
> I worked through a number of these issues upstream and I already talked to
> George and Russ over here at RedHat about working through the issue over
> here with them.  They can help me get access to your box to help debug.
> 
> Cheers,
> Don


-- 
    Cyrill
