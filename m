Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757697Ab2HPBir (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 21:38:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16041 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757680Ab2HPBio (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 21:38:44 -0400
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 24/25] MODSIGN: Allow modules to be signed with an unknown key
 unless enforcing
To: rusty@rustcorp.com.au
Cc: dhowells@redhat.com, dmitry.kasatkin@intel.com, zohar@linux.vnet.ibm.com,
        jmorris@namei.org, keyrings@linux-nfs.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 16 Aug 2012 02:38:34 +0100
Message-ID: <20120816013834.872.7280.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120816013405.872.42381.stgit@warthog.procyon.org.uk>
References: <20120816013405.872.42381.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently we fail the loading of modules that are signed with a public key
that is not in the modsign keyring even if we are not in enforcing mode.
This is somewhat at odds with the fact that we allow a completely unsigned
module to load in such a case.

We should allow modules signed with an unknown key to load in cases
where we are not enforcing and not in FIPS mode.

Signed-off-by: Josh Boyer <jwboyer@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 kernel/module-verify.c |    7 +++++++
 1 file changed, 7 insertions(+)


diff --git a/kernel/module-verify.c b/kernel/module-verify.c
index 070d730..c02d2e5 100644
--- a/kernel/module-verify.c
+++ b/kernel/module-verify.c
@@ -124,6 +124,13 @@ int module_verify(const void *data, size_t size, bool *_gpgsig_ok)
 		break;
 	case -ENOKEY:		/* Signed, but we don't have the public key */
 		pr_err("Module signed with unknown public key\n");
+		if (!modsign_signedonly) {
+			/* Allow a module to be signed with an unknown public
+			 * key unless we're enforcing.
+			 */
+			pr_info("Allowing\n");
+			ret = 0;
+		}
 		break;
 	default:		/* Other error (probably ENOMEM) */
 		break;

