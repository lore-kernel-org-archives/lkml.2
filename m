Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932621Ab2CEO7S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 09:59:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1029 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932150Ab2CEO7R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 09:59:17 -0500
Message-ID: <4F54D4AF.9060802@redhat.com>
Date: Mon, 05 Mar 2012 11:58:55 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Tony Luck <tony.luck@intel.com>, Ingo Molnar <mingo@elte.hu>,
        EDAC devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] EDAC: Convert AMD EDAC pieces to use RAS printk buffer
References: <1330698314-9863-1-git-send-email-bp@amd64.org> <1330698314-9863-5-git-send-email-bp@amd64.org> <4F50DECB.8030200@redhat.com> <20120305110441.GC1070@aftab> <4F54A6FF.50502@redhat.com> <20120305124411.GD1070@aftab> <4F54C133.6040709@redhat.com> <20120305141349.GF1070@aftab>
In-Reply-To: <20120305141349.GF1070@aftab>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 05-03-2012 11:13, Borislav Petkov escreveu:
> On Mon, Mar 05, 2012 at 10:35:47AM -0300, Mauro Carvalho Chehab wrote:
>> No. This is an example that you're not reading my emails:
> 
> Unfortunately, I read your emails.
> 
>> no other driver needs that. So, it is something that it is specific to
>> the MCA amd64 drivers.
> 
> Let me spell it for ya: no, it's specific to x86, and not to amd64_edac.

As I'll NACK adding this solution on my drivers, as it makes no sense there,
it is specific to amd64_edac/amd64 mce.

>> The other two MCA drivers are sb_edac and i7core_edac. I wrote both drivers, and they
>> don't need any helper function to store strings on a temporary buffer.
>>
>> Also, the edac core is not x86-specific. So, referencing to a var there (ras_agent) 
>> that it is defined inside arch/x86 would break Kernel compilation on all other 
>> architectures.
> 
> That's more like it.
> 
> It can be moved to an arch-agnostic place or be defined
> __attribute__((weak)) in edac_core.c. Unless someone has a better idea,
> of course.

Well, just fill the string on the way it makes sense for amd64, and then call the
EDAC report function, letting it to call the trace function.

> 
> [..]
> 
>> As already pointed out, you're not reading my emails. The above were at the version 1 of
>> my patches, with I sent at least a month ago. Since version 2, what is proposed is to use:
>>
>> TRACE_EVENT(mc_error_mce,
>>
>> for MCA-based memory error events. There's also a variant for non-MCA drivers (mc_error). 
>>
>> [1] http://git.kernel.org/?p=linux/kernel/git/mchehab/linux-edac.git;a=commitdiff;h=4eb2a29419c1fefd76c8dbcd308b84a4b52faf4d
> 
> I see at least 4 misdesigned tracepoints there:
> 
> trace_mc_out_of_range_mce
> trace_mc_out_of_range
> trace_mc_error_mce
> trace_mc_error
> ...

There's no "..." there. There are just 4 traces defined.
The out of range is an special case to report parse errors.

As I said before, I'm OK to remove the *out_of_range* traces. 

So, there'are just two traces:

	trace_mc_error_mce
	trace_mc_error

E. g. one for the MCA errors, and another one for the non-architecture supported
error handling.

> so NACK to those.
> 
>> I also wrote on my emails that, instead of having a tracepoint
>> specific for memory errors, it is possible to re-define the fields
>> I've proposed to cover CPU location/socket label, and that this is
>> better than folding everything into a hard-to-parse single string
>> message.
> 
> No, this is repurposing the fields of memory errors, which is ugly. So, no.

Then, I it should have 2 MCA error traces:

	- One when the error is inside the CPU socket;
	- Another one when the error is outside the CPU.

Tony,

Please correct me if I'm wrong, but Intel MCA can only point to an error inside
the CPU or a memory error, right? At least, I didn't find there at the x86 arch 
specs anything at the MCA registers that would allow an error to point to the 
PCI bus address for a PCI error, for example.

Regards,
Mauro


