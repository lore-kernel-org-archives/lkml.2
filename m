Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756509Ab1FHWMS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 18:12:18 -0400
Received: from adelie.canonical.com ([91.189.90.139]:47662 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169Ab1FHWMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 18:12:16 -0400
Message-ID: <4DEFF3B9.7070907@canonical.com>
Date: Wed, 08 Jun 2011 15:12:09 -0700
From: John Johansen <john.johansen@canonical.com>
Organization: Canonical
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110516 Thunderbird/3.1.10
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Matt Mackall <mpm@selenic.com>, David Howells <dhowells@redhat.com>,
        Miles Lane <miles.lane@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>
Subject: Re: 3.0.0-rc2-git1 -- BUG: sleeping function called from invalid
 context at mm/slub.c:847
References: <BANLkTimq+h+WyboMbPGVH1uJuj64YuRLdw@mail.gmail.com> <alpine.DEB.2.00.1106081305430.10320@chino.kir.corp.google.com> <1307564248.4204.1013.camel@calx> <alpine.DEB.2.00.1106081407440.10320@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1106081407440.10320@chino.kir.corp.google.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/08/2011 02:34 PM, David Rientjes wrote:
> On Wed, 8 Jun 2011, Matt Mackall wrote:
> 
>>> Not sure why this ever actually worked with apparmor if prepare_creds() 
>>> does an unconditional GFP_KERNEL allocation since this codepath hasn't 
>>> changed in at least a year and we're holding a spinlock from setrlimit.  
>>> John?
>>
>> Probably a lack of people enabling (and using!) both apparmor and
>> might_sleep. I don't this would be caught by a randconfig boot test.
>>
> 
> Right, CONFIG_DEBUG_SPINLOCK_SLEEP isn't enabled by default even though 
> CONFIG_DEBUG_KERNEL is.  We should probably just allow prepare_creds() to 
> take a gfp_t argument just like security_prepare_creds() and change 
> existing callers to use GFP_KERNEL with the exception of those using 
> setrlimit where we're always holding the spinlock.  
> 
> Documentation/security/credentials.txt says this:
> 
> 	To alter the current process's credentials, a function should first prepare a
> 	new set of credentials by calling:
> 
>         	struct cred *prepare_creds(void);   
> 
> 	this locks current->cred_replace_mutex and then allocates and constructs a
> 	duplicate of the current process's credentials, returning with the mutex still
> 	held if successful.  It returns NULL if not successful (out of memory).
> 
> although that mutex doesn't exist.  David, any downsides to passing the 
> gfp_t into prepare_creds()?

Well it certainly isn't needed for the apparmor case, as the bug is being
triggered by how apparmor handles policy replacement, and we have a means
of handling that for atomic contexts.
