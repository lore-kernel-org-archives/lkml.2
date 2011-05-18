Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933198Ab1ERNxU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 09:53:20 -0400
Received: from spaceboyz.net ([87.106.131.203]:41557 "EHLO spaceboyz.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932856Ab1ERNxR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 09:53:17 -0400
Date: Wed, 18 May 2011 15:33:52 +0200
From: David Lamparter <equinox@diac24.net>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: David Lamparter <equinox@diac24.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        jamal <hadi@cyberus.ca>, Daniel Lezcano <daniel.lezcano@free.fr>,
        Linux Containers <containers@lists.osdl.org>,
        Renato Westphal <renatowestphal@gmail.com>
Subject: Re: Identifying network namespaces (was: Network namespace
 manipulation with file descriptors)
Message-ID: <20110518133352.GE3762520@jupiter.n2.diac24.net>
References: <m1tyd7p7tq.fsf@fess.ebiederm.org>
 <20110518124307.GD3762520@jupiter.n2.diac24.net>
 <BANLkTikmrC86hk=W84UBwhJLe_uGAN4w9w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTikmrC86hk=W84UBwhJLe_uGAN4w9w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 18, 2011 at 04:03:03PM +0300, Alexey Dobriyan wrote:
> On Wed, May 18, 2011 at 3:43 PM, David Lamparter <equinox@diac24.net> wrote:
> > -   processes cannot easily be cross referenced with each other
> >
> >  in the case of user space stuff running astray - like management
> >  software crashing, routing daemons screwing up, etc. - it becomes
> >  fairly difficult to shut down a network namespace (or even reaquire
> >  physical devices that have been reassigned)
> 
> It shutdowns itself when last process using netns disappeares,
> so if you kill your routing daemons you should be fine.
> Physical netdevices are moved to init_net.

Now assume I'm running pptpd, which forks a new pppd for each
connection. Even if I kill pptpd, the pppd keeps running... now how do I
find the pppds that belong to that one namespace that I'm trying to
get rid of?

> > -   namespaces cannot adequately be identified to the user
> >
> >  for debugging, some kernel messages become useless. most prominently,
> >  "unregister_netdevice: waiting for lo to become free. Usage count = 123"
> >  could certainly use some clarification, *which* lo is meant...
> 
> There is no "netns %p" or something, because right now the only unique
> netns identifier is kernel pointer (which better not be exposed to userspace).
> Printing such thing would be quite useless since it's not printed
> at netns creation.

I agree printing the kernel pointer is point-less.

> > So, considering this set of premises (feedback welcome) I looked for
> > some suitable means of identification. I discarded going for any process
> > identifiers since Eric's patches allow for network namespaces without
> > any process holding a reference, using bind mounts instead.
> 
> If anything it should be netns->id, /proc/*/netns outputting id
> where id is not derived from kernel pointer.
> 
> > Solution?
> > [ using lo interface index ]
> 
> What a hack! :-)

Well, you could create another counter and count it up on namespace
creation. But the interface index is readily available to userspace as
is, and it uniquely identifies the network namespace.

(Stupidest thing you can do to break this is renaming the loopback
device; but even if you do that userspace can still look at the LOOPBACK
flag.)


-David

