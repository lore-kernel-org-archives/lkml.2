Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758584Ab1EZXi0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 19:38:26 -0400
Received: from usindmx04.hds.com ([207.126.252.15]:58195 "EHLO
	usindmx04.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757296Ab1EZXiZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 19:38:25 -0400
From: Satoru Moriya <satoru.moriya@hds.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        Seiji Aguchi <seiji.aguchi@hds.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>
Date: Thu, 26 May 2011 19:38:04 -0400
Subject: [PATCH][BUGFIX] param: fix return value handling in param_set_*
Thread-Topic: [PATCH][BUGFIX] param: fix return value handling in param_set_*
Thread-Index: Acwb/fUcfdmon40CRpCuD+WuMIwIew==
Message-ID: <65795E11DBF1E645A09CEC7EAEE94B9C3FF808C5@USINDEVS02.corp.hds.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ja-JP, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In STANDARD_PARAM_DEF, param_set_* handles the case in which strtolfn
returns -EINVAL but it may return -ERANGE. If it returns -ERANGE,
param_set_* may set uninitialized value to the paramerter. We should handle
both cases.

The one of the cases in which strtolfn() returns -ERANGE is following:

 *Type of module parameter is long
 *Set the parameter more than LONG_MAX

Signed-off-by: Satoru Moriya <satoru.moriya@hds.com>
---
 kernel/params.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/params.c b/kernel/params.c
index ed72e13..2a4ba25 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -225,8 +225,8 @@ int parse_args(const char *name,
 		int ret;						\
 									\
 		ret = strtolfn(val, 0, &l);				\
-		if (ret == -EINVAL || ((type)l != l))			\
-			return -EINVAL;					\
+		if (ret < 0 || ((type)l != l))				\
+			return ret < 0 ? ret : -EINVAL;			\
 		*((type *)kp->arg) = l;					\
 		return 0;						\
 	}
