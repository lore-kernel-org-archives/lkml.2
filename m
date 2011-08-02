Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754595Ab1HBQdg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 12:33:36 -0400
Received: from smtp-out.google.com ([216.239.44.51]:5821 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753699Ab1HBQdb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 12:33:31 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:date:
	message-id:subject:from:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=k73Br5H0bG2YQ5fVKtT0GCKpLfGQcb60EJcD/B8y6nidbzrEz8uZbQbLYdDvQbICL
	ZXMp+HbX373IZ4KYSQTzQ==
MIME-Version: 1.0
In-Reply-To: <20110802080315.GA9473@tiehlicka.suse.cz>
References: <20110801094611.AAF738A95F@mx2.suse.de>
	<CABeCy1Y6ZO3igfRhdDQTSS0i2w9k2WTtJYwWUxuRT56UG9Zd8Q@mail.gmail.com>
	<20110802080315.GA9473@tiehlicka.suse.cz>
Date: Tue, 2 Aug 2011 09:33:28 -0700
Message-ID: <CABeCy1aCA_iGOYw65UK3Nr2W7u5zEOK24N-n0iCY=aQZNVcUEQ@mail.gmail.com>
Subject: Re: [PATCH resend] x86, PAT: honor CONFIG_STRICT_DEVMEM if pat is disabled
From: Venki Pallipadi <venki@google.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 2, 2011 at 1:03 AM, Michal Hocko <mhocko@suse.cz> wrote:
> On Mon 01-08-11 16:33:18, Venki Pallipadi wrote:
>> On Fri, Jul 22, 2011 at 2:01 AM, Michal Hocko <mhocko@suse.cz> wrote:
>> >
>> > since 0124cecf (x86, PAT: disable /dev/mem mmap RAM with PAT) we are
>> > disabling access to the system RAM as if STRICT_DEVMEM was enabled by
>> > default. If we, however, disable pat by nopat kernel parameter we can
>> > access that memory without considering CONFIG_STRICT_DEVMEM.
>>
>> Looking at the code, I don't think this problem exists. Code in pat.c
>> disables /dev/mem mmap only when !CONFIG_STRICT_DEVMEM.
>
> Ahh yes, you are right. I got confused by having two separate
> range_is_allowed functions and didn't realize which one is called from
> which context.
>        mmap_mem
>          -> range_is_allowed [drivers/char/mem.c]
>               -EPERM
>          -> phys_mem_access_prot_allowed
>               -> range_is_allowed [arch/x86/mm/pat.c]
>
> So we really get stopped at the first check and do not get to the later
> one.
>
> While we are at it. {read,write}_mem checks only range_is_allowed (mem.c
> version) and it doesn't call phys_mem_access_prot_allowed so we do not
> consider PAT. {read,write}_kmem doesn't check the range at all.
> Is this correct?
> Why do we care _only_ about mmap?
>

Yes. The problem with PAT and /dev/mem mmap is with untracked mmaps in
user address space. Once mapped the mappings can stay in user space
and if there is a page attribute change for that physical address
later kernel doesn't have handle on all such user space mappings that
may exist.
Read/Write on the other hand use direct mappings and will not cause
this problem. I have generally been suggesting tools that want to
access /dev/mem and are unable to mmap it due to PAT to use read/write
instead. /dev/mem on 32 bit has some problems of its own and the
recent patchset on mailing list fixes most of the issues there.

Thanks,
Venki
