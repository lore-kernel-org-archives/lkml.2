Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756544Ab2GMX3Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 19:29:16 -0400
Received: from mx1.vsecurity.com ([209.67.252.12]:56898 "EHLO
	mx1.vsecurity.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756101Ab2GMX3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 19:29:14 -0400
X-Greylist: delayed 397 seconds by postgrey-1.27 at vger.kernel.org; Fri, 13 Jul 2012 19:29:14 EDT
Message-ID: <5000ADB7.7060307@vsecurity.com>
Date: Fri, 13 Jul 2012 19:22:31 -0400
From: Dan Rosenberg <drosenberg@vsecurity.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Stevie Trujillo <stevie.trujillo@gmail.com>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: kptr_restrict: pK-error in SysRq show-all-timers(Q)
References: <CAJiZuY2c1TVVGDxqSDSVC04t5KHK7k=ysJ99Bw6QKvEYdeWO3A@mail.gmail.com>
In-Reply-To: <CAJiZuY2c1TVVGDxqSDSVC04t5KHK7k=ysJ99Bw6QKvEYdeWO3A@mail.gmail.com>
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/26/2012 05:20 PM, Stevie Trujillo wrote:
> Hello,
>
> if I press ALT+SysRq+Q all the pointers are replaced with "pK-error" like this:
> [23153.208033]   .base:               pK-error
>
> with echo h > /proc/sysrq-trigger it works:
> [23107.776363]   .base:       ffff88023e60d540
>
> --
> Stevie Trujillo

The intent behind this behavior was to return "pK-error" in cases where the %pK
format specifier was used in interrupt context, because the CAP_SYSLOG check
wouldn't be meaningful.  Clearly this should only apply when kptr_restrict is
actually enabled though.

Signed-off-by: Dan Rosenberg <dan.j.rosenberg@gmail.com>
Cc: stable@vger.kernel.org
---
 lib/vsprintf.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index c3f36d41..598a73e 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -1030,7 +1030,8 @@ char *pointer(const char *fmt, char *buf, char *end, void *ptr,
 		 * %pK cannot be used in IRQ context because its test
 		 * for CAP_SYSLOG would be meaningless.
 		 */
-		if (in_irq() || in_serving_softirq() || in_nmi()) {
+		if (kptr_restrict && (in_irq() || in_serving_softirq() ||
+				      in_nmi())) {
 			if (spec.field_width == -1)
 				spec.field_width = default_width;
 			return string(buf, end, "pK-error", spec);

