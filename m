Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932387Ab1BKVhP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 16:37:15 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:48365 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932069Ab1BKVhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 16:37:13 -0500
Subject: Re: [PATCH 0/2] jump label: 2.6.38 updates
From: Peter Zijlstra <peterz@infradead.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Jason Baron <jbaron@redhat.com>, hpa@zytor.com, rostedt@goodmis.org,
        mingo@elte.hu, tglx@linutronix.de, andi@firstfloor.org,
        roland@redhat.com, rth@redhat.com, masami.hiramatsu.pt@hitachi.com,
        fweisbec@gmail.com, avi@redhat.com, davem@davemloft.net,
        sam@ravnborg.org, ddaney@caviumnetworks.com, michael@ellerman.id.au,
        linux-kernel@vger.kernel.org
In-Reply-To: <BLU0-SMTP101B686C32E10BA346B15F896EF0@phx.gbl>
References: <cover.1294239591.git.jbaron@redhat.com>
	 <1297452328.5226.89.camel@laptop>
	 <BLU0-SMTP101B686C32E10BA346B15F896EF0@phx.gbl>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 11 Feb 2011 22:38:17 +0100
Message-ID: <1297460297.5226.99.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-02-11 at 16:13 -0500, Mathieu Desnoyers wrote:
> 
> Thoughts ? 

 #if defined(CC_HAVE_ASM_GOTO) && defined(CONFIG_JUMP_LABEL)
+
+struct jump_label_key {
+       void *ptr;
+};

 struct jump_label_entry {
        struct hlist_node hlist;
        struct jump_entry *table;
-       int nr_entries;
        /* hang modules off here */
        struct hlist_head modules;
        unsigned long key;
+       u32 nr_entries;
+       int refcount;
 };

#else

+struct jump_label_key {
+       int state;
+};

#endif



So why can't we make that jump_label_entry::refcount and
jump_label_key::state an atomic_t and be done with it?

Then the enabled case uses if (atomic_inc_return(&key->ptr->refcount) ==
1), and the disabled atomic_inc(&key->state).

