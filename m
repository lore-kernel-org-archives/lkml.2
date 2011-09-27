Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752763Ab1I0SaW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 14:30:22 -0400
Received: from smtp-out.google.com ([216.239.44.51]:61203 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678Ab1I0SaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 14:30:20 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=mNDbOjXfzKY1TXHiDUv5l8Gu2soEM8RWYGeixWyDe58+slgZixJ98tf6ynF/g2HBc
	vfvguLdWuKH3it0dn3ORw==
Date: Tue, 27 Sep 2011 11:30:13 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Michal Hocko <mhocko@suse.cz>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Oleg Nesterov <oleg@redhat.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Tejun Heo <tj@kernel.org>, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 1/2] oom: do not live lock on frozen tasks
In-Reply-To: <20110927075245.GA25807@tiehlicka.suse.cz>
Message-ID: <alpine.DEB.2.00.1109271128110.17876@chino.kir.corp.google.com>
References: <20110825151818.GA4003@redhat.com> <alpine.DEB.2.00.1109260154510.1389@chino.kir.corp.google.com> <20110926091440.GE10156@tiehlicka.suse.cz> <201109261751.40688.rjw@sisk.pl> <alpine.DEB.2.00.1109261801150.8510@chino.kir.corp.google.com>
 <20110927075245.GA25807@tiehlicka.suse.cz>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Sep 2011, Michal Hocko wrote:

> I guess you mean a situation when select_bad_process picks up a process
> which is not marked as frozen yet but we send SIGKILL right before
> schedule is called in refrigerator. 
> In that case either schedule should catch it by signal_pending_state
> check or we will pick it up next OOM round when we pick up the same
> process (if nothing else is eligible). Or am I missing something?
>  

That doesn't close the race, the oom killer will see the presence of an 
eligible TIF_MEMDIE thread in select_bad_process() and simply return to 
the page allocator.  You'd need to thaw it there as well and hope that 
nothing now or in the future will get into an endless thaw-freeze-thaw 
loop in the exit path.
