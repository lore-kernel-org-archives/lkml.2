Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932325Ab1IAWIK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 18:08:10 -0400
Received: from smtp-out.google.com ([216.239.44.51]:7493 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932200Ab1IAWII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 18:08:08 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=ECcUtY/pn1nmhHsTsyVPZ0Sv1gRGyOYrmojIf51NT3RYxDNQmO43G6bZ2In6y7Go7
	VpFJWipoeG/UrZrcykSNg==
Date: Thu, 1 Sep 2011 15:08:00 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Rik van Riel <riel@redhat.com>, Randy Dunlap <rdunlap@xenotime.net>,
        Satoru Moriya <smoriya@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, lwoodman@redhat.com,
        Seiji Aguchi <saguchi@redhat.com>, hughd@google.com,
        hannes@cmpxchg.org
Subject: Re: [PATCH -v2 -mm] add extra free kbytes tunable
In-Reply-To: <20110901145819.4031ef7c.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.2.00.1109011501260.22550@chino.kir.corp.google.com>
References: <20110901105208.3849a8ff@annuminas.surriel.com> <20110901100650.6d884589.rdunlap@xenotime.net> <20110901152650.7a63cb8b@annuminas.surriel.com> <20110901145819.4031ef7c.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Sep 2011, Andrew Morton wrote:

> > Add a userspace visible knob
> 
> argh.  Fear and hostility at new knobs which need to be maintained for
> ever, even if the underlying implementation changes.
> 

Do we really need to maintain tunables that lose their purpose either 
because the implementation changes or is patched to fix the issue that the 
tunable was intended to address without requiring it?

Are there really userspace tools written to not be able to handle -ENOENT 
when one of these gets removed?

> > It may also be useful to reduce the memory use of virtual
> > machines (temporarily?), in a way that does not cause memory
> > fragmentation like ballooning does.
> 
> Maybe.  You need to alter the setting, then somehow persuade all the
> targeted kswapd's to start running, then somehow determine that they've
> done their thing, then unalter the /proc setting.  Not the best API
> we've ever designed ;)
> 

And, unfortunately, this could have negative effects if using cpusets 
and/or mempolicies since this is global across all zones such that jobs 
that do not require such "extra" memory would be unfairly penalized with 
work incurred by additional reclaim they don't need.  And if the job is 
constrained to a memory cgroup, there's no guarantee it will reclaim back 
to these altered watermarks.
