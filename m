Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758194Ab2EKSxQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 14:53:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4694 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751794Ab2EKSxO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 14:53:14 -0400
Message-ID: <4FAD6012.20408@redhat.com>
Date: Fri, 11 May 2012 15:53:06 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: "Luck, Tony" <tony.luck@intel.com>
CC: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Doug Thompson <norsk5@yahoo.com>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH v.23-2] RAS: use tracepoint to handle hw issues
References: <1336683628-12954-1-git-send-email-mchehab@redhat.com> <1336748054-21325-1-git-send-email-mchehab@redhat.com> <3908561D78D1C84285E8C5FCA982C28F192ED5D3@ORSMSX104.amr.corp.intel.com>
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F192ED5D3@ORSMSX104.amr.corp.intel.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 11-05-2012 14:02, Luck, Tony escreveu:
>> For example:
>>
>> mc_event: Corrected error:memory read on memory stick "DIMM_1A" (mc:0 channel:0 slot:0 page:0x586b6e offset:0xa66 grain:32 syndrome:0x0 area:DMA)
> 
> This is looking so much better.
> 
> I looked through your examples from drivers on what text we might see
> in the "memory read" position ... and agree that it would be a lot of
> work to make them all come up with grammatically clean messages, especially
> for all the poorly documented (or undocumented) "default/unknown/..." cases.
> 
> Back to my "does the casual user really need to know" soapbox. What different
> actions do we expect a user to take when we tell them "read error" or "write
> error" or "unknown error"?  I'm beginning to think that this belongs inside
> the brackets! Perhaps as:  type:"memory read"?

Indeed, read/write errors are equal for the user, but other events like (i5100):

		"SPD protocol error", /* 18 */
		"spare copy initiated", /* 20 */
		"spare copy completed", /* 21 */

Or (i5000):
	"Northbound CRC error on non-redundant retry";
	">Tmid Thermal event with intelligent throttling disabled";
			specific = "DIMM-spare copy started";
			specific = "DIMM-spare copy completed";

May mean that the DIMM is ok, but the error maybe on some other part of the system
(like an overheated cabinet, a badly-inserted DIMM or PCI device or maybe just some
 data mirroring in progress).

So, IMHO, keeping it at the main part of the error is valuable, at least when the
driver can generate such kinds of event.

> Then we'd have:
> 
> mc_event: Corrected error on memory stick "DIMM_1A" (bunch of stuff for deep diagnosis by vendor)

With the current implementation, this can actually be done at driver-basis: just fill
error_msg with a blank string and add all details at the driver-specific error detail.

> Knowing that the error was Corrected/Uncorrected is vital to the user. It lets them know
> the urgency with which they need to take action ... we need to educate them that a few
> "Corrected" errors are perfectly normal and nothing to raise blood pressure about.
> 
> Knowing which memory stick was involved - also very important. If they do take action,
> they should be able to swap out the memory stick that was the source of the problem.

> Everything else is just for memory geeks like me, you and Boris (and OEMs who want to
> diagnose root cause of problems they see by pattern analysis across errors from multiple
> machines with DIMMS from different batches/vendors).

Agreed (except for the cases like the above described).

Regards,
Mauro
