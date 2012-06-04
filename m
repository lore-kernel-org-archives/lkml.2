Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760554Ab2FDMud (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 08:50:33 -0400
Received: from casper.infradead.org ([85.118.1.10]:56548 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753225Ab2FDMuc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 08:50:32 -0400
Message-ID: <1338814210.28282.47.camel@twins>
Subject: Re: [RFC] [PATCH 0/5] Teach perf tool to profile sleep times (V4)
From: Peter Zijlstra <peterz@infradead.org>
To: Andrew Vagin <avagin@openvz.org>
Cc: Arun Sharma <asharma@fb.com>, Oleg Strikov <OSTRIKOV@nvidia.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org
Date: Mon, 04 Jun 2012 14:50:10 +0200
In-Reply-To: <1338813658.28282.43.camel@twins>
References: <1338797382-287275-1-git-send-email-avagin@openvz.org>
	 <1338813658.28282.43.camel@twins>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-06-04 at 14:40 +0200, Peter Zijlstra wrote:
> +       if (task) {
> +               struct perf_event_context *ctx;
> +
> +               rcu_read_lock();
> +               ctx = rcu_dereference(task->perf_event_ctxp[perf_sw_context]);
> +               list_for_each_entry_rcu(event, &ctx->event_list, event_entry) {

Ah, this needs a little something like the below:

			if (!(event->attr.type == PERF_TYPE_TRACEPOINT &&
			      event->attr.config == $something))
				continue;

Not exactly sure where we hid the tracepoint_id at this point..


> +                       if (perf_tp_event_match(event, &data, regs))
> +                               perf_swevent_event(event, count, &data, regs);
> +               }
> +               rcu_read_unlock();
> +       } 
