Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757672Ab1FJVAo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 17:00:44 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:65457 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752259Ab1FJVAn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 17:00:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=mtFIttkd+Nt6XwSVMBgvXz1Oz3AGZ7h3aphkt/08KpjNMYKFX3oI0AidzYo5q6RbB2
         SZ7Irze/wBa2gMUd2Ex6TCbcpkgSa364zTXKnc6f/YyQSTuu0n6XfyciuisP0uSKplq2
         YrkLY2YqNM2/WZcMwsSRADcKB++wUccBwTiQM=
MIME-Version: 1.0
In-Reply-To: <4DF1D078.7070207@jp.fujitsu.com>
References: <4df13d6327307cf53@agluck-desktop.sc.intel.com>
	<4DF1D078.7070207@jp.fujitsu.com>
Date: Fri, 10 Jun 2011 14:00:42 -0700
X-Google-Sender-Auth: ld-Pijn9wdgp2lqyo5b10_xPREU
Message-ID: <BANLkTim2CoU4aQZipXWn9gW5TexCrtoEJA@mail.gmail.com>
Subject: Re: [PATCH 10/10] MCE: Add Action-Required support
From: Tony Luck <tony.luck@intel.com>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Borislav Petkov <bp@amd64.org>,
        linux-kernel@vger.kernel.org, "Huang, Ying" <ying.huang@intel.com>,
        Avi Kivity <avi@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/6/10 Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>:
>> +static int kernel_ar_recoverable(struct mce *m, int tolerant)
>> +{
>> +     if (tolerant >= 2)
>> +             return MCE_AR_SEVERITY;
>> +     if (!(m->mcgstatus & MCG_STATUS_EIPV) || !m->ip)
>> +             return MCE_PANIC_SEVERITY;
>> +     if (search_exception_tables(m->ip))
>> +             return MCE_AR_SEVERITY;
>> +     return MCE_PANIC_SEVERITY;
>> +}
>> +
>
> You said "Just handle errors in user mode for now." but ...?

Oops. I dropped the kernel handling bits from mce.c, but forget to
clean them out of mce-severity.c

Will fix.

>> +     if (!mce_usable_address(m))
>> +             mce_panic("No address for Action-Required Machine Check",
>> +                       m, msg);
>> +     if (!(m->mcgstatus & MCG_STATUS_EIPV))
>> +             mce_panic("No EIPV for Action-Required Machine Check",
>> +                       m, msg);
>
> When can this happen?

Probably never (or only if there was a chip bug. AR errors should
provide addresses
(otherwise there is no way to perform any useful "action").

> Why not create new severity {PANIC, "Action Required: but No EIPV", ...}
> in severity table?

Very good idea.

>> +static void ar_fallback(struct task_struct *me, unsigned long pfn)
>> +{
>> +     if (signal_pending(me) && sigismember(&me->pending.signal, SIGBUS))
>> +             return;
>
> Is it safe for _AR if SIGBUS is pending but blocked?
> I think force_sig() is reasonable for such situation.

Agreed - it is not safe if the signal is blocked.  force_sig() sounds better.

>> +     if (worst == MCE_AR_SEVERITY) {
>> +             mce_action_required(&m, msg, regs);
>
> Comprehensible name would be appreciated, e.g.:
>                mce_request_dpc_for_action_required(pfn);

I'm always in the mood for better names ... but I'm not sure what
the "dpc" in this name is trying to tell me.

> And if we cannot request context for recovery, it is better to suppress
> trailing attempts, e.g. before mce_end():
>
>        if (!no_way_out && severity == MCE_AR_SEVERITY) {
>                err = mce_request_dpc_for_action_required(pfn);
>                if (err) {
>                        atomic_inc(&global_nwo);
>                        severity = MCE_PANIC_SEVERITY;  /* escalated */
>                }
>        }

Agreed - if we can't perform the recovery action, we should escalate
the severity.

-Tony
