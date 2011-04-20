Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753201Ab1DTVeu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 17:34:50 -0400
Received: from smtp-out.google.com ([216.239.44.51]:61853 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752202Ab1DTVes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 17:34:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=JT7sDk2VlavDrZpitdD2iGkvH85qOmE7NUgU1u6KDozONkZ+tzy+RjoHhZaxGoWI3d
         LlMQGpS76vTnTrvI2L5w==
Date: Wed, 20 Apr 2011 14:34:41 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Matthew Wilcox <matthew@wil.cx>
cc: Pekka Enberg <penberg@kernel.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Christoph Lameter <cl@linux.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Michal Hocko <mhocko@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>, linux-parisc@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH v3] mm: make expand_downwards symmetrical to
 expand_upwards
In-Reply-To: <20110420112020.GA31296@parisc-linux.org>
Message-ID: <alpine.DEB.2.00.1104201425020.31768@chino.kir.corp.google.com>
References: <20110420102314.4604.A69D9226@jp.fujitsu.com> <BANLkTi=mxWwLPEnB+rGg29b06xNUD0XvsA@mail.gmail.com> <20110420161615.462D.A69D9226@jp.fujitsu.com> <BANLkTimfpY3gq8oY6bPDajBW7JN6Hp+A0A@mail.gmail.com> <20110420112020.GA31296@parisc-linux.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Apr 2011, Matthew Wilcox wrote:

> > That part makes me think the best option is to make parisc do
> > CONFIG_NUMA as well regardless of the historical intent was.
> 
> But it's not just parisc.  It's six other architectures as well, some
> of which aren't even SMP.  Does !SMP && NUMA make any kind of sense?
> 

It does as long as DISCONTIGMEM is hijacking NUMA abstractions throughout 
the code; for example, look at the .config that James is probably using 
for testing here:

	CONFIG_PA8X00=y
	CONFIG_64BIT=y
	CONFIG_DISCONTIGMEM=y
	CONFIG_NEED_MULTIPLE_NODES=y
	CONFIG_NODES_SHIFT=3

and CONFIG_NUMA is not enabled.  So we want CONFIG_NODES_SHIFT of 3 
(because MAX_PHYSMEM_RANGES is 8) and CONFIG_NEED_MULTIPLE_NODES is 
enabled because of DISCONTIGMEM:

	#
	# Both the NUMA code and DISCONTIGMEM use arrays of pg_data_t's
	# to represent different areas of memory.  This variable allows
	# those dependencies to exist individually.
	#
	config NEED_MULTIPLE_NODES
		def_bool y
		depends on DISCONTIGMEM || NUMA

when in reality we should do away with CONFIG_NEED_MULTIPLE_NODES and just 
force DISCONTIGMEM to enable CONFIG_NUMA at least for -stable and as a 
quick fix for James.

In the long run, we'll probably want to define a lighterweight CONFIG_NUMA 
as a layer that CONFIG_DISCONTIGMEM can use for memory range abstractions 
and then CONFIG_NUMA is built on top of it to define proximity between 
those ranges.
