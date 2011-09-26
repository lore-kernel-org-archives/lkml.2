Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752269Ab1IZJDI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 05:03:08 -0400
Received: from smtp-out.google.com ([216.239.44.51]:19954 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136Ab1IZJDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 05:03:05 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=kJ8FmCs/wol9QtftvBho9szkd8PbA9w9noNmI0D8aWaPdyzOtR4K63rquMhmvnGlR
	dbYVQTpVh/FWyGUtBh6mg==
Date: Mon, 26 Sep 2011 02:02:59 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Michal Hocko <mhocko@suse.cz>
cc: Oleg Nesterov <oleg@redhat.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH 2/2] oom: give bonus to frozen processes
In-Reply-To: <20110926083555.GD10156@tiehlicka.suse.cz>
Message-ID: <alpine.DEB.2.00.1109260157270.1389@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1108241226550.31357@chino.kir.corp.google.com> <20110825091920.GA22564@tiehlicka.suse.cz> <20110825151818.GA4003@redhat.com> <20110825164758.GB22564@tiehlicka.suse.cz> <alpine.DEB.2.00.1108251404130.18747@chino.kir.corp.google.com>
 <20110826070946.GA7280@tiehlicka.suse.cz> <20110826085610.GA9083@tiehlicka.suse.cz> <alpine.DEB.2.00.1108260218050.14732@chino.kir.corp.google.com> <20110826095356.GB9083@tiehlicka.suse.cz> <alpine.DEB.2.00.1108261110020.13943@chino.kir.corp.google.com>
 <20110926083555.GD10156@tiehlicka.suse.cz>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Sep 2011, Michal Hocko wrote:

> Let's try it with a heuristic change first. If you really do not like
> it, we can move to oom_scode_adj. I like the heuristic change little bit
> more because it is at the same place as the root bonus.

The problem with the bonus is that, as mentioned previously, it doesn't 
protect against ANYTHING for the case you're trying to fix.  This won't 
panic the machine because all killable threads are guaranteed to have a 
non-zero badness score, but it's a very valid configuration to have either

 - all eligible threads (system-wide, shared cpuset, shared mempolicy 
   nodes) are frozen, or

 - all eligible frozen threads use <5% of memory whereas all other 
   eligible killable threads use 1% of available memory.

and that means the oom killer will repeatedly select those threads and the 
livelock still exists unless you can guarantee that they are successfully 
thawed, that thawing them in all situations is safe, and that once thawed 
they will make a timely exit.

Additionally, I don't think biasing against frozen tasks makes sense from 
a heusritic standpoint of the oom killer.  Why would we want give 
non-frozen tasks that are actually getting work done a preference over a 
task that is frozen and doing absolutely nothing?  It seems like that's 
backwards and that we'd actually prefer killing the task doing nothing so 
it can free its memory.
