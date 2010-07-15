Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934931Ab0GOWr7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 18:47:59 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50837 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934838Ab0GOWr5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 18:47:57 -0400
Message-ID: <4C3F8FD5.9080203@zytor.com>
Date: Thu, 15 Jul 2010 15:46:45 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Steven Rostedt <rostedt@rostedt.homelinux.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>,
        Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Tom Zanussi <tzanussi@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        "Frank Ch. Eigler" <fche@redhat.com>, Tejun Heo <htejun@gmail.com>
Subject: Re: [patch 1/2] x86_64 page fault NMI-safe
References: <AANLkTinLB3gQNKFk9QRfBS8YEfxL3qxZDFw7vWHDOnmL@mail.gmail.com>	<20100714203940.GC22096@Krystal>	<AANLkTinM0eFnreNB5l_6f20oSGBchqAtYPb57tM01kUB@mail.gmail.com>	<20100714222115.GA30122@Krystal>	<AANLkTikLG4xVYfvuMtbuzsqcnzo1ut4dFAm6piqy2Lh7@mail.gmail.com>	<AANLkTin21xBD-BFY4ZX2BPRFnT5-LkgGugvWsvTEP4Mr@mail.gmail.com>	<AANLkTil4LYSjS88P2CopOVi3Ty9pxwFPsaw0328KlPSu@mail.gmail.com>	<20100715183153.GA9276@Krystal>	<AANLkTilfXUtQznSzOmO9ecoaviIt62Hv6jdUOMSRLdrF@mail.gmail.com>	<AANLkTimAn0uMpeYKctO0qxM6nwbfev3RHARLZIbf991k@mail.gmail.com>	<20100715220117.GA1499@Krystal>	<AANLkTinL3S3iMSoP0fb6bxn9IY62OmytBtbqCKy9CZk2@mail.gmail.com> <AANLkTinOTwnSNgwX7PnalhzwWMjwie0Xk_Lnrn_0bLzz@mail.gmail.com>
In-Reply-To: <AANLkTinOTwnSNgwX7PnalhzwWMjwie0Xk_Lnrn_0bLzz@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/2010 03:26 PM, Linus Torvalds wrote:
> On Thu, Jul 15, 2010 at 3:16 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>>
>> Then you could in fact possibly test the stack pointer for whether it
>> is in the NMI stack area, and use the value of %rsp itself as the
>> flag. So you could avoid the flag entirely. Because testing %rsp is
>> valid - testing %rip is not.
>>
>> That would also avoid the race, because %rsp (as a flag) now gets
>> cleared atomically by the "iret". So that might actually solve things.
> 
> Hmm. So on x86-32, it's easy: if the NMI is nested, you can literally
> look at the current %rsp value, and see if it's within the NMI stack
> region.
> 
> But on x86-64, due to IST, you need to look at the saved-rsp value on
> the stack, since the %rsp always gets reset to the NMI stack region
> regardless of where it was before.
> 
> Why do we force IST use for NMI, btw? Maybe we shouldn't, and just use
> the normal kernel stack mechanisms?
> 

The reasons for using TSS (32 bits) or IST (64 bits) are: concern about
the size of the regular kernel stack, and a concern that the kernel
stack pointer may not be in a usable state.  The former is not a problem
here: we're doing a stack switch anyway, and so the additional overhead
on the main stack is pretty minimal, but the latter may be.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

