Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751792Ab0IAGAp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 02:00:45 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:44092 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751100Ab0IAGAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 02:00:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=EQ8w6u+AORPwkRy2/gCjJFpPvpelkKAURmhKlWH/WYa18BKXRPxiJdbPv55UripeW/
         ZD2r1zAoh4YIsF0nHJMHTGIIGr8XaaEMiG1HL0a8+Z3norg6pIpy788kz09SoL+0MVms
         4rq8lECxv8X7SSTrjiDeKvtQWNBh1T/Lel17Q=
MIME-Version: 1.0
In-Reply-To: <20100901053055.GA14316@elte.hu>
References: <1283310009-22168-1-git-send-email-dzickus@redhat.com>
	<1283310009-22168-2-git-send-email-dzickus@redhat.com>
	<20100901053055.GA14316@elte.hu>
Date: Wed, 1 Sep 2010 10:00:42 +0400
Message-ID: <AANLkTim_O0CXMCv_qVDKOP72=VC63eoZuvpKWm=mme7k@mail.gmail.com>
Subject: Re: [PATCH 1/3] [lockup detector] sync touch_*_watchdog back to old semantics
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Don Zickus <dzickus@redhat.com>, peterz@infradead.org, fweisbec@gmail.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/1/10, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Don Zickus <dzickus@redhat.com> wrote:
>
>>  void touch_nmi_watchdog(void)
>>  {
>> -	__get_cpu_var(watchdog_nmi_touch) = true;
>> +	if (watchdog_enabled) {
>> +		unsigned cpu;
>> +
>> +		for_each_present_cpu(cpu) {
>> +			if (per_cpu(watchdog_nmi_touch, cpu) != true)
>> +				per_cpu(watchdog_nmi_touch, cpu) = true;
>> +		}
>
> Hm, this is going to be a scalability nightmare with lots of CPUs. Not
> only do we have a nr_cpus loop, but we touch per-cpu areas of _other_
> CPUs - a big scalability nono.
>
> Why do we need to do this? We never needed to touch other CPU's NMI
> lockup accounting data areas - why has this changed? The changelog does
> not explain this.
>
> Thanks,
>
> 	Ingo
>
I believe this came from old nmi watchdog code where it might be
useful when nmi watchdog activated via io-apic. I'm trying to figure
out if we really need it still.
