Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755813Ab2JPX4Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 19:56:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60556 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755589Ab2JPX4X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 19:56:23 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CAB=NE6VMxhE8O4J+OaKVNUjJqdBEiNkocvueGFn8Wsa8-AG_bQ@mail.gmail.com>
References: <CAB=NE6VMxhE8O4J+OaKVNUjJqdBEiNkocvueGFn8Wsa8-AG_bQ@mail.gmail.com> <1350085772-8755-1-git-send-email-mcgrof@do-not-panic.com> <3084988.3Xup6S3alX@avalon> <CAB=NE6UUL+zCSMwy4yzZq7+3pDLxZNsusSvXyJv4gi3_rz2ugg@mail.gmail.com> <5298100.2jQ2j2jhxN@avalon>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: dhowells@redhat.com, Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, backports@vger.kernel.org, rob@ti.com,
        arnd@arndb.de, davej@redhat.com, airlied@linux.ie, bskeggs@redhat.com,
        alan@lxorguk.ukuu.org.uk, tglx@linutronix.de, daniel.vetter@ffwll.ch,
        jbarnes@virtuousgeek.org, alexander.deucher@amd.com,
        paulmck@linux.vnet.ibm.com, gregkh@linuxfoundation.org
Subject: Re: [PATCH 1/2] uapi: update includes for drm content when no kernel API exists
Date: Wed, 17 Oct 2012 00:27:30 +0100
Message-ID: <7756.1350430050@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Luis R. Rodriguez <mcgrof@do-not-panic.com> wrote:

> >> The include_next trick can work as well but that'd mean synching the UAPI
> >> files regularly into compat. I'd much prefer to have code intact when
> >> possible when backporting so the option I stuck with then was to patch
> >> the code directly and then as part of compat-drivers to always copy
> >> that day's linux-next UAPI headers into the current directory for
> >> compilation. I see no other driver code using the uapi path explicitly
> >> though, is that by design?
> >
> > As far as I understand that's by design, yes. Kernel code isn't expected to
> > reference uapi/ headers directly.
> 
> Did the design consider the case where no respective kernel API header
> file would ever exist?

I didn't particularly design it such that kernel .c files couldn't access uapi
.h files directly.  I did, however, design it so that my scripts wouldn't have
to touch any .c files where possible, and certainly I didn't want to have to
double up all #includes that refer to KAPI/UAPI split headers.

Ideally, I'd've used #include_next in the KAPI file to refer to the UAPI file
where both exist, but some people have strong objections to that, so I ended
up having to do #include <uapi/...> instead.

I also didn't want to rename the asm/, linux/, etc. prefixes as that would
mandate changing pretty much every #include in the kernel.

For the case where no respective KAPI file exists, it was considered and it is
handled.  This is done by adding extra -I flags, for example:

	-I include
	-I include/uapi

so looking for linux/foo.h, say, will look first for include/linux/foo.h and
then for include/uapi/linux/foo.h.

David
