Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752365Ab2LTLVd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 06:21:33 -0500
Received: from mx2.parallels.com ([64.131.90.16]:56042 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751416Ab2LTLVY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 06:21:24 -0500
Message-ID: <50D2F4B6.9040108@parallels.com>
Date: Thu, 20 Dec 2012 15:21:26 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>
CC: <linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <linux-mm@kvack.org>, <xfs@oss.sgi.com>
Subject: Re: [PATCH 09/19] list_lru: per-node list infrastructure
References: <1354058086-27937-1-git-send-email-david@fromorbit.com> <1354058086-27937-10-git-send-email-david@fromorbit.com>
In-Reply-To: <1354058086-27937-10-git-send-email-david@fromorbit.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/28/2012 03:14 AM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Now that we have an LRU list API, we can start to enhance the
> implementation.  This splits the single LRU list into per-node lists
> and locks to enhance scalability. Items are placed on lists
> according to the node the memory belongs to. To make scanning the
> lists efficient, also track whether the per-node lists have entries
> in them in a active nodemask.
> 

I think it is safe to assume that these functions could benefit from
having more metadata available for them when they run.

Let's say for instance that a hypothetical person, for some unknown
reasons, comes with the idea of replicating those lists transparently
per memcg.

In this case, it is very useful to know which memcg drives the current
call. In general, the struct shrink_control already contains a lot of
data that we use to drive the process. Wouldn't it make sense to also
pass shrink_control as data to those lists as well?

The only drawback of this, is that it would tie it to the shrinking
process. I am not sure if this is a concern, but it if is, maybe we
could replace things like :

+static long
+list_lru_walk_node(
+	struct list_lru		*lru,
+	int			nid,
+	list_lru_walk_cb	isolate,
+	void			*cb_arg,
+	long			*nr_to_walk)
+{

with

+static long
+list_lru_walk_node(
+	struct list_lru		*lru,
+       struct something_like_shrink_control_not_shrink_control *a)
+{

This way we can augment the data available for the interface, for
instance, passing the memcg context, without going patching all the callers.

