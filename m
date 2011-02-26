Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751157Ab1BZOHb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Feb 2011 09:07:31 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:51156 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746Ab1BZOHa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Feb 2011 09:07:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=mui3YMvSwThRmv5/Yilq34FImSTsWKNlC4lsZkuh5pOaXZhlC1VEeaXruFGPU4pkMG
         kFggxwpyKT3k/+Fudoapn2t4kcKHsHs5oufnlH9wWYZe+KNavAdUIWDEy+a5RvVQKQhW
         60jm9e/w7wD12auUT1Xzx8WbkZ+knN+kPyIOQ=
MIME-Version: 1.0
In-Reply-To: <4D68F346.1000500@gmail.com>
References: <1294348732-15030-1-git-send-email-dzickus@redhat.com>
	<1294348732-15030-6-git-send-email-dzickus@redhat.com>
	<alpine.LFD.2.00.1102230227010.31425@eddie.linux-mips.org>
	<4D68B397.6040809@gmail.com>
	<AANLkTi==WbHfLrWAjFCZU9VAhfyf9MLnvKza=i9PuO7r@mail.gmail.com>
	<4D68F346.1000500@gmail.com>
Date: Sat, 26 Feb 2011 22:07:29 +0800
Message-ID: <AANLkTin3nY6++whgOGTC=HLN_oK0J5chsx5uZ_OG6h8G@mail.gmail.com>
Subject: Re: [PATCH 5/6] x86, NMI: Allow NMI reason io port (0x61) to be
 processed on any CPU
From: huang ying <huang.ying.caritas@gmail.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: "Maciej W. Rozycki" <macro@linux-mips.org>,
        Don Zickus <dzickus@redhat.com>, x86@kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>, ying.huang@intel.com,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 26, 2011 at 8:34 PM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
[snip]
>> Why?  Without LVT reconfig, system with this patch can not work
>> properly?
>
>  I guess we have a few nits here -- first an important comment were
> removed which doesn't reflect what happens on hw level for real. At
> least we should put it back just to not confuse people who read this
> code, something like
>
>        /*
>         * FIXME: Only BSP can see external NMI for now and hot-unplug
>         * for BSP is not yet implemented
>         */
>        WARN_ON_ONCE(smp_processor_id());
>
>  The reason for WARN_ON_ONCE here is that -- imagine the situation when
> perf-nmi happens on one cpu with external nmi on BSP and for some reason
> (say code on upper level is screwed\bogus or anything else) nmi-notifier
> didn't handled it properly as result we might have a report like "SERR for
> reason xx on CPU 1" while this cpu didn't see this signal at all. And then
> due to locking ordering BSP will see unknown nmi while in real those nmi
> belongs
> him and it was CPU 1 who observed erronious NMI from upper level. Note this
> is theoretical scenario I never saw anything like this ;)

Yes.  That is possible, at least in theory.  But similar issue is
possible for original code too.  For example, On CPU 0,

1. perf NMI 1 triggered
2. NMI handler enter
3. perf NMI 2 triggered (1 NMI is pending)
4. perf NMI handler handled 2 events
5. NMI handler return
6. NMI handler enter (because of pending NMI)
7. external NMI triggered (another NMI is pending)
8. external NMI handler handled SERR
9. NMI handler return
10. NMI handler enter (because of pending NMI)
11. unknown NMI triggered

If my analysis is correct, this kind of issue can not be resolved even
if we revert to original code.

Best Regards,
Huang Ying
