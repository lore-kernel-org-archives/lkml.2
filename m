Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754724Ab2B0Tnr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 14:43:47 -0500
Received: from smtp.snhosting.dk ([87.238.248.203]:31098 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753957Ab2B0Tnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 14:43:43 -0500
Date: Mon, 27 Feb 2012 20:43:41 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Meelis Roos <mroos@linux.ee>
Cc: Tejun Heo <tj@kernel.org>, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, sparclinux@vger.kernel.org,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: OF-related boot crash in 3.3.0-rc3-00188-g3ec1e88
Message-ID: <20120227194341.GA1448@merkur.ravnborg.org>
References: <alpine.SOC.1.00.1202201109260.467@math.ut.ee> <20120220170603.GC7836@mtj.dyndns.org> <alpine.SOC.1.00.1202210030530.11350@math.ut.ee> <20120221010537.GA15898@dhcp-172-17-108-109.mtv.corp.google.com> <alpine.SOC.1.00.1202220213180.4171@math.ut.ee> <20120222174825.GA32694@google.com> <alpine.SOC.1.00.1202222025120.20496@math.ut.ee> <20120223185503.GI22536@google.com> <alpine.SOC.1.00.1202241120300.1227@math.ut.ee> <alpine.SOC.1.00.1202271914310.15067@math.ut.ee>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.SOC.1.00.1202271914310.15067@math.ut.ee>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 27, 2012 at 07:17:42PM +0200, Meelis Roos wrote:
> > > > > Can you please try the following patch?  If it still fails to boot,
> > > > > please attach the failing log.  Thank you.
> > > > 
> > > > It works on E3500! Will try other machines tomorrow.
> > > 
> > > Once confirmed, I'll push the patch through tip.  It just hides the
> > > underlying problem but we should be in no worse shape than before,
> > > it's two line change so reproduing the problem again for proper
> > > diagnosing isn't difficult, and we're getting a bit late in release
> > > cycle already.
> > 
> > It cured the V210 too but I could not test V100 since it's offline until 
> > monday.
> 
> Tested V100 too, success!

Hi Meelis.

I have tried to cook up a small patch that verify the length of what
we read - compared to the original length.

Could you try to give this a quick spin and see if something
turns up. I you have time it would be good to try on a box
that worked before and one that was fixed by the patch from Tejun.

I have not looked much at the of stuff - but this looked like the right place to start.

I have no possibility to try it out myself...

	Sam

diff --git a/drivers/of/pdt.c b/drivers/of/pdt.c
index 07cc1d6..826204a 100644
--- a/drivers/of/pdt.c
+++ b/drivers/of/pdt.c
@@ -128,6 +128,10 @@ static struct property * __init of_pdt_build_one_prop(phandle node, char *prev,
 			p->value = prom_early_alloc(p->length + 1);
 			len = of_pdt_prom_ops->getproperty(node, p->name,
 					p->value, p->length);
+
+			if (len != p->length)
+				pr_err("prop: %s %d => %d", p->name, p->length, len);
+
 			if (len <= 0)
 				p->length = 0;
 			((unsigned char *)p->value)[p->length] = '\0';
@@ -161,8 +165,13 @@ static char * __init of_pdt_get_one_property(phandle node, const char *name)
 
 	len = of_pdt_prom_ops->getproplen(node, name);
 	if (len > 0) {
+		int proplen;
 		buf = prom_early_alloc(len);
-		len = of_pdt_prom_ops->getproperty(node, name, buf, len);
+		proplen = of_pdt_prom_ops->getproperty(node, name, buf, len);
+
+		if (proplen != len)
+			pr_err("prop: %s %d => %d\n", name, len, proplen);
+
 	}
 
 	return buf;
