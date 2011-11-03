Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755598Ab1KCOnw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 10:43:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24790 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753215Ab1KCOnu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 10:43:50 -0400
Date: Thu, 3 Nov 2011 10:43:47 -0400
From: Josh Boyer <jwboyer@redhat.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: sb_edac 32-bit compile fail due to 64-bit divide
Message-ID: <20111103144347.GG19809@zod.bos.redhat.com>
References: <20111103140716.GF19809@zod.bos.redhat.com>
 <4EB2A5FF.1040808@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EB2A5FF.1040808@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 03, 2011 at 12:32:31PM -0200, Mauro Carvalho Chehab wrote:
> Em 03-11-2011 12:07, Josh Boyer escreveu:
> > Hi,
> > 
> > It seems the newly added EDAC driver for SandyBridge won't build on
> > 32-bit x86 because of a 64-bit divide somewhere:
> > 
> > 	drivers/edac/sb_edac.c: In function 'get_memory_error_data':
> > 	drivers/edac/sb_edac.c:861:2: warning: left shift count >= width of type
> > 	[enabled by default]
> > 	<snip>
> > 	ERROR: "__udivdi3" [drivers/edac/sb_edac.ko] undefined!
> > 	make[1]: *** [__modpost] Error 1
> > 	make: *** [modules] Error 2
> > 
> > You can find the full build log here:
> > 
> > http://koji.fedoraproject.org/koji/getfile?taskID=3482579&name=build.log
> > 
> > Before I go digging into where this is done and what to do about it, I
> > do want to confirm that it is supposed to work on a 32-bit kernel,
> > correct?
> 
> Thanks for pointing it!
> 
> Well, I didn't test it on a 32-bit kernel. It should work through.
> 
> It is probably due to those debug lines:
> 	debugf0("CH#%d RIR#%d INTL#%d, offset %Lu.%03Lu GB (0x%016Lx), tgt: %d, reg=0x%08x\n",
>         	i, j, k,
>                 tmp_mb / 1000, tmp_mb % 1000,
>                 ((u64)tmp_mb) << 20L,
>                 (u32)RIR_RNK_TGT(reg),
>                 reg);
> (same kind of calculus is recurrent at the driver)

All of that should basically not exist in this build because the debugf*
macros depend on CONFIG_EDAC_DEBUG, which isn't set in this build.  The
problem seems to be somewhere else.

I would guess line 1056:

	addr /= sck_xch;

addr is a u64.

> Maybe the easiest way would be to write a function that would call do_div() internally,
> and output a string with something similar to:
> 
> 	sprintf(msg, "%Lu.%03Lu GB", tmp_mb / 1000, tmp_mb % 1000);
> 
> Of course, an interim fix would be to make it depend on CONFIG_64BIT or CONFIG_X86_64.

That would work I guess.  It's up to you.
> 
> Regards,
> Mauro
