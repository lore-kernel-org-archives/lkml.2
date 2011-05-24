Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754549Ab1EXQ6G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 12:58:06 -0400
Received: from mga01.intel.com ([192.55.52.88]:50427 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753136Ab1EXQ6F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 12:58:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,261,1304319600"; 
   d="scan'208";a="7873867"
From: "Luck, Tony" <tony.luck@intel.com>
To: Ingo Molnar <mingo@elte.hu>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>, Andi Kleen <andi@firstfloor.org>,
        Borislav Petkov <bp@alien8.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Date: Tue, 24 May 2011 09:57:46 -0700
Subject: RE: [RFC 0/9] mce recovery for Sandy Bridge server
Thread-Topic: [RFC 0/9] mce recovery for Sandy Bridge server
Thread-Index: AcwZxFlMSQwrNMG/Q5aZUjpOaLvlQAAbCDUg
Message-ID: <987664A83D2D224EAE907B061CE93D5301D5D0595B@orsmsx505.amr.corp.intel.com>
References: <4ddad79317108eb33d@agluck-desktop.sc.intel.com>
 <20110524034023.GB25230@elte.hu>
In-Reply-To: <20110524034023.GB25230@elte.hu>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Other points noted - I'll go look at the previous discussion threads
you gave me links to.

I do want to comment on this point:
> Creating a callback there would be a good place to do the TIF_MCE work and also 
> to extract any events that got queued by other NMIs. Note that more events 
> might be queued by further NMIs while we are processing the MCE path - while 
> with the task->mce_error_pfn hack we are limited to a single pending event only 
> and subsequent NMIs will overwrite this value!

I wasn't very happy with task->mce_error_pfn either - but being overwritten
is not one of its flaws.  The task that stumbled on the error must not be
run until the error is dealt with - any other NMIs for other errors must
be happening to other tasks (who have their own task->mce_error_pfn).

> A happy side effect is that the TIF_MCE_NOTIFY hack could go away as well.

We need some way to stop the task that found the error dead in its
tracks - if it tripped over a data error, then running it will just trip
over the same error again. If it had a memory error during an instruction
fetch we have no place to return to.

So can we talk about this part for a while before returning to the
"how to report this" discussion?

So here's the situation - we are in the NMI handler when we find from
looking at the machine check bank registers that we have a recoverable
error. We know the physical address, and we know the task (which might
have been in user or kernel context). I can package that information
into a perf/event ... but then how can I mark the current task as
not-fit-for-execution?

-Tony


