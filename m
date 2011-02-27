Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752392Ab1B0Xov (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Feb 2011 18:44:51 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:56559 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149Ab1B0XoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Feb 2011 18:44:20 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: =?iso-8859-2?q?Micha=B3_Miros=B3aw?= <mirqus@gmail.com>
Subject: Re: [PATCH] don't allow CAP_NET_ADMIN to load non-netdev kernel modules
Date: Sun, 27 Feb 2011 21:22:52 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Ben Hutchings <bhutchings@solarflare.com>,
        David Miller <davem@davemloft.net>, segoon@openwall.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kuznet@ms2.inr.ac.ru, pekkas@netcore.fi, jmorris@namei.org,
        yoshfuji@linux-ipv6.org, kaber@trash.net, eric.dumazet@gmail.com,
        therbert@google.com, xiaosuo@gmail.com, jesse@nicira.com,
        kees.cook@canonical.com, eugene@redhat.com, dan.j.rosenberg@gmail.com,
        akpm@linux-foundation.org
References: <1298660879.2554.23.camel@bwh-desktop> <1298666310.2554.47.camel@bwh-desktop> <AANLkTikmtKksP6o1hecf0=ZnRv0j4+_Q326UEG8ss16k@mail.gmail.com>
In-Reply-To: <AANLkTikmtKksP6o1hecf0=ZnRv0j4+_Q326UEG8ss16k@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 8bit
Message-Id: <201102272122.52643.arnd@arndb.de>
X-Provags-ID: V02:K0:0u5lzkSjQ2GkFL03H/XhzVlDncckiYu6uO6+2pcQJ++
 AXAozgyum2Ql+JNGEkGTQubj+eKmeXw0pv2Q10yDgrzzocEiKH
 z8AgAfmO4V7EDazo1KihhCZZuj5KkgA2uVJFo5go//6PMWHxLg
 r0uwEoPSTmjbyrBnMbX4kIKD4zVGRP36tuRYPdFquLeNGsbWHj
 7W60S7vtZfNh9MvVQlVPQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 25 February 2011, Micha³ Miros³aw wrote:
> > diff --git a/net/core/dev.c b/net/core/dev.c
> > index 54aaca6..0d09baa 100644
> > --- a/net/core/dev.c
> > +++ b/net/core/dev.c
> > @@ -1120,8 +1120,20 @@ void dev_load(struct net *net, const char *name)
> >        dev = dev_get_by_name_rcu(net, name);
> >        rcu_read_unlock();
> >
> > -       if (!dev && capable(CAP_NET_ADMIN))
> > -               request_module("%s", name);
> > +       if (!dev && capable(CAP_NET_ADMIN)) {
> > +               /* Check whether the name looks like one that a net
> > +                * driver will generate initially.  If not, require a
> > +                * module alias with a suitable prefix, so that this
> > +                * can't be used to load arbitrary modules.
> > +                */
> > +               if ((strncmp(name, "eth", 3) == 0 &&
> > +                    isdigit((unsigned char)name[3])) ||
> > +                   (strncmp(name, "wlan", 4) == 0 &&
> > +                    isdigit((unsigned char)name[4])))
> > +                       request_module("%s", name);
> > +               else
> > +                       request_module("netdev-%s", name);
> > +       }
> >  }
> >  EXPORT_SYMBOL(dev_load);
> >
> 
> This might be better as:
> 
> if (request_module("netdev-%s", name))
>     ... fallback
> 
> Then after some years the fallback could be removed if announced properly.

The backwards compatibility should mostly be for systems that today don't
use split capabilities, right?

The fallback could therefore rely on CAP_SYS_MODULE as well:

	if (request_module("netdev-%s", name)) {
		if (capable(CAP_SYS_MODULE))
			request_module("%s", name);
	}

Not 100% solution, but should solve the capability escalation nicely without
causing much pain.

	Arnd

