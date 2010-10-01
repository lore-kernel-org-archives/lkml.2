Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754000Ab0JARt4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 13:49:56 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:41674 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752841Ab0JARtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 13:49:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=m94lI0diiN0EMwFzu7lPlbYS2XrNHAqqNjKeAeosnk8l9KHZaZrSPNVQP50BiS3RkU
         f3X7yt6ioPrjmemao7JQdWN9GVX23lQHy6JC/EQkjt1wXUXDZWj1Y+Bm+87dHtxRveGF
         c0K3eVHX7sHkjXOx+yc+SW08fd5bTT8FEM100=
MIME-Version: 1.0
In-Reply-To: <1285938596-2186-1-git-send-email-glommer@redhat.com>
References: <1285938596-2186-1-git-send-email-glommer@redhat.com>
Date: Fri, 1 Oct 2010 10:49:53 -0700
X-Google-Sender-Auth: Y3EeS0B2GkKPLEvATAjuWdoIU_c
Message-ID: <AANLkTimdukAnwtPooFJYTxtzoT+Scy9JwWoxkkj3g0zO@mail.gmail.com>
Subject: Re: [PATCH] use a stable clock reference in vdso vgetns
From: john stultz <johnstul@us.ibm.com>
To: Glauber Costa <glommer@redhat.com>
Cc: linux-kernel@vger.kernel.org, avi@redhat.com,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 1, 2010 at 6:09 AM, Glauber Costa <glommer@redhat.com> wrote:
> When using vdso services for clock_gettime, we test for the ability
> of a fine-grained measurement through the existance of a vread() function.
>
> However, from the time we test it, to the time we use it, vread() reference
> may not be valid anymore. It happens, for example, when we change the current
> clocksource from one that provides vread (say tsc) to one that lacks it
> (say acpi_pm), in the middle of clock_gettime routine.
>
> seqlock does not really protect us, since readers here won't stop the writers
> to change references. The proposed solution is to grab a copy of the clock
> structure early, and use it as a stable reference onwards.

Ah. Good find! The fix looks reasonable to me. However, its likely the
similar code in arch/x86/kernel/vsyscall_64.c will need a similar fix.

Awhile back there was some motivation to merge the two vdso/vsyscall
implementations to avoid the duplication, but my memory is failing on
why that didn't happen. I feel like it had to do with complication
with the way the two implementations are mapped out to userland. Even
so, it seems a shared forced inline method would resolve the issue, so
maybe it just fell off the todo list?

thanks
-john
