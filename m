Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752271Ab2KCK6r (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2012 06:58:47 -0400
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:11958
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750846Ab2KCK6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2012 06:58:46 -0400
X-IronPort-AV: E=Sophos;i="4.80,705,1344204000"; 
   d="scan'208";a="161245661"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org
Subject: [PATCH 0/16] use WARN
Date: Sat,  3 Nov 2012 11:58:21 +0100
Message-Id: <1351940317-14812-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches use WARN, which combines printk and WARN_ON(1), or WARN_ONCE,
which combines printk and WARN_ON_ONCE(1).  This does not appear to affect
the behavior, but makes the code a little more concise.

The semantic patch that makes this transformation is as follows
(http://coccinelle.lip6.fr/).  In particular, it only transforms the case
where the WARN_ON or WARN_ON_ONCE is preceded by a single printk.

// <smpl>
@bad1@
position p;
@@

printk(...);
printk@p(...);
WARN_ON(1);

@ok1@
expression list es;
position p != bad1.p;
@@

-printk@p(
+WARN(1,
  es);
-WARN_ON(1);

@@
expression list ok1.es;
@@

if (...)
- {
  WARN(1,es);
- }

@bad2@
position p;
@@

printk(...);
printk@p(...);
WARN_ON_ONCE(1);

@ok2@
expression list es;
position p != bad2.p;
@@

-printk@p(
+WARN_ONCE(1,
  es);
-WARN_ON_ONCE(1);

@@
expression list ok2.es;
@@

if (...)
- {
  WARN_ONCE(1,es);
- }
// </smpl>

