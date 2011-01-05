Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752522Ab1AESvL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 13:51:11 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:64761 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751780Ab1AESvJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 13:51:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=ZgKVJJmz4Uvoek5y5jF8B3w9DnfC3QIfLpem4xr01GB3HtgZKH2H9fXgbQLe3hhvvX
         TU7/VNeypmzu9/9KpCJNtldnUI2k+kp1d309W+KOPMufHc88D5DcfwWiOUBdoVIpZnCF
         unKsneILMxkoDfWsxGm4Jw7YXO2LsMf0o3QDE=
MIME-Version: 1.0
In-Reply-To: <AANLkTinft80dXqE-U=YDB23d9=BgXLCxJzgiA_gF4cVL@mail.gmail.com>
References: <1294172717-6044-1-git-send-email-penberg@kernel.org>
 <alpine.DEB.2.00.1101041939030.27551@chino.kir.corp.google.com>
 <alpine.DEB.2.00.1101050943120.13032@router.home> <alpine.DEB.2.00.1101051108520.14761@router.home>
 <AANLkTinft80dXqE-U=YDB23d9=BgXLCxJzgiA_gF4cVL@mail.gmail.com>
From: Bart Van Assche <bvanassche@acm.org>
Date: Wed, 5 Jan 2011 19:50:49 +0100
X-Google-Sender-Auth: L5d3e5_hmZ8cO9pU9aDir_X7HUs
Message-ID: <AANLkTinCZzJWYGnxXq_Nwv7QSkEV4Tg-te-1y0PCeRRY@mail.gmail.com>
Subject: Re: [PATCH] slub: Fix sysfs circular locking dependency
To: Pekka Enberg <penberg@kernel.org>
Cc: Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 5, 2011 at 7:26 PM, Pekka Enberg <penberg@kernel.org> wrote:
>
> On Wed, Jan 5, 2011 at 7:10 PM, Christoph Lameter <cl@linux.com> wrote:
> > How about this solution? In the common case of kernels without hotplug
> > support there will be no locking at all.
> >
> >
> > Subject: slub: Avoid use of slub_lock in show_slab_objects()
> >
> > The purpose of the locking is to prevent removal and additions
> > of nodes when statistics are gathered for a slab cache. So we
> > need to avoid racing with memory hotplug functionality.
> >
> > It is enough to take the memory hotplug locks there instead
> > of the slub_lock.
> >
> >
> > Signed-off-by: Christoph Lameter <cl@linux.com>
> >
> > ---
> >  mm/slub.c |    4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > Index: linux-2.6/mm/slub.c
> > ===================================================================
> > --- linux-2.6.orig/mm/slub.c    2011-01-05 09:55:34.000000000 -0600
> > +++ linux-2.6/mm/slub.c 2011-01-05 09:56:27.000000000 -0600
> > @@ -3821,7 +3821,7 @@ static ssize_t show_slab_objects(struct
> >                }
> >        }
> >
> > -       down_read(&slub_lock);
> > +       lock_memory_hotplug();
> >  #ifdef CONFIG_SLUB_DEBUG
> >        if (flags & SO_ALL) {
> >                for_each_node_state(node, N_NORMAL_MEMORY) {
> > @@ -3862,7 +3862,7 @@ static ssize_t show_slab_objects(struct
> >                        x += sprintf(buf + x, " N%d=%lu",
> >                                        node, nodes[node]);
> >  #endif
> > -       up_read(&slub_lock);
> > +       unlock_memory_hotplug();
> >        kfree(nodes);
> >        return x + sprintf(buf + x, "\n");
> >  }
>
> Makes sense. Bart, does this fix the problem for you?

The action sequence that had triggered this sequence (invoke
kmem_cache_create(); read all files in /sys/kernel/slab; invoke
kmem_cache_destroy()) does now pass without triggering lock inversion
complaints.

Bart.
