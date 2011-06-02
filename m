Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754443Ab1FBS0l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 14:26:41 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:65418 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754396Ab1FBS0j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 14:26:39 -0400
MIME-Version: 1.0
Message-ID: <75f89186-d730-4b89-b88c-899cd5674cf0@default>
Date: Thu, 2 Jun 2011 11:26:06 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Steven Whitehouse <swhiteho@redhat.com>
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <jlbec@evilplan.org>,
        Sunil Mushran <sunil.mushran@oracle.com>, linux-kernel@vger.kernel.org
Subject: RE: bug in cleancache ocfs2 hook, anybody want to try cleancache?
References: <da833bdb-7f77-4ebb-ad9b-9fae656b75a1@default
 1307004343.2823.17.camel@menhir>
In-Reply-To: <1307004343.2823.17.camel@menhir>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.4.1.0  (410211) [OL
 12.0.6557.5001]
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4DE7D5D8.0040:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Having started looking at the cleancache code in a bit more detail, I
> have another question... what is the intended mechanism for selecting a
> cleancache backend? The registration code looks like this:
> 
> struct cleancache_ops cleancache_register_ops(struct cleancache_ops
> *ops)
> {
>         struct cleancache_ops old = cleancache_ops;
> 
>         cleancache_ops = *ops;
>         cleancache_enabled = 1;
>         return old;
> }
> EXPORT_SYMBOL(cleancache_register_ops);
> 
> but I wonder what the intent was here. It looks racy to me, and what
> prevents the backend module from unloading while it is in use? Neither
> of the two in-tree callers seems to do anything with the returned
> structure beyond printing a warning if another backend has already
> registered itself. Also why return the structure and not a pointer to
> it? The ops structure pointer passed in should also be const I think.
> 
> From the code I assume that it is only valid to load the module for a
> single cleancache backend at a time, though nothing appears to enforce
> that.

Hi Steven --

The intent was to allow backends to be "chained", but this is
not used yet and not really very well thought through yet either
(e.g. possible coherency issues of chaining).
So, yes, currently only one cleancache backend can be loaded
at time.

There's another initialization issue... if mounts are done
before a backend registers, those mounts are not enabled
for cleancache.   As a result, cleancache backends generally
need to be built-in, not loaded separately as a module.
I've had ideas on how to fix this for some time (basically
recording calls to cleancache_init_fs that occur when no
backend is registered, then calling the backend lazily after
registration occurs).

> Also, as regards your earlier question wrt a kvm backend, I may be
> tempted to have a go at writing one, but I'd like to figure out what
> I'm
> letting myself in for before making any commitment to that,

I think the hardest part is updating the tmem.c module in zcache
to support multiple "clients".  When I ported it from Xen, I tore
all that out.  Fortunately, I've put it back in during RAMster
development but those changes haven't yet seen the light of day
(though I can share them offlist).

The next issue is the guest->host interface.  Is there the equivalent
of a hypercall in KVM?  If so, a shim like drivers/xen/tmem.c is
needed in the guest, and some shim that interfaces the host side
of the hypercall to tmem.c (and presumably zcache).

That may be enough for a proof-of-concept, though Xen has
a bunch of tools and stuff for which KVM would probably want some
equivalent.

If you are at all interested, let's take the details offlist.
It would be great to have a proof-of-concept by KVM Forum!

Thanks,
Dan
