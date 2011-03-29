Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753507Ab1C2PtJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 11:49:09 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:18700 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751587Ab1C2PtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 11:49:07 -0400
Date: Tue, 29 Mar 2011 08:48:55 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: dedekind1@gmail.com
Cc: lkml <linux-kernel@vger.kernel.org>, linux-mtd@lists.infradead.org,
        Adrian Hunter <adrian.hunter@nokia.com>
Subject: [PATCH v2] ubifs: fix kconfig dependency warning
Message-Id: <20110329084855.0de29fff.randy.dunlap@oracle.com>
In-Reply-To: <1301411055.21445.13.camel@localhost>
References: <20110328134016.deb5d0c8.randy.dunlap@oracle.com>
	<1301382178.2816.69.camel@localhost>
	<4D91F432.2070406@oracle.com>
	<1301411055.21445.13.camel@localhost>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt358.oracle.com [141.146.40.158]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4D91FF6A.017D,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Mar 2011 18:04:15 +0300 Artem Bityutskiy wrote:

> On Tue, 2011-03-29 at 08:01 -0700, Randy Dunlap wrote:
> > On 03/29/11 00:02, Artem Bityutskiy wrote:
> > > On Mon, 2011-03-28 at 13:40 -0700, Randy Dunlap wrote:
> > >> From: Randy Dunlap <randy.dunlap@oracle.com>
> > >>
> > >> Fix another kconfig dependency warning, this time in ubifs.
> > >>
> > >> warning: (UBIFS_FS_DEBUG && LOCKDEP && LATENCYTOP) selects KALLSYMS_ALL which has unmet direct dependencies (DEBUG_KERNEL && KALLSYMS)
> > >>
> > >> Without this patch, we can have:
> > >> # CONFIG_KALLSYMS is not set
> > >> CONFIG_KALLSYMS_ALL=y
> > >> which is useless (does nothing unless KALLSYMS is enabled).
> > >>
> > >> However, ubifs builds successfully with or without this patch,
> > >> and it builds with this line completely deleted,
> > >> so what was this 'select' for?  Just developer convenience?
> > > 
> > > Well, here is the idea. You can compile UBIFS with debugging and without
> > > debugging. Without debugging the resulting ubifs.ko is much smaller, so
> > > some embedded people prefer it this way.
> > > 
> > > If you select debugging support, then we'll compile it a lot of
> > > assertions, self-checks, test-modes, extra error messages with detailed
> > > dumps. And we want to see stackdumps when errors or problems happen,
> > > this is why we select KALLSYMS_ALL.
> > > 
> > > So I guess instead we should do:
> > > 
> > > select KALLSYMS
> > > select KALLSYMS_ALL
> > 
> > Yes, that should do it.  Thanks for the explanation.
> 
> Will you submit a patch? Alternatively, I can make it myself. What is
> your preference?

Here's an updated patch.  But since KALLSYMS_ALL depends on DEBUG_KERNEL,
the lines above aren't quite sufficient and I don't care to select
DEBUG_KERNEL.

---
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix kconfig dependency warning in ubifs:

warning: (UBIFS_FS_DEBUG && LOCKDEP && LATENCYTOP) selects KALLSYMS_ALL which has unmet direct dependencies (DEBUG_KERNEL && KALLSYMS)

Without this patch, we can have:
# CONFIG_KALLSYMS is not set
CONFIG_KALLSYMS_ALL=y
which is useless (does nothing unless KALLSYMS is enabled).

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc:      Artem Bityutskiy <dedekind1@gmail.com>
Cc:      Adrian Hunter <adrian.hunter@nokia.com>
Cc:      linux-mtd@lists.infradead.org
---
 fs/ubifs/Kconfig |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- linux-next-20110328.orig/fs/ubifs/Kconfig
+++ linux-next-20110328/fs/ubifs/Kconfig
@@ -47,7 +47,8 @@ config UBIFS_FS_DEBUG
 	bool "Enable debugging support"
 	depends on UBIFS_FS
 	select DEBUG_FS
-	select KALLSYMS_ALL
+	select KALLSYMS
+	select KALLSYMS_ALL if DEBUG_KERNEL
 	help
 	  This option enables UBIFS debugging support. It makes sure various
 	  assertions, self-checks, debugging messages and test modes are compiled
