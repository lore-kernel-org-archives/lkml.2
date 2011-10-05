Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932846Ab1JEHYI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 03:24:08 -0400
Received: from smtp-out.google.com ([216.239.44.51]:19124 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755813Ab1JEHYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 03:24:05 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=qVDIGNDRmbskrMHwFobYB2gHaMhjjO7RH+WgtsnZfIgOAew8HFfOSa8ZobNVprshC
	6mswayBmkK5g2VkhGqEMQ==
Date: Wed, 5 Oct 2011 00:23:59 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Eric Dumazet <eric.dumazet@gmail.com>
cc: Dave Hansen <dave@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, James.Bottomley@hansenpartnership.com,
        hpa@zytor.com
Subject: Re: [RFCv3][PATCH 4/4] show page size in /proc/$pid/numa_maps
In-Reply-To: <1317798564.3099.12.camel@edumazet-laptop>
Message-ID: <alpine.DEB.2.00.1110050012490.18906@chino.kir.corp.google.com>
References: <20111001000856.DD623081@kernel> <20111001000900.BD9248B8@kernel> <alpine.DEB.2.00.1110042344250.16359@chino.kir.corp.google.com> <1317798564.3099.12.camel@edumazet-laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Oct 2011, Eric Dumazet wrote:

> > This would be great if all the /proc/pid/numa_maps consumers were human, 
> > but unfortuantely that's not the case.  
> > 
> > I understand that this patchset was probably the result of me asking for 
> > the pagesize= to be specified in each line and using pagesize=4K and 
> > pagesize=2M as examples, but that exact usage is probably not what we 
> > want.
> > 
> > As long as there are scripts that go through and read this information 
> > (we have some internally), expressing them with differing units just makes 
> > it more difficult to parse.  I'd rather them just be the byte count.
> > 
> > That way, 1G pages would just show pagesize=1073741824.  I don't think 
> > that's too long and is much easier to parse systematically.
> > 
> 
> Hmm... Thats sounds strange.
> 
> Are you saying you cant change your scripts [But you'll have to anyway
> to parse pagesize=] ?
> 

pagesize= isn't absolutely required, you can already get the thp stats 
from /proc/pid/smaps.  A script can then parse /proc/pid/numa_maps for the 
same vmas to determine the NUMA locality.  Adding pagesize= to numa_maps 
then doesn't change the script at all if it's robust.

> I routinely use "cat /proc/xxx/numa_maps", and am stuck when a kernel
> displays nothing (it happened on some debian released kernels)
> 
> Seeing pagesize=1GB is slightly better for human, and not that hard to
> parse for a program.
> 

Why on earth do we want to convert a byte value into a string so a script 
can convert it the other way around?  Do you have a hard time parsing 
4096, 2097152, and 1073741824 to be 4K, 2M, and 1G respectively?  Then you 
better not use the hugepage sysfs interface to configure multiple hugepage 
sizes because they're all specified in kB!

> By the way, "pagesize=4KiB" are just noise if you ask me, thats the
> default PAGE_SIZE. This also breaks old scripts :)
> 

-ENOPARSE.  It better not break any old script, I don't know why it would.  
Anything that emits a field=value tuple should be parsed as such.  I doubt 
you can find a well-distributed example since numa_maps output includes 
file, mapped, mapmax, anon, and dirty fields and not a single line of 
output would have all of them.
