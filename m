Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752903Ab0JAQlQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 12:41:16 -0400
Received: from mail.digidescorp.com ([66.244.163.200]:14484 "EHLO
	digidescorp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988Ab0JAQlP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 12:41:15 -0400
X-Spam-Processed: digidescorp.com, Fri, 01 Oct 2010 11:41:14 -0500
X-Authenticated-Sender: steve@digidescorp.com
X-MDRemoteIP: 12.54.16.226
X-Return-Path: prvs=18902378fd=steve@digidescorp.com
X-Envelope-From: steve@digidescorp.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH][RESEND] nommu: add anonymous page memcg accounting
From: "Steven J. Magnani" <steve@digidescorp.com>
Reply-To: steve@digidescorp.com
To: David Howells <dhowells@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        kamezawa.hiroyu@jp.fujitsu.com
In-Reply-To: <5867.1285945621@redhat.com>
References: <WC20101001143139.810346@digidescorp.com>
	 <1285929315-2856-1-git-send-email-steve@digidescorp.com>
	 <5206.1285943095@redhat.com>  <5867.1285945621@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Digital Design Corporation
Date: Fri, 01 Oct 2010 11:41:07 -0500
Message-ID: <1285951267.2558.69.camel@iscandar.digidescorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-10-01 at 16:07 +0100, David Howells wrote: 
> Steve Magnani <steve@digidescorp.com> wrote:
> 
> > If anything I think nommu is one of the better applications of memcg. Since
> > nommu typically embedded, being able to put potential memory pigs in a
> > sandbox so they can't destabilize the system is a Good Thing. That was my
> > motivation for doing this in the first place and it works quite well.
> 
> I suspect it's not useful for a few reasons:
> 
>  (1) You don't normally run many applications on a NOMMU system.  Typically,
>      you'll run just one, probably threaded app, I think.

Not always.

> 
>  (2) In general, you won't be able to cull processes to make space.  If the OOM
>      killer runs your application has a bug in it.

Not always. Every now and then applications have to deal with
user-supplied input of some sort. 

In our case it's a user-formatted disk drive that can have some
arbitrarily-sized FAT32 partition on which we are required to run
dosfsck. Now, dosfsck is the epitome of a memory pig; its memory
requirements scale with partition size, number of dentries, and any
damage encountered - none of which can be predicted. There is a set of
partitions we are able to check with no problem, but no guarantee the
user won't present us with one that would bring down the whole system,
were the OOM killer to get involved. Putting just dosfsck in its own
sandbox ensures this can't happen. See also my response to #4 below.

> 
>  (3) memcg has a huge overhead.  20 bytes per page!  On a 4K page 32-bit
>      system, that's nearly 5% of your RAM, assuming I understand the
>      CGROUP_MEM_RES_CTLR config help text correctly.

When you use 16K pages, 20 bytes/page isn't so huge :)

> 
>  (4) There's no swapping, no page faults, no migration and little shareable
>      memory.  Being able to allocate large blocks of contiguous memory is much
>      more important and much more of a bottleneck than this.  The 5% of RAM
>      lost makes that just that little bit harder.
> 
> If it's memory sandboxing you require, ulimit might be sufficient for NOMMU
> mode.

dosfsck is written to handle memory allocation failures properly
(bailing out) but I have not been able to get this code to execute when
the system runs out of memory - the OOM killer gets invoked and that's
all she wrote. Will a ulimit violation return control back to the
process, or terminate it in some graceful manner? 

> 
> However, I suppose there's little harm in letting the patch in.  I would guess
> the additions all optimise away if memcg isn't enabled.
> 
> A question for you: why does struct page_cgroup need a page pointer?  If an
> array of page_cgroup structs is allocated per array of page structs, then you
> should be able to use the array index to map between them.

Kame is probably better able to answer this.
 
Steve


