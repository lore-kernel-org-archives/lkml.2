Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755380Ab0GSHcy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 03:32:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20871 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752605Ab0GSHcx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 03:32:53 -0400
Message-ID: <4C43FF73.1070305@redhat.com>
Date: Mon, 19 Jul 2010 10:32:03 +0300
From: Avi Kivity <avi@redhat.com>
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
        Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        "Frank Ch. Eigler" <fche@redhat.com>, Tejun Heo <htejun@gmail.com>
Subject: Re: [patch 1/2] x86_64 page fault NMI-safe
References: <20100714154923.947138065@efficios.com>	<20100714155804.049012415@efficios.com>	<AANLkTiml2uwYqQayTKjMN2gI3LnjVFpwxXkv8GN3McEE@mail.gmail.com>	<20100714170617.GB4955@Krystal>	<AANLkTinLB3gQNKFk9QRfBS8YEfxL3qxZDFw7vWHDOnmL@mail.gmail.com>	<20100714203940.GC22096@Krystal>	<AANLkTinM0eFnreNB5l_6f20oSGBchqAtYPb57tM01kUB@mail.gmail.com>	<20100714222115.GA30122@Krystal>	<AANLkTikLG4xVYfvuMtbuzsqcnzo1ut4dFAm6piqy2Lh7@mail.gmail.com>	<AANLkTin21xBD-BFY4ZX2BPRFnT5-LkgGugvWsvTEP4Mr@mail.gmail.com>	<4C42DF9A.5090908@redhat.com>	<AANLkTin1noI6IUfuQsbAgVVzj2rSOhm-Cx3WpsMBgdJ6@mail.gmail.com>	<4C434223.8030202@redhat.com> <AANLkTinQQoLkCg5ru8X5jtPnpCx2B3JnhcHvg3vm4BFQ@mail.gmail.com>
In-Reply-To: <AANLkTinQQoLkCg5ru8X5jtPnpCx2B3JnhcHvg3vm4BFQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18/2010 09:22 PM, Linus Torvalds wrote:
> On Sun, Jul 18, 2010 at 11:04 AM, Avi Kivity<avi@redhat.com>  wrote:
>    
>> Too simple - an MCE will switch to its own stack, failing the test.  Now
>> that we have correctable MCEs, that's not a good idea.
>>      
> Ahh, true. And I think we do DEBUG traps with IST too.
>
> So we do need the explicit flag over the region. Too bad. I was hoping
> to handle the nested case without having to set up the percpu segment
> (that whole conditional swapgs thing, which is extra painful in NMI).
>    

Well, we have to do that anyway for the non-nested case.  So we just do 
it before checking whether we're nested or not, and undo it on the popf; 
retf path.

-- 
error compiling committee.c: too many arguments to function

