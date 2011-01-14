Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757822Ab1ANPW4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 10:22:56 -0500
Received: from ausc60ps301.us.dell.com ([143.166.148.206]:12937 "EHLO
	ausc60ps301.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752081Ab1ANPWt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 10:22:49 -0500
X-Loopcount0: from 10.175.216.251
From: <Narendra_K@Dell.com>
To: <jbarnes@virtuousgeek.org>
CC: <lenb@kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-next@vger.kernel.org>, <sfr@canb.auug.org.au>,
        <Matt_Domsch@Dell.com>, <Charles_Rose@Dell.com>,
        <Surya_Prabhakar@Dell.com>
Date: Fri, 14 Jan 2011 20:52:42 +0530
Subject: [PATCH] Fix build failure when CONFIG_NLS is set to 'm' by
 allmodconfig
Thread-Topic: [PATCH] Fix build failure when CONFIG_NLS is set to 'm' by
 allmodconfig
Thread-Index: Acuz/uMeJyITrETuTaiDsh0qWTAk+Q==
Message-ID: <20110114154458.GA18289@fedora14-r610.oslab.blr.amer.dell.com>
References: <20110112203414.GA5657@fedora14-r610.oslab.blr.amer.dell.com>
 <20110112160229.7b8d82c1@jbarnes-desktop>
 <alpine.LFD.2.02.1101122217370.19754@x980>
 <20110113075556.789ac3c3@jbarnes-vaio.home>
 <20110113162755.GA5872@fedora14-r610.oslab.blr.amer.dell.com>
In-Reply-To: <20110113162755.GA5872@fedora14-r610.oslab.blr.amer.dell.com>
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

On Thu, Jan 13, 2011 at 09:33:56PM +0530, K, Narendra wrote:
> On Thu, Jan 13, 2011 at 09:25:56PM +0530, Jesse Barnes wrote:
> > On Wed, 12 Jan 2011 22:23:55 -0500 (EST)
> > Len Brown <lenb@kernel.org> wrote:
> > > > So there's no other ACPI code that depends on this function?  I'd hate
> > > > to make PCI depend on NLS, so assuming ACPI doesn't need it (in which
> > > > case the select or depend should be there), I guess it should be pulled
> > > > into a common file that will always be included.
> > > 
> > > No, nothing in the ACPI code uses utf16s_to_utf8s.
> > > 
> > > I don't know anything about NLS, but it appears to be
> > > something that file systems (befs, cifs, fat, hfs, isofs, jfs, etc)
> > > use to to support native languages.
> > > 
> > > BTW. I don't understand why pci-label.o appears twice above.
> > > It used to be just the 2nd one, that depends on CONFIG_DMI.
> > 
> > Ok, I'll drop this patch for now then since I haven't seen a fix yet
> > and need to get Linus the rest of the changes.
> 
> Jesse,
> 
> I just compile tested a fix on the following lines without any failure.
> If it is acceptable, i will send a patch in half an hour. It builds
> 

Hello,

This patch addresses the build failure described in this thread by
compiling fs/nls/nls_base.c always into vmlinux, thus making the base
nls functions available always.

Please consider this patch for inclusion if there are no concerns with
this approach.

From: Narendra K <narendra_k@dell.com>
Subject: [PATCH] Fix build failure when CONFIG_NLS is set to 'm' by allmodconfig

This patch fixes the following build breakage introduced by the patch
PCI:export ACPI _DSM provided firmware instance number and string to sysfs.
(previously commit a6247cd4be20cb5439db5cb7b0b6cc67fdc8e2a2).

http://marc.info/?l=linux-pci&m=129313294112736&w=1

drivers/built-in.o: In function `T.647':
pci-label.c:(.text+0x28514): undefined reference to `utf16s_to_utf8s'

This happens because 'make allmodconfig' sets CONFIG_NLS=m and makes
'utf16s_to_utf8s` unavailable to drivers/pci/pci-label.o which is built
into vmlinux.

This is fixed by making fs/nls/nls_base.c always compile as part of
vmlinux thus making the base nls functions available always.

Signed-off-by: Narendra K <narendra_k@dell.com>
---
 fs/Makefile     |    2 +-
 fs/nls/Makefile |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

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
diff --git a/fs/nls/Makefile b/fs/nls/Makefile
index f499dd7..c172fbb 100644
--- a/fs/nls/Makefile
+++ b/fs/nls/Makefile
@@ -2,7 +2,7 @@
 # Makefile for native language support
 #
 
-obj-$(CONFIG_NLS)		+= nls_base.o
+obj-y				+= nls_base.o
 
 obj-$(CONFIG_NLS_CODEPAGE_437)	+= nls_cp437.o
 obj-$(CONFIG_NLS_CODEPAGE_737)	+= nls_cp737.o
-- 
1.7.3.1

With regards,
Narendra K