Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756946Ab0LPS0H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 13:26:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62238 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751724Ab0LPS0B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 13:26:01 -0500
Date: Thu, 16 Dec 2010 13:25:11 -0500
From: Jason Baron <jbaron@redhat.com>
To: peterz@infradead.org, hpa@zytor.com, rostedt@goodmis.org, mingo@elte.hu
Cc: mathieu.desnoyers@polymtl.ca, tglx@linutronix.de, andi@firstfloor.org,
        roland@redhat.com, rth@redhat.com, masami.hiramatsu.pt@hitachi.com,
        fweisbec@gmail.com, avi@redhat.com, davem@davemloft.net,
        sam@ravnborg.org, ddaney@caviumnetworks.com, michael@ellerman.id.au,
        linux-kernel@vger.kernel.org
Message-Id: <cover.1292522251.git.jbaron@redhat.com>
Subject: [PATCH/RFC 0/2] jump label: simplify API
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The first patch uses the storage space of the jump label key address
as a pointer into the update table. In this way, we can find all
the addresses that need to be updated without hashing.

The second patch introduces:

static __always_inline bool unlikely_switch(struct jump_label_key *key);

instead of the old JUMP_LABEL(key, label) macro.

In this way, jump labels become really easy to use:

Define:

	struct jump_label_key jump_key;

Can be used as:

	if (unlikely_switch(&jump_key))
		do unlikely code

enable/disale via:

	jump_label_enable(&jump_key);
	jump_label_disable(&jump_key);

that's it!

Thanks to H. Peter Anvin for suggesting the simpler 'unlikely_switch()'
function.

thanks,

-Jason


Jason Baron (2):
  jump label: make enable/disable o(1)
  jump label: introduce unlikely_switch()

 arch/x86/include/asm/jump_label.h |   22 +++--
 arch/x86/kernel/jump_label.c      |    2 +-
 include/linux/dynamic_debug.h     |   24 ++----
 include/linux/jump_label.h        |   72 ++++++++++-------
 include/linux/jump_label_ref.h    |   41 ++++++----
 include/linux/perf_event.h        |   25 +++---
 include/linux/tracepoint.h        |    8 +-
 kernel/jump_label.c               |  159 ++++++++++++++++++++++++++++++-------
 kernel/perf_event.c               |    4 +-
 kernel/tracepoint.c               |   22 ++---
 10 files changed, 243 insertions(+), 136 deletions(-)

