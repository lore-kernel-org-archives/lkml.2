Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932626Ab0EFUsl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 16:48:41 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:52713 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932583Ab0EFUsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 16:48:39 -0400
Subject: Re: kbuild: fixing the select problem
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-arch@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>, linux-kbuild@vger.kernel.org,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Vegard Nossum <vegard.nossum@gmail.com>
In-Reply-To: <1273157554.23208.69.camel@mulgrave.site>
References: <1273096160.23208.35.camel@mulgrave.site>
	 <4BE2D10D.4070706@suse.cz>  <1273157554.23208.69.camel@mulgrave.site>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 06 May 2010 15:48:35 -0500
Message-ID: <1273178915.2881.20.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-05-06 at 09:52 -0500, James Bottomley wrote:
> The list is
> 
> USB_ARCH_HAS_HCD has 4 defaults
> DEFCONFIG_LIST has 5 defaults
> MAC80211_RC_DEFAULT has 2 defaults
> X86_L1_CACHE_SHIFT has 2 defaults
> SPLIT_PTLOCK_CPUS has 2 defaults
> X86_MINIMUM_CPU_FAMILY has 3 defaults
> DEFAULT_TCP_CONG has 2 defaults
> DEFCONFIG_LIST has 5 defaults
> USB_ARCH_HAS_HCD has 4 defaults
> X86_L1_CACHE_SHIFT has 2 defaults
> X86_MINIMUM_CPU_FAMILY has 3 defaults
> SPLIT_PTLOCK_CPUS has 2 defaults
> DEFAULT_TCP_CONG has 2 defaults
> MAC80211_RC_DEFAULT has 2 defaults

Here's a patch that alters the default processing to the needed form and
checks the old vs new values.  I've been running randconfigs but I can't
get the warning to trip ... have at it.

James

---

diff --git a/scripts/kconfig/symbol.c b/scripts/kconfig/symbol.c
index 6c8fbbb..722bc4e 100644
--- a/scripts/kconfig/symbol.c
+++ b/scripts/kconfig/symbol.c
@@ -115,14 +115,31 @@ struct property *sym_get_env_prop(struct symbol *sym)
 
 struct property *sym_get_default_prop(struct symbol *sym)
 {
-	struct property *prop;
+	struct property *prop, *ret = NULL;
+	tristate old_val = no, val = no;
 
 	for_all_defaults(sym, prop) {
 		prop->visible.tri = expr_calc_value(prop->visible.expr);
-		if (prop->visible.tri != no)
-			return prop;
+		if (prop->visible.tri != no) {
+			tristate v = expr_calc_value(prop->expr);
+			if (!ret)
+				old_val = v;
+			if (v >= val) {
+				val = v;
+				ret = prop;
+			}
+		}
 	}
-	return NULL;
+	/*
+	 * Previously, we took the first valid default we found (this
+	 * is now old_val).  In the new scheme, the value is the or of
+	 * all the defaults.
+	 */
+	if (old_val != val)
+		menu_warn(ret->menu, "ERROR: new parser has inconsistent "
+			  "values for %s (%d != %d)\n", sym->name,
+			  old_val, val);
+	return ret;
 }
 
 static struct property *sym_get_range_prop(struct symbol *sym)


