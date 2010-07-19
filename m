Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936275Ab0GSPcW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 11:32:22 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:16913 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936235Ab0GSPcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 11:32:16 -0400
Date: Mon, 19 Jul 2010 11:31:49 -0400
From: Chris Mason <chris.mason@oracle.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: 2.6.35 Regression/oops from virtio: return ENOMEM on out of
 memory patch
Message-ID: <20100719153149.GF8623@think>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	"Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org,
	Rusty Russell <rusty@rustcorp.com.au>
References: <20100719150216.GC8623@think>
 <20100719151609.GA4267@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100719151609.GA4267@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4C446FEE.02CE:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 19, 2010 at 06:16:10PM +0300, Michael S. Tsirkin wrote:
> On Mon, Jul 19, 2010 at 11:02:16AM -0400, Chris Mason wrote:
> > Hi everyone,
> > 
> > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=686d363786a53ed28ee875b84ef24e6d5126ef6f
> > 
> > I've been having problems with my long running stress runs and tracked
> > it down to the above commit.  Under load I get a couple of GFP_ATOMIC
> > allocation failures from virtio per day (not really surprising), and in
> > the past it would carry on happily.
> > 
> > Now I get the atomic allocation failure followed by this:
> > 
> > BUG: unable to handle kernel paging request at ffff88087c37e458
> > IP: [<ffffffff812e3752>] virtqueue_add_buf_gfp+0x305/0x353
> > 
> > (Full oops below).
> > 
> > Looking at virtqueue_add_buf_gfp, it does:
> > 
> >         /* If the host supports indirect descriptor tables, and we have multiple 
> >          * buffers, then go indirect. FIXME: tune this threshold */
> >         if (vq->indirect && (out + in) > 1 && vq->num_free) {
> >                 head = vring_add_indirect(vq, sg, out, in, gfp);
> >                 if (head != vq->vring.num)
> >                         goto add_head;
> >         }
> > [ ... ]
> > 
> > add_head:
> >         /* Set token. */
> >         vq->data[head] = data;
> > 
> > Since vring_add_indirect is returning -ENOMEM, head is -ENOMEM and things
> > go bad pretty quickly.  Full oops below, afraid I don't know the virtio
> > code well enough to provide the clean and obvious fix (outside of
> > reverting) at this late rc.
> 
> Good catch! Can you verify this fix please?
> 
> virtio: fix oops on OOM
> 
> virtio ring was changed to return an error code on OOM,
> but one caller was missed and still checks for vq->vring.num.
> The fix is just to check for <0 error code.
> 
> Long term it might make sense to change goto add_head to
> just return an error on oom instead, but let's apply
> a minimal fix for 2.6.35.
> 

Great, that looks sane, I'll give it a shot.

-chris
