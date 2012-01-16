Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756060Ab2APSsE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 13:48:04 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42707 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755801Ab2APSsB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 13:48:01 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Jan 16 10:45:17 2012
Message-Id: <20120116184517.042963719@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Mon, 16 Jan 2012 10:44:42 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, kvm@vger.kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>, Avi Kivity <avi@redhat.com>
Subject: [15/48] KVM guest: prevent tracing recursion with kvmclock
In-Reply-To: <20120116184527.GA11972@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Avi Kivity <avi@redhat.com>

(cherry picked from commit 95ef1e52922cf75b1ea2eae54ef886f2cc47eecb)

Prevent tracing of preempt_disable() in get_cpu_var() in
kvm_clock_read(). When CONFIG_DEBUG_PREEMPT is enabled,
preempt_disable/enable() are traced and this causes the function_graph
tracer to go into an infinite recursion. By open coding the
preempt_disable() around the get_cpu_var(), we can use the notrace
version which prevents preempt_disable/enable() from being traced and
prevents the recursion.

Based on a similar patch for Xen from Jeremy Fitzhardinge.

Tested-by: Gleb Natapov <gleb@redhat.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/x86/kernel/kvmclock.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -74,9 +74,10 @@ static cycle_t kvm_clock_read(void)
 	struct pvclock_vcpu_time_info *src;
 	cycle_t ret;
 
-	src = &get_cpu_var(hv_clock);
+	preempt_disable_notrace();
+	src = &__get_cpu_var(hv_clock);
 	ret = pvclock_clocksource_read(src);
-	put_cpu_var(hv_clock);
+	preempt_enable_notrace();
 	return ret;
 }
 


