Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754263Ab2HEJwp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2012 05:52:45 -0400
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:9379 "EHLO
	mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754193Ab2HEJwo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2012 05:52:44 -0400
X-IronPort-AV: E=Sophos;i="4.77,715,1336341600"; 
   d="scan'208";a="152465602"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org
Subject: [PATCH 0/6] fix error return code
Date: Sun,  5 Aug 2012 11:52:30 +0200
Message-Id: <1344160356-387-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches fix cases where the return code appears to be unintentially 0.

The complete semantic match that finds the problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@r@
identifier f;
expression ret,e;
constant C;
@@

f(...) { <+...
(
return -C;
|
ret = -C
... when != ret = e
return ret;
|
if (ret < 0) { ... return ret; }
)
...+> }

@s@
identifier r.f,ret;
@@

f(...) { <+... return ret; ...+> }

@@
identifier r.f,s.ret;
expression e,e1,e2,e3,e4,x;
@@

f(...) { <+...
(
if (\(ret != 0\|ret < 0\) || ...) { ... return ...; }
|
ret = 0
)
... when != ret = e1
*x = \(kmalloc\|kzalloc\|kcalloc\|devm_kzalloc\|ioremap\|ioremap_nocache\|devm_ioremap\|devm_ioremap_nocache\)(...);
... when != x = e2
    when != ret = e3
*if (x == NULL || ...)
{
  ... when != ret = e4
*  return ret;
}
...+> }
// </smpl>

