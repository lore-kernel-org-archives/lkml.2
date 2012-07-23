Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753059Ab2GWGdO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 02:33:14 -0400
Received: from gate.crashing.org ([63.228.1.57]:34768 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752543Ab2GWGdM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 02:33:12 -0400
Message-ID: <1343025161.2957.22.camel@pasglop>
Subject: More irqdomain problems (Was: next/mmotm unbootable on G5:
 irqdomain)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Milton Miller <miltonm@bga.com>,
        Hugh Dickins <hughd@google.com>, ul Mundt <lethal@linux-sh.org>,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Date: Mon, 23 Jul 2012 16:32:41 +1000
In-Reply-To: <1343011543.2957.2.camel@pasglop>
References: <alpine.LSU.2.00.1207211911160.1585@eggly.anvils>
	 <1343011543.2957.2.camel@pasglop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allright, another one Grant:

unsigned int irq_find_mapping(struct irq_domain *domain,
			      irq_hw_number_t hwirq)
{
	struct irq_data *data;

	/* Look for default domain if nececssary */
	if (domain == NULL)
		domain = irq_default_domain;
	if (domain == NULL)
		return 0;

	switch (domain->revmap_type) {
	case IRQ_DOMAIN_MAP_LEGACY:
		return irq_domain_legacy_revmap(domain, hwirq);
	case IRQ_DOMAIN_MAP_LINEAR:
		return irq_linear_revmap(domain, hwirq);
	case IRQ_DOMAIN_MAP_TREE:
		rcu_read_lock();
		data = radix_tree_lookup(&domain->revmap_data.tree, hwirq);
		rcu_read_unlock();
		if (data)
			return data->irq;
-               break;
+               return 0;
	case IRQ_DOMAIN_MAP_NOMAP:

Please, stick a proper commit message and my s-o-b and see if you can fix
your tree before you ask Linus to pull because that's not pretty on any
pseries .... irq_find_mapping() does get called for all interrupt the
first time it's mapped to check if there's a pre-existing mapping, so
the case of the thing being unpopulated is absolutely legit.

the NOMAP case has a similar dubious exit case but since I'm not that
familiar with NOMAP I haven't touched it.

Cheers,
Ben.


