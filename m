Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756612Ab1KWXCQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 18:02:16 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:32933 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756482Ab1KWXCP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 18:02:15 -0500
Date: Wed, 23 Nov 2011 15:02:13 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the final tree
 (net-next tree related)
Message-Id: <20111123150213.ed7257cb.akpm@linux-foundation.org>
In-Reply-To: <20111123120937.GB27968@hmsreliant.think-freely.org>
References: <20111123150004.59be04eb36c480ec44edc9d5@canb.auug.org.au>
	<20111123120937.GB27968@hmsreliant.think-freely.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Nov 2011 07:09:37 -0500
Neil Horman <nhorman@tuxdriver.com> wrote:

> On Wed, Nov 23, 2011 at 03:00:04PM +1100, Stephen Rothwell wrote:
> > Hi all,
> > 
> > After merging the final tree, today's linux-next build (powerpc allnoconfig)
> > failed like this:
> > 
> > In file included from include/linux/netdevice.h:53:0,
> >                  from include/linux/icmpv6.h:173,
> >                  from include/linux/ipv6.h:220,
> >                  from include/net/ipv6.h:16,
> >                  from include/linux/sunrpc/clnt.h:26,
> >                  from include/linux/nfs_fs.h:50,
> >                  from init/do_mounts.c:20:
> > include/net/netprio_cgroup.h:23:29: error: field 'css' has incomplete type
>
> ...
>
> FYI, I've got a more appropriate fix building right now getting posted for the
> net-next tree.  I'll cc you on it.

This header looks to be pretty screwed up:

- Extraneous newline after "struct cgroup_netprio_state"

- Weird special-casing of the CONFIG_CGROUPS &&
  !CONFIG_NETPRIO_CGROUP case looks suspicious.

- Unnecessary use of IS_ENABLED - jsut use #ifdef CONFIG_NETPRIO_CGROUP

- Adds code stubs specifically for the CONFIG_CGROUPS &&
  !CONFIG_NETPRIO_CGROUP case.  Doesn't add any for the !CONFIG_CGROUPS
  case.  Seems wrong.

- Uses empty macros for the sock_update_netprioidx() and
  skb_update_prio() which can cause build errors.  Should be changed to
  plain old typechecked inline C functions.  If that causes build
  errors then something else is screwed up.

- Adds a stub for skb_update_prio() but there's no non-stub version
  of it.

also

- doesn't compile


Needs a thorough redo.  Please take a look at the other cgroup
subsystem headers.  The basic pattern is

#ifdef CONFIG_FOO_CGROUP
<definitions and declarations>
#else
<any needed stubs go here>
#endif

And that's it.
