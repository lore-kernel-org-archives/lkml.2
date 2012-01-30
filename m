Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752429Ab2A3LGH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 06:06:07 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:60701 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751794Ab2A3LGD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 06:06:03 -0500
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: David Airlie <airlied@linux.ie>
Cc: kernel-janitors@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] initialize all fields
Date: Mon, 30 Jan 2012 12:05:54 +0100
Message-Id: <1327921555-7862-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a case where a structure field is not initialized before
the structureis copied to user level.

The semantic match that finds this problem is as follows
(http://coccinelle.lip6.fr/).  It uses other references to the same
structure in the current file to find the set of fields that should be
initialized.

@a disable decl_init@
identifier x,x1;
type T,T1;
expression e,sz;
@@

T x;
... when any
copy_to_user(e,&x,sz)

@r@
a.T y;
identifier f,f1,f2;
@@

(
y.f1[...]
|
y.f1.f2
|
y.f
)

@b@
identifier a.x,r.f;
type a.T;
expression e,e1,sz;
position p,p0;
@@

T x@p0;
... when != x.f = e1
    when != &x
    when != &(x.f)
    when != get_user(x.f,...)
    when != __get_user(x.f,...)
    when != x = e1
copy_to_user@p(e,&x,sz)

@script:ocaml@
t << a.T;
x << a.x;
f << r.f;
p << b.p;
@@

Printf.printf "%s:%d: %s %s missing %s\n" (List.hd p).file (List.hd p).line
   t x f

