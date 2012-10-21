Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752737Ab2JUKwN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 06:52:13 -0400
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:62022
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752401Ab2JUKwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 06:52:12 -0400
X-IronPort-AV: E=Sophos;i="4.80,625,1344204000"; 
   d="scan'208";a="159799678"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org
Subject: [PATCH 0/5] eliminate possible double free
Date: Sun, 21 Oct 2012 12:52:02 +0200
Message-Id: <1350816727-1381-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches fix cases where a called function frees some data and the
calling context frees the same data.

The complete semantic match is as follows: (http://coccinelle.lip6.fr/)

// <smpl>
@r exists@
parameter list[n] ps;
type T;
identifier a;
expression e;
expression ret != 0;
identifier f,free;
position p1;
@@

f(ps,T a,...) {
  ... when any
      when != a = e
  if(...) { ... free@p1(a); ... return ret; }
  ... when any
}

@s exists@
identifier r.f,r.free;
expression x,a;
position p2,p3;
expression list[r.n] xs;
@@

x = f@p2(xs,a,...);
if (...) { ... free@p3(a); ... return ...; }

@script:python@
p1 << r.p1;
p2 << s.p2;
p3 << s.p3;
@@

cocci.print_main("",p1)
cocci.print_secs("",p2)
cocci.print_secs("",p3)
// </smpl>

