Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757045Ab1ERKpW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 06:45:22 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:44820 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756958Ab1ERKpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 06:45:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=YIx4Vjl3+7521WxtPokh+KV90mZRefnRWZoVsSIC08BRbD9N1HG395JTjKpegGdBry
         Bt/0T5B2slmiwe6/yT2McvquMktDFLPuihQPL5F3NhCKpuIc76IzjLiXHTm0SYvF8zyQ
         OHXMYG5WniA0yv+UcegZltLchR1DOSBfAxE0o=
MIME-Version: 1.0
In-Reply-To: <20110518095539.GU20624@htj.dyndns.org>
References: <1305569849-10448-1-git-send-email-tj@kernel.org>
 <1305569849-10448-4-git-send-email-tj@kernel.org> <201105180240.56754.vda.linux@googlemail.com>
 <20110518095539.GU20624@htj.dyndns.org>
From: Denys Vlasenko <vda.linux@googlemail.com>
Date: Wed, 18 May 2011 12:44:58 +0200
Message-ID: <BANLkTi=Yq6BRG7CFfXaKNP1rTb-4hhftmg@mail.gmail.com>
Subject: Re: [PATCH 03/10] ptrace: implement PTRACE_SEIZE
To: Tejun Heo <tj@kernel.org>
Cc: oleg@redhat.com, jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, indan@nul.nu,
        bdonlan@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 18, 2011 at 11:55 AM, Tejun Heo <tj@kernel.org> wrote:
> Hello, Denys.
>
> On Wed, May 18, 2011 at 02:40:56AM +0200, Denys Vlasenko wrote:
>> This makes PTRACE_EVENT_STOP similar to other PTRACE_EVENTs.
>> The only difference is that it can't be set by PTRACE_SETOPTIONS
>> as other events do, but activated implicitly by PTRACE_SEIZE.
>
> Also by PTRACE_INTERRUPT and group stop.

"Activating" meaning "enabling", not "causing". Only PTRACE_SEIZE
enables PTRACE_EVENT_STOP.

>> This made me thinking.
>>
>> How about making API even more similar to existing one?
>>
>> Create PTRACE_O_TRACESTOP, make it settable by PTRACE_SETOPTIONS too.
>>
>> Make PTRACE_SEIZE take the mask of PTRACE_O_xyz flags
>> as data argument.
>> If PTRACE_O_TRACESTOP is set, it works as you described above.
>> If PTRACE_O_TRACESTOP is not set, then it works as good old PTRACE_ATTACH.
>> In both cases, immediately at attach it sets opts a-la PTRACE_SETOPTIONS.
>>
>> We can even avoid introducing PTRACE_SEIZE at all, because
>> currently PTRACE_ATTACH ignores its data argument.
>>
>> I know, I know, "this changes API", but did we ever promise
>> that PTRACE_ATTACH with nonzero data arg is a valid usage?
>> Also, I perused first 10 pages of google code search results
>> and I see that everybody passes 0 or NULL.
>
> But as SEIZE introduces behavior differences throughout ptrace
> operation,
>
> Similar issue with PTRACE_O_TRACESTOP.  It won't only enable TRACESTOP
> it will change other behaviors too

All these differences revolve around making handling of stops
and SIGCONT better. It seems fitting to the option name.

PTRACE_SEIZE sets a flag somewhere "please convert
group-stops into PTRACE_EVENT_STOPs".

But, we *already have* ptrace op which performs this action
of modifying (or adding) stops - it's PTRACE_SETOPTIONS.
With PTRACE_O_TRACESYSGOOD it modifies syscall-stops.
With PTRACE_O_TRACEEXEC - post-execve stop.
With PTRACE_O_TRACEFORK it adds a stop after fork.

Since we have this API, why not use it for the very similar
concept of modifying group-stops too?

> I think it's actually beneficial to use a distinctively new
> request.  It's not like it costs anything or we're short on request
> number space.

"Entities must not be multiplied beyond necessity"?

-- 
vda
