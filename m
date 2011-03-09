Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753848Ab1CIWL1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 17:11:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34953 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751156Ab1CIWLW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 17:11:22 -0500
Subject: Re: [PATCH -v2] capabilites: allow the application of capability
 limits to usermode helpers
From: Eric Paris <eparis@redhat.com>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        dhowells@redhat.com, jmorris@namei.org, serge.hallyn@canonical.com,
        morgan@kernel.org
In-Reply-To: <20110309213813.GA28009@kroah.com>
References: <20110309193330.12181.92080.stgit@paris.rdu.redhat.com>
	 <20110309213813.GA28009@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 09 Mar 2011 17:11:12 -0500
Message-ID: <1299708672.17577.42.camel@unknown001a4b0c2895>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-03-09 at 13:38 -0800, Greg KH wrote:
> On Wed, Mar 09, 2011 at 02:33:31PM -0500, Eric Paris wrote:
> > There is no way to limit the capabilities of usermodehelpers. This problem
> > reared its head recently when someone complained that any user with
> > cap_net_admin was able to load arbitrary kernel modules, even though the user
> > didn't have cap_sys_module.  The reason is because the actual load is done by
> > a usermode helper and those always have the full cap set.  This patch addes new
> > sysctls which allow us to bound the permissions of usermode helpers.
> > 
> > /proc/sys/kernel/usermodehelper/bset
> > /proc/sys/kernel/usermodehelper/inheritable
> 
> Shouldn't these be documented somewhere?  Documentation/ABI?

Yes, they should.  Will do.

> > You must have CAP_SYS_MODULE to change these (changes are &= ONLY).
> 
> Why that permission?  Just because 'modprobe' is usually run from this
> callback?  Or some other reason?

I don't have a good answer for this.  I was originally looking at this
thinking about modprobe.  Since it's a purely restrictive interface I
probably don't need something quite so strong.  I'm trying to decide
what the implications are of usemode helpers being forced to run with
reduced permissions.  Andrew, do you have thoughts?

> > When the kernel launches a usermodehelper it will do so with these as
> > the bset and pI.
> 
> Shouldn't the caller of these functions be the ones dictating the
> capabilities it should be run with?

Yes. And no.  It depends what you mean.  The caps of the 'caller' task
are irrelevant.  If I run ifconfig ipv6 I need CAP_NET_ADMIN but the
upcall needs CAP_SYS_MODULE.  If I plug in a USB drive there is no
'caller' task which makes sense.

Now if by 'caller' you mean 'call site' then yes, we could probably
launch usermodehelpers with reduced privileged sets.  We know in the
code when we are asking to launch modprobe that we are going to need
CAP_SYS_MODULE and don't need caps like CAP_SYS_RAWIO and CAP_MAC_ADMIN.
We know when we upcall to hotplug we don't really need any priv, since
it's another task that is going to do the real work.  So yeah, there
might be some value in another patch to address this....

But neither solves the problem of being able to eliminate capabilities
from a machine globally.  In olden times we had a global cap-bound but
it was dropped in favor of an inheritance from init type mechanism.
Since kthreads don't inherit from init we still end up with this patch.

