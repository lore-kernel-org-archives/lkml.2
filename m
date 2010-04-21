Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756175Ab0DUSiB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 14:38:01 -0400
Received: from smtp.outflux.net ([198.145.64.163]:40376 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756114Ab0DUSh7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 14:37:59 -0400
X-Greylist: delayed 515 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 Apr 2010 14:37:59 EDT
Date: Wed, 21 Apr 2010 11:29:11 -0700
From: Kees Cook <kees@canonical.com>
To: Kyle McMartin <kmcmartin@redhat.com>
Cc: eparis@redhat.com, cebbert@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] trivial: make mmap_min_addr perms 600
Message-ID: <20100421182911.GB13524@outflux.net>
References: <20100421140033.GA8389@ihatethathostname.lab.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100421140033.GA8389@ihatethathostname.lab.bos.redhat.com>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 21, 2010 at 10:00:33AM -0400, Kyle McMartin wrote:
> Chuck points out that mmap_min_addr is 644...
> CAP_SYS_RAWIO will deny users read/write to the file, let's let them see
> that this is intended.

Hmm.  Denying read is actually an unintended side-effect of the
CAP_SYS_RAWIO check.

The value is useful information for an admin to see without being root
("is my system vulnerable to kernel NULL pointer attacks?") and its
setting is trivially easy for an attacker to determine by calling mmap()
in PAGE_SIZE increments starting at 0.

I would opt for greater transparency for the admin, and leave it 644 and
instead more carefully check CAP_SYS_RAWIO.

Signed-off-by: Kees Cook <kees.cook@canonical.com>
---
 security/min_addr.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/security/min_addr.c b/security/min_addr.c
index e86f297..f728728 100644
--- a/security/min_addr.c
+++ b/security/min_addr.c
@@ -33,7 +33,7 @@ int mmap_min_addr_handler(struct ctl_table *table, int write,
 {
 	int ret;
 
-	if (!capable(CAP_SYS_RAWIO))
+	if (write && !capable(CAP_SYS_RAWIO))
 		return -EPERM;
 
 	ret = proc_doulongvec_minmax(table, write, buffer, lenp, ppos);
-- 
1.7.0.4


-- 
Kees Cook
Ubuntu Security Team
