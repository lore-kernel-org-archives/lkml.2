Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758770Ab2BJOSE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 09:18:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59079 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751205Ab2BJOSC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 09:18:02 -0500
Message-ID: <4F35270F.1020402@redhat.com>
Date: Fri, 10 Feb 2012 12:17:51 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 01/31] events/hw_event: Create a Hardware Events Report
 Mecanism (HERM)
References: <1328832090-9166-1-git-send-email-mchehab@redhat.com> <1328832090-9166-2-git-send-email-mchehab@redhat.com> <20120210134115.GC16783@aftab>
In-Reply-To: <20120210134115.GC16783@aftab>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 10-02-2012 11:41, Borislav Petkov escreveu:
> On Thu, Feb 09, 2012 at 10:01:00PM -0200, Mauro Carvalho Chehab wrote:
>> In order to provide a proper hardware event subsystem, let's
>> encapsulate hardware events into a common trace facility, and
>> make both edac and mce drivers to use it. After that, common
>> facilities can be moved into a new core for hardware events
>> reporting subsystem. This patch is the first of a series, and just
>> touches at mce.
> 
> I think it would work too if you had only one event:
> 
> * trace_hw_error(...)
> 
> which would have as an argument a string describing it, like
> "Uncorrected Memory Read Error", "Memory Read Error (out of range)" "TLB
> Multimatch Error" etc., followed by the rest of the error info.
> 
> Currently, you're introducing at least 5 trace_* calls _only_ for memory
> errors. What about the remaining couples of tens of errors which haven't
> been addressed yet?

Good point.

The way I see it is that:

- a non-memory related, non-parsed MCE event would generate a "mce_record" trace
	(we need an additional patch to disable it when the error is parsed.
	 I'll address it after finishing the tests with a few other platforms);

As more MCE parsers are added at the core, the situations where such event will
be generated will reduce, and will eventually disappear in long term.

- a non-x86 event (or a x86 event for a memory controller that is not addressed
by MCE events) will use a "mc_error";

- a x86 event generated via MCE will use a "mc_error_mce".

There are two special events defined when there's a memory error _and_ a driver
bug:

	"mc_out_of_range_mce" and "mc_out_of_range".

While the name of them and one of the parameters are memory-controller specific,
it should be easy to make it generic enough to be used by other types of errors.

The previous EDAC logic were to generate an out of range printk and return. With
the changes I made, it is possible to let the EDAC to provide the information
parsed, just discarding the bad parsed value. That's the approach I took, as the
other information there may be useful. By taking such approach, the MCE information
will be shown by the "mc_error_mce" trace. So, we can remove the "mc_out_of_range_mce"
without loosing any information.

In any case, we can't merge the *_mce with the non-mce variant, as the mce.h header
is arch specific and doesn't exist on PPC and tilera architectures.

So, the only event that we can actually remove is "mc_out_of_range_mce", if we let
the core generate two events for badly parsed error events. What do you think?

Regards,
Mauro



> 
> Thanks.
> 

