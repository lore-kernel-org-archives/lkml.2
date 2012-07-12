Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759330Ab2GLWgB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 18:36:01 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58752 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759297Ab2GLWf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 18:35:56 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Steven Rostedt <rostedt@goodmis.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [ 006/187] powerpc/ftrace: Do not trace restore_interrupts()
Date: Thu, 12 Jul 2012 15:32:42 -0700
Message-Id: <20120712191522.827473614@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120712191522.742634173@linuxfoundation.org>
References: <20120712192421.GA28926@kroah.com>
 <20120712191522.742634173@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt <rostedt@goodmis.org>

commit 2d773aa4810d4a612d1c879faacc38594cc3f841 upstream.

As I was adding code that affects all archs, I started testing function
tracer against PPC64 and found that it currently locks up with 3.4
kernel. I figured it was due to tracing a function that shouldn't be, so
I went through the following process to bisect to find the culprit:

 cat /debug/tracing/available_filter_functions > t
 num=`wc -l t`
 sed -ne "1,${num}p" t > t1
 let num=num+1
 sed -ne "${num},$p" t > t2
 cat t1 > /debug/tracing/set_ftrace_filter
 echo function /debug/tracing/current_tracer
 <failed? bisect t1, if not bisect t2>

It finally came down to this function: restore_interrupts()

I'm not sure why this locks up the system. It just seems to prevent
scheduling from occurring. Interrupts seem to still work, as I can ping
the box. But all user processes freeze.

When restore_interrupts() is not traced, function tracing works fine.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kernel/irq.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/kernel/irq.c
+++ b/arch/powerpc/kernel/irq.c
@@ -277,7 +277,7 @@ EXPORT_SYMBOL(arch_local_irq_restore);
  * NOTE: This is called with interrupts hard disabled but not marked
  * as such in paca->irq_happened, so we need to resync this.
  */
-void restore_interrupts(void)
+void notrace restore_interrupts(void)
 {
 	if (irqs_disabled()) {
 		local_paca->irq_happened |= PACA_IRQ_HARD_DIS;


