Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932780Ab1DMBeW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 21:34:22 -0400
Received: from smtp-out.google.com ([74.125.121.67]:48325 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932750Ab1DMBeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 21:34:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=FV4PVgy2qyTHQn7OtoAAFh2/CmHf7XUxYVjQG1kLYI1jyA4aJJjCK6XEwbmhL8EE5X
         Fe+6Ah2XtbHFzsysQmpg==
Date: Tue, 12 Apr 2011 18:34:15 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Christoph Lameter <cl@linux.com>
cc: Peter Kruse <pk@q-leap.de>, eric.dumazet@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: I have a blaze of 353 page allocation failures, all alike
In-Reply-To: <alpine.DEB.2.00.1104121306581.14692@router.home>
Message-ID: <alpine.DEB.2.00.1104121830030.14956@chino.kir.corp.google.com>
References: <4D53FE43.8030106@q-leap.com>    <alpine.DEB.2.00.1102141046170.26158@router.home>    <4D5A2EDB.8060603@q-leap.com>    <alpine.DEB.2.00.1102151040560.10511@router.home>    <4D5BC16A.2090205@q-leap.com>    <alpine.DEB.2.00.1102160956250.27814@router.home>
 <4D5BF56F.1000504@q-leap.com>    <alpine.DEB.2.00.1102161010330.27814@router.home>    <4D5CCEED.3010501@q-leap.com>    <alpine.DEB.2.00.1102171102520.11140@router.home> <272bf0cc51439a2ab31ee2f06317dd9f.squirrel@www.q-leap.de> <4D6648B5.1090306@q-leap.com>
 <4DA4692D.7080207@q-leap.de> <alpine.DEB.2.00.1104121306581.14692@router.home>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Apr 2011, Christoph Lameter wrote:

> > > it took a while to find a date for a reboot... Unfortunately
> > > it was not possible to get the early boot messages with the
> > > kernel 2.6.32.23 since the compiled in log buffer is too
> > > small. So we installed as you suggested a more recent kernel
> > > 2.6.32.29 with a bigger log buffer, I attach the dmesg
> > > of that, and hope that the information in there is useful.
> > > We will keep an eye on that server with the newer kernel
> > > to see if the allocation failures appear again.
> > 
> > the server was running for a few without any more allocation
> > failures with kernel 2.6.32.29 but at one point the server
> > stopped responding, it was still possible for a while to
> > get a login, and trying to kill some processes but that
> > didn't succeed.  But after that even login was
> > no longer possible so we had to reset it.
> > I attach the call trace, I hope you can find out what is
> > the problem.
> 
> The problem maybe that you have lots and lots of SCSI devices which
> consume ZONE_DMA memory for their control structures. I guess that is
> oversubscribing the 16M zone.
> 

You can try to get more memory reserves specifically for lowmem in 
ZONE_DMA by changing /proc/sys/vm/lowmem_reserve_ratio.  The values are 
ratios, so lowering the numbers will yield larger amounts of memory 
reserves in ZONE_DMA for GFP_DMA allocations.  Try lowering the non-zero 
entries to 1 to reserve the entire zone for lowmem, assuming your system 
has enough RAM for everything else you're running.

This will verify if ZONE_DMA is being depleted from the larger number of 
SCSI devices.  If you don't get any additional page allocation failures, 
then check how much memory in ZONE_DMA is used at peak and that would be a 
sane reserve ratio to use next time you restart the system.
