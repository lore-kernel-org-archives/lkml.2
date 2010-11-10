Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756236Ab0KJOia (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 09:38:30 -0500
Received: from canuck.infradead.org ([134.117.69.58]:56018 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755319Ab0KJOi2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 09:38:28 -0500
Subject: Re: [RFC PATCH 1/2] perf: Enable group siblings on exec if
 attr::enable_on_exec set
From: Peter Zijlstra <peterz@infradead.org>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Matt Fleming <matt@console-pimps.org>,
        "Zhang, Rui" <rui.zhang@intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
In-Reply-To: <1289398677.2479.10.camel@localhost>
References: <1289369711.2430.38.camel@minggr.sh.intel.com>
	 <1289391586.2191.100.camel@laptop>  <1289398677.2479.10.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 10 Nov 2010 15:38:35 +0100
Message-ID: <1289399915.2191.127.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-10 at 22:17 +0800, Lin Ming wrote:
> On Wed, 2010-11-10 at 20:19 +0800, Peter Zijlstra wrote:
> > On Wed, 2010-11-10 at 14:15 +0800, Lin Ming wrote:
> > > Currently, only group leader is enabled on exec.
> > 
> > That's enough, right? If all sibling events are already enabled enabling
> > the group leader makes the whole thing go.
> 
> No.
> 
> If the event group is disabled by default("perf stat" case) and will be
> enabled at next exec, then actually only the group leader will be
> enabled , because all siblings are explicitly disabled(->state ==
> PERF_EVENT_STATE_OFF). So the siblings will never be enabled.

Right, so what I was saying is, don't disable all the siblings by
default, so that only the group leader will be disabled. In that case
nothing will get scheduled because the group leader is not enabled.

So: {disabled, enabled, enabled} will not actually get scheduled and the
group as a whole is effectively disabled. Once the enabled_on_exec flips
the group leader to 'enabled' the whole group becomes enabled.

I don't mind the patch too much (although I would like to avoid that
double sibling iteration in both group_enable_on_exec() and
__perf_event_mark_enabled()), but I think it can already work as is.


