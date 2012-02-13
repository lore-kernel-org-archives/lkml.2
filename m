Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756526Ab2BMKYF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 05:24:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35803 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754493Ab2BMKYB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 05:24:01 -0500
Message-ID: <4F38E4B5.6070205@redhat.com>
Date: Mon, 13 Feb 2012 08:23:49 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 01/31] events/hw_event: Create a Hardware Events Report
 Mecanism (HERM)
References: <1328832090-9166-1-git-send-email-mchehab@redhat.com> <1328832090-9166-2-git-send-email-mchehab@redhat.com> <20120210134115.GC16783@aftab> <4F35270F.1020402@redhat.com> <20120212124825.GC32467@aftab> <4F37F526.8090907@redhat.com> <20120212184445.GA2080@aftab> <4F381520.8070504@redhat.com> <20120213092131.GA7235@aftab>
In-Reply-To: <20120213092131.GA7235@aftab>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 13-02-2012 07:21, Borislav Petkov escreveu:
> On Sun, Feb 12, 2012 at 05:38:08PM -0200, Mauro Carvalho Chehab wrote:
>> Em 12-02-2012 16:44, Borislav Petkov escreveu:
>>> On Sun, Feb 12, 2012 at 03:21:42PM -0200, Mauro Carvalho Chehab wrote:
>>>> As I said before, there's just one trace call for memory error events 
>>>> (hw_event:mc_error) on my second RFC.
>>>
>>> Are you kidding me:
>>>
>>> $ grep -EriIno "trace_.*\W" patch01.txt
>>>
>>> ...
>>>
>>> TRACE_EVENT(mc_corrected_error,
>>> TRACE_EVENT(mc_uncorrected_error,
>>> TRACE_EVENT(mc_corrected_error_fbd,
>>> TRACE_EVENT(mc_uncorrected_error_fbd,
>>> TRACE_EVENT(mc_out_of_range,
>>> TRACE_EVENT(mc_corrected_error_no_info,
>>> TRACE_EVENT(mc_uncorrected_error_no_info,
>>>
>>
>> Huh?
>>
>> See PATCH v3 03/31:  hw_event: Consolidate uncorrected/corrected error msgs into one
>>
>> Those events got merged there into one hardware event and one
>> software error event generated due to a hardware trouble
>> (mc_out_of_range).
> 
> [..]
> 
> Right, and what I was suggesting is to introduce a single trace event
> and use it everywhere. Instead, you're converting the edac calls into
> trace events and then eliminating them, which creates unnecessary noise.

I did that for a few reasons: preserve history for the ones that reviewed
the original patchset, to remind why some changes were needed, and avoid 
rebasing my tree. Also, this way it it simpler to change or remove a patchset
if needed.

At the final version, I intend to fold some patches, in order to remove
some uneeded-to-preserve dirty details from the upstream history.

> But, nevermind this, I have a better suggestion: instead of you and me
> going back and forth needlessly about the trace events, how about you
> concentrate on fixing the FBDIMM drivers (and only those) since this is
> the main reason for your patchset, as you say, and let me concentrate
> on writing the trace event I mean - I'm currently travelling but I'll
> try to hack up something in the next couple of days in order to give
> you a better idea of what I mean? The edac drivers can use the standard
> edac_printk and friends in the meantime and we can convert them later.

The main reason for this patchset is to implement the changes that were
discussed on the EDAC mini-summits that happened in 2010 [1][2]. The
fix for FB-DIMM is one of the issues that I'm addressing [3].

The fixes needed for FB-DIMM drivers and for Intel CPU-integrated memory
controllers (for Nehalem and Sandy Bridge) are done already. I'm now
focused on testing it on a wide range of machines, in order to be sure that
they won't be causing any regressions. I think I'll be able to test it
on almost all x86 machines and on a few ppc ones.

Anyway, I won't be touching on the trace events again. So, feel free to
propose what you're meaning.

It is probably better if you could write a tracing patch against my tree 
with your view, as it will be easy for us to review and to merge it later.
It should also be easier for you to propose it, as, on my tree, all drivers 
call a single function to report errors:

	edac_mc_handle_error(), defined on drivers/edac/edac_mc.c.

This is the function that calls the defined events, and replaces all the
previous ones. All drivers were ported to use it on my tree.

So, for example, on amd64_edac[4], an error is reported like:

edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, src_mci,
			     page, offset, syndrome,
			     csrow, channel, -1,
			     EDAC_MOD_STR, "", NULL);

for the families that don't use MCE for errors, or:

edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, src_mci,
			     page, offset, syndrome,
			     csrow, channel, -1,
			     EDAC_MOD_STR, "", m);

for the ones that use it. The last parameter there is arch-dependent.
The EDAC core calls the x86 variant of the trace call, with the MCE
log information, if the parameter is filled and the machine is X86
(hmm... there's a bug there... it should be testing for CONFIG_X86_MCE
instead of just CONFIG_X86 - I'll add a patch fixing it).

The label is decoded using the (csrow, channel, -1) location. In the case
of this driver, only 2 layers are used, so, the final number is -1. The
EDAC core will print the error for the label found at [csrow][cschannel]
location.

An event where the driver can't decode where the error happened is generated
with:

edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
				     page, offset, syndrome,
				     -1, -1, -1,
				     EDAC_MOD_STR,
				     "failed to map error addr to a node",
				     NULL);

In such case, the location is unknown (all were filled with -1), so
the EDAC core will not seek for the labels.

For FB-DIMM drivers, where part of the location is not known, like UE
errors where the MC can only point to the branch and DIMM slot, but the
channel can't be determined, due to lockstep mode, where both channels of
a branch are used for ECC, the driver will call it with something like:

edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, src_mci,
			     page, offset, syndrome,
			     branch, -1, dimm_slot,
			     "memory read error", "some other detail", NULL);

The core should produce a message like:

	EDAC MC0: UE memory read error on DIMM1A or DIMM1B (branch 0 slot 0 page 0xdeadbeef offset 0xdeadbeef grain 8 syndrome 0x0 some other detail)


[1] http://lwn.net/Articles/388292/
[2] http://lwn.net/Articles/416669/
[3] As you can see, change the EDAC core to not force a csrow/channel
    hierarchy is indeed the hardest challenge that this patchset addresses. 
    While I'm making a big effort to minimally touch the drivers, all drivers need 
    to be converted to use the new function prototypes, and to properly describe 
    what memory hierarchy is used there. For example, those are the changes done
    at amd64_edac:

    http://git.kernel.org/?p=linux/kernel/git/mchehab/linux-edac.git;a=history;f=drivers/edac/amd64_edac.c;h=aa7ecbb48777f7a27ff86c87772facab51f40663;hb=refs/heads/hw_events

   I'll likely be testing my patches tomorrow on amd64, to be sure that no
   regressions were added.

[4] The change at the error logic to use the new way on amd64_edac 
    is on those patches:

	http://git.kernel.org/?p=linux/kernel/git/mchehab/linux-edac.git;a=commitdiff;h=78f9d383a1ab40352c3eb3cf84a7ad93c19652bc
	http://git.kernel.org/?p=linux/kernel/git/mchehab/linux-edac.git;a=commitdiff;h=60dae3534f9f3c8408e1e9016e815e9b06d53a2f

