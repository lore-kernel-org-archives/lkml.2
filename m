Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758752Ab1DNPN7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 11:13:59 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:33643 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752167Ab1DNPN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 11:13:58 -0400
Date: Thu, 14 Apr 2011 11:13:58 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Mike Frysinger <vapier@gentoo.org>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        <uclinux-dist-devel@blackfin.uclinux.org>,
        <linux-pm@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] freezer: should barriers be smp ?
In-Reply-To: <BANLkTi=_+kYvs3_dsXifd_rkxfmFzJLttA@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1104141104160.2487-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Apr 2011, Mike Frysinger wrote:

> > On Wed, Apr 13, 2011 at 18:49, Rafael J. Wysocki wrote:

> > In my opinion is an architecture problem, not the freezer code problem.
> 
> OK, we have a patch pending locally which populates all barriers with
> this logic, but based on my understanding of things, that didnt seem
> correct.  i guess i'm reading too much into the names ... i'd expect
> the opposite behavior where "rmb" is only for UP needs while "smp_rmb"
> is a rmb which additionally covers SMP.

You are misinterpreting the names and the concepts, both.

First, you need to understand that memory barriers are needed only for
purposes of synchronizing between two different entities capable of
accessing memory (obviously it's not necessary to synchronize an entity
with itself).  One of those entities is always a CPU, of course; the
other entity could be a DMA-capable device or it could be another CPU.

A device driver might need to use memory barriers even on a UP
platform, because it might need to synchronize the CPU with the device
it is driving.

But core kernel code is concerned only with CPUs.  Therefore on UP 
systems, core kernel code (such as the freezer) never needs to use 
memory barriers.

That's the difference between rmb() and smp_rmb().  rmb() _always_ 
generates a memory barrier, so it should be used only in device 
drivers.  smp_rmb() generates a memory barrier only if CONFIG_SMP is 
enabled; otherwise it merely generates a compiler barrier.

In the freezer, there is no reason to use rmb() and wmb().  It should 
use smp_rmb() and smp_wmb().

Alan Stern

