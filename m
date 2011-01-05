Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751314Ab1AEAtM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 19:49:12 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57329 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116Ab1AEAtK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 19:49:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=IWn4YTv1d9SsfwMxN922TO4Fmug/GnunXF8qenD4bj80rdYcJeKHNa4sWG2Gnejo4N
         85lJ7aVuQu3EV9nqT6u/wQ02vGrGwXmui7gwIm7oEI93GWKwn/wfUat04iSzom/DzLy7
         BHZIdfavAKWTt10iTVUmyuSoYP+8V2ZIJJ8RQ=
Date: Wed, 5 Jan 2011 01:49:06 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Zhaolei <zhaolei@cn.fujitsu.com>,
        "nhorman@tuxdriver.com" <nhorman@tuxdriver.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC patch 2/5] trace event skb fix unassigned field
Message-ID: <20110105004903.GF2911@nowhere>
References: <E1PaGZY-0001EI-BD@smtp.tuxdriver.com>
 <20110104235418.GD2911@nowhere>
 <20110105004038.GB9737@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110105004038.GB9737@Krystal>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 04, 2011 at 07:40:38PM -0500, Mathieu Desnoyers wrote:
> * Frederic Weisbecker (fweisbec@gmail.com) wrote:
> > On Tue, Jan 04, 2011 at 06:46:06PM -0500, nhorman@tuxdriver.com wrote:
> > > Acked- by: Neil Horman <nhorman@tuxdriver.com>
> > > 
> > > 
> > > Sent from my Verizon Wireless Phone
> > > 
> > > ----- Reply message -----
> > > From: "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>
> > > Date: Tue, Jan 4, 2011 6:16 pm
> > > Subject: [RFC patch 2/5] trace event skb fix unassigned field
> > > To: "LKML" <linux-kernel@vger.kernel.org>
> > > Cc: "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>, "Steven Rostedt" <rostedt@goodmis.org>, "Frederic Weisbecker" <fweisbec@gmail.com>, "Ingo Molnar" <mingo@elte.hu>, "Neil Horman" <nhorman@tuxdriver.com>, "Thomas Gleixner" <tglx@linutronix.de>
> > > 
> > > 
> > > The field "protocol" in event kfree_skb is left unassigned if skb is NULL,
> > > leaving its trace output as garbage. Assign the value to 0 when skb is NULL
> > > instead.
> > 
> > Hm, if the skb is already null, we probably shouldn't send any trace.
> > 
> > What about using TP_CONDITION() ?
> 
> Hrm, let's see. It's been introduced by commit
> 5cb3d1d9d34ac04bcaa2034139345b2a5fea54c1
> by Zhaolei.
> 
> Event at the time of that commit, the only caller looked like:
> 
> void kfree_skb(struct sk_buff *skb)
> {
>         if (unlikely(!skb))
>                 return;
>         if (likely(atomic_read(&skb->users) == 1))
>                 smp_rmb();
>         else if (likely(!atomic_dec_and_test(&skb->users)))
>                 return;
>         trace_kfree_skb(skb, __builtin_return_address(0));
>         __kfree_skb(skb);
> }
> EXPORT_SYMBOL(kfree_skb);
> 
> So it already checks for a null pointer before calling the tracepoint. This
> leads me to wonder why why this check was added in the first place ?

Likely for no strong reasons :)

So I guess we can remove the check from the tracepoint?
