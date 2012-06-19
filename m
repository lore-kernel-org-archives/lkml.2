Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478Ab2FSAtR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 20:49:17 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:50886 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752288Ab2FSAtQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 20:49:16 -0400
X-AuditID: 9c93016f-b7c35ae00000135b-b3-4fdfcc81f822
From: Namhyung Kim <namhyung@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: rostedt@goodmis.org, acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        weisbec@gmail.com, namhyung.kim@lge.com, mingo@kernel.org,
        peterz@infradead.org
Subject: Re: [RFC PATCH 0/2] libtraceevent/perf: Add support for trace-cmd plugins
References: <1339695333-64591-1-git-send-email-dsahern@gmail.com>
	<87lijlhv9v.fsf@sejong.aot.lge.com> <4FDF3D5C.1030209@gmail.com>
Date: Tue, 19 Jun 2012 09:45:40 +0900
In-Reply-To: <4FDF3D5C.1030209@gmail.com> (David Ahern's message of "Mon, 18
	Jun 2012 08:38:20 -0600")
Message-ID: <87d34wi0y3.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.97 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Jun 2012 08:38:20 -0600, David Ahern wrote:
> Hi Namhyung:
>

Hi David,


> On 6/18/12 2:35 AM, Namhyung Kim wrote:
>> And for this particular case in patch 2/2, it seems that format of the
>> kvm_emulate_insn event is broken already and should be fixed anyway.
>> Further improvement in this area can be addressed in perf kvm or other
>> users if needed.
>
> kvm tracepoints are fine; perf just doesn't handle their (advanced)
> formatting.
>

Yeah, I think it's a libtraceevent's issue, not perf's. Please see
below:

TRACE_EVENT(kvm_emulate_insn,
        ...
	TP_printk("%x:%llx:%s (%s)%s",
		  __entry->csbase, __entry->rip,
		  __print_insn(__entry->insn, __entry->len),
		  __print_symbolic(__entry->flags,
				   kvm_trace_symbol_emul_flags),
		  __entry->failed ? " failed" : ""
		)
	);

And __print_insn is defined as:

#define __print_insn(insn, ilen) ({		                 \
	int i;							 \
	const char *ret = p->buffer + p->len;			 \
								 \
	for (i = 0; i < ilen; ++i)				 \
		trace_seq_printf(p, " %02x", insn[i]);		 \
	trace_seq_printf(p, "%c", 0);				 \
	ret;							 \
	})

The parse error is occurred at the beginning of the compound statment:

  Warning: bad op token {
  Warning: failed to read event print fmt for kvm_emulate_insn

I don't think we can handle this kind of compound statments easily. So I
just said it *seems* broken. :) Btw, calling trace_seq_printf() here also
looks like a problem and I have no idea where the 'p' came from.

Thanks,
Namhyung


> Note that I am referring to kvm:* tracepoints, not perf-kvm which has
> its own issues that need to be fixed.
>
> David
