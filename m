Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760563Ab0LOE5k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 23:57:40 -0500
Received: from smtp-out.google.com ([216.239.44.51]:10254 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760542Ab0LOE5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 23:57:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=NvNSs1u2L47MkV1MTP/ap9//9MIcb6oQeq6Gl2uwZsfH+TMv82nRMOvvm/fxeYOjT3
         yaZn1/tJdKFpD1BJAjEg==
Date: Tue, 14 Dec 2010 20:57:28 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hughd@tigran.mtv.corp.google.com
To: "Martin K. Petersen" <martin.petersen@oracle.com>
cc: Ric Wheeler <ricwheeler@gmail.com>, Christian Brandt <brandtc@psi5.com>,
        linux-kernel@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>
Subject: Re: swap storage alignment and stride size
In-Reply-To: <yq1d3p486qe.fsf@sermon.lab.mkp.net>
Message-ID: <alpine.LSU.2.00.1012142038430.13004@tigran.mtv.corp.google.com>
References: <4CFFBA7D.6060802@psi5.com> <4CFFE2EA.9040909@gmail.com> <yq1d3p486qe.fsf@sermon.lab.mkp.net>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Dec 2010, Martin K. Petersen wrote:
> >>>>> "Ric" == Ric Wheeler <ricwheeler@gmail.com> writes:
> 
> Ric> There has been a lot of work on alignment, Martin Petersen lead
> Ric> most of that and is probably the best one to ping.
> 
> With modern tooling we should align the partition or DM device correctly
> so the swap starts on a properly aligned boundary. But I don't think
> anybody has looked into hooking the swap stuff up with the I/O
> topology. I'm also not sure the swap code is flexible enough to deal
> with units that are bigger than page size.

You and Christian are right, mm/swapfile.c is very much oriented to
the small mm page size, 4kB on x86.

Yes, when it's running nicely, the elevator can make a big difference
by merging adjacent writes to swap; but swapping is often by nature
not so nice.

I think it would be a big mistake to try to build the idea of bigger
blocks into mm/swapfile.c: it is so orientated towards the mm concerns
that we'd end up with a mess that way.

Much better to add a dm layer below it, to buffer such alignment and
stride concerns.  Perhaps someone has already done that?

(scan_swap_map does try to allocate in 1MB clusters, but they're not
written out that way, and there's no attempt to align: if it worked
out better for the lower level to require that these 1MB clusters
are aligned, we could probably go for that - though the swap header
page might then be a nuisance.)

Hugh
