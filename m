Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757395Ab0LPTK0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 14:10:26 -0500
Received: from canuck.infradead.org ([134.117.69.58]:49038 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753574Ab0LPTKZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 14:10:25 -0500
Subject: Re: [PATCH/RFC 1/2] jump label: make enable/disable o(1)
From: Peter Zijlstra <peterz@infradead.org>
To: Jason Baron <jbaron@redhat.com>
Cc: hpa@zytor.com, rostedt@goodmis.org, mingo@elte.hu,
        mathieu.desnoyers@polymtl.ca, tglx@linutronix.de, andi@firstfloor.org,
        roland@redhat.com, rth@redhat.com, masami.hiramatsu.pt@hitachi.com,
        fweisbec@gmail.com, avi@redhat.com, davem@davemloft.net,
        sam@ravnborg.org, ddaney@caviumnetworks.com, michael@ellerman.id.au,
        linux-kernel@vger.kernel.org
In-Reply-To: <a35b9310aafa31a9e97f5c9bad9b09e0b6cbbf79.1292522252.git.jbaron@redhat.com>
References: <cover.1292522251.git.jbaron@redhat.com>
	 <a35b9310aafa31a9e97f5c9bad9b09e0b6cbbf79.1292522252.git.jbaron@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 16 Dec 2010 20:10:02 +0100
Message-ID: <1292526602.2708.57.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-12-16 at 13:25 -0500, Jason Baron wrote:
> Previously, I allowed any variable type to be used as the 'key' for
> the jump label. However, by enforcing a type, we can make use of the
> contents of the 'key'. This patch thus introduces:
> 
> struct jump_label_key {
>        void *ptr;
> };
> 
> The 'ptr' is used a pointer into the jump label table of the
> corresponding addresses that need to be updated. Thus, when jump labels
> are enabled/disabled we have a constant time algorithm. There is no
> longer any hashing.
> 
> When jump lables are disabled we simply have:
> 
> struct jump_label_key {
>         int state;
> };
> 
> I've also defined an analogous structure for ref counted jump labels as
> per a request from Peter.
> 
> struct jump_label_keyref {
>        void *ptr;
> };
> 
> And for the jump labels disabled case:
> 
> 
> struct jump_label_keyref {
>         atomic_t refcount;
> };
> 
> The reason I've introduced an additional structure for the reference counted
> jump labels is twofold:
> 
> 1) For the jump labels disabled case, reference counted jump labels use an
> atomic_read(). I didn't want to impact the jump labels disabled case for
> tracepoints which simply accesses an 'int'.
> 
> 2) By introducing a second type, we have two parallel APIs:
> 
> extern void jump_label_enable(struct jump_label_key *key);
> extern void jump_label_disable(struct jump_label_key *key);
> 
> static inline void jump_label_inc(struct jump_label_keyref *key)
> static inline void jump_label_dec(struct jump_label_keyref *key)
> 
> In this way, we can't mix up the reference counted API, with the straight
> enable/disable API since they accept different types.

But why do we want to have two APIs?
