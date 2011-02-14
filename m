Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753399Ab1BNLZr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 06:25:47 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:52698 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752710Ab1BNLZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 06:25:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=StIUR5hWH2bVnFePTHYaO4COB3BwQLoG/9Ih5c1awZ5akBiMpji8Q39HXLR+WqVz4I
         zlaG/pF4Xu6pXWX6OrSS/l3G68bTOhmKqBmcqYNsVySjYgGIEOEO9AGmGjphpqXkHs2O
         rQDzZ/JxwGHFw1MeVlW4mgcxMpJPdqafuU6dI=
Date: Mon, 14 Feb 2011 12:25:40 +0100
From: Tejun Heo <tj@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, brgerst@gmail.com,
        gorcunov@gmail.com, shaohui.zheng@intel.com, rientjes@google.com,
        mingo@elte.hu, hpa@linux.intel.com
Subject: Re: [PATCH 02/26] x86-64, NUMA: Simplify hotplug node handling in
 acpi_numa_memory_affinity_init()
Message-ID: <20110214112540.GE18742@htj.dyndns.org>
References: <1297530663-26234-1-git-send-email-tj@kernel.org>
 <1297530663-26234-3-git-send-email-tj@kernel.org>
 <4D56C79B.2060201@kernel.org>
 <AANLkTimiKA91OEMyt-KM5q5V5s6-xS_76Ji-Y8M_k4Bt@mail.gmail.com>
 <4D56CB9F.8030909@kernel.org>
 <AANLkTimAceZOxWQq03QqhXhQ42r2jw6MQYA9Vc2XQo5B@mail.gmail.com>
 <4D56CDDF.8050401@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D56CDDF.8050401@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Yinghai.

On Sat, Feb 12, 2011 at 10:13:51AM -0800, Yinghai Lu wrote:
> > Eh?  The oldnode thing will restore the node to initial state thus
> > fulfilling the node empty condition.  Am I missing something?
> > 
> 
> yes. nd get restored, but it keep node_parsed set for that kind of node.

So, this is the code snippet.  Both @nd->start and end are zero and
nodes_parsed for @node is clear.

	nd = &nodes[node];
	oldnode = *nd;

@oldnode->start, end == 0.

	if (!node_test_and_set(node, nodes_parsed)) {
		nd->start = start;
		nd->end = end;
This path is taken and @nd->start and end are set.
	} else {
		if (start < nd->start)
			nd->start = start;
		if (nd->end < end)
			nd->end = end;
	}

	printk(KERN_INFO "SRAT: Node %u PXM %u %lx-%lx\n", node, pxm,
	       start, end);

	if (ma->flags & ACPI_SRAT_MEM_HOT_PLUGGABLE) {
		update_nodes_add(node, start, end);
		/* restore nodes[node] */
		*nd = oldnode;
@nd->start and end are restored to zero.
		if ((nd->start | nd->end) == 0)
			node_clear(node, nodes_parsed);
and @nodes_parsed is cleared.
	}

So, what the hell am I missing?

-- 
tejun
