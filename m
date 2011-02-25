Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751991Ab1BYGG2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 01:06:28 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33001 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768Ab1BYGG1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 01:06:27 -0500
MIME-Version: 1.0
In-Reply-To: <20110224120109.0ed9f473@queued.net>
References: <20110224165917.3760.24493.stgit@localhost6.localdomain6>
 <20110224093341.5a809a13@queued.net> <20110224194234.GA8907@angua.secretlab.ca>
 <20110224120109.0ed9f473@queued.net>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 24 Feb 2011 23:06:06 -0700
X-Google-Sender-Auth: cEYba8paHDfKIORbCs0-5CY94tw
Message-ID: <AANLkTimc37=azh11sYYi6x7gTE=0ybud5tXgxa1TDUMT@mail.gmail.com>
Subject: Re: [PATCH v5] of/promtree: allow DT device matching by fixing 'name' brokenness
To: Andres Salomon <dilinger@queued.net>
Cc: dsd@laptop.org, sparclinux@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 24, 2011 at 1:01 PM, Andres Salomon <dilinger@queued.net> wrote:
> On Thu, 24 Feb 2011 12:42:34 -0700
> Grant Likely <grant.likely@secretlab.ca> wrote:
>> If firmware is buggy, then pkg2path must deal with it.  It is not okay
>> for it to return NULL.  (I know that pkg2path is an OFW command, but
>> in this context it really means the linux wrapper to pkg2path which
>> has the semantics, "give me the unique, full and accurate path for
>> this node").  If OFW pkg2path doesn't work, then the platform code
>> must work around it.  I'm pushing back on this because I do not want
>> to see platform workarounds in the common code.
>
> I'm fine with that, I just don't want to see BUG() happening that
> early.  I think a workaround should be handled in common code.  I agree
> that heroic workarounds for firmware bugs should be handled in
> arch-specific pkg2path hooks, but a simple workaround in common code
> is better than just crashing early in boot (imo).

Alright, you've swayed me a bit.  I've made this change and pushed it
out to devicetree/experimental.  I've also picked up your other patch.
 Let me know if it works for you.

diff --git a/drivers/of/pdt.c b/drivers/of/pdt.c
index 5ab3bd5..4d87b5d 100644
--- a/drivers/of/pdt.c
+++ b/drivers/of/pdt.c
@@ -65,17 +65,25 @@ static inline void irq_trans_init(struct device_node *dp) {

 static char * __init of_pdt_build_full_name(struct device_node *dp)
 {
+       static int failsafe_id = 0; /* for generating unique names on failure */
        char *buf;
        int len;

        if (of_pdt_prom_ops->pkg2path(dp->phandle, NULL, 0, &len))
-               BUG();
+               goto failsafe;

        buf = prom_early_alloc(len + 1);
-       if (!buf)
-               BUG();
        if (of_pdt_prom_ops->pkg2path(dp->phandle, buf, len, &len))
-               BUG();
+               goto failsafe;
+       return buf;
+
+ failsafe:
+       buf = prom_early_alloc(strlen(dp->parent->full_name) +
+                              strlen(dp->name) + 16);
+       sprintf(buf, "%s/%s@unknown%i",
+               of_node_is_root(dp->parent) ? "" : dp->parent->full_name,
+               dp->name, failsafe_id++);
+       pr_err("%s: pkg2path failed; assigning %s\n", __func__, buf);
        return buf;
 }

g.
