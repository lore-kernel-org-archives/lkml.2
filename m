Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752187Ab1DRU1x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 16:27:53 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40010 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751593Ab1DRU1u convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 16:27:50 -0400
MIME-Version: 1.0
In-Reply-To: <20110418200204.GA2522@joi.lan>
References: <20110407151129.GA24977@comet.dominikbrodowski.net>
 <20110414170559.GA10768@comet.dominikbrodowski.net> <20110414190117.GA3493@joi.lan>
 <20110415061136.GA21979@isilmar-3.linta.de> <4DAA1453.5000604@nigelcunningham.com.au>
 <20110416235028.GA6096@taurine.csclub.uwaterloo.ca> <20110417151204.GA24519@taurine.csclub.uwaterloo.ca>
 <20110417154557.GA2871@joi.lan> <20110417162427.GB25242@taurine.csclub.uwaterloo.ca>
 <20110417164920.GA2626@joi.lan> <20110418200204.GA2522@joi.lan>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 18 Apr 2011 13:27:10 -0700
Message-ID: <BANLkTi=Oo03CQchHYh4EvEsk+wZy7akLNw@mail.gmail.com>
Subject: Re: 2.6.39-rc1 nouveau(?) regression (bisected)
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Kyle Spaans <kspaans@uwaterloo.ca>, linux-kernel@vger.kernel.org,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Ben Skeggs <bskeggs@redhat.com>, airlied@redhat.com,
        dri-devel@lists.freedesktop.org, mjg@redhat.com,
        maciej.rutecki@gmail.com, nouveau@lists.freedesktop.org,
        Nigel Cunningham <lkml@nigelcunningham.com.au>,
        Nick Piggin <npiggin@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 18, 2011 at 1:02 PM, Marcin Slusarz
<marcin.slusarz@gmail.com> wrote:
>
> It's some nasty corruption:

Looks like something wrote 0xffffffff to free'd memory.

Enabling DEBUG_PAGEALLOC *might* show where it happens.

>
> [    6.523867] =============================================================================
> [    6.523916] BUG sysfs_dir_cache: Poison overwritten
> [    6.523949] -----------------------------------------------------------------------------
> [    6.523950]
> [    6.524016] INFO: 0xffff8801bb47df4c-0xffff8801bb47df4f. First byte 0xff instead of 0x6b
> [    6.524061] INFO: Slab 0xffffea00060f7b58 objects=22 used=21 fp=0xffff8801bb47df18 flags=0x80000000000000c1
> [    6.524110] INFO: Object 0xffff8801bb47df18 @offset=3864 fp=0x          (null)
> [    6.524111]
> [    6.524170] Bytes b4 0xffff8801bb47df08:  00 00 00 00 00 00 00 00 5a 5a 5a 5a 5a 5a 5a 5a ........ZZZZZZZZ
> [    6.524516]   Object 0xffff8801bb47df18:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [    6.524862]   Object 0xffff8801bb47df28:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [    6.525208]   Object 0xffff8801bb47df38:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> [    6.525556]   Object 0xffff8801bb47df48:  6b 6b 6b 6b ff ff ff ff 6b 6b 6b 6b 6b 6b 6b 6b kkkk<FF><FF><FF><FF>kkkkkkkk

So here the 0xffffffff is pretty obvious.

> and in another boot:
>
> [    6.704786] BUG: unable to handle kernel paging request at ffffffffbc70b058

Here it is less obvious, but it was _probably_ a regular kernel
pointer of the type 0xffff8801bc70b058 before the high bits were
overwritten by a 0xffffffff.

So then sysfs_refresh_inode() follows that pointer, and crashes.

Just a guess, obviously, but it looks rather likely.

                         Linus
