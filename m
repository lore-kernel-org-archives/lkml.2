Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756938Ab0JOVDh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 17:03:37 -0400
Received: from casper.infradead.org ([85.118.1.10]:54108 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756489Ab0JOVDg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 17:03:36 -0400
Subject: Re: [PATCH 5/9] jump label: Add
 register_jump_label_key/unregister_jump_label_key
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jason Baron <jbaron@redhat.com>
In-Reply-To: <20101015201036.923619508@goodmis.org>
References: <20101015200949.134732894@goodmis.org>
	 <20101015201036.923619508@goodmis.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 15 Oct 2010 23:03:15 +0200
Message-ID: <1287176595.1998.116.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-10-15 at 16:09 -0400, Steven Rostedt wrote:
> 
> 2)
> 
> If a tracepoint is defined in the core kernel code, but the usage
> of the tracepoint is confined to a module, the current jump label
> code does not create a entry in its table until the module is
> loaded. Thus, if the tracepoint is enabled before the module
> is loaded, we would miss the enablement of the jump label.
> 
> I'm not sure if there any tracepoints which currently fall into
> this category (the bkl could fall into this category at some point
> if its only used in modules). However, I do think its an important
> case to address to make sure that jump label behave in a consistent
> way with how consumers of the tracepoints might expect.
> 
> This case is implemented by introducing:
> 
> void register_jump_label_key(unsigned long key);
> void unregister_jump_label_key(unsigned long key);
> 
> So basically any jump label that we want to use in the system must
> first be registered, then it can be enabled/disabled, and then
> finally it can be unregistered. For core kernel jump labels, I would
> only expect them to be registered and never unregistered. However,
> a jump label may be unregistred when modules are removed.
> 
> Although, this introduces some more work for consumers wanting
> to use jump labels, the tracepoint and dynamic debug consumer code
> seems fairly contained, at least to me. 

Urgh, this sucks.. :-(

So now we have to actually track all JUMP_LABEL() sites and call
register muck on them.. even though we already track them through the
special data section.

Is there really no way around this?
