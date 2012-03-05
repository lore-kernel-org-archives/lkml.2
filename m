Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932321Ab2CENgH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 08:36:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12005 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932224Ab2CENgG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 08:36:06 -0500
Message-ID: <4F54C133.6040709@redhat.com>
Date: Mon, 05 Mar 2012 10:35:47 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Tony Luck <tony.luck@intel.com>, Ingo Molnar <mingo@elte.hu>,
        EDAC devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [PATCH 4/4] EDAC: Convert AMD EDAC pieces to use RAS printk buffer
References: <1330698314-9863-1-git-send-email-bp@amd64.org> <1330698314-9863-5-git-send-email-bp@amd64.org> <4F50DECB.8030200@redhat.com> <20120305110441.GC1070@aftab> <4F54A6FF.50502@redhat.com> <20120305124411.GD1070@aftab>
In-Reply-To: <20120305124411.GD1070@aftab>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 05-03-2012 09:44, Borislav Petkov escreveu:
> On Mon, Mar 05, 2012 at 08:43:59AM -0300, Mauro Carvalho Chehab wrote:
>> It is still adding an amd64-specific code inside the core, as no other driver will
>> use the amd64 "ras_agent".
> 
> Whoopie, we have another example that you're not really reading
> my emails: ras_agent is _NOT_ amd64-specific but it is defined in
> <arch/x86/ras/ras.c>

No. This is an example that you're not reading my emails: no other driver needs that.
So, it is something that it is specific to the MCA amd64 drivers.

The other two MCA drivers are sb_edac and i7core_edac. I wrote both drivers, and they
don't need any helper function to store strings on a temporary buffer.

Also, the edac core is not x86-specific. So, referencing to a var there (ras_agent) 
that it is defined inside arch/x86 would break Kernel compilation on all other 
architectures.

> [..]
> 
>> If nobody objects, I'll add my changes to linux-next, as it was tested
>> on most systems. I'll remove the MCE-specific tracepoint from my code,
>> keeping the trace there for the other stuff.
> 
> As already pointed out, I object to the tracepoints you've defined for every
> single edac_mc_handle_* call:
> 
> TRACE_EVENT(mc_corrected_error,
> TRACE_EVENT(mc_uncorrected_error,
> TRACE_EVENT(mc_corrected_error_fbd,
> TRACE_EVENT(mc_uncorrected_error_fbd,
> TRACE_EVENT(mc_out_of_range,
> TRACE_EVENT(mc_corrected_error_no_info,
> TRACE_EVENT(mc_uncorrected_error_no_info,

As already pointed out, you're not reading my emails. The above were at the version 1 of
my patches, with I sent at least a month ago. Since version 2, what is proposed is to use:

TRACE_EVENT(mc_error_mce,

for MCA-based memory error events. There's also a variant for non-MCA drivers (mc_error). 

[1] http://git.kernel.org/?p=linux/kernel/git/mchehab/linux-edac.git;a=commitdiff;h=4eb2a29419c1fefd76c8dbcd308b84a4b52faf4d

I also wrote on my emails that, instead of having a tracepoint specific for memory errors,
it is possible to re-define the fields I've proposed to cover CPU location/socket label,
and that this is better than folding everything into a hard-to-parse single string message.

> The edac drivers which get their error info from MCA should use
> trace_mce_record() and the others should either use a _single_ generic
> tracepoint or define one which adheres to the underlying hardware
> reporting scheme (be it PCI-AER, or whatever).
> 

Mauro.
