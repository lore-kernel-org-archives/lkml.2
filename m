Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753174Ab0KZLf0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 06:35:26 -0500
Received: from smtp-out.google.com ([216.239.44.51]:59466 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803Ab0KZLfY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 06:35:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=KnU/cgL0ZrTwux9vSO9QnLF96zDK7vjjJZ3CkRTprdVZqgA0ik3Sn2g5BF+8ky2efb
         FP4TY0I6ft5BPVGvJ50w==
MIME-Version: 1.0
In-Reply-To: <AANLkTimOY=58aW0OsWhTRjc5tgxNApKpReNh0hwK7SJJ@mail.gmail.com>
References: <20101123224601.766827604@openvz.org>
	<20101123224800.294919307@openvz.org>
	<AANLkTikjfM=8xa8smgT6D_WTYC_S-JZ69iiqu8gD21sK@mail.gmail.com>
	<AANLkTin1Q0eo4mFbSCeO4RNrK8Men0Q3r_x9_dCse11Q@mail.gmail.com>
	<AANLkTimOY=58aW0OsWhTRjc5tgxNApKpReNh0hwK7SJJ@mail.gmail.com>
Date: Fri, 26 Nov 2010 12:35:22 +0100
Message-ID: <AANLkTikWB0TbCO1JLCtk03HAV0qEj63fPZ+rzViAZJS4@mail.gmail.com>
Subject: Re: [rfc 1/3] perf, x86: P4 PMU - describe config format
From: Stephane Eranian <eranian@google.com>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        ming.m.lin@intel.com, peterz@infradead.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 26, 2010 at 12:32 PM, Cyrill Gorcunov <gorcunov@openvz.org> wrote:
> On Fri, Nov 26, 2010 at 2:14 PM, Cyrill Gorcunov <gorcunov@openvz.org> wrote:
>> Stephane, this is a misprint, I'll update this comments on format
>> (giod catch btw!). in real low 32 bits are considered as cccr in ht
>> mode. wait a bit, i'll post update.
>>
>> On 11/26/10, Stephane Eranian <eranian@google.com> wrote:
> ...
>>>> + *    Low 32 bits
>>>> + *    -----------
>>>> + *      0-6: P4_PEBS_METRIC enum
>>>> + *     7-11:                    reserved
>>>> + *       12: Active thread
>>>
>>> I don't understand bit 12. In the actual register, it
>>> corresponds to the enable bit. Seems you're overriding
>>> its usage. Do I interpret this as saying: 0 = enable when
>>> running on thread0, 1=monitoring when running on thread1?
>>> And if I don't care?
> ...
> I believe it simply escaped quilt refresh somehow. Here is the 'refreshed'
> copy (note the low bits 12-19 updated here).
> ---
> perf, x86: P4 PMU - describe config format v2
>
> Add description of .config in a sake of RAW events.
> At least this should bring some light to those who
> will be reading this code.
>
> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> CC: Lin Ming <ming.m.lin@intel.com>
> CC: Stephane Eranian <eranian@google.com>
> CC: Peter Zijlstra <peterz@infradead.org>
> ---
>  arch/x86/include/asm/perf_event_p4.h |   63 ++++++++++++++++++++++++++++++-----
>  1 file changed, 55 insertions(+), 8 deletions(-)
>
> Index: linux-2.6.tip/arch/x86/include/asm/perf_event_p4.h
> ===================================================================
> --- linux-2.6.tip.orig/arch/x86/include/asm/perf_event_p4.h
> +++ linux-2.6.tip/arch/x86/include/asm/perf_event_p4.h
> @@ -744,14 +744,6 @@ enum P4_ESCR_EMASKS {
>  };
>
>  /*
> - * P4 PEBS specifics (Replay Event only)
> - *
> - * Format (bits):
> - *   0-6: metric from P4_PEBS_METRIC enum
> - *    7 : reserved
> - *    8 : reserved
> - * 9-11 : reserved
> - *
>  * Note we have UOP and PEBS bits reserved for now
>  * just in case if we will need them once
>  */
> @@ -788,5 +780,60 @@ enum P4_PEBS_METRIC {
>        P4_PEBS_METRIC__max
>  };
>
> +/*
> + * Notes on internal configuration of ESCR+CCCR tuples
> + *
> + * Since P4 has quite the different architecture of
> + * performance registers in compare with "architectural"
> + * once and we have on 64 bits to keep configuration
> + * of performance event, the following trick is used.
> + *
> + * 1) Since both ESCR and CCCR registers have only low
> + *    32 bits valuable, we pack them into a single 64 bit
> + *    configuration. Low 32 bits of such config correspond
> + *    to low 32 bits of CCCR register and high 32 bits
> + *    correspond to low 32 bits of ESCR register.
> + *
> + * 2) The meaning of every bit of such config field can
> + *    be found in Intel SDM but it should be noted that
> + *    we "borrow" some reserved bits for own usage and
> + *    clean them or set to a proper value when we do
> + *    a real write to hardware registers.
> + *
> + * 3) The format of bits of config is the following
> + *    and should be either 0 or set to some predefined
> + *    values:
> + *
> + *    Low 32 bits
> + *    -----------
> + *      0-6: P4_PEBS_METRIC enum
> + *     7-11:                    reserved
> + *       12:                    reserved (Enable)
> + *    13-15:                    reserved (ESCR select)
> + *    16-17: Active Thread

HW has the active thread bits reserved to 0x3.
what about you? If not, then explain what they
mean.
