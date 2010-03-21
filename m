Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752431Ab0CUTQf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 15:16:35 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:34663 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751337Ab0CUTQe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 15:16:34 -0400
Date: Sun, 21 Mar 2010 20:16:31 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yinghai@kernel.org>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 06/12] genericirq: make irq_chip related function to take
 desc
In-Reply-To: <m1eije71et.fsf@fess.ebiederm.org>
Message-ID: <Pine.LNX.4.64.1003212016040.12371@ask.diku.dk>
References: <1267697339-5491-1-git-send-email-yinghai@kernel.org>
 <1267697339-5491-7-git-send-email-yinghai@kernel.org>
 <alpine.LFD.2.00.1003041142460.2014@localhost.localdomain> <4B900250.8020100@kernel.org>
 <Pine.LNX.4.64.1003050847170.21768@ask.diku.dk> <m1eije71et.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is my semantic patch:

// -----------------------------------------------------------------------
// find functions

@ignore@
struct irq_chip i;
identifier x;
local idexpression l;
position p;
@@

i.x@p = \(NULL\|l\);

@r@
struct irq_chip i;
identifier x!={name,typename},fn;
position p!=ignore.p;
@@

i.x@p = fn;

// -----------------------------------------------------------------------
// normalize code

@@
expression irq;
@@

(
- irq_desc + irq
+ irq_to_desc(irq)
|
- &irq_desc[irq]
+ irq_to_desc(irq)
)

// -----------------------------------------------------------------------
// find their calls

@@
identifier r.fn;
expression irq;
@@

fn(
-  irq
+  irq_to_desc(irq)
   ,...)

@@
struct irq_chip *ic;
struct irq_desc *desc;
identifier fun != {name,typename};
expression irq;
@@

 \(ic\|desc->chip\)->fun(
-  irq
+  irq_to_desc(irq)
   ,...)

// -----------------------------------------------------------------------
// find their definitions

@unused@
identifier r.fn,irq;
type T;
@@

fn(
-   T irq
+   struct irq_desc *unused
    , ...) {
  ... when != irq
      when != unused
      when strict
}

@with_desc@
identifier r.fn,irqv,desc;
type T;
@@

fn(
-   T irqv
+   struct irq_desc *desc
    , ...) {
+ unsigned int irqv = desc->irq;
  ...
(
- struct irq_desc *desc = irq_to_desc(irqv);
|
- struct irq_desc *desc;
  ...
- desc = irq_to_desc(irqv);
)
  ...
}

@depends on !unused && !with_desc@
identifier r.fn,irqv;
type T;
@@

fn(
-   T irqv
+   struct irq_desc *desc
    , ...) {
+ unsigned int irqv = desc->irq;
  ... when != desc
      when strict
}

// -----------------------------------------------------------------------
// simplify definitions

@@
struct irq_desc *desc;
expression irq,E1,E2;
@@

desc = irq_to_desc(irq)
<...
- irq_to_desc(irq)
+ desc
...>
(
return;
|
desc = E1
|
?irq = E2
)

@@
identifier r.fn,irqv,desc,fld;
@@

fn(struct irq_desc *desc, ...) {
  unsigned int irqv = desc->irq;
  <...
(
- irq_to_desc(irqv)
+ desc
|
- irq_desc[irqv].fld
+ desc->fld
)
  ...>
}

@@
struct irq_desc *desc;
@@

- desc = desc;

@@
identifier r.fn,irqv,desc;
@@

fn(struct irq_desc *desc, ...) {
- unsigned int irqv = desc->irq;
  ... when != irqv
      when strict
}
