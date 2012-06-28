Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932677Ab2F1JEB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 05:04:01 -0400
Received: from e06smtp11.uk.ibm.com ([195.75.94.107]:38466 "EHLO
	e06smtp11.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396Ab2F1JD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 05:03:59 -0400
Date: Thu, 28 Jun 2012 11:03:16 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Alex Williamson <alex.williamson@redhat.com>, avi@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        jan.kiszka@siemens.com
Subject: Re: [PATCH v2 1/6] kvm: Pass kvm_irqfd to functions
Message-ID: <20120628110316.0f53a1ef@BR9GNB5Z>
In-Reply-To: <20120628083857.GD12447@redhat.com>
References: <20120627044758.23698.249.stgit@bling.home>
	<20120627050858.23698.44118.stgit@bling.home>
	<20120627162430.3477d0f6@BR9GNB5Z>
	<20120628083857.GD12447@redhat.com>
Organization: IBM Deutschland Research & Development GmbH Vorsitzende des
 Aufsichtsrats: Martina Koederitz =?UTF-8?B?R2VzY2jDpGZ0c2bDvGhydW5nOg==?=
 Dirk Wittkopp Sitz der Gesellschaft: =?UTF-8?B?QsO2Ymxpbmdlbg==?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
x-cbid: 12062809-5024-0000-0000-0000030E8540
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Jun 2012 11:38:57 +0300
"Michael S. Tsirkin" <mst@redhat.com> wrote:

> On Wed, Jun 27, 2012 at 04:24:30PM +0200, Cornelia Huck wrote:
> > On Tue, 26 Jun 2012 23:09:04 -0600
> > Alex Williamson <alex.williamson@redhat.com> wrote:
> > 
> > > Prune this down to just the struct kvm_irqfd so we can avoid
> > > changing function definition for every flag or field we use.
> > > 
> > > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> > 
> > I'm currently trying to find a way to make irqfd workable for s390
> > which will likely include using a new field in kvm_irqfd, so I'd like
> > to have this change (and I also think it makes the code nicer to read).
> > So:
> > 
> > Acked-by: Cornelia Huck <cornelia.huck@de.ibm.com>
> 
> Unfortunately it looks like we are not sanitizing kvm_irqfd
> at all so we won't be able to use the padding :(
> We'll need a new ioctl instead.
> 

How about something like this as parameter for the new ioctl?

struct kvm_irqfd2 {
	__u32 fd;
	__u32 flags;  /* for things like deassign */
	__u64 type;   /* determines the payload */
	union {
		/* type traditional */
		struct {
			__u32 gsi;
		} trad;
		/* type s390 */
		struct {
			__u32 int_type;
			__u32 parm;
			__u64 parm64;
		} s390;
		__u8 pad[20];
	};
}

This could be combined with an arch or a per-kvm callback to keep the
generic code clean of architecture dependencies.

Cornelia

