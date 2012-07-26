Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752194Ab2GZOFj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 10:05:39 -0400
Received: from mx2.parallels.com ([64.131.90.16]:48203 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751090Ab2GZOFh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 10:05:37 -0400
Message-ID: <50114E05.1040201@parallels.com>
Date: Thu, 26 Jul 2012 18:02:45 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@kernel.org>, Greg Thelen <gthelen@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Frederic Weisbecker <fweisbec@gmail.com>, <devel@openvz.org>,
        <cgroups@vger.kernel.org>, Pekka Enberg <penberg@cs.helsinki.fi>,
        Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Suleiman Souhlal <suleiman@google.com>
Subject: Re: [PATCH 05/10] slab: allow enable_cpu_cache to use preset values
 for its tunables
References: <1343227101-14217-1-git-send-email-glommer@parallels.com> <1343227101-14217-6-git-send-email-glommer@parallels.com> <alpine.DEB.2.00.1207251204450.3543@router.home> <501039F9.7040309@parallels.com> <alpine.DEB.2.00.1207251331480.4995@router.home>
In-Reply-To: <alpine.DEB.2.00.1207251331480.4995@router.home>
Content-Type: multipart/mixed;
	boundary="------------010800000600070305040105"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------010800000600070305040105
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit

On 07/25/2012 10:33 PM, Christoph Lameter wrote:
> On Wed, 25 Jul 2012, Glauber Costa wrote:
> 
>> It is certainly not through does the same method as SLAB, right ?
>> Writing to /proc/slabinfo gives me an I/O error
>> I assume it is something through sysfs, but schiming through the code
>> now, I can't find any per-cache tunables. Would you mind pointing me to
>> them?
> 
> The slab attributes in /sys/kernel/slab/<slabname>/<attr> can be modified
> for some values. I think that could be the default method for the future
> since it allows easy addition of new tunables as needed.
> 

Christoph, would the following PoC patch be enough?



--------------010800000600070305040105
Content-Type: text/x-patch; name="0001-slub-propagation.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="0001-slub-propagation.patch"

>From 7c582c5c6321cbde93c5e73c6c2096b4432a2a04 Mon Sep 17 00:00:00 2001
From: Glauber Costa <glommer@parallels.com>
Date: Thu, 26 Jul 2012 15:19:08 +0400
Subject: [PATCH] slub propagation

---
 mm/slub.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/mm/slub.c b/mm/slub.c
index 55946c3..a136a75 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -5130,6 +5130,10 @@ static ssize_t slab_attr_store(struct kobject *kobj,
 	struct slab_attribute *attribute;
 	struct kmem_cache *s;
 	int err;
+#ifdef CONFIG_MEMCG_KMEM
+	struct kmem_cache *c;
+	struct mem_cgroup_cache_params *p;
+#endif
 
 	attribute = to_slab_attr(attr);
 	s = to_slab(kobj);
@@ -5138,7 +5142,19 @@ static ssize_t slab_attr_store(struct kobject *kobj,
 		return -EIO;
 
 	err = attribute->store(s, buf, len);
+#ifdef CONFIG_MEMCG_KMEM
+	if (slab_state < FULL)
+		return err;
 
+	if ((err < 0) || (s->memcg_params.id == -1))
+		return err;
+
+	list_for_each_entry(p, &s->memcg_params.sibling_list, sibling_list) {
+		c = container_of(p, struct kmem_cache, memcg_params);
+		/* return value determined by the parent cache only */
+		attribute->store(c, buf, len);
+	}
+#endif
 	return err;
 }
 
-- 
1.7.10.4


--------------010800000600070305040105--
