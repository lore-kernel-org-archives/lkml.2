Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753205Ab1ATFJp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 00:09:45 -0500
Received: from mga11.intel.com ([192.55.52.93]:38985 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751053Ab1ATFJp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 00:09:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,348,1291622400"; 
   d="scan'208";a="649067080"
Subject: Re: section mismatch in intel_idle
From: Shaohua Li <shaohua.li@intel.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: "Brown, Len" <len.brown@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20110120005329.24119041@stein>
References: <20110120005329.24119041@stein>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 20 Jan 2011 13:09:34 +0800
Message-ID: <1295500174.1949.911.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-01-20 at 07:53 +0800, Stefan Richter wrote:
> Hi,
> 
> this just showed up in 2.6.38-rc1:
> 
> WARNING: drivers/idle/built-in.o(.text+0x112): Section mismatch in reference from the function intel_idle_probe() to the variable .cpuinit.data:setup_broadcast_notifier
> The function intel_idle_probe() references
> the variable __cpuinitdata setup_broadcast_notifier.
> This is often because intel_idle_probe lacks a __cpuinitdata 
> annotation or the annotation of setup_broadcast_notifier is wrong.
> 
> WARNING: drivers/idle/built-in.o(.exit.text+0x2d): Section mismatch in reference from the function intel_idle_exit() to the variable .cpuinit.data:setup_broadcast_notifier
> The function __exit intel_idle_exit() references
> a variable __cpuinitdata setup_broadcast_notifier.
> This is often seen when error handling in the exit function
> uses functionality in the init path.
> The fix is often to remove the __cpuinitdata annotation of
> setup_broadcast_notifier so it may be used outside an init section.
Len, please add this to your tree.

Fix annotation warning.

Reported-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Signed-off-by: Shaohua Li <shaohua.li@intel.com>

diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
index 7acb32e..6a0ff5d 100644
--- a/drivers/idle/intel_idle.c
+++ b/drivers/idle/intel_idle.c
@@ -263,7 +263,7 @@ static void __setup_broadcast_timer(void *arg)
 	clockevents_notify(reason, &cpu);
 }
 
-static int __cpuinit setup_broadcast_cpuhp_notify(struct notifier_block *n,
+static int setup_broadcast_cpuhp_notify(struct notifier_block *n,
 		unsigned long action, void *hcpu)
 {
 	int hotcpu = (unsigned long)hcpu;
@@ -281,7 +281,7 @@ static int __cpuinit setup_broadcast_cpuhp_notify(struct notifier_block *n,
 	return NOTIFY_OK;
 }
 
-static struct notifier_block __cpuinitdata setup_broadcast_notifier = {
+static struct notifier_block setup_broadcast_notifier = {
 	.notifier_call = setup_broadcast_cpuhp_notify,
 };
 


