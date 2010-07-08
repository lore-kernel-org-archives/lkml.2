Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756174Ab0GHPAN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 11:00:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35584 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754146Ab0GHPAK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 11:00:10 -0400
Message-ID: <4C35E7E6.1080105@zytor.com>
Date: Thu, 08 Jul 2010 07:59:50 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Hans Rosenfeld <hans.rosenfeld@amd.com>
CC: "mingo@redhat.com" <mingo@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Subject: Re: [tip:x86/cpu] x86, cpu: AMD errata checking framework
References: <1276681733-10872-1-git-send-email-hans.rosenfeld@amd.com> <tip-48327dd572aaf9924c3dc4f8ad3189d506b11390@git.kernel.org> <4C34B5CE.1040407@zytor.com> <20100708141845.GI11824@escobedo.osrc.amd.com>
In-Reply-To: <20100708141845.GI11824@escobedo.osrc.amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/08/2010 07:18 AM, Hans Rosenfeld wrote:
> Hi,
> 
> On Wed, Jul 07, 2010 at 01:13:50PM -0400, H. Peter Anvin wrote:
>> This code has been excluded since it was added, because it doesn't
>> compile if CONFIG_CPU_SUP_AMD is not defined.  I took a quick look over
>> it to see if it could quickly be fixed (which it can -- just don't
>> exclude the macro definitions and define a dummy version of
>> cpu_has_amd_erratum() which simply returns false), however, on looking
>> closer at the code I have to say it really is pretty broken, and as such
>> I would rather you refreshed the patch.
> 
> Great that finally someone cared to take a closer look at it, after
> only 4 weeks :)
> 
> I have looked into the issue and I think the main problem is not in
> those patches, although either of the two patches could have fixed it
> one way or another. Adding a dummy cpu_has_amd_erratum() would be one
> way to do it, but I don't think it would be right.
> 

It works well, and gcc will then remove the associated code.

>> However, a *much* bigger issue is the fact that
>> this will manifest a potentially very large memory structure into code
>> at every calling point, but it is not at all obvious to the programmer
>> that that will happen.
> 
> I don't really see a problem here, for basically two reasons.
> 
> First, it is very, very, very unlikely that there will ever be a
> very large argument list for an erratum. Errata that never get fixed
> in a family only have one model-stepping range covering the whole
> family, while errata that get fixed eventually apply only to a couple
> few model-stepping ranges. While working on this I spent a lot of time
> studying the various AMD errata that could possibly make use of this
> framework, and except for one all could be handled by three ranges or
> less. The exception was a family 0xf erratum, which needed about 8
> ranges because of the strange way the family 0xf models/steppings were
> assigned.
> 
> Second, the cpu_has_amd_erratum() function is supposed to be called
> only once for each erratum by initialization code. You should never
> ever call it repeatedly in loops or interrupt handlers. If you need to
> check for an erratum in such a place, cache the result in a local
> variable. That would even be advisable without specifying the erratum
> in the argument list.

There is absolutely no reason to believe that that is actually the
case... and even if it was, it could get changed by gcc behind the
programmer's back.  This assertion is insane.

> Really, I don't see what this change would gain us, but it would
> certainly make it harder to maintain.

Centralization and abstraction.

>> Note that I haven't included a pointer to the cpuinfo_x86 structure. The
>> reason why is that although you pass a pointer to an arbitrary
>> cpuinfo_x86 structure, you also do rdmsrl() on the local processor and
>> expect them to work.  This isn't really ideal; it's better, then, to
>> make it specific to the currently executing processor and just use
>> current_cpu_data.
> 
> Yes, that makes sense. I will rework that part.

Perhaps I wasn't making myself clear enough.  If you submit the same
style of code again, I will veto it.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

