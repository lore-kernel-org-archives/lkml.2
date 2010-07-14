Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757022Ab0GNToP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 15:44:15 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42157 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754508Ab0GNToN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 15:44:13 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTil2r3sUcoCC_ktp3TV2JNTSMxbpke8yJMx_8lmm@mail.gmail.com>
References: <20100714154923.947138065@efficios.com>
	<20100714155804.049012415@efficios.com>
	<AANLkTiml2uwYqQayTKjMN2gI3LnjVFpwxXkv8GN3McEE@mail.gmail.com>
	<20100714170617.GB4955@Krystal>
	<AANLkTinLB3gQNKFk9QRfBS8YEfxL3qxZDFw7vWHDOnmL@mail.gmail.com>
	<20100714184642.GA9728@elte.hu>
	<AANLkTil2r3sUcoCC_ktp3TV2JNTSMxbpke8yJMx_8lmm@mail.gmail.com>
Date: Wed, 14 Jul 2010 12:41:58 -0700
Message-ID: <AANLkTinfmoKvi1SauDA5_RiTmu6bztTDk8b_ycS-lr8S@mail.gmail.com>
Subject: Re: [patch 1/2] x86_64 page fault NMI-safe
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
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
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 14, 2010 at 12:14 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Wed, Jul 14, 2010 at 11:46 AM, Ingo Molnar <mingo@elte.hu> wrote:
>> We could solve that by copying that small stack frame off before entering the
>> 'generic' NMI routine - but it all feels a bit pulled in by the hair.
>
> Why? It's much cleaner than making the _real_ codepaths much worse.

.. but if the option is to never take a fault at all from the NMI
handler, and that is doable, than that would be good, of course.

But that may not be fixable. At least not without much more pain than
just adding a fairly simple hack to the NMI path itself, and keeping
all the NMI pain away from all the other cases.

And doing the per-cpu NMI nesting hack would actually also work as a
way to essentially block NMI's from critical regions. With my NMI
nestign avoidance suggestion, you could literally do something like
this to block NMI's:

  /* This is just a fake stack structure */
  struct nmi_blocker {
     unsigned long rflags;
     unsigned long cs;
     unsigned long rip;
   };

  void block_nmi_on_this_cpu(struct nmi_blocker *blocker)
  {
      get_cpu();
      memset(blocker, 0, sizeof(*blocker));
      per_cpu_nmi_stack_frame = blocker;
  }

  void unblock_nmi_on_this_cpu(struct nmi_blocker *blocker)
  {
     per_cpu_nmi_stack_frame = NULL;
     barrier();
     /* Did an NMI happen? If so, we're now running NMI-blocked by hardware,
      * we need to emulate the NMI and do a real 'iret' here
      */
     if (blocker->cs == INVALID_CS)
        asm volatile(".. build stack frame, call NMI routine ..");
     put_cpu();
  }

or similar. Wouldn't that be nice to have as a capability?

                 Linus
