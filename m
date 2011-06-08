Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755956Ab1FHVeh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 17:34:37 -0400
Received: from smtp-out.google.com ([216.239.44.51]:62867 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753524Ab1FHVef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 17:34:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=P/IIhDDJzaDTYDJBV/Vg3CT6kv23xuiNM2kxGJIK35miMgCY2+JILOoqnnQWoJ9JGu
         wzzZW2ghTNcSfKNwzUwQ==
Date: Wed, 8 Jun 2011 14:34:29 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Matt Mackall <mpm@selenic.com>, David Howells <dhowells@redhat.com>
cc: Miles Lane <miles.lane@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>,
        John Johansen <john.johansen@canonical.com>
Subject: Re: 3.0.0-rc2-git1 -- BUG: sleeping function called from invalid
 context at mm/slub.c:847
In-Reply-To: <1307564248.4204.1013.camel@calx>
Message-ID: <alpine.DEB.2.00.1106081407440.10320@chino.kir.corp.google.com>
References: <BANLkTimq+h+WyboMbPGVH1uJuj64YuRLdw@mail.gmail.com> <alpine.DEB.2.00.1106081305430.10320@chino.kir.corp.google.com> <1307564248.4204.1013.camel@calx>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Jun 2011, Matt Mackall wrote:

> > Not sure why this ever actually worked with apparmor if prepare_creds() 
> > does an unconditional GFP_KERNEL allocation since this codepath hasn't 
> > changed in at least a year and we're holding a spinlock from setrlimit.  
> > John?
> 
> Probably a lack of people enabling (and using!) both apparmor and
> might_sleep. I don't this would be caught by a randconfig boot test.
> 

Right, CONFIG_DEBUG_SPINLOCK_SLEEP isn't enabled by default even though 
CONFIG_DEBUG_KERNEL is.  We should probably just allow prepare_creds() to 
take a gfp_t argument just like security_prepare_creds() and change 
existing callers to use GFP_KERNEL with the exception of those using 
setrlimit where we're always holding the spinlock.  

Documentation/security/credentials.txt says this:

	To alter the current process's credentials, a function should first prepare a
	new set of credentials by calling:

        	struct cred *prepare_creds(void);   

	this locks current->cred_replace_mutex and then allocates and constructs a
	duplicate of the current process's credentials, returning with the mutex still
	held if successful.  It returns NULL if not successful (out of memory).

although that mutex doesn't exist.  David, any downsides to passing the 
gfp_t into prepare_creds()?
