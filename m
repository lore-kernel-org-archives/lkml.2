Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932537Ab1KDN7q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 09:59:46 -0400
Received: from tango.0pointer.de ([85.214.72.216]:38895 "EHLO
	tango.0pointer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932418Ab1KDN7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 09:59:44 -0400
Date: Fri, 4 Nov 2011 14:59:43 +0100
From: Lennart Poettering <mzxreary@0pointer.de>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Glauber Costa <glommer@parallels.com>, "Brian K. White" <brian@aljex.com>,
        cgroups@vger.kernel.org, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] new cgroup controller "fork"
Message-ID: <20111104135943.GB14377@tango.0pointer.de>
References: <4EB2C4A5.6000406@parallels.com>
 <20111103165903.GA4755@Debian-60-squeeze-64-minimal>
 <20111103182101.5037c1e5@lxorguk.ukuu.org.uk>
 <20111103185108.GA5153@Debian-60-squeeze-64-minimal>
 <20111103190330.02590426@lxorguk.ukuu.org.uk>
 <20111103192039.GA5300@Debian-60-squeeze-64-minimal>
 <4EB2EA93.2050206@parallels.com>
 <4EB2F5CF.5010604@aljex.com>
 <4EB30DAF.4090704@parallels.com>
 <4EB3560D.7000002@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EB3560D.7000002@cn.fujitsu.com>
Organization: Red Hat, Inc.
X-Campaign-1: ()  ASCII Ribbon Campaign
X-Campaign-2: /  Against HTML Email & vCards - Against Microsoft Attachments
User-Agent: Leviathan/19.8.0 [zh] (Cray 3; I; Solaris 4.711; Console)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 04.11.11 11:03, Li Zefan (lizf@cn.fujitsu.com) wrote:

> >> Sure many other processes would legitimately fork/die/fork/die a lot
> >> while never exceeding a few total concurrent tasks, and for them you
> >> would not want to set any such fork limit. So what?
> >>
> > As I said previously, he knows his use cases better than anyone else.
> > If a use case can be found in which the summation of cpu+task controllers is not enough, and if this is implemented as an option to the task controller, and does not make it:
> > 1) confusing,
> > 2) more expensive,
> > 
> > then I don't see why not we shouldn't take it.
> 
> Quoted from Lennart's reply in another mail thread:
> 
> "Given that shutting down some services might involve forking off a few
> things (think: a shell script handling shutdown which forks off a couple
> of shell utilities) we'd want something that is between "from now on no
> forking at all" and "unlimited forking". This could be done in many
> different ways: we'd be happy if we could do time-based rate limiting,
> but we'd also be fine with defining a certain budget of additional forks
> a cgroup can do (i.e. "from now on you can do 50 more forks, then you'll
> get EPERM)."
> 
> (http://lkml.org/lkml/2011/10/19/468)
> 
> The last sentence suggests he might like this fork controller.

Yes, indeed. Limiting forks like this would be pretty much exactly what
we need in systemd to make the shutdown of services robust towards
code which tries to fork faster than we could kill it. I am all in
favour of this code, especially due to its simplicity.

However, I'd like to see this implemented as part of the core cgroup
interfaces, instead of an independent controller. Otherwise we might
have multiple userspace frameworks fighting over it: LXC might want to
take posession of it, systemd too, and Max' own CGI tool might as
well. I believe limiting forks like this is an important part of the
basic cgroup management that userspace needs, independently of what a
specific software actually wants to do with it (i.e. which cgroup
controller it wants to use, if any), and it hence should be available in
all hierarchies, including the named ones that are useful to ensure that
a specific controller is not monopolized by one userspace consumer.

Lennart

-- 
Lennart Poettering - Red Hat, Inc.
