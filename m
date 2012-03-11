Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752253Ab2CKThM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 15:37:12 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:50201 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751515Ab2CKTgf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 15:36:35 -0400
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org
Subject: [PATCH 0/7] ensure arguments to request_irq and free_irq are compatible
Date: Sun, 11 Mar 2012 20:36:20 +0100
Message-Id: <1331494587-12196-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As far as I can see, free_irq does nothing if its second argument is not
the same as the last argument of the corresponding call to request_irq.
These were found using the semantic match below (http://coccinelle.lip6.fr/).
This semantic match finds a number of other cases, but they are mostly in
platform driver probe functions, so the functions should be just converted
to use devm functions, eliminating the need to call free_irq at all.

// <smpl>
@r exists@
expression e,e1,e2,e3,e4,e5;
type T;
position p1,p2;
@@

request_irq@p1(e1,e2,e3,e4,e5)
...
(
 free_irq(e1,(T)e5);
|
free_irq@p2(e1,e);
)

@bad1 exists@
position r.p1,r.p2;
expression e1,e2,e3,e4,e5;
@@

request_irq@p1(e1,e2,e3,e4,(void *)e5)
...
free_irq@p2(e1,e5);

@bad2 exists@
position r.p1,r.p2;
statement S;
@@

if (request_irq@p1(...)) S else { <+... free_irq@p2(...); ...+> }

@script:python depends on !bad1 && !bad2@
p1 << r.p1;
p2 << r.p2;
@@

cocci.print_main("",p1)
cocci.print_secs("",p2)
// </smpl>

