Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965434Ab2FAQWJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 12:22:09 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:16696 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965301Ab2FAQWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 12:22:07 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6729"; a="194516770"
From: David Brown <davidb@codeaurora.org>
To: Russell King <linux@arm.linux.org.uk>
Cc: David Brown <davidb@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Arnd Bergmann <arnd@arndb.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Jon Masters <jonathan@jonmasters.org>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Paulo Marques <pmarques@grupopie.com>,
        Eric Miao <eric.y.miao@gmail.com>
Subject: [PATCH] ARM: two possible fixes for the KALLSYMS build problem
Date: Fri,  1 Jun 2012 09:21:59 -0700
Message-Id: <1338567721-19514-1-git-send-email-davidb@codeaurora.org>
X-Mailer: git-send-email 1.7.10.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In trying to build numerous targets, I've managed to reproduce the
problem with KALLSYMS enough to come up with some ideas for a fix.
Neither of these fixes affects the size of the kernel.  I've compile
tested all of the defconfigs that are present in the kernel, and
neither causes any new compilation failures (several don't build).

The first fix adjusts the alignment of the per-cpu section, in the
cases where it is blank.  If it has the same alignment as the
following section, there won't be inconsistencies in the position when
the kallsyms data is inserted.

The second fix just eliminates the per_cpu section on non-smp builds.

Either case only affects the position of an empty section, and should
have no effect on the position or size of anything else.

I think the second patch (eliminate the per-cpu section) is cleaner,
but I'm concerned about something I've missed or changed.

The second patch does make the per-cpu section smaller (since some
symbols are left out).  It also affects the position of init_end, and
may need a page alignment before it.  But, this would also suggest
that currently, on SMP, there might be a page that isn't being freed.

David Brown (1):
  ARM: Prevent KALLSYM size mismatch on ARM.

 arch/arm/kernel/vmlinux.lds.S |    3 +++
 1 file changed, 3 insertions(+)

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

