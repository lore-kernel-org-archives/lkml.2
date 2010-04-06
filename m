Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756133Ab0DFA1j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 20:27:39 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:63203 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754909Ab0DFA1e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 20:27:34 -0400
MIME-Version: 1.0
Message-ID: <ac1d8fae-d630-45ce-b2aa-84f850cdeda0@default>
Date: Mon, 5 Apr 2010 17:26:03 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Dmitry Torokhov <dtor@vmware.com>, linux-kernel@vger.kernel.org,
       pv-drivers@vmware.com, Avi Kivity <avi@redhat.com>
Subject: RE: [PATCH] VMware Balloon driver
References: <20100404215202.GA13020@dtor-ws.eng.vmware.com>
 <20100405142419.2c9bea3d.akpm@linux-foundation.org> <4BBA5E1C.10706@goop.org>
 <20100405151720.8a6ac5e3.akpm@linux-foundation.org>
 <4BBA7226.9080508@goop.org 20100405163458.135fa319.akpm@linux-foundation.org>
In-Reply-To: <20100405163458.135fa319.akpm@linux-foundation.org>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 1.5.1.5.2  (401224) [OL
 12.0.6514.5000]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4BBA7FDF.012A:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Andrew Morton [mailto:akpm@linux-foundation.org]
> Sent: Monday, April 05, 2010 5:35 PM
> To: Jeremy Fitzhardinge
> Cc: Dmitry Torokhov; linux-kernel@vger.kernel.org; pv-
> drivers@vmware.com; Avi Kivity; Dan Magenheimer
> Subject: Re: [PATCH] VMware Balloon driver
> 
> On Mon, 05 Apr 2010 16:28:38 -0700
> Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> 
> > And is there some way to get the vm subsystem to provide
> backpressure:
> > "I'm getting desperately short of memory!"?
> 
> Not really.  One could presumably pull dopey tricks by hooking into
> slab shrinker registration or even ->writepage().  But cooking up
> something explicit doesn't sound too hard - the trickiest bit would be
> actually defining what it should do.

Sorry, I don't mean to be too self-serving.  And I am far less
an expert in Linux mm code than others involved in this discussion.

But this backpressure metric is one thing that frontswap provides.
It also provides an "insurance policy" for "desperately short
of memory".  It is the "yin" to the "yang" of cleancache.

If I understand the swap subsystem correctly, there IS NO
"getting desperately short of memory" except when a swap
device is unavailable or, more likely, too darn slow.

Frontswap writes synchronously to pseudo-RAM (tmem, in the
case of Xen) instead of a slow asynchronous swap device.  It
hooks directly into swap_writepage()/swap_readpage() in
a very clean, well-defined (not dopey) way.
So -- I think -- it is a perfect feedback mechanism to
tell a balloon driver (or equivalent), "I need more memory"
while covering the short-term need until the balloon driver
(and/or hypervisor) can respond.

It works today with Xen, and Nitin Gupta is working on an
in-kernel memory compression backend for it.  And Chris Mason
and I think it may also be a fine interface for SSD-used-
as-RAM-extension.

So please consider frontswap and cleancache before "cooking
up something [else] explicit"...  these were previously part
of Transcendent Memory postings*, but I have revised them to
be more useful, well-defined, and standalone (from Xen/tmem)
and will be re-posting the revised versions soon.

Dan

* See:
http://lwn.net/Articles/340080/ 
http://lkml.indiana.edu/hypermail/linux/kernel/0912.2/01322.html 
OLS 2009 proceedings
LCA 2010 proceedings
