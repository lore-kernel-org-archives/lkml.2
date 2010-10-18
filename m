Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755115Ab0JRLST (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 07:18:19 -0400
Received: from canuck.infradead.org ([134.117.69.58]:56948 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754636Ab0JRLSR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 07:18:17 -0400
Subject: Re: [tip:perf/core] jump label: x86 support
From: Peter Zijlstra <peterz@infradead.org>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, tglx@linutronix.de, jbaron@redhat.com,
        "mathieu.desnoyers" <mathieu.desnoyers@efficios.com>
Cc: linux-tip-commits@vger.kernel.org
In-Reply-To: <tip-d9f5ab7b1c0a520867af389bab5d5fcdbd0e407e@git.kernel.org>
References: <f838f49f40fbea0254036194be66dc48b598dcea.1284733808.git.jbaron@redhat.com>
	 <tip-d9f5ab7b1c0a520867af389bab5d5fcdbd0e407e@git.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 18 Oct 2010 13:17:55 +0200
Message-ID: <1287400675.29097.1550.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-09-24 at 09:01 +0000, tip-bot for Jason Baron wrote:
> +void arch_jump_label_transform(struct jump_entry *entry,
> +                              enum jump_label_type type)
> +{
> +       union jump_code_union code;
> +
> +       if (type == JUMP_LABEL_ENABLE) {
> +               code.jump = 0xe9;
> +               code.offset = entry->target -
> +                               (entry->code + JUMP_LABEL_NOP_SIZE);
> +       } else
> +               memcpy(&code, ideal_nop5, JUMP_LABEL_NOP_SIZE);
> +       get_online_cpus();
> +       mutex_lock(&text_mutex);
> +       text_poke_smp((void *)entry->code, &code, JUMP_LABEL_NOP_SIZE);
> +       mutex_unlock(&text_mutex);
> +       put_online_cpus();
> +} 

hpa, mathieu, what's the status of stop_machine less text poking?
Because the above basically means we have to disable architecture
jump_label support for -rt.
