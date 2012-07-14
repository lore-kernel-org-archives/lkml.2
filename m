Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754230Ab2GNQnY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2012 12:43:24 -0400
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:17419
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750838Ab2GNQnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2012 12:43:17 -0400
X-IronPort-AV: E=Sophos;i="4.77,584,1336341600"; 
   d="scan'208";a="150655453"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org
Subject: [PATCH 0/6] ensure a consistent return value in error case
Date: Sat, 14 Jul 2012 18:43:02 +0200
Message-Id: <1342284188-19176-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Typically, the return value desired for the failure of a function with an
integer return value is a negative integer.  In these cases, the return
value is sometimes a negative integer and sometimes 0, due to a subsequent
initialization of the return variable within the loop.

The semantic match that finds this problem is:
(http://coccinelle.lip6.fr/)

//<smpl>
@r exists@
identifier ret;
position p;
constant C;
expression e1,e2,e3,e4;
@@

ret = -C
... when != ret = e1
    when != ret += e1
    when any
if@p (...)
{
  ... when != ret = e2
      when != ret + e2
  return ret;
}
... when any
if (\(ret != 0\|ret < 0\|ret > 0\) || ...)
{
  ...
  return ...;
}
... when != ret = e3
    when != ret += e3
    when any
if@p (...)
{
  ... when != ret = e4
      when != ret += e4
  return ret;
}

@@
identifier r.ret;
position r.p;
statement S;
@@

(
if@p (<+...ret...+>) S
|
*if@p (...) S
)
//</smpl>

