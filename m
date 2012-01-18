Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757295Ab2ARJk1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 04:40:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9313 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757104Ab2ARJkX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 04:40:23 -0500
Date: Wed, 18 Jan 2012 10:38:19 +0100
From: Andrew Jones <drjones@redhat.com>
To: David Rientjes <rientjes@google.com>
Cc: Jerome Marchand <jmarchan@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org, mingo@elte.hu,
        david.woodhouse@intel.com, gregkh@suse.de, davem@davemloft.net,
        axboe@kernel.dk, holt@sgi.com, linux-arch@vger.kernel.org,
        linux@arm.linux.org.uk, hskinnemoen@gmail.com, egtvedt@samfundet.no,
        msalter@redhat.com, a-jacquiot@ti.com, starvik@axis.com,
        jesper.nilsson@axis.com, dhowells@redhat.com, takata@linux-m32r.org,
        geert@linux-m68k.org, yasutake.koichi@jp.panasonic.com,
        jonas@southpole.se, kyle@mcmartin.ca, deller@gmx.de,
        jejb@parisc-linux.org, chris@zankel.net, greg@kroah.com,
        davej@redhat.com, airlied@linux.ie, jkosina@suse.cz,
        mchehab@infradead.org, johannes@sipsolutions.net,
        linville@tuxdriver.com
Subject: Re: [PATCH] kconfig: untangle EXPERT and EMBEDDED
Message-ID: <20120118093818.GC2317@turtle.usersys.redhat.com>
References: <20120112101805.GA2375@turtle.usersys.redhat.com>
 <alpine.DEB.2.00.1201121259270.17287@chino.kir.corp.google.com>
 <20120113085125.GA2452@turtle.usersys.redhat.com>
 <alpine.DEB.2.00.1201130230320.15417@chino.kir.corp.google.com>
 <20120113122202.GB2452@turtle.usersys.redhat.com>
 <alpine.DEB.2.00.1201131318340.24089@chino.kir.corp.google.com>
 <4F1442C5.70500@redhat.com>
 <alpine.DEB.2.00.1201161530170.16270@chino.kir.corp.google.com>
 <20120117144644.GC3188@turtle.usersys.redhat.com>
 <alpine.DEB.2.00.1201171246280.2595@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1201171246280.2595@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 17, 2012 at 12:54:01PM -0800, David Rientjes wrote:
> When it's configurable only for CONFIG_EMBEDDED, then you can propose that 
> to the HID maintainers.  If they agree, then we don't care if users 
> currently with CONFIG_EXPERT=y and CONFIG_EMBEDDED=n lose the option, but 
> that needs to be handled on a case-by-case basis when breaking backwards 
> compatibility.
> 

Ah, I think I may have just gotten to the bottom of this long, useless
thread. Based on your last email and by rereading what you wrote above.
You seem to believe a patch like

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 82928f5..ec1023d 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -771,7 +771,7 @@ config DEBUG_WRITECOUNT

 config DEBUG_MEMORY_INIT
        bool "Debug memory initialisation" if EXPERT
-       default !EXPERT
+       default !EMBEDDED
        help
          Enable this for additional checks during memory initialisation.
          The sanity checks verify aspects of the VM such as the memory
model

means that configs with CONFIG_EXPERT=y and CONFIG_EMBEDDED=n would then
generate kernels that no longer have the additional memory checks. Those
checks are generally a good thing, and in fact the config help for that
option says "If unsure, say Y". So a general kernel, using the general
kernel option, EXPERT, but not the specific option, EMBEDDED, would be
upset when losing that option.

Your problem is that your logic is backwards. The kernel right now has
precisely that issue, due to 6a108a14fa35. If EXPERT is on, then you'll
lose DEBUG_MEMORY_INIT. That, and all the other silently changed defaults,
is exactly what this patch fixes.

Please review the logic and the entire patch again.
