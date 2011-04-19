Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756040Ab1DSVtt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 17:49:49 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:45791 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753432Ab1DSVts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 17:49:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=JYhkWhgk+2GoPUc7XYiYYxXWsuJZwO2px3OQUMcbVhiCidMcnYhgPikLsHhUAuiIDy
         kYIZhVOnozZU9/zYj4PzGyZGvol6QELMR9PVFDuEUnmgLCdlZCo2KTZw/ckOHhC4JSSL
         76hknc4NrraxhN/FQlaC9l4rThej4hpayaZYg=
Date: Tue, 19 Apr 2011 23:47:47 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Kyle Spaans <kspaans@uwaterloo.ca>, linux-kernel@vger.kernel.org,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Ben Skeggs <bskeggs@redhat.com>, airlied@redhat.com,
        dri-devel@lists.freedesktop.org, mjg@redhat.com,
        maciej.rutecki@gmail.com, nouveau@lists.freedesktop.org,
        Nigel Cunningham <lkml@nigelcunningham.com.au>,
        Nick Piggin <npiggin@gmail.com>
Subject: Re: 2.6.39-rc1 nouveau(?) regression (bisected)
Message-ID: <20110419214747.GA2965@joi.lan>
References: <20110414190117.GA3493@joi.lan>
 <20110415061136.GA21979@isilmar-3.linta.de>
 <4DAA1453.5000604@nigelcunningham.com.au>
 <20110416235028.GA6096@taurine.csclub.uwaterloo.ca>
 <20110417151204.GA24519@taurine.csclub.uwaterloo.ca>
 <20110417154557.GA2871@joi.lan>
 <20110417162427.GB25242@taurine.csclub.uwaterloo.ca>
 <20110417164920.GA2626@joi.lan>
 <20110418200204.GA2522@joi.lan>
 <BANLkTi=Oo03CQchHYh4EvEsk+wZy7akLNw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTi=Oo03CQchHYh4EvEsk+wZy7akLNw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 18, 2011 at 01:27:10PM -0700, Linus Torvalds wrote:
> On Mon, Apr 18, 2011 at 1:02 PM, Marcin Slusarz
> <marcin.slusarz@gmail.com> wrote:
> >
> > It's some nasty corruption:
> 
> Looks like something wrote 0xffffffff to free'd memory.
> 
> Enabling DEBUG_PAGEALLOC *might* show where it happens.
> 
> >
> > [    6.523867] =============================================================================
> > [    6.523916] BUG sysfs_dir_cache: Poison overwritten
> > [    6.523949] -----------------------------------------------------------------------------
> > [    6.523950]
> > [    6.524016] INFO: 0xffff8801bb47df4c-0xffff8801bb47df4f. First byte 0xff instead of 0x6b
> > [    6.524061] INFO: Slab 0xffffea00060f7b58 objects=22 used=21 fp=0xffff8801bb47df18 flags=0x80000000000000c1
> > [    6.524110] INFO: Object 0xffff8801bb47df18 @offset=3864 fp=0x          (null)
> > [    6.524111]
> > [    6.524170] Bytes b4 0xffff8801bb47df08:  00 00 00 00 00 00 00 00 5a 5a 5a 5a 5a 5a 5a 5a ........ZZZZZZZZ
> > [    6.524516]   Object 0xffff8801bb47df18:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> > [    6.524862]   Object 0xffff8801bb47df28:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> > [    6.525208]   Object 0xffff8801bb47df38:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> > [    6.525556]   Object 0xffff8801bb47df48:  6b 6b 6b 6b ff ff ff ff 6b 6b 6b 6b 6b 6b 6b 6b kkkk<FF><FF><FF><FF>kkkkkkkk
> 
> So here the 0xffffffff is pretty obvious.
> 
> > and in another boot:
> >
> > [    6.704786] BUG: unable to handle kernel paging request at ffffffffbc70b058
> 
> Here it is less obvious, but it was _probably_ a regular kernel
> pointer of the type 0xffff8801bc70b058 before the high bits were
> overwritten by a 0xffffffff.
> 
> So then sysfs_refresh_inode() follows that pointer, and crashes.
> 
> Just a guess, obviously, but it looks rather likely.

Thanks. It helped a bit.
I'll send two patches in response to this message, one of which fixes this bug.

Marcin

