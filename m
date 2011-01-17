Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752859Ab1AQT34 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 14:29:56 -0500
Received: from ausc60ps301.us.dell.com ([143.166.148.206]:38725 "EHLO
	ausc60ps301.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752603Ab1AQT3w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 14:29:52 -0500
X-Loopcount0: from 10.175.216.249
From: <Narendra_K@Dell.com>
To: <sfr@canb.auug.org.au>
CC: <jbarnes@virtuousgeek.org>, <lenb@kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-next@vger.kernel.org>,
        <Matt_Domsch@Dell.com>, <Charles_Rose@Dell.com>,
        <Surya_Prabhakar@Dell.com>
Date: Mon, 17 Jan 2011 11:28:48 -0800
Subject: Re: [PATCH] Fix build failure when CONFIG_NLS is set to 'm' by
 allmodconfig
Thread-Topic: [PATCH] Fix build failure when CONFIG_NLS is set to 'm' by
 allmodconfig
Thread-Index: Acu2fMNkSiSL+anbQq2xKrcgSlLe3A==
Message-ID: <20110117195215.GA2708@fedora14-r610.oslab.blr.amer.dell.com>
References: <20110112203414.GA5657@fedora14-r610.oslab.blr.amer.dell.com>
 <20110112160229.7b8d82c1@jbarnes-desktop>
 <alpine.LFD.2.02.1101122217370.19754@x980>
 <20110113075556.789ac3c3@jbarnes-vaio.home>
 <20110113162755.GA5872@fedora14-r610.oslab.blr.amer.dell.com>
 <20110114154458.GA18289@fedora14-r610.oslab.blr.amer.dell.com>
 <20110115080949.62176a3c.sfr@canb.auug.org.au>
In-Reply-To: <20110115080949.62176a3c.sfr@canb.auug.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mutt/1.5.21 (2010-09-15)
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 15, 2011 at 02:39:49AM +0530, Stephen Rothwell wrote:
> Hi Narendra,
> 
> On Fri, 14 Jan 2011 20:52:42 +0530 <Narendra_K@Dell.com> wrote:
> >
> > This patch addresses the build failure described in this thread by
> > compiling fs/nls/nls_base.c always into vmlinux, thus making the base
> > nls functions available always.
> 
> Even on platforms that don't support ACPI or DMI ...
> 
> > From: Narendra K <narendra_k@dell.com>
> > Subject: [PATCH] Fix build failure when CONFIG_NLS is set to 'm' by allmodconfig
> > 
> > This patch fixes the following build breakage introduced by the patch
> > PCI:export ACPI _DSM provided firmware instance number and string to sysfs.
> > (previously commit a6247cd4be20cb5439db5cb7b0b6cc67fdc8e2a2).
> > 
> > http://marc.info/?l=linux-pci&m=129313294112736&w=1
> > 
> > drivers/built-in.o: In function `T.647':
> > pci-label.c:(.text+0x28514): undefined reference to `utf16s_to_utf8s'
> > 
> > This happens because 'make allmodconfig' sets CONFIG_NLS=m and makes
> > 'utf16s_to_utf8s` unavailable to drivers/pci/pci-label.o which is built
> > into vmlinux.
> > 
> > This is fixed by making fs/nls/nls_base.c always compile as part of
> > vmlinux thus making the base nls functions available always.
> > +++ b/fs/nls/Makefile
> > @@ -2,7 +2,7 @@
> >  # Makefile for native language support
> >  #
> >  
> > -obj-$(CONFIG_NLS)		+= nls_base.o
> > +obj-y				+= nls_base.o
> 
> You should really restrict this to CONFIG_ACPI || CONFIG_DMI ||
> CONFIG_NLS ... maybe create a CONFIG_NLS_BASE that is selected by ACPI,
> DMI and NLS?

Hi Stephen,

Thank you for the suggestions. 

I agree with your suggestion that we should compile nls_base.o
conditionally, only when ACPI || DMI || NLS. I have introduced a bew
config option CONFIG_NLS_BASE and made ACPI, DMI and NLS select it.

V1 -> V2:

1. Conditionally compile fs/nls/nls_base.c by introducing a new config
option CONFIG_NLS_BASE, which is selected by (ACPI || DMI || NLS).
Behavior of the rest of the files under fs/nls is not changed.

From: Narendra K <narendra_k@dell.com>
Subject: [PATCH V2] Fix build failure when CONFIG_NLS is set to 'm' by allmodconfig

This patch fixes the following build breakage introduced by the patch
PCI:export ACPI _DSM provided firmware instance number and string to sysfs.
(previously commit a6247cd4be20cb5439db5cb7b0b6cc67fdc8e2a2).

http://marc.info/?l=linux-pci&m=129313294112736&w=1

drivers/built-in.o: In function `T.647':
pci-label.c:(.text+0x28514): undefined reference to `utf16s_to_utf8s'

This happens because 'make allmodconfig' sets CONFIG_NLS=m and makes
'utf16s_to_utf8s` unavailable to drivers/pci/pci-label.o which is built
into vmlinux.

This is fixed by making fs/nls/nls_base.c compile conditionally into
vmlinux by introducing a new config option CONFIG_NLS_BASE which is
selected by (ACPI || DMI || NLS). This makes

Signed-off-by: Narendra K <narendra_k@dell.com>
---
 fs/Makefile     |    2 +-
 fs/nls/Kconfig  |   14 ++++++++++++++
 fs/nls/Makefile |    2 +-
 3 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/fs/Makefile b/fs/Makefile
index a7f7cef..1e78b9b 100644
--- a/fs/Makefile
+++ b/fs/Makefile
@@ -86,7 +86,7 @@ obj-$(CONFIG_NFS_FS)		+= nfs/
 obj-$(CONFIG_EXPORTFS)		+= exportfs/
 obj-$(CONFIG_NFSD)		+= nfsd/
 obj-$(CONFIG_LOCKD)		+= lockd/
-obj-$(CONFIG_NLS)		+= nls/
+obj-y				+= nls/
 obj-$(CONFIG_SYSV_FS)		+= sysv/
 obj-$(CONFIG_CIFS)		+= cifs/
 obj-$(CONFIG_NCP_FS)		+= ncpfs/
diff --git a/fs/nls/Kconfig b/fs/nls/Kconfig
index a39edc4..2fb92e5 100644
--- a/fs/nls/Kconfig
+++ b/fs/nls/Kconfig
@@ -4,6 +4,7 @@
 
 menuconfig NLS
 	tristate "Native language support"
+	select NLS_BASE
 	---help---
 	  The base Native Language Support. A number of filesystems
 	  depend on it (e.g. FAT, JOLIET, NT, BEOS filesystems), as well
@@ -17,6 +18,19 @@ menuconfig NLS
 
 if NLS
 
+config NLS_BASE
+	bool "Base NLS functions"
+	depends on ACPI || DMI
+	default y
+	---help---
+	  The base NLS support functions which handle unicode traslations.
+
+	  If unsure, say Y.
+
+	  This config option is selected by ACPI && DMI && NLS as the
+	  functions defined here are needed in vmlinux and if built as
+	  module cause build issues.
+
 config NLS_DEFAULT
 	string "Default NLS Option"
 	default "iso8859-1"
diff --git a/fs/nls/Makefile b/fs/nls/Makefile
index f499dd7..dde741f 100644
--- a/fs/nls/Makefile
+++ b/fs/nls/Makefile
@@ -2,7 +2,7 @@
 # Makefile for native language support
 #
 
-obj-$(CONFIG_NLS)		+= nls_base.o
+obj-$(CONFIG_NLS_BASE)		+= nls_base.o
 
 obj-$(CONFIG_NLS_CODEPAGE_437)	+= nls_cp437.o
 obj-$(CONFIG_NLS_CODEPAGE_737)	+= nls_cp737.o
-- 
1.7.3.1

With regards,
Narendra K