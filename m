Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753534Ab1JYUSF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 16:18:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58457 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751368Ab1JYUSD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 16:18:03 -0400
Date: Tue, 25 Oct 2011 16:17:24 -0400
From: Dave Jones <davej@redhat.com>
To: Greg KH <greg@kroah.com>
Cc: Nick Bowler <nbowler@elliptictech.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Randy Dunlap <rdunlap@xenotime.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Debian kernel maintainers <debian-kernel@lists.debian.org>
Subject: Re: [PATCH] module,bug: Add TAINT_OOT_MODULE flag for modules not
 built in-tree
Message-ID: <20111025201723.GA25063@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, Greg KH <greg@kroah.com>,
	Nick Bowler <nbowler@elliptictech.com>,
	Ben Hutchings <ben@decadent.org.uk>,
	Rusty Russell <rusty@rustcorp.com.au>,
	Randy Dunlap <rdunlap@xenotime.net>,
	LKML <linux-kernel@vger.kernel.org>,
	Debian kernel maintainers <debian-kernel@lists.debian.org>
References: <1319461948.31243.31.camel@deadeye>
 <4EA57CBF.2050901@xenotime.net>
 <87k47tpvvm.fsf@rustcorp.com.au>
 <20111025153855.GA24779@elliptictech.com>
 <1319558749.11727.6.camel@deadeye>
 <20111025165142.GA25354@elliptictech.com>
 <20111025200455.GA6376@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111025200455.GA6376@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 25, 2011 at 10:04:55PM +0200, Greg Kroah-Hartman wrote:
 > On Tue, Oct 25, 2011 at 12:51:42PM -0400, Nick Bowler wrote:
 > > On 2011-10-25 18:05 +0200, Ben Hutchings wrote:
 > > > On Tue, 2011-10-25 at 11:38 -0400, Nick Bowler wrote:
 > > > > This patch prevents the use of lockdep for debugging out of tree
 > > > > modules, which is rather mean.
 > > > 
 > > > It was already disabled for staging modules, which seems equally
 > > > unhelpful.
 > > 
 > > This is not the case: lockdep works fine with staging modules.
 > 
 > Yes, that was fixed a few kernel versions ago.
 > 
 > Now you might want to update that fix for the TAINT_OOT_MODULE flag as
 > well, if you feel it is needed.

I'm assuming you mean this patch ?

commit 7816c45bf13255157c00fb8aca86cb64d825e878
Author: Roland Vossen <rvossen@broadcom.com>
Date:   Thu Apr 7 11:20:58 2011 +0200

    modules: Enabled dynamic debugging for staging modules
    
    Driver modules from the staging directory are marked 'tainted'
    by module.c. Subsequently, tainted modules are denied dynamic
    debugging. This is unwanted behavior, since staging modules should
    be able to use the dynamic debugging mechanism.
    
    Please merge this also into the staging-linus branch.
    
    Signed-off-by: Roland Vossen <rvossen@broadcom.com>
    Acked-by: Jason Baron <jbaron@redhat.com>
    Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

diff --git a/kernel/module.c b/kernel/module.c
index d5938a5..4d5c16a 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2790,7 +2790,7 @@ static struct module *load_module(void __user *umod,
        }
 
        /* This has to be done once we're sure module name is unique. */
-       if (!mod->taints)
+       if (!mod->taints || mod->taints == (1U<<TAINT_CRAP))
                dynamic_debug_setup(info.debug, info.num_debug);
 
        /* Find duplicate symbols */
@@ -2827,7 +2827,7 @@ static struct module *load_module(void __user *umod,
        module_bug_cleanup(mod);
 
  ddebug:
-       if (!mod->taints)
+       if (!mod->taints || mod->taints == (1U<<TAINT_CRAP))
                dynamic_debug_remove(info.debug);
  unlock:
        mutex_unlock(&module_mutex);



If we want to support out of tree modules with this, should we just nuke the
whole check, or do we still want to prevent certain types of tainted kernels
from using this stuff ?

(sidenote: it's not immediately obvious to me that this is the right patch,
as dynamic debug & lockdep are separate things, though this was the only
thing in kernel/module.c's history this year that sounds similar)

	Dave

