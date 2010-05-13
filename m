Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759595Ab0EMWqi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 18:46:38 -0400
Received: from mga12.intel.com ([143.182.124.36]:11626 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759546Ab0EMWqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 18:46:35 -0400
Message-Id: <89k83a$882me0@azsmga001.ch.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,224,1272870000"; 
   d="scan'208";a="276912576"
Date: Thu, 13 May 2010 23:46:30 +0100
To: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>,
       dri-devel@lists.freedesktop.org, Dave Airlie <airlied@linux.ie>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: render error detected, EIR: 0x00000010
References: <AANLkTikfzHWeVjto4Q8bWDie_5BjRz3V0fc3LW7k4uob@mail.gmail.com>
From: Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <AANLkTikfzHWeVjto4Q8bWDie_5BjRz3V0fc3LW7k4uob@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 May 2010 03:59:08 +0530, Jaswinder Singh Rajput <jaswinderlinux@gmail.com> wrote:
> Hello Chris,
> 
> I am also getting display error on another PC :
> 
> [   34.198957] render error detected, EIR: 0x00000010
> [   34.198972] [drm:i915_handle_error] *ERROR* EIR stuck: 0x00000010, masking
> [   34.198998] render error detected, EIR: 0x00000010

Wow. Things are really amiss there. MI_SET_CONTEXT (the first instruction
in the batch) was removed in

  commit 45f45c73469f1bd46a1b6fb206f2e9e5e4fd66b3
  Author: Eric Anholt <eric@anholt.net>
  Date:   Mon Dec 29 11:26:11 2008 -0800

      Remove logical context setup.

which explains why the destination bo is not on the active list, you
have a pre-GEM UMS xf86-video-intel (so the batchbuffer is using absolute
addressing rather than relocs and the kernel memory manager). The hardware
is reporting a PTE error (in the overlay plane!) and the single active
command is to clear the absolute buffer. As it is not being tracked by the
kernel, I can't tell you what's wrong with the buffer, but most probably
either the size or its stride is illegal in the context of that command.
Or maybe even the GTT hasn't been fully initialised for the buffer, it is
impossible to tell.

In short, you can trade this bug against the risk of GTT incoherency that
is endemic on i8xx by updating your driver.

-- 
Chris Wilson, Intel Open Source Technology Centre
