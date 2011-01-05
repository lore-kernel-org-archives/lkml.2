Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751926Ab1AEPnu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 10:43:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2978 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750699Ab1AEPnt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 10:43:49 -0500
Date: Wed, 5 Jan 2011 10:43:05 -0500
From: Jason Baron <jbaron@redhat.com>
To: peterz@infradead.org, mathieu.desnoyers@polymtl.ca, hpa@zytor.com,
        rostedt@goodmis.org, mingo@elte.hu
Cc: tglx@linutronix.de, andi@firstfloor.org, roland@redhat.com, rth@redhat.com,
        masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com, avi@redhat.com,
        davem@davemloft.net, sam@ravnborg.org, ddaney@caviumnetworks.com,
        michael@ellerman.id.au, linux-kernel@vger.kernel.org
Message-Id: <cover.1294239591.git.jbaron@redhat.com>
Subject: [PATCH 0/2] jump label: 2.6.38 updates
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The first patch uses the storage space of the jump label key address
as a pointer into the update table. In this way, we can find all
the addresses that need to be updated without hashing.

The second patch introduces:

static __always_inline bool static_branch(struct jump_label_key *key);

instead of the old JUMP_LABEL(key, label) macro.

In this way, jump labels become really easy to use:

Define:

        struct jump_label_key jump_key;

Can be used as:

        if (static_branch(&jump_key))
                do unlikely code

enable/disale via:

        jump_label_enable(&jump_key);
        jump_label_disable(&jump_key);

that's it!

For perf, which also uses jump labels, I've left the reference counting
out of the jump label layer, thus removing the 'jump_label_inc()' and
'jump_label_dec()' interface. Hopefully, this is a more palatable solution.

Thanks to H. Peter Anvin for suggesting the simpler 'static_branch()'
function.

thanks,

-Jason




Jason Baron (2):
  jump label: make enable/disable o(1)
  jump label: introduce unlikely_switch()

 arch/sparc/include/asm/jump_label.h |   25 ++++---
 arch/x86/include/asm/jump_label.h   |   22 ++++---
 arch/x86/kernel/jump_label.c        |    2 +-
 include/linux/dynamic_debug.h       |   24 ++-----
 include/linux/jump_label.h          |   66 ++++++++++--------
 include/linux/jump_label_ref.h      |   36 +++-------
 include/linux/perf_event.h          |   28 ++++----
 include/linux/tracepoint.h          |    8 +--
 kernel/jump_label.c                 |  129 +++++++++++++++++++++++++++--------
 kernel/perf_event.c                 |   24 ++++--
 kernel/tracepoint.c                 |   22 ++----
 11 files changed, 226 insertions(+), 160 deletions(-)

