Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756628Ab1ISQTi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 12:19:38 -0400
Received: from merlin.infradead.org ([205.233.59.134]:46860 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756381Ab1ISQTh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 12:19:37 -0400
Subject: Re: [PATCH 1/9] Remove parent field in cpuacct cgroup
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, xemul@parallels.com, paul@paulmenage.org,
        lizf@cn.fujitsu.com, daniel.lezcano@free.fr, mingo@elte.hu,
        jbottomley@parallels.com
Date: Mon, 19 Sep 2011 18:19:20 +0200
In-Reply-To: <4E776937.1070108@parallels.com>
References: <1316030695-19826-1-git-send-email-glommer@parallels.com>
	  <1316030695-19826-2-git-send-email-glommer@parallels.com>
	 <1316448186.1511.19.camel@twins> <4E776937.1070108@parallels.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1316449160.6091.5.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-09-19 at 13:09 -0300, Glauber Costa wrote:
> On 09/19/2011 01:03 PM, Peter Zijlstra wrote:
> > On Wed, 2011-09-14 at 17:04 -0300, Glauber Costa wrote:
> >> +       for (; ca; ca = parent_ca(ca)) {
> >
> > It might be good to check that the loop condition and null condition in
> > the parent_ca() function get folded. Otherwise there's a double branch
> > in that loop.
> >
> > Note that this function is one of the reasons I dislike cpuacct, it adds
> > a second cgroup hierarchy traversal to every context switch.
> >
> Well, it is not that hard to optimize this.
> 
> Those values are always updated, but they don't really need to, unless 
> they are read.
> 
> So what we can do, is introduce a marker in the cgroup, representing the 
> last read value. Parent is untouched. We then update parent when 1) 
> reading this value, 2) cgroup destroy, 3) cpu hotplug. (humm, and maybe 
> we don't even need to do it in cpu hotplug, since the per-cpu variables 
> will still be accessible... )
> 
> How about it ?

Updating that value would involve iterating all tasks in the entire
cgroup subtree nested at whatever cgroup you're wanting to read.

The delayed update would be an entire subtree walk, that can be quite
expensive. Who wants these numbers and what for and at what frequency?
Does that really make sense?
