Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752444Ab2GaKH5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 06:07:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56039 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751789Ab2GaKHY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 06:07:24 -0400
Message-ID: <5017AE48.5090108@redhat.com>
Date: Tue, 31 Jul 2012 13:07:04 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Stefan Bader <stefan.bader@canonical.com>
CC: Cong Wang <xiyou.wangcong@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yinghai@kernel.org>,
        Tejun Heo <tj@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: x86/mm: Limit 2/4M size calculation to x86_32
References: <5000259D.9020303@canonical.com> <CAM_iQpVPzB69R1_4E_J5Yw=d1TncqHe0+dWEwOufQniNcpBVtg@mail.gmail.com> <500FCDF3.7080808@redhat.com> <500FD4FA.7020904@canonical.com> <500FE74C.4040907@redhat.com> <500FF3A1.6080809@canonical.com> <500FF767.8020507@redhat.com> <5017A9EB.1030903@canonical.com>
In-Reply-To: <5017A9EB.1030903@canonical.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31/2012 12:48 PM, Stefan Bader wrote:
> On 25.07.2012 15:40, Avi Kivity wrote:
>> On 07/25/2012 04:24 PM, Stefan Bader wrote:
>>>>> ...
>>>>> ifdef CONFIG_X86_32
>>>>>         /*
>>>>>          * Don't use a large page for the first 2/4MB of memory
>>>>>          * because there are often fixed size MTRRs in there
>>>>>          * and overlapping MTRRs into large pages can cause
>>>>>          * slowdowns.
>>>>>          */
>>>>>
>>>>
>>>> That's equally true for X86_64.
>>>>
>>>> Best would be to merge the MTRRs into PAT, but that might not work for SMM.
>>>>
>>>>
>>> Ok, true. Not sure why this was restricted to 32bit when reconsidering. Except
>>> if in 64bit it was assumed (or asserted) that the regions are aligned to 2M...
>>> But maybe this can be answered by someone knowing the details. I would not mind
>>> either way (have the first range with 4K pages in all cases or fixing the
>>> additional PTE allocation). Just as it is now it is inconsistent.
>> 
>> Sometimes CONFIG_X86_32 is used as an alias for "machines so old they
>> don't support x86_64".  As a 32-bit kernel can be run on a machine that
>> does support x86_64, it should be replaced by a runtime test for
>> X86_FEATURE_LM, until a more accurate test can be found.
>> 
> 
> So basically the first range being 4k exist because MTRRs might define ranges
> there and those are always aligned to 4k but not necessarily to the bigger pages
> used. Reading through the Intel and AMD docs indicates various levels of badness
> when this is not the case. Though afaict MTRRs are not tied to long mode capable
> CPUs. For example Atom is 32bit only (the earlier ones at least) and uses MTRRs.
> So testing for LM would miss those.
> Would it not be better to unconditionally have the first 2/4M as 4k pages? At
> least as long as there is no check for the alignment of the MTRR ranges. Or
> thinking of it, the runtime test should look for X86_FEATURE_MTRR, shouldn't it?

MTRRs are indeed far older than x86_64; it's almost pointless to test
for them, since practically all processors have them.

The fact that the check is only done on i386 and not on x86_64 may come
from one of

 - an oversight
 - by the time x86_64 processors came along, the problem with
conflicting sizes was resolved
 - the whole thing is bogus

Copying hpa who may be in a position to find out which.

-- 
error compiling committee.c: too many arguments to function


