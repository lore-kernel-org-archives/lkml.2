Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753922Ab3AGJAd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 04:00:33 -0500
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:53122 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753297Ab3AGJAc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 04:00:32 -0500
X-IronPort-AV: E=Sophos;i="4.84,423,1355094000"; 
   d="scan'208";a="188679763"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org
Subject: [PATCH 0/2] reposition free_irq to avoid access to invalid data
Date: Mon,  7 Jan 2013 11:00:14 +0100
Message-Id: <1357552816-6046-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The data referenced by an interrupt handler should not be freed before the
interrupt is ended.

The semantic match that finds this problem is as follows
(http://coccinelle.lip6.fr/).  The basic idea behind this semantic match is
to find cases where the order of the call to free_irq is different than its
order in some error-handling code.  This semantic match, however, has a
high rate of false positives, because most of the time the order doesn't
seem to matter.

// <smpl>
@fn exists@
expression list es;
expression a,b;
identifier f;
@@

if (...) {
  ... when any
  free_irq(a,b);
  ... when any
  f(es);
  ... when any
  return ...;
}

@@
expression list fn.es;
expression fn.a,fn.b;
identifier fn.f;
@@

*f(es);
... when any
*free_irq(a,b);
// </smpl>

