Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754551Ab0I1PMY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 11:12:24 -0400
Received: from relay1.sgi.com ([192.48.179.29]:37931 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752006Ab0I1PMX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 11:12:23 -0400
Date: Tue, 28 Sep 2010 10:12:18 -0500
From: Robin Holt <holt@sgi.com>
To: Avi Kivity <avi@redhat.com>
Cc: Nathan Fontenot <nfont@austin.ibm.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linuxppc-dev@ozlabs.org, Greg KH <greg@kroah.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 0/8] v2 De-Couple sysfs memory directories from memory
 sections
Message-ID: <20100928151218.GJ14068@sgi.com>
References: <4CA0EBEB.1030204@austin.ibm.com>
 <4CA1E338.6070201@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CA1E338.6070201@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 28, 2010 at 02:44:40PM +0200, Avi Kivity wrote:
>  On 09/27/2010 09:09 PM, Nathan Fontenot wrote:
> >This set of patches decouples the concept that a single memory
> >section corresponds to a single directory in
> >/sys/devices/system/memory/.  On systems
> >with large amounts of memory (1+ TB) there are perfomance issues
> >related to creating the large number of sysfs directories.  For
> >a powerpc machine with 1 TB of memory we are creating 63,000+
> >directories.  This is resulting in boot times of around 45-50
> >minutes for systems with 1 TB of memory and 8 hours for systems
> >with 2 TB of memory.  With this patch set applied I am now seeing
> >boot times of 5 minutes or less.
> >
> >The root of this issue is in sysfs directory creation. Every time
> >a directory is created a string compare is done against all sibling
> >directories to ensure we do not create duplicates.  The list of
> >directory nodes in sysfs is kept as an unsorted list which results
> >in this being an exponentially longer operation as the number of
> >directories are created.
> >
> >The solution solved by this patch set is to allow a single
> >directory in sysfs to span multiple memory sections.  This is
> >controlled by an optional architecturally defined function
> >memory_block_size_bytes().  The default definition of this
> >routine returns a memory block size equal to the memory section
> >size. This maintains the current layout of sysfs memory
> >directories as it appears to userspace to remain the same as it
> >is today.
> >
> 
> Why not update sysfs directory creation to be fast, for example by
> using an rbtree instead of a linked list.  This fixes an
> implementation problem in the kernel instead of working around it
> and creating a new ABI.

Because the old ABI creates 129,000+ entries inside
/sys/devices/system/memory with their associated links from
/sys/devices/system/node/node*/ back to those directory entries.

Thankfully things like rpm, hald, and other miscellaneous commands scan
that information.  On our 8 TB test machine, hald runs continuously
following boot for nearly an hour mostly scanning useless information
from /sys/

Robin

> 
> New ABIs mean old tools won't work, and new tools need to understand
> both ABIs.
> 
> -- 
> error compiling committee.c: too many arguments to function
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
