Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752724Ab1EDJlz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 05:41:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39194 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751669Ab1EDJly (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 05:41:54 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: jbaron@redhat.com, rostedt@goodmis.org, mingo@elte.hu
Cc: linux-kernel@vger.kernel.org
Subject: [PATCHv2 0/2] jump_label,x86: make batch update of jump_label entries
Date: Wed,  4 May 2011 11:41:41 +0200
Message-Id: <1304502103-3228-1-git-send-email-jolsa@redhat.com>
In-Reply-To: <1304023961-12741-1-git-send-email-jolsa@redhat.com>
References: <1304023961-12741-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

I'm changing the jump label update code to use batch processing
for x86 architectures. 

Currently each jump label update calls text_poke_smp for each
jump label key entry. Thus one key update ends up calling stop
machine multiple times.

This patch is using text_poke_smp_batch, which is called for
all the key's entries. Thus ensuring the stop machine is called
only once per jump_label key.

attached patches:
1/2 - jump_label,x86: use text_poke_smp_batch for entries update
	- added jump_label_update_end function which is paired with
	the key's entries update
	- jump_label_update_end calls arch_jump_label_update_end which
	is overloaded by x86 arch and makes the batch update of all the
	entries queued by arch_jump_label_transform function.

2/2 - jump_label,x86: using static arrays before dynamic allocation is needed
	- in the first patch, the queue array, which stores jump_label
	entries is allocated/resized dynamically.
	- due to the fact that many jump_label entries have low number
	of callers, it seems appropriate to use static sized array
	when the update starts and if needed (in case of high number
	of jump_label entries) allocate/use the dynamic array


Patch 2/2 and could be ommited if the benefit/complexity ratio
would seem too low.. ;)

I tested this on x86 and s390 archs.

v2 changes:
 - queueing all entries for single key and process them
   all at one time

wrb,
jirka
---
 arch/x86/kernel/jump_label.c |  177 +++++++++++++++++++++++++++++++++++++++--
 include/linux/jump_label.h   |    1 +
 kernel/jump_label.c          |   16 ++++-
 3 files changed, 183 insertions(+), 11 deletions(-)
