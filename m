Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754352Ab2BLTiW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Feb 2012 14:38:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44343 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751639Ab2BLTiV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Feb 2012 14:38:21 -0500
Message-ID: <4F381520.8070504@redhat.com>
Date: Sun, 12 Feb 2012 17:38:08 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 01/31] events/hw_event: Create a Hardware Events Report
 Mecanism (HERM)
References: <1328832090-9166-1-git-send-email-mchehab@redhat.com> <1328832090-9166-2-git-send-email-mchehab@redhat.com> <20120210134115.GC16783@aftab> <4F35270F.1020402@redhat.com> <20120212124825.GC32467@aftab> <4F37F526.8090907@redhat.com> <20120212184445.GA2080@aftab>
In-Reply-To: <20120212184445.GA2080@aftab>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 12-02-2012 16:44, Borislav Petkov escreveu:
> On Sun, Feb 12, 2012 at 03:21:42PM -0200, Mauro Carvalho Chehab wrote:
>> As I said before, there's just one trace call for memory error events 
>> (hw_event:mc_error) on my second RFC.
> 
> Are you kidding me:
> 
> $ grep -EriIno "trace_.*\W" patch01.txt
> 
> ...
> 
> TRACE_EVENT(mc_corrected_error,
> TRACE_EVENT(mc_uncorrected_error,
> TRACE_EVENT(mc_corrected_error_fbd,
> TRACE_EVENT(mc_uncorrected_error_fbd,
> TRACE_EVENT(mc_out_of_range,
> TRACE_EVENT(mc_corrected_error_no_info,
> TRACE_EVENT(mc_uncorrected_error_no_info,
> 

Huh?

See PATCH v3 03/31:  hw_event: Consolidate uncorrected/corrected error msgs into one

Those events got merged there into one hardware event and one
software error event generated due to a hardware trouble
(mc_out_of_range). 

This patch:
	[PATCH v3 21/31] hw_event: Add x86 MCE events on it

adds the mc_error_mce variant per your request.

What is there is:

$ grep TRACE_EVENT include/trace/events/hw_event.h
TRACE_EVENT(mc_error,
TRACE_EVENT(mc_out_of_range,
TRACE_EVENT(mc_error_mce,
TRACE_EVENT(mc_out_of_range_mce,

And what I've said already is that I'll get rid of 
"mc_out_of_range_mce" in the final version, and convert
"mc_out_of_range" into a generic event to inform that a hardware
error occurred but the driver has a bug and weren't able to 
parse it.

I only added:
	TRACE_EVENT(mc_error_mce,
per your request to have an arch-specific event with both mce-record
data and mc_error information.

For me, only this hardware-error event is needed:
	TRACE_EVENT(mc_error,

Subsequent patches consolidate the drivers to just use one function
call to EDAC core to report the errors:
	edac_mc_handle_error()

That function increments the error counts, gets the associated
label(s) and generate the event. It currently also prints the error
message, to preserve backward compatibility.

Mauro.
