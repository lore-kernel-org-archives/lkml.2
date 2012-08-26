Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487Ab2HZQBP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2012 12:01:15 -0400
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:56799
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751970Ab2HZQBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2012 12:01:13 -0400
X-IronPort-AV: E=Sophos;i="4.80,315,1344204000"; 
   d="scan'208";a="153852285"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org
Subject: [PATCH 0/13] use clk_prepare_enable and clk_disable_unprepare
Date: Sun, 26 Aug 2012 18:00:52 +0200
Message-Id: <1345996865-32082-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clk_prepare_enable and clk_disable_unprepare combine clk_prepare and
clk_enable, and clk_disable and clk_unprepare.  They make the code more
concise, and ensure that clk_unprepare is called when clk_enable fails.

The transformation is made using the following semantic patch
(http://coccinelle.lip6.fr/).  This semantic patch is not really safe, in
that it doesn't check for clk_disable's that are relying on the removed
clk_unprepare's.  These cases have been adjusted by hand.

// <smpl>
@@
expression e;
@@

- clk_prepare(e);
- clk_enable(e);
+ clk_prepare_enable(e);

@@
expression e;
identifier r;
statement S;
@@

- r = clk_prepare(e); if (r) S
- clk_enable(e);
+ r = clk_prepare_enable(e); if (r) S

@@
expression e;
expression r;
@@

- clk_prepare(e);
  r =
- clk_enable
+ clk_prepare_enable
  (e);
  if (r) { ...
- clk_unprepare(e); // unsafe!
  ...
  return ...;
  }

@@
expression e;
expression r;
@@

- clk_prepare(e);
  r =
- clk_enable
+ clk_prepare_enable
  (e);

@@
expression e;
statement S;
@@

- if (clk_prepare(e)) S
- clk_enable(e);
+ if (clk_prepare_enable(e)) S

@@
expression e;
@@

- clk_prepare(e);
  if (
- clk_enable(e)
+ clk_prepare_enable(e)
  ) { ...
- clk_unprepare(e); // unsafe!
  ...
  return ...;
  }

@@
expression e;
statement S;
@@

- clk_prepare(e);
  if (
- clk_enable(e)
+ clk_prepare_enable(e)
  ) S

@@
expression e,r2;
identifier r1;
statement S;
@@

- r1 = clk_prepare(e); if (r1) S
  r2 =
-  clk_enable
+  clk_prepare_enable
   (e);
  if (r2) { ...
- clk_unprepare(e); // unsafe!
  ...
  return ...;
  }

@@
expression e,r2;
identifier r1;
statement S;
@@

- r1 = clk_prepare(e); if (r1) S
  r2 =
-  clk_enable
+  clk_prepare_enable
   (e);

@@
expression e;
statement S1;
@@

- if (clk_prepare(e)) S1
  if (
-  clk_enable
+  clk_prepare_enable
     (e)) { ...
- clk_unprepare(e); // unsafe!
  ...
  return ...;
  }

@@
expression e;
statement S1,S2;
@@

- if (clk_prepare(e)) S1
  if (
-  clk_enable
+  clk_prepare_enable
     (e)) S2

@@
expression e;
@@

- clk_disable(e);
- clk_unprepare(e);
+ clk_disable_unprepare(e);
// </smpl>

