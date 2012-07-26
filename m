Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752779Ab2GZPUy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 11:20:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38243 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752704Ab2GZPUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 11:20:53 -0400
Date: Thu, 26 Jul 2012 08:19:55 -0700
From: tip-bot for Julia Lawall <Julia.Lawall@lip6.fr>
Message-ID: <tip-41fb433b63cc4745f4918fdaf295763da5ca826c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        Julia.Lawall@lip6.fr, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        Julia.Lawall@lip6.fr, tglx@linutronix.de
In-Reply-To: <1342284188-19176-7-git-send-email-Julia.Lawall@lip6.fr>
References: <1342284188-19176-7-git-send-email-Julia.Lawall@lip6.fr>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] arch/x86/kernel/kdebugfs.c:
  Ensure a consistent return value in error case
Git-Commit-ID: 41fb433b63cc4745f4918fdaf295763da5ca826c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 26 Jul 2012 08:20:02 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  41fb433b63cc4745f4918fdaf295763da5ca826c
Gitweb:     http://git.kernel.org/tip/41fb433b63cc4745f4918fdaf295763da5ca826c
Author:     Julia Lawall <Julia.Lawall@lip6.fr>
AuthorDate: Sat, 14 Jul 2012 18:43:08 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 26 Jul 2012 15:07:20 +0200

arch/x86/kernel/kdebugfs.c: Ensure a consistent return value in error case

Typically, the return value desired for the failure of a
function with an integer return value is a negative integer.  In
these cases, the return value is sometimes a negative integer
and sometimes 0, due to a subsequent initialization of the
return variable within the loop.

A simplified version of the semantic match that finds this
problem is: (http://coccinelle.lip6.fr/)

//<smpl>
@r exists@
identifier ret;
position p;
constant C;
expression e1,e3,e4;
statement S;
@@

ret = -C
... when != ret = e3
    when any
if@p (...) S
... when any
if (\(ret != 0\|ret < 0\|ret > 0\) || ...) { ... return ...; }
... when != ret = e3
    when any
*if@p (...)
{
  ... when != ret = e4
  return ret;
}
//</smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
Link: http://lkml.kernel.org/r/1342284188-19176-7-git-send-email-Julia.Lawall@lip6.fr
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/kdebugfs.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/kdebugfs.c b/arch/x86/kernel/kdebugfs.c
index 1d5d31e..dc1404b 100644
--- a/arch/x86/kernel/kdebugfs.c
+++ b/arch/x86/kernel/kdebugfs.c
@@ -107,7 +107,7 @@ static int __init create_setup_data_nodes(struct dentry *parent)
 {
 	struct setup_data_node *node;
 	struct setup_data *data;
-	int error = -ENOMEM;
+	int error;
 	struct dentry *d;
 	struct page *pg;
 	u64 pa_data;
@@ -121,8 +121,10 @@ static int __init create_setup_data_nodes(struct dentry *parent)
 
 	while (pa_data) {
 		node = kmalloc(sizeof(*node), GFP_KERNEL);
-		if (!node)
+		if (!node) {
+			error = -ENOMEM;
 			goto err_dir;
+		}
 
 		pg = pfn_to_page((pa_data+sizeof(*data)-1) >> PAGE_SHIFT);
 		if (PageHighMem(pg)) {
