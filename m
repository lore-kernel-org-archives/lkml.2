Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836Ab2HSIoo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 04:44:44 -0400
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:52549 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751938Ab2HSIoi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 04:44:38 -0400
X-IronPort-AV: E=Sophos;i="4.77,792,1336341600"; 
   d="scan'208";a="170216891"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org
Subject: [PATCH 0/14] fix error return code
Date: Sun, 19 Aug 2012 10:44:16 +0200
Message-Id: <1345365870-29831-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches fix cases where the return code appears to be unintentially
nonnegative.

The complete semantic match that finds the problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@ok exists@
identifier f,ret,i;
expression e;
constant c;
@@

f(...) {
<+...
(
return -c@i;
|
ret = -c@i;
... when != ret = e
return ret;
|
if (ret < 0) { ... return ret; }
)
...+> }

@r exists@
identifier ret,l,ok.f;
expression e1,e2,e3;
statement S;
position p1,p2,p3;
@@

f(...) {
... when any
(
if@p1 (\(ret < 0\|ret != 0\))
 { ... return ret; }
|
ret@p1 = 0
)
... when != ret = e1
    when != &ret
(
 if (<+... ret = e3 ...+>) S
|
 if (<+... &ret ...+>) S
|
if@p2(...)
 {
  ... when != ret = e2
      when forall
 return@p3 ret;
}
)
... when any
}

@bad exists@
position r.p1,r.p2;
statement S1,S2;
identifier r.ret;
expression e1;
@@

(
if@p1 (\(ret < 0\|ret != 0\)) S1
|
ret@p1 = 0
)
... when any
ret = e1
... when any
if@p2(...) S2

@bad2@
position r.p1,r.p2;
identifier r.ret;
expression e1;
statement S2;
@@

ret@p1 = 0
... when != if (...) { ... ret = e1 ... return ret; }
    when any
if@p2(...) S2


@script:python depends on !bad && !bad2@
p1 << r.p1;
p2 << r.p2;
p3 << r.p3;
@@

cocci.print_main("",p1)
cocci.print_secs("",p2)
cocci.print_secs("",p3)
// </smpl>

