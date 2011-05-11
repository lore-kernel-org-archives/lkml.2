Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756864Ab1EKWXO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 18:23:14 -0400
Received: from kroah.org ([198.145.64.141]:47195 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756759Ab1EKWXN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 18:23:13 -0400
Date: Wed, 11 May 2011 15:21:57 -0700
From: Greg KH <greg@kroah.com>
To: Anton Blanchard <anton@samba.org>
Cc: gregkh@suse.de, nfont@austin.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] memory hotplug: Speed up add/remove when blocks are
 larger than PAGES_PER_SECTION
Message-ID: <20110511222157.GA11840@kroah.com>
References: <20110511172514.7e30970d@kryten>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110511172514.7e30970d@kryten>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 11, 2011 at 05:25:14PM +1000, Anton Blanchard wrote:
> 
> On ppc64 the minimum memory section for hotplug is 16MB but most
> recent machines have a memory block size of 256MB. This means
> memory_block_change_state does 16 separate calls to
> memory_section_action.
> 
> This also means we call the notifiers 16 times and the hook
> in the ehea network driver is quite costly. To offline one 256MB
> region takes:
> 
> # time echo offline > /sys/devices/system/memory/memory32/state
> 7.9s
> 
> This patch removes the loop and calls online_pages or
> remove_memory once for the entire region and in doing so makes
> the logic simpler since we don't have to back out if things fail
> part way through.
> 
> The same test to offline one region now takes:
> 
> # time echo online > /sys/devices/system/memory/memory32/state
> 0.67s
> 
> Over 11 times faster.
> 
> Signed-off-by: Anton Blanchard <anton@samba.org>

Your patch introduced a compiler warning, care to send a follow-on patch
fixing this up:
	drivers/base/memory.c: In function ‘memory_block_change_state’:
	drivers/base/memory.c:281:6: warning: unused variable ‘i’

thanks,

greg k-h
