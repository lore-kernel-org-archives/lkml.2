Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755190Ab2AIVTv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 16:19:51 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:58903 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754772Ab2AIVTu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 16:19:50 -0500
Date: Mon, 9 Jan 2012 13:19:45 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Pekka Enberg <penberg@kernel.org>
cc: Christoph Lameter <cl@linux.com>, Eric Dumazet <eric.dumazet@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: [patch slab/urgent] disallow changing cpu_partial from userspace
 for debug caches
In-Reply-To: <alpine.DEB.2.00.1201090855530.29109@router.home>
Message-ID: <alpine.DEB.2.00.1201091316390.10232@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1111230923260.16544@router.home>  <alpine.LFD.2.02.1112120915030.2555@tux.localdomain>  <alpine.DEB.2.00.1112141908410.27595@chino.kir.corp.google.com>  <alpine.DEB.2.00.1201060934550.10460@chino.kir.corp.google.com>
 <1326020041.32105.3.camel@jaguar> <alpine.DEB.2.00.1201090855530.29109@router.home>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For caches with debugging enabled, "slub: Switch per cpu partial page 
support off for debugging" changes cpu_partial to 0.  It shouldn't be 
tunable from userspace for such caches, otherwise the same accounting 
issues arise during validation.

This patch disallows tuning /sys/kernel/slab/cache/cpu_partial to be non-
zero for caches with debugging enabled.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 mm/slub.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -4639,6 +4639,8 @@ static ssize_t cpu_partial_store(struct kmem_cache *s, const char *buf,
 	err = strict_strtoul(buf, 10, &objects);
 	if (err)
 		return err;
+	if (objects && kmem_cache_debug(s))
+		return -EINVAL;
 
 	s->cpu_partial = objects;
 	flush_all(s);
