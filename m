Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754141Ab1BSDMc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 22:12:32 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:44418 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752874Ab1BSDMa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 22:12:30 -0500
Date: Fri, 18 Feb 2011 19:12:25 -0800
From: Andres Salomon <dilinger@queued.net>
To: Andres Salomon <dilinger@queued.net>
Cc: Daniel Drake <dsd@laptop.org>, David Woodhouse <dwmw2@infradead.org>,
        cbou@mail.ru, linux-kernel@vger.kernel.org, x86@kernel.org,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        dmitry.torokhov@gmail.com, Grant Likely <grant.likely@secretlab.ca>,
        devicetree-discuss@lists.ozlabs.org, Mitch Bradley <wmb@laptop.org>,
        "David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org
Subject: [PATCH] of/pdt: don't bother parsing pkg2path results, return as-is
Message-ID: <20110218191225.5e38b8bc@queued.net>
In-Reply-To: <20110218190659.7f955e4c@queued.net>
References: <20110216222820.487AE9D401C@zog.reactivated.net>
	<1297896277.3011.5.camel@macbook.infradead.org>
	<AANLkTikAF2X1A5jfoNfCPRhZkZ7qPdZ57c8B5b9z4+qr@mail.gmail.com>
	<20110218190659.7f955e4c@queued.net>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Feb 2011 19:06:59 -0800
Andres Salomon <dilinger@queued.net> wrote:

> On Fri, 18 Feb 2011 23:42:57 +0000
> Daniel Drake <dsd@laptop.org> wrote:
> 
> > On 16 February 2011 22:44, David Woodhouse <dwmw2@infradead.org>
> > wrote:
> > > On Wed, 2011-02-16 at 22:28 +0000, Daniel Drake wrote:
> > >>
> > >> +static int __init add_common_platform_devices(void)
> > >> +{
> > >> +       struct platform_device *pdev;
> > >> +
> > >> +       pdev = platform_device_register_simple("olpc-battery",
> > >> -1, NULL, 0);
> > >> +       if (IS_ERR(pdev))
> > >> +               return PTR_ERR(pdev);
> > >> +
> > >> +       return 0;
> > >> +}
> > >> +
> > >
> > > Still kind of sucks that you have to do this, and can't bind to
> > > something in the device-tree.
> > 
> > OK, feel free to put this patch on hold for now. I started looking
> > at the device tree approach today. It looks doable but first we
> > have to fix a DT bug/inconsistency that is preventing us from
> > correctly binding to the tree's devices.
> > 
> > Daniel
> 
> 
> Mea culpa.  The patch below fixes a bug I introduced earlier.
> Cc'ing the sparc folks, as this probably affects them
> (although I would think that it fixes broken behavior for them..?)
> 
> 
> 

And this is a followup to the prior patch; an optimization based
upon what we're doing with pkg2path stuff.

The sparc folks don't use pkg2path, so this shouldn't affect them at
all.

Cc'ing Mitch as well, in case there's some reason why I should be
wary of doing this.  :)




From: Andres Salomon <dilinger@queued.net>

The of_pdt_try_pkg2path() function currently allocates memory for
and fetches the full path name from OFW (of the form '/foo/bar/baz@0').
It then returns only the name ('baz@0)', and the caller re-constructs
the full name (for dp->full_name) based upon dp->parent->full_name and
what was returned by of_pdt_try_pkg2path().  Oh, and it allocates more
memory for it.

OLPC is the only architecture which fills in the pkg2path hook, so
this shouldn't affect any other users (ie, sparc).  Since in practice
(dp->parent->full_name + '/' + strrchr(pkg2path, '/')) and the result
from pkg2path end up being exactly the same, just short circuit the rest
of the of_pdt_build_full_name logic and set dp->full_name to the result
of pkg2path.  This means we don't have to parse it nor allocate more
memory for it.

This saves time, code, and memory.

Signed-off-by: Andres Salomon <dilinger@queued.net>
---
 drivers/of/pdt.c |   17 +++++++----------
 1 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/of/pdt.c b/drivers/of/pdt.c
index b39d584..605834b 100644
--- a/drivers/of/pdt.c
+++ b/drivers/of/pdt.c
@@ -134,7 +134,7 @@ static char * __init of_pdt_get_one_property(phandle node, const char *name)
 
 static char * __init of_pdt_try_pkg2path(phandle node)
 {
-	char *res, *buf = NULL;
+	char *buf = NULL;
 	int len;
 
 	if (!of_pdt_prom_ops->pkg2path)
@@ -147,13 +147,7 @@ static char * __init of_pdt_try_pkg2path(phandle node)
 		pr_err("%s: package-to-path failed\n", __func__);
 		return NULL;
 	}
-
-	res = strrchr(buf, '/');
-	if (!res) {
-		pr_err("%s: couldn't find / in %s\n", __func__, buf);
-		return NULL;
-	}
-	return res+1;
+	return buf;
 }
 
 static struct device_node * __init of_pdt_create_node(phandle node,
@@ -193,10 +187,13 @@ static char * __init of_pdt_build_full_name(struct device_node *dp,
 	 * name property (ie, 'battery'), we want the name we see with
 	 * package-to-path (ie, 'battery@0').
 	 */
+	n = of_pdt_try_pkg2path(node);
+	if (n)
+		return n;
+
+	/* Older methods for determining full name */
 	name = of_pdt_node_name(dp);
 	if (!name)
-		name = of_pdt_try_pkg2path(node);
-	if (!name)
 		name = dp->name;
 
 	plen = strlen(dp->parent->full_name);
-- 
1.7.2.3

