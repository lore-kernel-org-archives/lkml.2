Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754465Ab2FWDiQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 23:38:16 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:35237 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752300Ab2FWDiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 23:38:15 -0400
MIME-Version: 1.0
In-Reply-To: <CAEtiSauEdKP3Jsi_O6Q=yc9AWkSKDvNrLe0faicQWJGqdKxLwg@mail.gmail.com>
References: <CAEtiSauEdKP3Jsi_O6Q=yc9AWkSKDvNrLe0faicQWJGqdKxLwg@mail.gmail.com>
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Date: Fri, 22 Jun 2012 23:37:54 -0400
Message-ID: <CAHGf_=r8Goe6EEC1eS_Azxc1nQcEq4txRMDPGRLVLoyF3xFriA@mail.gmail.com>
Subject: Re: [RFC][RT][PATCH] mm: Do not use stop_machine() for
 __zone_pcp_udpate() for CONFIG_PREEMPT_RT_FULL
To: Aaditya Kumar <aaditya.kumar.30@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, mingo@kernel.org, C.Emde@osadl.org,
        jkacur@redhat.com, frank.rowand@am.sony.com, tim.bird@am.sony.com,
        takuzo.ohara@ap.sony.com, kan.iibuchi@jp.sony.com,
        kosaki.motohiro@gmail.com,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(6/19/12 2:32 PM), Aaditya Kumar wrote:
> The code path of __zone_pcp_update() has following locks, which in
> CONFIG_PREEMPT_RT_FULL=y are rt-mutex.
>   - pa_lock locked by cpu_lock_irqsave()
>   - zone->lock locked by free_pcppages_bulk()
>
> Since __zone_pcp_update() is called from stop_machine(), so with
> CONFIG_PREEMPT_RT_FULL=y
> we get following backtrace when __zone_pcp_update() is called during
> memory hot plugging while
> doing heavy file I/O.
>
> I think stop_machine() may not be required for calling __zone_pcp_update()
> in case of CONFIG_PREEMPT_RT_FULL=y as acquiring pa_lock in __zone_pcp_update()
> should be sufficient to isolate pcp pages and to setup per cpu pagesets.
>
> Can someone please let me know if am missing anything here?

First off, you should cc memory hotplug experts when discussing memory
hotplug topic.
Second, stop_machine() is required because usually zone->pageset is
per-cpu variable.
the regular access rule is, 1) owner cpu can always access their own
pcp, 2) offlined cpu's
pcp can be accessed from any cpus because is has no race chance 3)
otherwise caller must
use stop_machine for preventing owner cpu accesses pcp.

stop_machine and send ipi are common technique for per-cpu area hack.
