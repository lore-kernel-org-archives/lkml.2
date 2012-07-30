Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753922Ab2G3HKI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 03:10:08 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:34914 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752487Ab2G3HKG convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:5:1>);
	Mon, 30 Jul 2012 03:10:06 -0400
Message-Id: <50164F68020000780009132F@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Mon, 30 Jul 2012 08:10:00 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Konrad Rzeszutek Wilk" <konrad@darnok.org>
Cc: "Stefano Stabellini" <stefano.stabellini@eu.citrix.com>,
        "xen-devel" <xen-devel@lists.xen.org>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 5/7] xen/p2m: Add logic to revector a
 P2M tree to use __va leafs.
References: <1343335652-5659-1-git-send-email-konrad.wilk@oracle.com>
 <1343335652-5659-6-git-send-email-konrad.wilk@oracle.com>
 <alpine.DEB.2.02.1207271215540.26163@kaball.uk.xensource.com>
 <50129C030200007800090F9B@nat28.tlf.novell.com>
 <20120727173459.GB17427@andromeda.dapyr.net>
In-Reply-To: <20120727173459.GB17427@andromeda.dapyr.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 27.07.12 at 19:34, Konrad Rzeszutek Wilk <konrad@darnok.org> wrote:
> On Fri, Jul 27, 2012 at 12:47:47PM +0100, Jan Beulich wrote:
>> >>> On 27.07.12 at 13:18, Stefano Stabellini <stefano.stabellini@eu.citrix.com> 
> wrote:
>> > On Thu, 26 Jul 2012, Konrad Rzeszutek Wilk wrote:
>> >>  1) All P2M lookups instead of using the __ka address would
>> >>     use the __va address. This means we can safely erase from
>> >>     __ka space the PMD pointers that point to the PFNs for
>> >>     P2M array and be OK.
>> >>  2). Allocate a new array, copy the existing P2M into it,
>> >>     revector the P2M tree to use that, and return the old
>> >>     P2M to the memory allocate. This has the advantage that
>> >>     it sets the stage for using XEN_ELF_NOTE_INIT_P2M
>> >>     feature. That feature allows us to set the exact virtual
>> >>     address space we want for the P2M - and allows us to
>> >>     boot as initial domain on large machines.
>> >> 
>> >> So we pick option 2).
>> > 
>> > 1) looks like a decent option that requires less code.
>> > Is the problem with 1) that we might want to access the P2M before we
>> > have __va addresses ready?
>> 
>> AIUI 1) has no easy way of subsequently accommodating support
>> for XEN_ELF_NOTE_INIT_P2M (where you almost definitely will
>> want/need to reclaim the originally used VA space - if nothing else,
>> then for forward compatibility with the rest of the kernel).
> 
> <nods> That was my thinking - this way we can boot dom0 (since
> the hypervisor is the only one that implements the
> XEN_ELF_NOTE_INIT_P2M) with large amount of memory. Granted booting
> with more than 500GB would require adding another layer to the P2M
> tree. But somehow I thought that we are limited in the hypervisor
> to 500GB?

The only limitation is that kexec (with the current specification)
would not work beyond 512Gb, but that's a non-issue for
upstream since kexec doesn't work there yet anyway. Our
kernels come up fine even on 5Tb now (which is the current
limit in the hypervisor).

Jan

