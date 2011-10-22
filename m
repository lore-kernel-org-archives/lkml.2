Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754637Ab1JVKVh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Oct 2011 06:21:37 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:42927 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477Ab1JVKVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Oct 2011 06:21:35 -0400
Date: Sat, 22 Oct 2011 12:21:30 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Lennart Poettering <mzxreary@0pointer.de>
Cc: Paul Menage <paul@paulmenage.org>, Kay Sievers <kay.sievers@vrfy.org>,
        linux-kernel@vger.kernel.org, harald@redhat.com, david@fubar.dk,
        greg@kroah.com
Subject: Re: A =?utf-8?Q?Plumber=E2=80=99?= =?utf-8?Q?s?= Wish List for Linux
Message-ID: <20111022102126.GA2811@somewhere.feld.cvut.cz>
References: <1317943022.1095.25.camel@mop>
 <CALdu-PBLCNXTaZuODyzw_g_FQNyLqK_FsdObC=HjtEp75vkdFQ@mail.gmail.com>
 <20111019230347.GA32295@tango.0pointer.de>
 <CALdu-PCRj4+tL-6MXwsZKuODHRQn_pixdfVLwC6PV2a0q4sw4g@mail.gmail.com>
 <20111019233111.GE32295@tango.0pointer.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111019233111.GE32295@tango.0pointer.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 20, 2011 at 01:31:11AM +0200, Lennart Poettering wrote:
> On Wed, 19.10.11 16:09, Paul Menage (paul@paulmenage.org) wrote:
> 
> > On Wed, Oct 19, 2011 at 4:03 PM, Lennart Poettering
> > <mzxreary@0pointer.de> wrote:
> > >
> > > For our systemd usecase a cgroup.signal file would not be useful. This
> > > is because we actually kill all members of the service's cgroup plus the
> > > main process of the service, which is usually also in the service's
> > > cgroup but sometimes isn't (for example: when the user logs in, the
> > > whole /sbin/login process ends up in the user's session cgroup, and is
> > > removed from the original service cgroup). Since we want to avoid
> > > killing the main service process twice in the case where it isn't in the
> > > servce cgroup we'd hence prefer to have some fork throttling logic in
> > > place, so that we can kill members flexibly in accordance with these
> > > rules.
> > 
> > By fork-throttling, do you just mean "0 or unlimited", or would you
> > actually want some kind of rate-limited throttling? If the former,
> > than I agree with Frederick that his task counter should solve that
> > problem.
> 
> Given that shutting down some services might involve forking off a few
> things (think: a shell script handling shutdown which forks off a couple
> of shell utilities) we'd want something that is between "from now on no
> forking at all" and "unlimited forking". This could be done in many
> different ways: we'd be happy if we could do time-based rate limiting,
> but we'd also be fine with defining a certain budget of additional forks
> a cgroup can do (i.e. "from now on you can do 50 more forks, then you'll
> get EPERM).

Thinking more about it, you shouldn't use the task counter subsystem for
Systemd. This is a subsystem that may bring some significant overhead
(ie: walk through the entire hierarchy every fork and exit). Doesn't
sound like something suitable for an init process.

If you really need to stop any forks in a cgroup, then a cgroup core feature
handling that very single purpose would be better and more efficient.

That said I'm not really sure why you're using cgroups in Systemd.
